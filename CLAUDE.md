# CLAUDE.md — x-dockerize

This file contains what Claude Code needs to know about this repository.

## Purpose

Produces shared PHP Docker base images and publishes them to GHCR for reuse
across multiple projects.

Projects consume these images via `FROM ghcr.io/x-dockerize/php:8.5-fpm`,
avoiding repeated extension and user configuration in every project.

## Image Naming

Format: `ghcr.io/x-dockerize/php:<PHP_VERSION>-<VARIANT>`

Examples:
- `ghcr.io/x-dockerize/php:8.5-fpm`
- `ghcr.io/x-dockerize/php:8.5-cli`
- `ghcr.io/x-dockerize/php:8.4-fpm`
- `ghcr.io/x-dockerize/php:8.4-cli`

## Design Decisions

- **entrypoint.sh in base image**: Runtime UID/GID adjustment runs automatically in all derived images.
- **deployer user in base**: UID/GID 1000, standardized across all projects.
- **Composer not in base**: Each project chooses its own Composer version.
  Projects use `COPY --from=composer:latest /usr/bin/composer /usr/bin/composer`.
- **fpm vs cli split**: FPM for web servers, CLI for workers and schedulers.
  The CLI image does not add the `www-data` group.
- **Multi-platform**: Every image is built for both `linux/amd64` and `linux/arm64`.

## Version-Specific Dockerfiles

The workflow resolves the Dockerfile path with a fallback mechanism:

1. `php/<variant>/<php_version>/Dockerfile` — version-specific (takes precedence)
2. `php/<variant>/Dockerfile` — default (used when no override exists)

Create a version-specific file only when a PHP version diverges from the default.

## Development

When adding a new PHP version:
1. Update `matrix.php_version` in `.github/workflows/php.yml`
2. Push to `master` — CI builds automatically

When adding a new extension:
- Update both `php/fpm/Dockerfile` and `php/cli/Dockerfile`
- Add any required system packages to the `apt-get install` line
