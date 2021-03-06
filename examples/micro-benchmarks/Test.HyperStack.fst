module Test.HyperStack

open FStar.Preorder
open FStar.HyperStack
open FStar.HyperStack.ST

module HS = FStar.HyperStack

(* Tests *)
val test_do_nothing: int -> Stack int
  (requires (fun h -> True))
  (ensures (fun h _ h1 -> True))
let test_do_nothing x =
  push_frame();
  pop_frame ();
  x

val test_do_something: #rel:preorder int -> s:mstackref int rel -> Stack int
  (requires (fun h     -> contains h s))
  (ensures (fun h r h1 -> contains h s /\ r = sel h s))
let test_do_something #rel s =
  push_frame();
  let res = !s in
  pop_frame ();
  res

val test_do_something_else: #rel:preorder int -> s:mstackref int rel -> v:int -> Stack unit
  (requires (fun h     -> contains h s /\ rel (HS.sel h s) v))
  (ensures (fun h r h1 -> contains h1 s /\ v = sel h1 s))
let test_do_something_else #rel s v =
  push_frame();
  s := v;
  pop_frame ()

val test_allocate: unit -> Stack unit (requires (fun _ -> True)) (ensures (fun _ _ _ -> True))
let test_allocate () =
  push_frame();
  let x :stackref int = salloc 1 in
  x := 2;
  pop_frame ()

val test_nested_stl: unit -> Stack unit (requires (fun _ -> True)) (ensures (fun _ _ _ -> True))
let test_nested_stl () =
  let x = test_do_nothing 0 in ()

val test_nested_stl2: unit -> Stack unit (requires (fun _ -> True)) (ensures (fun _ _ _ -> True))
let test_nested_stl2 () =
  push_frame ();
  let x = test_do_nothing 0 in
  pop_frame ()

(* Testing mix of Heap and Stack code *)
val test_stack: int -> Stack int
  (requires (fun h -> True))
  (ensures (fun h _ h1 -> modifies Set.empty h h1))
let test_stack x =
  push_frame();
  let s :stackref int = salloc x in
  s := (1 + x);
  pop_frame ();
  x

val test_stack_with_long_lived: #rel:preorder int -> s:mreference int rel -> Stack unit
  (requires (fun h -> contains h s /\ rel (HS.sel h s) (HS.sel h s + 1)))
  (ensures  (fun h0 _ h1 -> contains h1 s /\ sel h1 s = (sel h0 s) + 1 /\
                         modifies (Set.singleton (frameOf s)) h0 h1))
#set-options "--z3rlimit 10"
let test_stack_with_long_lived #rel s =
  push_frame();
  let _ = test_stack !s in
  s := !s + 1;
  pop_frame()
#reset-options

val test_heap_code_with_stack_calls: unit -> Heap unit
  (requires (fun h -> heap_only h))
  (ensures  (fun h0 _ h1 -> modifies_transitively (Set.singleton h0.tip) h0 h1 ))
let test_heap_code_with_stack_calls () =
  let h = get () in
  // How is the following not known ?
  HS.root_has_color_zero ();
  let s :ref int = ralloc h.tip 0 in
  test_stack_with_long_lived s;
  s := 1;
  ()

val test_heap_code_with_stack_calls_and_regions: unit -> Heap unit
  (requires (fun h -> heap_only h))
  (ensures  (fun h0 _ h1 -> modifies_transitively (Set.singleton h0.tip) h0 h1 ))
let test_heap_code_with_stack_calls_and_regions () =
  let h = get() in
  let color = 0 in
  HS.root_has_color_zero ();
  let new_region = new_colored_region h.tip color in
  let s :ref int = ralloc new_region 1 in
  test_stack_with_long_lived s; // STStack call
  test_heap_code_with_stack_calls (); // STHeap call
  ()

val test_lax_code_with_stack_calls_and_regions: unit -> ST unit
  (requires (fun h -> True))
  (ensures  (fun h0 _ h1 -> modifies_transitively (Set.singleton HS.root) h0 h1 ))
let test_lax_code_with_stack_calls_and_regions () =
  push_frame();
  let color = 0 in
  HS.root_has_color_zero ();
  let new_region = new_colored_region HS.root color in
  let s :ref int = ralloc new_region 1 in
  test_stack_with_long_lived s; // Stack call
  pop_frame()

val test_lax_code_with_stack_calls_and_regions_2: unit -> ST unit
  (requires (fun h -> True))
  (ensures  (fun h0 _ h1 -> modifies_transitively (Set.singleton HS.root) h0 h1 ))
#set-options "--z3rlimit 10"
let test_lax_code_with_stack_calls_and_regions_2 () =
  push_frame();
  let color = 0 in
  HS.root_has_color_zero ();
  let new_region = new_colored_region HS.root color in
  let s :ref int = ralloc new_region 1 in
  test_stack_with_long_lived s; // Stack call
  test_lax_code_with_stack_calls_and_regions (); // ST call
  pop_frame()
#reset-options

val test_to_be_stack_inlined: unit -> StackInline (reference int)
  (requires (fun h -> is_stack_region h.tip))
  (ensures  (fun h0 r h1 -> ~(contains h0 r) /\ contains h1 r /\ sel h1 r = 2))
let test_to_be_stack_inlined () =
  let r :stackref int = salloc 0 in
  r := 2;
  r

val test_stack_function_with_inline: unit -> Stack int
  (requires (fun h -> True))
  (ensures  (fun h0 _ h1 -> True))
let test_stack_function_with_inline () =
  push_frame();
  let x = test_to_be_stack_inlined () in
  let y = !x + !x in
  pop_frame();
  y

val test_st_function_with_inline: unit -> ST unit
  (requires (fun h -> True))
  (ensures  (fun h0 _ h1 -> True))
let test_st_function_with_inline () =
  push_frame();
  let x = test_to_be_stack_inlined () in
  let y = !x + !x in
  pop_frame();
  ()

val test_to_be_inlined: unit -> Inline (reference int * reference int)
  (requires (fun h -> is_stack_region h.tip))
  (ensures  (fun h0 r h1 -> True))
let test_to_be_inlined () =
  let r :stackref int = salloc 0 in
  HS.root_has_color_zero ();
  let region = new_region HS.root in
  let r' = ralloc region 1 in
  r := 2;
  r' := 3;
  r,r'

val test_st_function_with_inline_2: unit -> ST unit
  (requires (fun h -> True))
  (ensures  (fun h0 _ h1 -> True))
let test_st_function_with_inline_2 () =
  push_frame();
  let x = test_to_be_stack_inlined () in
  let r, r' = test_to_be_inlined () in
  pop_frame();
  ()

val with_frame: #a:Type -> #pre:st_pre -> #post:(mem -> Tot (st_post a)) -> $f:(unit -> Stack a pre post)
	     -> Stack a (fun s0 -> forall (s1:mem). fresh_frame s0 s1 ==> pre s1)
		     (fun s0 x s1 ->
			exists (s0' s1':mem). fresh_frame s0 s0'
			         /\ poppable s0'
				 /\ post s0' x s1'
				 /\ equal_domains s0' s1'
				 /\ s1 == pop s1')
let with_frame #a #pre #post f =
  push_frame();
  let x = f() in
  pop_frame();
  x

let test_with_frame (x:stackref int) (v:int)
  : Stack unit (requires (fun m -> contains m x))
	       (ensures (fun m0 _ m1 -> modifies (Set.singleton (frameOf x)) m0 m1 /\ sel m1 x = v))
 = admit () //with_frame (fun _ -> x := v)


let as_requires (#a:Type) (wp:st_wp a) = wp (fun x s -> True)
let as_ensures (#a:Type) (wp:st_wp a) = fun s0 x s1 -> wp (fun y s1' -> y=!=x \/ s1=!=s1') s0

assume val as_stack: #a:Type -> #wp:st_wp a -> $f:(unit -> STATE a wp) ->
	   Pure (unit -> Stack a (as_requires wp)
			      (as_ensures wp))
	        (requires (forall s0 x s1. as_ensures wp s0 x s1 ==> equal_domains s0 s1))
 	        (ensures (fun x -> True))

val mm_tests: unit -> Unsafe unit (requires (fun _ -> True)) (ensures (fun _ _ _ -> True))
let mm_tests _ =
  let _ = push_frame () in

  let r1 :mmstackref int = salloc_mm 2 in

  //check that the heap contains the reference
  let m = get () in
  let h = Map.sel m.h m.tip in
  let _ = assert (Heap.contains h (as_ref r1)) in

  let _ = !r1 in

  let _ = sfree r1 in

  //this fails because the ref has been freed
  //let _ = !r1 in

  //check that the heap does not contain the reference
  let m = get () in
  let h = Map.sel m.h m.tip in
  let _ = assert (~ (Heap.contains h (as_ref r1))) in

  let r2 :mmstackref int = salloc_mm 2 in
  let _ = pop_frame () in

  //this fails because the reference is no longer live
  //let _ = sfree r2 in

  let id = new_region HS.root in

  let r3 :mmref int = ralloc_mm id 2 in
  let _ = !r3 in
  let _ = rfree r3 in

  //check that the heap does not contain the reference
  let m = get () in
  let h = Map.sel m.h id in
  let _ = assert (~ (Heap.contains h (as_ref r3))) in

  //this fails because the reference is no longer live
  //let _ = !r3 in

  //this fails because recall of mm refs is not allowed
  //let _ = recall r3 in
  ()
