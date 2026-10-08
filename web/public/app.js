/**
 * Eldoria Web Terminal App — Modern Edition
 * Integrates xterm.js, Web Audio API, responsive auto-scaling, and font configuration.
 */

(function () {
    // ── Elements ─────────────────────────────────────────────────────────────
    const terminalContainer = document.getElementById("terminal-container");
    const splashOverlay = document.getElementById("splash-overlay");
    const startBtn = document.getElementById("start-btn");
    
    // Status
    const connectionStatus = document.getElementById("connection-status");
    const statusLabel = document.getElementById("status-label");
    
    // Dock Controls
    const muteBtn = document.getElementById("mute-btn");
    const volumeIconOn = document.getElementById("volume-icon-on");
    const volumeIconOff = document.getElementById("volume-icon-off");
    const volumeSlider = document.getElementById("volume-slider");
    
    const fontBtn = document.getElementById("font-btn");
    const fontDropdown = document.getElementById("font-dropdown");
    const currentFontLabel = document.getElementById("current-font-label");
    const customFontInput = document.getElementById("custom-font-input");
    const customFontApply = document.getElementById("custom-font-apply");
    
    // VFX Shader Controls
    const terminalFrame = document.querySelector(".terminal-frame");
    const vfxBtn = document.getElementById("vfx-btn");
    const vfxDropdown = document.getElementById("vfx-dropdown");
    const currentVfxLabel = document.getElementById("current-vfx-label");
    
    const helpBtn = document.getElementById("help-btn");
    const helpModal = document.getElementById("help-modal");
    const helpClose = document.getElementById("help-close");
    const fullscreenBtn = document.getElementById("fullscreen-btn");

    let term = null;
    let ws = null;
    let isConnected = false;

    // Load persisted font or default to IBM Plex Mono
    const DEFAULT_FONT = "'IBM Plex Mono', 'Menlo', 'Courier New', monospace";
    let activeFontFamily = localStorage.getItem("eldoria_terminal_font") || DEFAULT_FONT;
    let activeFontName = localStorage.getItem("eldoria_terminal_font_name") || "IBM Plex";

    // Load persisted VFX preset (default: none)
    const VFX_PRESET_NAMES = {
        "none": "Pure",
        "crt": "Scanlines",
        "curved-crt": "Arcade",
        "amber": "Amber",
        "green": "Green",
        "gameboy": "Game Boy",
        "bloom": "Bloom",
        "parchment": "Grimoire",
        "oled": "OLED",
        "torchlight": "Torch",
    };
    let activeVfxPreset = localStorage.getItem("eldoria_vfx_preset") || "none";

    // ── Responsive Auto-Scaling Calculation ──────────────────────────────────
    function fitTerminalToViewport() {
        if (!term) return;

        // Viewport dimensions accounting for header (60px) and bottom padding
        const availWidth = window.innerWidth * 0.94;
        const availHeight = (window.innerHeight - 100) * 0.95;

        // Monospace aspect ratio with lineHeight=1.0:
        // Width: 80 cols * (0.60 * fontSize) = 48 * fontSize
        // Height: 40 rows * (1.00 * fontSize) = 40 * fontSize
        const fontByWidth = availWidth / 50;
        const fontByHeight = availHeight / 42;
        const optimalFont = Math.floor(Math.min(fontByWidth, fontByHeight));
        const clampedFont = Math.max(12, Math.min(32, optimalFont));

        if (term.options.fontSize !== clampedFont) {
            term.options.fontSize = clampedFont;
            term.refresh(0, 39);
        }
    }

    // ── Terminal Initialization ──────────────────────────────────────────────
    function initTerminal() {
        term = new Terminal({
            cols: 80,
            rows: 40,
            cursorBlink: true,
            cursorStyle: "block",
            fontSize: 16,
            lineHeight: 1.0,      // Crucial: 1.0 ensures box-drawing characters connect seamlessly!
            letterSpacing: 0,     // 0 ensures continuous horizontal lines
            fontFamily: activeFontFamily,
            theme: {
                background: "#08090d",
                foreground: "#f1f5f9",
                cursor: "#e6c66e",
                cursorAccent: "#08090d",
                selectionBackground: "rgba(230, 198, 110, 0.25)",
                black: "#12151e",
                red: "#f43f5e",
                green: "#10b981",
                yellow: "#eab308",
                blue: "#3b82f6",
                magenta: "#a855f7",
                cyan: "#06b6d4",
                white: "#e2e8f0",
                brightBlack: "#475569",
                brightRed: "#fb7185",
                brightGreen: "#34d399",
                brightYellow: "#fde047",
                brightBlue: "#60a5fa",
                brightMagenta: "#c084fc",
                brightCyan: "#38bdf8",
                brightWhite: "#ffffff",
            },
            allowProposedApi: true,
        });

        term.open(terminalContainer);
        fitTerminalToViewport();

        // Ensure font metrics are re-checked after WebFonts are loaded
        if (document.fonts) {
            document.fonts.ready.then(() => {
                fitTerminalToViewport();
                term.refresh(0, 39);
            });
        }

        // ── In-Band OSC 777 Audio Dispatcher ─────────────────────────────────
        term.parser.registerOscHandler(777, (data) => {
            if (data.startsWith("eldoria-audio;")) {
                const payloadStr = data.slice("eldoria-audio;".length);
                try {
                    const evt = JSON.parse(payloadStr);
                    if (window.audioManager) {
                        window.audioManager.handleEvent(evt);
                    }
                } catch (err) {
                    console.debug("[Terminal] Error parsing audio OSC JSON:", err, payloadStr);
                }
                return true; // Invisible to terminal output canvas
            }
            return false;
        });

        // Send input keystrokes to WebSocket
        term.onData((data) => {
            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send(data);
            }
        });

        window.addEventListener("resize", fitTerminalToViewport);
    }

    // ── Font Selector Logic ──────────────────────────────────────────────────
    function setTerminalFont(fontFamily, displayName) {
        activeFontFamily = fontFamily;
        activeFontName = displayName || "Custom";
        
        localStorage.setItem("eldoria_terminal_font", fontFamily);
        localStorage.setItem("eldoria_terminal_font_name", activeFontName);

        if (term) {
            term.options.fontFamily = fontFamily;
            fitTerminalToViewport();
            term.refresh(0, 39);
        }

        if (currentFontLabel) {
            currentFontLabel.textContent = activeFontName;
        }

        // Update active class on dropdown items
        if (fontDropdown) {
            fontDropdown.querySelectorAll(".dropdown-item").forEach((btn) => {
                const isMatch = btn.dataset.font === fontFamily;
                btn.classList.toggle("active", isMatch);
            });
        }
    }

    // ── Real-Time VFX / Shaders Logic ────────────────────────────────────────
    function setVfxPreset(presetId, displayName) {
        activeVfxPreset = presetId;
        const name = displayName || VFX_PRESET_NAMES[presetId] || "VFX";

        localStorage.setItem("eldoria_vfx_preset", presetId);

        if (terminalFrame) {
            // Remove existing vfx- classes
            const classesToRemove = Array.from(terminalFrame.classList).filter((c) => c.startsWith("vfx-"));
            classesToRemove.forEach((c) => terminalFrame.classList.remove(c));

            if (presetId && presetId !== "none") {
                terminalFrame.classList.add(`vfx-${presetId}`);
            }
        }

        if (currentVfxLabel) {
            currentVfxLabel.textContent = name;
        }

        if (vfxDropdown) {
            vfxDropdown.querySelectorAll(".dropdown-item").forEach((item) => {
                const isMatch = item.dataset.vfx === presetId;
                item.classList.toggle("active", isMatch);
            });
        }
    }

    // ── WebSocket PTY Bridge ─────────────────────────────────────────────────
    function connectWebSocket() {
        const protocol = location.protocol === "https:" ? "wss:" : "ws:";
        const wsUrl = `${protocol}//${location.host}/ws`;

        updateStatus("SYNCING", "connecting");

        ws = new WebSocket(wsUrl);
        ws.binaryType = "arraybuffer";

        ws.onopen = () => {
            isConnected = true;
            updateStatus("LIVE", "connected");
            ws.send(JSON.stringify({ type: "resize", cols: 80, rows: 40 }));
            fitTerminalToViewport();
            term.focus();
        };

        ws.onmessage = (event) => {
            if (typeof event.data === "string") {
                term.write(event.data);
            } else if (event.data instanceof ArrayBuffer) {
                term.write(new Uint8Array(event.data));
            }
        };

        ws.onclose = () => {
            isConnected = false;
            updateStatus("OFFLINE", "disconnected");
            term.writeln("\r\n\x1b[38;5;220m[Connection closed. Press any key to reconnect.]\x1b[0m\r\n");
        };

        ws.onerror = (err) => {
            console.error("WebSocket error:", err);
            updateStatus("OFFLINE", "disconnected");
        };
    }

    function updateStatus(text, stateClass) {
        if (!connectionStatus || !statusLabel) return;
        statusLabel.textContent = text;
        connectionStatus.className = `status-indicator ${stateClass}`;
    }

    // ── Audio Unlock & Game Start ────────────────────────────────────────────
    function startGame() {
        if (window.audioManager) {
            window.audioManager.unlock();
        }

        splashOverlay.classList.add("hidden");
        fitTerminalToViewport();
        term.focus();

        if (!ws || ws.readyState === WebSocket.CLOSED) {
            connectWebSocket();
        }
    }

    // ── UI Controls & Event Listeners ────────────────────────────────────────
    startBtn.addEventListener("click", startGame);

    // Pressing Enter or Space on overlay to start
    window.addEventListener("keydown", function onFirstKey(e) {
        if (!splashOverlay.classList.contains("hidden")) {
            if (e.key === "Enter" || e.key === " " || e.code === "Space") {
                e.preventDefault();
                startGame();
            }
        } else if (!isConnected && ws && ws.readyState === WebSocket.CLOSED) {
            connectWebSocket();
        }
    });

    // Mute Button Toggle
    if (muteBtn) {
        muteBtn.addEventListener("click", () => {
            if (window.audioManager) {
                const muted = window.audioManager.toggleMute();
                volumeIconOn.classList.toggle("hidden", muted);
                volumeIconOff.classList.toggle("hidden", !muted);
                muteBtn.classList.toggle("active", muted);
            }
        });
    }

    // Volume Slider
    if (volumeSlider) {
        volumeSlider.addEventListener("input", (e) => {
            const vol = parseFloat(e.target.value);
            if (window.audioManager) {
                window.audioManager.setMasterVolume(vol);
                if (vol > 0 && window.audioManager._isMuted) {
                    window.audioManager.setMute(false);
                    volumeIconOn.classList.remove("hidden");
                    volumeIconOff.classList.add("hidden");
                    muteBtn.classList.remove("active");
                }
            }
        });
    }

    // Font Dropdown Toggle
    if (fontBtn && fontDropdown) {
        fontBtn.addEventListener("click", (e) => {
            e.stopPropagation();
            fontDropdown.classList.toggle("hidden");
            if (vfxDropdown) vfxDropdown.classList.add("hidden");
        });

        fontDropdown.querySelectorAll(".dropdown-item").forEach((item) => {
            item.addEventListener("click", (e) => {
                e.stopPropagation();
                const font = item.dataset.font;
                const name = item.dataset.name;
                setTerminalFont(font, name);
                fontDropdown.classList.add("hidden");
                if (term) term.focus();
            });
        });

        if (customFontApply && customFontInput) {
            const applyCustomFont = () => {
                const val = customFontInput.value.trim();
                if (val) {
                    const fullFont = `'${val}', monospace`;
                    setTerminalFont(fullFont, val);
                    fontDropdown.classList.add("hidden");
                    if (term) term.focus();
                }
            };
            customFontApply.addEventListener("click", (e) => {
                e.stopPropagation();
                applyCustomFont();
            });
            customFontInput.addEventListener("keydown", (e) => {
                if (e.key === "Enter") {
                    e.preventDefault();
                    applyCustomFont();
                }
            });
        }

        // Close dropdown when clicking outside
        document.addEventListener("click", (e) => {
            if (!fontDropdown.contains(e.target) && e.target !== fontBtn) {
                fontDropdown.classList.add("hidden");
            }
        });
    }

    // Initialize font label
    if (currentFontLabel) {
        currentFontLabel.textContent = activeFontName;
    }

    // VFX Shaders Dropdown Toggle & Selection
    if (vfxBtn && vfxDropdown) {
        vfxBtn.addEventListener("click", (e) => {
            e.stopPropagation();
            vfxDropdown.classList.toggle("hidden");
            if (fontDropdown) fontDropdown.classList.add("hidden");
        });

        vfxDropdown.querySelectorAll(".dropdown-item").forEach((item) => {
            item.addEventListener("click", (e) => {
                e.stopPropagation();
                const vfx = item.dataset.vfx;
                const name = item.dataset.name;
                setVfxPreset(vfx, name);
                vfxDropdown.classList.add("hidden");
                if (term) term.focus();
            });
        });

        // Close dropdown when clicking outside
        document.addEventListener("click", (e) => {
            if (!vfxDropdown.contains(e.target) && e.target !== vfxBtn) {
                vfxDropdown.classList.add("hidden");
            }
        });
    }

    // Help / Keybindings Modal
    if (helpBtn && helpModal && helpClose) {
        helpBtn.addEventListener("click", () => {
            helpModal.classList.toggle("hidden");
        });
        helpClose.addEventListener("click", () => {
            helpModal.classList.add("hidden");
            term.focus();
        });
        helpModal.addEventListener("click", (e) => {
            if (e.target === helpModal) {
                helpModal.classList.add("hidden");
                term.focus();
            }
        });
    }

    // Fullscreen Toggle
    if (fullscreenBtn) {
        fullscreenBtn.addEventListener("click", () => {
            if (!document.fullscreenElement) {
                document.documentElement.requestFullscreen().then(() => {
                    setTimeout(fitTerminalToViewport, 150);
                }).catch(() => {});
            } else {
                document.exitFullscreen().then(() => {
                    setTimeout(fitTerminalToViewport, 150);
                }).catch(() => {});
            }
        });
    }

    // Apply persisted VFX preset
    setVfxPreset(activeVfxPreset, VFX_PRESET_NAMES[activeVfxPreset]);

    // Initialize terminal
    initTerminal();
})();
