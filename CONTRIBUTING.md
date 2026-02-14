# Contributing to Art Roulette

## Commit conventions

This project uses [cocogitto](https://docs.cocogitto.io/) for conventional commits and automated versioning. All commits should follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
feat: add new roulette mode
fix: correct folder tree selection logic
docs: update contributing guide
```

## Workflows

### Releasing a new version

1. Make sure all changes are committed and pushed to `main`.
2. Run `cog bump --auto` (or `--patch`, `--minor`, `--major` for explicit control).
   - This updates `config/version` in `project.godot` automatically via a pre-bump hook.
   - Creates a bump commit and a version tag (e.g., `0.2.0`).
3. Push the commit and tag: `git push --follow-tags`.
4. The `Release` GitHub Actions workflow triggers automatically on the new tag.
5. The workflow exports the project for Windows, macOS, and Linux, then creates a GitHub release with all three zip files attached.

### Admin requirements

- **No manual approval is needed.** The release workflow runs automatically and publishes without intervention.
- **GitHub Actions permissions:** The workflow uses the default `GITHUB_TOKEN` with `contents: write` permission. This is enabled by default for repos — no secrets or tokens need to be configured.
- **Godot version updates:** If the project upgrades Godot, update the `GODOT_VERSION` env var in `.github/workflows/release.yml` to match.
- **macOS builds are unsigned.** Users will need to right-click and select "Open" the first time to bypass Gatekeeper. Signing requires an Apple Developer certificate and is not currently configured.
