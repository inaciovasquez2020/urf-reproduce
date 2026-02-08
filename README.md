Lean Formalization Status

Modules
URFReproduce.MerkleAlgebra
URFReproduce.CanonicalSerialization
URFReproduce.ReplayDeterminism
URFReproduce.FailureToWitness
URFReproduce.NormalForm

Build
lake update
lake build

Deterministic Guarantees
Canonical serialization uniqueness implies hash uniqueness
Merkle root determinism over canonical artifact ordering
Replay determinism implies certificate hash invariance
Failure to witness reduction totality
Existence of minimal replay complete normal form N(I,E,C)
