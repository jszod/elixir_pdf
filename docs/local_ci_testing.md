# Local CI Testing Guide

This guide explains how to set up and run Gitub Actions CI workflow using aa Linux VM. This is helpful for testing the CI workflow locally.

## Quick Reference

**Run the workflow locally**
```
act -j build --platform ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```

## Overview
We use [act](https://github.com/nektos/act) and Docker the run the Github actions workflow locally. This process mimics the production CI environment as closely as possible, including dependency installation and environment setup.

## Prerequisites
You will need

* A Mac or Linux machine
* UTM installed to run a virtual machine (if running on a Mac)
* An Ubuntu 24.04 LTS VM configured in UTM
* The following software installed on the VM:
  * Docker
  * act (brew install act or manual installation)
  * Optional but recommended Colima if running on MacOS directly

## VM and Environment Setup
1. Create and Configure a VM
   * Create an Ubuntu 24.04 LTS VM using UTM
   * Allocate enough CPU & RAM (4GB RAM, 2 Cores minimum)
2. Install Dependencies inside VM
   
   **Install Docker**
   ```
   sudo apt update
   sudo apt install -y docker.io git curl build-essential
   ```

   **Add your user to the docker group (so you don't to use sudo)** 
   ```
   sudo usermod -aG docker $USER
   newgrp docker
   ```
   **Install act**
   ```
   curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
   ```

   # Running the Workflow

   Checkout the project out to your desired local drive
   ```
   cd ~/src/elixir/elixir_pdf
   git pull origin main
   ```

   **Run the workflow**
   ```
   act -j build --platform ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
   ```
   **Note:**
   This uses an Unbuntu 22.04 image which closely matches the current unbuntu-latest runner used by Github Actions. If you want to test against a newer OS version you can replace them image:

   ```
   act -j build --platform ubuntu-latest=ghcr.io/catthehacker/ubuntu:24.04
   ```

   # Troubleshooting

   If you encounter issues running the CI workflow locally, here are some common issues and solutions:

## Troubleshooting

If you encounter issues while running the CI workflow locally, here are some common problems and solutions:

### Docker Permission Errors

**Error:**
```
permission denied while trying to connect to the Docker daemon socket
```

**Solution:**

Ensure your user is added to the `docker` group so you can run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

You may need to log out and log back in for the permission change to take effect.

### DNS or Networking Issues

If Docker is unable to pull images from registries like ghcr.io, your VM may not have working DNS configured.

You can fix this by updating your Netplan configuration:

```
network:
  version: 2
  ethernets:
    enp0s1:
      dhcp4: true
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

Apply the configuration:

```
sudo netplan apply
```

If you see warnings about **Netplan permissions being too open**, fix them with:

```
sudo chmod 600 /etc/netplan/*.yaml
```

### Act Hangs at "Cleaning build artifacts"

**Symptom:**

```
Mix requires the Hex package manager to fetch dependencies
```

**Cause:**

This happens when Hex is not installed yet in the Docker container used by Act.

**Solution:**

Make sure the Reset and prepare Elixir environment step in the workflow properly installs Hex.
You can also manually verify by running:

```
mix local.hex --force
```

inside the container.

### Debugging Other Errors

If you encounter unexpected errors during the local CI run:
* Make sure you are in the project root directory when running act.
* Check that Docker is running:

```
sudo systemctl status docker
```

* Run the workflow with debug logging enabled:

```
ACT_LOG_LEVEL=debug act -j build --platform ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```

This will give you more verbose output to help troubleshoot.