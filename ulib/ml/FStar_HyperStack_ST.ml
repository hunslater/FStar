open FStar_CommonST

open FStar_Monotonic_HyperHeap
open FStar_Monotonic_HyperStack
   
open FStar_HyperStack

let push_frame () = ()
let pop_frame () = ()

let def_rid = root

let salloc (contents:'a) :('a reference) =
  let r = FStar_CommonST.alloc contents in
  MkRef (root, r)

let salloc_mm (contents:'a) :('a reference) =
  let r = FStar_CommonST.alloc contents in
  MkRef (root, r)

let sfree r = ()

let new_region = (fun r0 -> def_rid)
let new_colored_region = (fun r0 c -> def_rid)

let ralloc i (contents:'a) :('a reference) =
  let r = FStar_CommonST.alloc contents in
  MkRef (i, r)  

let ralloc_mm i (contents:'a) :('a reference) =
  let r = FStar_CommonST.alloc contents in
  MkRef (i, r)  

let rfree r = ()

let op_Colon_Equals r v = match r with
  | MkRef (_, r) -> op_Colon_Equals r v

let op_Bang r = match r with
  | MkRef (_, r) -> op_Bang r

let read = op_Bang

let write = op_Colon_Equals

let get () = HS (Prims.parse_int "0", FStar_Map.const FStar_Monotonic_Heap.emp, def_rid)

let recall = (fun r -> ())

let recall_region = (fun r -> ())

type 'a ref = 'a FStar_HyperStack.reference
let alloc = salloc
type ('a, 'b) mref = 'a ref
type ('a, 'b, 'c) m_rref = 'b ref
let mr_witness _ _ _ _ _ = ()
let mr_testify _ _ _ _ _ = ()
type erid = rid
type 'a witnessed = 'a FStar_CommonST.witnessed
