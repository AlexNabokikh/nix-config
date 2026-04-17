# Codebase Improvement Suggestions

## High Priority

### 1. Remove Unused Flake Inputs
**Issue**: Several flake inputs are declared but never used
- `spicetify-nix` - Not referenced anywhere
- `homebrew-core` and `homebrew-cask` - Declared as "optional" but not used

**Action**: Remove from `flake.nix` inputs section to speed up flake evaluation

**Impact**: Faster `nix flake update` and reduced lock file size

---

### 2. Fix Placeholder Values
**Issue**: `users/fs.nix` has `gitKey = "YOUR_GIT_KEY"` placeholder
- This value is never used in `home/modules/git.nix`
- Git signing uses `~/.ssh/id_gitsign_fs` instead

**Action**: Either:
- Remove `gitKey` from user config if unused
- Or use it properly in git.nix: `signingkey = userConfig.gitKey;`

**Impact**: Cleaner configuration, no misleading placeholders

---

### 3. Consolidate SSH Keys
**Issue**: SSH keys are duplicated in two places:
- `users/fs.nix` (3 keys)
- `hosts/modules/nixos-common.nix` (same 3 keys hardcoded)

**Action**: Use `userConfig.sshKeys` in nixos-common.nix:
```nix
openssh.authorizedKeys.keys = userConfig.sshKeys;
```

**Impact**: Single source of truth, easier to maintain

---

### 4. Fix Unused Lambda Patterns
**Issue**: Many modules have unused parameters (flagged by deadnix/statix)

**Files to fix**:
- `hosts/modules/mac-common.nix` - unused `pkgs`
- `hosts/modules/parallels.nix` - unused `pkgs`
- Multiple home modules with empty patterns

**Action**: Replace `{pkgs, ...}:` with `{...}:` or `_:` when pkgs is unused

**Impact**: Cleaner code, passes linting

---

### 5. Consolidate Repeated Keys
**Issue**: Multiple files have repeated attribute keys (statix warnings)

**Examples**:
- `hosts/neo/configuration.nix` - `nix` and `security` keys repeated
- `hosts/modules/nixos-common.nix` - `nix`, `environment`, `services` repeated

**Action**: Merge into single attribute sets:
```nix
nix = {
  settings = { ... };
  optimise.automatic = true;
  package = pkgs.nix;
};
```

**Impact**: More readable, better structure

---

## Medium Priority

### 6. Improve Module Organization
**Issue**: `hosts/modules/mac-common.nix` only imports other modules

**Action**: Consider either:
- Inline the imports in host configs
- Add actual configuration to make it substantial

**Impact**: Clearer module purpose

---

### 7. Add Module Documentation
**Issue**: Most modules lack comments explaining their purpose

**Action**: Add header comments to each module:
```nix
# Module: Hyprland Wayland Compositor
# Purpose: Configures Hyprland with custom keybindings and appearance
# Platform: NixOS only
{...}: {
```

**Impact**: Better maintainability, easier onboarding

---

### 8. Standardize Empty Patterns
**Issue**: Many modules use `{...}:` for empty patterns

**Action**: Use `_:` instead (statix recommendation):
```nix
# Before
{...}: {
  programs.starship.enable = true;
}

# After
_: {
  programs.starship.enable = true;
}
```

**Impact**: Cleaner, more idiomatic Nix

---

### 9. Create Shared Darwin Module
**Issue**: Both macOS configs have nearly identical settings

**Action**: Create `hosts/modules/darwin-common.nix` with shared settings:
- TouchID/WatchID auth
- System defaults (Finder, Dock, etc.)
- Keyboard mappings
- Activation scripts

**Impact**: DRY principle, easier to maintain

---

### 10. Improve Justfile Commands
**Issue**: Duplicate commands for different hosts

**Action**: Use variables and conditionals:
```justfile
# Switch configuration for current host
switch:
    @if [ "$(uname)" = "Darwin" ]; then \
        just darwin-switch; \
    else \
        sudo nixos-rebuild switch --flake .#{{hostname}}; \
    fi
```

**Impact**: Simpler interface, fewer commands

---

## Low Priority

### 11. Add System Architecture Flexibility
**Issue**: `mkDarwinConfiguration` hardcodes `aarch64-darwin`

**Action**: Accept system as parameter:
```nix
mkDarwinConfiguration = system: hostname: username:
  darwin.lib.darwinSystem {
    inherit system;
    # ...
  };
```

**Impact**: Support for Intel Macs if needed

---

### 12. Resolve TODOs
**Issue**: Several TODO comments in code

**Files**:
- `home/modules/neovim.nix` - NodeJS disabled due to bug
- `home/modules/neovim.nix` - Ruff moved to Homebrew
- `home/modules/zsh.nix` - 1Password CLI integration disabled
- `hosts/modules/nixos-common.nix` - Move SSH keys to variable

**Action**: Either fix or document why they're deferred

**Impact**: Cleaner codebase

---

### 13. Add Formatter Output
**Issue**: `nix fmt` works but could be more discoverable

**Action**: Already done! ✓

---

### 14. Keep Operational Docs Linked From Root
**Issue**: Subdirectories need discoverable documentation without creating
multiple README entry points.

**Action**: Keep the single root `README.md` as the documentation map and link
to focused pages in `docs/` for Mac deploys, Just recipes, VMs, and physical
hosts.

**Impact**: Better documentation without competing READMEs

---

### 15. Add .editorconfig
**Issue**: No editor configuration for consistent formatting

**Action**: Create `.editorconfig`:
```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.nix]
indent_style = space
indent_size = 2

[*.md]
trim_trailing_whitespace = false
```

**Impact**: Consistent formatting across editors

---

### 16. Optimize Overlays
**Issue**: Only one overlay (stable-packages) - consider if both channels needed

**Action**: Evaluate if you actually use `pkgs.stable.*` anywhere
- If yes, keep it
- If no, remove nixpkgs-stable input

**Impact**: Faster evaluation if removed

---

### 17. Add Garbage Collection Automation
**Issue**: Manual cleanup via `just clean`

**Action**: Enable automatic GC on Darwin:
```nix
nix.gc = {
  automatic = true;
  interval = {Weekday = 7;}; # Sunday
  options = "--delete-older-than 30d";
};
```

**Impact**: Automatic disk space management

---

### 18. Improve Error Messages
**Issue**: No validation of required values

**Action**: Add assertions:
```nix
assertions = [
  {
    assertion = userConfig.email != "";
    message = "User email must be set";
  }
];
```

**Impact**: Better error messages

---

### 19. Add Development Documentation
**Issue**: No guide for adding new machines

**Action**: Create `docs/ADDING-MACHINES.md` with step-by-step guide

**Impact**: Easier to scale

---

### 20. Consider Secrets Management
**Issue**: No secrets management despite having `sops` installed

**Action**: Either:
- Implement `sops-nix` for secrets
- Remove `sops` if not using it

**Impact**: Proper secrets handling or cleaner dependencies

---

## Quick Wins (Easy to Implement)

1. ✅ Remove empty directories (DONE)
2. ✅ Remove commented code (DONE)
3. ✅ Fix systemd on macOS (DONE)
4. ✅ Consolidate duplicate packages (DONE)
5. Remove unused flake inputs (5 min)
6. Fix SSH keys duplication (5 min)
7. Remove/fix gitKey placeholder (2 min)
8. Add .editorconfig (2 min)
9. Fix unused lambda patterns in mac-common.nix (2 min)

---

## Summary Statistics

- **High Priority**: 5 items
- **Medium Priority**: 10 items
- **Low Priority**: 9 items
- **Quick Wins**: 9 items (4 already done)

**Estimated Time to Complete All**: 4-6 hours
**Estimated Time for High Priority**: 1 hour
