namespace URFReproduce

abbrev Bytes := List UInt8

axiom SHA256 : Bytes → Bytes

structure Artifact where
  path : String
  hash : Bytes

abbrev ArtifactList := List Artifact

axiom ArtifactSerialize : Artifact → Bytes

def LeafHash (a : Artifact) : Bytes :=
  SHA256 (ArtifactSerialize a)

def CombineHash (l r : Bytes) : Bytes :=
  SHA256 (l ++ r)

def MerkleFold : List Bytes → Bytes
| []        => SHA256 []
| [x]       => x
| x :: y :: rest => MerkleFold (CombineHash x y :: rest)

def LeafList (as : ArtifactList) : List Bytes :=
  as.map LeafHash

def MerkleRoot (as : ArtifactList) : Bytes :=
  MerkleFold (LeafList as)

axiom ArtifactSerialize_injective :
  ∀ a b : Artifact,
    ArtifactSerialize a = ArtifactSerialize b → a = b

axiom SHA256_collision_resistant :
  ∀ x y : Bytes,
    SHA256 x = SHA256 y → x = y

axiom OrderedArtifacts :
  ArtifactList → Prop

axiom CanonicalOrder_unique :
  ∀ as1 as2,
    OrderedArtifacts as1 →
    OrderedArtifacts as2 →
    LeafList as1 = LeafList as2 →
    as1 = as2

theorem MerkleRoot_unique
  (as1 as2 : ArtifactList)
  (h1 : OrderedArtifacts as1)
  (h2 : OrderedArtifacts as2)
  (h : MerkleRoot as1 = MerkleRoot as2) :
  as1 = as2 :=
by
  unfold MerkleRoot at h
  admit

end URFReproduce

