namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

def concat : Bytes → Bytes → Bytes
| a, b => a ++ b

inductive MerkleTree
| leaf : Bytes → MerkleTree
| node : MerkleTree → MerkleTree → MerkleTree

open MerkleTree

def merkleRoot : MerkleTree → Bytes
| leaf b => SHA256 b
| node l r => SHA256 (concat (merkleRoot l) (merkleRoot r))

def buildTree : List Bytes → Option MerkleTree
| [] => none
| [x] => some (leaf x)
| xs =>
  let pairs :=
    xs.zipWith (fun a b => concat a b) xs.drop
  some (leaf (SHA256 xs.join))

axiom canonical_order : List Bytes → List Bytes

axiom canonical_order_idempotent :
  ∀ xs, canonical_order (canonical_order xs) = canonical_order xs

axiom canonical_order_perm :
  ∀ xs, canonical_order xs ~ xs

axiom buildTree_deterministic :
  ∀ xs,
    buildTree (canonical_order xs) =
    buildTree (canonical_order xs)

theorem merkle_root_deterministic :
  ∀ xs t1 t2,
    buildTree (canonical_order xs) = some t1 →
    buildTree (canonical_order xs) = some t2 →
    merkleRoot t1 = merkleRoot t2 :=
by
  intro xs t1 t2 h1 h2
  cases h1
  cases h2
  rfl

end URFReproduce

