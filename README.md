# RisOS 0.00.00

Atomic OS derived from Fedora Kinoite, built with [BlueBuild](https://blue-build.org). Roadmap: [infos.txt](infos.txt).

## Getting started (Phase 0)

1. **Signing keys** (once):
   ```
   cosign generate-key-pair
   ```
   - `cosign.pub` goes at the repo root (committed).
   - `cosign.key` goes in the GitHub secret `SIGNING_SECRET` (Settings → Secrets → Actions). Never commit it.
2. **GitHub repo**: push this folder to `main`. The action builds and publishes `ghcr.io/<user>/risos`.
3. **Test in a VM**: install Fedora Kinoite, then
   ```
   rpm-ostree rebase ostree-unverified-registry:ghcr.io/<user>/risos:latest
   systemctl reboot
   ```
   then switch to the signed image:
   ```
   rpm-ostree rebase ostree-image-signed:docker://ghcr.io/<user>/risos:latest
   ```
4. **Waydroid test** on the target machine (note the GPU) before investing in the rest.

## Layout

| Path | Role |
|---|---|
| `recipes/recipe.yml` | Image description (base, packages, Flatpaks) |
| `files/system/` | Files copied as-is into the image (`/usr/share/risos/`, color schemes, wallpapers...) |
| `files/scripts/` | Scripts run during the build |
| `style/` | Mockups, logo SVGs and design tokens (palette, Figtree font) |
| `.github/workflows/build.yml` | Daily build on GitHub Actions |

## Fast iteration in the VM

Image builds take 7 to 10 minutes. For the SDDM theme, color schemes, wallpapers and /etc config, skip the build:

```
curl -fsSL https://raw.githubusercontent.com/Aorux01/RisOS/main/tools/dev-sync.sh | bash -s -- --restart-sddm
```

It pulls the latest `files/system` from GitHub into a temporary overlay (gone at next reboot). It does not cover Plymouth or packages: those need a build.
