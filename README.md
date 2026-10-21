# RisOS 0.00.00

OS atomique dérivé de Fedora Kinoite, construit avec [BlueBuild](https://blue-build.org). Feuille de route : [infos.txt](infos.txt).

## Mise en route (Phase 0)

1. **Clés de signature** (une seule fois) :
   ```
   cosign generate-key-pair
   ```
   - `cosign.pub` → à la racine du dépôt (commit).
   - `cosign.key` → secret GitHub `SIGNING_SECRET` (Settings → Secrets → Actions). Ne jamais commiter.
2. **Dépôt GitHub** : pousser ce dossier sur `main`. L'action construit et publie `ghcr.io/<utilisateur>/risos`.
3. **Tester dans une VM** : installer Fedora Kinoite, puis
   ```
   rpm-ostree rebase ostree-unverified-registry:ghcr.io/<utilisateur>/risos:latest
   systemctl reboot
   ```
   puis, pour passer à l'image signée :
   ```
   rpm-ostree rebase ostree-image-signed:docker://ghcr.io/<utilisateur>/risos:latest
   ```
4. **Test Waydroid** sur la machine cible (noter le GPU) avant d'investir dans la suite.

## Structure

| Chemin | Rôle |
|---|---|
| `recipes/recipe.yml` | Description de l'image (base, paquets, Flatpaks) |
| `files/system/` | Fichiers copiés tels quels dans l'image (`/usr/share/risos/`, thème, fonds...) |
| `scripts/` | Scripts exécutés pendant la construction |
| `style/` | Maquettes et jetons de design (palette, police Figtree) |
| `.github/workflows/build.yml` | Construction quotidienne sur GitHub Actions |
