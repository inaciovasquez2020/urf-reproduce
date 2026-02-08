namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

structure Certificate where
  body : Bytes

axiom CanonicalSerialize : Certificate → Bytes

axiom CanonicalSerialize_deterministic :
  ∀ c : Certificate,
    CanonicalSerialize c = CanonicalSerialize c

axiom CanonicalSerialize_injective :
  ∀ c1 c2 : Certificate,
    CanonicalSerialize c1 = CanonicalSerialize c2 → c1 = c2

def CertHash (c : Certificate) : Bytes :=
  SHA256 (CanonicalSerialize c)

axiom SHA256_injective :
  ∀ b1 b2 : Bytes,
    SHA256 b1 = SHA256 b2 → b1 = b2

theorem CertHash_uniqueness
  (c1 c2 : Certificate) :
  CertHash c1 = CertHash c2 → c1 = c2 := by
  intro h
  unfold CertHash at h
  have h1 :
    CanonicalSerialize c1 = CanonicalSerialize c2 :=
    SHA256_injective _ _ h
  exact CanonicalSerialize_injective _ _ h1

end URFReproduce

