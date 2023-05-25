# `molecule-qemu`

Molecule QEMU driver for testing Ansible roles.

## Usage

```bash
pip install molecule-qemu
```

## Dependencies

```bash
brew install qemu cdrtools
```

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
  - name: instance-1
    vm_image: ~/Downloads/debian-11-generic-amd64.qcow2
    vm_ssh_port: 10022
  - name: instance-2
    vm_image: ~/Downloads/debian-11-generic-amd64.qcow2
    vm_ssh_port: 10023

provisioner:
  name: ansible
verifier:
  name: ansible
```

# Cloud Images

* [Ubuntu](https://cloud-images.ubuntu.com/)
* [Debian](https://cdimage.debian.org/cdimage/openstack/current/)

# Reference

* [Ansible](https://www.ansible.com/)
* [Molecule](https://molecule.readthedocs.io/en/latest/)
* [QEMU](https://www.qemu.org/)
