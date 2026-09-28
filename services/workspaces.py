#!/usr/bin/env python3
import socket
import os
import sys
import json
import glob

def get_hypr_socket():
    xdg_runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")
    his = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    
    if his:
        sock = f"{xdg_runtime}/hypr/{his}/.socket2.sock"
        if os.path.exists(sock):
            return sock
            
    matches = glob.glob(f"{xdg_runtime}/hypr/*/.socket2.sock")
    if matches:
        return matches[0]
    return None

def main():
    sock_path = get_hypr_socket()
    if not sock_path:
        sys.exit(1)

    try:
        s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        s.connect(sock_path)
        while True:
            data = s.recv(1024).decode('utf-8', errors='ignore')
            if not data:
                break
            for line in data.split('\n'):
                if line.startswith("workspace>>"):
                    ws = line.split(">>")[1]
                    print(json.dumps({"event": "workspace", "active": ws}), flush=True)
    except Exception:
        sys.exit(1)

if __name__ == "__main__":
    main()