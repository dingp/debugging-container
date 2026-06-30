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
podman-hpc build -f container/debian-12-vnc-novnc.Dockerfile -t ghcr.io/dingp/debian:12-vnc-novnc .
```

Run it with the helper script:

```sh
scripts/run-vnc-novnc.sh
```

The helper generates a one-time VNC password, chooses a random localhost noVNC port, and does not expose the VNC server port by default. It prints the noVNC URL and password before starting the container.

See [RUN_VNC_NOVNC.md](RUN_VNC_NOVNC.md) for full usage details.

The helper can be configured with environment variables:

- `IMAGE`, default `ghcr.io/dingp/debian:12-vnc-novnc`
- `HOST_NOVNC_ADDR`, default `127.0.0.1`
- `HOST_NOVNC_PORT`, default random
- `JUPYTER_PROXY_BASE_URL`, default `https://jupyter.nersc.gov`
- `JUPYTER_PROXY_HOST`, default `jupyter.nersc.gov`
- `JUPYTER_PROXY_HTTPS_PORT`, default `443`
- `JUPYTER_PROXY_PREFIX`, default to `JUPYTERHUB_SERVICE_PREFIX`
- `JUPYTER_PROXY_USER`, default to `USER`
- `JUPYTER_PROXY_SERVER`, optional Jupyter server name, such as `muller-login-node-base` or `perlmutter-login-node`
- `NOVNC_PORT`, default `6080` inside the container
- `EXPOSE_VNC`, default `0`; set to `1` to publish the VNC server port
- `VNC_HOST_ADDR`, default `127.0.0.1`
- `VNC_HOST_PORT`, default to `VNC_PORT`
- `VNC_PORT`, default `5901` inside the container
- `VNC_PASSWORD_LENGTH`, default `8`

Runtime settings are controlled with environment variables:

- `VNC_DISPLAY`, default `1`
- `VNC_PORT`, default `5901`
- `VNC_GEOMETRY`, default `1280x800`
- `VNC_DEPTH`, default `24`
- `VNC_LOCALHOST`, default `no`
- `VNC_SECURITY_TYPES`, default `VncAuth`; set to `None` to disable VNC auth
- `VNC_PASSWORD`, default `changeme`
- `VNC_PASSWORD_FILE`, default `/root/.vnc/passwd`
- `VNC_PASSWORD_PLAIN_FILE`, optional plaintext password file used to generate `VNC_PASSWORD_FILE`
- `VNC_XSTARTUP`, default `/root/.vnc/xstartup`
- `VNC_DESKTOP_CMD`, default `fvwm3`
- `VNC_EXTRA_ARGS`, appended to `vncserver`
- `NOVNC_LISTEN`, default `0.0.0.0`
- `NOVNC_PORT`, default `6080`
- `NOVNC_WEB`, default `/usr/share/novnc`
- `NOVNC_VNC_HOST`, default `127.0.0.1`
- `NOVNC_VNC_PORT`, default to `VNC_PORT`
- `NOVNC_EXTRA_ARGS`, appended to `websockify`
