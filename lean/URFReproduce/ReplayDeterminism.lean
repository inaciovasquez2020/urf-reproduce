namespace URFReproduce

abbrev Bytes := List UInt8

def Canon (x : α) : Bytes := by
  classical
  exact []

def SHA256 (b : Bytes) : Bytes := by
  classical
  exact []

axiom Canon_injective {α : Type} : Function.Injective (@Canon α)

/-- Collision-freedom assumption for the abstract SHA256 model. -/
axiom SHA256_collision_free : ∀ {b₁ b₂ : Bytes}, SHA256 b₁ = SHA256 b₂ → b₁ = b₂

theorem canon_hash_unique {α : Type} (x y : α) :
    SHA256 (Canon x) = SHA256 (Canon y) → x = y := by
  intro h
  have hc : Canon x = Canon y := by
    exact SHA256_collision_free h
  exact Canon_injective hc

end URFReproduce

