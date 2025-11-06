# NVIDIA Drivers on Fedora 43 with Wayland

A comprehensive guide for installing and configuring NVIDIA drivers on Fedora 43 with Wayland support, particularly for legacy NVIDIA GPUs.

## Problem Overview

When installing NVIDIA drivers on Fedora 43, several issues can occur:
- GNOME UI fails to start after driver installation
- Nouveau is blacklisted, leaving no working graphics driver
- NVIDIA kernel modules fail to load properly
- GDM (GNOME Display Manager) crashes with segmentation faults

## Prerequisites

- Fedora 43 installed
- NVIDIA GPU (this guide focuses on legacy GPUs like GTX 680)
- Internet connection for package downloads

## Installation Guide

### 1. Initial Cleanup and Preparation

If you have a broken NVIDIA installation:

```bash
# Remove broken NVIDIA packages
sudo dnf remove *nvidia*

# Temporarily remove nouveau blacklist to regain GUI access
sudo rm /etc/modprobe.d/blacklist-nouveau.conf

# Reboot with nouveau driver
sudo reboot
```

### 2. Enable RPM Fusion Repositories

```bash
# Enable RPM Fusion free and nonfree repositories
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### 3. Install Development Tools

```bash
# Install kernel development tools required for module building
sudo dnf install kernel-devel kernel-headers gcc make dkms
```

### 4. Install NVIDIA Drivers

For legacy GPUs (GTX 680 and similar):

```bash
# Install NVIDIA 470xx legacy drivers
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs

# Build kernel modules (crucial step)
sudo akmods --force

# Verify module was built successfully
modinfo -F version nvidia
```

### 5. Configure Kernel Modules

```bash
# Create nouveau blacklist
echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf

# Enable nvidia-drm kernel mode setting (required for Wayland)
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia-modeset.conf

# Rebuild initramfs
sudo dracut --force
```

### 6. Install Wayland Support

```bash
# Install EGL Wayland support
sudo dnf install egl-wayland
```

### 7. Configure Environment Variables

Add these lines to `/etc/environment`:

```bash
# NVIDIA Wayland environment variables
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
```

### 8. Display Manager Configuration

#### Option A: Use GDM (Recommended for GNOME)

```bash
# Ensure Wayland is enabled in GDM
sudo nano /etc/gdm/custom.conf
# Make sure WaylandEnable=false is commented out or removed

# Update GDM and GNOME packages (fixes crash issues)
sudo dnf update gdm gnome-shell
```

#### Option B: Use LightDM (Temporary workaround if GDM crashes)

```bash
# Install LightDM as temporary replacement
sudo dnf install lightdm lightdm-gtk

# Switch to LightDM
sudo systemctl disable gdm
sudo systemctl enable lightdm
sudo reboot
```

### 9. Final Steps

```bash
# Rebuild initramfs one more time
sudo dracut --force

# Reboot the system
sudo reboot
```

## Verification

After rebooting, verify the installation:

```bash
# Check if NVIDIA driver is loaded
nvidia-smi

# Check if Wayland is running
echo $XDG_SESSION_TYPE

# Verify kernel modules
lsmod | grep nvidia
```

Expected output should show:
- `nvidia-smi` displaying driver version and GPU information
- `XDG_SESSION_TYPE` showing `wayland`
- NVIDIA modules loaded in kernel

## Troubleshooting

### GDM Crashes
If GDM continues to crash:
1. Switch to LightDM temporarily using Option B above
2. Update all system packages: `sudo dnf update`
3. Try switching back to GDM after updates

### Kernel Module Issues
If NVIDIA modules fail to load:
1. Rebuild modules: `sudo akmods --force`
2. Check module build logs: `journalctl -xe | grep akmod`
3. Ensure kernel headers match running kernel: `rpm -q kernel-devel`

### Wayland Not Working
If Wayland doesn't start:
1. Verify environment variables in `/etc/environment`
2. Check nvidia-drm modeset is enabled
3. Ensure EGL Wayland is installed

## Key Success Factors

1. **Correct Driver Version**: Legacy GPUs (GTX 680) require 470xx drivers, not current ones
2. **Proper Module Building**: Run `akmods --force` and wait for completion
3. **nvidia-drm Modeset**: Essential for Wayland support
4. **Environment Variables**: Required for NVIDIA + Wayland compatibility
5. **Updated Packages**: Keep GDM and GNOME updated to avoid crashes

## Final Working Configuration

- **OS**: Fedora 43
- **Desktop**: GNOME on Wayland
- **GPU**: NVIDIA GeForce GTX 680 (or similar legacy GPU)
- **Driver**: 470.256.02 (legacy)
- **Display Manager**: GDM
- **Hardware Acceleration**: Fully functional
- **Monitoring**: nvidia-smi working

## Important Notes

- Always use legacy drivers (470xx) for older NVIDIA GPUs
- NVIDIA + Wayland requires specific kernel parameters and environment variables
- GDM provides better Wayland support than LightDM for GNOME
- Keep system packages updated to avoid display manager crashes

---

*This guide was created based on successful installation experience with Fedora 43 and NVIDIA GTX 680 on Wayland.*