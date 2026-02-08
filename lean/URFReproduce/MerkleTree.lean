namespace URFReproduce

abbrev Bytes := List UInt8

def SHA256 (b : Bytes) : Bytes := by
  classical
  exact []

def concat (a b : Bytes) : Bytes :=
  a ++ b

def MerkleLeaf (b : Bytes) : Bytes :=
  SHA256 b

def MerkleNode (l r : Bytes) : Bytes :=
  SHA256 (concat l r)

def MerkleLayer : List Bytes → List Bytes
| [] => []
| [x] => [x]
| x :: y :: xs => MerkleNode x y :: MerkleLayer xs

partial def MerkleRoot : List Bytes → Bytes
| [] => []
| [x] => x
| xs => MerkleRoot (MerkleLayer xs)

/-- Ordered artifact multiset normal form. -/
structure OrderedArtifacts where
  artifacts : List Bytes

def MerkleRootArtifacts (A : OrderedArtifacts) : Bytes :=
  MerkleRoot (A.artifacts)

end URFReproduce

