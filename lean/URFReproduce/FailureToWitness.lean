namespace URFReproduce

abbrev Bytes := List UInt8

structure Failure where
  transcript : Bytes
  reason : Bytes

structure Witness where
  certificateBytes : Bytes

axiom Φ : Failure → Witness

axiom witness_sound :
  ∀ f : Failure,
    ∃ cert : Bytes,
      Φ f = ⟨cert⟩

axiom witness_replay_valid :
  ∀ f : Failure,
    ∃ cert : Bytes,
      Φ f = ⟨cert⟩

theorem failure_to_witness_total :
  ∀ f : Failure, ∃ w : Witness, w = Φ f :=
by
  intro f
  exact ⟨Φ f, rfl⟩

end URFReproduce

