#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-localhost/debugging-container-vnc-novnc:latest}"
CONTAINER_NOVNC_PORT="${NOVNC_PORT:-6080}"
HOST_NOVNC_ADDR="${HOST_NOVNC_ADDR:-127.0.0.1}"
HOST_NOVNC_PORT="${HOST_NOVNC_PORT:-}"
VNC_PORT="${VNC_PORT:-5901}"
VNC_HOST_ADDR="${VNC_HOST_ADDR:-127.0.0.1}"
VNC_HOST_PORT="${VNC_HOST_PORT:-$VNC_PORT}"
EXPOSE_VNC="${EXPOSE_VNC:-0}"
VNC_PASSWORD_LENGTH="${VNC_PASSWORD_LENGTH:-8}"

random_password() {
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -base64 "${VNC_PASSWORD_LENGTH}" | tr -d '\n' | cut -c "1-${VNC_PASSWORD_LENGTH}"
        return
    fi

    if command -v python3 >/dev/null 2>&1; then
        python3 - "${VNC_PASSWORD_LENGTH}" <<'PY'
import secrets
import string
import sys

length = int(sys.argv[1])
alphabet = string.ascii_letters + string.digits
print("".join(secrets.choice(alphabet) for _ in range(length)), end="")
PY
        return
    fi

    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "${VNC_PASSWORD_LENGTH}"
}

random_port() {
    if command -v shuf >/dev/null 2>&1; then
        shuf -i 49152-60999 -n 1
        return
    fi

    if command -v python3 >/dev/null 2>&1; then
        python3 - <<'PY'
import secrets

print(secrets.randbelow(11848) + 49152)
PY
        return
    fi

    printf '%s\n' "$((49152 + RANDOM % 11848))"
}

if [[ -z "${HOST_NOVNC_PORT}" ]]; then
    HOST_NOVNC_PORT="$(random_port)"
fi

tmpdir="$(mktemp -d)"
password_file="${tmpdir}/vnc-password"
cleanup() {
    rm -rf "${tmpdir}"
}
trap cleanup EXIT

vnc_password="$(random_password)"
printf '%s\n' "${vnc_password}" > "${password_file}"
chmod 0600 "${password_file}"

run_args=(
    run
    --rm
    -p "${HOST_NOVNC_ADDR}:${HOST_NOVNC_PORT}:${CONTAINER_NOVNC_PORT}"
    -v "${password_file}:/run/secrets/vnc-password:ro"
    -e "VNC_PASSWORD_PLAIN_FILE=/run/secrets/vnc-password"
    -e "NOVNC_PORT=${CONTAINER_NOVNC_PORT}"
    -e "VNC_PORT=${VNC_PORT}"
)

case "${EXPOSE_VNC,,}" in
    1|true|yes|y|on)
        run_args+=( -p "${VNC_HOST_ADDR}:${VNC_HOST_PORT}:${VNC_PORT}" )
        ;;
esac

printf 'Image: %s\n' "${IMAGE}"
printf 'noVNC: http://%s:%s/vnc.html\n' "${HOST_NOVNC_ADDR}" "${HOST_NOVNC_PORT}"
printf 'One-time VNC password: %s\n' "${vnc_password}"
if [[ "${EXPOSE_VNC,,}" =~ ^(1|true|yes|y|on)$ ]]; then
    printf 'VNC: %s:%s\n' "${VNC_HOST_ADDR}" "${VNC_HOST_PORT}"
else
    printf 'VNC server port is not exposed on the host.\n'
fi
printf '\n'

exec podman-hpc "${run_args[@]}" "${IMAGE}"
