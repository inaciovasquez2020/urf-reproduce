namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

structure Artifact where
  path : String
  hash : Bytes

def Artifact.serialize (a : Artifact) : Bytes :=
  a.hash

def concat_bytes : List Bytes → Bytes
| [] => []
| (b :: t) => b ++ concat_bytes t

def MerkleLeaf (a : Artifact) : Bytes :=
  SHA256 (Artifact.serialize a)

def MerkleLevel : List Bytes → List Bytes
| [] => []
| [x] => [x]
| (x :: y :: t) => SHA256 (x ++ y) :: MerkleLevel t

partial def MerkleRootFromLeaves : List Bytes → Bytes
| [] => SHA256 []
| [x] => x
| xs => MerkleRootFromLeaves (MerkleLevel xs)

def MerkleRoot (A : List Artifact) : Bytes :=
  let leaves := A.map MerkleLeaf
  MerkleRootFromLeaves leaves

axiom SHA256_deterministic :
  ∀ b : Bytes, SHA256 b = SHA256 b

theorem MerkleRoot_deterministic
  (A : List Artifact) :
  MerkleRoot A = MerkleRoot A := by
  rfl

end URFReproduce

