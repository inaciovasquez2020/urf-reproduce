namespace URFReproduce

abbrev Bytes := List UInt8

def CanonicalSerialize (x : Bytes) : Bytes :=
  x

axiom SHA256 : Bytes → Bytes

def Hash (x : Bytes) : Bytes :=
  SHA256 (CanonicalSerialize x)

theorem canonical_serialization_idempotent
  (x : Bytes) :
  CanonicalSerialize (CanonicalSerialize x) = CanonicalSerialize x := by
  rfl

axiom SHA256_collision_resistant :
  ∀ a b : Bytes,
  SHA256 a = SHA256 b → a = b

theorem hash_uniqueness
  (x y : Bytes)
  (h : Hash x = Hash y) :
  CanonicalSerialize x = CanonicalSerialize y := by
  unfold Hash at h
  have h' := SHA256_collision_resistant
    (CanonicalSerialize x)
    (CanonicalSerialize y)
    h
  exact h'

end URFReproduce

