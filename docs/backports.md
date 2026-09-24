# Backports

Upstream `minio/mc` is archived at
[`77f82e18`](https://github.com/minio/mc/commit/77f82e18b5401a65958f1619df6ebb994634bd88)
(2025-11-06). This fork starts from that commit. The reference for fixes made
since then is [pgsty/mc](https://github.com/pgsty/mc), the client of the SILO
community fork. This file records every change of pgsty/mc considered for this
fork, reviewed against pgsty/mc at
[`e952aa78`](https://github.com/pgsty/mc/commit/e952aa78f10a2b77dd525a2b7e3143bcda0cd377)
(2026-09-16), and its status:

- **ported**: in this fork, by cherry-pick (`git cherry-pick -x`, which keeps
  the author and names the source commit) or by an equivalent change of our
  own, named in the row.
- **deferred**: applies to this fork and is not ported yet. Deferred rows
  are the maintenance backlog, in priority order: security, then
  correctness in commands the fork's users run.
- **not applicable**: SILO's branding, packaging, release machinery, or
  features outside this fork's scope.

## Security

| pgsty/mc | Change | Status |
|---|---|---|
| `a29b455e`, `bdc742af`, `08244df9`, `4b36b0a5`, `81e27673`, `625713ce`, `ec12b643`, `f1889395`, `f5b88ddd`, `b291b539`, `76b2e891`, `328efee1` | `--debug`, traces, error messages and admin trace output can print credentials, SSE-C keys and signed headers; redaction becomes structural and fails closed | deferred (priority 1) |
| `39983926` | SSE-C keys and credential URLs that the parser rejects are echoed in errors | deferred (priority 1) |
| `30a7ea01`, `c1358c42` | support artifacts are written world-readable; they are created and rotated as 0600 | deferred (priority 1) |
| `d2c0db78` | removes a vendor encryption key embedded in the client and closes the proxy-set path | deferred (priority 1) |
| `9603ee38`, `0686cd87` | SUBNET secrets in HTTP debug logs are redacted | deferred (priority 1, with the redaction set above) |
| `21210812` | policy writes are validated strictly before they are sent | deferred (priority 1) |

## Dependencies and toolchain

| pgsty/mc | Change | Status |
|---|---|---|
| `011ff855`, `d8e1e879`, `c05a6e48`, `6686b647`, `98a8b0ff`, `7102c8c6`, `53882e36`, `fa22b40b`, `458abcbf`, `88fa983a`, `81586050` | Go toolchain and module updates, some onto SILO's own packages | ported by an equivalent change: this fork moved to go1.27.1 and raised every module govulncheck flags to its fixed release, on upstream's module paths |

## Correctness

| pgsty/mc | Change | Status |
|---|---|---|
| `423490db` | JSON metrics output panics | deferred (priority 2) |
| `7057705b` | S3 Select responses are closed twice | deferred (priority 2) |
| `712bf3a6` | an empty pipe input uses a multipart upload; it becomes a regular PUT | deferred (priority 2) |
| `32790869` | an explicit checksum is dropped on zero-byte uploads | deferred (priority 2) |
| `699c07a9` | `mv` reports success when deleting the source fails | deferred (priority 2) |
| `e1ead001`, `55497f51`, `96b3fedf` | `mirror` stops on a permission failure, loses retries, and removes targets when historical versions are deleted | deferred (priority 2) |
| `736018d6`, `886eec79`, `16fa0176` | object lock failures are not propagated and empty retention durations are accepted | deferred (priority 2) |
| `1bdfb6ad` | an invalid `find` expression panics | deferred (priority 2) |
| `945081f1` | transfer failures are reported as command usage errors | deferred (priority 2) |
| `67b7b5fd`, `a786c2b8` | `admin service restart --dry-run` can fall back to a real restart; restart output without a terminal | deferred (priority 2, the dry-run fix first) |
| `367359c2` | `sql` exits 0 when an object fails | deferred (priority 2) |
| `45e51449`, `d38412a3`, `59989f8a`, `915cfd9b`, `35f2cc18`, `d60a25de`, `1e087504`, `a8564c72`, `1b3f0d61` | exit codes, flag and environment parsing, error classification and statistics fixes | deferred (priority 2) |
| `e7ef01a6`, `70a29504` | lint cleanups and embedding compatibility of SILO's packages | not applicable |

## Not applicable

| pgsty/mc | Change | Reason |
|---|---|---|
| `f6ae2b06`, `d145647d` | disables self-update and the SUBNET licensing paths | SILO distribution policy; this fork's images are not self-updated and SUBNET changes are product decisions, reviewed separately if needed |
| `aa07b1c5`, `1b394230`, `a31a42b0`, `b75d28b5`, `4abbb3a9`, `8b7b2e96`, `9dfca8fc` | new `checksum verify` command | new feature, outside this fork's scope |
| `5061c4fc`, `0c6704da`, `c62a64da`, `2d5abc21`, `f5c5dc9f`, `779b73d2` | SILO branding, the `mcli` name and module paths | this fork keeps upstream's names and module paths |
| `d13a15fe`, `51a097c9`, `1f105aab`, `1182da53`, `ad10a2a1`, `02c0305e`, `4c4dcc4b`, `8a883ca5`, `8c304dd6`, `810bbd2b`, `14b05e6b`, `e938ceae`, `d6ba2363`, `b6b26551`, `9a3805da`, `a8e7eb4b`, `f484d0db`, `36749332`, `a6c14dab`, `1445e88e`, `36d0fc3a`, `c05da7b0`, `2c33a4e2` | SILO's packaging, release pipeline and CI | this fork has its own CI and release workflow |
| `9ee207f1`, `5f54221a`, `02b1c115`, `c7f7706b`, `d205f88c`, `95326cea`, `59f26a93`, `683dc50e`, `a04eea79`, `269cac31`, `eb1704d8`, `b0021fd0`, `e952aa78` | SILO documentation, governance and release notes | SILO-specific |
| `65c71b22`, `7bc9843d`, `14bd724d`, `98760ff2`, `a5da20c1`, `00b4d535` | test changes tied to SILO's functional-test server, brand gate and CLI contracts | taken with the fixes they cover, if those are ported |
