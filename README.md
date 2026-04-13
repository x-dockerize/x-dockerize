# x-dockerize

Shared Docker base images used across multiple projects.

## Published Images

| Image | Description |
|-------|-------------|
| `ghcr.io/x-dockerize/php:8.5-fpm` | PHP 8.5 FPM |
| `ghcr.io/x-dockerize/php:8.5-cli` | PHP 8.5 CLI |
| `ghcr.io/x-dockerize/php:8.4-fpm` | PHP 8.4 FPM |
| `ghcr.io/x-dockerize/php:8.4-cli` | PHP 8.4 CLI |
| `ghcr.io/x-dockerize/php:8.3-fpm` | PHP 8.3 FPM |
| `ghcr.io/x-dockerize/php:8.3-cli` | PHP 8.3 CLI |

## Installed PHP Extensions

All PHP images include the following extensions:

**Core:** `pdo_mysql`, `pdo_pgsql`, `bcmath`, `gmp`, `intl`, `soap`, `zip`, `gd` (JPEG, PNG, WebP, FreeType), `pcntl`, `exif`

**System:** `p7zip-full` (`7z` binary via `exec()` / `proc_open()`)

**PECL:** `igbinary`, `msgpack`, `redis` (with igbinary), `memcached` (with igbinary), `mongodb`, `swoole`

## Usage

Use as a base image in your project's `Dockerfile`:

```dockerfile
# PHP-FPM (web server)
FROM ghcr.io/x-dockerize/php:8.5-fpm AS base

# PHP-CLI (worker / scheduler)
FROM ghcr.io/x-dockerize/php:8.5-cli AS worker-base
```

### Runtime UID/GID Adjustment

The base image defines a `deployer` user (UID/GID 1000). To match the host user
on different servers, pass environment variables at runtime:

```yaml
# docker-compose.yml
environment:
  USER_ID: ${UID:-1000}
  GROUP_ID: ${GID:-1000}
```

## Repository Structure

```
x-dockerize/
├── php/
│   ├── entrypoint.sh       # Runtime UID/GID adjustment
│   ├── fpm/
│   │   ├── Dockerfile      # PHP-FPM image (all versions)
│   │   └── 8.6/
│   │       └── Dockerfile  # Version-specific override (if needed)
│   └── cli/
│       ├── Dockerfile      # PHP-CLI image (all versions)
│       └── 8.6/
│           └── Dockerfile  # Version-specific override (if needed)
└── .github/
    └── workflows/
        └── php.yml         # CI: build & push to GHCR
```

## CI/CD

On every push to `master` (or any change under `php/**`), GitHub Actions
automatically builds all image combinations (8.3 / 8.4 / 8.5 × fpm / cli)
for both `linux/amd64` and `linux/arm64` and pushes them to GHCR.

Manual runs are also supported via `workflow_dispatch`.

## Version-Specific Dockerfiles

The workflow first checks for a version-specific Dockerfile before falling back
to the default:

- `php/fpm/Dockerfile` — used for all versions unless overridden
- `php/fpm/8.6/Dockerfile` — used only for PHP 8.6 if it exists

To add a version-specific override, simply create the file — no workflow changes needed.

## Adding a New PHP Version

Add the version to the matrix in `.github/workflows/php.yml`:

```yaml
matrix:
  php_version: ["8.3", "8.4", "8.5", "8.6"]   # ← add here
  variant: ["fpm", "cli"]
```

## License

MIT
