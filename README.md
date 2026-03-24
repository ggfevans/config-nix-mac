# config-nix-mac

NixOS configuration for **nix-mac** — a 2011 Mac Mini (5,1) running NixOS 25.11 "Xantusia".

## Hardware

- **CPU:** Intel Core i5-2415M (Sandy Bridge) — 2c/4t @ 2.3–2.9 GHz
- **RAM:** 8 GB DDR3
- **GPU:** Intel HD Graphics 3000
- **SSD:** Kingston SUV400S37 240GB (btrfs, zstd)
- **HDD:** Seagate ST2000LM015 2TB (btrfs, zstd, mounted at /data)
- **Wi-Fi:** Broadcom BCM4331 (broadcom_sta)

## Key Features

- Flake-based NixOS 25.11 config
- Btrfs with subvolumes (@, @home, @nix, @log) and zstd compression
- SSH hardened on port 42042 (key-only)
- Tailscale VPN
- Powertop auto-tune for power management
- Weekly btrfs auto-scrub
- Auto-upgrade from this repo at 04:00 daily

## Usage
```bash
# Rebuild from local config
sudo nixos-rebuild switch --flake /etc/nixos#nix-mac

# Garbage collect old generations
sudo nix-collect-garbage -d
```

## Related

- [config-nix-charlie](https://github.com/ggfevans/config-nix-charlie) — NixOS on 2018 MacBook Pro (T2)
