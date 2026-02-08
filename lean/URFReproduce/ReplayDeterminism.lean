namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

structure Transcript where
  payload : Bytes

structure Certificate where
  body : Bytes
  hash : Bytes

axiom serialize_transcript : Transcript → Bytes
axiom serialize_certificate_body : Certificate → Bytes

axiom replay :
  Transcript → Certificate

axiom canonical_replay :
  ∀ t : Transcript,
  serialize_certificate_body (replay t) =
  serialize_transcript t

axiom SHA256_deterministic :
  ∀ b : Bytes,
  SHA256 b = SHA256 b

def cert_hash (c : Certificate) : Bytes :=
  SHA256 (serialize_certificate_body c)

theorem replay_hash_invariant
  (t : Transcript) :
  cert_hash (replay t) =
  SHA256 (serialize_transcript t) := by
  unfold cert_hash
  have h := canonical_replay t
  simpa [h]

end URFReproduce

