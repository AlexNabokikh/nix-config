# Mac Deployment

This page covers macOS hosts managed by nix-darwin and Home Manager.

## Hosts

The active Darwin outputs live in `flake.nix`:

- `neo`
- `macvm-fs`

The matching Home Manager outputs are:

- `fs@neo`
- `fs@macvm-fs`

## First-Time Setup

Install Nix, clone this repository, and make sure flakes are available.

```sh
git clone <repo-url>
cd infra-nix-home-machines
```

The recipes expect Doppler to be available. Log in before switching if the host
does not already have a working Doppler setup.

```sh
doppler me
```

Apply the system configuration:

```sh
just darwin-switch
```

Apply the user configuration:

```sh
just home-switch
```

On a host whose system hostname does not match the flake output, use the explicit
recipes:

```sh
just darwin-switch-neo
just home-switch-neo
just darwin-switch-macvm-fs
just home-switch-macvm-fs
```

## Normal Updates

For the current hostname:

```sh
just quick-update
```

For `macvm-fs`:

```sh
just quick-update-macvm-fs
```

These update the flake lock, switch nix-darwin, and switch Home Manager.

## Build Without Switching

Use a build recipe when checking a change before applying it:

```sh
just darwin-build
just home-build
```

Explicit `macvm-fs` variants are also available:

```sh
just darwin-build-macvm-fs
just home-build-macvm-fs
```

## Troubleshooting

Show the current hostname, expected flake names, and recent generations:

```sh
just show-config
```

Validate the flake:

```sh
just verify-flake
```

If Home Manager fails after a large package change, try a separate Darwin switch
first, then re-run Home Manager:

```sh
just darwin-switch
just home-switch
```
