#!/bin/bash
echo -e "\n=== Gaming Setup ==="
sudo pacman -S --needed --noconfirm \
  steam \
  gamemode lib32-gamemode \
  umu-launcher

sudo usermod -aG gamemode $USER

if ! grep -q "intel_pstate=disable" /etc/default/grub; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Intel CPU Gaming Fix (12th/13th/14th gen)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "PROBLEM:"
  echo "  Intel's pstate driver locks CPU in powersave mode"
  echo "  when launching Proton/Wine games, causing severe"
  echo "  performance issues and stuttering."
  echo ""
  echo "SOLUTION:"
  echo "  Disable intel_pstate and use acpi-cpufreq driver"
  echo ""
  echo "STEPS:"
  echo "  1. sudo nvim /etc/default/grub"
  echo "  2. Add to GRUB_CMDLINE_LINUX_DEFAULT:"
  echo "       intel_pstate=disable"
  echo "     Example:"
  echo "       GRUB_CMDLINE_LINUX_DEFAULT=\"quiet intel_pstate=disable\""
  echo "  3. sudo grub-mkconfig -o /boot/grub/grub.cfg"
  echo "  4. Reboot"
  echo ""
  echo "VERIFY:"
  echo "  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver"
  echo "  Should output: acpi-cpufreq"
  echo ""
  echo "USAGE:"
  echo "  Steam launch options: gamemoderun %command%"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  read -p "Apply Intel CPU fix now? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&intel_pstate=disable /' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo "✓ GRUB configured. REBOOT REQUIRED."
  fi
fi
