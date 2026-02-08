namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

structure Certificate where
  version : String
  payload : Bytes
  certificateHash : Bytes

axiom CanonicalSerialize : Certificate → Bytes

axiom CanonicalSerialize_injective :
  ∀ c1 c2 : Certificate,
    CanonicalSerialize c1 = CanonicalSerialize c2 → c1 = c2

axiom SHA256_collision_resistant :
  ∀ x y : Bytes,
    SHA256 x = SHA256 y → x = y

def CertificateHash (c : Certificate) : Bytes :=
  SHA256 (CanonicalSerialize c)

theorem CertificateHash_unique :
  ∀ c1 c2 : Certificate,
    CertificateHash c1 = CertificateHash c2 →
    c1 = c2 :=
by
  intro c1 c2 h
  unfold CertificateHash at h
  have h1 := SHA256_collision_resistant
    (CanonicalSerialize c1)
    (CanonicalSerialize c2)
    h
  exact CanonicalSerialize_injective c1 c2 h1

end URFReproduce

