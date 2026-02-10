#!/usr/bin/env python3
"""Minimal AURA core service skeleton.

Phase-0 goals:
- Provide a local health endpoint.
- Surface capability registry contents.
- Stay dependency-free for fast bootstrap.
"""

from __future__ import annotations

import json
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]
CAPABILITIES_DIR = REPO_ROOT / "aura" / "libs" / "capability-registry" / "capabilities"
HOST = "127.0.0.1"
PORT = 8088


def load_capabilities() -> list[dict]:
    capabilities = []
    for file_path in sorted(CAPABILITIES_DIR.glob("*.json")):
        with file_path.open("r", encoding="utf-8") as f:
            capabilities.append(json.load(f))
    return capabilities


class AuraCoreHandler(BaseHTTPRequestHandler):
    def _send_json(self, status: int, payload: dict) -> None:
        response = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(response)))
        self.end_headers()
        self.wfile.write(response)

    def log_message(self, format: str, *args) -> None:  # noqa: A003
        return

    def do_GET(self) -> None:  # noqa: N802
        if self.path == "/health":
            self._send_json(
                200,
                {
                    "service": "aura-core",
                    "status": "ok",
                    "mode": "idle",
                },
            )
            return

        if self.path == "/capabilities":
            self._send_json(
                200,
                {
                    "count": len(load_capabilities()),
                    "capabilities": load_capabilities(),
                },
            )
            return

        self._send_json(404, {"error": "not_found", "path": self.path})


def main() -> None:
    server = HTTPServer((HOST, PORT), AuraCoreHandler)
    print(f"aura-core listening on http://{HOST}:{PORT}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
