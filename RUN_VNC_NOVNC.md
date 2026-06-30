# Using `run-vnc-novnc.sh`

`scripts/run-vnc-novnc.sh` starts the Debian 12 VNC/noVNC desktop image with safer defaults for interactive use on NERSC systems, especially from Jupyter.

## What It Does

The helper script:

- Starts `ghcr.io/dingp/debian:12-vnc-novnc` with `podman-hpc`.
- Generates a one-time VNC password at runtime.
- Stores the password in a temporary `0600` file and mounts that file read-only into the container.
- Avoids putting the VNC password in shell history or in the `podman-hpc run` command line.
- Chooses a random host port for noVNC when `HOST_NOVNC_PORT` is not set.
- Publishes only the noVNC port by default.
- Does not expose the raw VNC server port unless `EXPOSE_VNC=1` is set.
- Prints the noVNC access URL and one-time VNC password before starting the container.
- Prints a Jupyter Server Proxy URL when it can determine the Jupyter user/server path.

Inside the container, the VNC server listens on `VNC_PORT` and noVNC listens on `NOVNC_PORT`. On the host, only noVNC is exposed by default.

## Basic Usage

From the repository root:

```sh
scripts/run-vnc-novnc.sh
```

The script prints output like:

```text
Image: ghcr.io/dingp/debian:12-vnc-novnc
noVNC: https://jupyter.nersc.gov/user/your-user-name/perlmutter-login-node/proxy/49967/vnc.html?port=443&host=jupyter.nersc.gov&path=user%2Fyour-user-name%2Fperlmutter-login-node%2Fproxy%2F49967
One-time VNC password: AbC123xY
VNC server port is not exposed on the host.
```

Open the printed `noVNC` URL in a browser and enter the printed one-time VNC password.

## Jupyter Server Proxy URLs

When run inside a Jupyter session, the script uses `JUPYTERHUB_SERVICE_PREFIX` to build the proxied noVNC URL. This is the preferred path because JupyterHub already provides the username and server name.

For example, if the service prefix is:

```text
/user/your-user-name/muller-login-node-base/
```

and the selected noVNC host port is `49967`, the printed URL is:

```text
https://jupyter.nersc.gov/user/your-user-name/muller-login-node-base/proxy/49967/vnc.html?port=443&host=jupyter.nersc.gov&path=user%2Fyour-user-name%2Fmuller-login-node-base%2Fproxy%2F49967
```

If the helper is not running inside Jupyter, provide the server path explicitly:

```sh
JUPYTER_PROXY_USER="${USER}" \
JUPYTER_PROXY_SERVER=perlmutter-login-node \
scripts/run-vnc-novnc.sh
```

The server name is the Jupyter server type, such as `muller-login-node-base` or `perlmutter-login-node`.

## Configuration

Common settings:

| Variable | Default | Purpose |
| --- | --- | --- |
| `IMAGE` | `ghcr.io/dingp/debian:12-vnc-novnc` | Container image to run. |
| `HOST_NOVNC_ADDR` | `127.0.0.1` | Host address used for the noVNC port publication. |
| `HOST_NOVNC_PORT` | random | Host port for noVNC. |
| `NOVNC_PORT` | `6080` | noVNC port inside the container. |
| `VNC_PORT` | `5901` | VNC server port inside the container. |
| `EXPOSE_VNC` | `0` | Set to `1` to also publish the raw VNC server port. |
| `VNC_PASSWORD_LENGTH` | `8` | Length of the generated one-time VNC password. |

Jupyter URL settings:

| Variable | Default | Purpose |
| --- | --- | --- |
| `JUPYTER_PROXY_BASE_URL` | `https://jupyter.nersc.gov` | Public Jupyter base URL. |
| `JUPYTER_PROXY_HOST` | `jupyter.nersc.gov` | Host query parameter passed to noVNC. |
| `JUPYTER_PROXY_HTTPS_PORT` | `443` | Port query parameter passed to noVNC. |
| `JUPYTER_PROXY_PREFIX` | `JUPYTERHUB_SERVICE_PREFIX` | Full Jupyter user/server prefix. |
| `JUPYTER_PROXY_USER` | `USER` | Username used when `JUPYTER_PROXY_PREFIX` is absent. |
| `JUPYTER_PROXY_SERVER` | unset | Jupyter server name used when `JUPYTER_PROXY_PREFIX` is absent. |

Raw VNC exposure settings:

| Variable | Default | Purpose |
| --- | --- | --- |
| `VNC_HOST_ADDR` | `127.0.0.1` | Host address for raw VNC publication when `EXPOSE_VNC=1`. |
| `VNC_HOST_PORT` | `VNC_PORT` | Host port for raw VNC publication when `EXPOSE_VNC=1`. |

## Examples

Use a fixed noVNC host port:

```sh
HOST_NOVNC_PORT=49967 scripts/run-vnc-novnc.sh
```

Use a locally built image:

```sh
IMAGE=localhost/debugging-container-vnc-novnc:latest scripts/run-vnc-novnc.sh
```

Run outside Jupyter but still print a Jupyter proxy URL:

```sh
JUPYTER_PROXY_USER="${USER}" \
JUPYTER_PROXY_SERVER=muller-login-node-base \
scripts/run-vnc-novnc.sh
```

Expose the raw VNC server port in addition to noVNC:

```sh
EXPOSE_VNC=1 scripts/run-vnc-novnc.sh
```

Use a custom raw VNC host port:

```sh
EXPOSE_VNC=1 VNC_HOST_PORT=5905 scripts/run-vnc-novnc.sh
```

## Security Notes

The helper avoids passing the VNC password as an environment variable or command-line argument. It writes the generated password to a temporary file, mounts that file read-only into the container, and deletes the temporary directory when the helper exits.

By default, raw VNC is not exposed on the host. Prefer the printed noVNC URL unless a separate VNC client is required.
