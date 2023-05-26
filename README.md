# `molecule-qemu`

Molecule QEMU driver for testing Ansible roles.

## Usage

```bash
pip install molecule-qemu
```

Install QEMU and CDRTools on macOS:

```bash
brew install qemu cdrtools
```

Supported platforms:
* MacOS 13.x (aaarch64)

Support guest OS:
* Ubuntu 20.04 LTS (aarch64)
* Ubuntu 20.04 LTS (x86_64)
* Debian 11 (x86_64)

Support of other platforms and guest OS is possible, but not tested.

# Examples

## Example scenario
```bash
molecule init scenario scenario_name -d molecule-qemu
```

## Example `molecule.yml`
```yaml
---
dependency:
  name: galaxy
driver:
  name: molecule-qemu
platforms:
  - name: ubuntu-1
    image: file:///Users/andrey/Downloads/focal-server-cloudimg-arm64.img
    image_arch: aarch64
    ssh_port: 10022
    ssh_user: ubuntu
  - name: ubuntu-2
    image: file:///Users/andrey/Downloads/focal-server-cloudimg-amd64.img
    image_arch: x86_64  # default
    ssh_port: 10023
    ssh_user: ubuntu
  - name: debian-1
    image: file:///Users/andrey/Downloads/debian-11-generic-amd64.qcow2
    image_arch: x86_64  # default
    ssh_port: 10024
    ssh_user: debian

provisioner:
  name: ansible
verifier:
  name: ansible
```

# Cloud Images

* [Ubuntu](https://cloud-images.ubuntu.com/)
* [Debian](https://cloud.debian.org/images/cloud/)

# Reference

* [Ansible](https://www.ansible.com/)
* [Molecule](https://molecule.readthedocs.io/en/latest/)
* [QEMU](https://www.qemu.org/)
