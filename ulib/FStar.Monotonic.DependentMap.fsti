module FStar.Monotonic.DependentMap
(** A library for mutable partial, dependent maps,
    that grow monotonically,
    while subject to an invariant on the entire map *)
open FStar.HyperStack.ST
module HS = FStar.HyperStack
module MR = FStar.Monotonic.RRef
module DM = FStar.DependentMap

/// The logical model of the map is given in terms of DM.t///
let opt (#a:eqtype) (b:a -> Type) = fun (x:a) -> option (b x)
let partial_dependent_map (a:eqtype) (b:a -> Type) =
    DM.t a (opt b)

/// An empty partial, dependent map maps all keys to None
let empty_partial_dependent_map (#a:_) (#b:_)
  : partial_dependent_map a b
  = DM.create #a #(opt b) (fun x -> None)
////////////////////////////////////////////////////////////////////////////////

/// `map a b`: Internally, the model is implemented using this abstract type
///    These maps provide three operations:
///      - empty, sel, upd
///    Which are proven to be in correspondence with the operations on DM.t
///    via the homomorphism `repr` below
val map
    (a:eqtype u#a)
    (b:(a -> Type u#b))
  : Type u#(max a b)

/// `repr m`: A ghost function that reveals the internal `map` as a `DM.t`
val repr (#a:_) (#b:_)
    (r:map a b)
  : GTot (partial_dependent_map a b)

/// An `empty : map a b` is equivalent to the `empty_partial_dependent_map`
val empty (#a:_) (#b:_)
  : r:map a b{repr r == empty_partial_dependent_map}

/// Selecting a key from a map `sel r x` is equivalent to selecting it from its `repr`
val sel (#a:_) (#b:_)
    (r:map a b)
    (x:a)
  : Pure (option (b x))
    (requires True)
    (ensures (fun o -> DM.sel (repr r) x == o))

/// Updating a map using `upd r x v` is equivalent to updating its repr
val upd (#a:_) (#b:_)
    (r:map a b)
    (x:a)
    (v:b x)
  : Pure (map a b)
    (requires True)
    (ensures (fun r' -> repr r' == DM.upd (repr r) x (Some v)))

/// `imap a b inv` further augments a map with an invariant on its repr
let imap (a:eqtype) (b: a -> Type) (inv:DM.t a (opt b) -> Type) =
    r:map a b{inv (repr r)}

/// `grows r1 r2` is an abstract preorder on `imap`
val grows (#a:_) (#b:_) (#inv:DM.t a (opt b) -> Type)
  : FStar.Preorder.preorder (imap a b inv)

/// And, finally, the main type of this module:
///
/// `t r a b inv` is a mutable, imap stored in region `r` constrained
///               to evolve according to `grows`
let t (r:MR.rid) (a:eqtype) (b:a -> Type) (inv:DM.t a (opt b) -> Type) =
    MR.m_rref r (imap a b inv) grows

/// `defined t x h`: In state `h`, map `t` is defined at point `x`.
///     - We define these in `Type` rather than `bool`
///       since it is typical for client code to use `defined`
///       as a stable heap predicate, which requires a `heap -> Type`
let defined
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
    (h:HS.mem)
  : GTot Type
  = Some? (sel (HS.sel h t) x)

/// `fresh t x h`: The map is not defined at point `x`
let fresh
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
    (h:HS.mem)
  : GTot Type0
  = ~ (defined t x h)

/// `value_of t x h`: Get the value of `x` in the map `t` in state `h`
let value_of
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
    (h:HS.mem{defined t x h})
  : GTot (b x)
  = Some?.v (sel (HS.sel h t) x)

/// `contains t x y h`: In state `h`, `t` maps `x` to `y`
let contains
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
    (y:b x)
    (h:HS.mem)
  : GTot Type0
  = defined t x h /\
    value_of t x h == y

/// `contains_stable`: The `contains` predicate is stable with respect to `grows`
val contains_stable
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
    (y:b x)
  : Lemma (ensures (MR.stable_on_t t (contains t x y)))

/// `defined_stable`: The `defined` predicate is stable with respect to `grows`
///    - this is easily derivable from the previous lemma
///      But, we provide it here as a convenience to clients
val defined_stable
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
  : Lemma (ensures (MR.stable_on_t t (defined t x)))

////////////////////////////////////////////////////////////////////////////////
// Interface of stateful operations
////////////////////////////////////////////////////////////////////////////////

/// `alloc ()`: Allocating a new `t` requires proving the `inv` of the empty map
val alloc (#a:eqtype) (#b:a -> Type) (#inv:DM.t a (opt b) -> Type) (#r:MR.rid)
    (_:unit{inv (repr empty)})
  : ST (t r a b inv)
       (requires (fun h -> HyperStack.ST.witnessed (region_contains_pred r)))
       (ensures (fun h0 x h1 ->
         ralloc_post r empty h0 x h1))

/// `extend t x y`: Extending `t` with (x -> y)
///     Requires: - proving that the `t` does not already define `x`
///               - and that the resulting heap would still respect `inv`
///     Ensures:  - that only `t` is modified
///               - by updating it to contain `(x -> y)`
///               - and in the future `t` will always contain `(x -> y)`
//This really should be hidden inside the MR library
let addr_of (#r:_) (#a:_) (#b:_) (m:MR.m_rref r a b) : GTot nat =
    HS.as_addr m

val extend
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
    (y:b x)
  : ST unit
       (requires (fun h ->
         ~(defined t x h) /\
         inv (repr (upd (HS.sel h t) x y))))
       (ensures (fun h0 u h1 ->
         let cur = HS.sel h0 t in
         HS.contains h1 t /\
         HS.modifies (Set.singleton r) h0 h1 /\
         HS.modifies_ref r (Set.singleton (addr_of t)) h0 h1 /\
         HS.sel h1 t == upd cur x y /\
         MR.witnessed (contains t x y)))

/// `lookup t x`: Querying the map `t` at point `x`
///      Ensures: - The state does not change
///               - If it returns `Some v`, then `t` will always contains `x -> v`
val lookup
    (#a:eqtype)
    (#b:a -> Type)
    (#inv:DM.t a (opt b) -> Type)
    (#r:MR.rid)
    (t:t r a b inv)
    (x:a)
  : ST (option (b x))
       (requires (fun h -> True))
       (ensures (fun h0 y h1 ->
         h0==h1 /\
         y == sel (HS.sel h1 t) x /\
         (match y with
          | None -> ~(defined t x h1)
          | Some v ->
            contains t x v h1 /\
            MR.witnessed (contains t x v))))
 
let forall_t (#a:eqtype) (#b:a -> Type) (#inv:DM.t a (opt b) -> Type) (#r:MR.rid)
             (t:t r a b inv) (h:HS.mem) (pred: (x:a) -> b x -> Type0)
  = forall (x:a).{:pattern (sel (HS.sel h t) x) \/ (DM.sel (repr (HS.sel h t)) x)}
            defined t x h ==> pred x (Some?.v (sel (HS.sel h t) x))

let f_opt (#a:eqtype) (#b #c:a -> Type) (f: (x:a) -> b x -> c x) :(x:a) -> option (b x) -> option (c x)
  = fun x y ->
    match y with
    | None   -> None
    | Some y -> Some (f x y)

val mmap_f (#a:eqtype) (#b #c:a -> Type) (m:map a b) (f: (x:a) -> b x -> c x)
  :Tot (m':(map a c){repr m' == DM.map (f_opt f) (repr m)})

val map_f (#a:eqtype) (#b #c:a -> Type)
          (#inv:DM.t a (opt b) -> Type) (#inv':DM.t a (opt c) -> Type)
	  (#r #r':MR.rid)
          (m:t r a b inv) (f: (x:a) -> b x -> c x)
	  :ST (t r' a c inv')
	      (requires (fun h0 -> inv' (DM.map (f_opt f) (repr (HS.sel h0 m))) /\ witnessed (region_contains_pred r')))
	      (ensures  (fun h0 m' h1 ->
	                 inv' (DM.map (f_opt f) (repr (HS.sel h0 m))) /\  //AR: surprised that even after the fix for #57, we need this repetetion from the requires clause
	                 ralloc_post r' (mmap_f (HS.sel h0 m) f) h0 m' h1))




