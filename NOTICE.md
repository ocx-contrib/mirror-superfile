# NOTICE

This repository packages and redistributes upstream software published by the
[superfile](https://github.com/yorukot/superfile) project. The Apache-2.0
license in [`LICENSE`](LICENSE) covers the OCX pipeline files authored here.
It does **not** cover any upstream-derived asset — the redistributed bytes
carry their own license, recorded below.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `superfile` | `ghcr.io/ocx-contrib/superfile/superfile` | `MIT` |

---

## `superfile`

Upstream: <https://github.com/yorukot/superfile>
Published to `ghcr.io/ocx-contrib/superfile/superfile`.

| Component | SPDX | Holder |
|---|---|---|
| superfile (`spf`) | **MIT** | Copyright (c) 2024 yorukot |

Verified at the license gate:

```
$ gh api repos/yorukot/superfile/license --jq '{spdx: .license.spdx_id}'
{"spdx":"MIT"}
```

MIT is permissive and grants redistribution of the compiled binary provided
the copyright and permission notice are included. This NOTICE records that
notice; the canonical text is
<https://github.com/yorukot/superfile/blob/main/LICENSE>.

The published binary statically links third-party Go modules under permissive
licenses, enumerated in upstream's `go.mod` / `go.sum`.

## Logo

`logo.svg` is upstream's own `asset/spf.svg`, redistributed unaltered from
<https://github.com/yorukot/superfile/tree/main/asset> under the same MIT
license; `logo.png` is a 512px render of that same file. It is used here for
catalog identification only. No endorsement or affiliation is implied — this
is an unaffiliated mirror.

No modifications are made to any upstream artifact in this repository; they
are republished byte-for-byte inside an OCX bundle.
