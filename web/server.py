"""
Web Terminal Server for Eldoria.
Provides a pure Python zero-dependency async HTTP and WebSocket server.
Pipes PTY terminal sessions to web clients and streams static assets (audio, HTML, JS, CSS).
"""

from __future__ import annotations

import argparse
import asyncio
import base64
import fcntl
import hashlib
import json
import logging
import mimetypes
import os
import pty
from pathlib import Path
import re
import struct
import subprocess
import sys
import termios
import urllib.parse
from typing import Optional, Tuple

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("eldoria.webserver")

PROJECT_ROOT = Path(__file__).resolve().parent.parent
PUBLIC_DIR = PROJECT_ROOT / "web" / "public"
RESOURCES_DIR = PROJECT_ROOT / "Resources"

WS_GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"


# ─────────────────────────────────────────────────────────────────────────────
# WebSocket RFC 6455 Framing Helpers
# ─────────────────────────────────────────────────────────────────────────────

def make_ws_frame(data: bytes, opcode: int = 0x02) -> bytes:
    """
    Constructs an unmasked WebSocket frame from server to client.
    Opcodes: 0x01 (text), 0x02 (binary), 0x08 (close), 0x09 (ping), 0x0A (pong).
    """
    header = bytearray([0x80 | (opcode & 0x0F)])
    length = len(data)
    if length <= 125:
        header.append(length)
    elif length <= 65535:
        header.append(126)
        header.extend(struct.pack("!H", length))
    else:
        header.append(127)
        header.extend(struct.pack("!Q", length))
    return bytes(header) + data


async def read_ws_frame(reader: asyncio.StreamReader) -> Tuple[int, bytes]:
    """
    Reads a masked WebSocket frame from client, de-masks, and returns (opcode, payload).
    """
    b1_b2 = await reader.readexactly(2)
    opcode = b1_b2[0] & 0x0F
    masked = bool(b1_b2[1] & 0x80)
    payload_len = b1_b2[1] & 0x7F

    if payload_len == 126:
        (payload_len,) = struct.unpack("!H", await reader.readexactly(2))
    elif payload_len == 127:
        (payload_len,) = struct.unpack("!Q", await reader.readexactly(8))

    mask_key = await reader.readexactly(4) if masked else None
    payload = await reader.readexactly(payload_len)

    if masked and mask_key:
        unmasked = bytearray(payload)
        for i in range(len(unmasked)):
            unmasked[i] ^= mask_key[i % 4]
        payload = bytes(unmasked)

    return opcode, payload


# ─────────────────────────────────────────────────────────────────────────────
# HTTP Request Parsing & Response
# ─────────────────────────────────────────────────────────────────────────────

class HttpRequest:
    def __init__(self, method: str, path: str, version: str, headers: dict[str, str]):
        self.method = method.upper()
        self.path = path
        self.version = version
        self.headers = headers

    @classmethod
    async def parse(cls, reader: asyncio.StreamReader) -> Optional[HttpRequest]:
        line = await reader.readline()
        if not line:
            return None
        line_str = line.decode("latin1").strip()
        parts = line_str.split()
        if len(parts) < 3:
            return None
        method, path, version = parts[0], parts[1], parts[2]

        headers: dict[str, str] = {}
        while True:
            hline = await reader.readline()
            if not hline or hline in (b"\r\n", b"\n"):
                break
            h_str = hline.decode("latin1").strip()
            if ":" in h_str:
                k, v = h_str.split(":", 1)
                headers[k.strip().lower()] = v.strip()

        return cls(method, path, version, headers)


# ─────────────────────────────────────────────────────────────────────────────
# Static Asset Delivery with HTTP 206 Partial Content (Range Support)
# ─────────────────────────────────────────────────────────────────────────────

MIME_TYPES = {
    ".html": "text/html; charset=utf-8",
    ".js": "application/javascript; charset=utf-8",
    ".css": "text/css; charset=utf-8",
    ".json": "application/json; charset=utf-8",
    ".mp3": "audio/mpeg",
    ".wav": "audio/wav",
    ".ogg": "audio/ogg",
    ".flac": "audio/flac",
    ".png": "image/png",
    ".jpg": "image/jpeg",
    ".jpeg": "image/jpeg",
    ".svg": "image/svg+xml",
    ".ico": "image/x-icon",
}


def get_mime_type(path: Path) -> str:
    ext = path.suffix.lower()
    if ext in MIME_TYPES:
        return MIME_TYPES[ext]
    guessed, _ = mimetypes.guess_type(str(path))
    return guessed or "application/octet-stream"


async def serve_static_file(req: HttpRequest, writer: asyncio.StreamWriter) -> None:
    # URL decode path and strip query string
    req_path = urllib.parse.unquote(req.path.split("?")[0])

    # Route paths
    if req_path in ("/", ""):
        target = PUBLIC_DIR / "index.html"
    elif req_path.startswith("/Resources/"):
        rel = req_path[len("/Resources/") :]
        target = (RESOURCES_DIR / rel).resolve()
        # Security check: must remain inside RESOURCES_DIR
        if not str(target).startswith(str(RESOURCES_DIR.resolve())):
            await send_http_error(writer, 403, "Forbidden")
            return
    else:
        rel = req_path.lstrip("/")
        target = (PUBLIC_DIR / rel).resolve()
        # Security check: must remain inside PUBLIC_DIR
        if not str(target).startswith(str(PUBLIC_DIR.resolve())):
            await send_http_error(writer, 403, "Forbidden")
            return

    if not target.is_file():
        await send_http_error(writer, 404, "Not Found")
        return

    try:
        total_size = target.stat().st_size
        mime = get_mime_type(target)

        # Check Range header (critical for audio streaming / seeking)
        range_header = req.headers.get("range")
        if range_header and range_header.startswith("bytes="):
            match = re.search(r"bytes=(\d+)-(\d*)", range_header)
            if match:
                start = int(match.group(1))
                end = int(match.group(2)) if match.group(2) else total_size - 1
                start = max(0, min(start, total_size - 1))
                end = max(start, min(end, total_size - 1))
                content_length = end - start + 1

                headers = [
                    "HTTP/1.1 206 Partial Content",
                    f"Content-Type: {mime}",
                    f"Content-Range: bytes {start}-{end}/{total_size}",
                    f"Content-Length: {content_length}",
                    "Accept-Ranges: bytes",
                    "Access-Control-Allow-Origin: *",
                    "Cache-Control: public, max-age=3600",
                    "Connection: close",
                    "\r\n",
                ]
                writer.write("\r\n".join(headers).encode("latin1"))
                await writer.drain()

                if req.method != "HEAD":
                    with open(target, "rb") as f:
                        f.seek(start)
                        remaining = content_length
                        while remaining > 0:
                            chunk_size = min(65536, remaining)
                            chunk = f.read(chunk_size)
                            if not chunk:
                                break
                            writer.write(chunk)
                            await writer.drain()
                            remaining -= len(chunk)
                return

        # Full file 200 OK
        headers = [
            "HTTP/1.1 200 OK",
            f"Content-Type: {mime}",
            f"Content-Length: {total_size}",
            "Accept-Ranges: bytes",
            "Access-Control-Allow-Origin: *",
            "Cache-Control: public, max-age=3600",
            "Connection: close",
            "\r\n",
        ]
        writer.write("\r\n".join(headers).encode("latin1"))
        await writer.drain()

        if req.method != "HEAD":
            with open(target, "rb") as f:
                while True:
                    chunk = f.read(65536)
                    if not chunk:
                        break
                    writer.write(chunk)
                    await writer.drain()

    except Exception as exc:
        logger.error("Error serving static file %s: %s", target, exc)


async def send_http_error(writer: asyncio.StreamWriter, code: int, message: str) -> None:
    body = f"<html><body><h1>{code} {message}</h1></body></html>".encode("utf-8")
    resp = (
        f"HTTP/1.1 {code} {message}\r\n"
        f"Content-Type: text/html; charset=utf-8\r\n"
        f"Content-Length: {len(body)}\r\n"
        f"Connection: close\r\n\r\n"
    ).encode("latin1") + body
    writer.write(resp)
    await writer.drain()


# ─────────────────────────────────────────────────────────────────────────────
# PTY Process Spawner & WebSocket Tunnel
# ─────────────────────────────────────────────────────────────────────────────

async def handle_websocket_session(
    reader: asyncio.StreamReader,
    writer: asyncio.StreamWriter,
    req: HttpRequest,
    command: list[str],
) -> None:
    """Performs WS handshake, launches PTY child process, and pipes I/O bidirectionally."""
    # Complete WS handshake
    key = req.headers["sec-websocket-key"]
    accept_val = base64.b64encode(hashlib.sha1((key + WS_GUID).encode()).digest()).decode()

    hs_response = (
        "HTTP/1.1 101 Switching Protocols\r\n"
        "Upgrade: websocket\r\n"
        "Connection: Upgrade\r\n"
        f"Sec-WebSocket-Accept: {accept_val}\r\n\r\n"
    ).encode("latin1")
    writer.write(hs_response)
    await writer.drain()

    logger.info("WebSocket handshake successful. Launching Eldoria PTY session...")

    # Open PTY
    master_fd, slave_fd = pty.openpty()

    # Initial terminal size: 80 columns x 40 rows
    initial_cols, initial_rows = 80, 40
    fcntl.ioctl(slave_fd, termios.TIOCSWINSZ, struct.pack("HHHH", initial_rows, initial_cols, 0, 0))
    fcntl.ioctl(master_fd, termios.TIOCSWINSZ, struct.pack("HHHH", initial_rows, initial_cols, 0, 0))

    # Environment for Eldoria PTY
    env = dict(os.environ)
    env["ELDORIA_WEB_AUDIO"] = "1"
    env["TERM"] = "xterm-256color"
    env["COLORTERM"] = "truecolor"
    env["LINES"] = str(initial_rows)
    env["COLUMNS"] = str(initial_cols)
    env["PYTHONUNBUFFERED"] = "1"

    proc = subprocess.Popen(
        command,
        stdin=slave_fd,
        stdout=slave_fd,
        stderr=slave_fd,
        env=env,
        preexec_fn=os.setsid,
        close_fds=True,
        cwd=str(PROJECT_ROOT),
    )
    os.close(slave_fd)
    os.set_blocking(master_fd, False)

    loop = asyncio.get_running_loop()
    pty_queue: asyncio.Queue[Optional[bytes]] = asyncio.Queue()

    def on_pty_readable() -> None:
        try:
            data = os.read(master_fd, 8192)
            if data:
                pty_queue.put_nowait(data)
            else:
                pty_queue.put_nowait(None)
        except (BlockingIOError, InterruptedError):
            pass
        except Exception:
            pty_queue.put_nowait(None)

    loop.add_reader(master_fd, on_pty_readable)

    # Task 1: Pump PTY output -> WebSocket client (Binary frame opcode=0x02)
    async def pty_to_ws() -> None:
        try:
            while True:
                chunk = await pty_queue.get()
                if chunk is None:
                    break
                writer.write(make_ws_frame(chunk, opcode=0x02))
                await writer.drain()
        except (asyncio.CancelledError, ConnectionResetError, BrokenPipeError):
            pass
        except Exception as exc:
            logger.debug("PTY to WS error: %s", exc)

    # Task 2: Pump WebSocket client input -> PTY stdin
    async def ws_to_pty() -> None:
        try:
            while True:
                opcode, payload = await read_ws_frame(reader)
                if opcode == 0x08:  # Connection close
                    break
                elif opcode == 0x09:  # Ping
                    writer.write(make_ws_frame(payload, opcode=0x0A))
                    await writer.drain()
                elif opcode in (0x01, 0x02):  # Text or Binary
                    # Check for resize JSON control message
                    if payload.startswith(b'{"type":"resize"') or payload.startswith(b'{"type": "resize"'):
                        try:
                            msg = json.loads(payload.decode("utf-8"))
                            c = int(msg.get("cols", 80))
                            r = int(msg.get("rows", 40))
                            fcntl.ioctl(master_fd, termios.TIOCSWINSZ, struct.pack("HHHH", r, c, 0, 0))
                            continue
                        except Exception:
                            pass
                    # Regular user keystrokes / ANSI sequences
                    os.write(master_fd, payload)
        except (asyncio.CancelledError, asyncio.IncompleteReadError, ConnectionResetError):
            pass
        except Exception as exc:
            logger.debug("WS to PTY error: %s", exc)

    pty_task = asyncio.create_task(pty_to_ws())
    ws_task = asyncio.create_task(ws_to_pty())

    # Wait until either direction terminates
    done, pending = await asyncio.wait(
        [pty_task, ws_task],
        return_when=asyncio.FIRST_COMPLETED,
    )

    for task in pending:
        task.cancel()

    # Clean up PTY and process
    try:
        loop.remove_reader(master_fd)
    except Exception:
        pass

    try:
        os.close(master_fd)
    except Exception:
        pass

    if proc.poll() is None:
        try:
            proc.terminate()
            try:
                proc.wait(timeout=1.0)
            except subprocess.TimeoutExpired:
                proc.kill()
        except Exception:
            pass

    logger.info("PTY session terminated.")


# ─────────────────────────────────────────────────────────────────────────────
# Connection Dispatcher
# ─────────────────────────────────────────────────────────────────────────────

async def dispatch_client(
    reader: asyncio.StreamReader,
    writer: asyncio.StreamWriter,
    command: list[str],
) -> None:
    try:
        req = await HttpRequest.parse(reader)
        if not req:
            writer.close()
            await writer.wait_closed()
            return

        is_ws = (
            req.headers.get("upgrade", "").lower() == "websocket"
            and "sec-websocket-key" in req.headers
        )

        if is_ws and req.path.startswith("/ws"):
            await handle_websocket_session(reader, writer, req, command)
        else:
            await serve_static_file(req, writer)

    except Exception as exc:
        logger.error("Unhandled client error: %s", exc)
    finally:
        try:
            writer.close()
            await writer.wait_closed()
        except Exception:
            pass


async def run_server(host: str, port: int, command: list[str]) -> None:
    server = await asyncio.start_server(
        lambda r, w: dispatch_client(r, w, command),
        host,
        port,
    )
    logger.info("=" * 60)
    logger.info("  Eldoria Web Terminal Server is LIVE!")
    logger.info("  Play URL: http://%s:%d", host if host != "0.0.0.0" else "localhost", port)
    logger.info("  Game Command: %s", " ".join(command))
    logger.info("=" * 60)

    async with server:
        await server.serve_forever()


def main() -> None:
    parser = argparse.ArgumentParser(description="Eldoria Web Terminal Server")
    parser.add_argument("--host", default="127.0.0.1", help="Host interface to bind (default: 127.0.0.1)")
    parser.add_argument("--port", type=int, default=8080, help="Port to listen on (default: 8080)")
    parser.add_argument(
        "--cmd",
        nargs="*",
        default=None,
        help="Command to run in PTY (default: python main.py or compiled binary)",
    )
    parser.add_argument(
        "--binary",
        action="store_true",
        help="Run compiled binary (dist/eldoria) instead of Python script",
    )

    args = parser.parse_args()

    if args.cmd:
        command = args.cmd
    elif args.binary:
        bin_path = PROJECT_ROOT / "dist" / "eldoria"
        if not bin_path.is_file():
            print(f"Error: Compiled binary not found at {bin_path}. Run without --binary or compile first.")
            sys.exit(1)
        command = [str(bin_path)]
    else:
        # Check for virtual environment python
        venv_python = PROJECT_ROOT / ".venv" / "bin" / "python"
        py_exec = str(venv_python) if venv_python.is_file() else sys.executable
        command = [py_exec, str(PROJECT_ROOT / "main.py")]

    try:
        asyncio.run(run_server(args.host, args.port, command))
    except KeyboardInterrupt:
        logger.info("Server stopped by user.")


if __name__ == "__main__":
    main()
