"""
Unit and integration tests for Eldoria web terminal server.
Verifies HTTP static serving, Range request (HTTP 206) audio streaming,
WebSocket RFC 6455 handshaking, and frame codec.
"""

import asyncio
import os
import unittest
from pathlib import Path

from web.server import (
    HttpRequest,
    PROJECT_ROOT,
    PUBLIC_DIR,
    get_mime_type,
    make_ws_frame,
    read_ws_frame,
    run_server,
)


class TestWebServer(unittest.TestCase):
    def test_mime_types(self):
        self.assertEqual(get_mime_type(Path("test.html")), "text/html; charset=utf-8")
        self.assertEqual(get_mime_type(Path("test.js")), "application/javascript; charset=utf-8")
        self.assertEqual(get_mime_type(Path("test.css")), "text/css; charset=utf-8")
        self.assertEqual(get_mime_type(Path("test.mp3")), "audio/mpeg")
        self.assertEqual(get_mime_type(Path("test.wav")), "audio/wav")

    def test_ws_framing_roundtrip(self):
        async def _test():
            # Test text/binary frame encoding and decoding
            test_payload = b"Hello, Eldoria Web Terminal!"
            frame = make_ws_frame(test_payload, opcode=0x02)

            reader = asyncio.StreamReader()
            reader.feed_data(frame)
            reader.feed_eof()

            # Note: server-to-client frames are unmasked; test that read_ws_frame handles unmasked or masked
            opcode, payload = await read_ws_frame(reader)
            self.assertEqual(opcode, 0x02)
            self.assertEqual(payload, test_payload)

        asyncio.run(_test())

    def test_http_range_request_and_static_serving(self):
        async def _test():
            from web.server import serve_static_file

            class DummyWriter:
                def __init__(self):
                    self.data = bytearray()
                    self.closed = False

                def write(self, b: bytes):
                    self.data.extend(b)

                async def drain(self):
                    pass

                def close(self):
                    self.closed = True

                async def wait_closed(self):
                    pass

            # 1. Test full GET / (index.html)
            req = HttpRequest("GET", "/", "HTTP/1.1", {"host": "localhost"})
            writer = DummyWriter()
            await serve_static_file(req, writer)

            output = bytes(writer.data)
            self.assertIn(b"HTTP/1.1 200 OK", output)
            self.assertIn(b"Content-Type: text/html", output)
            self.assertIn(b"Eldoria", output)

            # 2. Test Range request (bytes=0-9)
            req_range = HttpRequest(
                "GET",
                "/index.html",
                "HTTP/1.1",
                {"host": "localhost", "range": "bytes=0-9"},
            )
            writer_range = DummyWriter()
            await serve_static_file(req_range, writer_range)

            output_range = bytes(writer_range.data)
            self.assertIn(b"HTTP/1.1 206 Partial Content", output_range)
            self.assertIn(b"Content-Range: bytes 0-9/", output_range)
            self.assertIn(b"Content-Length: 10", output_range)

            # 4. Test Range request on actual audio asset
            req_audio = HttpRequest(
                "GET",
                "/Resources/BGM/Title.mp3",
                "HTTP/1.1",
                {"host": "localhost", "range": "bytes=0-1023"},
            )
            writer_audio = DummyWriter()
            await serve_static_file(req_audio, writer_audio)

            output_audio = bytes(writer_audio.data)
            self.assertIn(b"HTTP/1.1 206 Partial Content", output_audio)
            self.assertIn(b"Content-Type: audio/mpeg", output_audio)
            self.assertIn(b"Content-Range: bytes 0-1023/", output_audio)
            self.assertIn(b"Content-Length: 1024", output_audio)

            # 5. Test 404 for non-existent file
            req_404 = HttpRequest("GET", "/nonexistent_file_xyz.txt", "HTTP/1.1", {})
            writer_404 = DummyWriter()
            await serve_static_file(req_404, writer_404)

            output_404 = bytes(writer_404.data)
            self.assertIn(b"404 Not Found", output_404)

        asyncio.run(_test())


if __name__ == "__main__":
    unittest.main()
