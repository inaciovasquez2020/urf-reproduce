Merkle Manifest (v1)
Scope
All files under:
../urf-verifier
../urf-counterexamples
. (this repo)
Canonical ordering
Collect all regular files excluding .git and .lake
Sort by relative path bytes (lexicographic)
For each file, compute sha256(file_bytes)
Leaf hash = sha256(path || 0x00 || file_sha256_hex)
Merkle parent = sha256(left || right) with right=left if odd
Root = final hash hex
Outputs
manifest/files.sha256
manifest/merkle.root
Contract
Deterministic across machines given identical bytes.
