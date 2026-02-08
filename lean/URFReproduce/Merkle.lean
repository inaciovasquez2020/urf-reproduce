namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

def HashPair (a b : Bytes) : Bytes :=
  SHA256 (a ++ b)

def MerkleLayer : List Bytes → List Bytes
| [] => []
| [x] => [x]
| (a :: b :: t) => HashPair a b :: MerkleLayer t

def MerkleRoot : List Bytes → Bytes
| [] => []
| [x] => x
| xs => MerkleRoot (MerkleLayer xs)

axiom SHA256_collision_resistant :
  ∀ a b : Bytes,
  SHA256 a = SHA256 b → a = b

axiom list_concat_cancel :
  ∀ a b c d : Bytes,
  a ++ b = c ++ d → a = c ∧ b = d

theorem hashpair_injective
  (a b c d : Bytes)
  (h : HashPair a b = HashPair c d) :
  a = c ∧ b = d := by
  unfold HashPair at h
  have h1 := SHA256_collision_resistant (a ++ b) (c ++ d) h
  exact list_concat_cancel a b c d h1

end URFReproduce

