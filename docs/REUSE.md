<!--
SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
SPDX-License-Identifier: AGPL-3.0-only
-->

# REUSE Compliance Guide

This project follows the [REUSE Specification](https://reuse.software/) to standardize license and copyright information across all files.

## License

The project is licensed under **AGPL-3.0-only**. See [`LICENSE`](../LICENSE) (in [`LICENSES/AGPL-3.0-only.txt`](../LICENSES/AGPL-3.0-only.txt)) for the full license text.

## REUSE Configuration

- [`REUSE.toml`](../REUSE.toml) — central configuration that bulk-annotates files unable to carry inline SPDX headers
- [`LICENSES/`](../LICENSES/) — directory containing the full text of every license used in the project
- Individual source files carry inline SPDX headers at the top

### When to use `REUSE.toml` vs. inline headers

| Approach                    | When to use                                                                          | Examples                                        |
| --------------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------- |
| **Inline SPDX header**      | Source files you create and edit                                                     | `.dart`, `.md`, `.sh`, `.yaml`, `.toml`, `.ps1` |
| **`REUSE.toml` annotation** | Auto-generated files, lock files, or files where inline comments would break tooling | `pubspec.lock`, `.vscode/*.json`, `.metadata`   |

If a file is auto-generated (e.g., by Flutter or Dart tooling), add it to [`REUSE.toml`](../REUSE.toml) instead of inserting an inline header — the header would be overwritten on regeneration.

## Adding a New File

Every new file must include an SPDX header identifying its copyright and license. Use [`reuse annotate`](https://reuse.readthedocs.io/en/latest/manpage.html#annotate) to add headers:

```bash
# Single file
uv run reuse annotate --license AGPL-3.0-only --copyright "The Anytag Frontend Authors" lib/screens/new_screen.dart

# Multiple files with a glob pattern
uv run reuse annotate --license AGPL-3.0-only --copyright "The Anytag Frontend Authors" lib/screens/*.dart

# Dry-run to preview changes first
uv run reuse annotate --license AGPL-3.0-only --copyright "The Anytag Frontend Authors" --dry-run lib/new_file.dart
```

This automatically inserts the correct SPDX header using the appropriate comment syntax for each file type. Alternatively, you can add headers manually:

| File type             | Comment style | Header                                                              |
| --------------------- | ------------- | ------------------------------------------------------------------- |
| Dart (`.dart`)        | `//`          | `// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors`       |
| Markdown (`.md`)      | `<!-- -->`    | `<!-- SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors -->` |
| Shell (`.sh`)         | `#`           | `# SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors`        |
| YAML (`.yml`/`.yaml`) | `#`           | `# SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors`        |
| TOML (`.toml`)        | `#`           | `# SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors`        |
| PowerShell (`.ps1`)   | `#`           | `# SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors`        |

Each header must be followed by:

```text
// SPDX-License-Identifier: AGPL-3.0-only
```

## Checking Compliance Locally

Before committing, verify all files are properly annotated:

```bash
# REUSE is installed as a dev dependency — run via uv
uv run reuse lint

# Expected output: "All files are compliant!"
```

## CI Enforcement

The CI pipeline (`.github/workflows/reuse.yml`) automatically runs `reuse lint` on every push and pull request. A non-compliant status will fail the build, so ensure all new files include proper SPDX headers before pushing.

## See Also

- [Development Guide](./DEVELOPMENT.md) — Development workflow
- [Troubleshooting](./TROUBLESHOOTING.md) — CI/CD workflow overview
