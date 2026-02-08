namespace URFReproduce

abbrev Bytes := List UInt8

structure Inputs where
  payload : Bytes

structure Evidence where
  artifacts : List Bytes

structure Environment where
  ociDigest : Bytes

structure NormalForm where
  I : Inputs
  E : Evidence
  C : Environment

axiom replayComplete :
  NormalForm → Prop

axiom minimal :
  NormalForm → Prop

axiom canonicalize :
  Inputs → Evidence → Environment → NormalForm

axiom canonicalize_idempotent :
  ∀ I E C,
    canonicalize
      (canonicalize I E C).I
      (canonicalize I E C).E
      (canonicalize I E C).C
    =
    canonicalize I E C

axiom canonicalize_replay_complete :
  ∀ I E C,
    replayComplete (canonicalize I E C)

axiom canonicalize_minimal :
  ∀ I E C,
    minimal (canonicalize I E C)

theorem normal_form_exists :
  ∀ I E C,
    ∃ N : NormalForm,
      replayComplete N ∧ minimal N :=
by
  intro I E C
  refine ⟨canonicalize I E C, ?_, ?_⟩
  exact canonicalize_replay_complete I E C
  exact canonicalize_minimal I E C

end URFReproduce

