/**
 * Eldoria Web Audio Engine — Buffer Architecture
 * High-performance Web Audio API engine using decoded AudioBuffers.
 * Eliminates HTMLMediaElement pipeline exhaustion and ensures zero-latency,
 * gapless, leak-free BGM streaming and polyphonic SFX across endless battles.
 */

class WebAudioManager {
    constructor() {
        this.ctx = null;
        this.masterGain = null;
        this.musicGain = null;
        this.sfxGain = null;

        // Volumes
        this._masterVolume = 1.0;
        this._musicVolume = 1.0;
        this._sfxVolume = 1.0;
        this._isMuted = false;

        // BGM state: { source, gain, track, volume, startTime }
        this.currentBgm = null;
        this.bgmBuffers = new Map(); // trackName -> AudioBuffer
        this._loadingBgm = new Map(); // trackName -> Promise<AudioBuffer>

        // SFX state & cache
        this.sfxBuffers = new Map(); // soundName -> AudioBuffer
        this.activeSfx = new Map();   // handleId -> { source, gain }
        this._nextHandleId = 1;

        this.isUnlocked = false;
        this._pendingActions = [];
    }

    /**
     * Initializes the Web Audio Context and audio graph upon first user gesture.
     */
    unlock() {
        if (!this.ctx) {
            const AudioContextClass = window.AudioContext || window.webkitAudioContext;
            this.ctx = new AudioContextClass();

            this.masterGain = this.ctx.createGain();
            this.musicGain = this.ctx.createGain();
            this.sfxGain = this.ctx.createGain();

            this.musicGain.connect(this.masterGain);
            this.sfxGain.connect(this.masterGain);
            this.masterGain.connect(this.ctx.destination);

            this.masterGain.gain.setValueAtTime(this._isMuted ? 0 : this._masterVolume, this.ctx.currentTime);
            this.musicGain.gain.setValueAtTime(this._musicVolume, this.ctx.currentTime);
            this.sfxGain.gain.setValueAtTime(this._sfxVolume, this.ctx.currentTime);

            // Preload common BGM assets in background to ensure 0ms latency during battles
            this._preloadCommonBgm();
        }

        if (this.ctx.state === "suspended") {
            this.ctx.resume();
        }

        this.isUnlocked = true;

        // Execute any actions queued before audio context was unlocked
        while (this._pendingActions.length > 0) {
            const fn = this._pendingActions.shift();
            try {
                fn();
            } catch (err) {
                console.warn("[Audio] Error running queued audio action:", err);
            }
        }
    }

    _preloadCommonBgm() {
        const tracks = [
            "Title",
            "World Map Smol",
            "Battle Theme",
            "Battle Won",
            "Battle Lost",
            "Boss Battle Theme",
            "Cave Theme",
            "Town Theme",
        ];
        for (const t of tracks) {
            this._loadBgmBuffer(t).catch(() => {});
        }
    }

    /**
     * Dispatches in-band OSC 777 action events received from the terminal stream.
     */
    handleEvent(event) {
        if (!event || !event.action) return;

        const execute = () => {
            switch (event.action) {
                case "play_bgm":
                    this.playBgm(event.track, event.loop !== false, event.volume ?? 1.0);
                    break;
                case "stop_bgm":
                    this.stopBgm();
                    break;
                case "pause_bgm":
                    this.pauseBgm();
                    break;
                case "resume_bgm":
                    this.resumeBgm();
                    break;
                case "fade_to_bgm":
                    this.fadeToBgm(event.track, event.duration ?? 1.5, event.loop !== false, event.volume ?? 1.0);
                    break;
                case "fade_out_bgm":
                    this.fadeOutBgm(event.duration ?? 1.5);
                    break;
                case "play_sfx":
                    this.playSfx(event.sound, event.loop === true, event.volume ?? 1.0);
                    break;
                case "stop_sfx":
                    this.stopSfx(event.handle_id);
                    break;
                case "pause_sfx":
                    this.pauseSfx(event.handle_id);
                    break;
                case "resume_sfx":
                    this.resumeSfx(event.handle_id);
                    break;
                case "set_master_volume":
                    this.setMasterVolume(event.volume);
                    break;
                case "set_music_volume":
                    this.setMusicVolume(event.volume);
                    break;
                case "set_sfx_volume":
                    this.setSfxVolume(event.volume);
                    break;
                case "set_mute":
                    this.setMute(event.muted);
                    break;
                default:
                    console.debug("[Audio] Unhandled audio action:", event.action);
            }
        };

        if (!this.isUnlocked) {
            this._pendingActions.push(execute);
        } else {
            execute();
        }
    }

    // ── Background Music (BGM) ────────────────────────────────────────────────

    _resolveBgmUrl(track) {
        if (!track) return null;
        if (track.endsWith(".mp3") || track.endsWith(".wav") || track.endsWith(".ogg")) {
            return `/Resources/BGM/${encodeURI(track)}`;
        }
        return `/Resources/BGM/${encodeURIComponent(track)}.mp3`;
    }

    async _loadBgmBuffer(track) {
        if (!track) return null;
        if (this.bgmBuffers.has(track)) {
            return this.bgmBuffers.get(track);
        }
        if (this._loadingBgm.has(track)) {
            return this._loadingBgm.get(track);
        }

        const url = this._resolveBgmUrl(track);
        if (!url) return null;

        const loadPromise = (async () => {
            try {
                let res = await fetch(url);
                if (!res.ok && url.endsWith(".mp3")) {
                    // Fallback to .wav if .mp3 not found
                    const wavUrl = url.replace(/\.mp3$/, ".wav");
                    res = await fetch(wavUrl);
                }
                if (!res.ok) {
                    console.warn("[Audio] BGM track not found:", track, url);
                    return null;
                }
                const arr = await res.arrayBuffer();
                const buf = await this.ctx.decodeAudioData(arr);
                this.bgmBuffers.set(track, buf);
                return buf;
            } catch (err) {
                console.warn("[Audio] Could not decode BGM track:", track, err);
                return null;
            } finally {
                this._loadingBgm.delete(track);
            }
        })();

        this._loadingBgm.set(track, loadPromise);
        return loadPromise;
    }

    async playBgm(track, loop = true, volume = 1.0) {
        if (!track || !this.ctx) return;

        // If the same track is already playing, just update volume
        if (this.currentBgm && this.currentBgm.track === track) {
            this.currentBgm.volume = volume;
            this.currentBgm.gain.gain.setValueAtTime(volume, this.ctx.currentTime);
            return;
        }

        const buffer = await this._loadBgmBuffer(track);
        if (!buffer || !this.ctx) return;

        // Stop current track immediately
        this._stopCurrentBgmImmediate();

        const now = this.ctx.currentTime;
        const source = this.ctx.createBufferSource();
        source.buffer = buffer;
        source.loop = loop;

        const gain = this.ctx.createGain();
        gain.gain.setValueAtTime(volume, now);

        source.connect(gain);
        gain.connect(this.musicGain);
        source.start(0);

        this.currentBgm = { source, gain, track, volume };
    }

    async fadeToBgm(track, duration = 1.5, loop = true, volume = 1.0) {
        if (!track || !this.ctx) return;

        // If same track is already playing, smoothly adjust volume
        if (this.currentBgm && this.currentBgm.track === track) {
            const now = this.ctx.currentTime;
            this.currentBgm.volume = volume;
            this.currentBgm.gain.gain.cancelScheduledValues(now);
            this.currentBgm.gain.gain.setValueAtTime(this.currentBgm.gain.gain.value, now);
            this.currentBgm.gain.gain.linearRampToValueAtTime(volume, now + duration);
            return;
        }

        const buffer = await this._loadBgmBuffer(track);
        if (!buffer || !this.ctx) return;

        const now = this.ctx.currentTime;

        // 1. Smoothly fade out current track
        if (this.currentBgm) {
            const oldBgm = this.currentBgm;
            this.currentBgm = null;

            oldBgm.gain.gain.cancelScheduledValues(now);
            oldBgm.gain.gain.setValueAtTime(oldBgm.gain.gain.value, now);
            oldBgm.gain.gain.linearRampToValueAtTime(0.0001, now + duration);

            setTimeout(() => {
                try {
                    oldBgm.source.stop();
                    oldBgm.source.disconnect();
                    oldBgm.gain.disconnect();
                } catch (e) {}
            }, (duration + 0.1) * 1000);
        }

        // 2. Start new track with smooth fade in
        const source = this.ctx.createBufferSource();
        source.buffer = buffer;
        source.loop = loop;

        const gain = this.ctx.createGain();
        gain.gain.setValueAtTime(0.0001, now);
        gain.gain.linearRampToValueAtTime(volume, now + duration);

        source.connect(gain);
        gain.connect(this.musicGain);
        source.start(0);

        this.currentBgm = { source, gain, track, volume };
    }

    fadeOutBgm(duration = 1.5) {
        if (!this.currentBgm || !this.ctx) return;

        const now = this.ctx.currentTime;
        const oldBgm = this.currentBgm;
        this.currentBgm = null;

        oldBgm.gain.gain.cancelScheduledValues(now);
        oldBgm.gain.gain.setValueAtTime(oldBgm.gain.gain.value, now);
        oldBgm.gain.gain.linearRampToValueAtTime(0.0001, now + duration);

        setTimeout(() => {
            try {
                oldBgm.source.stop();
                oldBgm.source.disconnect();
                oldBgm.gain.disconnect();
            } catch (e) {}
        }, (duration + 0.1) * 1000);
    }

    stopBgm() {
        this._stopCurrentBgmImmediate();
    }

    pauseBgm() {
        if (this.currentBgm) {
            this.fadeOutBgm(0.2);
        }
    }

    resumeBgm() {
        // Resume handled cleanly via playBgm/fadeToBgm
    }

    _stopCurrentBgmImmediate() {
        if (this.currentBgm) {
            try {
                this.currentBgm.source.stop();
                this.currentBgm.source.disconnect();
                this.currentBgm.gain.disconnect();
            } catch (e) {}
            this.currentBgm = null;
        }
    }

    // ── Sound Effects (SFX) ───────────────────────────────────────────────────

    _resolveSfxUrl(sound) {
        if (!sound) return null;
        if (sound.endsWith(".mp3") || sound.endsWith(".wav") || sound.endsWith(".ogg")) {
            return `/Resources/SFX/${encodeURI(sound)}`;
        }
        return `/Resources/SFX/${encodeURIComponent(sound)}.mp3`;
    }

    async _loadSfxBuffer(url) {
        if (this.sfxBuffers.has(url)) {
            return this.sfxBuffers.get(url);
        }

        try {
            let res = await fetch(url);
            if (!res.ok && url.endsWith(".mp3")) {
                const wavUrl = url.replace(/\.mp3$/, ".wav");
                res = await fetch(wavUrl);
            }
            if (!res.ok) return null;
            const arr = await res.arrayBuffer();
            const buf = await this.ctx.decodeAudioData(arr);
            this.sfxBuffers.set(url, buf);
            return buf;
        } catch (err) {
            console.debug("[Audio] Could not load SFX buffer for", url, err);
            return null;
        }
    }

    async playSfx(sound, loop = false, volume = 1.0) {
        if (!sound || !this.ctx) return null;
        const url = this._resolveSfxUrl(sound);
        if (!url) return null;

        const buffer = await this._loadSfxBuffer(url);
        if (!buffer || !this.ctx) return null;

        const handleId = this._nextHandleId++;
        const source = this.ctx.createBufferSource();
        source.buffer = buffer;
        source.loop = loop;

        const gainNode = this.ctx.createGain();
        gainNode.gain.setValueAtTime(volume, this.ctx.currentTime);

        source.connect(gainNode);
        gainNode.connect(this.sfxGain);

        source.onended = () => {
            this.activeSfx.delete(handleId);
            try {
                source.disconnect();
                gainNode.disconnect();
            } catch (e) {}
        };

        source.start(0);
        this.activeSfx.set(handleId, { source, gainNode, sound });
        return handleId;
    }

    stopSfx(handleId) {
        if (handleId === null || handleId === undefined) {
            for (const [id, sfx] of this.activeSfx.entries()) {
                try {
                    sfx.source.stop();
                } catch (e) {}
            }
            this.activeSfx.clear();
        } else if (this.activeSfx.has(handleId)) {
            const sfx = this.activeSfx.get(handleId);
            try {
                sfx.source.stop();
            } catch (e) {}
            this.activeSfx.delete(handleId);
        }
    }

    pauseSfx(handleId) {
        this.stopSfx(handleId);
    }

    resumeSfx(handleId) {
        // No-op for one-shot buffer sources
    }

    // ── Volume & Mute Controls ────────────────────────────────────────────────

    setMasterVolume(volume) {
        this._masterVolume = Math.max(0, Math.min(1, volume));
        if (this.masterGain && this.ctx && !this._isMuted) {
            this.masterGain.gain.setValueAtTime(this._masterVolume, this.ctx.currentTime);
        }
    }

    setMusicVolume(volume) {
        this._musicVolume = Math.max(0, Math.min(1, volume));
        if (this.musicGain && this.ctx) {
            this.musicGain.gain.setValueAtTime(this._musicVolume, this.ctx.currentTime);
        }
    }

    setSfxVolume(volume) {
        this._sfxVolume = Math.max(0, Math.min(1, volume));
        if (this.sfxGain && this.ctx) {
            this.sfxGain.gain.setValueAtTime(this._sfxVolume, this.ctx.currentTime);
        }
    }

    setMute(muted) {
        this._isMuted = !!muted;
        if (this.masterGain && this.ctx) {
            const target = this._isMuted ? 0 : this._masterVolume;
            this.masterGain.gain.setValueAtTime(target, this.ctx.currentTime);
        }
    }

    toggleMute() {
        this.setMute(!this._isMuted);
        return this._isMuted;
    }
}

// Global singleton instance
window.audioManager = new WebAudioManager();
