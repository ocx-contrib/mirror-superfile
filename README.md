# mirror-superfile

OCX mirror for [superfile](https://github.com/yorukot/superfile), a pretty
fancy and modern terminal file manager. One repository, one spec directory per
package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [superfile](https://github.com/yorukot/superfile) | [`superfile/mirror.yml`](superfile/mirror.yml) | `ghcr.io/ocx-contrib/superfile/superfile` | [`ocx.sh/superfile/superfile`](https://index.ocx.sh/superfile/superfile) | `MIT` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

`yorukot` is a personal handle rather than a vendor, so the tool names itself:
the namespace is `superfile`, not the maintainer. The binary it ships is
`spf` — the package segment is the name the project publishes under, not the
binary you type.

## Layout

```
mirror-base.yml         repo-wide policy the spec inherits via `extends:`
logo.svg / logo.png     shared describe assets (512px PNG), named by the spec
                        as `catalog.logo: ../logo.svg` — the default probe
                        looks only beside the spec
superfile/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface (`binaries: ["spf"]`, PATH)
├── CATALOG.md          → ocx package describe
└── tests/smoke.star    Starlark smoke test
.github/workflows/      ALL GENERATED — never hand-edit
```

## Editing

- Change the **spec** (`superfile/mirror.yml`) or **base**
  (`mirror-base.yml`), never the generated workflows — the
  `verify-generated.yml` drift guard fails CI (exit 65) on any hand-edit.
- After any spec/base change:

  ```sh
  direnv allow                                   # once per checkout
  ocx-mirror package validate superfile/mirror.yml
  ocx-mirror package pipeline generate ci --spec superfile/mirror.yml
  ocx-mirror package pipeline generate ci --check --spec superfile/mirror.yml
  ```

- Commit and push straight to `main` — mirror repos take no PRs.
- The toolchain pins the floating minor (`ocx.sh/ocx/{cli,mirror}:0.5`) in
  [`ocx.toml`](ocx.toml); concrete digests live in `ocx.lock` only. `ocx
  update` re-resolves them.

## Notes

- Archives nest the binary as `dist/superfile-<os>-v<ver>-<arch>/spf`, with a
  leading `./` in the tarballs but not the zips — hence
  `strip_components: 3` (tar) vs `2` (zip) in the spec. The evidence is a
  comment above `asset_type:`.
- Both Linux binaries are statically linked (0 × PT_INTERP, 0 × DT_NEEDED),
  so the Linux platform keys are bare and the alpine container leg proves the
  universality claim.
- The smoke test exercises `spf --version` (shape only) and `spf path-list`
  under XDG overrides pointed into scratch — superfile's TUI surface cannot
  run headless.
