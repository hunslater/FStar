module EnumParsing

open PureParser
open Validator
open Serializer
open Slice

open FStar.Seq
open FStar.HyperStack
open FStar.HyperStack.ST

module U8 = FStar.UInt8
module U16 = FStar.UInt16
module U32 = FStar.UInt32

type numbers =
  | Nothing : numbers
  | OneNum : n:U32.t -> numbers
  | TwoNums : n:U32.t -> m:U32.t -> numbers

// note that the choice of tags is part of the data format, so this still
// specifies encoding

// we might have needed a U16 even with 3 constructors if one of the tags was
// [>=256]
// the refinement is a simplification of all the legal tag values (in
// general might need to combine a bunch of ranges)
// NOTE: this could well just be a [nat] with a similar refinement
let numbers_tag = t:U8.t{U8.v t < 3}

val numbers_tag_val : numbers -> numbers_tag
let numbers_tag_val n =
  match n with
  | Nothing -> 0uy
  | OneNum _ -> 1uy
  | TwoNums _ _ -> 2uy

val parse_numbers_tag : parser numbers_tag
let parse_numbers_tag =
  parse_u8 `and_then`
  (fun t -> if U8.lt t 3uy then parse_ret (t <: numbers_tag) else fail_parser)

let parse_Nothing : parser (ns:numbers{Nothing? ns}) =
  parse_ret Nothing

let parse_OneNum : parser (ns:numbers{OneNum? ns}) =
  parse_u32 `and_then`
  (fun n -> parse_ret #(ns:numbers{OneNum? ns}) (OneNum n))

let parse_TwoNums : parser (ns:numbers{TwoNums? ns}) =
  parse_u32 `and_then`
  (fun n -> parse_u32 `and_then`
  (fun m -> parse_ret #(ns:numbers{TwoNums? ns}) (TwoNums n m)))

let parser_forget (#t:Type) (#rf1:t -> Type0) ($p:parser (v:t{rf1 v})) : parser t =
  fun input -> match p input with
            | Some (v, off) -> Some (v, off)
            | None -> None

let parse_numbers_data (t:numbers_tag) : parser numbers =
  if U8.eq t 0uy
    then parser_forget parse_Nothing
  else if U8.eq t 1uy
    then parser_forget parse_OneNum
  else parser_forget parse_TwoNums

let parse_numbers : parser numbers =
  parse_numbers_tag `and_then` parse_numbers_data

let pure_validator = input:bytes{length input < pow2 32} -> option (off:nat{off <= length input})

let validate_ok (#t:Type) (p: parser t) (v: pure_validator) : Type0 =
  forall (input: bytes{length input < pow2 32}).
    match v input with
    | Some off -> Some? (p input) /\
                 (let (_, off') = Some?.v (p input) in
                   off == off')
    | None -> True

let pure_validator' #t (p: parser t) = v:pure_validator{validate_ok p v}

let parser_forget_ok #t (#rf1:t -> Type0) (p: parser (v:t{rf1 v})) (v: pure_validator) :
  Lemma (requires (validate_ok p v))
        (ensures (validate_ok (parser_forget p) v))
  [SMTPat (validate_ok (parser_forget p) v)] = ()

let make_correct #t (p: parser t) (v:pure_validator) :
  Pure (pure_validator' p)
    (requires (validate_ok p v))
    (ensures (fun r -> True)) = v

let validate_Nothing_pure = make_correct (parser_forget parse_Nothing)
                            (fun input -> Some 0)

let validate_OneNum_pure = make_correct (parser_forget parse_OneNum)
                           (fun input -> if length input < 4 then None else Some 4)

let validate_TwoNums_pure = make_correct (parser_forget parse_TwoNums)
                            (fun input -> if length input < 8 then None else Some 8)

let validate_numbers_data_pure (t:numbers_tag) : pure_validator' (parse_numbers_data t) =
  make_correct _
  (if U8.eq t 0uy
    then validate_Nothing_pure
  else if U8.eq t 1uy
    then validate_OneNum_pure
  else validate_TwoNums_pure)

#reset-options "--z3rlimit 15"

val seq_pure_validate (v1 v2: pure_validator) : pure_validator
let seq_pure_validate v1 v2 = fun input ->
  match v1 input with
  | Some off -> (match v2 (slice input off (length input)) with
               | Some off' -> Some (off+off')
               | None -> None)
  | None -> None

val lemma_seq_pure_validate_A2_ok
  (#t:Type) (#p: parser t) (v1: pure_validator' p)
  (#t':Type) (#p': parser t') (v2: pure_validator' p') :
  Lemma (forall t'' (f: t -> t' -> t'').
        validate_ok
          (p `and_then` (fun (v:t) -> p' `and_then` (fun (v':t') -> parse_ret (f v v'))))
          (seq_pure_validate v1 v2))
let lemma_seq_pure_validate_A2_ok #t #p v1 #t' #p' v2 = ()

val then_pure_check (#t:Type) (p: parser t) (v: t -> pure_validator) : pure_validator
let then_pure_check #t p v = fun input ->
  match p input with
  | Some (x, off) -> (match v x (slice input off (length input)) with
                    | Some off' -> Some (off+off')
                    | None -> None)
  | None -> None

val lemma_then_pure_check_ok
  (#t:Type) (#p: parser t)
  (#t':Type) (#p': t -> parser t') (v: (x:t -> pure_validator' (p' x))) :
  Lemma (validate_ok
          (p `and_then` p')
          (p `then_pure_check` v))
  [SMTPat (p `then_pure_check` v); SMTPat (p `and_then` p')]
let lemma_then_pure_check_ok #t #p #t' #p' v = ()

#reset-options

let validate_numbers_pure : pure_validator' parse_numbers =
  make_correct _
  (parse_numbers_tag `then_pure_check` validate_numbers_data_pure)

val parse_numbers_tag_st : parser_st parse_numbers_tag
let parse_numbers_tag_st = fun input ->
  match parse_u8_st input with
  | Some (tag, off) -> if U8.lt tag 3uy
                      then Some ((tag <: numbers_tag), off)
                      else None
  | None -> None

let parse_numbers_tag_st_nochk : parser_st_nochk parse_numbers_tag = fun input ->
  let (tag, off) = parse_u8_st_nochk input in
  ((tag <: numbers_tag), off)

(*
let validate_numbers (input:bslice) : Stack (option (off:U32.t{U32.v off <= U32.v input.len}))
  (requires (fun h0 -> live h0 input))
  (ensures (fun h0 r h1 -> live h1 input /\
                        modifies_none h0 h1 /\
                        begin
                          let bs = as_seq h1 input in
                          match r with
                          | Some off -> validate_numbers_pure bs == Some (U32.v off)
                          | None -> True
                        end)) =
  match parse_numbers_tag_st input with
  | Some (tag, off) ->
    let input = advance_slice input off in
    if U8.eq tag 0uy
      then Some off
    else (admit(); if U8.eq tag 1uy
      then if U32.lt input.len 4ul then None else Some (U32.add off 4ul)
    else begin
      assert (U8.v tag == 2);
      if U32.lt input.len 8ul then None else Some (U32.add off 8ul)
    end)
  | None -> None
*)

let check_length (len:U32.t) (input:bslice) : Pure bool
  (requires True)
  (ensures (fun r -> r ==> U32.v input.len >= U32.v len)) = U32.lte len input.len

val validate_OneNum : stateful_validator (parser_forget parse_OneNum)
let validate_OneNum = fun input ->
  if check_length 4ul input then Some 4ul else None

val validate_TwoNums : stateful_validator (parser_forget parse_TwoNums)
let validate_TwoNums = fun input ->
  if check_length 8ul input then Some 8ul else None

let validate_numbers_data (t:numbers_tag) : stateful_validator (parse_numbers_data t) =
  if U8.eq t 0uy then
    (fun input -> Some 0ul) <: stateful_validator (parser_forget parse_Nothing)
  else if U8.eq t 1uy then
    validate_OneNum
  else validate_TwoNums

let coerce_validator #t (#p: parser t)
                        (#p': parser t{forall x. p x == p' x})
                        (v: stateful_validator p) : Pure (stateful_validator p') (requires True) (ensures (fun r -> True)) =
  fun input -> match v input with
            | Some off -> Some off
            | None -> None

#reset-options "--z3rlimit 15"

val and_check (#t:Type) (p: parser t) (p_st: parser_st p)
              (#t':Type) (#p': t -> parser t') (v: x:t -> stateful_validator (p' x))
              : stateful_validator (p `and_then` p')
let and_check #t p p_st #t' #p' v =
    fun input -> match p_st input with
              | Some (x, off) ->
                begin
                  match v x (advance_slice input off) with
                  | Some off' -> Some (U32.add off off')
                  | None -> None
                end
              | None -> None

#reset-options

let validate_numbers : stateful_validator parse_numbers =
    // TODO: parse_numbers_tag is not inferred from the type of parse_numbers_tag_st
    and_check parse_numbers_tag parse_numbers_tag_st validate_numbers_data