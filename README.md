# Container images for debugging k8s workloads

This repository contains some basic images with common tools for debugging k8s workloads. The images are based on popular Linux distros (`Fedora`, `AlmaLinux`, `Debian`, `Alpine`).

They are using base these distros' official images on Dockerhub as base images. Tools added on top of the images are:
- `wget, curl, tar, which`
- `nmap, traceroute`
- `htop, procps`
- `gdb`
- `which`
- `git, vim`

## VNC/noVNC desktop image

Build the Debian 12 desktop image with:

```sh
podman-hpc build -f container/debian-12-vnc-novnc.Dockerfile -t debugging-container-vnc-novnc .
```

Run it with:

```sh
podman-hpc run --rm \
  -p 6080:6080 \
  -p 5901:5901 \
  -e VNC_PASSWORD='change-this' \
  debugging-container-vnc-novnc
```

Then open `http://localhost:6080/vnc.html` for noVNC, or connect a VNC client to port `5901`.

Runtime settings are controlled with environment variables:

- `VNC_DISPLAY`, default `1`
- `VNC_PORT`, default `5901`
- `VNC_GEOMETRY`, default `1280x800`
- `VNC_DEPTH`, default `24`
- `VNC_LOCALHOST`, default `no`
- `VNC_SECURITY_TYPES`, default `VncAuth`; set to `None` to disable VNC auth
- `VNC_PASSWORD`, default `changeme`
- `VNC_PASSWORD_FILE`, default `/root/.vnc/passwd`
- `VNC_XSTARTUP`, default `/root/.vnc/xstartup`
- `VNC_DESKTOP_CMD`, default `fvwm3`
- `VNC_EXTRA_ARGS`, appended to `vncserver`
- `NOVNC_LISTEN`, default `0.0.0.0`
- `NOVNC_PORT`, default `6080`
- `NOVNC_WEB`, default `/usr/share/novnc`
- `NOVNC_VNC_HOST`, default `127.0.0.1`
- `NOVNC_VNC_PORT`, default to `VNC_PORT`
- `NOVNC_EXTRA_ARGS`, appended to `websockify`
