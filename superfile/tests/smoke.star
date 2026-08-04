# superfile/tests/smoke.star — stable across upstream superfile releases.
#
# superfile is a TUI file manager, so its interactive surface cannot run
# headless. The contract that CAN run headless: the binary is live and reports
# a version SHAPE (Tier 1+2), and `path-list` — its only non-TUI subcommand —
# computes config/state paths from the ENVIRONMENT and provisions the config
# tree on disk (Tier 3). Never asserts help/version prose.

SPF = "spf.exe" if ocx.target_platform.os == ocx.os.Windows else "spf"

# Tier 1 + 2: liveness + version SHAPE. Not the banner, not the exact version —
# the `v`-prefixed digits are the contract.
r_version = ocx.run(SPF, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"v\d+\.\d+\.\d+")

# Tier 3: `path-list` resolves every config location through adrg/xdg, which
# honors XDG_* overrides on EVERY OS including Windows — so pointing them all
# into scratch is both hermetic (nothing outside the sandbox is touched) and
# functional (the output must reflect OUR env, not a hardcoded default).
#
# The assertion is on a UNIQUE TOKEN, not the full path: Go's filepath.Clean
# rewrites `/` to `\` on Windows, so a full-path compare would fail there while
# the token — a single path component — survives any separator convention.
TOKEN = "ocx-spf-smoke-cfg"
CFG = ocx.scratch_root + "/" + TOKEN
r_paths = ocx.run(
    SPF, "path-list",
    env = {
        "XDG_CONFIG_HOME": CFG + "/config",
        "XDG_STATE_HOME": CFG + "/state",
        "XDG_DATA_HOME": CFG + "/data",
        "XDG_CACHE_HOME": CFG + "/cache",
    },
)
expect.ok(r_paths)
expect.contains(r_paths.stdout, TOKEN)

# `path-list` PROVISIONS what it reports: the config directory (and the stock
# theme set inside it) must now exist on disk inside scratch. A binary that
# merely echoed the env back would fail here.
expect.true(ocx.exists(TOKEN + "/config/superfile"))

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).
