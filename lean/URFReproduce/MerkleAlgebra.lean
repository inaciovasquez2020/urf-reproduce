namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes
axiom concat : Bytes → Bytes → Bytes

def hashPair (a b : Bytes) : Bytes :=
  SHA256 (concat a b)

inductive MerkleTree
| leaf : Bytes → MerkleTree
| node : MerkleTree → MerkleTree → MerkleTree

open MerkleTree

def MerkleRoot : MerkleTree → Bytes
| leaf b => SHA256 b
| node l r => hashPair (MerkleRoot l) (MerkleRoot r)

axiom OrderedArtifacts : Type
axiom buildTree : OrderedArtifacts → MerkleTree
axiom flattenArtifacts : OrderedArtifacts → List Bytes

axiom buildTree_sound :
  ∀ A, MerkleRoot (buildTree A) =
       foldl hashPair (SHA256 []) (flattenArtifacts A)

axiom OrderedArtifacts_ext :
  ∀ A B,
    flattenArtifacts A = flattenArtifacts B → A = B

theorem MerkleRoot_unique :
  ∀ A B,
    MerkleRoot (buildTree A) = MerkleRoot (buildTree B) →
    flattenArtifacts A = flattenArtifacts B :=
by
  intro A B h
  have hA := buildTree_sound A
  have hB := buildTree_sound B
  sorry

end URFReproduce

