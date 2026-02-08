namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

structure Environment where
  ociDigest : Bytes

structure Inputs where
  payload : Bytes

structure Evidence where
  artifacts : List Bytes

structure Certificate where
  inputs : Inputs
  evidence : Evidence
  env : Environment
  hash : Bytes

axiom replay :
  Inputs → Evidence → Environment → Certificate

axiom replay_deterministic :
  ∀ I E C,
    replay I E C = replay I E C

axiom certificate_bytes :
  Certificate → Bytes

def certificate_hash (cert : Certificate) : Bytes :=
  SHA256 (certificate_bytes cert)

theorem replay_hash_invariant :
  ∀ I E C cert1 cert2,
    replay I E C = cert1 →
    replay I E C = cert2 →
    certificate_hash cert1 = certificate_hash cert2 :=
by
  intro I E C cert1 cert2 h1 h2
  cases h1
  cases h2
  rfl

end URFReproduce

