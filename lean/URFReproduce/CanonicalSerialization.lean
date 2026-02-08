namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

axiom serializeCanonical :
  {α : Type} → α → Bytes

axiom serialize_canonical_unique :
  ∀ {α} (x y : α),
    serializeCanonical x = serializeCanonical y → x = y

theorem canonical_serialization_hash_unique :
  ∀ {α} (x y : α),
    SHA256 (serializeCanonical x) =
    SHA256 (serializeCanonical y) →
    serializeCanonical x = serializeCanonical y →
    x = y :=
by
  intro α x y hhash hser
  exact serialize_canonical_unique x y hser

axiom sha256_collision_resistant :
  ∀ b1 b2 : Bytes,
    SHA256 b1 = SHA256 b2 → b1 = b2

theorem canonical_hash_unique_strong :
  ∀ {α} (x y : α),
    SHA256 (serializeCanonical x) =
    SHA256 (serializeCanonical y) →
    x = y :=
by
  intro α x y h
  have hbytes :=
    sha256_collision_resistant
      (serializeCanonical x)
      (serializeCanonical y)
      h
  exact serialize_canonical_unique x y hbytes

end URFReproduce

