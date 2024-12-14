# Container images for debugging k8s workloads

This repository contains some basic images with common tools for debugging k8s workloads. The images are based on popular Linux distros (`Fedora`, `AlmaLinux`, `Debian`, `Alpine`).

They are using base these distros' official images on Dockerhub as base images. Tools added on top of the images are:
- `wget, curl, tar`
- `nmap, traceroute`
- `htop, procps`
- `gdb`
