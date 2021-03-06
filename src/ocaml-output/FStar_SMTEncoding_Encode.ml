open Prims
let add_fuel:
  'Auu____4 . 'Auu____4 -> 'Auu____4 Prims.list -> 'Auu____4 Prims.list =
  fun x  ->
    fun tl1  ->
      let uu____19 = FStar_Options.unthrottle_inductives () in
      if uu____19 then tl1 else x :: tl1
let withenv:
  'Auu____28 'Auu____29 'Auu____30 .
    'Auu____30 ->
      ('Auu____29,'Auu____28) FStar_Pervasives_Native.tuple2 ->
        ('Auu____29,'Auu____28,'Auu____30) FStar_Pervasives_Native.tuple3
  = fun c  -> fun uu____48  -> match uu____48 with | (a,b) -> (a, b, c)
let vargs:
  'Auu____59 'Auu____60 'Auu____61 .
    (('Auu____61,'Auu____60) FStar_Util.either,'Auu____59)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      (('Auu____61,'Auu____60) FStar_Util.either,'Auu____59)
        FStar_Pervasives_Native.tuple2 Prims.list
  =
  fun args  ->
    FStar_List.filter
      (fun uu___77_107  ->
         match uu___77_107 with
         | (FStar_Util.Inl uu____116,uu____117) -> false
         | uu____122 -> true) args
let subst_lcomp_opt:
  'Auu____134 .
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      (FStar_Syntax_Syntax.lcomp,'Auu____134) FStar_Util.either
        FStar_Pervasives_Native.option ->
        (FStar_Syntax_Syntax.lcomp,'Auu____134) FStar_Util.either
          FStar_Pervasives_Native.option
  =
  fun s  ->
    fun l  ->
      match l with
      | FStar_Pervasives_Native.Some (FStar_Util.Inl l1) ->
          let uu____170 =
            let uu____175 =
              let uu____176 =
                let uu____179 = l1.FStar_Syntax_Syntax.comp () in
                FStar_Syntax_Subst.subst_comp s uu____179 in
              FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp uu____176 in
            FStar_Util.Inl uu____175 in
          FStar_Pervasives_Native.Some uu____170
      | uu____186 -> l
let escape: Prims.string -> Prims.string =
  fun s  -> FStar_Util.replace_char s 39 95
let mk_term_projector_name:
  FStar_Ident.lident -> FStar_Syntax_Syntax.bv -> Prims.string =
  fun lid  ->
    fun a  ->
      let a1 =
        let uu___100_205 = a in
        let uu____206 =
          FStar_Syntax_Util.unmangle_field_name a.FStar_Syntax_Syntax.ppname in
        {
          FStar_Syntax_Syntax.ppname = uu____206;
          FStar_Syntax_Syntax.index =
            (uu___100_205.FStar_Syntax_Syntax.index);
          FStar_Syntax_Syntax.sort = (uu___100_205.FStar_Syntax_Syntax.sort)
        } in
      let uu____207 =
        FStar_Util.format2 "%s_%s" lid.FStar_Ident.str
          (a1.FStar_Syntax_Syntax.ppname).FStar_Ident.idText in
      FStar_All.pipe_left escape uu____207
let primitive_projector_by_pos:
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident -> Prims.int -> Prims.string
  =
  fun env  ->
    fun lid  ->
      fun i  ->
        let fail uu____220 =
          let uu____221 =
            FStar_Util.format2
              "Projector %s on data constructor %s not found"
              (Prims.string_of_int i) lid.FStar_Ident.str in
          failwith uu____221 in
        let uu____222 = FStar_TypeChecker_Env.lookup_datacon env lid in
        match uu____222 with
        | (uu____227,t) ->
            let uu____229 =
              let uu____230 = FStar_Syntax_Subst.compress t in
              uu____230.FStar_Syntax_Syntax.n in
            (match uu____229 with
             | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
                 let uu____251 = FStar_Syntax_Subst.open_comp bs c in
                 (match uu____251 with
                  | (binders,uu____257) ->
                      if
                        (i < (Prims.parse_int "0")) ||
                          (i >= (FStar_List.length binders))
                      then fail ()
                      else
                        (let b = FStar_List.nth binders i in
                         mk_term_projector_name lid
                           (FStar_Pervasives_Native.fst b)))
             | uu____272 -> fail ())
let mk_term_projector_name_by_pos:
  FStar_Ident.lident -> Prims.int -> Prims.string =
  fun lid  ->
    fun i  ->
      let uu____279 =
        FStar_Util.format2 "%s_%s" lid.FStar_Ident.str
          (Prims.string_of_int i) in
      FStar_All.pipe_left escape uu____279
let mk_term_projector:
  FStar_Ident.lident -> FStar_Syntax_Syntax.bv -> FStar_SMTEncoding_Term.term
  =
  fun lid  ->
    fun a  ->
      let uu____286 =
        let uu____291 = mk_term_projector_name lid a in
        (uu____291,
          (FStar_SMTEncoding_Term.Arrow
             (FStar_SMTEncoding_Term.Term_sort,
               FStar_SMTEncoding_Term.Term_sort))) in
      FStar_SMTEncoding_Util.mkFreeV uu____286
let mk_term_projector_by_pos:
  FStar_Ident.lident -> Prims.int -> FStar_SMTEncoding_Term.term =
  fun lid  ->
    fun i  ->
      let uu____298 =
        let uu____303 = mk_term_projector_name_by_pos lid i in
        (uu____303,
          (FStar_SMTEncoding_Term.Arrow
             (FStar_SMTEncoding_Term.Term_sort,
               FStar_SMTEncoding_Term.Term_sort))) in
      FStar_SMTEncoding_Util.mkFreeV uu____298
let mk_data_tester:
  'Auu____308 .
    'Auu____308 ->
      FStar_Ident.lident ->
        FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term
  =
  fun env  ->
    fun l  ->
      fun x  -> FStar_SMTEncoding_Term.mk_tester (escape l.FStar_Ident.str) x
type varops_t =
  {
  push: Prims.unit -> Prims.unit;
  pop: Prims.unit -> Prims.unit;
  new_var: FStar_Ident.ident -> Prims.int -> Prims.string;
  new_fvar: FStar_Ident.lident -> Prims.string;
  fresh: Prims.string -> Prims.string;
  string_const: Prims.string -> FStar_SMTEncoding_Term.term;
  next_id: Prims.unit -> Prims.int;
  mk_unique: Prims.string -> Prims.string;}[@@deriving show]
let __proj__Mkvarops_t__item__push: varops_t -> Prims.unit -> Prims.unit =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__push
let __proj__Mkvarops_t__item__pop: varops_t -> Prims.unit -> Prims.unit =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__pop
let __proj__Mkvarops_t__item__new_var:
  varops_t -> FStar_Ident.ident -> Prims.int -> Prims.string =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__new_var
let __proj__Mkvarops_t__item__new_fvar:
  varops_t -> FStar_Ident.lident -> Prims.string =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__new_fvar
let __proj__Mkvarops_t__item__fresh: varops_t -> Prims.string -> Prims.string
  =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__fresh
let __proj__Mkvarops_t__item__string_const:
  varops_t -> Prims.string -> FStar_SMTEncoding_Term.term =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__string_const
let __proj__Mkvarops_t__item__next_id: varops_t -> Prims.unit -> Prims.int =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__next_id
let __proj__Mkvarops_t__item__mk_unique:
  varops_t -> Prims.string -> Prims.string =
  fun projectee  ->
    match projectee with
    | { push = __fname__push; pop = __fname__pop; new_var = __fname__new_var;
        new_fvar = __fname__new_fvar; fresh = __fname__fresh;
        string_const = __fname__string_const; next_id = __fname__next_id;
        mk_unique = __fname__mk_unique;_} -> __fname__mk_unique
let varops: varops_t =
  let initial_ctr = Prims.parse_int "100" in
  let ctr = FStar_Util.mk_ref initial_ctr in
  let new_scope uu____672 =
    let uu____673 = FStar_Util.smap_create (Prims.parse_int "100") in
    let uu____676 = FStar_Util.smap_create (Prims.parse_int "100") in
    (uu____673, uu____676) in
  let scopes =
    let uu____696 = let uu____707 = new_scope () in [uu____707] in
    FStar_Util.mk_ref uu____696 in
  let mk_unique y =
    let y1 = escape y in
    let y2 =
      let uu____748 =
        let uu____751 = FStar_ST.op_Bang scopes in
        FStar_Util.find_map uu____751
          (fun uu____863  ->
             match uu____863 with
             | (names1,uu____875) -> FStar_Util.smap_try_find names1 y1) in
      match uu____748 with
      | FStar_Pervasives_Native.None  -> y1
      | FStar_Pervasives_Native.Some uu____884 ->
          (FStar_Util.incr ctr;
           (let uu____919 =
              let uu____920 =
                let uu____921 = FStar_ST.op_Bang ctr in
                Prims.string_of_int uu____921 in
              Prims.strcat "__" uu____920 in
            Prims.strcat y1 uu____919)) in
    let top_scope =
      let uu____995 =
        let uu____1004 = FStar_ST.op_Bang scopes in FStar_List.hd uu____1004 in
      FStar_All.pipe_left FStar_Pervasives_Native.fst uu____995 in
    FStar_Util.smap_add top_scope y2 true; y2 in
  let new_var pp rn =
    FStar_All.pipe_left mk_unique
      (Prims.strcat pp.FStar_Ident.idText
         (Prims.strcat "__" (Prims.string_of_int rn))) in
  let new_fvar lid = mk_unique lid.FStar_Ident.str in
  let next_id1 uu____1142 = FStar_Util.incr ctr; FStar_ST.op_Bang ctr in
  let fresh1 pfx =
    let uu____1251 =
      let uu____1252 = next_id1 () in
      FStar_All.pipe_left Prims.string_of_int uu____1252 in
    FStar_Util.format2 "%s_%s" pfx uu____1251 in
  let string_const s =
    let uu____1257 =
      let uu____1260 = FStar_ST.op_Bang scopes in
      FStar_Util.find_map uu____1260
        (fun uu____1372  ->
           match uu____1372 with
           | (uu____1383,strings) -> FStar_Util.smap_try_find strings s) in
    match uu____1257 with
    | FStar_Pervasives_Native.Some f -> f
    | FStar_Pervasives_Native.None  ->
        let id1 = next_id1 () in
        let f =
          let uu____1396 = FStar_SMTEncoding_Util.mk_String_const id1 in
          FStar_All.pipe_left FStar_SMTEncoding_Term.boxString uu____1396 in
        let top_scope =
          let uu____1400 =
            let uu____1409 = FStar_ST.op_Bang scopes in
            FStar_List.hd uu____1409 in
          FStar_All.pipe_left FStar_Pervasives_Native.snd uu____1400 in
        (FStar_Util.smap_add top_scope s f; f) in
  let push1 uu____1536 =
    let uu____1537 =
      let uu____1548 = new_scope () in
      let uu____1557 = FStar_ST.op_Bang scopes in uu____1548 :: uu____1557 in
    FStar_ST.op_Colon_Equals scopes uu____1537 in
  let pop1 uu____1759 =
    let uu____1760 =
      let uu____1771 = FStar_ST.op_Bang scopes in FStar_List.tl uu____1771 in
    FStar_ST.op_Colon_Equals scopes uu____1760 in
  {
    push = push1;
    pop = pop1;
    new_var;
    new_fvar;
    fresh = fresh1;
    string_const;
    next_id = next_id1;
    mk_unique
  }
let unmangle: FStar_Syntax_Syntax.bv -> FStar_Syntax_Syntax.bv =
  fun x  ->
    let uu___101_1973 = x in
    let uu____1974 =
      FStar_Syntax_Util.unmangle_field_name x.FStar_Syntax_Syntax.ppname in
    {
      FStar_Syntax_Syntax.ppname = uu____1974;
      FStar_Syntax_Syntax.index = (uu___101_1973.FStar_Syntax_Syntax.index);
      FStar_Syntax_Syntax.sort = (uu___101_1973.FStar_Syntax_Syntax.sort)
    }
type binding =
  | Binding_var of (FStar_Syntax_Syntax.bv,FStar_SMTEncoding_Term.term)
  FStar_Pervasives_Native.tuple2
  | Binding_fvar of
  (FStar_Ident.lident,Prims.string,FStar_SMTEncoding_Term.term
                                     FStar_Pervasives_Native.option,FStar_SMTEncoding_Term.term
                                                                    FStar_Pervasives_Native.option)
  FStar_Pervasives_Native.tuple4[@@deriving show]
let uu___is_Binding_var: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_var _0 -> true | uu____2007 -> false
let __proj__Binding_var__item___0:
  binding ->
    (FStar_Syntax_Syntax.bv,FStar_SMTEncoding_Term.term)
      FStar_Pervasives_Native.tuple2
  = fun projectee  -> match projectee with | Binding_var _0 -> _0
let uu___is_Binding_fvar: binding -> Prims.bool =
  fun projectee  ->
    match projectee with | Binding_fvar _0 -> true | uu____2043 -> false
let __proj__Binding_fvar__item___0:
  binding ->
    (FStar_Ident.lident,Prims.string,FStar_SMTEncoding_Term.term
                                       FStar_Pervasives_Native.option,
      FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple4
  = fun projectee  -> match projectee with | Binding_fvar _0 -> _0
let binder_of_eithervar:
  'Auu____2090 'Auu____2091 .
    'Auu____2091 ->
      ('Auu____2091,'Auu____2090 FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2
  = fun v1  -> (v1, FStar_Pervasives_Native.None)
type cache_entry =
  {
  cache_symbol_name: Prims.string;
  cache_symbol_arg_sorts: FStar_SMTEncoding_Term.sort Prims.list;
  cache_symbol_decls: FStar_SMTEncoding_Term.decl Prims.list;
  cache_symbol_assumption_names: Prims.string Prims.list;}[@@deriving show]
let __proj__Mkcache_entry__item__cache_symbol_name:
  cache_entry -> Prims.string =
  fun projectee  ->
    match projectee with
    | { cache_symbol_name = __fname__cache_symbol_name;
        cache_symbol_arg_sorts = __fname__cache_symbol_arg_sorts;
        cache_symbol_decls = __fname__cache_symbol_decls;
        cache_symbol_assumption_names =
          __fname__cache_symbol_assumption_names;_}
        -> __fname__cache_symbol_name
let __proj__Mkcache_entry__item__cache_symbol_arg_sorts:
  cache_entry -> FStar_SMTEncoding_Term.sort Prims.list =
  fun projectee  ->
    match projectee with
    | { cache_symbol_name = __fname__cache_symbol_name;
        cache_symbol_arg_sorts = __fname__cache_symbol_arg_sorts;
        cache_symbol_decls = __fname__cache_symbol_decls;
        cache_symbol_assumption_names =
          __fname__cache_symbol_assumption_names;_}
        -> __fname__cache_symbol_arg_sorts
let __proj__Mkcache_entry__item__cache_symbol_decls:
  cache_entry -> FStar_SMTEncoding_Term.decl Prims.list =
  fun projectee  ->
    match projectee with
    | { cache_symbol_name = __fname__cache_symbol_name;
        cache_symbol_arg_sorts = __fname__cache_symbol_arg_sorts;
        cache_symbol_decls = __fname__cache_symbol_decls;
        cache_symbol_assumption_names =
          __fname__cache_symbol_assumption_names;_}
        -> __fname__cache_symbol_decls
let __proj__Mkcache_entry__item__cache_symbol_assumption_names:
  cache_entry -> Prims.string Prims.list =
  fun projectee  ->
    match projectee with
    | { cache_symbol_name = __fname__cache_symbol_name;
        cache_symbol_arg_sorts = __fname__cache_symbol_arg_sorts;
        cache_symbol_decls = __fname__cache_symbol_decls;
        cache_symbol_assumption_names =
          __fname__cache_symbol_assumption_names;_}
        -> __fname__cache_symbol_assumption_names
type env_t =
  {
  bindings: binding Prims.list;
  depth: Prims.int;
  tcenv: FStar_TypeChecker_Env.env;
  warn: Prims.bool;
  cache: cache_entry FStar_Util.smap;
  nolabels: Prims.bool;
  use_zfuel_name: Prims.bool;
  encode_non_total_function_typ: Prims.bool;
  current_module_name: Prims.string;}[@@deriving show]
let __proj__Mkenv_t__item__bindings: env_t -> binding Prims.list =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__bindings
let __proj__Mkenv_t__item__depth: env_t -> Prims.int =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__depth
let __proj__Mkenv_t__item__tcenv: env_t -> FStar_TypeChecker_Env.env =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__tcenv
let __proj__Mkenv_t__item__warn: env_t -> Prims.bool =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__warn
let __proj__Mkenv_t__item__cache: env_t -> cache_entry FStar_Util.smap =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__cache
let __proj__Mkenv_t__item__nolabels: env_t -> Prims.bool =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__nolabels
let __proj__Mkenv_t__item__use_zfuel_name: env_t -> Prims.bool =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__use_zfuel_name
let __proj__Mkenv_t__item__encode_non_total_function_typ: env_t -> Prims.bool
  =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__encode_non_total_function_typ
let __proj__Mkenv_t__item__current_module_name: env_t -> Prims.string =
  fun projectee  ->
    match projectee with
    | { bindings = __fname__bindings; depth = __fname__depth;
        tcenv = __fname__tcenv; warn = __fname__warn; cache = __fname__cache;
        nolabels = __fname__nolabels;
        use_zfuel_name = __fname__use_zfuel_name;
        encode_non_total_function_typ =
          __fname__encode_non_total_function_typ;
        current_module_name = __fname__current_module_name;_} ->
        __fname__current_module_name
let mk_cache_entry:
  'Auu____2387 .
    'Auu____2387 ->
      Prims.string ->
        FStar_SMTEncoding_Term.sort Prims.list ->
          FStar_SMTEncoding_Term.decl Prims.list -> cache_entry
  =
  fun env  ->
    fun tsym  ->
      fun cvar_sorts  ->
        fun t_decls  ->
          let names1 =
            FStar_All.pipe_right t_decls
              (FStar_List.collect
                 (fun uu___78_2421  ->
                    match uu___78_2421 with
                    | FStar_SMTEncoding_Term.Assume a ->
                        [a.FStar_SMTEncoding_Term.assumption_name]
                    | uu____2425 -> [])) in
          {
            cache_symbol_name = tsym;
            cache_symbol_arg_sorts = cvar_sorts;
            cache_symbol_decls = t_decls;
            cache_symbol_assumption_names = names1
          }
let use_cache_entry: cache_entry -> FStar_SMTEncoding_Term.decl Prims.list =
  fun ce  ->
    [FStar_SMTEncoding_Term.RetainAssumptions
       (ce.cache_symbol_assumption_names)]
let print_env: env_t -> Prims.string =
  fun e  ->
    let uu____2434 =
      FStar_All.pipe_right e.bindings
        (FStar_List.map
           (fun uu___79_2444  ->
              match uu___79_2444 with
              | Binding_var (x,uu____2446) ->
                  FStar_Syntax_Print.bv_to_string x
              | Binding_fvar (l,uu____2448,uu____2449,uu____2450) ->
                  FStar_Syntax_Print.lid_to_string l)) in
    FStar_All.pipe_right uu____2434 (FStar_String.concat ", ")
let lookup_binding:
  'Auu____2464 .
    env_t ->
      (binding -> 'Auu____2464 FStar_Pervasives_Native.option) ->
        'Auu____2464 FStar_Pervasives_Native.option
  = fun env  -> fun f  -> FStar_Util.find_map env.bindings f
let caption_t:
  env_t ->
    FStar_Syntax_Syntax.term -> Prims.string FStar_Pervasives_Native.option
  =
  fun env  ->
    fun t  ->
      let uu____2492 =
        FStar_TypeChecker_Env.debug env.tcenv FStar_Options.Low in
      if uu____2492
      then
        let uu____2495 = FStar_Syntax_Print.term_to_string t in
        FStar_Pervasives_Native.Some uu____2495
      else FStar_Pervasives_Native.None
let fresh_fvar:
  Prims.string ->
    FStar_SMTEncoding_Term.sort ->
      (Prims.string,FStar_SMTEncoding_Term.term)
        FStar_Pervasives_Native.tuple2
  =
  fun x  ->
    fun s  ->
      let xsym = varops.fresh x in
      let uu____2508 = FStar_SMTEncoding_Util.mkFreeV (xsym, s) in
      (xsym, uu____2508)
let gen_term_var:
  env_t ->
    FStar_Syntax_Syntax.bv ->
      (Prims.string,FStar_SMTEncoding_Term.term,env_t)
        FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun x  ->
      let ysym = Prims.strcat "@x" (Prims.string_of_int env.depth) in
      let y =
        FStar_SMTEncoding_Util.mkFreeV
          (ysym, FStar_SMTEncoding_Term.Term_sort) in
      (ysym, y,
        (let uu___102_2524 = env in
         {
           bindings = ((Binding_var (x, y)) :: (env.bindings));
           depth = (env.depth + (Prims.parse_int "1"));
           tcenv = (uu___102_2524.tcenv);
           warn = (uu___102_2524.warn);
           cache = (uu___102_2524.cache);
           nolabels = (uu___102_2524.nolabels);
           use_zfuel_name = (uu___102_2524.use_zfuel_name);
           encode_non_total_function_typ =
             (uu___102_2524.encode_non_total_function_typ);
           current_module_name = (uu___102_2524.current_module_name)
         }))
let new_term_constant:
  env_t ->
    FStar_Syntax_Syntax.bv ->
      (Prims.string,FStar_SMTEncoding_Term.term,env_t)
        FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun x  ->
      let ysym =
        varops.new_var x.FStar_Syntax_Syntax.ppname
          x.FStar_Syntax_Syntax.index in
      let y = FStar_SMTEncoding_Util.mkApp (ysym, []) in
      (ysym, y,
        (let uu___103_2542 = env in
         {
           bindings = ((Binding_var (x, y)) :: (env.bindings));
           depth = (uu___103_2542.depth);
           tcenv = (uu___103_2542.tcenv);
           warn = (uu___103_2542.warn);
           cache = (uu___103_2542.cache);
           nolabels = (uu___103_2542.nolabels);
           use_zfuel_name = (uu___103_2542.use_zfuel_name);
           encode_non_total_function_typ =
             (uu___103_2542.encode_non_total_function_typ);
           current_module_name = (uu___103_2542.current_module_name)
         }))
let new_term_constant_from_string:
  env_t ->
    FStar_Syntax_Syntax.bv ->
      Prims.string ->
        (Prims.string,FStar_SMTEncoding_Term.term,env_t)
          FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun x  ->
      fun str  ->
        let ysym = varops.mk_unique str in
        let y = FStar_SMTEncoding_Util.mkApp (ysym, []) in
        (ysym, y,
          (let uu___104_2563 = env in
           {
             bindings = ((Binding_var (x, y)) :: (env.bindings));
             depth = (uu___104_2563.depth);
             tcenv = (uu___104_2563.tcenv);
             warn = (uu___104_2563.warn);
             cache = (uu___104_2563.cache);
             nolabels = (uu___104_2563.nolabels);
             use_zfuel_name = (uu___104_2563.use_zfuel_name);
             encode_non_total_function_typ =
               (uu___104_2563.encode_non_total_function_typ);
             current_module_name = (uu___104_2563.current_module_name)
           }))
let push_term_var:
  env_t -> FStar_Syntax_Syntax.bv -> FStar_SMTEncoding_Term.term -> env_t =
  fun env  ->
    fun x  ->
      fun t  ->
        let uu___105_2573 = env in
        {
          bindings = ((Binding_var (x, t)) :: (env.bindings));
          depth = (uu___105_2573.depth);
          tcenv = (uu___105_2573.tcenv);
          warn = (uu___105_2573.warn);
          cache = (uu___105_2573.cache);
          nolabels = (uu___105_2573.nolabels);
          use_zfuel_name = (uu___105_2573.use_zfuel_name);
          encode_non_total_function_typ =
            (uu___105_2573.encode_non_total_function_typ);
          current_module_name = (uu___105_2573.current_module_name)
        }
let lookup_term_var:
  env_t -> FStar_Syntax_Syntax.bv -> FStar_SMTEncoding_Term.term =
  fun env  ->
    fun a  ->
      let aux a' =
        lookup_binding env
          (fun uu___80_2597  ->
             match uu___80_2597 with
             | Binding_var (b,t) when FStar_Syntax_Syntax.bv_eq b a' ->
                 FStar_Pervasives_Native.Some (b, t)
             | uu____2610 -> FStar_Pervasives_Native.None) in
      let uu____2615 = aux a in
      match uu____2615 with
      | FStar_Pervasives_Native.None  ->
          let a2 = unmangle a in
          let uu____2627 = aux a2 in
          (match uu____2627 with
           | FStar_Pervasives_Native.None  ->
               let uu____2638 =
                 let uu____2639 = FStar_Syntax_Print.bv_to_string a2 in
                 let uu____2640 = print_env env in
                 FStar_Util.format2
                   "Bound term variable not found (after unmangling): %s in environment: %s"
                   uu____2639 uu____2640 in
               failwith uu____2638
           | FStar_Pervasives_Native.Some (b,t) -> t)
      | FStar_Pervasives_Native.Some (b,t) -> t
let new_term_constant_and_tok_from_lid:
  env_t ->
    FStar_Ident.lident ->
      (Prims.string,Prims.string,env_t) FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun x  ->
      let fname = varops.new_fvar x in
      let ftok = Prims.strcat fname "@tok" in
      let uu____2667 =
        let uu___106_2668 = env in
        let uu____2669 =
          let uu____2672 =
            let uu____2673 =
              let uu____2686 =
                let uu____2689 = FStar_SMTEncoding_Util.mkApp (ftok, []) in
                FStar_All.pipe_left
                  (fun _0_40  -> FStar_Pervasives_Native.Some _0_40)
                  uu____2689 in
              (x, fname, uu____2686, FStar_Pervasives_Native.None) in
            Binding_fvar uu____2673 in
          uu____2672 :: (env.bindings) in
        {
          bindings = uu____2669;
          depth = (uu___106_2668.depth);
          tcenv = (uu___106_2668.tcenv);
          warn = (uu___106_2668.warn);
          cache = (uu___106_2668.cache);
          nolabels = (uu___106_2668.nolabels);
          use_zfuel_name = (uu___106_2668.use_zfuel_name);
          encode_non_total_function_typ =
            (uu___106_2668.encode_non_total_function_typ);
          current_module_name = (uu___106_2668.current_module_name)
        } in
      (fname, ftok, uu____2667)
let try_lookup_lid:
  env_t ->
    FStar_Ident.lident ->
      (Prims.string,FStar_SMTEncoding_Term.term
                      FStar_Pervasives_Native.option,FStar_SMTEncoding_Term.term
                                                       FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple3 FStar_Pervasives_Native.option
  =
  fun env  ->
    fun a  ->
      lookup_binding env
        (fun uu___81_2731  ->
           match uu___81_2731 with
           | Binding_fvar (b,t1,t2,t3) when FStar_Ident.lid_equals b a ->
               FStar_Pervasives_Native.Some (t1, t2, t3)
           | uu____2770 -> FStar_Pervasives_Native.None)
let contains_name: env_t -> Prims.string -> Prims.bool =
  fun env  ->
    fun s  ->
      let uu____2787 =
        lookup_binding env
          (fun uu___82_2795  ->
             match uu___82_2795 with
             | Binding_fvar (b,t1,t2,t3) when b.FStar_Ident.str = s ->
                 FStar_Pervasives_Native.Some ()
             | uu____2810 -> FStar_Pervasives_Native.None) in
      FStar_All.pipe_right uu____2787 FStar_Option.isSome
let lookup_lid:
  env_t ->
    FStar_Ident.lident ->
      (Prims.string,FStar_SMTEncoding_Term.term
                      FStar_Pervasives_Native.option,FStar_SMTEncoding_Term.term
                                                       FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun a  ->
      let uu____2829 = try_lookup_lid env a in
      match uu____2829 with
      | FStar_Pervasives_Native.None  ->
          let uu____2862 =
            let uu____2863 = FStar_Syntax_Print.lid_to_string a in
            FStar_Util.format1 "Name not found: %s" uu____2863 in
          failwith uu____2862
      | FStar_Pervasives_Native.Some s -> s
let push_free_var:
  env_t ->
    FStar_Ident.lident ->
      Prims.string ->
        FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option -> env_t
  =
  fun env  ->
    fun x  ->
      fun fname  ->
        fun ftok  ->
          let uu___107_2911 = env in
          {
            bindings =
              ((Binding_fvar (x, fname, ftok, FStar_Pervasives_Native.None))
              :: (env.bindings));
            depth = (uu___107_2911.depth);
            tcenv = (uu___107_2911.tcenv);
            warn = (uu___107_2911.warn);
            cache = (uu___107_2911.cache);
            nolabels = (uu___107_2911.nolabels);
            use_zfuel_name = (uu___107_2911.use_zfuel_name);
            encode_non_total_function_typ =
              (uu___107_2911.encode_non_total_function_typ);
            current_module_name = (uu___107_2911.current_module_name)
          }
let push_zfuel_name: env_t -> FStar_Ident.lident -> Prims.string -> env_t =
  fun env  ->
    fun x  ->
      fun f  ->
        let uu____2925 = lookup_lid env x in
        match uu____2925 with
        | (t1,t2,uu____2938) ->
            let t3 =
              let uu____2948 =
                let uu____2955 =
                  let uu____2958 = FStar_SMTEncoding_Util.mkApp ("ZFuel", []) in
                  [uu____2958] in
                (f, uu____2955) in
              FStar_SMTEncoding_Util.mkApp uu____2948 in
            let uu___108_2963 = env in
            {
              bindings =
                ((Binding_fvar (x, t1, t2, (FStar_Pervasives_Native.Some t3)))
                :: (env.bindings));
              depth = (uu___108_2963.depth);
              tcenv = (uu___108_2963.tcenv);
              warn = (uu___108_2963.warn);
              cache = (uu___108_2963.cache);
              nolabels = (uu___108_2963.nolabels);
              use_zfuel_name = (uu___108_2963.use_zfuel_name);
              encode_non_total_function_typ =
                (uu___108_2963.encode_non_total_function_typ);
              current_module_name = (uu___108_2963.current_module_name)
            }
let try_lookup_free_var:
  env_t ->
    FStar_Ident.lident ->
      FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option
  =
  fun env  ->
    fun l  ->
      let uu____2976 = try_lookup_lid env l in
      match uu____2976 with
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
      | FStar_Pervasives_Native.Some (name,sym,zf_opt) ->
          (match zf_opt with
           | FStar_Pervasives_Native.Some f when env.use_zfuel_name ->
               FStar_Pervasives_Native.Some f
           | uu____3025 ->
               (match sym with
                | FStar_Pervasives_Native.Some t ->
                    (match t.FStar_SMTEncoding_Term.tm with
                     | FStar_SMTEncoding_Term.App (uu____3033,fuel::[]) ->
                         let uu____3037 =
                           let uu____3038 =
                             let uu____3039 =
                               FStar_SMTEncoding_Term.fv_of_term fuel in
                             FStar_All.pipe_right uu____3039
                               FStar_Pervasives_Native.fst in
                           FStar_Util.starts_with uu____3038 "fuel" in
                         if uu____3037
                         then
                           let uu____3042 =
                             let uu____3043 =
                               FStar_SMTEncoding_Util.mkFreeV
                                 (name, FStar_SMTEncoding_Term.Term_sort) in
                             FStar_SMTEncoding_Term.mk_ApplyTF uu____3043
                               fuel in
                           FStar_All.pipe_left
                             (fun _0_41  ->
                                FStar_Pervasives_Native.Some _0_41)
                             uu____3042
                         else FStar_Pervasives_Native.Some t
                     | uu____3047 -> FStar_Pervasives_Native.Some t)
                | uu____3048 -> FStar_Pervasives_Native.None))
let lookup_free_var:
  env_t ->
    FStar_Ident.lident FStar_Syntax_Syntax.withinfo_t ->
      FStar_SMTEncoding_Term.term
  =
  fun env  ->
    fun a  ->
      let uu____3061 = try_lookup_free_var env a.FStar_Syntax_Syntax.v in
      match uu____3061 with
      | FStar_Pervasives_Native.Some t -> t
      | FStar_Pervasives_Native.None  ->
          let uu____3065 =
            let uu____3066 =
              FStar_Syntax_Print.lid_to_string a.FStar_Syntax_Syntax.v in
            FStar_Util.format1 "Name not found: %s" uu____3066 in
          failwith uu____3065
let lookup_free_var_name:
  env_t -> FStar_Ident.lident FStar_Syntax_Syntax.withinfo_t -> Prims.string
  =
  fun env  ->
    fun a  ->
      let uu____3077 = lookup_lid env a.FStar_Syntax_Syntax.v in
      match uu____3077 with | (x,uu____3089,uu____3090) -> x
let lookup_free_var_sym:
  env_t ->
    FStar_Ident.lident FStar_Syntax_Syntax.withinfo_t ->
      (FStar_SMTEncoding_Term.op,FStar_SMTEncoding_Term.term Prims.list)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun a  ->
      let uu____3115 = lookup_lid env a.FStar_Syntax_Syntax.v in
      match uu____3115 with
      | (name,sym,zf_opt) ->
          (match zf_opt with
           | FStar_Pervasives_Native.Some
               {
                 FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.App
                   (g,zf);
                 FStar_SMTEncoding_Term.freevars = uu____3151;
                 FStar_SMTEncoding_Term.rng = uu____3152;_}
               when env.use_zfuel_name -> (g, zf)
           | uu____3167 ->
               (match sym with
                | FStar_Pervasives_Native.None  ->
                    ((FStar_SMTEncoding_Term.Var name), [])
                | FStar_Pervasives_Native.Some sym1 ->
                    (match sym1.FStar_SMTEncoding_Term.tm with
                     | FStar_SMTEncoding_Term.App (g,fuel::[]) -> (g, [fuel])
                     | uu____3191 -> ((FStar_SMTEncoding_Term.Var name), []))))
let tok_of_name:
  env_t ->
    Prims.string ->
      FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option
  =
  fun env  ->
    fun nm  ->
      FStar_Util.find_map env.bindings
        (fun uu___83_3207  ->
           match uu___83_3207 with
           | Binding_fvar (uu____3210,nm',tok,uu____3213) when nm = nm' ->
               tok
           | uu____3222 -> FStar_Pervasives_Native.None)
let mkForall_fuel':
  'Auu____3226 .
    'Auu____3226 ->
      (FStar_SMTEncoding_Term.pat Prims.list Prims.list,FStar_SMTEncoding_Term.fvs,
        FStar_SMTEncoding_Term.term) FStar_Pervasives_Native.tuple3 ->
        FStar_SMTEncoding_Term.term
  =
  fun n1  ->
    fun uu____3244  ->
      match uu____3244 with
      | (pats,vars,body) ->
          let fallback uu____3269 =
            FStar_SMTEncoding_Util.mkForall (pats, vars, body) in
          let uu____3274 = FStar_Options.unthrottle_inductives () in
          if uu____3274
          then fallback ()
          else
            (let uu____3276 = fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort in
             match uu____3276 with
             | (fsym,fterm) ->
                 let add_fuel1 tms =
                   FStar_All.pipe_right tms
                     (FStar_List.map
                        (fun p  ->
                           match p.FStar_SMTEncoding_Term.tm with
                           | FStar_SMTEncoding_Term.App
                               (FStar_SMTEncoding_Term.Var "HasType",args) ->
                               FStar_SMTEncoding_Util.mkApp
                                 ("HasTypeFuel", (fterm :: args))
                           | uu____3307 -> p)) in
                 let pats1 = FStar_List.map add_fuel1 pats in
                 let body1 =
                   match body.FStar_SMTEncoding_Term.tm with
                   | FStar_SMTEncoding_Term.App
                       (FStar_SMTEncoding_Term.Imp ,guard::body'::[]) ->
                       let guard1 =
                         match guard.FStar_SMTEncoding_Term.tm with
                         | FStar_SMTEncoding_Term.App
                             (FStar_SMTEncoding_Term.And ,guards) ->
                             let uu____3328 = add_fuel1 guards in
                             FStar_SMTEncoding_Util.mk_and_l uu____3328
                         | uu____3331 ->
                             let uu____3332 = add_fuel1 [guard] in
                             FStar_All.pipe_right uu____3332 FStar_List.hd in
                       FStar_SMTEncoding_Util.mkImp (guard1, body')
                   | uu____3337 -> body in
                 let vars1 = (fsym, FStar_SMTEncoding_Term.Fuel_sort) :: vars in
                 FStar_SMTEncoding_Util.mkForall (pats1, vars1, body1))
let mkForall_fuel:
  (FStar_SMTEncoding_Term.pat Prims.list Prims.list,FStar_SMTEncoding_Term.fvs,
    FStar_SMTEncoding_Term.term) FStar_Pervasives_Native.tuple3 ->
    FStar_SMTEncoding_Term.term
  = mkForall_fuel' (Prims.parse_int "1")
let head_normal: env_t -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun env  ->
    fun t  ->
      let t1 = FStar_Syntax_Util.unmeta t in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_arrow uu____3378 -> true
      | FStar_Syntax_Syntax.Tm_refine uu____3391 -> true
      | FStar_Syntax_Syntax.Tm_bvar uu____3398 -> true
      | FStar_Syntax_Syntax.Tm_uvar uu____3399 -> true
      | FStar_Syntax_Syntax.Tm_abs uu____3416 -> true
      | FStar_Syntax_Syntax.Tm_constant uu____3433 -> true
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let uu____3435 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Eager_unfolding_only] env.tcenv
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          FStar_All.pipe_right uu____3435 FStar_Option.isNone
      | FStar_Syntax_Syntax.Tm_app
          ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
             FStar_Syntax_Syntax.pos = uu____3453;
             FStar_Syntax_Syntax.vars = uu____3454;_},uu____3455)
          ->
          let uu____3476 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Eager_unfolding_only] env.tcenv
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          FStar_All.pipe_right uu____3476 FStar_Option.isNone
      | uu____3493 -> false
let head_redex: env_t -> FStar_Syntax_Syntax.term -> Prims.bool =
  fun env  ->
    fun t  ->
      let uu____3500 =
        let uu____3501 = FStar_Syntax_Util.un_uinst t in
        uu____3501.FStar_Syntax_Syntax.n in
      match uu____3500 with
      | FStar_Syntax_Syntax.Tm_abs
          (uu____3504,uu____3505,FStar_Pervasives_Native.Some rc) ->
          ((FStar_Ident.lid_equals rc.FStar_Syntax_Syntax.residual_effect
              FStar_Parser_Const.effect_Tot_lid)
             ||
             (FStar_Ident.lid_equals rc.FStar_Syntax_Syntax.residual_effect
                FStar_Parser_Const.effect_GTot_lid))
            ||
            (FStar_List.existsb
               (fun uu___84_3526  ->
                  match uu___84_3526 with
                  | FStar_Syntax_Syntax.TOTAL  -> true
                  | uu____3527 -> false)
               rc.FStar_Syntax_Syntax.residual_flags)
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let uu____3529 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Eager_unfolding_only] env.tcenv
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          FStar_All.pipe_right uu____3529 FStar_Option.isSome
      | uu____3546 -> false
let whnf: env_t -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun env  ->
    fun t  ->
      let uu____3553 = head_normal env t in
      if uu____3553
      then t
      else
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Normalize.Beta;
          FStar_TypeChecker_Normalize.Weak;
          FStar_TypeChecker_Normalize.HNF;
          FStar_TypeChecker_Normalize.Exclude
            FStar_TypeChecker_Normalize.Zeta;
          FStar_TypeChecker_Normalize.Eager_unfolding;
          FStar_TypeChecker_Normalize.EraseUniverses] env.tcenv t
let norm: env_t -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun env  ->
    fun t  ->
      FStar_TypeChecker_Normalize.normalize
        [FStar_TypeChecker_Normalize.Beta;
        FStar_TypeChecker_Normalize.Exclude FStar_TypeChecker_Normalize.Zeta;
        FStar_TypeChecker_Normalize.Eager_unfolding;
        FStar_TypeChecker_Normalize.EraseUniverses] env.tcenv t
let trivial_post: FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term =
  fun t  ->
    let uu____3564 =
      let uu____3565 = FStar_Syntax_Syntax.null_binder t in [uu____3565] in
    let uu____3566 =
      FStar_Syntax_Syntax.fvar FStar_Parser_Const.true_lid
        FStar_Syntax_Syntax.Delta_constant FStar_Pervasives_Native.None in
    FStar_Syntax_Util.abs uu____3564 uu____3566 FStar_Pervasives_Native.None
let mk_Apply:
  FStar_SMTEncoding_Term.term ->
    (Prims.string,FStar_SMTEncoding_Term.sort) FStar_Pervasives_Native.tuple2
      Prims.list -> FStar_SMTEncoding_Term.term
  =
  fun e  ->
    fun vars  ->
      FStar_All.pipe_right vars
        (FStar_List.fold_left
           (fun out  ->
              fun var  ->
                match FStar_Pervasives_Native.snd var with
                | FStar_SMTEncoding_Term.Fuel_sort  ->
                    let uu____3604 = FStar_SMTEncoding_Util.mkFreeV var in
                    FStar_SMTEncoding_Term.mk_ApplyTF out uu____3604
                | s ->
                    let uu____3609 = FStar_SMTEncoding_Util.mkFreeV var in
                    FStar_SMTEncoding_Util.mk_ApplyTT out uu____3609) e)
let mk_Apply_args:
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term
  =
  fun e  ->
    fun args  ->
      FStar_All.pipe_right args
        (FStar_List.fold_left FStar_SMTEncoding_Util.mk_ApplyTT e)
let is_app: FStar_SMTEncoding_Term.op -> Prims.bool =
  fun uu___85_3624  ->
    match uu___85_3624 with
    | FStar_SMTEncoding_Term.Var "ApplyTT" -> true
    | FStar_SMTEncoding_Term.Var "ApplyTF" -> true
    | uu____3625 -> false
let is_an_eta_expansion:
  env_t ->
    FStar_SMTEncoding_Term.fv Prims.list ->
      FStar_SMTEncoding_Term.term ->
        FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option
  =
  fun env  ->
    fun vars  ->
      fun body  ->
        let rec check_partial_applications t xs =
          match ((t.FStar_SMTEncoding_Term.tm), xs) with
          | (FStar_SMTEncoding_Term.App
             (app,f::{
                       FStar_SMTEncoding_Term.tm =
                         FStar_SMTEncoding_Term.FreeV y;
                       FStar_SMTEncoding_Term.freevars = uu____3661;
                       FStar_SMTEncoding_Term.rng = uu____3662;_}::[]),x::xs1)
              when (is_app app) && (FStar_SMTEncoding_Term.fv_eq x y) ->
              check_partial_applications f xs1
          | (FStar_SMTEncoding_Term.App
             (FStar_SMTEncoding_Term.Var f,args),uu____3685) ->
              let uu____3694 =
                ((FStar_List.length args) = (FStar_List.length xs)) &&
                  (FStar_List.forall2
                     (fun a  ->
                        fun v1  ->
                          match a.FStar_SMTEncoding_Term.tm with
                          | FStar_SMTEncoding_Term.FreeV fv ->
                              FStar_SMTEncoding_Term.fv_eq fv v1
                          | uu____3705 -> false) args (FStar_List.rev xs)) in
              if uu____3694
              then tok_of_name env f
              else FStar_Pervasives_Native.None
          | (uu____3709,[]) ->
              let fvs = FStar_SMTEncoding_Term.free_variables t in
              let uu____3713 =
                FStar_All.pipe_right fvs
                  (FStar_List.for_all
                     (fun fv  ->
                        let uu____3717 =
                          FStar_Util.for_some
                            (FStar_SMTEncoding_Term.fv_eq fv) vars in
                        Prims.op_Negation uu____3717)) in
              if uu____3713
              then FStar_Pervasives_Native.Some t
              else FStar_Pervasives_Native.None
          | uu____3721 -> FStar_Pervasives_Native.None in
        check_partial_applications body (FStar_List.rev vars)
type label =
  (FStar_SMTEncoding_Term.fv,Prims.string,FStar_Range.range)
    FStar_Pervasives_Native.tuple3[@@deriving show]
type labels = label Prims.list[@@deriving show]
type pattern =
  {
  pat_vars:
    (FStar_Syntax_Syntax.bv,FStar_SMTEncoding_Term.fv)
      FStar_Pervasives_Native.tuple2 Prims.list;
  pat_term:
    Prims.unit ->
      (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
        FStar_Pervasives_Native.tuple2;
  guard: FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term;
  projections:
    FStar_SMTEncoding_Term.term ->
      (FStar_Syntax_Syntax.bv,FStar_SMTEncoding_Term.term)
        FStar_Pervasives_Native.tuple2 Prims.list;}[@@deriving show]
let __proj__Mkpattern__item__pat_vars:
  pattern ->
    (FStar_Syntax_Syntax.bv,FStar_SMTEncoding_Term.fv)
      FStar_Pervasives_Native.tuple2 Prims.list
  =
  fun projectee  ->
    match projectee with
    | { pat_vars = __fname__pat_vars; pat_term = __fname__pat_term;
        guard = __fname__guard; projections = __fname__projections;_} ->
        __fname__pat_vars
let __proj__Mkpattern__item__pat_term:
  pattern ->
    Prims.unit ->
      (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
        FStar_Pervasives_Native.tuple2
  =
  fun projectee  ->
    match projectee with
    | { pat_vars = __fname__pat_vars; pat_term = __fname__pat_term;
        guard = __fname__guard; projections = __fname__projections;_} ->
        __fname__pat_term
let __proj__Mkpattern__item__guard:
  pattern -> FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term =
  fun projectee  ->
    match projectee with
    | { pat_vars = __fname__pat_vars; pat_term = __fname__pat_term;
        guard = __fname__guard; projections = __fname__projections;_} ->
        __fname__guard
let __proj__Mkpattern__item__projections:
  pattern ->
    FStar_SMTEncoding_Term.term ->
      (FStar_Syntax_Syntax.bv,FStar_SMTEncoding_Term.term)
        FStar_Pervasives_Native.tuple2 Prims.list
  =
  fun projectee  ->
    match projectee with
    | { pat_vars = __fname__pat_vars; pat_term = __fname__pat_term;
        guard = __fname__guard; projections = __fname__projections;_} ->
        __fname__projections
exception Let_rec_unencodeable
let uu___is_Let_rec_unencodeable: Prims.exn -> Prims.bool =
  fun projectee  ->
    match projectee with
    | Let_rec_unencodeable  -> true
    | uu____3943 -> false
exception Inner_let_rec
let uu___is_Inner_let_rec: Prims.exn -> Prims.bool =
  fun projectee  ->
    match projectee with | Inner_let_rec  -> true | uu____3947 -> false
let as_function_typ:
  env_t ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term
  =
  fun env  ->
    fun t0  ->
      let rec aux norm1 t =
        let t1 = FStar_Syntax_Subst.compress t in
        match t1.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_arrow uu____3966 -> t1
        | FStar_Syntax_Syntax.Tm_refine uu____3979 ->
            let uu____3986 = FStar_Syntax_Util.unrefine t1 in
            aux true uu____3986
        | uu____3987 ->
            if norm1
            then let uu____3988 = whnf env t1 in aux false uu____3988
            else
              (let uu____3990 =
                 let uu____3991 =
                   FStar_Range.string_of_range t0.FStar_Syntax_Syntax.pos in
                 let uu____3992 = FStar_Syntax_Print.term_to_string t0 in
                 FStar_Util.format2 "(%s) Expected a function typ; got %s"
                   uu____3991 uu____3992 in
               failwith uu____3990) in
      aux true t0
let rec curried_arrow_formals_comp:
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.binders,FStar_Syntax_Syntax.comp)
      FStar_Pervasives_Native.tuple2
  =
  fun k  ->
    let k1 = FStar_Syntax_Subst.compress k in
    match k1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
        FStar_Syntax_Subst.open_comp bs c
    | FStar_Syntax_Syntax.Tm_refine (bv,uu____4024) ->
        curried_arrow_formals_comp bv.FStar_Syntax_Syntax.sort
    | uu____4029 ->
        let uu____4030 = FStar_Syntax_Syntax.mk_Total k1 in ([], uu____4030)
let is_arithmetic_primitive:
  'Auu____4044 .
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      'Auu____4044 Prims.list -> Prims.bool
  =
  fun head1  ->
    fun args  ->
      match ((head1.FStar_Syntax_Syntax.n), args) with
      | (FStar_Syntax_Syntax.Tm_fvar fv,uu____4064::uu____4065::[]) ->
          ((((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.op_Addition)
               ||
               (FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.op_Subtraction))
              ||
              (FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.op_Multiply))
             ||
             (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.op_Division))
            ||
            (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.op_Modulus)
      | (FStar_Syntax_Syntax.Tm_fvar fv,uu____4069::[]) ->
          FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.op_Minus
      | uu____4072 -> false
let isInteger: FStar_Syntax_Syntax.term' -> Prims.bool =
  fun tm  ->
    match tm with
    | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_int
        (n1,FStar_Pervasives_Native.None )) -> true
    | uu____4093 -> false
let getInteger: FStar_Syntax_Syntax.term' -> Prims.int =
  fun tm  ->
    match tm with
    | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_int
        (n1,FStar_Pervasives_Native.None )) -> FStar_Util.int_of_string n1
    | uu____4108 -> failwith "Expected an Integer term"
let is_BitVector_primitive:
  'Auu____4112 .
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,'Auu____4112)
        FStar_Pervasives_Native.tuple2 Prims.list -> Prims.bool
  =
  fun head1  ->
    fun args  ->
      match ((head1.FStar_Syntax_Syntax.n), args) with
      | (FStar_Syntax_Syntax.Tm_fvar
         fv,(sz_arg,uu____4151)::uu____4152::uu____4153::[]) ->
          (((((((((((FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.bv_and_lid)
                      ||
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.bv_xor_lid))
                     ||
                     (FStar_Syntax_Syntax.fv_eq_lid fv
                        FStar_Parser_Const.bv_or_lid))
                    ||
                    (FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.bv_add_lid))
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.bv_sub_lid))
                  ||
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.bv_shift_left_lid))
                 ||
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.bv_shift_right_lid))
                ||
                (FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.bv_udiv_lid))
               ||
               (FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.bv_mod_lid))
              ||
              (FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.bv_uext_lid))
             ||
             (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.bv_mul_lid))
            && (isInteger sz_arg.FStar_Syntax_Syntax.n)
      | (FStar_Syntax_Syntax.Tm_fvar fv,(sz_arg,uu____4204)::uu____4205::[])
          ->
          ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.nat_to_bv_lid)
             ||
             (FStar_Syntax_Syntax.fv_eq_lid fv
                FStar_Parser_Const.bv_to_nat_lid))
            && (isInteger sz_arg.FStar_Syntax_Syntax.n)
      | uu____4242 -> false
let rec encode_const:
  FStar_Const.sconst ->
    env_t ->
      (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decl Prims.list)
        FStar_Pervasives_Native.tuple2
  =
  fun c  ->
    fun env  ->
      match c with
      | FStar_Const.Const_unit  -> (FStar_SMTEncoding_Term.mk_Term_unit, [])
      | FStar_Const.Const_bool (true ) ->
          let uu____4461 =
            FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Util.mkTrue in
          (uu____4461, [])
      | FStar_Const.Const_bool (false ) ->
          let uu____4464 =
            FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Util.mkFalse in
          (uu____4464, [])
      | FStar_Const.Const_char c1 ->
          let uu____4468 =
            let uu____4469 =
              let uu____4476 =
                let uu____4479 =
                  let uu____4480 =
                    FStar_SMTEncoding_Util.mkInteger'
                      (FStar_Util.int_of_char c1) in
                  FStar_SMTEncoding_Term.boxInt uu____4480 in
                [uu____4479] in
              ("FStar.Char.__char_of_int", uu____4476) in
            FStar_SMTEncoding_Util.mkApp uu____4469 in
          (uu____4468, [])
      | FStar_Const.Const_int (i,FStar_Pervasives_Native.None ) ->
          let uu____4496 =
            let uu____4497 = FStar_SMTEncoding_Util.mkInteger i in
            FStar_SMTEncoding_Term.boxInt uu____4497 in
          (uu____4496, [])
      | FStar_Const.Const_int (repr,FStar_Pervasives_Native.Some sw) ->
          let syntax_term =
            FStar_ToSyntax_ToSyntax.desugar_machine_integer
              (env.tcenv).FStar_TypeChecker_Env.dsenv repr sw
              FStar_Range.dummyRange in
          encode_term syntax_term env
      | FStar_Const.Const_string (s,uu____4518) ->
          let uu____4519 = varops.string_const s in (uu____4519, [])
      | FStar_Const.Const_range uu____4522 ->
          let uu____4523 = FStar_SMTEncoding_Term.mk_Range_const () in
          (uu____4523, [])
      | FStar_Const.Const_effect  ->
          (FStar_SMTEncoding_Term.mk_Term_type, [])
      | c1 ->
          let uu____4529 =
            let uu____4530 = FStar_Syntax_Print.const_to_string c1 in
            FStar_Util.format1 "Unhandled constant: %s" uu____4530 in
          failwith uu____4529
and encode_binders:
  FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.binders ->
      env_t ->
        (FStar_SMTEncoding_Term.fv Prims.list,FStar_SMTEncoding_Term.term
                                                Prims.list,env_t,FStar_SMTEncoding_Term.decls_t,
          FStar_Syntax_Syntax.bv Prims.list) FStar_Pervasives_Native.tuple5
  =
  fun fuel_opt  ->
    fun bs  ->
      fun env  ->
        (let uu____4559 =
           FStar_TypeChecker_Env.debug env.tcenv FStar_Options.Low in
         if uu____4559
         then
           let uu____4560 = FStar_Syntax_Print.binders_to_string ", " bs in
           FStar_Util.print1 "Encoding binders %s\n" uu____4560
         else ());
        (let uu____4562 =
           FStar_All.pipe_right bs
             (FStar_List.fold_left
                (fun uu____4646  ->
                   fun b  ->
                     match uu____4646 with
                     | (vars,guards,env1,decls,names1) ->
                         let uu____4725 =
                           let x = unmangle (FStar_Pervasives_Native.fst b) in
                           let uu____4741 = gen_term_var env1 x in
                           match uu____4741 with
                           | (xxsym,xx,env') ->
                               let uu____4765 =
                                 let uu____4770 =
                                   norm env1 x.FStar_Syntax_Syntax.sort in
                                 encode_term_pred fuel_opt uu____4770 env1 xx in
                               (match uu____4765 with
                                | (guard_x_t,decls') ->
                                    ((xxsym,
                                       FStar_SMTEncoding_Term.Term_sort),
                                      guard_x_t, env', decls', x)) in
                         (match uu____4725 with
                          | (v1,g,env2,decls',n1) ->
                              ((v1 :: vars), (g :: guards), env2,
                                (FStar_List.append decls decls'), (n1 ::
                                names1)))) ([], [], env, [], [])) in
         match uu____4562 with
         | (vars,guards,env1,decls,names1) ->
             ((FStar_List.rev vars), (FStar_List.rev guards), env1, decls,
               (FStar_List.rev names1)))
and encode_term_pred:
  FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.typ ->
      env_t ->
        FStar_SMTEncoding_Term.term ->
          (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
            FStar_Pervasives_Native.tuple2
  =
  fun fuel_opt  ->
    fun t  ->
      fun env  ->
        fun e  ->
          let uu____4929 = encode_term t env in
          match uu____4929 with
          | (t1,decls) ->
              let uu____4940 =
                FStar_SMTEncoding_Term.mk_HasTypeWithFuel fuel_opt e t1 in
              (uu____4940, decls)
and encode_term_pred':
  FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.typ ->
      env_t ->
        FStar_SMTEncoding_Term.term ->
          (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
            FStar_Pervasives_Native.tuple2
  =
  fun fuel_opt  ->
    fun t  ->
      fun env  ->
        fun e  ->
          let uu____4951 = encode_term t env in
          match uu____4951 with
          | (t1,decls) ->
              (match fuel_opt with
               | FStar_Pervasives_Native.None  ->
                   let uu____4966 = FStar_SMTEncoding_Term.mk_HasTypeZ e t1 in
                   (uu____4966, decls)
               | FStar_Pervasives_Native.Some f ->
                   let uu____4968 =
                     FStar_SMTEncoding_Term.mk_HasTypeFuel f e t1 in
                   (uu____4968, decls))
and encode_arith_term:
  env_t ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.args ->
        (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
          FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun head1  ->
      fun args_e  ->
        let uu____4974 = encode_args args_e env in
        match uu____4974 with
        | (arg_tms,decls) ->
            let head_fv =
              match head1.FStar_Syntax_Syntax.n with
              | FStar_Syntax_Syntax.Tm_fvar fv -> fv
              | uu____4993 -> failwith "Impossible" in
            let unary arg_tms1 =
              let uu____5002 = FStar_List.hd arg_tms1 in
              FStar_SMTEncoding_Term.unboxInt uu____5002 in
            let binary arg_tms1 =
              let uu____5015 =
                let uu____5016 = FStar_List.hd arg_tms1 in
                FStar_SMTEncoding_Term.unboxInt uu____5016 in
              let uu____5017 =
                let uu____5018 =
                  let uu____5019 = FStar_List.tl arg_tms1 in
                  FStar_List.hd uu____5019 in
                FStar_SMTEncoding_Term.unboxInt uu____5018 in
              (uu____5015, uu____5017) in
            let mk_default uu____5025 =
              let uu____5026 =
                lookup_free_var_sym env head_fv.FStar_Syntax_Syntax.fv_name in
              match uu____5026 with
              | (fname,fuel_args) ->
                  FStar_SMTEncoding_Util.mkApp'
                    (fname, (FStar_List.append fuel_args arg_tms)) in
            let mk_l op mk_args ts =
              let uu____5077 = FStar_Options.smtencoding_l_arith_native () in
              if uu____5077
              then
                let uu____5078 = let uu____5079 = mk_args ts in op uu____5079 in
                FStar_All.pipe_right uu____5078 FStar_SMTEncoding_Term.boxInt
              else mk_default () in
            let mk_nl nm op ts =
              let uu____5108 = FStar_Options.smtencoding_nl_arith_wrapped () in
              if uu____5108
              then
                let uu____5109 = binary ts in
                match uu____5109 with
                | (t1,t2) ->
                    let uu____5116 =
                      FStar_SMTEncoding_Util.mkApp (nm, [t1; t2]) in
                    FStar_All.pipe_right uu____5116
                      FStar_SMTEncoding_Term.boxInt
              else
                (let uu____5120 =
                   FStar_Options.smtencoding_nl_arith_native () in
                 if uu____5120
                 then
                   let uu____5121 = op (binary ts) in
                   FStar_All.pipe_right uu____5121
                     FStar_SMTEncoding_Term.boxInt
                 else mk_default ()) in
            let add1 = mk_l FStar_SMTEncoding_Util.mkAdd binary in
            let sub1 = mk_l FStar_SMTEncoding_Util.mkSub binary in
            let minus = mk_l FStar_SMTEncoding_Util.mkMinus unary in
            let mul1 = mk_nl "_mul" FStar_SMTEncoding_Util.mkMul in
            let div1 = mk_nl "_div" FStar_SMTEncoding_Util.mkDiv in
            let modulus = mk_nl "_mod" FStar_SMTEncoding_Util.mkMod in
            let ops =
              [(FStar_Parser_Const.op_Addition, add1);
              (FStar_Parser_Const.op_Subtraction, sub1);
              (FStar_Parser_Const.op_Multiply, mul1);
              (FStar_Parser_Const.op_Division, div1);
              (FStar_Parser_Const.op_Modulus, modulus);
              (FStar_Parser_Const.op_Minus, minus)] in
            let uu____5252 =
              let uu____5261 =
                FStar_List.tryFind
                  (fun uu____5283  ->
                     match uu____5283 with
                     | (l,uu____5293) ->
                         FStar_Syntax_Syntax.fv_eq_lid head_fv l) ops in
              FStar_All.pipe_right uu____5261 FStar_Util.must in
            (match uu____5252 with
             | (uu____5332,op) ->
                 let uu____5342 = op arg_tms in (uu____5342, decls))
and encode_BitVector_term:
  env_t ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.arg Prims.list ->
        (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decl Prims.list)
          FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun head1  ->
      fun args_e  ->
        let uu____5350 = FStar_List.hd args_e in
        match uu____5350 with
        | (tm_sz,uu____5358) ->
            let sz = getInteger tm_sz.FStar_Syntax_Syntax.n in
            let sz_key =
              FStar_Util.format1 "BitVector_%s" (Prims.string_of_int sz) in
            let sz_decls =
              let uu____5368 = FStar_Util.smap_try_find env.cache sz_key in
              match uu____5368 with
              | FStar_Pervasives_Native.Some cache_entry -> []
              | FStar_Pervasives_Native.None  ->
                  let t_decls = FStar_SMTEncoding_Term.mkBvConstructor sz in
                  ((let uu____5376 = mk_cache_entry env "" [] [] in
                    FStar_Util.smap_add env.cache sz_key uu____5376);
                   t_decls) in
            let uu____5377 =
              match ((head1.FStar_Syntax_Syntax.n), args_e) with
              | (FStar_Syntax_Syntax.Tm_fvar
                 fv,uu____5397::(sz_arg,uu____5399)::uu____5400::[]) when
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.bv_uext_lid)
                    && (isInteger sz_arg.FStar_Syntax_Syntax.n)
                  ->
                  let uu____5449 =
                    let uu____5452 = FStar_List.tail args_e in
                    FStar_List.tail uu____5452 in
                  let uu____5455 =
                    let uu____5458 = getInteger sz_arg.FStar_Syntax_Syntax.n in
                    FStar_Pervasives_Native.Some uu____5458 in
                  (uu____5449, uu____5455)
              | (FStar_Syntax_Syntax.Tm_fvar
                 fv,uu____5464::(sz_arg,uu____5466)::uu____5467::[]) when
                  FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.bv_uext_lid
                  ->
                  let uu____5516 =
                    let uu____5517 = FStar_Syntax_Print.term_to_string sz_arg in
                    FStar_Util.format1
                      "Not a constant bitvector extend size: %s" uu____5517 in
                  failwith uu____5516
              | uu____5526 ->
                  let uu____5533 = FStar_List.tail args_e in
                  (uu____5533, FStar_Pervasives_Native.None) in
            (match uu____5377 with
             | (arg_tms,ext_sz) ->
                 let uu____5556 = encode_args arg_tms env in
                 (match uu____5556 with
                  | (arg_tms1,decls) ->
                      let head_fv =
                        match head1.FStar_Syntax_Syntax.n with
                        | FStar_Syntax_Syntax.Tm_fvar fv -> fv
                        | uu____5577 -> failwith "Impossible" in
                      let unary arg_tms2 =
                        let uu____5586 = FStar_List.hd arg_tms2 in
                        FStar_SMTEncoding_Term.unboxBitVec sz uu____5586 in
                      let unary_arith arg_tms2 =
                        let uu____5595 = FStar_List.hd arg_tms2 in
                        FStar_SMTEncoding_Term.unboxInt uu____5595 in
                      let binary arg_tms2 =
                        let uu____5608 =
                          let uu____5609 = FStar_List.hd arg_tms2 in
                          FStar_SMTEncoding_Term.unboxBitVec sz uu____5609 in
                        let uu____5610 =
                          let uu____5611 =
                            let uu____5612 = FStar_List.tl arg_tms2 in
                            FStar_List.hd uu____5612 in
                          FStar_SMTEncoding_Term.unboxBitVec sz uu____5611 in
                        (uu____5608, uu____5610) in
                      let binary_arith arg_tms2 =
                        let uu____5627 =
                          let uu____5628 = FStar_List.hd arg_tms2 in
                          FStar_SMTEncoding_Term.unboxBitVec sz uu____5628 in
                        let uu____5629 =
                          let uu____5630 =
                            let uu____5631 = FStar_List.tl arg_tms2 in
                            FStar_List.hd uu____5631 in
                          FStar_SMTEncoding_Term.unboxInt uu____5630 in
                        (uu____5627, uu____5629) in
                      let mk_bv op mk_args resBox ts =
                        let uu____5680 =
                          let uu____5681 = mk_args ts in op uu____5681 in
                        FStar_All.pipe_right uu____5680 resBox in
                      let bv_and =
                        mk_bv FStar_SMTEncoding_Util.mkBvAnd binary
                          (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_xor =
                        mk_bv FStar_SMTEncoding_Util.mkBvXor binary
                          (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_or =
                        mk_bv FStar_SMTEncoding_Util.mkBvOr binary
                          (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_add =
                        mk_bv FStar_SMTEncoding_Util.mkBvAdd binary
                          (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_sub =
                        mk_bv FStar_SMTEncoding_Util.mkBvSub binary
                          (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_shl =
                        mk_bv (FStar_SMTEncoding_Util.mkBvShl sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_shr =
                        mk_bv (FStar_SMTEncoding_Util.mkBvShr sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_udiv =
                        mk_bv (FStar_SMTEncoding_Util.mkBvUdiv sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_mod =
                        mk_bv (FStar_SMTEncoding_Util.mkBvMod sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_mul =
                        mk_bv (FStar_SMTEncoding_Util.mkBvMul sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let bv_ult =
                        mk_bv FStar_SMTEncoding_Util.mkBvUlt binary
                          FStar_SMTEncoding_Term.boxBool in
                      let bv_uext arg_tms2 =
                        let uu____5789 =
                          let uu____5792 =
                            match ext_sz with
                            | FStar_Pervasives_Native.Some x -> x
                            | FStar_Pervasives_Native.None  ->
                                failwith "impossible" in
                          FStar_SMTEncoding_Util.mkBvUext uu____5792 in
                        let uu____5794 =
                          let uu____5797 =
                            let uu____5798 =
                              match ext_sz with
                              | FStar_Pervasives_Native.Some x -> x
                              | FStar_Pervasives_Native.None  ->
                                  failwith "impossible" in
                            sz + uu____5798 in
                          FStar_SMTEncoding_Term.boxBitVec uu____5797 in
                        mk_bv uu____5789 unary uu____5794 arg_tms2 in
                      let to_int1 =
                        mk_bv FStar_SMTEncoding_Util.mkBvToNat unary
                          FStar_SMTEncoding_Term.boxInt in
                      let bv_to =
                        mk_bv (FStar_SMTEncoding_Util.mkNatToBv sz)
                          unary_arith (FStar_SMTEncoding_Term.boxBitVec sz) in
                      let ops =
                        [(FStar_Parser_Const.bv_and_lid, bv_and);
                        (FStar_Parser_Const.bv_xor_lid, bv_xor);
                        (FStar_Parser_Const.bv_or_lid, bv_or);
                        (FStar_Parser_Const.bv_add_lid, bv_add);
                        (FStar_Parser_Const.bv_sub_lid, bv_sub);
                        (FStar_Parser_Const.bv_shift_left_lid, bv_shl);
                        (FStar_Parser_Const.bv_shift_right_lid, bv_shr);
                        (FStar_Parser_Const.bv_udiv_lid, bv_udiv);
                        (FStar_Parser_Const.bv_mod_lid, bv_mod);
                        (FStar_Parser_Const.bv_mul_lid, bv_mul);
                        (FStar_Parser_Const.bv_ult_lid, bv_ult);
                        (FStar_Parser_Const.bv_uext_lid, bv_uext);
                        (FStar_Parser_Const.bv_to_nat_lid, to_int1);
                        (FStar_Parser_Const.nat_to_bv_lid, bv_to)] in
                      let uu____5997 =
                        let uu____6006 =
                          FStar_List.tryFind
                            (fun uu____6028  ->
                               match uu____6028 with
                               | (l,uu____6038) ->
                                   FStar_Syntax_Syntax.fv_eq_lid head_fv l)
                            ops in
                        FStar_All.pipe_right uu____6006 FStar_Util.must in
                      (match uu____5997 with
                       | (uu____6079,op) ->
                           let uu____6089 = op arg_tms1 in
                           (uu____6089, (FStar_List.append sz_decls decls)))))
and encode_term:
  FStar_Syntax_Syntax.typ ->
    env_t ->
      (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
        FStar_Pervasives_Native.tuple2
  =
  fun t  ->
    fun env  ->
      let t0 = FStar_Syntax_Subst.compress t in
      (let uu____6100 =
         FStar_All.pipe_left (FStar_TypeChecker_Env.debug env.tcenv)
           (FStar_Options.Other "SMTEncoding") in
       if uu____6100
       then
         let uu____6101 = FStar_Syntax_Print.tag_of_term t in
         let uu____6102 = FStar_Syntax_Print.tag_of_term t0 in
         let uu____6103 = FStar_Syntax_Print.term_to_string t0 in
         FStar_Util.print3 "(%s) (%s)   %s\n" uu____6101 uu____6102
           uu____6103
       else ());
      (match t0.FStar_Syntax_Syntax.n with
       | FStar_Syntax_Syntax.Tm_delayed uu____6109 ->
           let uu____6134 =
             let uu____6135 =
               FStar_All.pipe_left FStar_Range.string_of_range
                 t.FStar_Syntax_Syntax.pos in
             let uu____6136 = FStar_Syntax_Print.tag_of_term t0 in
             let uu____6137 = FStar_Syntax_Print.term_to_string t0 in
             let uu____6138 = FStar_Syntax_Print.term_to_string t in
             FStar_Util.format4 "(%s) Impossible: %s\n%s\n%s\n" uu____6135
               uu____6136 uu____6137 uu____6138 in
           failwith uu____6134
       | FStar_Syntax_Syntax.Tm_unknown  ->
           let uu____6143 =
             let uu____6144 =
               FStar_All.pipe_left FStar_Range.string_of_range
                 t.FStar_Syntax_Syntax.pos in
             let uu____6145 = FStar_Syntax_Print.tag_of_term t0 in
             let uu____6146 = FStar_Syntax_Print.term_to_string t0 in
             let uu____6147 = FStar_Syntax_Print.term_to_string t in
             FStar_Util.format4 "(%s) Impossible: %s\n%s\n%s\n" uu____6144
               uu____6145 uu____6146 uu____6147 in
           failwith uu____6143
       | FStar_Syntax_Syntax.Tm_bvar x ->
           let uu____6153 =
             let uu____6154 = FStar_Syntax_Print.bv_to_string x in
             FStar_Util.format1 "Impossible: locally nameless; got %s"
               uu____6154 in
           failwith uu____6153
       | FStar_Syntax_Syntax.Tm_ascribed (t1,k,uu____6161) ->
           encode_term t1 env
       | FStar_Syntax_Syntax.Tm_meta
           ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_unknown ;
              FStar_Syntax_Syntax.pos = uu____6202;
              FStar_Syntax_Syntax.vars = uu____6203;_},FStar_Syntax_Syntax.Meta_alien
            (obj,desc,ty))
           ->
           let tsym =
             let uu____6220 = varops.fresh "t" in
             (uu____6220, FStar_SMTEncoding_Term.Term_sort) in
           let t1 = FStar_SMTEncoding_Util.mkFreeV tsym in
           let decl =
             let uu____6223 =
               let uu____6234 =
                 let uu____6237 = FStar_Util.format1 "alien term (%s)" desc in
                 FStar_Pervasives_Native.Some uu____6237 in
               ((FStar_Pervasives_Native.fst tsym), [],
                 FStar_SMTEncoding_Term.Term_sort, uu____6234) in
             FStar_SMTEncoding_Term.DeclFun uu____6223 in
           (t1, [decl])
       | FStar_Syntax_Syntax.Tm_meta (t1,uu____6245) -> encode_term t1 env
       | FStar_Syntax_Syntax.Tm_name x ->
           let t1 = lookup_term_var env x in (t1, [])
       | FStar_Syntax_Syntax.Tm_fvar v1 ->
           let uu____6255 =
             lookup_free_var env v1.FStar_Syntax_Syntax.fv_name in
           (uu____6255, [])
       | FStar_Syntax_Syntax.Tm_type uu____6258 ->
           (FStar_SMTEncoding_Term.mk_Term_type, [])
       | FStar_Syntax_Syntax.Tm_uinst (t1,uu____6262) -> encode_term t1 env
       | FStar_Syntax_Syntax.Tm_constant c -> encode_const c env
       | FStar_Syntax_Syntax.Tm_arrow (binders,c) ->
           let module_name = env.current_module_name in
           let uu____6287 = FStar_Syntax_Subst.open_comp binders c in
           (match uu____6287 with
            | (binders1,res) ->
                let uu____6298 =
                  (env.encode_non_total_function_typ &&
                     (FStar_Syntax_Util.is_pure_or_ghost_comp res))
                    || (FStar_Syntax_Util.is_tot_or_gtot_comp res) in
                if uu____6298
                then
                  let uu____6303 =
                    encode_binders FStar_Pervasives_Native.None binders1 env in
                  (match uu____6303 with
                   | (vars,guards,env',decls,uu____6328) ->
                       let fsym =
                         let uu____6346 = varops.fresh "f" in
                         (uu____6346, FStar_SMTEncoding_Term.Term_sort) in
                       let f = FStar_SMTEncoding_Util.mkFreeV fsym in
                       let app = mk_Apply f vars in
                       let uu____6349 =
                         FStar_TypeChecker_Util.pure_or_ghost_pre_and_post
                           (let uu___109_6358 = env.tcenv in
                            {
                              FStar_TypeChecker_Env.solver =
                                (uu___109_6358.FStar_TypeChecker_Env.solver);
                              FStar_TypeChecker_Env.range =
                                (uu___109_6358.FStar_TypeChecker_Env.range);
                              FStar_TypeChecker_Env.curmodule =
                                (uu___109_6358.FStar_TypeChecker_Env.curmodule);
                              FStar_TypeChecker_Env.gamma =
                                (uu___109_6358.FStar_TypeChecker_Env.gamma);
                              FStar_TypeChecker_Env.gamma_cache =
                                (uu___109_6358.FStar_TypeChecker_Env.gamma_cache);
                              FStar_TypeChecker_Env.modules =
                                (uu___109_6358.FStar_TypeChecker_Env.modules);
                              FStar_TypeChecker_Env.expected_typ =
                                (uu___109_6358.FStar_TypeChecker_Env.expected_typ);
                              FStar_TypeChecker_Env.sigtab =
                                (uu___109_6358.FStar_TypeChecker_Env.sigtab);
                              FStar_TypeChecker_Env.is_pattern =
                                (uu___109_6358.FStar_TypeChecker_Env.is_pattern);
                              FStar_TypeChecker_Env.instantiate_imp =
                                (uu___109_6358.FStar_TypeChecker_Env.instantiate_imp);
                              FStar_TypeChecker_Env.effects =
                                (uu___109_6358.FStar_TypeChecker_Env.effects);
                              FStar_TypeChecker_Env.generalize =
                                (uu___109_6358.FStar_TypeChecker_Env.generalize);
                              FStar_TypeChecker_Env.letrecs =
                                (uu___109_6358.FStar_TypeChecker_Env.letrecs);
                              FStar_TypeChecker_Env.top_level =
                                (uu___109_6358.FStar_TypeChecker_Env.top_level);
                              FStar_TypeChecker_Env.check_uvars =
                                (uu___109_6358.FStar_TypeChecker_Env.check_uvars);
                              FStar_TypeChecker_Env.use_eq =
                                (uu___109_6358.FStar_TypeChecker_Env.use_eq);
                              FStar_TypeChecker_Env.is_iface =
                                (uu___109_6358.FStar_TypeChecker_Env.is_iface);
                              FStar_TypeChecker_Env.admit =
                                (uu___109_6358.FStar_TypeChecker_Env.admit);
                              FStar_TypeChecker_Env.lax = true;
                              FStar_TypeChecker_Env.lax_universes =
                                (uu___109_6358.FStar_TypeChecker_Env.lax_universes);
                              FStar_TypeChecker_Env.failhard =
                                (uu___109_6358.FStar_TypeChecker_Env.failhard);
                              FStar_TypeChecker_Env.nosynth =
                                (uu___109_6358.FStar_TypeChecker_Env.nosynth);
                              FStar_TypeChecker_Env.tc_term =
                                (uu___109_6358.FStar_TypeChecker_Env.tc_term);
                              FStar_TypeChecker_Env.type_of =
                                (uu___109_6358.FStar_TypeChecker_Env.type_of);
                              FStar_TypeChecker_Env.universe_of =
                                (uu___109_6358.FStar_TypeChecker_Env.universe_of);
                              FStar_TypeChecker_Env.use_bv_sorts =
                                (uu___109_6358.FStar_TypeChecker_Env.use_bv_sorts);
                              FStar_TypeChecker_Env.qname_and_index =
                                (uu___109_6358.FStar_TypeChecker_Env.qname_and_index);
                              FStar_TypeChecker_Env.proof_ns =
                                (uu___109_6358.FStar_TypeChecker_Env.proof_ns);
                              FStar_TypeChecker_Env.synth =
                                (uu___109_6358.FStar_TypeChecker_Env.synth);
                              FStar_TypeChecker_Env.is_native_tactic =
                                (uu___109_6358.FStar_TypeChecker_Env.is_native_tactic);
                              FStar_TypeChecker_Env.identifier_info =
                                (uu___109_6358.FStar_TypeChecker_Env.identifier_info);
                              FStar_TypeChecker_Env.tc_hooks =
                                (uu___109_6358.FStar_TypeChecker_Env.tc_hooks);
                              FStar_TypeChecker_Env.dsenv =
                                (uu___109_6358.FStar_TypeChecker_Env.dsenv);
                              FStar_TypeChecker_Env.dep_graph =
                                (uu___109_6358.FStar_TypeChecker_Env.dep_graph)
                            }) res in
                       (match uu____6349 with
                        | (pre_opt,res_t) ->
                            let uu____6369 =
                              encode_term_pred FStar_Pervasives_Native.None
                                res_t env' app in
                            (match uu____6369 with
                             | (res_pred,decls') ->
                                 let uu____6380 =
                                   match pre_opt with
                                   | FStar_Pervasives_Native.None  ->
                                       let uu____6393 =
                                         FStar_SMTEncoding_Util.mk_and_l
                                           guards in
                                       (uu____6393, [])
                                   | FStar_Pervasives_Native.Some pre ->
                                       let uu____6397 =
                                         encode_formula pre env' in
                                       (match uu____6397 with
                                        | (guard,decls0) ->
                                            let uu____6410 =
                                              FStar_SMTEncoding_Util.mk_and_l
                                                (guard :: guards) in
                                            (uu____6410, decls0)) in
                                 (match uu____6380 with
                                  | (guards1,guard_decls) ->
                                      let t_interp =
                                        let uu____6422 =
                                          let uu____6433 =
                                            FStar_SMTEncoding_Util.mkImp
                                              (guards1, res_pred) in
                                          ([[app]], vars, uu____6433) in
                                        FStar_SMTEncoding_Util.mkForall
                                          uu____6422 in
                                      let cvars =
                                        let uu____6451 =
                                          FStar_SMTEncoding_Term.free_variables
                                            t_interp in
                                        FStar_All.pipe_right uu____6451
                                          (FStar_List.filter
                                             (fun uu____6465  ->
                                                match uu____6465 with
                                                | (x,uu____6471) ->
                                                    x <>
                                                      (FStar_Pervasives_Native.fst
                                                         fsym))) in
                                      let tkey =
                                        FStar_SMTEncoding_Util.mkForall
                                          ([], (fsym :: cvars), t_interp) in
                                      let tkey_hash =
                                        FStar_SMTEncoding_Term.hash_of_term
                                          tkey in
                                      let uu____6490 =
                                        FStar_Util.smap_try_find env.cache
                                          tkey_hash in
                                      (match uu____6490 with
                                       | FStar_Pervasives_Native.Some
                                           cache_entry ->
                                           let uu____6498 =
                                             let uu____6499 =
                                               let uu____6506 =
                                                 FStar_All.pipe_right cvars
                                                   (FStar_List.map
                                                      FStar_SMTEncoding_Util.mkFreeV) in
                                               ((cache_entry.cache_symbol_name),
                                                 uu____6506) in
                                             FStar_SMTEncoding_Util.mkApp
                                               uu____6499 in
                                           (uu____6498,
                                             (FStar_List.append decls
                                                (FStar_List.append decls'
                                                   (FStar_List.append
                                                      guard_decls
                                                      (use_cache_entry
                                                         cache_entry)))))
                                       | FStar_Pervasives_Native.None  ->
                                           let tsym =
                                             let uu____6526 =
                                               let uu____6527 =
                                                 FStar_Util.digest_of_string
                                                   tkey_hash in
                                               Prims.strcat "Tm_arrow_"
                                                 uu____6527 in
                                             varops.mk_unique uu____6526 in
                                           let cvar_sorts =
                                             FStar_List.map
                                               FStar_Pervasives_Native.snd
                                               cvars in
                                           let caption =
                                             let uu____6538 =
                                               FStar_Options.log_queries () in
                                             if uu____6538
                                             then
                                               let uu____6541 =
                                                 FStar_TypeChecker_Normalize.term_to_string
                                                   env.tcenv t0 in
                                               FStar_Pervasives_Native.Some
                                                 uu____6541
                                             else
                                               FStar_Pervasives_Native.None in
                                           let tdecl =
                                             FStar_SMTEncoding_Term.DeclFun
                                               (tsym, cvar_sorts,
                                                 FStar_SMTEncoding_Term.Term_sort,
                                                 caption) in
                                           let t1 =
                                             let uu____6549 =
                                               let uu____6556 =
                                                 FStar_List.map
                                                   FStar_SMTEncoding_Util.mkFreeV
                                                   cvars in
                                               (tsym, uu____6556) in
                                             FStar_SMTEncoding_Util.mkApp
                                               uu____6549 in
                                           let t_has_kind =
                                             FStar_SMTEncoding_Term.mk_HasType
                                               t1
                                               FStar_SMTEncoding_Term.mk_Term_type in
                                           let k_assumption =
                                             let a_name =
                                               Prims.strcat "kinding_" tsym in
                                             let uu____6568 =
                                               let uu____6575 =
                                                 FStar_SMTEncoding_Util.mkForall
                                                   ([[t_has_kind]], cvars,
                                                     t_has_kind) in
                                               (uu____6575,
                                                 (FStar_Pervasives_Native.Some
                                                    a_name), a_name) in
                                             FStar_SMTEncoding_Util.mkAssume
                                               uu____6568 in
                                           let f_has_t =
                                             FStar_SMTEncoding_Term.mk_HasType
                                               f t1 in
                                           let f_has_t_z =
                                             FStar_SMTEncoding_Term.mk_HasTypeZ
                                               f t1 in
                                           let pre_typing =
                                             let a_name =
                                               Prims.strcat "pre_typing_"
                                                 tsym in
                                             let uu____6596 =
                                               let uu____6603 =
                                                 let uu____6604 =
                                                   let uu____6615 =
                                                     let uu____6616 =
                                                       let uu____6621 =
                                                         let uu____6622 =
                                                           FStar_SMTEncoding_Term.mk_PreType
                                                             f in
                                                         FStar_SMTEncoding_Term.mk_tester
                                                           "Tm_arrow"
                                                           uu____6622 in
                                                       (f_has_t, uu____6621) in
                                                     FStar_SMTEncoding_Util.mkImp
                                                       uu____6616 in
                                                   ([[f_has_t]], (fsym ::
                                                     cvars), uu____6615) in
                                                 mkForall_fuel uu____6604 in
                                               (uu____6603,
                                                 (FStar_Pervasives_Native.Some
                                                    "pre-typing for functions"),
                                                 (Prims.strcat module_name
                                                    (Prims.strcat "_" a_name))) in
                                             FStar_SMTEncoding_Util.mkAssume
                                               uu____6596 in
                                           let t_interp1 =
                                             let a_name =
                                               Prims.strcat "interpretation_"
                                                 tsym in
                                             let uu____6645 =
                                               let uu____6652 =
                                                 let uu____6653 =
                                                   let uu____6664 =
                                                     FStar_SMTEncoding_Util.mkIff
                                                       (f_has_t_z, t_interp) in
                                                   ([[f_has_t_z]], (fsym ::
                                                     cvars), uu____6664) in
                                                 FStar_SMTEncoding_Util.mkForall
                                                   uu____6653 in
                                               (uu____6652,
                                                 (FStar_Pervasives_Native.Some
                                                    a_name),
                                                 (Prims.strcat module_name
                                                    (Prims.strcat "_" a_name))) in
                                             FStar_SMTEncoding_Util.mkAssume
                                               uu____6645 in
                                           let t_decls =
                                             FStar_List.append (tdecl ::
                                               decls)
                                               (FStar_List.append decls'
                                                  (FStar_List.append
                                                     guard_decls
                                                     [k_assumption;
                                                     pre_typing;
                                                     t_interp1])) in
                                           ((let uu____6689 =
                                               mk_cache_entry env tsym
                                                 cvar_sorts t_decls in
                                             FStar_Util.smap_add env.cache
                                               tkey_hash uu____6689);
                                            (t1, t_decls)))))))
                else
                  (let tsym = varops.fresh "Non_total_Tm_arrow" in
                   let tdecl =
                     FStar_SMTEncoding_Term.DeclFun
                       (tsym, [], FStar_SMTEncoding_Term.Term_sort,
                         FStar_Pervasives_Native.None) in
                   let t1 = FStar_SMTEncoding_Util.mkApp (tsym, []) in
                   let t_kinding =
                     let a_name =
                       Prims.strcat "non_total_function_typing_" tsym in
                     let uu____6704 =
                       let uu____6711 =
                         FStar_SMTEncoding_Term.mk_HasType t1
                           FStar_SMTEncoding_Term.mk_Term_type in
                       (uu____6711,
                         (FStar_Pervasives_Native.Some
                            "Typing for non-total arrows"),
                         (Prims.strcat module_name (Prims.strcat "_" a_name))) in
                     FStar_SMTEncoding_Util.mkAssume uu____6704 in
                   let fsym = ("f", FStar_SMTEncoding_Term.Term_sort) in
                   let f = FStar_SMTEncoding_Util.mkFreeV fsym in
                   let f_has_t = FStar_SMTEncoding_Term.mk_HasType f t1 in
                   let t_interp =
                     let a_name = Prims.strcat "pre_typing_" tsym in
                     let uu____6723 =
                       let uu____6730 =
                         let uu____6731 =
                           let uu____6742 =
                             let uu____6743 =
                               let uu____6748 =
                                 let uu____6749 =
                                   FStar_SMTEncoding_Term.mk_PreType f in
                                 FStar_SMTEncoding_Term.mk_tester "Tm_arrow"
                                   uu____6749 in
                               (f_has_t, uu____6748) in
                             FStar_SMTEncoding_Util.mkImp uu____6743 in
                           ([[f_has_t]], [fsym], uu____6742) in
                         mkForall_fuel uu____6731 in
                       (uu____6730, (FStar_Pervasives_Native.Some a_name),
                         (Prims.strcat module_name (Prims.strcat "_" a_name))) in
                     FStar_SMTEncoding_Util.mkAssume uu____6723 in
                   (t1, [tdecl; t_kinding; t_interp])))
       | FStar_Syntax_Syntax.Tm_refine uu____6776 ->
           let uu____6783 =
             let uu____6788 =
               FStar_TypeChecker_Normalize.normalize_refinement
                 [FStar_TypeChecker_Normalize.Weak;
                 FStar_TypeChecker_Normalize.HNF;
                 FStar_TypeChecker_Normalize.EraseUniverses] env.tcenv t0 in
             match uu____6788 with
             | { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_refine (x,f);
                 FStar_Syntax_Syntax.pos = uu____6795;
                 FStar_Syntax_Syntax.vars = uu____6796;_} ->
                 let uu____6803 =
                   FStar_Syntax_Subst.open_term
                     [(x, FStar_Pervasives_Native.None)] f in
                 (match uu____6803 with
                  | (b,f1) ->
                      let uu____6828 =
                        let uu____6829 = FStar_List.hd b in
                        FStar_Pervasives_Native.fst uu____6829 in
                      (uu____6828, f1))
             | uu____6838 -> failwith "impossible" in
           (match uu____6783 with
            | (x,f) ->
                let uu____6849 = encode_term x.FStar_Syntax_Syntax.sort env in
                (match uu____6849 with
                 | (base_t,decls) ->
                     let uu____6860 = gen_term_var env x in
                     (match uu____6860 with
                      | (x1,xtm,env') ->
                          let uu____6874 = encode_formula f env' in
                          (match uu____6874 with
                           | (refinement,decls') ->
                               let uu____6885 =
                                 fresh_fvar "f"
                                   FStar_SMTEncoding_Term.Fuel_sort in
                               (match uu____6885 with
                                | (fsym,fterm) ->
                                    let tm_has_type_with_fuel =
                                      FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                        (FStar_Pervasives_Native.Some fterm)
                                        xtm base_t in
                                    let encoding =
                                      FStar_SMTEncoding_Util.mkAnd
                                        (tm_has_type_with_fuel, refinement) in
                                    let cvars =
                                      let uu____6901 =
                                        let uu____6904 =
                                          FStar_SMTEncoding_Term.free_variables
                                            refinement in
                                        let uu____6911 =
                                          FStar_SMTEncoding_Term.free_variables
                                            tm_has_type_with_fuel in
                                        FStar_List.append uu____6904
                                          uu____6911 in
                                      FStar_Util.remove_dups
                                        FStar_SMTEncoding_Term.fv_eq
                                        uu____6901 in
                                    let cvars1 =
                                      FStar_All.pipe_right cvars
                                        (FStar_List.filter
                                           (fun uu____6944  ->
                                              match uu____6944 with
                                              | (y,uu____6950) ->
                                                  (y <> x1) && (y <> fsym))) in
                                    let xfv =
                                      (x1, FStar_SMTEncoding_Term.Term_sort) in
                                    let ffv =
                                      (fsym,
                                        FStar_SMTEncoding_Term.Fuel_sort) in
                                    let tkey =
                                      FStar_SMTEncoding_Util.mkForall
                                        ([], (ffv :: xfv :: cvars1),
                                          encoding) in
                                    let tkey_hash =
                                      FStar_SMTEncoding_Term.hash_of_term
                                        tkey in
                                    let uu____6983 =
                                      FStar_Util.smap_try_find env.cache
                                        tkey_hash in
                                    (match uu____6983 with
                                     | FStar_Pervasives_Native.Some
                                         cache_entry ->
                                         let uu____6991 =
                                           let uu____6992 =
                                             let uu____6999 =
                                               FStar_All.pipe_right cvars1
                                                 (FStar_List.map
                                                    FStar_SMTEncoding_Util.mkFreeV) in
                                             ((cache_entry.cache_symbol_name),
                                               uu____6999) in
                                           FStar_SMTEncoding_Util.mkApp
                                             uu____6992 in
                                         (uu____6991,
                                           (FStar_List.append decls
                                              (FStar_List.append decls'
                                                 (use_cache_entry cache_entry))))
                                     | FStar_Pervasives_Native.None  ->
                                         let module_name =
                                           env.current_module_name in
                                         let tsym =
                                           let uu____7020 =
                                             let uu____7021 =
                                               let uu____7022 =
                                                 FStar_Util.digest_of_string
                                                   tkey_hash in
                                               Prims.strcat "_Tm_refine_"
                                                 uu____7022 in
                                             Prims.strcat module_name
                                               uu____7021 in
                                           varops.mk_unique uu____7020 in
                                         let cvar_sorts =
                                           FStar_List.map
                                             FStar_Pervasives_Native.snd
                                             cvars1 in
                                         let tdecl =
                                           FStar_SMTEncoding_Term.DeclFun
                                             (tsym, cvar_sorts,
                                               FStar_SMTEncoding_Term.Term_sort,
                                               FStar_Pervasives_Native.None) in
                                         let t1 =
                                           let uu____7036 =
                                             let uu____7043 =
                                               FStar_List.map
                                                 FStar_SMTEncoding_Util.mkFreeV
                                                 cvars1 in
                                             (tsym, uu____7043) in
                                           FStar_SMTEncoding_Util.mkApp
                                             uu____7036 in
                                         let x_has_base_t =
                                           FStar_SMTEncoding_Term.mk_HasType
                                             xtm base_t in
                                         let x_has_t =
                                           FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                             (FStar_Pervasives_Native.Some
                                                fterm) xtm t1 in
                                         let t_has_kind =
                                           FStar_SMTEncoding_Term.mk_HasType
                                             t1
                                             FStar_SMTEncoding_Term.mk_Term_type in
                                         let t_haseq_base =
                                           FStar_SMTEncoding_Term.mk_haseq
                                             base_t in
                                         let t_haseq_ref =
                                           FStar_SMTEncoding_Term.mk_haseq t1 in
                                         let t_haseq1 =
                                           let uu____7058 =
                                             let uu____7065 =
                                               let uu____7066 =
                                                 let uu____7077 =
                                                   FStar_SMTEncoding_Util.mkIff
                                                     (t_haseq_ref,
                                                       t_haseq_base) in
                                                 ([[t_haseq_ref]], cvars1,
                                                   uu____7077) in
                                               FStar_SMTEncoding_Util.mkForall
                                                 uu____7066 in
                                             (uu____7065,
                                               (FStar_Pervasives_Native.Some
                                                  (Prims.strcat "haseq for "
                                                     tsym)),
                                               (Prims.strcat "haseq" tsym)) in
                                           FStar_SMTEncoding_Util.mkAssume
                                             uu____7058 in
                                         let t_kinding =
                                           let uu____7095 =
                                             let uu____7102 =
                                               FStar_SMTEncoding_Util.mkForall
                                                 ([[t_has_kind]], cvars1,
                                                   t_has_kind) in
                                             (uu____7102,
                                               (FStar_Pervasives_Native.Some
                                                  "refinement kinding"),
                                               (Prims.strcat
                                                  "refinement_kinding_" tsym)) in
                                           FStar_SMTEncoding_Util.mkAssume
                                             uu____7095 in
                                         let t_interp =
                                           let uu____7120 =
                                             let uu____7127 =
                                               let uu____7128 =
                                                 let uu____7139 =
                                                   FStar_SMTEncoding_Util.mkIff
                                                     (x_has_t, encoding) in
                                                 ([[x_has_t]], (ffv :: xfv ::
                                                   cvars1), uu____7139) in
                                               FStar_SMTEncoding_Util.mkForall
                                                 uu____7128 in
                                             let uu____7162 =
                                               let uu____7165 =
                                                 FStar_Syntax_Print.term_to_string
                                                   t0 in
                                               FStar_Pervasives_Native.Some
                                                 uu____7165 in
                                             (uu____7127, uu____7162,
                                               (Prims.strcat
                                                  "refinement_interpretation_"
                                                  tsym)) in
                                           FStar_SMTEncoding_Util.mkAssume
                                             uu____7120 in
                                         let t_decls =
                                           FStar_List.append decls
                                             (FStar_List.append decls'
                                                [tdecl;
                                                t_kinding;
                                                t_interp;
                                                t_haseq1]) in
                                         ((let uu____7172 =
                                             mk_cache_entry env tsym
                                               cvar_sorts t_decls in
                                           FStar_Util.smap_add env.cache
                                             tkey_hash uu____7172);
                                          (t1, t_decls))))))))
       | FStar_Syntax_Syntax.Tm_uvar (uv,k) ->
           let ttm =
             let uu____7202 = FStar_Syntax_Unionfind.uvar_id uv in
             FStar_SMTEncoding_Util.mk_Term_uvar uu____7202 in
           let uu____7203 =
             encode_term_pred FStar_Pervasives_Native.None k env ttm in
           (match uu____7203 with
            | (t_has_k,decls) ->
                let d =
                  let uu____7215 =
                    let uu____7222 =
                      let uu____7223 =
                        let uu____7224 =
                          let uu____7225 = FStar_Syntax_Unionfind.uvar_id uv in
                          FStar_All.pipe_left FStar_Util.string_of_int
                            uu____7225 in
                        FStar_Util.format1 "uvar_typing_%s" uu____7224 in
                      varops.mk_unique uu____7223 in
                    (t_has_k, (FStar_Pervasives_Native.Some "Uvar typing"),
                      uu____7222) in
                  FStar_SMTEncoding_Util.mkAssume uu____7215 in
                (ttm, (FStar_List.append decls [d])))
       | FStar_Syntax_Syntax.Tm_app uu____7230 ->
           let uu____7245 = FStar_Syntax_Util.head_and_args t0 in
           (match uu____7245 with
            | (head1,args_e) ->
                let uu____7286 =
                  let uu____7299 =
                    let uu____7300 = FStar_Syntax_Subst.compress head1 in
                    uu____7300.FStar_Syntax_Syntax.n in
                  (uu____7299, args_e) in
                (match uu____7286 with
                 | uu____7315 when head_redex env head1 ->
                     let uu____7328 = whnf env t in
                     encode_term uu____7328 env
                 | uu____7329 when is_arithmetic_primitive head1 args_e ->
                     encode_arith_term env head1 args_e
                 | uu____7348 when is_BitVector_primitive head1 args_e ->
                     encode_BitVector_term env head1 args_e
                 | (FStar_Syntax_Syntax.Tm_uinst
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
                       FStar_Syntax_Syntax.pos = uu____7362;
                       FStar_Syntax_Syntax.vars = uu____7363;_},uu____7364),uu____7365::
                    (v1,uu____7367)::(v2,uu____7369)::[]) when
                     FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.lexcons_lid
                     ->
                     let uu____7420 = encode_term v1 env in
                     (match uu____7420 with
                      | (v11,decls1) ->
                          let uu____7431 = encode_term v2 env in
                          (match uu____7431 with
                           | (v21,decls2) ->
                               let uu____7442 =
                                 FStar_SMTEncoding_Util.mk_LexCons v11 v21 in
                               (uu____7442,
                                 (FStar_List.append decls1 decls2))))
                 | (FStar_Syntax_Syntax.Tm_fvar
                    fv,uu____7446::(v1,uu____7448)::(v2,uu____7450)::[]) when
                     FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.lexcons_lid
                     ->
                     let uu____7497 = encode_term v1 env in
                     (match uu____7497 with
                      | (v11,decls1) ->
                          let uu____7508 = encode_term v2 env in
                          (match uu____7508 with
                           | (v21,decls2) ->
                               let uu____7519 =
                                 FStar_SMTEncoding_Util.mk_LexCons v11 v21 in
                               (uu____7519,
                                 (FStar_List.append decls1 decls2))))
                 | (FStar_Syntax_Syntax.Tm_constant
                    (FStar_Const.Const_range_of ),(arg,uu____7523)::[]) ->
                     encode_const
                       (FStar_Const.Const_range (arg.FStar_Syntax_Syntax.pos))
                       env
                 | (FStar_Syntax_Syntax.Tm_constant
                    (FStar_Const.Const_set_range_of
                    ),(rng,uu____7549)::(arg,uu____7551)::[]) ->
                     encode_term arg env
                 | (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify
                    ),uu____7586) ->
                     let e0 =
                       let uu____7604 = FStar_List.hd args_e in
                       FStar_TypeChecker_Util.reify_body_with_arg env.tcenv
                         head1 uu____7604 in
                     ((let uu____7612 =
                         FStar_All.pipe_left
                           (FStar_TypeChecker_Env.debug env.tcenv)
                           (FStar_Options.Other "SMTEncodingReify") in
                       if uu____7612
                       then
                         let uu____7613 =
                           FStar_Syntax_Print.term_to_string e0 in
                         FStar_Util.print1 "Result of normalization %s\n"
                           uu____7613
                       else ());
                      (let e =
                         let uu____7618 =
                           let uu____7619 =
                             FStar_TypeChecker_Util.remove_reify e0 in
                           let uu____7620 = FStar_List.tl args_e in
                           FStar_Syntax_Syntax.mk_Tm_app uu____7619
                             uu____7620 in
                         uu____7618 FStar_Pervasives_Native.None
                           t0.FStar_Syntax_Syntax.pos in
                       encode_term e env))
                 | (FStar_Syntax_Syntax.Tm_constant
                    (FStar_Const.Const_reflect
                    uu____7629),(arg,uu____7631)::[]) -> encode_term arg env
                 | uu____7656 ->
                     let uu____7669 = encode_args args_e env in
                     (match uu____7669 with
                      | (args,decls) ->
                          let encode_partial_app ht_opt =
                            let uu____7724 = encode_term head1 env in
                            match uu____7724 with
                            | (head2,decls') ->
                                let app_tm = mk_Apply_args head2 args in
                                (match ht_opt with
                                 | FStar_Pervasives_Native.None  ->
                                     (app_tm,
                                       (FStar_List.append decls decls'))
                                 | FStar_Pervasives_Native.Some (formals,c)
                                     ->
                                     let uu____7788 =
                                       FStar_Util.first_N
                                         (FStar_List.length args_e) formals in
                                     (match uu____7788 with
                                      | (formals1,rest) ->
                                          let subst1 =
                                            FStar_List.map2
                                              (fun uu____7866  ->
                                                 fun uu____7867  ->
                                                   match (uu____7866,
                                                           uu____7867)
                                                   with
                                                   | ((bv,uu____7889),
                                                      (a,uu____7891)) ->
                                                       FStar_Syntax_Syntax.NT
                                                         (bv, a)) formals1
                                              args_e in
                                          let ty =
                                            let uu____7909 =
                                              FStar_Syntax_Util.arrow rest c in
                                            FStar_All.pipe_right uu____7909
                                              (FStar_Syntax_Subst.subst
                                                 subst1) in
                                          let uu____7914 =
                                            encode_term_pred
                                              FStar_Pervasives_Native.None ty
                                              env app_tm in
                                          (match uu____7914 with
                                           | (has_type,decls'') ->
                                               let cvars =
                                                 FStar_SMTEncoding_Term.free_variables
                                                   has_type in
                                               let e_typing =
                                                 let uu____7929 =
                                                   let uu____7936 =
                                                     FStar_SMTEncoding_Util.mkForall
                                                       ([[has_type]], cvars,
                                                         has_type) in
                                                   let uu____7945 =
                                                     let uu____7946 =
                                                       let uu____7947 =
                                                         let uu____7948 =
                                                           FStar_SMTEncoding_Term.hash_of_term
                                                             app_tm in
                                                         FStar_Util.digest_of_string
                                                           uu____7948 in
                                                       Prims.strcat
                                                         "partial_app_typing_"
                                                         uu____7947 in
                                                     varops.mk_unique
                                                       uu____7946 in
                                                   (uu____7936,
                                                     (FStar_Pervasives_Native.Some
                                                        "Partial app typing"),
                                                     uu____7945) in
                                                 FStar_SMTEncoding_Util.mkAssume
                                                   uu____7929 in
                                               (app_tm,
                                                 (FStar_List.append decls
                                                    (FStar_List.append decls'
                                                       (FStar_List.append
                                                          decls'' [e_typing]))))))) in
                          let encode_full_app fv =
                            let uu____7965 = lookup_free_var_sym env fv in
                            match uu____7965 with
                            | (fname,fuel_args) ->
                                let tm =
                                  FStar_SMTEncoding_Util.mkApp'
                                    (fname,
                                      (FStar_List.append fuel_args args)) in
                                (tm, decls) in
                          let head2 = FStar_Syntax_Subst.compress head1 in
                          let head_type =
                            match head2.FStar_Syntax_Syntax.n with
                            | FStar_Syntax_Syntax.Tm_uinst
                                ({
                                   FStar_Syntax_Syntax.n =
                                     FStar_Syntax_Syntax.Tm_name x;
                                   FStar_Syntax_Syntax.pos = uu____7996;
                                   FStar_Syntax_Syntax.vars = uu____7997;_},uu____7998)
                                ->
                                FStar_Pervasives_Native.Some
                                  (x.FStar_Syntax_Syntax.sort)
                            | FStar_Syntax_Syntax.Tm_name x ->
                                FStar_Pervasives_Native.Some
                                  (x.FStar_Syntax_Syntax.sort)
                            | FStar_Syntax_Syntax.Tm_uinst
                                ({
                                   FStar_Syntax_Syntax.n =
                                     FStar_Syntax_Syntax.Tm_fvar fv;
                                   FStar_Syntax_Syntax.pos = uu____8009;
                                   FStar_Syntax_Syntax.vars = uu____8010;_},uu____8011)
                                ->
                                let uu____8016 =
                                  let uu____8017 =
                                    let uu____8022 =
                                      FStar_TypeChecker_Env.lookup_lid
                                        env.tcenv
                                        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                                    FStar_All.pipe_right uu____8022
                                      FStar_Pervasives_Native.fst in
                                  FStar_All.pipe_right uu____8017
                                    FStar_Pervasives_Native.snd in
                                FStar_Pervasives_Native.Some uu____8016
                            | FStar_Syntax_Syntax.Tm_fvar fv ->
                                let uu____8052 =
                                  let uu____8053 =
                                    let uu____8058 =
                                      FStar_TypeChecker_Env.lookup_lid
                                        env.tcenv
                                        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                                    FStar_All.pipe_right uu____8058
                                      FStar_Pervasives_Native.fst in
                                  FStar_All.pipe_right uu____8053
                                    FStar_Pervasives_Native.snd in
                                FStar_Pervasives_Native.Some uu____8052
                            | FStar_Syntax_Syntax.Tm_ascribed
                                (uu____8087,(FStar_Util.Inl t1,uu____8089),uu____8090)
                                -> FStar_Pervasives_Native.Some t1
                            | FStar_Syntax_Syntax.Tm_ascribed
                                (uu____8139,(FStar_Util.Inr c,uu____8141),uu____8142)
                                ->
                                FStar_Pervasives_Native.Some
                                  (FStar_Syntax_Util.comp_result c)
                            | uu____8191 -> FStar_Pervasives_Native.None in
                          (match head_type with
                           | FStar_Pervasives_Native.None  ->
                               encode_partial_app
                                 FStar_Pervasives_Native.None
                           | FStar_Pervasives_Native.Some head_type1 ->
                               let head_type2 =
                                 let uu____8218 =
                                   FStar_TypeChecker_Normalize.normalize_refinement
                                     [FStar_TypeChecker_Normalize.Weak;
                                     FStar_TypeChecker_Normalize.HNF;
                                     FStar_TypeChecker_Normalize.EraseUniverses]
                                     env.tcenv head_type1 in
                                 FStar_All.pipe_left
                                   FStar_Syntax_Util.unrefine uu____8218 in
                               let uu____8219 =
                                 curried_arrow_formals_comp head_type2 in
                               (match uu____8219 with
                                | (formals,c) ->
                                    (match head2.FStar_Syntax_Syntax.n with
                                     | FStar_Syntax_Syntax.Tm_uinst
                                         ({
                                            FStar_Syntax_Syntax.n =
                                              FStar_Syntax_Syntax.Tm_fvar fv;
                                            FStar_Syntax_Syntax.pos =
                                              uu____8235;
                                            FStar_Syntax_Syntax.vars =
                                              uu____8236;_},uu____8237)
                                         when
                                         (FStar_List.length formals) =
                                           (FStar_List.length args)
                                         ->
                                         encode_full_app
                                           fv.FStar_Syntax_Syntax.fv_name
                                     | FStar_Syntax_Syntax.Tm_fvar fv when
                                         (FStar_List.length formals) =
                                           (FStar_List.length args)
                                         ->
                                         encode_full_app
                                           fv.FStar_Syntax_Syntax.fv_name
                                     | uu____8251 ->
                                         if
                                           (FStar_List.length formals) >
                                             (FStar_List.length args)
                                         then
                                           encode_partial_app
                                             (FStar_Pervasives_Native.Some
                                                (formals, c))
                                         else
                                           encode_partial_app
                                             FStar_Pervasives_Native.None))))))
       | FStar_Syntax_Syntax.Tm_abs (bs,body,lopt) ->
           let uu____8300 = FStar_Syntax_Subst.open_term' bs body in
           (match uu____8300 with
            | (bs1,body1,opening) ->
                let fallback uu____8323 =
                  let f = varops.fresh "Tm_abs" in
                  let decl =
                    FStar_SMTEncoding_Term.DeclFun
                      (f, [], FStar_SMTEncoding_Term.Term_sort,
                        (FStar_Pervasives_Native.Some
                           "Imprecise function encoding")) in
                  let uu____8330 =
                    FStar_SMTEncoding_Util.mkFreeV
                      (f, FStar_SMTEncoding_Term.Term_sort) in
                  (uu____8330, [decl]) in
                let is_impure rc =
                  let uu____8337 =
                    FStar_TypeChecker_Util.is_pure_or_ghost_effect env.tcenv
                      rc.FStar_Syntax_Syntax.residual_effect in
                  FStar_All.pipe_right uu____8337 Prims.op_Negation in
                let codomain_eff rc =
                  let res_typ =
                    match rc.FStar_Syntax_Syntax.residual_typ with
                    | FStar_Pervasives_Native.None  ->
                        let uu____8347 =
                          FStar_TypeChecker_Rel.new_uvar
                            FStar_Range.dummyRange []
                            FStar_Syntax_Util.ktype0 in
                        FStar_All.pipe_right uu____8347
                          FStar_Pervasives_Native.fst
                    | FStar_Pervasives_Native.Some t1 -> t1 in
                  if
                    FStar_Ident.lid_equals
                      rc.FStar_Syntax_Syntax.residual_effect
                      FStar_Parser_Const.effect_Tot_lid
                  then
                    let uu____8367 = FStar_Syntax_Syntax.mk_Total res_typ in
                    FStar_Pervasives_Native.Some uu____8367
                  else
                    if
                      FStar_Ident.lid_equals
                        rc.FStar_Syntax_Syntax.residual_effect
                        FStar_Parser_Const.effect_GTot_lid
                    then
                      (let uu____8371 = FStar_Syntax_Syntax.mk_GTotal res_typ in
                       FStar_Pervasives_Native.Some uu____8371)
                    else FStar_Pervasives_Native.None in
                (match lopt with
                 | FStar_Pervasives_Native.None  ->
                     ((let uu____8378 =
                         let uu____8383 =
                           let uu____8384 =
                             FStar_Syntax_Print.term_to_string t0 in
                           FStar_Util.format1
                             "Losing precision when encoding a function literal: %s\n(Unnannotated abstraction in the compiler ?)"
                             uu____8384 in
                         (FStar_Errors.Warning_FunctionLiteralPrecisionLoss,
                           uu____8383) in
                       FStar_Errors.log_issue t0.FStar_Syntax_Syntax.pos
                         uu____8378);
                      fallback ())
                 | FStar_Pervasives_Native.Some rc ->
                     let uu____8386 =
                       (is_impure rc) &&
                         (let uu____8388 =
                            FStar_TypeChecker_Env.is_reifiable env.tcenv rc in
                          Prims.op_Negation uu____8388) in
                     if uu____8386
                     then fallback ()
                     else
                       (let cache_size = FStar_Util.smap_size env.cache in
                        let uu____8395 =
                          encode_binders FStar_Pervasives_Native.None bs1 env in
                        match uu____8395 with
                        | (vars,guards,envbody,decls,uu____8420) ->
                            let body2 =
                              let uu____8434 =
                                FStar_TypeChecker_Env.is_reifiable env.tcenv
                                  rc in
                              if uu____8434
                              then
                                FStar_TypeChecker_Util.reify_body env.tcenv
                                  body1
                              else body1 in
                            let uu____8436 = encode_term body2 envbody in
                            (match uu____8436 with
                             | (body3,decls') ->
                                 let uu____8447 =
                                   let uu____8456 = codomain_eff rc in
                                   match uu____8456 with
                                   | FStar_Pervasives_Native.None  ->
                                       (FStar_Pervasives_Native.None, [])
                                   | FStar_Pervasives_Native.Some c ->
                                       let tfun =
                                         FStar_Syntax_Util.arrow bs1 c in
                                       let uu____8475 = encode_term tfun env in
                                       (match uu____8475 with
                                        | (t1,decls1) ->
                                            ((FStar_Pervasives_Native.Some t1),
                                              decls1)) in
                                 (match uu____8447 with
                                  | (arrow_t_opt,decls'') ->
                                      let key_body =
                                        let uu____8507 =
                                          let uu____8518 =
                                            let uu____8519 =
                                              let uu____8524 =
                                                FStar_SMTEncoding_Util.mk_and_l
                                                  guards in
                                              (uu____8524, body3) in
                                            FStar_SMTEncoding_Util.mkImp
                                              uu____8519 in
                                          ([], vars, uu____8518) in
                                        FStar_SMTEncoding_Util.mkForall
                                          uu____8507 in
                                      let cvars =
                                        FStar_SMTEncoding_Term.free_variables
                                          key_body in
                                      let cvars1 =
                                        match arrow_t_opt with
                                        | FStar_Pervasives_Native.None  ->
                                            cvars
                                        | FStar_Pervasives_Native.Some t1 ->
                                            let uu____8536 =
                                              let uu____8539 =
                                                FStar_SMTEncoding_Term.free_variables
                                                  t1 in
                                              FStar_List.append uu____8539
                                                cvars in
                                            FStar_Util.remove_dups
                                              FStar_SMTEncoding_Term.fv_eq
                                              uu____8536 in
                                      let tkey =
                                        FStar_SMTEncoding_Util.mkForall
                                          ([], cvars1, key_body) in
                                      let tkey_hash =
                                        FStar_SMTEncoding_Term.hash_of_term
                                          tkey in
                                      let uu____8558 =
                                        FStar_Util.smap_try_find env.cache
                                          tkey_hash in
                                      (match uu____8558 with
                                       | FStar_Pervasives_Native.Some
                                           cache_entry ->
                                           let uu____8566 =
                                             let uu____8567 =
                                               let uu____8574 =
                                                 FStar_List.map
                                                   FStar_SMTEncoding_Util.mkFreeV
                                                   cvars1 in
                                               ((cache_entry.cache_symbol_name),
                                                 uu____8574) in
                                             FStar_SMTEncoding_Util.mkApp
                                               uu____8567 in
                                           (uu____8566,
                                             (FStar_List.append decls
                                                (FStar_List.append decls'
                                                   (FStar_List.append decls''
                                                      (use_cache_entry
                                                         cache_entry)))))
                                       | FStar_Pervasives_Native.None  ->
                                           let uu____8585 =
                                             is_an_eta_expansion env vars
                                               body3 in
                                           (match uu____8585 with
                                            | FStar_Pervasives_Native.Some t1
                                                ->
                                                let decls1 =
                                                  let uu____8596 =
                                                    let uu____8597 =
                                                      FStar_Util.smap_size
                                                        env.cache in
                                                    uu____8597 = cache_size in
                                                  if uu____8596
                                                  then []
                                                  else
                                                    FStar_List.append decls
                                                      (FStar_List.append
                                                         decls' decls'') in
                                                (t1, decls1)
                                            | FStar_Pervasives_Native.None 
                                                ->
                                                let cvar_sorts =
                                                  FStar_List.map
                                                    FStar_Pervasives_Native.snd
                                                    cvars1 in
                                                let fsym =
                                                  let module_name =
                                                    env.current_module_name in
                                                  let fsym =
                                                    let uu____8613 =
                                                      let uu____8614 =
                                                        FStar_Util.digest_of_string
                                                          tkey_hash in
                                                      Prims.strcat "Tm_abs_"
                                                        uu____8614 in
                                                    varops.mk_unique
                                                      uu____8613 in
                                                  Prims.strcat module_name
                                                    (Prims.strcat "_" fsym) in
                                                let fdecl =
                                                  FStar_SMTEncoding_Term.DeclFun
                                                    (fsym, cvar_sorts,
                                                      FStar_SMTEncoding_Term.Term_sort,
                                                      FStar_Pervasives_Native.None) in
                                                let f =
                                                  let uu____8621 =
                                                    let uu____8628 =
                                                      FStar_List.map
                                                        FStar_SMTEncoding_Util.mkFreeV
                                                        cvars1 in
                                                    (fsym, uu____8628) in
                                                  FStar_SMTEncoding_Util.mkApp
                                                    uu____8621 in
                                                let app = mk_Apply f vars in
                                                let typing_f =
                                                  match arrow_t_opt with
                                                  | FStar_Pervasives_Native.None
                                                       -> []
                                                  | FStar_Pervasives_Native.Some
                                                      t1 ->
                                                      let f_has_t =
                                                        FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                                          FStar_Pervasives_Native.None
                                                          f t1 in
                                                      let a_name =
                                                        Prims.strcat
                                                          "typing_" fsym in
                                                      let uu____8646 =
                                                        let uu____8647 =
                                                          let uu____8654 =
                                                            FStar_SMTEncoding_Util.mkForall
                                                              ([[f]], cvars1,
                                                                f_has_t) in
                                                          (uu____8654,
                                                            (FStar_Pervasives_Native.Some
                                                               a_name),
                                                            a_name) in
                                                        FStar_SMTEncoding_Util.mkAssume
                                                          uu____8647 in
                                                      [uu____8646] in
                                                let interp_f =
                                                  let a_name =
                                                    Prims.strcat
                                                      "interpretation_" fsym in
                                                  let uu____8667 =
                                                    let uu____8674 =
                                                      let uu____8675 =
                                                        let uu____8686 =
                                                          FStar_SMTEncoding_Util.mkEq
                                                            (app, body3) in
                                                        ([[app]],
                                                          (FStar_List.append
                                                             vars cvars1),
                                                          uu____8686) in
                                                      FStar_SMTEncoding_Util.mkForall
                                                        uu____8675 in
                                                    (uu____8674,
                                                      (FStar_Pervasives_Native.Some
                                                         a_name), a_name) in
                                                  FStar_SMTEncoding_Util.mkAssume
                                                    uu____8667 in
                                                let f_decls =
                                                  FStar_List.append decls
                                                    (FStar_List.append decls'
                                                       (FStar_List.append
                                                          decls''
                                                          (FStar_List.append
                                                             (fdecl ::
                                                             typing_f)
                                                             [interp_f]))) in
                                                ((let uu____8703 =
                                                    mk_cache_entry env fsym
                                                      cvar_sorts f_decls in
                                                  FStar_Util.smap_add
                                                    env.cache tkey_hash
                                                    uu____8703);
                                                 (f, f_decls)))))))))
       | FStar_Syntax_Syntax.Tm_let
           ((uu____8706,{
                          FStar_Syntax_Syntax.lbname = FStar_Util.Inr
                            uu____8707;
                          FStar_Syntax_Syntax.lbunivs = uu____8708;
                          FStar_Syntax_Syntax.lbtyp = uu____8709;
                          FStar_Syntax_Syntax.lbeff = uu____8710;
                          FStar_Syntax_Syntax.lbdef = uu____8711;_}::uu____8712),uu____8713)
           -> failwith "Impossible: already handled by encoding of Sig_let"
       | FStar_Syntax_Syntax.Tm_let
           ((false
             ,{ FStar_Syntax_Syntax.lbname = FStar_Util.Inl x;
                FStar_Syntax_Syntax.lbunivs = uu____8739;
                FStar_Syntax_Syntax.lbtyp = t1;
                FStar_Syntax_Syntax.lbeff = uu____8741;
                FStar_Syntax_Syntax.lbdef = e1;_}::[]),e2)
           -> encode_let x t1 e1 e2 env encode_term
       | FStar_Syntax_Syntax.Tm_let uu____8762 ->
           (FStar_Errors.diag t0.FStar_Syntax_Syntax.pos
              "Non-top-level recursive functions, and their enclosings let bindings (including the top-level let) are not yet fully encoded to the SMT solver; you may not be able to prove some facts";
            FStar_Exn.raise Inner_let_rec)
       | FStar_Syntax_Syntax.Tm_match (e,pats) ->
           encode_match e pats FStar_SMTEncoding_Term.mk_Term_unit env
             encode_term)
and encode_let:
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          env_t ->
            (FStar_Syntax_Syntax.term ->
               env_t ->
                 (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
                   FStar_Pervasives_Native.tuple2)
              ->
              (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
                FStar_Pervasives_Native.tuple2
  =
  fun x  ->
    fun t1  ->
      fun e1  ->
        fun e2  ->
          fun env  ->
            fun encode_body  ->
              let uu____8832 = encode_term e1 env in
              match uu____8832 with
              | (ee1,decls1) ->
                  let uu____8843 =
                    FStar_Syntax_Subst.open_term
                      [(x, FStar_Pervasives_Native.None)] e2 in
                  (match uu____8843 with
                   | (xs,e21) ->
                       let uu____8868 = FStar_List.hd xs in
                       (match uu____8868 with
                        | (x1,uu____8882) ->
                            let env' = push_term_var env x1 ee1 in
                            let uu____8884 = encode_body e21 env' in
                            (match uu____8884 with
                             | (ee2,decls2) ->
                                 (ee2, (FStar_List.append decls1 decls2)))))
and encode_match:
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.branch Prims.list ->
      FStar_SMTEncoding_Term.term ->
        env_t ->
          (FStar_Syntax_Syntax.term ->
             env_t ->
               (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
                 FStar_Pervasives_Native.tuple2)
            ->
            (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
              FStar_Pervasives_Native.tuple2
  =
  fun e  ->
    fun pats  ->
      fun default_case  ->
        fun env  ->
          fun encode_br  ->
            let uu____8916 =
              let uu____8923 =
                let uu____8924 =
                  FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown
                    FStar_Pervasives_Native.None FStar_Range.dummyRange in
                FStar_Syntax_Syntax.null_bv uu____8924 in
              gen_term_var env uu____8923 in
            match uu____8916 with
            | (scrsym,scr',env1) ->
                let uu____8932 = encode_term e env1 in
                (match uu____8932 with
                 | (scr,decls) ->
                     let uu____8943 =
                       let encode_branch b uu____8968 =
                         match uu____8968 with
                         | (else_case,decls1) ->
                             let uu____8987 =
                               FStar_Syntax_Subst.open_branch b in
                             (match uu____8987 with
                              | (p,w,br) ->
                                  let uu____9013 = encode_pat env1 p in
                                  (match uu____9013 with
                                   | (env0,pattern) ->
                                       let guard = pattern.guard scr' in
                                       let projections =
                                         pattern.projections scr' in
                                       let env2 =
                                         FStar_All.pipe_right projections
                                           (FStar_List.fold_left
                                              (fun env2  ->
                                                 fun uu____9050  ->
                                                   match uu____9050 with
                                                   | (x,t) ->
                                                       push_term_var env2 x t)
                                              env1) in
                                       let uu____9057 =
                                         match w with
                                         | FStar_Pervasives_Native.None  ->
                                             (guard, [])
                                         | FStar_Pervasives_Native.Some w1 ->
                                             let uu____9079 =
                                               encode_term w1 env2 in
                                             (match uu____9079 with
                                              | (w2,decls2) ->
                                                  let uu____9092 =
                                                    let uu____9093 =
                                                      let uu____9098 =
                                                        let uu____9099 =
                                                          let uu____9104 =
                                                            FStar_SMTEncoding_Term.boxBool
                                                              FStar_SMTEncoding_Util.mkTrue in
                                                          (w2, uu____9104) in
                                                        FStar_SMTEncoding_Util.mkEq
                                                          uu____9099 in
                                                      (guard, uu____9098) in
                                                    FStar_SMTEncoding_Util.mkAnd
                                                      uu____9093 in
                                                  (uu____9092, decls2)) in
                                       (match uu____9057 with
                                        | (guard1,decls2) ->
                                            let uu____9117 =
                                              encode_br br env2 in
                                            (match uu____9117 with
                                             | (br1,decls3) ->
                                                 let uu____9130 =
                                                   FStar_SMTEncoding_Util.mkITE
                                                     (guard1, br1, else_case) in
                                                 (uu____9130,
                                                   (FStar_List.append decls1
                                                      (FStar_List.append
                                                         decls2 decls3))))))) in
                       FStar_List.fold_right encode_branch pats
                         (default_case, decls) in
                     (match uu____8943 with
                      | (match_tm,decls1) ->
                          let uu____9149 =
                            FStar_SMTEncoding_Term.mkLet'
                              ([((scrsym, FStar_SMTEncoding_Term.Term_sort),
                                  scr)], match_tm) FStar_Range.dummyRange in
                          (uu____9149, decls1)))
and encode_pat:
  env_t ->
    FStar_Syntax_Syntax.pat -> (env_t,pattern) FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun pat  ->
      (let uu____9189 =
         FStar_TypeChecker_Env.debug env.tcenv FStar_Options.Low in
       if uu____9189
       then
         let uu____9190 = FStar_Syntax_Print.pat_to_string pat in
         FStar_Util.print1 "Encoding pattern %s\n" uu____9190
       else ());
      (let uu____9192 = FStar_TypeChecker_Util.decorated_pattern_as_term pat in
       match uu____9192 with
       | (vars,pat_term) ->
           let uu____9209 =
             FStar_All.pipe_right vars
               (FStar_List.fold_left
                  (fun uu____9262  ->
                     fun v1  ->
                       match uu____9262 with
                       | (env1,vars1) ->
                           let uu____9314 = gen_term_var env1 v1 in
                           (match uu____9314 with
                            | (xx,uu____9336,env2) ->
                                (env2,
                                  ((v1,
                                     (xx, FStar_SMTEncoding_Term.Term_sort))
                                  :: vars1)))) (env, [])) in
           (match uu____9209 with
            | (env1,vars1) ->
                let rec mk_guard pat1 scrutinee =
                  match pat1.FStar_Syntax_Syntax.v with
                  | FStar_Syntax_Syntax.Pat_var uu____9415 ->
                      FStar_SMTEncoding_Util.mkTrue
                  | FStar_Syntax_Syntax.Pat_wild uu____9416 ->
                      FStar_SMTEncoding_Util.mkTrue
                  | FStar_Syntax_Syntax.Pat_dot_term uu____9417 ->
                      FStar_SMTEncoding_Util.mkTrue
                  | FStar_Syntax_Syntax.Pat_constant c ->
                      let uu____9425 = encode_const c env1 in
                      (match uu____9425 with
                       | (tm,decls) ->
                           ((match decls with
                             | uu____9439::uu____9440 ->
                                 failwith
                                   "Unexpected encoding of constant pattern"
                             | uu____9443 -> ());
                            FStar_SMTEncoding_Util.mkEq (scrutinee, tm)))
                  | FStar_Syntax_Syntax.Pat_cons (f,args) ->
                      let is_f =
                        let tc_name =
                          FStar_TypeChecker_Env.typ_of_datacon env1.tcenv
                            (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                        let uu____9466 =
                          FStar_TypeChecker_Env.datacons_of_typ env1.tcenv
                            tc_name in
                        match uu____9466 with
                        | (uu____9473,uu____9474::[]) ->
                            FStar_SMTEncoding_Util.mkTrue
                        | uu____9477 ->
                            mk_data_tester env1
                              (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                              scrutinee in
                      let sub_term_guards =
                        FStar_All.pipe_right args
                          (FStar_List.mapi
                             (fun i  ->
                                fun uu____9510  ->
                                  match uu____9510 with
                                  | (arg,uu____9518) ->
                                      let proj =
                                        primitive_projector_by_pos env1.tcenv
                                          (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                          i in
                                      let uu____9524 =
                                        FStar_SMTEncoding_Util.mkApp
                                          (proj, [scrutinee]) in
                                      mk_guard arg uu____9524)) in
                      FStar_SMTEncoding_Util.mk_and_l (is_f ::
                        sub_term_guards) in
                let rec mk_projections pat1 scrutinee =
                  match pat1.FStar_Syntax_Syntax.v with
                  | FStar_Syntax_Syntax.Pat_dot_term (x,uu____9551) ->
                      [(x, scrutinee)]
                  | FStar_Syntax_Syntax.Pat_var x -> [(x, scrutinee)]
                  | FStar_Syntax_Syntax.Pat_wild x -> [(x, scrutinee)]
                  | FStar_Syntax_Syntax.Pat_constant uu____9582 -> []
                  | FStar_Syntax_Syntax.Pat_cons (f,args) ->
                      let uu____9605 =
                        FStar_All.pipe_right args
                          (FStar_List.mapi
                             (fun i  ->
                                fun uu____9649  ->
                                  match uu____9649 with
                                  | (arg,uu____9663) ->
                                      let proj =
                                        primitive_projector_by_pos env1.tcenv
                                          (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                          i in
                                      let uu____9669 =
                                        FStar_SMTEncoding_Util.mkApp
                                          (proj, [scrutinee]) in
                                      mk_projections arg uu____9669)) in
                      FStar_All.pipe_right uu____9605 FStar_List.flatten in
                let pat_term1 uu____9697 = encode_term pat_term env1 in
                let pattern =
                  {
                    pat_vars = vars1;
                    pat_term = pat_term1;
                    guard = (mk_guard pat);
                    projections = (mk_projections pat)
                  } in
                (env1, pattern)))
and encode_args:
  FStar_Syntax_Syntax.args ->
    env_t ->
      (FStar_SMTEncoding_Term.term Prims.list,FStar_SMTEncoding_Term.decls_t)
        FStar_Pervasives_Native.tuple2
  =
  fun l  ->
    fun env  ->
      let uu____9707 =
        FStar_All.pipe_right l
          (FStar_List.fold_left
             (fun uu____9745  ->
                fun uu____9746  ->
                  match (uu____9745, uu____9746) with
                  | ((tms,decls),(t,uu____9782)) ->
                      let uu____9803 = encode_term t env in
                      (match uu____9803 with
                       | (t1,decls') ->
                           ((t1 :: tms), (FStar_List.append decls decls'))))
             ([], [])) in
      match uu____9707 with | (l1,decls) -> ((FStar_List.rev l1), decls)
and encode_function_type_as_formula:
  FStar_Syntax_Syntax.typ ->
    env_t ->
      (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
        FStar_Pervasives_Native.tuple2
  =
  fun t  ->
    fun env  ->
      let list_elements1 e =
        let uu____9860 = FStar_Syntax_Util.list_elements e in
        match uu____9860 with
        | FStar_Pervasives_Native.Some l -> l
        | FStar_Pervasives_Native.None  ->
            (FStar_Errors.log_issue e.FStar_Syntax_Syntax.pos
               (FStar_Errors.Warning_NonListLiteralSMTPattern,
                 "SMT pattern is not a list literal; ignoring the pattern");
             []) in
      let one_pat p =
        let uu____9881 =
          let uu____9896 = FStar_Syntax_Util.unmeta p in
          FStar_All.pipe_right uu____9896 FStar_Syntax_Util.head_and_args in
        match uu____9881 with
        | (head1,args) ->
            let uu____9935 =
              let uu____9948 =
                let uu____9949 = FStar_Syntax_Util.un_uinst head1 in
                uu____9949.FStar_Syntax_Syntax.n in
              (uu____9948, args) in
            (match uu____9935 with
             | (FStar_Syntax_Syntax.Tm_fvar
                fv,(uu____9963,uu____9964)::(e,uu____9966)::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.smtpat_lid
                 -> e
             | uu____10001 -> failwith "Unexpected pattern term") in
      let lemma_pats p =
        let elts = list_elements1 p in
        let smt_pat_or1 t1 =
          let uu____10037 =
            let uu____10052 = FStar_Syntax_Util.unmeta t1 in
            FStar_All.pipe_right uu____10052 FStar_Syntax_Util.head_and_args in
          match uu____10037 with
          | (head1,args) ->
              let uu____10093 =
                let uu____10106 =
                  let uu____10107 = FStar_Syntax_Util.un_uinst head1 in
                  uu____10107.FStar_Syntax_Syntax.n in
                (uu____10106, args) in
              (match uu____10093 with
               | (FStar_Syntax_Syntax.Tm_fvar fv,(e,uu____10124)::[]) when
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.smtpatOr_lid
                   -> FStar_Pervasives_Native.Some e
               | uu____10151 -> FStar_Pervasives_Native.None) in
        match elts with
        | t1::[] ->
            let uu____10173 = smt_pat_or1 t1 in
            (match uu____10173 with
             | FStar_Pervasives_Native.Some e ->
                 let uu____10189 = list_elements1 e in
                 FStar_All.pipe_right uu____10189
                   (FStar_List.map
                      (fun branch1  ->
                         let uu____10207 = list_elements1 branch1 in
                         FStar_All.pipe_right uu____10207
                           (FStar_List.map one_pat)))
             | uu____10218 ->
                 let uu____10223 =
                   FStar_All.pipe_right elts (FStar_List.map one_pat) in
                 [uu____10223])
        | uu____10244 ->
            let uu____10247 =
              FStar_All.pipe_right elts (FStar_List.map one_pat) in
            [uu____10247] in
      let uu____10268 =
        let uu____10287 =
          let uu____10288 = FStar_Syntax_Subst.compress t in
          uu____10288.FStar_Syntax_Syntax.n in
        match uu____10287 with
        | FStar_Syntax_Syntax.Tm_arrow (binders,c) ->
            let uu____10327 = FStar_Syntax_Subst.open_comp binders c in
            (match uu____10327 with
             | (binders1,c1) ->
                 (match c1.FStar_Syntax_Syntax.n with
                  | FStar_Syntax_Syntax.Comp
                      { FStar_Syntax_Syntax.comp_univs = uu____10370;
                        FStar_Syntax_Syntax.effect_name = uu____10371;
                        FStar_Syntax_Syntax.result_typ = uu____10372;
                        FStar_Syntax_Syntax.effect_args =
                          (pre,uu____10374)::(post,uu____10376)::(pats,uu____10378)::[];
                        FStar_Syntax_Syntax.flags = uu____10379;_}
                      ->
                      let uu____10420 = lemma_pats pats in
                      (binders1, pre, post, uu____10420)
                  | uu____10437 -> failwith "impos"))
        | uu____10456 -> failwith "Impos" in
      match uu____10268 with
      | (binders,pre,post,patterns) ->
          let env1 =
            let uu___110_10504 = env in
            {
              bindings = (uu___110_10504.bindings);
              depth = (uu___110_10504.depth);
              tcenv = (uu___110_10504.tcenv);
              warn = (uu___110_10504.warn);
              cache = (uu___110_10504.cache);
              nolabels = (uu___110_10504.nolabels);
              use_zfuel_name = true;
              encode_non_total_function_typ =
                (uu___110_10504.encode_non_total_function_typ);
              current_module_name = (uu___110_10504.current_module_name)
            } in
          let uu____10505 =
            encode_binders FStar_Pervasives_Native.None binders env1 in
          (match uu____10505 with
           | (vars,guards,env2,decls,uu____10530) ->
               let uu____10543 =
                 let uu____10558 =
                   FStar_All.pipe_right patterns
                     (FStar_List.map
                        (fun branch1  ->
                           let uu____10612 =
                             let uu____10623 =
                               FStar_All.pipe_right branch1
                                 (FStar_List.map
                                    (fun t1  -> encode_smt_pattern t1 env2)) in
                             FStar_All.pipe_right uu____10623
                               FStar_List.unzip in
                           match uu____10612 with
                           | (pats,decls1) -> (pats, decls1))) in
                 FStar_All.pipe_right uu____10558 FStar_List.unzip in
               (match uu____10543 with
                | (pats,decls') ->
                    let decls'1 = FStar_List.flatten decls' in
                    let post1 = FStar_Syntax_Util.unthunk_lemma_post post in
                    let env3 =
                      let uu___111_10775 = env2 in
                      {
                        bindings = (uu___111_10775.bindings);
                        depth = (uu___111_10775.depth);
                        tcenv = (uu___111_10775.tcenv);
                        warn = (uu___111_10775.warn);
                        cache = (uu___111_10775.cache);
                        nolabels = true;
                        use_zfuel_name = (uu___111_10775.use_zfuel_name);
                        encode_non_total_function_typ =
                          (uu___111_10775.encode_non_total_function_typ);
                        current_module_name =
                          (uu___111_10775.current_module_name)
                      } in
                    let uu____10776 =
                      let uu____10781 = FStar_Syntax_Util.unmeta pre in
                      encode_formula uu____10781 env3 in
                    (match uu____10776 with
                     | (pre1,decls'') ->
                         let uu____10788 =
                           let uu____10793 = FStar_Syntax_Util.unmeta post1 in
                           encode_formula uu____10793 env3 in
                         (match uu____10788 with
                          | (post2,decls''') ->
                              let decls1 =
                                FStar_List.append decls
                                  (FStar_List.append
                                     (FStar_List.flatten decls'1)
                                     (FStar_List.append decls'' decls''')) in
                              let uu____10803 =
                                let uu____10804 =
                                  let uu____10815 =
                                    let uu____10816 =
                                      let uu____10821 =
                                        FStar_SMTEncoding_Util.mk_and_l (pre1
                                          :: guards) in
                                      (uu____10821, post2) in
                                    FStar_SMTEncoding_Util.mkImp uu____10816 in
                                  (pats, vars, uu____10815) in
                                FStar_SMTEncoding_Util.mkForall uu____10804 in
                              (uu____10803, decls1)))))
and encode_smt_pattern:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    env_t ->
      (FStar_SMTEncoding_Term.pat,FStar_SMTEncoding_Term.decl Prims.list)
        FStar_Pervasives_Native.tuple2
  =
  fun t  ->
    fun env  ->
      let uu____10834 = FStar_Syntax_Util.head_and_args t in
      match uu____10834 with
      | (head1,args) ->
          let head2 = FStar_Syntax_Util.un_uinst head1 in
          (match ((head2.FStar_Syntax_Syntax.n), args) with
           | (FStar_Syntax_Syntax.Tm_fvar
              fv,uu____10893::(x,uu____10895)::(t1,uu____10897)::[]) when
               FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.has_type_lid
               ->
               let uu____10944 = encode_term x env in
               (match uu____10944 with
                | (x1,decls) ->
                    let uu____10957 = encode_term t1 env in
                    (match uu____10957 with
                     | (t2,decls') ->
                         let uu____10970 =
                           FStar_SMTEncoding_Term.mk_HasType x1 t2 in
                         (uu____10970, (FStar_List.append decls decls'))))
           | uu____10973 -> encode_term t env)
and encode_formula:
  FStar_Syntax_Syntax.typ ->
    env_t ->
      (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decls_t)
        FStar_Pervasives_Native.tuple2
  =
  fun phi  ->
    fun env  ->
      let debug1 phi1 =
        let uu____10996 =
          FStar_All.pipe_left (FStar_TypeChecker_Env.debug env.tcenv)
            (FStar_Options.Other "SMTEncoding") in
        if uu____10996
        then
          let uu____10997 = FStar_Syntax_Print.tag_of_term phi1 in
          let uu____10998 = FStar_Syntax_Print.term_to_string phi1 in
          FStar_Util.print2 "Formula (%s)  %s\n" uu____10997 uu____10998
        else () in
      let enc f r l =
        let uu____11031 =
          FStar_Util.fold_map
            (fun decls  ->
               fun x  ->
                 let uu____11059 =
                   encode_term (FStar_Pervasives_Native.fst x) env in
                 match uu____11059 with
                 | (t,decls') -> ((FStar_List.append decls decls'), t)) [] l in
        match uu____11031 with
        | (decls,args) ->
            let uu____11088 =
              let uu___112_11089 = f args in
              {
                FStar_SMTEncoding_Term.tm =
                  (uu___112_11089.FStar_SMTEncoding_Term.tm);
                FStar_SMTEncoding_Term.freevars =
                  (uu___112_11089.FStar_SMTEncoding_Term.freevars);
                FStar_SMTEncoding_Term.rng = r
              } in
            (uu____11088, decls) in
      let const_op f r uu____11120 =
        let uu____11133 = f r in (uu____11133, []) in
      let un_op f l =
        let uu____11152 = FStar_List.hd l in
        FStar_All.pipe_left f uu____11152 in
      let bin_op f uu___86_11168 =
        match uu___86_11168 with
        | t1::t2::[] -> f (t1, t2)
        | uu____11179 -> failwith "Impossible" in
      let enc_prop_c f r l =
        let uu____11213 =
          FStar_Util.fold_map
            (fun decls  ->
               fun uu____11236  ->
                 match uu____11236 with
                 | (t,uu____11250) ->
                     let uu____11251 = encode_formula t env in
                     (match uu____11251 with
                      | (phi1,decls') ->
                          ((FStar_List.append decls decls'), phi1))) [] l in
        match uu____11213 with
        | (decls,phis) ->
            let uu____11280 =
              let uu___113_11281 = f phis in
              {
                FStar_SMTEncoding_Term.tm =
                  (uu___113_11281.FStar_SMTEncoding_Term.tm);
                FStar_SMTEncoding_Term.freevars =
                  (uu___113_11281.FStar_SMTEncoding_Term.freevars);
                FStar_SMTEncoding_Term.rng = r
              } in
            (uu____11280, decls) in
      let eq_op r args =
        let rf =
          FStar_List.filter
            (fun uu____11342  ->
               match uu____11342 with
               | (a,q) ->
                   (match q with
                    | FStar_Pervasives_Native.Some
                        (FStar_Syntax_Syntax.Implicit uu____11361) -> false
                    | uu____11362 -> true)) args in
        if (FStar_List.length rf) <> (Prims.parse_int "2")
        then
          let uu____11377 =
            FStar_Util.format1
              "eq_op: got %s non-implicit arguments instead of 2?"
              (Prims.string_of_int (FStar_List.length rf)) in
          failwith uu____11377
        else
          (let uu____11391 = enc (bin_op FStar_SMTEncoding_Util.mkEq) in
           uu____11391 r rf) in
      let mk_imp1 r uu___87_11416 =
        match uu___87_11416 with
        | (lhs,uu____11422)::(rhs,uu____11424)::[] ->
            let uu____11451 = encode_formula rhs env in
            (match uu____11451 with
             | (l1,decls1) ->
                 (match l1.FStar_SMTEncoding_Term.tm with
                  | FStar_SMTEncoding_Term.App
                      (FStar_SMTEncoding_Term.TrueOp ,uu____11466) ->
                      (l1, decls1)
                  | uu____11471 ->
                      let uu____11472 = encode_formula lhs env in
                      (match uu____11472 with
                       | (l2,decls2) ->
                           let uu____11483 =
                             FStar_SMTEncoding_Term.mkImp (l2, l1) r in
                           (uu____11483, (FStar_List.append decls1 decls2)))))
        | uu____11486 -> failwith "impossible" in
      let mk_ite r uu___88_11507 =
        match uu___88_11507 with
        | (guard,uu____11513)::(_then,uu____11515)::(_else,uu____11517)::[]
            ->
            let uu____11554 = encode_formula guard env in
            (match uu____11554 with
             | (g,decls1) ->
                 let uu____11565 = encode_formula _then env in
                 (match uu____11565 with
                  | (t,decls2) ->
                      let uu____11576 = encode_formula _else env in
                      (match uu____11576 with
                       | (e,decls3) ->
                           let res = FStar_SMTEncoding_Term.mkITE (g, t, e) r in
                           (res,
                             (FStar_List.append decls1
                                (FStar_List.append decls2 decls3))))))
        | uu____11590 -> failwith "impossible" in
      let unboxInt_l f l =
        let uu____11615 = FStar_List.map FStar_SMTEncoding_Term.unboxInt l in
        f uu____11615 in
      let connectives =
        let uu____11633 =
          let uu____11646 = enc_prop_c (bin_op FStar_SMTEncoding_Util.mkAnd) in
          (FStar_Parser_Const.and_lid, uu____11646) in
        let uu____11663 =
          let uu____11678 =
            let uu____11691 = enc_prop_c (bin_op FStar_SMTEncoding_Util.mkOr) in
            (FStar_Parser_Const.or_lid, uu____11691) in
          let uu____11708 =
            let uu____11723 =
              let uu____11738 =
                let uu____11751 =
                  enc_prop_c (bin_op FStar_SMTEncoding_Util.mkIff) in
                (FStar_Parser_Const.iff_lid, uu____11751) in
              let uu____11768 =
                let uu____11783 =
                  let uu____11798 =
                    let uu____11811 =
                      enc_prop_c (un_op FStar_SMTEncoding_Util.mkNot) in
                    (FStar_Parser_Const.not_lid, uu____11811) in
                  [uu____11798;
                  (FStar_Parser_Const.eq2_lid, eq_op);
                  (FStar_Parser_Const.eq3_lid, eq_op);
                  (FStar_Parser_Const.true_lid,
                    (const_op FStar_SMTEncoding_Term.mkTrue));
                  (FStar_Parser_Const.false_lid,
                    (const_op FStar_SMTEncoding_Term.mkFalse))] in
                (FStar_Parser_Const.ite_lid, mk_ite) :: uu____11783 in
              uu____11738 :: uu____11768 in
            (FStar_Parser_Const.imp_lid, mk_imp1) :: uu____11723 in
          uu____11678 :: uu____11708 in
        uu____11633 :: uu____11663 in
      let rec fallback phi1 =
        match phi1.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_meta
            (phi',FStar_Syntax_Syntax.Meta_labeled (msg,r,b)) ->
            let uu____12132 = encode_formula phi' env in
            (match uu____12132 with
             | (phi2,decls) ->
                 let uu____12143 =
                   FStar_SMTEncoding_Term.mk
                     (FStar_SMTEncoding_Term.Labeled (phi2, msg, r)) r in
                 (uu____12143, decls))
        | FStar_Syntax_Syntax.Tm_meta uu____12144 ->
            let uu____12151 = FStar_Syntax_Util.unmeta phi1 in
            encode_formula uu____12151 env
        | FStar_Syntax_Syntax.Tm_match (e,pats) ->
            let uu____12190 =
              encode_match e pats FStar_SMTEncoding_Util.mkFalse env
                encode_formula in
            (match uu____12190 with | (t,decls) -> (t, decls))
        | FStar_Syntax_Syntax.Tm_let
            ((false
              ,{ FStar_Syntax_Syntax.lbname = FStar_Util.Inl x;
                 FStar_Syntax_Syntax.lbunivs = uu____12202;
                 FStar_Syntax_Syntax.lbtyp = t1;
                 FStar_Syntax_Syntax.lbeff = uu____12204;
                 FStar_Syntax_Syntax.lbdef = e1;_}::[]),e2)
            ->
            let uu____12225 = encode_let x t1 e1 e2 env encode_formula in
            (match uu____12225 with | (t,decls) -> (t, decls))
        | FStar_Syntax_Syntax.Tm_app (head1,args) ->
            let head2 = FStar_Syntax_Util.un_uinst head1 in
            (match ((head2.FStar_Syntax_Syntax.n), args) with
             | (FStar_Syntax_Syntax.Tm_fvar
                fv,uu____12272::(x,uu____12274)::(t,uu____12276)::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.has_type_lid
                 ->
                 let uu____12323 = encode_term x env in
                 (match uu____12323 with
                  | (x1,decls) ->
                      let uu____12334 = encode_term t env in
                      (match uu____12334 with
                       | (t1,decls') ->
                           let uu____12345 =
                             FStar_SMTEncoding_Term.mk_HasType x1 t1 in
                           (uu____12345, (FStar_List.append decls decls'))))
             | (FStar_Syntax_Syntax.Tm_fvar
                fv,(r,uu____12350)::(msg,uu____12352)::(phi2,uu____12354)::[])
                 when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.labeled_lid
                 ->
                 let uu____12399 =
                   let uu____12404 =
                     let uu____12405 = FStar_Syntax_Subst.compress r in
                     uu____12405.FStar_Syntax_Syntax.n in
                   let uu____12408 =
                     let uu____12409 = FStar_Syntax_Subst.compress msg in
                     uu____12409.FStar_Syntax_Syntax.n in
                   (uu____12404, uu____12408) in
                 (match uu____12399 with
                  | (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range
                     r1),FStar_Syntax_Syntax.Tm_constant
                     (FStar_Const.Const_string (s,uu____12418))) ->
                      let phi3 =
                        FStar_Syntax_Syntax.mk
                          (FStar_Syntax_Syntax.Tm_meta
                             (phi2,
                               (FStar_Syntax_Syntax.Meta_labeled
                                  (s, r1, false))))
                          FStar_Pervasives_Native.None r1 in
                      fallback phi3
                  | uu____12424 -> fallback phi2)
             | (FStar_Syntax_Syntax.Tm_fvar fv,(t,uu____12431)::[]) when
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.squash_lid)
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.auto_squash_lid)
                 -> encode_formula t env
             | uu____12456 when head_redex env head2 ->
                 let uu____12469 = whnf env phi1 in
                 encode_formula uu____12469 env
             | uu____12470 ->
                 let uu____12483 = encode_term phi1 env in
                 (match uu____12483 with
                  | (tt,decls) ->
                      let uu____12494 =
                        FStar_SMTEncoding_Term.mk_Valid
                          (let uu___114_12497 = tt in
                           {
                             FStar_SMTEncoding_Term.tm =
                               (uu___114_12497.FStar_SMTEncoding_Term.tm);
                             FStar_SMTEncoding_Term.freevars =
                               (uu___114_12497.FStar_SMTEncoding_Term.freevars);
                             FStar_SMTEncoding_Term.rng =
                               (phi1.FStar_Syntax_Syntax.pos)
                           }) in
                      (uu____12494, decls)))
        | uu____12498 ->
            let uu____12499 = encode_term phi1 env in
            (match uu____12499 with
             | (tt,decls) ->
                 let uu____12510 =
                   FStar_SMTEncoding_Term.mk_Valid
                     (let uu___115_12513 = tt in
                      {
                        FStar_SMTEncoding_Term.tm =
                          (uu___115_12513.FStar_SMTEncoding_Term.tm);
                        FStar_SMTEncoding_Term.freevars =
                          (uu___115_12513.FStar_SMTEncoding_Term.freevars);
                        FStar_SMTEncoding_Term.rng =
                          (phi1.FStar_Syntax_Syntax.pos)
                      }) in
                 (uu____12510, decls)) in
      let encode_q_body env1 bs ps body =
        let uu____12549 = encode_binders FStar_Pervasives_Native.None bs env1 in
        match uu____12549 with
        | (vars,guards,env2,decls,uu____12588) ->
            let uu____12601 =
              let uu____12614 =
                FStar_All.pipe_right ps
                  (FStar_List.map
                     (fun p  ->
                        let uu____12666 =
                          let uu____12677 =
                            FStar_All.pipe_right p
                              (FStar_List.map
                                 (fun uu____12717  ->
                                    match uu____12717 with
                                    | (t,uu____12731) ->
                                        encode_smt_pattern t
                                          (let uu___116_12737 = env2 in
                                           {
                                             bindings =
                                               (uu___116_12737.bindings);
                                             depth = (uu___116_12737.depth);
                                             tcenv = (uu___116_12737.tcenv);
                                             warn = (uu___116_12737.warn);
                                             cache = (uu___116_12737.cache);
                                             nolabels =
                                               (uu___116_12737.nolabels);
                                             use_zfuel_name = true;
                                             encode_non_total_function_typ =
                                               (uu___116_12737.encode_non_total_function_typ);
                                             current_module_name =
                                               (uu___116_12737.current_module_name)
                                           }))) in
                          FStar_All.pipe_right uu____12677 FStar_List.unzip in
                        match uu____12666 with
                        | (p1,decls1) -> (p1, (FStar_List.flatten decls1)))) in
              FStar_All.pipe_right uu____12614 FStar_List.unzip in
            (match uu____12601 with
             | (pats,decls') ->
                 let uu____12846 = encode_formula body env2 in
                 (match uu____12846 with
                  | (body1,decls'') ->
                      let guards1 =
                        match pats with
                        | ({
                             FStar_SMTEncoding_Term.tm =
                               FStar_SMTEncoding_Term.App
                               (FStar_SMTEncoding_Term.Var gf,p::[]);
                             FStar_SMTEncoding_Term.freevars = uu____12878;
                             FStar_SMTEncoding_Term.rng = uu____12879;_}::[])::[]
                            when
                            (FStar_Ident.text_of_lid
                               FStar_Parser_Const.guard_free)
                              = gf
                            -> []
                        | uu____12894 -> guards in
                      let uu____12899 =
                        FStar_SMTEncoding_Util.mk_and_l guards1 in
                      (vars, pats, uu____12899, body1,
                        (FStar_List.append decls
                           (FStar_List.append (FStar_List.flatten decls')
                              decls''))))) in
      debug1 phi;
      (let phi1 = FStar_Syntax_Util.unascribe phi in
       let check_pattern_vars vars pats =
         let pats1 =
           FStar_All.pipe_right pats
             (FStar_List.map
                (fun uu____12959  ->
                   match uu____12959 with
                   | (x,uu____12965) ->
                       FStar_TypeChecker_Normalize.normalize
                         [FStar_TypeChecker_Normalize.Beta;
                         FStar_TypeChecker_Normalize.AllowUnboundUniverses;
                         FStar_TypeChecker_Normalize.EraseUniverses]
                         env.tcenv x)) in
         match pats1 with
         | [] -> ()
         | hd1::tl1 ->
             let pat_vars =
               let uu____12973 = FStar_Syntax_Free.names hd1 in
               FStar_List.fold_left
                 (fun out  ->
                    fun x  ->
                      let uu____12985 = FStar_Syntax_Free.names x in
                      FStar_Util.set_union out uu____12985) uu____12973 tl1 in
             let uu____12988 =
               FStar_All.pipe_right vars
                 (FStar_Util.find_opt
                    (fun uu____13015  ->
                       match uu____13015 with
                       | (b,uu____13021) ->
                           let uu____13022 = FStar_Util.set_mem b pat_vars in
                           Prims.op_Negation uu____13022)) in
             (match uu____12988 with
              | FStar_Pervasives_Native.None  -> ()
              | FStar_Pervasives_Native.Some (x,uu____13028) ->
                  let pos =
                    FStar_List.fold_left
                      (fun out  ->
                         fun t  ->
                           FStar_Range.union_ranges out
                             t.FStar_Syntax_Syntax.pos)
                      hd1.FStar_Syntax_Syntax.pos tl1 in
                  let uu____13042 =
                    let uu____13047 =
                      let uu____13048 = FStar_Syntax_Print.bv_to_string x in
                      FStar_Util.format1
                        "SMT pattern misses at least one bound variable: %s"
                        uu____13048 in
                    (FStar_Errors.Warning_SMTPatternMissingBoundVar,
                      uu____13047) in
                  FStar_Errors.log_issue pos uu____13042) in
       let uu____13049 = FStar_Syntax_Util.destruct_typ_as_formula phi1 in
       match uu____13049 with
       | FStar_Pervasives_Native.None  -> fallback phi1
       | FStar_Pervasives_Native.Some (FStar_Syntax_Util.BaseConn (op,arms))
           ->
           let uu____13058 =
             FStar_All.pipe_right connectives
               (FStar_List.tryFind
                  (fun uu____13116  ->
                     match uu____13116 with
                     | (l,uu____13130) -> FStar_Ident.lid_equals op l)) in
           (match uu____13058 with
            | FStar_Pervasives_Native.None  -> fallback phi1
            | FStar_Pervasives_Native.Some (uu____13163,f) ->
                f phi1.FStar_Syntax_Syntax.pos arms)
       | FStar_Pervasives_Native.Some (FStar_Syntax_Util.QAll
           (vars,pats,body)) ->
           (FStar_All.pipe_right pats
              (FStar_List.iter (check_pattern_vars vars));
            (let uu____13203 = encode_q_body env vars pats body in
             match uu____13203 with
             | (vars1,pats1,guard,body1,decls) ->
                 let tm =
                   let uu____13248 =
                     let uu____13259 =
                       FStar_SMTEncoding_Util.mkImp (guard, body1) in
                     (pats1, vars1, uu____13259) in
                   FStar_SMTEncoding_Term.mkForall uu____13248
                     phi1.FStar_Syntax_Syntax.pos in
                 (tm, decls)))
       | FStar_Pervasives_Native.Some (FStar_Syntax_Util.QEx
           (vars,pats,body)) ->
           (FStar_All.pipe_right pats
              (FStar_List.iter (check_pattern_vars vars));
            (let uu____13278 = encode_q_body env vars pats body in
             match uu____13278 with
             | (vars1,pats1,guard,body1,decls) ->
                 let uu____13322 =
                   let uu____13323 =
                     let uu____13334 =
                       FStar_SMTEncoding_Util.mkAnd (guard, body1) in
                     (pats1, vars1, uu____13334) in
                   FStar_SMTEncoding_Term.mkExists uu____13323
                     phi1.FStar_Syntax_Syntax.pos in
                 (uu____13322, decls))))
type prims_t =
  {
  mk:
    FStar_Ident.lident ->
      Prims.string ->
        (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decl Prims.list)
          FStar_Pervasives_Native.tuple2;
  is: FStar_Ident.lident -> Prims.bool;}[@@deriving show]
let __proj__Mkprims_t__item__mk:
  prims_t ->
    FStar_Ident.lident ->
      Prims.string ->
        (FStar_SMTEncoding_Term.term,FStar_SMTEncoding_Term.decl Prims.list)
          FStar_Pervasives_Native.tuple2
  =
  fun projectee  ->
    match projectee with
    | { mk = __fname__mk; is = __fname__is;_} -> __fname__mk
let __proj__Mkprims_t__item__is: prims_t -> FStar_Ident.lident -> Prims.bool
  =
  fun projectee  ->
    match projectee with
    | { mk = __fname__mk; is = __fname__is;_} -> __fname__is
let prims: prims_t =
  let uu____13427 = fresh_fvar "a" FStar_SMTEncoding_Term.Term_sort in
  match uu____13427 with
  | (asym,a) ->
      let uu____13434 = fresh_fvar "x" FStar_SMTEncoding_Term.Term_sort in
      (match uu____13434 with
       | (xsym,x) ->
           let uu____13441 = fresh_fvar "y" FStar_SMTEncoding_Term.Term_sort in
           (match uu____13441 with
            | (ysym,y) ->
                let quant vars body x1 =
                  let xname_decl =
                    let uu____13485 =
                      let uu____13496 =
                        FStar_All.pipe_right vars
                          (FStar_List.map FStar_Pervasives_Native.snd) in
                      (x1, uu____13496, FStar_SMTEncoding_Term.Term_sort,
                        FStar_Pervasives_Native.None) in
                    FStar_SMTEncoding_Term.DeclFun uu____13485 in
                  let xtok = Prims.strcat x1 "@tok" in
                  let xtok_decl =
                    FStar_SMTEncoding_Term.DeclFun
                      (xtok, [], FStar_SMTEncoding_Term.Term_sort,
                        FStar_Pervasives_Native.None) in
                  let xapp =
                    let uu____13522 =
                      let uu____13529 =
                        FStar_List.map FStar_SMTEncoding_Util.mkFreeV vars in
                      (x1, uu____13529) in
                    FStar_SMTEncoding_Util.mkApp uu____13522 in
                  let xtok1 = FStar_SMTEncoding_Util.mkApp (xtok, []) in
                  let xtok_app = mk_Apply xtok1 vars in
                  let uu____13542 =
                    let uu____13545 =
                      let uu____13548 =
                        let uu____13551 =
                          let uu____13552 =
                            let uu____13559 =
                              let uu____13560 =
                                let uu____13571 =
                                  FStar_SMTEncoding_Util.mkEq (xapp, body) in
                                ([[xapp]], vars, uu____13571) in
                              FStar_SMTEncoding_Util.mkForall uu____13560 in
                            (uu____13559, FStar_Pervasives_Native.None,
                              (Prims.strcat "primitive_" x1)) in
                          FStar_SMTEncoding_Util.mkAssume uu____13552 in
                        let uu____13588 =
                          let uu____13591 =
                            let uu____13592 =
                              let uu____13599 =
                                let uu____13600 =
                                  let uu____13611 =
                                    FStar_SMTEncoding_Util.mkEq
                                      (xtok_app, xapp) in
                                  ([[xtok_app]], vars, uu____13611) in
                                FStar_SMTEncoding_Util.mkForall uu____13600 in
                              (uu____13599,
                                (FStar_Pervasives_Native.Some
                                   "Name-token correspondence"),
                                (Prims.strcat "token_correspondence_" x1)) in
                            FStar_SMTEncoding_Util.mkAssume uu____13592 in
                          [uu____13591] in
                        uu____13551 :: uu____13588 in
                      xtok_decl :: uu____13548 in
                    xname_decl :: uu____13545 in
                  (xtok1, uu____13542) in
                let axy =
                  [(asym, FStar_SMTEncoding_Term.Term_sort);
                  (xsym, FStar_SMTEncoding_Term.Term_sort);
                  (ysym, FStar_SMTEncoding_Term.Term_sort)] in
                let xy =
                  [(xsym, FStar_SMTEncoding_Term.Term_sort);
                  (ysym, FStar_SMTEncoding_Term.Term_sort)] in
                let qx = [(xsym, FStar_SMTEncoding_Term.Term_sort)] in
                let prims1 =
                  let uu____13702 =
                    let uu____13715 =
                      let uu____13724 =
                        let uu____13725 = FStar_SMTEncoding_Util.mkEq (x, y) in
                        FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool
                          uu____13725 in
                      quant axy uu____13724 in
                    (FStar_Parser_Const.op_Eq, uu____13715) in
                  let uu____13734 =
                    let uu____13749 =
                      let uu____13762 =
                        let uu____13771 =
                          let uu____13772 =
                            let uu____13773 =
                              FStar_SMTEncoding_Util.mkEq (x, y) in
                            FStar_SMTEncoding_Util.mkNot uu____13773 in
                          FStar_All.pipe_left FStar_SMTEncoding_Term.boxBool
                            uu____13772 in
                        quant axy uu____13771 in
                      (FStar_Parser_Const.op_notEq, uu____13762) in
                    let uu____13782 =
                      let uu____13797 =
                        let uu____13810 =
                          let uu____13819 =
                            let uu____13820 =
                              let uu____13821 =
                                let uu____13826 =
                                  FStar_SMTEncoding_Term.unboxInt x in
                                let uu____13827 =
                                  FStar_SMTEncoding_Term.unboxInt y in
                                (uu____13826, uu____13827) in
                              FStar_SMTEncoding_Util.mkLT uu____13821 in
                            FStar_All.pipe_left
                              FStar_SMTEncoding_Term.boxBool uu____13820 in
                          quant xy uu____13819 in
                        (FStar_Parser_Const.op_LT, uu____13810) in
                      let uu____13836 =
                        let uu____13851 =
                          let uu____13864 =
                            let uu____13873 =
                              let uu____13874 =
                                let uu____13875 =
                                  let uu____13880 =
                                    FStar_SMTEncoding_Term.unboxInt x in
                                  let uu____13881 =
                                    FStar_SMTEncoding_Term.unboxInt y in
                                  (uu____13880, uu____13881) in
                                FStar_SMTEncoding_Util.mkLTE uu____13875 in
                              FStar_All.pipe_left
                                FStar_SMTEncoding_Term.boxBool uu____13874 in
                            quant xy uu____13873 in
                          (FStar_Parser_Const.op_LTE, uu____13864) in
                        let uu____13890 =
                          let uu____13905 =
                            let uu____13918 =
                              let uu____13927 =
                                let uu____13928 =
                                  let uu____13929 =
                                    let uu____13934 =
                                      FStar_SMTEncoding_Term.unboxInt x in
                                    let uu____13935 =
                                      FStar_SMTEncoding_Term.unboxInt y in
                                    (uu____13934, uu____13935) in
                                  FStar_SMTEncoding_Util.mkGT uu____13929 in
                                FStar_All.pipe_left
                                  FStar_SMTEncoding_Term.boxBool uu____13928 in
                              quant xy uu____13927 in
                            (FStar_Parser_Const.op_GT, uu____13918) in
                          let uu____13944 =
                            let uu____13959 =
                              let uu____13972 =
                                let uu____13981 =
                                  let uu____13982 =
                                    let uu____13983 =
                                      let uu____13988 =
                                        FStar_SMTEncoding_Term.unboxInt x in
                                      let uu____13989 =
                                        FStar_SMTEncoding_Term.unboxInt y in
                                      (uu____13988, uu____13989) in
                                    FStar_SMTEncoding_Util.mkGTE uu____13983 in
                                  FStar_All.pipe_left
                                    FStar_SMTEncoding_Term.boxBool
                                    uu____13982 in
                                quant xy uu____13981 in
                              (FStar_Parser_Const.op_GTE, uu____13972) in
                            let uu____13998 =
                              let uu____14013 =
                                let uu____14026 =
                                  let uu____14035 =
                                    let uu____14036 =
                                      let uu____14037 =
                                        let uu____14042 =
                                          FStar_SMTEncoding_Term.unboxInt x in
                                        let uu____14043 =
                                          FStar_SMTEncoding_Term.unboxInt y in
                                        (uu____14042, uu____14043) in
                                      FStar_SMTEncoding_Util.mkSub
                                        uu____14037 in
                                    FStar_All.pipe_left
                                      FStar_SMTEncoding_Term.boxInt
                                      uu____14036 in
                                  quant xy uu____14035 in
                                (FStar_Parser_Const.op_Subtraction,
                                  uu____14026) in
                              let uu____14052 =
                                let uu____14067 =
                                  let uu____14080 =
                                    let uu____14089 =
                                      let uu____14090 =
                                        let uu____14091 =
                                          FStar_SMTEncoding_Term.unboxInt x in
                                        FStar_SMTEncoding_Util.mkMinus
                                          uu____14091 in
                                      FStar_All.pipe_left
                                        FStar_SMTEncoding_Term.boxInt
                                        uu____14090 in
                                    quant qx uu____14089 in
                                  (FStar_Parser_Const.op_Minus, uu____14080) in
                                let uu____14100 =
                                  let uu____14115 =
                                    let uu____14128 =
                                      let uu____14137 =
                                        let uu____14138 =
                                          let uu____14139 =
                                            let uu____14144 =
                                              FStar_SMTEncoding_Term.unboxInt
                                                x in
                                            let uu____14145 =
                                              FStar_SMTEncoding_Term.unboxInt
                                                y in
                                            (uu____14144, uu____14145) in
                                          FStar_SMTEncoding_Util.mkAdd
                                            uu____14139 in
                                        FStar_All.pipe_left
                                          FStar_SMTEncoding_Term.boxInt
                                          uu____14138 in
                                      quant xy uu____14137 in
                                    (FStar_Parser_Const.op_Addition,
                                      uu____14128) in
                                  let uu____14154 =
                                    let uu____14169 =
                                      let uu____14182 =
                                        let uu____14191 =
                                          let uu____14192 =
                                            let uu____14193 =
                                              let uu____14198 =
                                                FStar_SMTEncoding_Term.unboxInt
                                                  x in
                                              let uu____14199 =
                                                FStar_SMTEncoding_Term.unboxInt
                                                  y in
                                              (uu____14198, uu____14199) in
                                            FStar_SMTEncoding_Util.mkMul
                                              uu____14193 in
                                          FStar_All.pipe_left
                                            FStar_SMTEncoding_Term.boxInt
                                            uu____14192 in
                                        quant xy uu____14191 in
                                      (FStar_Parser_Const.op_Multiply,
                                        uu____14182) in
                                    let uu____14208 =
                                      let uu____14223 =
                                        let uu____14236 =
                                          let uu____14245 =
                                            let uu____14246 =
                                              let uu____14247 =
                                                let uu____14252 =
                                                  FStar_SMTEncoding_Term.unboxInt
                                                    x in
                                                let uu____14253 =
                                                  FStar_SMTEncoding_Term.unboxInt
                                                    y in
                                                (uu____14252, uu____14253) in
                                              FStar_SMTEncoding_Util.mkDiv
                                                uu____14247 in
                                            FStar_All.pipe_left
                                              FStar_SMTEncoding_Term.boxInt
                                              uu____14246 in
                                          quant xy uu____14245 in
                                        (FStar_Parser_Const.op_Division,
                                          uu____14236) in
                                      let uu____14262 =
                                        let uu____14277 =
                                          let uu____14290 =
                                            let uu____14299 =
                                              let uu____14300 =
                                                let uu____14301 =
                                                  let uu____14306 =
                                                    FStar_SMTEncoding_Term.unboxInt
                                                      x in
                                                  let uu____14307 =
                                                    FStar_SMTEncoding_Term.unboxInt
                                                      y in
                                                  (uu____14306, uu____14307) in
                                                FStar_SMTEncoding_Util.mkMod
                                                  uu____14301 in
                                              FStar_All.pipe_left
                                                FStar_SMTEncoding_Term.boxInt
                                                uu____14300 in
                                            quant xy uu____14299 in
                                          (FStar_Parser_Const.op_Modulus,
                                            uu____14290) in
                                        let uu____14316 =
                                          let uu____14331 =
                                            let uu____14344 =
                                              let uu____14353 =
                                                let uu____14354 =
                                                  let uu____14355 =
                                                    let uu____14360 =
                                                      FStar_SMTEncoding_Term.unboxBool
                                                        x in
                                                    let uu____14361 =
                                                      FStar_SMTEncoding_Term.unboxBool
                                                        y in
                                                    (uu____14360,
                                                      uu____14361) in
                                                  FStar_SMTEncoding_Util.mkAnd
                                                    uu____14355 in
                                                FStar_All.pipe_left
                                                  FStar_SMTEncoding_Term.boxBool
                                                  uu____14354 in
                                              quant xy uu____14353 in
                                            (FStar_Parser_Const.op_And,
                                              uu____14344) in
                                          let uu____14370 =
                                            let uu____14385 =
                                              let uu____14398 =
                                                let uu____14407 =
                                                  let uu____14408 =
                                                    let uu____14409 =
                                                      let uu____14414 =
                                                        FStar_SMTEncoding_Term.unboxBool
                                                          x in
                                                      let uu____14415 =
                                                        FStar_SMTEncoding_Term.unboxBool
                                                          y in
                                                      (uu____14414,
                                                        uu____14415) in
                                                    FStar_SMTEncoding_Util.mkOr
                                                      uu____14409 in
                                                  FStar_All.pipe_left
                                                    FStar_SMTEncoding_Term.boxBool
                                                    uu____14408 in
                                                quant xy uu____14407 in
                                              (FStar_Parser_Const.op_Or,
                                                uu____14398) in
                                            let uu____14424 =
                                              let uu____14439 =
                                                let uu____14452 =
                                                  let uu____14461 =
                                                    let uu____14462 =
                                                      let uu____14463 =
                                                        FStar_SMTEncoding_Term.unboxBool
                                                          x in
                                                      FStar_SMTEncoding_Util.mkNot
                                                        uu____14463 in
                                                    FStar_All.pipe_left
                                                      FStar_SMTEncoding_Term.boxBool
                                                      uu____14462 in
                                                  quant qx uu____14461 in
                                                (FStar_Parser_Const.op_Negation,
                                                  uu____14452) in
                                              [uu____14439] in
                                            uu____14385 :: uu____14424 in
                                          uu____14331 :: uu____14370 in
                                        uu____14277 :: uu____14316 in
                                      uu____14223 :: uu____14262 in
                                    uu____14169 :: uu____14208 in
                                  uu____14115 :: uu____14154 in
                                uu____14067 :: uu____14100 in
                              uu____14013 :: uu____14052 in
                            uu____13959 :: uu____13998 in
                          uu____13905 :: uu____13944 in
                        uu____13851 :: uu____13890 in
                      uu____13797 :: uu____13836 in
                    uu____13749 :: uu____13782 in
                  uu____13702 :: uu____13734 in
                let mk1 l v1 =
                  let uu____14677 =
                    let uu____14686 =
                      FStar_All.pipe_right prims1
                        (FStar_List.find
                           (fun uu____14744  ->
                              match uu____14744 with
                              | (l',uu____14758) ->
                                  FStar_Ident.lid_equals l l')) in
                    FStar_All.pipe_right uu____14686
                      (FStar_Option.map
                         (fun uu____14818  ->
                            match uu____14818 with | (uu____14837,b) -> b v1)) in
                  FStar_All.pipe_right uu____14677 FStar_Option.get in
                let is l =
                  FStar_All.pipe_right prims1
                    (FStar_Util.for_some
                       (fun uu____14908  ->
                          match uu____14908 with
                          | (l',uu____14922) -> FStar_Ident.lid_equals l l')) in
                { mk = mk1; is }))
let pretype_axiom:
  env_t ->
    FStar_SMTEncoding_Term.term ->
      (Prims.string,FStar_SMTEncoding_Term.sort)
        FStar_Pervasives_Native.tuple2 Prims.list ->
        FStar_SMTEncoding_Term.decl
  =
  fun env  ->
    fun tapp  ->
      fun vars  ->
        let uu____14960 = fresh_fvar "x" FStar_SMTEncoding_Term.Term_sort in
        match uu____14960 with
        | (xxsym,xx) ->
            let uu____14967 = fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort in
            (match uu____14967 with
             | (ffsym,ff) ->
                 let xx_has_type =
                   FStar_SMTEncoding_Term.mk_HasTypeFuel ff xx tapp in
                 let tapp_hash = FStar_SMTEncoding_Term.hash_of_term tapp in
                 let module_name = env.current_module_name in
                 let uu____14977 =
                   let uu____14984 =
                     let uu____14985 =
                       let uu____14996 =
                         let uu____14997 =
                           let uu____15002 =
                             let uu____15003 =
                               let uu____15008 =
                                 FStar_SMTEncoding_Util.mkApp
                                   ("PreType", [xx]) in
                               (tapp, uu____15008) in
                             FStar_SMTEncoding_Util.mkEq uu____15003 in
                           (xx_has_type, uu____15002) in
                         FStar_SMTEncoding_Util.mkImp uu____14997 in
                       ([[xx_has_type]],
                         ((xxsym, FStar_SMTEncoding_Term.Term_sort) ::
                         (ffsym, FStar_SMTEncoding_Term.Fuel_sort) :: vars),
                         uu____14996) in
                     FStar_SMTEncoding_Util.mkForall uu____14985 in
                   let uu____15033 =
                     let uu____15034 =
                       let uu____15035 =
                         let uu____15036 =
                           FStar_Util.digest_of_string tapp_hash in
                         Prims.strcat "_pretyping_" uu____15036 in
                       Prims.strcat module_name uu____15035 in
                     varops.mk_unique uu____15034 in
                   (uu____14984, (FStar_Pervasives_Native.Some "pretyping"),
                     uu____15033) in
                 FStar_SMTEncoding_Util.mkAssume uu____14977)
let primitive_type_axioms:
  FStar_TypeChecker_Env.env ->
    FStar_Ident.lident ->
      Prims.string ->
        FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.decl Prims.list
  =
  let xx = ("x", FStar_SMTEncoding_Term.Term_sort) in
  let x = FStar_SMTEncoding_Util.mkFreeV xx in
  let yy = ("y", FStar_SMTEncoding_Term.Term_sort) in
  let y = FStar_SMTEncoding_Util.mkFreeV yy in
  let mk_unit env nm tt =
    let typing_pred = FStar_SMTEncoding_Term.mk_HasType x tt in
    let uu____15072 =
      let uu____15073 =
        let uu____15080 =
          FStar_SMTEncoding_Term.mk_HasType
            FStar_SMTEncoding_Term.mk_Term_unit tt in
        (uu____15080, (FStar_Pervasives_Native.Some "unit typing"),
          "unit_typing") in
      FStar_SMTEncoding_Util.mkAssume uu____15073 in
    let uu____15083 =
      let uu____15086 =
        let uu____15087 =
          let uu____15094 =
            let uu____15095 =
              let uu____15106 =
                let uu____15107 =
                  let uu____15112 =
                    FStar_SMTEncoding_Util.mkEq
                      (x, FStar_SMTEncoding_Term.mk_Term_unit) in
                  (typing_pred, uu____15112) in
                FStar_SMTEncoding_Util.mkImp uu____15107 in
              ([[typing_pred]], [xx], uu____15106) in
            mkForall_fuel uu____15095 in
          (uu____15094, (FStar_Pervasives_Native.Some "unit inversion"),
            "unit_inversion") in
        FStar_SMTEncoding_Util.mkAssume uu____15087 in
      [uu____15086] in
    uu____15072 :: uu____15083 in
  let mk_bool env nm tt =
    let typing_pred = FStar_SMTEncoding_Term.mk_HasType x tt in
    let bb = ("b", FStar_SMTEncoding_Term.Bool_sort) in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let uu____15154 =
      let uu____15155 =
        let uu____15162 =
          let uu____15163 =
            let uu____15174 =
              let uu____15179 =
                let uu____15182 = FStar_SMTEncoding_Term.boxBool b in
                [uu____15182] in
              [uu____15179] in
            let uu____15187 =
              let uu____15188 = FStar_SMTEncoding_Term.boxBool b in
              FStar_SMTEncoding_Term.mk_HasType uu____15188 tt in
            (uu____15174, [bb], uu____15187) in
          FStar_SMTEncoding_Util.mkForall uu____15163 in
        (uu____15162, (FStar_Pervasives_Native.Some "bool typing"),
          "bool_typing") in
      FStar_SMTEncoding_Util.mkAssume uu____15155 in
    let uu____15209 =
      let uu____15212 =
        let uu____15213 =
          let uu____15220 =
            let uu____15221 =
              let uu____15232 =
                let uu____15233 =
                  let uu____15238 =
                    FStar_SMTEncoding_Term.mk_tester
                      (FStar_Pervasives_Native.fst
                         FStar_SMTEncoding_Term.boxBoolFun) x in
                  (typing_pred, uu____15238) in
                FStar_SMTEncoding_Util.mkImp uu____15233 in
              ([[typing_pred]], [xx], uu____15232) in
            mkForall_fuel uu____15221 in
          (uu____15220, (FStar_Pervasives_Native.Some "bool inversion"),
            "bool_inversion") in
        FStar_SMTEncoding_Util.mkAssume uu____15213 in
      [uu____15212] in
    uu____15154 :: uu____15209 in
  let mk_int env nm tt =
    let typing_pred = FStar_SMTEncoding_Term.mk_HasType x tt in
    let typing_pred_y = FStar_SMTEncoding_Term.mk_HasType y tt in
    let aa = ("a", FStar_SMTEncoding_Term.Int_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let bb = ("b", FStar_SMTEncoding_Term.Int_sort) in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let precedes =
      let uu____15288 =
        let uu____15289 =
          let uu____15296 =
            let uu____15299 =
              let uu____15302 =
                let uu____15305 = FStar_SMTEncoding_Term.boxInt a in
                let uu____15306 =
                  let uu____15309 = FStar_SMTEncoding_Term.boxInt b in
                  [uu____15309] in
                uu____15305 :: uu____15306 in
              tt :: uu____15302 in
            tt :: uu____15299 in
          ("Prims.Precedes", uu____15296) in
        FStar_SMTEncoding_Util.mkApp uu____15289 in
      FStar_All.pipe_left FStar_SMTEncoding_Term.mk_Valid uu____15288 in
    let precedes_y_x =
      let uu____15313 = FStar_SMTEncoding_Util.mkApp ("Precedes", [y; x]) in
      FStar_All.pipe_left FStar_SMTEncoding_Term.mk_Valid uu____15313 in
    let uu____15316 =
      let uu____15317 =
        let uu____15324 =
          let uu____15325 =
            let uu____15336 =
              let uu____15341 =
                let uu____15344 = FStar_SMTEncoding_Term.boxInt b in
                [uu____15344] in
              [uu____15341] in
            let uu____15349 =
              let uu____15350 = FStar_SMTEncoding_Term.boxInt b in
              FStar_SMTEncoding_Term.mk_HasType uu____15350 tt in
            (uu____15336, [bb], uu____15349) in
          FStar_SMTEncoding_Util.mkForall uu____15325 in
        (uu____15324, (FStar_Pervasives_Native.Some "int typing"),
          "int_typing") in
      FStar_SMTEncoding_Util.mkAssume uu____15317 in
    let uu____15371 =
      let uu____15374 =
        let uu____15375 =
          let uu____15382 =
            let uu____15383 =
              let uu____15394 =
                let uu____15395 =
                  let uu____15400 =
                    FStar_SMTEncoding_Term.mk_tester
                      (FStar_Pervasives_Native.fst
                         FStar_SMTEncoding_Term.boxIntFun) x in
                  (typing_pred, uu____15400) in
                FStar_SMTEncoding_Util.mkImp uu____15395 in
              ([[typing_pred]], [xx], uu____15394) in
            mkForall_fuel uu____15383 in
          (uu____15382, (FStar_Pervasives_Native.Some "int inversion"),
            "int_inversion") in
        FStar_SMTEncoding_Util.mkAssume uu____15375 in
      let uu____15425 =
        let uu____15428 =
          let uu____15429 =
            let uu____15436 =
              let uu____15437 =
                let uu____15448 =
                  let uu____15449 =
                    let uu____15454 =
                      let uu____15455 =
                        let uu____15458 =
                          let uu____15461 =
                            let uu____15464 =
                              let uu____15465 =
                                let uu____15470 =
                                  FStar_SMTEncoding_Term.unboxInt x in
                                let uu____15471 =
                                  FStar_SMTEncoding_Util.mkInteger'
                                    (Prims.parse_int "0") in
                                (uu____15470, uu____15471) in
                              FStar_SMTEncoding_Util.mkGT uu____15465 in
                            let uu____15472 =
                              let uu____15475 =
                                let uu____15476 =
                                  let uu____15481 =
                                    FStar_SMTEncoding_Term.unboxInt y in
                                  let uu____15482 =
                                    FStar_SMTEncoding_Util.mkInteger'
                                      (Prims.parse_int "0") in
                                  (uu____15481, uu____15482) in
                                FStar_SMTEncoding_Util.mkGTE uu____15476 in
                              let uu____15483 =
                                let uu____15486 =
                                  let uu____15487 =
                                    let uu____15492 =
                                      FStar_SMTEncoding_Term.unboxInt y in
                                    let uu____15493 =
                                      FStar_SMTEncoding_Term.unboxInt x in
                                    (uu____15492, uu____15493) in
                                  FStar_SMTEncoding_Util.mkLT uu____15487 in
                                [uu____15486] in
                              uu____15475 :: uu____15483 in
                            uu____15464 :: uu____15472 in
                          typing_pred_y :: uu____15461 in
                        typing_pred :: uu____15458 in
                      FStar_SMTEncoding_Util.mk_and_l uu____15455 in
                    (uu____15454, precedes_y_x) in
                  FStar_SMTEncoding_Util.mkImp uu____15449 in
                ([[typing_pred; typing_pred_y; precedes_y_x]], [xx; yy],
                  uu____15448) in
              mkForall_fuel uu____15437 in
            (uu____15436,
              (FStar_Pervasives_Native.Some
                 "well-founded ordering on nat (alt)"),
              "well-founded-ordering-on-nat") in
          FStar_SMTEncoding_Util.mkAssume uu____15429 in
        [uu____15428] in
      uu____15374 :: uu____15425 in
    uu____15316 :: uu____15371 in
  let mk_str env nm tt =
    let typing_pred = FStar_SMTEncoding_Term.mk_HasType x tt in
    let bb = ("b", FStar_SMTEncoding_Term.String_sort) in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let uu____15539 =
      let uu____15540 =
        let uu____15547 =
          let uu____15548 =
            let uu____15559 =
              let uu____15564 =
                let uu____15567 = FStar_SMTEncoding_Term.boxString b in
                [uu____15567] in
              [uu____15564] in
            let uu____15572 =
              let uu____15573 = FStar_SMTEncoding_Term.boxString b in
              FStar_SMTEncoding_Term.mk_HasType uu____15573 tt in
            (uu____15559, [bb], uu____15572) in
          FStar_SMTEncoding_Util.mkForall uu____15548 in
        (uu____15547, (FStar_Pervasives_Native.Some "string typing"),
          "string_typing") in
      FStar_SMTEncoding_Util.mkAssume uu____15540 in
    let uu____15594 =
      let uu____15597 =
        let uu____15598 =
          let uu____15605 =
            let uu____15606 =
              let uu____15617 =
                let uu____15618 =
                  let uu____15623 =
                    FStar_SMTEncoding_Term.mk_tester
                      (FStar_Pervasives_Native.fst
                         FStar_SMTEncoding_Term.boxStringFun) x in
                  (typing_pred, uu____15623) in
                FStar_SMTEncoding_Util.mkImp uu____15618 in
              ([[typing_pred]], [xx], uu____15617) in
            mkForall_fuel uu____15606 in
          (uu____15605, (FStar_Pervasives_Native.Some "string inversion"),
            "string_inversion") in
        FStar_SMTEncoding_Util.mkAssume uu____15598 in
      [uu____15597] in
    uu____15539 :: uu____15594 in
  let mk_true_interp env nm true_tm =
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [true_tm]) in
    [FStar_SMTEncoding_Util.mkAssume
       (valid, (FStar_Pervasives_Native.Some "True interpretation"),
         "true_interp")] in
  let mk_false_interp env nm false_tm =
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [false_tm]) in
    let uu____15676 =
      let uu____15677 =
        let uu____15684 =
          FStar_SMTEncoding_Util.mkIff
            (FStar_SMTEncoding_Util.mkFalse, valid) in
        (uu____15684, (FStar_Pervasives_Native.Some "False interpretation"),
          "false_interp") in
      FStar_SMTEncoding_Util.mkAssume uu____15677 in
    [uu____15676] in
  let mk_and_interp env conj uu____15696 =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let l_and_a_b = FStar_SMTEncoding_Util.mkApp (conj, [a; b]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_and_a_b]) in
    let valid_a = FStar_SMTEncoding_Util.mkApp ("Valid", [a]) in
    let valid_b = FStar_SMTEncoding_Util.mkApp ("Valid", [b]) in
    let uu____15721 =
      let uu____15722 =
        let uu____15729 =
          let uu____15730 =
            let uu____15741 =
              let uu____15742 =
                let uu____15747 =
                  FStar_SMTEncoding_Util.mkAnd (valid_a, valid_b) in
                (uu____15747, valid) in
              FStar_SMTEncoding_Util.mkIff uu____15742 in
            ([[l_and_a_b]], [aa; bb], uu____15741) in
          FStar_SMTEncoding_Util.mkForall uu____15730 in
        (uu____15729, (FStar_Pervasives_Native.Some "/\\ interpretation"),
          "l_and-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____15722 in
    [uu____15721] in
  let mk_or_interp env disj uu____15785 =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let l_or_a_b = FStar_SMTEncoding_Util.mkApp (disj, [a; b]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_or_a_b]) in
    let valid_a = FStar_SMTEncoding_Util.mkApp ("Valid", [a]) in
    let valid_b = FStar_SMTEncoding_Util.mkApp ("Valid", [b]) in
    let uu____15810 =
      let uu____15811 =
        let uu____15818 =
          let uu____15819 =
            let uu____15830 =
              let uu____15831 =
                let uu____15836 =
                  FStar_SMTEncoding_Util.mkOr (valid_a, valid_b) in
                (uu____15836, valid) in
              FStar_SMTEncoding_Util.mkIff uu____15831 in
            ([[l_or_a_b]], [aa; bb], uu____15830) in
          FStar_SMTEncoding_Util.mkForall uu____15819 in
        (uu____15818, (FStar_Pervasives_Native.Some "\\/ interpretation"),
          "l_or-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____15811 in
    [uu____15810] in
  let mk_eq2_interp env eq2 tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let xx1 = ("x", FStar_SMTEncoding_Term.Term_sort) in
    let yy1 = ("y", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let x1 = FStar_SMTEncoding_Util.mkFreeV xx1 in
    let y1 = FStar_SMTEncoding_Util.mkFreeV yy1 in
    let eq2_x_y = FStar_SMTEncoding_Util.mkApp (eq2, [a; x1; y1]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [eq2_x_y]) in
    let uu____15899 =
      let uu____15900 =
        let uu____15907 =
          let uu____15908 =
            let uu____15919 =
              let uu____15920 =
                let uu____15925 = FStar_SMTEncoding_Util.mkEq (x1, y1) in
                (uu____15925, valid) in
              FStar_SMTEncoding_Util.mkIff uu____15920 in
            ([[eq2_x_y]], [aa; xx1; yy1], uu____15919) in
          FStar_SMTEncoding_Util.mkForall uu____15908 in
        (uu____15907, (FStar_Pervasives_Native.Some "Eq2 interpretation"),
          "eq2-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____15900 in
    [uu____15899] in
  let mk_eq3_interp env eq3 tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let xx1 = ("x", FStar_SMTEncoding_Term.Term_sort) in
    let yy1 = ("y", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let x1 = FStar_SMTEncoding_Util.mkFreeV xx1 in
    let y1 = FStar_SMTEncoding_Util.mkFreeV yy1 in
    let eq3_x_y = FStar_SMTEncoding_Util.mkApp (eq3, [a; b; x1; y1]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [eq3_x_y]) in
    let uu____15998 =
      let uu____15999 =
        let uu____16006 =
          let uu____16007 =
            let uu____16018 =
              let uu____16019 =
                let uu____16024 = FStar_SMTEncoding_Util.mkEq (x1, y1) in
                (uu____16024, valid) in
              FStar_SMTEncoding_Util.mkIff uu____16019 in
            ([[eq3_x_y]], [aa; bb; xx1; yy1], uu____16018) in
          FStar_SMTEncoding_Util.mkForall uu____16007 in
        (uu____16006, (FStar_Pervasives_Native.Some "Eq3 interpretation"),
          "eq3-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____15999 in
    [uu____15998] in
  let mk_imp_interp env imp tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let l_imp_a_b = FStar_SMTEncoding_Util.mkApp (imp, [a; b]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_imp_a_b]) in
    let valid_a = FStar_SMTEncoding_Util.mkApp ("Valid", [a]) in
    let valid_b = FStar_SMTEncoding_Util.mkApp ("Valid", [b]) in
    let uu____16095 =
      let uu____16096 =
        let uu____16103 =
          let uu____16104 =
            let uu____16115 =
              let uu____16116 =
                let uu____16121 =
                  FStar_SMTEncoding_Util.mkImp (valid_a, valid_b) in
                (uu____16121, valid) in
              FStar_SMTEncoding_Util.mkIff uu____16116 in
            ([[l_imp_a_b]], [aa; bb], uu____16115) in
          FStar_SMTEncoding_Util.mkForall uu____16104 in
        (uu____16103, (FStar_Pervasives_Native.Some "==> interpretation"),
          "l_imp-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____16096 in
    [uu____16095] in
  let mk_iff_interp env iff tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let l_iff_a_b = FStar_SMTEncoding_Util.mkApp (iff, [a; b]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_iff_a_b]) in
    let valid_a = FStar_SMTEncoding_Util.mkApp ("Valid", [a]) in
    let valid_b = FStar_SMTEncoding_Util.mkApp ("Valid", [b]) in
    let uu____16184 =
      let uu____16185 =
        let uu____16192 =
          let uu____16193 =
            let uu____16204 =
              let uu____16205 =
                let uu____16210 =
                  FStar_SMTEncoding_Util.mkIff (valid_a, valid_b) in
                (uu____16210, valid) in
              FStar_SMTEncoding_Util.mkIff uu____16205 in
            ([[l_iff_a_b]], [aa; bb], uu____16204) in
          FStar_SMTEncoding_Util.mkForall uu____16193 in
        (uu____16192, (FStar_Pervasives_Native.Some "<==> interpretation"),
          "l_iff-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____16185 in
    [uu____16184] in
  let mk_not_interp env l_not tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let l_not_a = FStar_SMTEncoding_Util.mkApp (l_not, [a]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_not_a]) in
    let not_valid_a =
      let uu____16262 = FStar_SMTEncoding_Util.mkApp ("Valid", [a]) in
      FStar_All.pipe_left FStar_SMTEncoding_Util.mkNot uu____16262 in
    let uu____16265 =
      let uu____16266 =
        let uu____16273 =
          let uu____16274 =
            let uu____16285 =
              FStar_SMTEncoding_Util.mkIff (not_valid_a, valid) in
            ([[l_not_a]], [aa], uu____16285) in
          FStar_SMTEncoding_Util.mkForall uu____16274 in
        (uu____16273, (FStar_Pervasives_Native.Some "not interpretation"),
          "l_not-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____16266 in
    [uu____16265] in
  let mk_forall_interp env for_all1 tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let xx1 = ("x", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let x1 = FStar_SMTEncoding_Util.mkFreeV xx1 in
    let l_forall_a_b = FStar_SMTEncoding_Util.mkApp (for_all1, [a; b]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_forall_a_b]) in
    let valid_b_x =
      let uu____16345 =
        let uu____16352 =
          let uu____16355 = FStar_SMTEncoding_Util.mk_ApplyTT b x1 in
          [uu____16355] in
        ("Valid", uu____16352) in
      FStar_SMTEncoding_Util.mkApp uu____16345 in
    let uu____16358 =
      let uu____16359 =
        let uu____16366 =
          let uu____16367 =
            let uu____16378 =
              let uu____16379 =
                let uu____16384 =
                  let uu____16385 =
                    let uu____16396 =
                      let uu____16401 =
                        let uu____16404 =
                          FStar_SMTEncoding_Term.mk_HasTypeZ x1 a in
                        [uu____16404] in
                      [uu____16401] in
                    let uu____16409 =
                      let uu____16410 =
                        let uu____16415 =
                          FStar_SMTEncoding_Term.mk_HasTypeZ x1 a in
                        (uu____16415, valid_b_x) in
                      FStar_SMTEncoding_Util.mkImp uu____16410 in
                    (uu____16396, [xx1], uu____16409) in
                  FStar_SMTEncoding_Util.mkForall uu____16385 in
                (uu____16384, valid) in
              FStar_SMTEncoding_Util.mkIff uu____16379 in
            ([[l_forall_a_b]], [aa; bb], uu____16378) in
          FStar_SMTEncoding_Util.mkForall uu____16367 in
        (uu____16366, (FStar_Pervasives_Native.Some "forall interpretation"),
          "forall-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____16359 in
    [uu____16358] in
  let mk_exists_interp env for_some1 tt =
    let aa = ("a", FStar_SMTEncoding_Term.Term_sort) in
    let bb = ("b", FStar_SMTEncoding_Term.Term_sort) in
    let xx1 = ("x", FStar_SMTEncoding_Term.Term_sort) in
    let a = FStar_SMTEncoding_Util.mkFreeV aa in
    let b = FStar_SMTEncoding_Util.mkFreeV bb in
    let x1 = FStar_SMTEncoding_Util.mkFreeV xx1 in
    let l_exists_a_b = FStar_SMTEncoding_Util.mkApp (for_some1, [a; b]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [l_exists_a_b]) in
    let valid_b_x =
      let uu____16497 =
        let uu____16504 =
          let uu____16507 = FStar_SMTEncoding_Util.mk_ApplyTT b x1 in
          [uu____16507] in
        ("Valid", uu____16504) in
      FStar_SMTEncoding_Util.mkApp uu____16497 in
    let uu____16510 =
      let uu____16511 =
        let uu____16518 =
          let uu____16519 =
            let uu____16530 =
              let uu____16531 =
                let uu____16536 =
                  let uu____16537 =
                    let uu____16548 =
                      let uu____16553 =
                        let uu____16556 =
                          FStar_SMTEncoding_Term.mk_HasTypeZ x1 a in
                        [uu____16556] in
                      [uu____16553] in
                    let uu____16561 =
                      let uu____16562 =
                        let uu____16567 =
                          FStar_SMTEncoding_Term.mk_HasTypeZ x1 a in
                        (uu____16567, valid_b_x) in
                      FStar_SMTEncoding_Util.mkImp uu____16562 in
                    (uu____16548, [xx1], uu____16561) in
                  FStar_SMTEncoding_Util.mkExists uu____16537 in
                (uu____16536, valid) in
              FStar_SMTEncoding_Util.mkIff uu____16531 in
            ([[l_exists_a_b]], [aa; bb], uu____16530) in
          FStar_SMTEncoding_Util.mkForall uu____16519 in
        (uu____16518, (FStar_Pervasives_Native.Some "exists interpretation"),
          "exists-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____16511 in
    [uu____16510] in
  let mk_range_interp env range tt =
    let range_ty = FStar_SMTEncoding_Util.mkApp (range, []) in
    let uu____16627 =
      let uu____16628 =
        let uu____16635 =
          let uu____16636 = FStar_SMTEncoding_Term.mk_Range_const () in
          FStar_SMTEncoding_Term.mk_HasTypeZ uu____16636 range_ty in
        let uu____16637 = varops.mk_unique "typing_range_const" in
        (uu____16635, (FStar_Pervasives_Native.Some "Range_const typing"),
          uu____16637) in
      FStar_SMTEncoding_Util.mkAssume uu____16628 in
    [uu____16627] in
  let mk_inversion_axiom env inversion tt =
    let tt1 = ("t", FStar_SMTEncoding_Term.Term_sort) in
    let t = FStar_SMTEncoding_Util.mkFreeV tt1 in
    let xx1 = ("x", FStar_SMTEncoding_Term.Term_sort) in
    let x1 = FStar_SMTEncoding_Util.mkFreeV xx1 in
    let inversion_t = FStar_SMTEncoding_Util.mkApp (inversion, [t]) in
    let valid = FStar_SMTEncoding_Util.mkApp ("Valid", [inversion_t]) in
    let body =
      let hastypeZ = FStar_SMTEncoding_Term.mk_HasTypeZ x1 t in
      let hastypeS =
        let uu____16671 = FStar_SMTEncoding_Term.n_fuel (Prims.parse_int "1") in
        FStar_SMTEncoding_Term.mk_HasTypeFuel uu____16671 x1 t in
      let uu____16672 =
        let uu____16683 = FStar_SMTEncoding_Util.mkImp (hastypeZ, hastypeS) in
        ([[hastypeZ]], [xx1], uu____16683) in
      FStar_SMTEncoding_Util.mkForall uu____16672 in
    let uu____16706 =
      let uu____16707 =
        let uu____16714 =
          let uu____16715 =
            let uu____16726 = FStar_SMTEncoding_Util.mkImp (valid, body) in
            ([[inversion_t]], [tt1], uu____16726) in
          FStar_SMTEncoding_Util.mkForall uu____16715 in
        (uu____16714,
          (FStar_Pervasives_Native.Some "inversion interpretation"),
          "inversion-interp") in
      FStar_SMTEncoding_Util.mkAssume uu____16707 in
    [uu____16706] in
  let prims1 =
    [(FStar_Parser_Const.unit_lid, mk_unit);
    (FStar_Parser_Const.bool_lid, mk_bool);
    (FStar_Parser_Const.int_lid, mk_int);
    (FStar_Parser_Const.string_lid, mk_str);
    (FStar_Parser_Const.true_lid, mk_true_interp);
    (FStar_Parser_Const.false_lid, mk_false_interp);
    (FStar_Parser_Const.and_lid, mk_and_interp);
    (FStar_Parser_Const.or_lid, mk_or_interp);
    (FStar_Parser_Const.eq2_lid, mk_eq2_interp);
    (FStar_Parser_Const.eq3_lid, mk_eq3_interp);
    (FStar_Parser_Const.imp_lid, mk_imp_interp);
    (FStar_Parser_Const.iff_lid, mk_iff_interp);
    (FStar_Parser_Const.not_lid, mk_not_interp);
    (FStar_Parser_Const.forall_lid, mk_forall_interp);
    (FStar_Parser_Const.exists_lid, mk_exists_interp);
    (FStar_Parser_Const.range_lid, mk_range_interp);
    (FStar_Parser_Const.inversion_lid, mk_inversion_axiom)] in
  fun env  ->
    fun t  ->
      fun s  ->
        fun tt  ->
          let uu____17050 =
            FStar_Util.find_opt
              (fun uu____17076  ->
                 match uu____17076 with
                 | (l,uu____17088) -> FStar_Ident.lid_equals l t) prims1 in
          match uu____17050 with
          | FStar_Pervasives_Native.None  -> []
          | FStar_Pervasives_Native.Some (uu____17113,f) -> f env s tt
let encode_smt_lemma:
  env_t ->
    FStar_Syntax_Syntax.fv ->
      FStar_Syntax_Syntax.typ -> FStar_SMTEncoding_Term.decl Prims.list
  =
  fun env  ->
    fun fv  ->
      fun t  ->
        let lid = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
        let uu____17149 = encode_function_type_as_formula t env in
        match uu____17149 with
        | (form,decls) ->
            FStar_List.append decls
              [FStar_SMTEncoding_Util.mkAssume
                 (form,
                   (FStar_Pervasives_Native.Some
                      (Prims.strcat "Lemma: " lid.FStar_Ident.str)),
                   (Prims.strcat "lemma_" lid.FStar_Ident.str))]
let encode_free_var:
  Prims.bool ->
    env_t ->
      FStar_Syntax_Syntax.fv ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.term ->
            FStar_Syntax_Syntax.qualifier Prims.list ->
              (FStar_SMTEncoding_Term.decl Prims.list,env_t)
                FStar_Pervasives_Native.tuple2
  =
  fun uninterpreted  ->
    fun env  ->
      fun fv  ->
        fun tt  ->
          fun t_norm  ->
            fun quals  ->
              let lid =
                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
              let uu____17189 =
                ((let uu____17192 =
                    (FStar_Syntax_Util.is_pure_or_ghost_function t_norm) ||
                      (FStar_TypeChecker_Env.is_reifiable_function env.tcenv
                         t_norm) in
                  FStar_All.pipe_left Prims.op_Negation uu____17192) ||
                   (FStar_Syntax_Util.is_lemma t_norm))
                  || uninterpreted in
              if uu____17189
              then
                let uu____17199 = new_term_constant_and_tok_from_lid env lid in
                match uu____17199 with
                | (vname,vtok,env1) ->
                    let arg_sorts =
                      let uu____17218 =
                        let uu____17219 = FStar_Syntax_Subst.compress t_norm in
                        uu____17219.FStar_Syntax_Syntax.n in
                      match uu____17218 with
                      | FStar_Syntax_Syntax.Tm_arrow (binders,uu____17225) ->
                          FStar_All.pipe_right binders
                            (FStar_List.map
                               (fun uu____17255  ->
                                  FStar_SMTEncoding_Term.Term_sort))
                      | uu____17260 -> [] in
                    let d =
                      FStar_SMTEncoding_Term.DeclFun
                        (vname, arg_sorts, FStar_SMTEncoding_Term.Term_sort,
                          (FStar_Pervasives_Native.Some
                             "Uninterpreted function symbol for impure function")) in
                    let dd =
                      FStar_SMTEncoding_Term.DeclFun
                        (vtok, [], FStar_SMTEncoding_Term.Term_sort,
                          (FStar_Pervasives_Native.Some
                             "Uninterpreted name for impure function")) in
                    ([d; dd], env1)
              else
                (let uu____17274 = prims.is lid in
                 if uu____17274
                 then
                   let vname = varops.new_fvar lid in
                   let uu____17282 = prims.mk lid vname in
                   match uu____17282 with
                   | (tok,definition) ->
                       let env1 =
                         push_free_var env lid vname
                           (FStar_Pervasives_Native.Some tok) in
                       (definition, env1)
                 else
                   (let encode_non_total_function_typ =
                      lid.FStar_Ident.nsstr <> "Prims" in
                    let uu____17306 =
                      let uu____17317 = curried_arrow_formals_comp t_norm in
                      match uu____17317 with
                      | (args,comp) ->
                          let comp1 =
                            let uu____17335 =
                              FStar_TypeChecker_Env.is_reifiable_comp
                                env.tcenv comp in
                            if uu____17335
                            then
                              let uu____17336 =
                                FStar_TypeChecker_Env.reify_comp
                                  (let uu___117_17339 = env.tcenv in
                                   {
                                     FStar_TypeChecker_Env.solver =
                                       (uu___117_17339.FStar_TypeChecker_Env.solver);
                                     FStar_TypeChecker_Env.range =
                                       (uu___117_17339.FStar_TypeChecker_Env.range);
                                     FStar_TypeChecker_Env.curmodule =
                                       (uu___117_17339.FStar_TypeChecker_Env.curmodule);
                                     FStar_TypeChecker_Env.gamma =
                                       (uu___117_17339.FStar_TypeChecker_Env.gamma);
                                     FStar_TypeChecker_Env.gamma_cache =
                                       (uu___117_17339.FStar_TypeChecker_Env.gamma_cache);
                                     FStar_TypeChecker_Env.modules =
                                       (uu___117_17339.FStar_TypeChecker_Env.modules);
                                     FStar_TypeChecker_Env.expected_typ =
                                       (uu___117_17339.FStar_TypeChecker_Env.expected_typ);
                                     FStar_TypeChecker_Env.sigtab =
                                       (uu___117_17339.FStar_TypeChecker_Env.sigtab);
                                     FStar_TypeChecker_Env.is_pattern =
                                       (uu___117_17339.FStar_TypeChecker_Env.is_pattern);
                                     FStar_TypeChecker_Env.instantiate_imp =
                                       (uu___117_17339.FStar_TypeChecker_Env.instantiate_imp);
                                     FStar_TypeChecker_Env.effects =
                                       (uu___117_17339.FStar_TypeChecker_Env.effects);
                                     FStar_TypeChecker_Env.generalize =
                                       (uu___117_17339.FStar_TypeChecker_Env.generalize);
                                     FStar_TypeChecker_Env.letrecs =
                                       (uu___117_17339.FStar_TypeChecker_Env.letrecs);
                                     FStar_TypeChecker_Env.top_level =
                                       (uu___117_17339.FStar_TypeChecker_Env.top_level);
                                     FStar_TypeChecker_Env.check_uvars =
                                       (uu___117_17339.FStar_TypeChecker_Env.check_uvars);
                                     FStar_TypeChecker_Env.use_eq =
                                       (uu___117_17339.FStar_TypeChecker_Env.use_eq);
                                     FStar_TypeChecker_Env.is_iface =
                                       (uu___117_17339.FStar_TypeChecker_Env.is_iface);
                                     FStar_TypeChecker_Env.admit =
                                       (uu___117_17339.FStar_TypeChecker_Env.admit);
                                     FStar_TypeChecker_Env.lax = true;
                                     FStar_TypeChecker_Env.lax_universes =
                                       (uu___117_17339.FStar_TypeChecker_Env.lax_universes);
                                     FStar_TypeChecker_Env.failhard =
                                       (uu___117_17339.FStar_TypeChecker_Env.failhard);
                                     FStar_TypeChecker_Env.nosynth =
                                       (uu___117_17339.FStar_TypeChecker_Env.nosynth);
                                     FStar_TypeChecker_Env.tc_term =
                                       (uu___117_17339.FStar_TypeChecker_Env.tc_term);
                                     FStar_TypeChecker_Env.type_of =
                                       (uu___117_17339.FStar_TypeChecker_Env.type_of);
                                     FStar_TypeChecker_Env.universe_of =
                                       (uu___117_17339.FStar_TypeChecker_Env.universe_of);
                                     FStar_TypeChecker_Env.use_bv_sorts =
                                       (uu___117_17339.FStar_TypeChecker_Env.use_bv_sorts);
                                     FStar_TypeChecker_Env.qname_and_index =
                                       (uu___117_17339.FStar_TypeChecker_Env.qname_and_index);
                                     FStar_TypeChecker_Env.proof_ns =
                                       (uu___117_17339.FStar_TypeChecker_Env.proof_ns);
                                     FStar_TypeChecker_Env.synth =
                                       (uu___117_17339.FStar_TypeChecker_Env.synth);
                                     FStar_TypeChecker_Env.is_native_tactic =
                                       (uu___117_17339.FStar_TypeChecker_Env.is_native_tactic);
                                     FStar_TypeChecker_Env.identifier_info =
                                       (uu___117_17339.FStar_TypeChecker_Env.identifier_info);
                                     FStar_TypeChecker_Env.tc_hooks =
                                       (uu___117_17339.FStar_TypeChecker_Env.tc_hooks);
                                     FStar_TypeChecker_Env.dsenv =
                                       (uu___117_17339.FStar_TypeChecker_Env.dsenv);
                                     FStar_TypeChecker_Env.dep_graph =
                                       (uu___117_17339.FStar_TypeChecker_Env.dep_graph)
                                   }) comp FStar_Syntax_Syntax.U_unknown in
                              FStar_Syntax_Syntax.mk_Total uu____17336
                            else comp in
                          if encode_non_total_function_typ
                          then
                            let uu____17351 =
                              FStar_TypeChecker_Util.pure_or_ghost_pre_and_post
                                env.tcenv comp1 in
                            (args, uu____17351)
                          else
                            (args,
                              (FStar_Pervasives_Native.None,
                                (FStar_Syntax_Util.comp_result comp1))) in
                    match uu____17306 with
                    | (formals,(pre_opt,res_t)) ->
                        let uu____17396 =
                          new_term_constant_and_tok_from_lid env lid in
                        (match uu____17396 with
                         | (vname,vtok,env1) ->
                             let vtok_tm =
                               match formals with
                               | [] ->
                                   FStar_SMTEncoding_Util.mkFreeV
                                     (vname,
                                       FStar_SMTEncoding_Term.Term_sort)
                               | uu____17417 ->
                                   FStar_SMTEncoding_Util.mkApp (vtok, []) in
                             let mk_disc_proj_axioms guard encoded_res_t vapp
                               vars =
                               FStar_All.pipe_right quals
                                 (FStar_List.collect
                                    (fun uu___89_17459  ->
                                       match uu___89_17459 with
                                       | FStar_Syntax_Syntax.Discriminator d
                                           ->
                                           let uu____17463 =
                                             FStar_Util.prefix vars in
                                           (match uu____17463 with
                                            | (uu____17484,(xxsym,uu____17486))
                                                ->
                                                let xx =
                                                  FStar_SMTEncoding_Util.mkFreeV
                                                    (xxsym,
                                                      FStar_SMTEncoding_Term.Term_sort) in
                                                let uu____17504 =
                                                  let uu____17505 =
                                                    let uu____17512 =
                                                      let uu____17513 =
                                                        let uu____17524 =
                                                          let uu____17525 =
                                                            let uu____17530 =
                                                              let uu____17531
                                                                =
                                                                FStar_SMTEncoding_Term.mk_tester
                                                                  (escape
                                                                    d.FStar_Ident.str)
                                                                  xx in
                                                              FStar_All.pipe_left
                                                                FStar_SMTEncoding_Term.boxBool
                                                                uu____17531 in
                                                            (vapp,
                                                              uu____17530) in
                                                          FStar_SMTEncoding_Util.mkEq
                                                            uu____17525 in
                                                        ([[vapp]], vars,
                                                          uu____17524) in
                                                      FStar_SMTEncoding_Util.mkForall
                                                        uu____17513 in
                                                    (uu____17512,
                                                      (FStar_Pervasives_Native.Some
                                                         "Discriminator equation"),
                                                      (Prims.strcat
                                                         "disc_equation_"
                                                         (escape
                                                            d.FStar_Ident.str))) in
                                                  FStar_SMTEncoding_Util.mkAssume
                                                    uu____17505 in
                                                [uu____17504])
                                       | FStar_Syntax_Syntax.Projector 
                                           (d,f) ->
                                           let uu____17550 =
                                             FStar_Util.prefix vars in
                                           (match uu____17550 with
                                            | (uu____17571,(xxsym,uu____17573))
                                                ->
                                                let xx =
                                                  FStar_SMTEncoding_Util.mkFreeV
                                                    (xxsym,
                                                      FStar_SMTEncoding_Term.Term_sort) in
                                                let f1 =
                                                  {
                                                    FStar_Syntax_Syntax.ppname
                                                      = f;
                                                    FStar_Syntax_Syntax.index
                                                      = (Prims.parse_int "0");
                                                    FStar_Syntax_Syntax.sort
                                                      =
                                                      FStar_Syntax_Syntax.tun
                                                  } in
                                                let tp_name =
                                                  mk_term_projector_name d f1 in
                                                let prim_app =
                                                  FStar_SMTEncoding_Util.mkApp
                                                    (tp_name, [xx]) in
                                                let uu____17596 =
                                                  let uu____17597 =
                                                    let uu____17604 =
                                                      let uu____17605 =
                                                        let uu____17616 =
                                                          FStar_SMTEncoding_Util.mkEq
                                                            (vapp, prim_app) in
                                                        ([[vapp]], vars,
                                                          uu____17616) in
                                                      FStar_SMTEncoding_Util.mkForall
                                                        uu____17605 in
                                                    (uu____17604,
                                                      (FStar_Pervasives_Native.Some
                                                         "Projector equation"),
                                                      (Prims.strcat
                                                         "proj_equation_"
                                                         tp_name)) in
                                                  FStar_SMTEncoding_Util.mkAssume
                                                    uu____17597 in
                                                [uu____17596])
                                       | uu____17633 -> [])) in
                             let uu____17634 =
                               encode_binders FStar_Pervasives_Native.None
                                 formals env1 in
                             (match uu____17634 with
                              | (vars,guards,env',decls1,uu____17661) ->
                                  let uu____17674 =
                                    match pre_opt with
                                    | FStar_Pervasives_Native.None  ->
                                        let uu____17683 =
                                          FStar_SMTEncoding_Util.mk_and_l
                                            guards in
                                        (uu____17683, decls1)
                                    | FStar_Pervasives_Native.Some p ->
                                        let uu____17685 =
                                          encode_formula p env' in
                                        (match uu____17685 with
                                         | (g,ds) ->
                                             let uu____17696 =
                                               FStar_SMTEncoding_Util.mk_and_l
                                                 (g :: guards) in
                                             (uu____17696,
                                               (FStar_List.append decls1 ds))) in
                                  (match uu____17674 with
                                   | (guard,decls11) ->
                                       let vtok_app = mk_Apply vtok_tm vars in
                                       let vapp =
                                         let uu____17709 =
                                           let uu____17716 =
                                             FStar_List.map
                                               FStar_SMTEncoding_Util.mkFreeV
                                               vars in
                                           (vname, uu____17716) in
                                         FStar_SMTEncoding_Util.mkApp
                                           uu____17709 in
                                       let uu____17725 =
                                         let vname_decl =
                                           let uu____17733 =
                                             let uu____17744 =
                                               FStar_All.pipe_right formals
                                                 (FStar_List.map
                                                    (fun uu____17754  ->
                                                       FStar_SMTEncoding_Term.Term_sort)) in
                                             (vname, uu____17744,
                                               FStar_SMTEncoding_Term.Term_sort,
                                               FStar_Pervasives_Native.None) in
                                           FStar_SMTEncoding_Term.DeclFun
                                             uu____17733 in
                                         let uu____17763 =
                                           let env2 =
                                             let uu___118_17769 = env1 in
                                             {
                                               bindings =
                                                 (uu___118_17769.bindings);
                                               depth = (uu___118_17769.depth);
                                               tcenv = (uu___118_17769.tcenv);
                                               warn = (uu___118_17769.warn);
                                               cache = (uu___118_17769.cache);
                                               nolabels =
                                                 (uu___118_17769.nolabels);
                                               use_zfuel_name =
                                                 (uu___118_17769.use_zfuel_name);
                                               encode_non_total_function_typ;
                                               current_module_name =
                                                 (uu___118_17769.current_module_name)
                                             } in
                                           let uu____17770 =
                                             let uu____17771 =
                                               head_normal env2 tt in
                                             Prims.op_Negation uu____17771 in
                                           if uu____17770
                                           then
                                             encode_term_pred
                                               FStar_Pervasives_Native.None
                                               tt env2 vtok_tm
                                           else
                                             encode_term_pred
                                               FStar_Pervasives_Native.None
                                               t_norm env2 vtok_tm in
                                         match uu____17763 with
                                         | (tok_typing,decls2) ->
                                             let tok_typing1 =
                                               match formals with
                                               | uu____17786::uu____17787 ->
                                                   let ff =
                                                     ("ty",
                                                       FStar_SMTEncoding_Term.Term_sort) in
                                                   let f =
                                                     FStar_SMTEncoding_Util.mkFreeV
                                                       ff in
                                                   let vtok_app_l =
                                                     mk_Apply vtok_tm [ff] in
                                                   let vtok_app_r =
                                                     mk_Apply f
                                                       [(vtok,
                                                          FStar_SMTEncoding_Term.Term_sort)] in
                                                   let guarded_tok_typing =
                                                     let uu____17827 =
                                                       let uu____17838 =
                                                         FStar_SMTEncoding_Term.mk_NoHoist
                                                           f tok_typing in
                                                       ([[vtok_app_l];
                                                        [vtok_app_r]], 
                                                         [ff], uu____17838) in
                                                     FStar_SMTEncoding_Util.mkForall
                                                       uu____17827 in
                                                   FStar_SMTEncoding_Util.mkAssume
                                                     (guarded_tok_typing,
                                                       (FStar_Pervasives_Native.Some
                                                          "function token typing"),
                                                       (Prims.strcat
                                                          "function_token_typing_"
                                                          vname))
                                               | uu____17865 ->
                                                   FStar_SMTEncoding_Util.mkAssume
                                                     (tok_typing,
                                                       (FStar_Pervasives_Native.Some
                                                          "function token typing"),
                                                       (Prims.strcat
                                                          "function_token_typing_"
                                                          vname)) in
                                             let uu____17868 =
                                               match formals with
                                               | [] ->
                                                   let uu____17885 =
                                                     let uu____17886 =
                                                       let uu____17889 =
                                                         FStar_SMTEncoding_Util.mkFreeV
                                                           (vname,
                                                             FStar_SMTEncoding_Term.Term_sort) in
                                                       FStar_All.pipe_left
                                                         (fun _0_42  ->
                                                            FStar_Pervasives_Native.Some
                                                              _0_42)
                                                         uu____17889 in
                                                     push_free_var env1 lid
                                                       vname uu____17886 in
                                                   ((FStar_List.append decls2
                                                       [tok_typing1]),
                                                     uu____17885)
                                               | uu____17894 ->
                                                   let vtok_decl =
                                                     FStar_SMTEncoding_Term.DeclFun
                                                       (vtok, [],
                                                         FStar_SMTEncoding_Term.Term_sort,
                                                         FStar_Pervasives_Native.None) in
                                                   let name_tok_corr =
                                                     let uu____17901 =
                                                       let uu____17908 =
                                                         let uu____17909 =
                                                           let uu____17920 =
                                                             FStar_SMTEncoding_Util.mkEq
                                                               (vtok_app,
                                                                 vapp) in
                                                           ([[vtok_app];
                                                            [vapp]], vars,
                                                             uu____17920) in
                                                         FStar_SMTEncoding_Util.mkForall
                                                           uu____17909 in
                                                       (uu____17908,
                                                         (FStar_Pervasives_Native.Some
                                                            "Name-token correspondence"),
                                                         (Prims.strcat
                                                            "token_correspondence_"
                                                            vname)) in
                                                     FStar_SMTEncoding_Util.mkAssume
                                                       uu____17901 in
                                                   ((FStar_List.append decls2
                                                       [vtok_decl;
                                                       name_tok_corr;
                                                       tok_typing1]), env1) in
                                             (match uu____17868 with
                                              | (tok_decl,env2) ->
                                                  ((vname_decl :: tok_decl),
                                                    env2)) in
                                       (match uu____17725 with
                                        | (decls2,env2) ->
                                            let uu____17963 =
                                              let res_t1 =
                                                FStar_Syntax_Subst.compress
                                                  res_t in
                                              let uu____17971 =
                                                encode_term res_t1 env' in
                                              match uu____17971 with
                                              | (encoded_res_t,decls) ->
                                                  let uu____17984 =
                                                    FStar_SMTEncoding_Term.mk_HasType
                                                      vapp encoded_res_t in
                                                  (encoded_res_t,
                                                    uu____17984, decls) in
                                            (match uu____17963 with
                                             | (encoded_res_t,ty_pred,decls3)
                                                 ->
                                                 let typingAx =
                                                   let uu____17995 =
                                                     let uu____18002 =
                                                       let uu____18003 =
                                                         let uu____18014 =
                                                           FStar_SMTEncoding_Util.mkImp
                                                             (guard, ty_pred) in
                                                         ([[vapp]], vars,
                                                           uu____18014) in
                                                       FStar_SMTEncoding_Util.mkForall
                                                         uu____18003 in
                                                     (uu____18002,
                                                       (FStar_Pervasives_Native.Some
                                                          "free var typing"),
                                                       (Prims.strcat
                                                          "typing_" vname)) in
                                                   FStar_SMTEncoding_Util.mkAssume
                                                     uu____17995 in
                                                 let freshness =
                                                   let uu____18030 =
                                                     FStar_All.pipe_right
                                                       quals
                                                       (FStar_List.contains
                                                          FStar_Syntax_Syntax.New) in
                                                   if uu____18030
                                                   then
                                                     let uu____18035 =
                                                       let uu____18036 =
                                                         let uu____18047 =
                                                           FStar_All.pipe_right
                                                             vars
                                                             (FStar_List.map
                                                                FStar_Pervasives_Native.snd) in
                                                         let uu____18058 =
                                                           varops.next_id () in
                                                         (vname, uu____18047,
                                                           FStar_SMTEncoding_Term.Term_sort,
                                                           uu____18058) in
                                                       FStar_SMTEncoding_Term.fresh_constructor
                                                         uu____18036 in
                                                     let uu____18061 =
                                                       let uu____18064 =
                                                         pretype_axiom env2
                                                           vapp vars in
                                                       [uu____18064] in
                                                     uu____18035 ::
                                                       uu____18061
                                                   else [] in
                                                 let g =
                                                   let uu____18069 =
                                                     let uu____18072 =
                                                       let uu____18075 =
                                                         let uu____18078 =
                                                           let uu____18081 =
                                                             mk_disc_proj_axioms
                                                               guard
                                                               encoded_res_t
                                                               vapp vars in
                                                           typingAx ::
                                                             uu____18081 in
                                                         FStar_List.append
                                                           freshness
                                                           uu____18078 in
                                                       FStar_List.append
                                                         decls3 uu____18075 in
                                                     FStar_List.append decls2
                                                       uu____18072 in
                                                   FStar_List.append decls11
                                                     uu____18069 in
                                                 (g, env2))))))))
let declare_top_level_let:
  env_t ->
    FStar_Syntax_Syntax.fv ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          ((Prims.string,FStar_SMTEncoding_Term.term
                           FStar_Pervasives_Native.option)
             FStar_Pervasives_Native.tuple2,FStar_SMTEncoding_Term.decl
                                              Prims.list,env_t)
            FStar_Pervasives_Native.tuple3
  =
  fun env  ->
    fun x  ->
      fun t  ->
        fun t_norm  ->
          let uu____18112 =
            try_lookup_lid env
              (x.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          match uu____18112 with
          | FStar_Pervasives_Native.None  ->
              let uu____18149 = encode_free_var false env x t t_norm [] in
              (match uu____18149 with
               | (decls,env1) ->
                   let uu____18176 =
                     lookup_lid env1
                       (x.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                   (match uu____18176 with
                    | (n1,x',uu____18203) -> ((n1, x'), decls, env1)))
          | FStar_Pervasives_Native.Some (n1,x1,uu____18224) ->
              ((n1, x1), [], env)
let encode_top_level_val:
  Prims.bool ->
    env_t ->
      FStar_Syntax_Syntax.fv ->
        FStar_Syntax_Syntax.term ->
          FStar_Syntax_Syntax.qualifier Prims.list ->
            (FStar_SMTEncoding_Term.decl Prims.list,env_t)
              FStar_Pervasives_Native.tuple2
  =
  fun uninterpreted  ->
    fun env  ->
      fun lid  ->
        fun t  ->
          fun quals  ->
            let tt = norm env t in
            let uu____18279 =
              encode_free_var uninterpreted env lid t tt quals in
            match uu____18279 with
            | (decls,env1) ->
                let uu____18298 = FStar_Syntax_Util.is_smt_lemma t in
                if uu____18298
                then
                  let uu____18305 =
                    let uu____18308 = encode_smt_lemma env1 lid tt in
                    FStar_List.append decls uu____18308 in
                  (uu____18305, env1)
                else (decls, env1)
let encode_top_level_vals:
  env_t ->
    FStar_Syntax_Syntax.letbinding Prims.list ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        (FStar_SMTEncoding_Term.decl Prims.list,env_t)
          FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun bindings  ->
      fun quals  ->
        FStar_All.pipe_right bindings
          (FStar_List.fold_left
             (fun uu____18360  ->
                fun lb  ->
                  match uu____18360 with
                  | (decls,env1) ->
                      let uu____18380 =
                        let uu____18387 =
                          FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
                        encode_top_level_val false env1 uu____18387
                          lb.FStar_Syntax_Syntax.lbtyp quals in
                      (match uu____18380 with
                       | (decls',env2) ->
                           ((FStar_List.append decls decls'), env2)))
             ([], env))
let is_tactic: FStar_Syntax_Syntax.term -> Prims.bool =
  fun t  ->
    let fstar_tactics_tactic_lid =
      FStar_Parser_Const.p2l ["FStar"; "Tactics"; "tactic"] in
    let uu____18408 = FStar_Syntax_Util.head_and_args t in
    match uu____18408 with
    | (hd1,args) ->
        let uu____18445 =
          let uu____18446 = FStar_Syntax_Util.un_uinst hd1 in
          uu____18446.FStar_Syntax_Syntax.n in
        (match uu____18445 with
         | FStar_Syntax_Syntax.Tm_fvar fv when
             FStar_Syntax_Syntax.fv_eq_lid fv fstar_tactics_tactic_lid ->
             true
         | FStar_Syntax_Syntax.Tm_arrow (uu____18450,c) ->
             let effect_name = FStar_Syntax_Util.comp_effect_name c in
             FStar_Util.starts_with "FStar.Tactics"
               effect_name.FStar_Ident.str
         | uu____18469 -> false)
let encode_top_level_let:
  env_t ->
    (Prims.bool,FStar_Syntax_Syntax.letbinding Prims.list)
      FStar_Pervasives_Native.tuple2 ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        (FStar_SMTEncoding_Term.decl Prims.list,env_t)
          FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun uu____18491  ->
      fun quals  ->
        match uu____18491 with
        | (is_rec,bindings) ->
            let eta_expand1 binders formals body t =
              let nbinders = FStar_List.length binders in
              let uu____18567 = FStar_Util.first_N nbinders formals in
              match uu____18567 with
              | (formals1,extra_formals) ->
                  let subst1 =
                    FStar_List.map2
                      (fun uu____18648  ->
                         fun uu____18649  ->
                           match (uu____18648, uu____18649) with
                           | ((formal,uu____18667),(binder,uu____18669)) ->
                               let uu____18678 =
                                 let uu____18685 =
                                   FStar_Syntax_Syntax.bv_to_name binder in
                                 (formal, uu____18685) in
                               FStar_Syntax_Syntax.NT uu____18678) formals1
                      binders in
                  let extra_formals1 =
                    let uu____18693 =
                      FStar_All.pipe_right extra_formals
                        (FStar_List.map
                           (fun uu____18724  ->
                              match uu____18724 with
                              | (x,i) ->
                                  let uu____18735 =
                                    let uu___119_18736 = x in
                                    let uu____18737 =
                                      FStar_Syntax_Subst.subst subst1
                                        x.FStar_Syntax_Syntax.sort in
                                    {
                                      FStar_Syntax_Syntax.ppname =
                                        (uu___119_18736.FStar_Syntax_Syntax.ppname);
                                      FStar_Syntax_Syntax.index =
                                        (uu___119_18736.FStar_Syntax_Syntax.index);
                                      FStar_Syntax_Syntax.sort = uu____18737
                                    } in
                                  (uu____18735, i))) in
                    FStar_All.pipe_right uu____18693
                      FStar_Syntax_Util.name_binders in
                  let body1 =
                    let uu____18755 =
                      let uu____18756 = FStar_Syntax_Subst.compress body in
                      let uu____18757 =
                        let uu____18758 =
                          FStar_Syntax_Util.args_of_binders extra_formals1 in
                        FStar_All.pipe_left FStar_Pervasives_Native.snd
                          uu____18758 in
                      FStar_Syntax_Syntax.extend_app_n uu____18756
                        uu____18757 in
                    uu____18755 FStar_Pervasives_Native.None
                      body.FStar_Syntax_Syntax.pos in
                  ((FStar_List.append binders extra_formals1), body1) in
            let destruct_bound_function flid t_norm e =
              let get_result_type c =
                let uu____18819 =
                  FStar_TypeChecker_Env.is_reifiable_comp env.tcenv c in
                if uu____18819
                then
                  FStar_TypeChecker_Env.reify_comp
                    (let uu___120_18822 = env.tcenv in
                     {
                       FStar_TypeChecker_Env.solver =
                         (uu___120_18822.FStar_TypeChecker_Env.solver);
                       FStar_TypeChecker_Env.range =
                         (uu___120_18822.FStar_TypeChecker_Env.range);
                       FStar_TypeChecker_Env.curmodule =
                         (uu___120_18822.FStar_TypeChecker_Env.curmodule);
                       FStar_TypeChecker_Env.gamma =
                         (uu___120_18822.FStar_TypeChecker_Env.gamma);
                       FStar_TypeChecker_Env.gamma_cache =
                         (uu___120_18822.FStar_TypeChecker_Env.gamma_cache);
                       FStar_TypeChecker_Env.modules =
                         (uu___120_18822.FStar_TypeChecker_Env.modules);
                       FStar_TypeChecker_Env.expected_typ =
                         (uu___120_18822.FStar_TypeChecker_Env.expected_typ);
                       FStar_TypeChecker_Env.sigtab =
                         (uu___120_18822.FStar_TypeChecker_Env.sigtab);
                       FStar_TypeChecker_Env.is_pattern =
                         (uu___120_18822.FStar_TypeChecker_Env.is_pattern);
                       FStar_TypeChecker_Env.instantiate_imp =
                         (uu___120_18822.FStar_TypeChecker_Env.instantiate_imp);
                       FStar_TypeChecker_Env.effects =
                         (uu___120_18822.FStar_TypeChecker_Env.effects);
                       FStar_TypeChecker_Env.generalize =
                         (uu___120_18822.FStar_TypeChecker_Env.generalize);
                       FStar_TypeChecker_Env.letrecs =
                         (uu___120_18822.FStar_TypeChecker_Env.letrecs);
                       FStar_TypeChecker_Env.top_level =
                         (uu___120_18822.FStar_TypeChecker_Env.top_level);
                       FStar_TypeChecker_Env.check_uvars =
                         (uu___120_18822.FStar_TypeChecker_Env.check_uvars);
                       FStar_TypeChecker_Env.use_eq =
                         (uu___120_18822.FStar_TypeChecker_Env.use_eq);
                       FStar_TypeChecker_Env.is_iface =
                         (uu___120_18822.FStar_TypeChecker_Env.is_iface);
                       FStar_TypeChecker_Env.admit =
                         (uu___120_18822.FStar_TypeChecker_Env.admit);
                       FStar_TypeChecker_Env.lax = true;
                       FStar_TypeChecker_Env.lax_universes =
                         (uu___120_18822.FStar_TypeChecker_Env.lax_universes);
                       FStar_TypeChecker_Env.failhard =
                         (uu___120_18822.FStar_TypeChecker_Env.failhard);
                       FStar_TypeChecker_Env.nosynth =
                         (uu___120_18822.FStar_TypeChecker_Env.nosynth);
                       FStar_TypeChecker_Env.tc_term =
                         (uu___120_18822.FStar_TypeChecker_Env.tc_term);
                       FStar_TypeChecker_Env.type_of =
                         (uu___120_18822.FStar_TypeChecker_Env.type_of);
                       FStar_TypeChecker_Env.universe_of =
                         (uu___120_18822.FStar_TypeChecker_Env.universe_of);
                       FStar_TypeChecker_Env.use_bv_sorts =
                         (uu___120_18822.FStar_TypeChecker_Env.use_bv_sorts);
                       FStar_TypeChecker_Env.qname_and_index =
                         (uu___120_18822.FStar_TypeChecker_Env.qname_and_index);
                       FStar_TypeChecker_Env.proof_ns =
                         (uu___120_18822.FStar_TypeChecker_Env.proof_ns);
                       FStar_TypeChecker_Env.synth =
                         (uu___120_18822.FStar_TypeChecker_Env.synth);
                       FStar_TypeChecker_Env.is_native_tactic =
                         (uu___120_18822.FStar_TypeChecker_Env.is_native_tactic);
                       FStar_TypeChecker_Env.identifier_info =
                         (uu___120_18822.FStar_TypeChecker_Env.identifier_info);
                       FStar_TypeChecker_Env.tc_hooks =
                         (uu___120_18822.FStar_TypeChecker_Env.tc_hooks);
                       FStar_TypeChecker_Env.dsenv =
                         (uu___120_18822.FStar_TypeChecker_Env.dsenv);
                       FStar_TypeChecker_Env.dep_graph =
                         (uu___120_18822.FStar_TypeChecker_Env.dep_graph)
                     }) c FStar_Syntax_Syntax.U_unknown
                else FStar_Syntax_Util.comp_result c in
              let rec aux norm1 t_norm1 =
                let uu____18855 = FStar_Syntax_Util.abs_formals e in
                match uu____18855 with
                | (binders,body,lopt) ->
                    (match binders with
                     | uu____18919::uu____18920 ->
                         let uu____18935 =
                           let uu____18936 =
                             let uu____18939 =
                               FStar_Syntax_Subst.compress t_norm1 in
                             FStar_All.pipe_left FStar_Syntax_Util.unascribe
                               uu____18939 in
                           uu____18936.FStar_Syntax_Syntax.n in
                         (match uu____18935 with
                          | FStar_Syntax_Syntax.Tm_arrow (formals,c) ->
                              let uu____18982 =
                                FStar_Syntax_Subst.open_comp formals c in
                              (match uu____18982 with
                               | (formals1,c1) ->
                                   let nformals = FStar_List.length formals1 in
                                   let nbinders = FStar_List.length binders in
                                   let tres = get_result_type c1 in
                                   let uu____19024 =
                                     (nformals < nbinders) &&
                                       (FStar_Syntax_Util.is_total_comp c1) in
                                   if uu____19024
                                   then
                                     let uu____19059 =
                                       FStar_Util.first_N nformals binders in
                                     (match uu____19059 with
                                      | (bs0,rest) ->
                                          let c2 =
                                            let subst1 =
                                              FStar_List.map2
                                                (fun uu____19153  ->
                                                   fun uu____19154  ->
                                                     match (uu____19153,
                                                             uu____19154)
                                                     with
                                                     | ((x,uu____19172),
                                                        (b,uu____19174)) ->
                                                         let uu____19183 =
                                                           let uu____19190 =
                                                             FStar_Syntax_Syntax.bv_to_name
                                                               b in
                                                           (x, uu____19190) in
                                                         FStar_Syntax_Syntax.NT
                                                           uu____19183)
                                                formals1 bs0 in
                                            FStar_Syntax_Subst.subst_comp
                                              subst1 c1 in
                                          let body1 =
                                            FStar_Syntax_Util.abs rest body
                                              lopt in
                                          let uu____19192 =
                                            let uu____19213 =
                                              get_result_type c2 in
                                            (bs0, body1, bs0, uu____19213) in
                                          (uu____19192, false))
                                   else
                                     if nformals > nbinders
                                     then
                                       (let uu____19281 =
                                          eta_expand1 binders formals1 body
                                            tres in
                                        match uu____19281 with
                                        | (binders1,body1) ->
                                            ((binders1, body1, formals1,
                                               tres), false))
                                     else
                                       ((binders, body, formals1, tres),
                                         false))
                          | FStar_Syntax_Syntax.Tm_refine (x,uu____19370) ->
                              let uu____19375 =
                                let uu____19396 =
                                  aux norm1 x.FStar_Syntax_Syntax.sort in
                                FStar_Pervasives_Native.fst uu____19396 in
                              (uu____19375, true)
                          | uu____19461 when Prims.op_Negation norm1 ->
                              let t_norm2 =
                                FStar_TypeChecker_Normalize.normalize
                                  [FStar_TypeChecker_Normalize.AllowUnboundUniverses;
                                  FStar_TypeChecker_Normalize.Beta;
                                  FStar_TypeChecker_Normalize.Weak;
                                  FStar_TypeChecker_Normalize.HNF;
                                  FStar_TypeChecker_Normalize.Exclude
                                    FStar_TypeChecker_Normalize.Zeta;
                                  FStar_TypeChecker_Normalize.UnfoldUntil
                                    FStar_Syntax_Syntax.Delta_constant;
                                  FStar_TypeChecker_Normalize.EraseUniverses]
                                  env.tcenv t_norm1 in
                              aux true t_norm2
                          | uu____19463 ->
                              let uu____19464 =
                                let uu____19465 =
                                  FStar_Syntax_Print.term_to_string e in
                                let uu____19466 =
                                  FStar_Syntax_Print.term_to_string t_norm1 in
                                FStar_Util.format3
                                  "Impossible! let-bound lambda %s = %s has a type that's not a function: %s\n"
                                  flid.FStar_Ident.str uu____19465
                                  uu____19466 in
                              failwith uu____19464)
                     | uu____19491 ->
                         let rec aux' t_norm2 =
                           let uu____19516 =
                             let uu____19517 =
                               FStar_Syntax_Subst.compress t_norm2 in
                             uu____19517.FStar_Syntax_Syntax.n in
                           match uu____19516 with
                           | FStar_Syntax_Syntax.Tm_arrow (formals,c) ->
                               let uu____19558 =
                                 FStar_Syntax_Subst.open_comp formals c in
                               (match uu____19558 with
                                | (formals1,c1) ->
                                    let tres = get_result_type c1 in
                                    let uu____19586 =
                                      eta_expand1 [] formals1 e tres in
                                    (match uu____19586 with
                                     | (binders1,body1) ->
                                         ((binders1, body1, formals1, tres),
                                           false)))
                           | FStar_Syntax_Syntax.Tm_refine (bv,uu____19666)
                               -> aux' bv.FStar_Syntax_Syntax.sort
                           | uu____19671 -> (([], e, [], t_norm2), false) in
                         aux' t_norm1) in
              aux false t_norm in
            (try
               let uu____19727 =
                 FStar_All.pipe_right bindings
                   (FStar_Util.for_all
                      (fun lb  ->
                         (FStar_Syntax_Util.is_lemma
                            lb.FStar_Syntax_Syntax.lbtyp)
                           || (is_tactic lb.FStar_Syntax_Syntax.lbtyp))) in
               if uu____19727
               then encode_top_level_vals env bindings quals
               else
                 (let uu____19739 =
                    FStar_All.pipe_right bindings
                      (FStar_List.fold_left
                         (fun uu____19833  ->
                            fun lb  ->
                              match uu____19833 with
                              | (toks,typs,decls,env1) ->
                                  ((let uu____19928 =
                                      FStar_Syntax_Util.is_lemma
                                        lb.FStar_Syntax_Syntax.lbtyp in
                                    if uu____19928
                                    then FStar_Exn.raise Let_rec_unencodeable
                                    else ());
                                   (let t_norm =
                                      whnf env1 lb.FStar_Syntax_Syntax.lbtyp in
                                    let uu____19931 =
                                      let uu____19946 =
                                        FStar_Util.right
                                          lb.FStar_Syntax_Syntax.lbname in
                                      declare_top_level_let env1 uu____19946
                                        lb.FStar_Syntax_Syntax.lbtyp t_norm in
                                    match uu____19931 with
                                    | (tok,decl,env2) ->
                                        let uu____19992 =
                                          let uu____20005 =
                                            let uu____20016 =
                                              FStar_Util.right
                                                lb.FStar_Syntax_Syntax.lbname in
                                            (uu____20016, tok) in
                                          uu____20005 :: toks in
                                        (uu____19992, (t_norm :: typs), (decl
                                          :: decls), env2))))
                         ([], [], [], env)) in
                  match uu____19739 with
                  | (toks,typs,decls,env1) ->
                      let toks1 = FStar_List.rev toks in
                      let decls1 =
                        FStar_All.pipe_right (FStar_List.rev decls)
                          FStar_List.flatten in
                      let typs1 = FStar_List.rev typs in
                      let mk_app1 curry f ftok vars =
                        match vars with
                        | [] ->
                            FStar_SMTEncoding_Util.mkFreeV
                              (f, FStar_SMTEncoding_Term.Term_sort)
                        | uu____20199 ->
                            if curry
                            then
                              (match ftok with
                               | FStar_Pervasives_Native.Some ftok1 ->
                                   mk_Apply ftok1 vars
                               | FStar_Pervasives_Native.None  ->
                                   let uu____20207 =
                                     FStar_SMTEncoding_Util.mkFreeV
                                       (f, FStar_SMTEncoding_Term.Term_sort) in
                                   mk_Apply uu____20207 vars)
                            else
                              (let uu____20209 =
                                 let uu____20216 =
                                   FStar_List.map
                                     FStar_SMTEncoding_Util.mkFreeV vars in
                                 (f, uu____20216) in
                               FStar_SMTEncoding_Util.mkApp uu____20209) in
                      let encode_non_rec_lbdef bindings1 typs2 toks2 env2 =
                        match (bindings1, typs2, toks2) with
                        | ({ FStar_Syntax_Syntax.lbname = uu____20298;
                             FStar_Syntax_Syntax.lbunivs = uvs;
                             FStar_Syntax_Syntax.lbtyp = uu____20300;
                             FStar_Syntax_Syntax.lbeff = uu____20301;
                             FStar_Syntax_Syntax.lbdef = e;_}::[],t_norm::[],
                           (flid_fv,(f,ftok))::[]) ->
                            let flid =
                              (flid_fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                            let uu____20364 =
                              let uu____20371 =
                                FStar_TypeChecker_Env.open_universes_in
                                  env2.tcenv uvs [e; t_norm] in
                              match uu____20371 with
                              | (tcenv',uu____20389,e_t) ->
                                  let uu____20395 =
                                    match e_t with
                                    | e1::t_norm1::[] -> (e1, t_norm1)
                                    | uu____20406 -> failwith "Impossible" in
                                  (match uu____20395 with
                                   | (e1,t_norm1) ->
                                       ((let uu___123_20422 = env2 in
                                         {
                                           bindings =
                                             (uu___123_20422.bindings);
                                           depth = (uu___123_20422.depth);
                                           tcenv = tcenv';
                                           warn = (uu___123_20422.warn);
                                           cache = (uu___123_20422.cache);
                                           nolabels =
                                             (uu___123_20422.nolabels);
                                           use_zfuel_name =
                                             (uu___123_20422.use_zfuel_name);
                                           encode_non_total_function_typ =
                                             (uu___123_20422.encode_non_total_function_typ);
                                           current_module_name =
                                             (uu___123_20422.current_module_name)
                                         }), e1, t_norm1)) in
                            (match uu____20364 with
                             | (env',e1,t_norm1) ->
                                 let uu____20432 =
                                   destruct_bound_function flid t_norm1 e1 in
                                 (match uu____20432 with
                                  | ((binders,body,uu____20453,uu____20454),curry)
                                      ->
                                      ((let uu____20465 =
                                          FStar_All.pipe_left
                                            (FStar_TypeChecker_Env.debug
                                               env2.tcenv)
                                            (FStar_Options.Other
                                               "SMTEncoding") in
                                        if uu____20465
                                        then
                                          let uu____20466 =
                                            FStar_Syntax_Print.binders_to_string
                                              ", " binders in
                                          let uu____20467 =
                                            FStar_Syntax_Print.term_to_string
                                              body in
                                          FStar_Util.print2
                                            "Encoding let : binders=[%s], body=%s\n"
                                            uu____20466 uu____20467
                                        else ());
                                       (let uu____20469 =
                                          encode_binders
                                            FStar_Pervasives_Native.None
                                            binders env' in
                                        match uu____20469 with
                                        | (vars,guards,env'1,binder_decls,uu____20496)
                                            ->
                                            let body1 =
                                              let uu____20510 =
                                                FStar_TypeChecker_Env.is_reifiable_function
                                                  env'1.tcenv t_norm1 in
                                              if uu____20510
                                              then
                                                FStar_TypeChecker_Util.reify_body
                                                  env'1.tcenv body
                                              else body in
                                            let app =
                                              mk_app1 curry f ftok vars in
                                            let uu____20513 =
                                              let uu____20522 =
                                                FStar_All.pipe_right quals
                                                  (FStar_List.contains
                                                     FStar_Syntax_Syntax.Logic) in
                                              if uu____20522
                                              then
                                                let uu____20533 =
                                                  FStar_SMTEncoding_Term.mk_Valid
                                                    app in
                                                let uu____20534 =
                                                  encode_formula body1 env'1 in
                                                (uu____20533, uu____20534)
                                              else
                                                (let uu____20544 =
                                                   encode_term body1 env'1 in
                                                 (app, uu____20544)) in
                                            (match uu____20513 with
                                             | (app1,(body2,decls2)) ->
                                                 let eqn =
                                                   let uu____20567 =
                                                     let uu____20574 =
                                                       let uu____20575 =
                                                         let uu____20586 =
                                                           FStar_SMTEncoding_Util.mkEq
                                                             (app1, body2) in
                                                         ([[app1]], vars,
                                                           uu____20586) in
                                                       FStar_SMTEncoding_Util.mkForall
                                                         uu____20575 in
                                                     let uu____20597 =
                                                       let uu____20600 =
                                                         FStar_Util.format1
                                                           "Equation for %s"
                                                           flid.FStar_Ident.str in
                                                       FStar_Pervasives_Native.Some
                                                         uu____20600 in
                                                     (uu____20574,
                                                       uu____20597,
                                                       (Prims.strcat
                                                          "equation_" f)) in
                                                   FStar_SMTEncoding_Util.mkAssume
                                                     uu____20567 in
                                                 let uu____20603 =
                                                   let uu____20606 =
                                                     let uu____20609 =
                                                       let uu____20612 =
                                                         let uu____20615 =
                                                           primitive_type_axioms
                                                             env2.tcenv flid
                                                             f app1 in
                                                         FStar_List.append
                                                           [eqn] uu____20615 in
                                                       FStar_List.append
                                                         decls2 uu____20612 in
                                                     FStar_List.append
                                                       binder_decls
                                                       uu____20609 in
                                                   FStar_List.append decls1
                                                     uu____20606 in
                                                 (uu____20603, env2))))))
                        | uu____20620 -> failwith "Impossible" in
                      let encode_rec_lbdefs bindings1 typs2 toks2 env2 =
                        let fuel =
                          let uu____20705 = varops.fresh "fuel" in
                          (uu____20705, FStar_SMTEncoding_Term.Fuel_sort) in
                        let fuel_tm = FStar_SMTEncoding_Util.mkFreeV fuel in
                        let env0 = env2 in
                        let uu____20708 =
                          FStar_All.pipe_right toks2
                            (FStar_List.fold_left
                               (fun uu____20796  ->
                                  fun uu____20797  ->
                                    match (uu____20796, uu____20797) with
                                    | ((gtoks,env3),(flid_fv,(f,ftok))) ->
                                        let flid =
                                          (flid_fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
                                        let g =
                                          let uu____20945 =
                                            FStar_Ident.lid_add_suffix flid
                                              "fuel_instrumented" in
                                          varops.new_fvar uu____20945 in
                                        let gtok =
                                          let uu____20947 =
                                            FStar_Ident.lid_add_suffix flid
                                              "fuel_instrumented_token" in
                                          varops.new_fvar uu____20947 in
                                        let env4 =
                                          let uu____20949 =
                                            let uu____20952 =
                                              FStar_SMTEncoding_Util.mkApp
                                                (g, [fuel_tm]) in
                                            FStar_All.pipe_left
                                              (fun _0_43  ->
                                                 FStar_Pervasives_Native.Some
                                                   _0_43) uu____20952 in
                                          push_free_var env3 flid gtok
                                            uu____20949 in
                                        (((flid, f, ftok, g, gtok) :: gtoks),
                                          env4)) ([], env2)) in
                        match uu____20708 with
                        | (gtoks,env3) ->
                            let gtoks1 = FStar_List.rev gtoks in
                            let encode_one_binding env01 uu____21108 t_norm
                              uu____21110 =
                              match (uu____21108, uu____21110) with
                              | ((flid,f,ftok,g,gtok),{
                                                        FStar_Syntax_Syntax.lbname
                                                          = lbn;
                                                        FStar_Syntax_Syntax.lbunivs
                                                          = uvs;
                                                        FStar_Syntax_Syntax.lbtyp
                                                          = uu____21154;
                                                        FStar_Syntax_Syntax.lbeff
                                                          = uu____21155;
                                                        FStar_Syntax_Syntax.lbdef
                                                          = e;_})
                                  ->
                                  let uu____21183 =
                                    let uu____21190 =
                                      FStar_TypeChecker_Env.open_universes_in
                                        env3.tcenv uvs [e; t_norm] in
                                    match uu____21190 with
                                    | (tcenv',uu____21212,e_t) ->
                                        let uu____21218 =
                                          match e_t with
                                          | e1::t_norm1::[] -> (e1, t_norm1)
                                          | uu____21229 ->
                                              failwith "Impossible" in
                                        (match uu____21218 with
                                         | (e1,t_norm1) ->
                                             ((let uu___124_21245 = env3 in
                                               {
                                                 bindings =
                                                   (uu___124_21245.bindings);
                                                 depth =
                                                   (uu___124_21245.depth);
                                                 tcenv = tcenv';
                                                 warn = (uu___124_21245.warn);
                                                 cache =
                                                   (uu___124_21245.cache);
                                                 nolabels =
                                                   (uu___124_21245.nolabels);
                                                 use_zfuel_name =
                                                   (uu___124_21245.use_zfuel_name);
                                                 encode_non_total_function_typ
                                                   =
                                                   (uu___124_21245.encode_non_total_function_typ);
                                                 current_module_name =
                                                   (uu___124_21245.current_module_name)
                                               }), e1, t_norm1)) in
                                  (match uu____21183 with
                                   | (env',e1,t_norm1) ->
                                       ((let uu____21260 =
                                           FStar_All.pipe_left
                                             (FStar_TypeChecker_Env.debug
                                                env01.tcenv)
                                             (FStar_Options.Other
                                                "SMTEncoding") in
                                         if uu____21260
                                         then
                                           let uu____21261 =
                                             FStar_Syntax_Print.lbname_to_string
                                               lbn in
                                           let uu____21262 =
                                             FStar_Syntax_Print.term_to_string
                                               t_norm1 in
                                           let uu____21263 =
                                             FStar_Syntax_Print.term_to_string
                                               e1 in
                                           FStar_Util.print3
                                             "Encoding let rec %s : %s = %s\n"
                                             uu____21261 uu____21262
                                             uu____21263
                                         else ());
                                        (let uu____21265 =
                                           destruct_bound_function flid
                                             t_norm1 e1 in
                                         match uu____21265 with
                                         | ((binders,body,formals,tres),curry)
                                             ->
                                             ((let uu____21302 =
                                                 FStar_All.pipe_left
                                                   (FStar_TypeChecker_Env.debug
                                                      env01.tcenv)
                                                   (FStar_Options.Other
                                                      "SMTEncoding") in
                                               if uu____21302
                                               then
                                                 let uu____21303 =
                                                   FStar_Syntax_Print.binders_to_string
                                                     ", " binders in
                                                 let uu____21304 =
                                                   FStar_Syntax_Print.term_to_string
                                                     body in
                                                 let uu____21305 =
                                                   FStar_Syntax_Print.binders_to_string
                                                     ", " formals in
                                                 let uu____21306 =
                                                   FStar_Syntax_Print.term_to_string
                                                     tres in
                                                 FStar_Util.print4
                                                   "Encoding let rec: binders=[%s], body=%s, formals=[%s], tres=%s\n"
                                                   uu____21303 uu____21304
                                                   uu____21305 uu____21306
                                               else ());
                                              if curry
                                              then
                                                failwith
                                                  "Unexpected type of let rec in SMT Encoding; expected it to be annotated with an arrow type"
                                              else ();
                                              (let uu____21310 =
                                                 encode_binders
                                                   FStar_Pervasives_Native.None
                                                   binders env' in
                                               match uu____21310 with
                                               | (vars,guards,env'1,binder_decls,uu____21341)
                                                   ->
                                                   let decl_g =
                                                     let uu____21355 =
                                                       let uu____21366 =
                                                         let uu____21369 =
                                                           FStar_List.map
                                                             FStar_Pervasives_Native.snd
                                                             vars in
                                                         FStar_SMTEncoding_Term.Fuel_sort
                                                           :: uu____21369 in
                                                       (g, uu____21366,
                                                         FStar_SMTEncoding_Term.Term_sort,
                                                         (FStar_Pervasives_Native.Some
                                                            "Fuel-instrumented function name")) in
                                                     FStar_SMTEncoding_Term.DeclFun
                                                       uu____21355 in
                                                   let env02 =
                                                     push_zfuel_name env01
                                                       flid g in
                                                   let decl_g_tok =
                                                     FStar_SMTEncoding_Term.DeclFun
                                                       (gtok, [],
                                                         FStar_SMTEncoding_Term.Term_sort,
                                                         (FStar_Pervasives_Native.Some
                                                            "Token for fuel-instrumented partial applications")) in
                                                   let vars_tm =
                                                     FStar_List.map
                                                       FStar_SMTEncoding_Util.mkFreeV
                                                       vars in
                                                   let app =
                                                     let uu____21394 =
                                                       let uu____21401 =
                                                         FStar_List.map
                                                           FStar_SMTEncoding_Util.mkFreeV
                                                           vars in
                                                       (f, uu____21401) in
                                                     FStar_SMTEncoding_Util.mkApp
                                                       uu____21394 in
                                                   let gsapp =
                                                     let uu____21411 =
                                                       let uu____21418 =
                                                         let uu____21421 =
                                                           FStar_SMTEncoding_Util.mkApp
                                                             ("SFuel",
                                                               [fuel_tm]) in
                                                         uu____21421 ::
                                                           vars_tm in
                                                       (g, uu____21418) in
                                                     FStar_SMTEncoding_Util.mkApp
                                                       uu____21411 in
                                                   let gmax =
                                                     let uu____21427 =
                                                       let uu____21434 =
                                                         let uu____21437 =
                                                           FStar_SMTEncoding_Util.mkApp
                                                             ("MaxFuel", []) in
                                                         uu____21437 ::
                                                           vars_tm in
                                                       (g, uu____21434) in
                                                     FStar_SMTEncoding_Util.mkApp
                                                       uu____21427 in
                                                   let body1 =
                                                     let uu____21443 =
                                                       FStar_TypeChecker_Env.is_reifiable_function
                                                         env'1.tcenv t_norm1 in
                                                     if uu____21443
                                                     then
                                                       FStar_TypeChecker_Util.reify_body
                                                         env'1.tcenv body
                                                     else body in
                                                   let uu____21445 =
                                                     encode_term body1 env'1 in
                                                   (match uu____21445 with
                                                    | (body_tm,decls2) ->
                                                        let eqn_g =
                                                          let uu____21463 =
                                                            let uu____21470 =
                                                              let uu____21471
                                                                =
                                                                let uu____21486
                                                                  =
                                                                  FStar_SMTEncoding_Util.mkEq
                                                                    (gsapp,
                                                                    body_tm) in
                                                                ([[gsapp]],
                                                                  (FStar_Pervasives_Native.Some
                                                                    (Prims.parse_int
                                                                    "0")),
                                                                  (fuel ::
                                                                  vars),
                                                                  uu____21486) in
                                                              FStar_SMTEncoding_Util.mkForall'
                                                                uu____21471 in
                                                            let uu____21507 =
                                                              let uu____21510
                                                                =
                                                                FStar_Util.format1
                                                                  "Equation for fuel-instrumented recursive function: %s"
                                                                  flid.FStar_Ident.str in
                                                              FStar_Pervasives_Native.Some
                                                                uu____21510 in
                                                            (uu____21470,
                                                              uu____21507,
                                                              (Prims.strcat
                                                                 "equation_with_fuel_"
                                                                 g)) in
                                                          FStar_SMTEncoding_Util.mkAssume
                                                            uu____21463 in
                                                        let eqn_f =
                                                          let uu____21514 =
                                                            let uu____21521 =
                                                              let uu____21522
                                                                =
                                                                let uu____21533
                                                                  =
                                                                  FStar_SMTEncoding_Util.mkEq
                                                                    (app,
                                                                    gmax) in
                                                                ([[app]],
                                                                  vars,
                                                                  uu____21533) in
                                                              FStar_SMTEncoding_Util.mkForall
                                                                uu____21522 in
                                                            (uu____21521,
                                                              (FStar_Pervasives_Native.Some
                                                                 "Correspondence of recursive function to instrumented version"),
                                                              (Prims.strcat
                                                                 "@fuel_correspondence_"
                                                                 g)) in
                                                          FStar_SMTEncoding_Util.mkAssume
                                                            uu____21514 in
                                                        let eqn_g' =
                                                          let uu____21547 =
                                                            let uu____21554 =
                                                              let uu____21555
                                                                =
                                                                let uu____21566
                                                                  =
                                                                  let uu____21567
                                                                    =
                                                                    let uu____21572
                                                                    =
                                                                    let uu____21573
                                                                    =
                                                                    let uu____21580
                                                                    =
                                                                    let uu____21583
                                                                    =
                                                                    FStar_SMTEncoding_Term.n_fuel
                                                                    (Prims.parse_int
                                                                    "0") in
                                                                    uu____21583
                                                                    ::
                                                                    vars_tm in
                                                                    (g,
                                                                    uu____21580) in
                                                                    FStar_SMTEncoding_Util.mkApp
                                                                    uu____21573 in
                                                                    (gsapp,
                                                                    uu____21572) in
                                                                  FStar_SMTEncoding_Util.mkEq
                                                                    uu____21567 in
                                                                ([[gsapp]],
                                                                  (fuel ::
                                                                  vars),
                                                                  uu____21566) in
                                                              FStar_SMTEncoding_Util.mkForall
                                                                uu____21555 in
                                                            (uu____21554,
                                                              (FStar_Pervasives_Native.Some
                                                                 "Fuel irrelevance"),
                                                              (Prims.strcat
                                                                 "@fuel_irrelevance_"
                                                                 g)) in
                                                          FStar_SMTEncoding_Util.mkAssume
                                                            uu____21547 in
                                                        let uu____21606 =
                                                          let uu____21615 =
                                                            encode_binders
                                                              FStar_Pervasives_Native.None
                                                              formals env02 in
                                                          match uu____21615
                                                          with
                                                          | (vars1,v_guards,env4,binder_decls1,uu____21644)
                                                              ->
                                                              let vars_tm1 =
                                                                FStar_List.map
                                                                  FStar_SMTEncoding_Util.mkFreeV
                                                                  vars1 in
                                                              let gapp =
                                                                FStar_SMTEncoding_Util.mkApp
                                                                  (g,
                                                                    (fuel_tm
                                                                    ::
                                                                    vars_tm1)) in
                                                              let tok_corr =
                                                                let tok_app =
                                                                  let uu____21669
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    (gtok,
                                                                    FStar_SMTEncoding_Term.Term_sort) in
                                                                  mk_Apply
                                                                    uu____21669
                                                                    (fuel ::
                                                                    vars1) in
                                                                let uu____21674
                                                                  =
                                                                  let uu____21681
                                                                    =
                                                                    let uu____21682
                                                                    =
                                                                    let uu____21693
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkEq
                                                                    (tok_app,
                                                                    gapp) in
                                                                    ([
                                                                    [tok_app]],
                                                                    (fuel ::
                                                                    vars1),
                                                                    uu____21693) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____21682 in
                                                                  (uu____21681,
                                                                    (
                                                                    FStar_Pervasives_Native.Some
                                                                    "Fuel token correspondence"),
                                                                    (
                                                                    Prims.strcat
                                                                    "fuel_token_correspondence_"
                                                                    gtok)) in
                                                                FStar_SMTEncoding_Util.mkAssume
                                                                  uu____21674 in
                                                              let uu____21714
                                                                =
                                                                let uu____21721
                                                                  =
                                                                  encode_term_pred
                                                                    FStar_Pervasives_Native.None
                                                                    tres env4
                                                                    gapp in
                                                                match uu____21721
                                                                with
                                                                | (g_typing,d3)
                                                                    ->
                                                                    let uu____21734
                                                                    =
                                                                    let uu____21737
                                                                    =
                                                                    let uu____21738
                                                                    =
                                                                    let uu____21745
                                                                    =
                                                                    let uu____21746
                                                                    =
                                                                    let uu____21757
                                                                    =
                                                                    let uu____21758
                                                                    =
                                                                    let uu____21763
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_and_l
                                                                    v_guards in
                                                                    (uu____21763,
                                                                    g_typing) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____21758 in
                                                                    ([[gapp]],
                                                                    (fuel ::
                                                                    vars1),
                                                                    uu____21757) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____21746 in
                                                                    (uu____21745,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "Typing correspondence of token to term"),
                                                                    (Prims.strcat
                                                                    "token_correspondence_"
                                                                    g)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____21738 in
                                                                    [uu____21737] in
                                                                    (d3,
                                                                    uu____21734) in
                                                              (match uu____21714
                                                               with
                                                               | (aux_decls,typing_corr)
                                                                   ->
                                                                   ((FStar_List.append
                                                                    binder_decls1
                                                                    aux_decls),
                                                                    (FStar_List.append
                                                                    typing_corr
                                                                    [tok_corr]))) in
                                                        (match uu____21606
                                                         with
                                                         | (aux_decls,g_typing)
                                                             ->
                                                             ((FStar_List.append
                                                                 binder_decls
                                                                 (FStar_List.append
                                                                    decls2
                                                                    (
                                                                    FStar_List.append
                                                                    aux_decls
                                                                    [decl_g;
                                                                    decl_g_tok]))),
                                                               (FStar_List.append
                                                                  [eqn_g;
                                                                  eqn_g';
                                                                  eqn_f]
                                                                  g_typing),
                                                               env02)))))))) in
                            let uu____21828 =
                              let uu____21841 =
                                FStar_List.zip3 gtoks1 typs2 bindings1 in
                              FStar_List.fold_left
                                (fun uu____21920  ->
                                   fun uu____21921  ->
                                     match (uu____21920, uu____21921) with
                                     | ((decls2,eqns,env01),(gtok,ty,lb)) ->
                                         let uu____22076 =
                                           encode_one_binding env01 gtok ty
                                             lb in
                                         (match uu____22076 with
                                          | (decls',eqns',env02) ->
                                              ((decls' :: decls2),
                                                (FStar_List.append eqns' eqns),
                                                env02))) ([decls1], [], env0)
                                uu____21841 in
                            (match uu____21828 with
                             | (decls2,eqns,env01) ->
                                 let uu____22149 =
                                   let isDeclFun uu___90_22161 =
                                     match uu___90_22161 with
                                     | FStar_SMTEncoding_Term.DeclFun
                                         uu____22162 -> true
                                     | uu____22173 -> false in
                                   let uu____22174 =
                                     FStar_All.pipe_right decls2
                                       FStar_List.flatten in
                                   FStar_All.pipe_right uu____22174
                                     (FStar_List.partition isDeclFun) in
                                 (match uu____22149 with
                                  | (prefix_decls,rest) ->
                                      let eqns1 = FStar_List.rev eqns in
                                      ((FStar_List.append prefix_decls
                                          (FStar_List.append rest eqns1)),
                                        env01))) in
                      let uu____22214 =
                        (FStar_All.pipe_right quals
                           (FStar_Util.for_some
                              (fun uu___91_22218  ->
                                 match uu___91_22218 with
                                 | FStar_Syntax_Syntax.HasMaskedEffect  ->
                                     true
                                 | uu____22219 -> false)))
                          ||
                          (FStar_All.pipe_right typs1
                             (FStar_Util.for_some
                                (fun t  ->
                                   let uu____22225 =
                                     (FStar_Syntax_Util.is_pure_or_ghost_function
                                        t)
                                       ||
                                       (FStar_TypeChecker_Env.is_reifiable_function
                                          env1.tcenv t) in
                                   FStar_All.pipe_left Prims.op_Negation
                                     uu____22225))) in
                      if uu____22214
                      then (decls1, env1)
                      else
                        (try
                           if Prims.op_Negation is_rec
                           then
                             encode_non_rec_lbdef bindings typs1 toks1 env1
                           else encode_rec_lbdefs bindings typs1 toks1 env1
                         with | Inner_let_rec  -> (decls1, env1)))
             with
             | Let_rec_unencodeable  ->
                 let msg =
                   let uu____22277 =
                     FStar_All.pipe_right bindings
                       (FStar_List.map
                          (fun lb  ->
                             FStar_Syntax_Print.lbname_to_string
                               lb.FStar_Syntax_Syntax.lbname)) in
                   FStar_All.pipe_right uu____22277
                     (FStar_String.concat " and ") in
                 let decl =
                   FStar_SMTEncoding_Term.Caption
                     (Prims.strcat "let rec unencodeable: Skipping: " msg) in
                 ([decl], env))
let rec encode_sigelt:
  env_t ->
    FStar_Syntax_Syntax.sigelt ->
      (FStar_SMTEncoding_Term.decls_t,env_t) FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun se  ->
      let nm =
        let uu____22326 = FStar_Syntax_Util.lid_of_sigelt se in
        match uu____22326 with
        | FStar_Pervasives_Native.None  -> ""
        | FStar_Pervasives_Native.Some l -> l.FStar_Ident.str in
      let uu____22330 = encode_sigelt' env se in
      match uu____22330 with
      | (g,env1) ->
          let g1 =
            match g with
            | [] ->
                let uu____22346 =
                  let uu____22347 = FStar_Util.format1 "<Skipped %s/>" nm in
                  FStar_SMTEncoding_Term.Caption uu____22347 in
                [uu____22346]
            | uu____22348 ->
                let uu____22349 =
                  let uu____22352 =
                    let uu____22353 =
                      FStar_Util.format1 "<Start encoding %s>" nm in
                    FStar_SMTEncoding_Term.Caption uu____22353 in
                  uu____22352 :: g in
                let uu____22354 =
                  let uu____22357 =
                    let uu____22358 =
                      FStar_Util.format1 "</end encoding %s>" nm in
                    FStar_SMTEncoding_Term.Caption uu____22358 in
                  [uu____22357] in
                FStar_List.append uu____22349 uu____22354 in
          (g1, env1)
and encode_sigelt':
  env_t ->
    FStar_Syntax_Syntax.sigelt ->
      (FStar_SMTEncoding_Term.decls_t,env_t) FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun se  ->
      let is_opaque_to_smt t =
        let uu____22371 =
          let uu____22372 = FStar_Syntax_Subst.compress t in
          uu____22372.FStar_Syntax_Syntax.n in
        match uu____22371 with
        | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_string
            (s,uu____22376)) -> s = "opaque_to_smt"
        | uu____22377 -> false in
      let is_uninterpreted_by_smt t =
        let uu____22382 =
          let uu____22383 = FStar_Syntax_Subst.compress t in
          uu____22383.FStar_Syntax_Syntax.n in
        match uu____22382 with
        | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_string
            (s,uu____22387)) -> s = "uninterpreted_by_smt"
        | uu____22388 -> false in
      match se.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_new_effect_for_free uu____22393 ->
          failwith "impossible -- removed by tc.fs"
      | FStar_Syntax_Syntax.Sig_pragma uu____22398 -> ([], env)
      | FStar_Syntax_Syntax.Sig_main uu____22401 -> ([], env)
      | FStar_Syntax_Syntax.Sig_effect_abbrev uu____22404 -> ([], env)
      | FStar_Syntax_Syntax.Sig_sub_effect uu____22419 -> ([], env)
      | FStar_Syntax_Syntax.Sig_new_effect ed ->
          let uu____22423 =
            let uu____22424 =
              FStar_All.pipe_right se.FStar_Syntax_Syntax.sigquals
                (FStar_List.contains FStar_Syntax_Syntax.Reifiable) in
            FStar_All.pipe_right uu____22424 Prims.op_Negation in
          if uu____22423
          then ([], env)
          else
            (let close_effect_params tm =
               match ed.FStar_Syntax_Syntax.binders with
               | [] -> tm
               | uu____22450 ->
                   FStar_Syntax_Syntax.mk
                     (FStar_Syntax_Syntax.Tm_abs
                        ((ed.FStar_Syntax_Syntax.binders), tm,
                          (FStar_Pervasives_Native.Some
                             (FStar_Syntax_Util.mk_residual_comp
                                FStar_Parser_Const.effect_Tot_lid
                                FStar_Pervasives_Native.None
                                [FStar_Syntax_Syntax.TOTAL]))))
                     FStar_Pervasives_Native.None tm.FStar_Syntax_Syntax.pos in
             let encode_action env1 a =
               let uu____22470 =
                 new_term_constant_and_tok_from_lid env1
                   a.FStar_Syntax_Syntax.action_name in
               match uu____22470 with
               | (aname,atok,env2) ->
                   let uu____22486 =
                     FStar_Syntax_Util.arrow_formals_comp
                       a.FStar_Syntax_Syntax.action_typ in
                   (match uu____22486 with
                    | (formals,uu____22504) ->
                        let uu____22517 =
                          let uu____22522 =
                            close_effect_params
                              a.FStar_Syntax_Syntax.action_defn in
                          encode_term uu____22522 env2 in
                        (match uu____22517 with
                         | (tm,decls) ->
                             let a_decls =
                               let uu____22534 =
                                 let uu____22535 =
                                   let uu____22546 =
                                     FStar_All.pipe_right formals
                                       (FStar_List.map
                                          (fun uu____22562  ->
                                             FStar_SMTEncoding_Term.Term_sort)) in
                                   (aname, uu____22546,
                                     FStar_SMTEncoding_Term.Term_sort,
                                     (FStar_Pervasives_Native.Some "Action")) in
                                 FStar_SMTEncoding_Term.DeclFun uu____22535 in
                               [uu____22534;
                               FStar_SMTEncoding_Term.DeclFun
                                 (atok, [], FStar_SMTEncoding_Term.Term_sort,
                                   (FStar_Pervasives_Native.Some
                                      "Action token"))] in
                             let uu____22575 =
                               let aux uu____22627 uu____22628 =
                                 match (uu____22627, uu____22628) with
                                 | ((bv,uu____22680),(env3,acc_sorts,acc)) ->
                                     let uu____22718 = gen_term_var env3 bv in
                                     (match uu____22718 with
                                      | (xxsym,xx,env4) ->
                                          (env4,
                                            ((xxsym,
                                               FStar_SMTEncoding_Term.Term_sort)
                                            :: acc_sorts), (xx :: acc))) in
                               FStar_List.fold_right aux formals
                                 (env2, [], []) in
                             (match uu____22575 with
                              | (uu____22790,xs_sorts,xs) ->
                                  let app =
                                    FStar_SMTEncoding_Util.mkApp (aname, xs) in
                                  let a_eq =
                                    let uu____22813 =
                                      let uu____22820 =
                                        let uu____22821 =
                                          let uu____22832 =
                                            let uu____22833 =
                                              let uu____22838 =
                                                mk_Apply tm xs_sorts in
                                              (app, uu____22838) in
                                            FStar_SMTEncoding_Util.mkEq
                                              uu____22833 in
                                          ([[app]], xs_sorts, uu____22832) in
                                        FStar_SMTEncoding_Util.mkForall
                                          uu____22821 in
                                      (uu____22820,
                                        (FStar_Pervasives_Native.Some
                                           "Action equality"),
                                        (Prims.strcat aname "_equality")) in
                                    FStar_SMTEncoding_Util.mkAssume
                                      uu____22813 in
                                  let tok_correspondence =
                                    let tok_term =
                                      FStar_SMTEncoding_Util.mkFreeV
                                        (atok,
                                          FStar_SMTEncoding_Term.Term_sort) in
                                    let tok_app = mk_Apply tok_term xs_sorts in
                                    let uu____22858 =
                                      let uu____22865 =
                                        let uu____22866 =
                                          let uu____22877 =
                                            FStar_SMTEncoding_Util.mkEq
                                              (tok_app, app) in
                                          ([[tok_app]], xs_sorts,
                                            uu____22877) in
                                        FStar_SMTEncoding_Util.mkForall
                                          uu____22866 in
                                      (uu____22865,
                                        (FStar_Pervasives_Native.Some
                                           "Action token correspondence"),
                                        (Prims.strcat aname
                                           "_token_correspondence")) in
                                    FStar_SMTEncoding_Util.mkAssume
                                      uu____22858 in
                                  (env2,
                                    (FStar_List.append decls
                                       (FStar_List.append a_decls
                                          [a_eq; tok_correspondence])))))) in
             let uu____22896 =
               FStar_Util.fold_map encode_action env
                 ed.FStar_Syntax_Syntax.actions in
             match uu____22896 with
             | (env1,decls2) -> ((FStar_List.flatten decls2), env1))
      | FStar_Syntax_Syntax.Sig_declare_typ (lid,uu____22924,uu____22925)
          when FStar_Ident.lid_equals lid FStar_Parser_Const.precedes_lid ->
          let uu____22926 = new_term_constant_and_tok_from_lid env lid in
          (match uu____22926 with | (tname,ttok,env1) -> ([], env1))
      | FStar_Syntax_Syntax.Sig_declare_typ (lid,uu____22943,t) ->
          let quals = se.FStar_Syntax_Syntax.sigquals in
          let will_encode_definition =
            let uu____22949 =
              FStar_All.pipe_right quals
                (FStar_Util.for_some
                   (fun uu___92_22953  ->
                      match uu___92_22953 with
                      | FStar_Syntax_Syntax.Assumption  -> true
                      | FStar_Syntax_Syntax.Projector uu____22954 -> true
                      | FStar_Syntax_Syntax.Discriminator uu____22959 -> true
                      | FStar_Syntax_Syntax.Irreducible  -> true
                      | uu____22960 -> false)) in
            Prims.op_Negation uu____22949 in
          if will_encode_definition
          then ([], env)
          else
            (let fv =
               FStar_Syntax_Syntax.lid_as_fv lid
                 FStar_Syntax_Syntax.Delta_constant
                 FStar_Pervasives_Native.None in
             let uu____22969 =
               let uu____22976 =
                 FStar_All.pipe_right se.FStar_Syntax_Syntax.sigattrs
                   (FStar_Util.for_some is_uninterpreted_by_smt) in
               encode_top_level_val uu____22976 env fv t quals in
             match uu____22969 with
             | (decls,env1) ->
                 let tname = lid.FStar_Ident.str in
                 let tsym =
                   FStar_SMTEncoding_Util.mkFreeV
                     (tname, FStar_SMTEncoding_Term.Term_sort) in
                 let uu____22991 =
                   let uu____22994 =
                     primitive_type_axioms env1.tcenv lid tname tsym in
                   FStar_List.append decls uu____22994 in
                 (uu____22991, env1))
      | FStar_Syntax_Syntax.Sig_assume (l,us,f) ->
          let uu____23002 = FStar_Syntax_Subst.open_univ_vars us f in
          (match uu____23002 with
           | (uu____23011,f1) ->
               let uu____23013 = encode_formula f1 env in
               (match uu____23013 with
                | (f2,decls) ->
                    let g =
                      let uu____23027 =
                        let uu____23028 =
                          let uu____23035 =
                            let uu____23038 =
                              let uu____23039 =
                                FStar_Syntax_Print.lid_to_string l in
                              FStar_Util.format1 "Assumption: %s" uu____23039 in
                            FStar_Pervasives_Native.Some uu____23038 in
                          let uu____23040 =
                            varops.mk_unique
                              (Prims.strcat "assumption_" l.FStar_Ident.str) in
                          (f2, uu____23035, uu____23040) in
                        FStar_SMTEncoding_Util.mkAssume uu____23028 in
                      [uu____23027] in
                    ((FStar_List.append decls g), env)))
      | FStar_Syntax_Syntax.Sig_let (lbs,uu____23046) when
          (FStar_All.pipe_right se.FStar_Syntax_Syntax.sigquals
             (FStar_List.contains FStar_Syntax_Syntax.Irreducible))
            ||
            (FStar_All.pipe_right se.FStar_Syntax_Syntax.sigattrs
               (FStar_Util.for_some is_opaque_to_smt))
          ->
          let attrs = se.FStar_Syntax_Syntax.sigattrs in
          let uu____23058 =
            FStar_Util.fold_map
              (fun env1  ->
                 fun lb  ->
                   let lid =
                     let uu____23076 =
                       let uu____23079 =
                         FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
                       uu____23079.FStar_Syntax_Syntax.fv_name in
                     uu____23076.FStar_Syntax_Syntax.v in
                   let uu____23080 =
                     let uu____23081 =
                       FStar_TypeChecker_Env.try_lookup_val_decl env1.tcenv
                         lid in
                     FStar_All.pipe_left FStar_Option.isNone uu____23081 in
                   if uu____23080
                   then
                     let val_decl =
                       let uu___127_23109 = se in
                       {
                         FStar_Syntax_Syntax.sigel =
                           (FStar_Syntax_Syntax.Sig_declare_typ
                              (lid, (lb.FStar_Syntax_Syntax.lbunivs),
                                (lb.FStar_Syntax_Syntax.lbtyp)));
                         FStar_Syntax_Syntax.sigrng =
                           (uu___127_23109.FStar_Syntax_Syntax.sigrng);
                         FStar_Syntax_Syntax.sigquals =
                           (FStar_Syntax_Syntax.Irreducible ::
                           (se.FStar_Syntax_Syntax.sigquals));
                         FStar_Syntax_Syntax.sigmeta =
                           (uu___127_23109.FStar_Syntax_Syntax.sigmeta);
                         FStar_Syntax_Syntax.sigattrs =
                           (uu___127_23109.FStar_Syntax_Syntax.sigattrs)
                       } in
                     let uu____23114 = encode_sigelt' env1 val_decl in
                     match uu____23114 with | (decls,env2) -> (env2, decls)
                   else (env1, [])) env (FStar_Pervasives_Native.snd lbs) in
          (match uu____23058 with
           | (env1,decls) -> ((FStar_List.flatten decls), env1))
      | FStar_Syntax_Syntax.Sig_let
          ((uu____23142,{ FStar_Syntax_Syntax.lbname = FStar_Util.Inr b2t1;
                          FStar_Syntax_Syntax.lbunivs = uu____23144;
                          FStar_Syntax_Syntax.lbtyp = uu____23145;
                          FStar_Syntax_Syntax.lbeff = uu____23146;
                          FStar_Syntax_Syntax.lbdef = uu____23147;_}::[]),uu____23148)
          when FStar_Syntax_Syntax.fv_eq_lid b2t1 FStar_Parser_Const.b2t_lid
          ->
          let uu____23167 =
            new_term_constant_and_tok_from_lid env
              (b2t1.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          (match uu____23167 with
           | (tname,ttok,env1) ->
               let xx = ("x", FStar_SMTEncoding_Term.Term_sort) in
               let x = FStar_SMTEncoding_Util.mkFreeV xx in
               let b2t_x = FStar_SMTEncoding_Util.mkApp ("Prims.b2t", [x]) in
               let valid_b2t_x =
                 FStar_SMTEncoding_Util.mkApp ("Valid", [b2t_x]) in
               let decls =
                 let uu____23196 =
                   let uu____23199 =
                     let uu____23200 =
                       let uu____23207 =
                         let uu____23208 =
                           let uu____23219 =
                             let uu____23220 =
                               let uu____23225 =
                                 FStar_SMTEncoding_Util.mkApp
                                   ((FStar_Pervasives_Native.snd
                                       FStar_SMTEncoding_Term.boxBoolFun),
                                     [x]) in
                               (valid_b2t_x, uu____23225) in
                             FStar_SMTEncoding_Util.mkEq uu____23220 in
                           ([[b2t_x]], [xx], uu____23219) in
                         FStar_SMTEncoding_Util.mkForall uu____23208 in
                       (uu____23207,
                         (FStar_Pervasives_Native.Some "b2t def"), "b2t_def") in
                     FStar_SMTEncoding_Util.mkAssume uu____23200 in
                   [uu____23199] in
                 (FStar_SMTEncoding_Term.DeclFun
                    (tname, [FStar_SMTEncoding_Term.Term_sort],
                      FStar_SMTEncoding_Term.Term_sort,
                      FStar_Pervasives_Native.None))
                   :: uu____23196 in
               (decls, env1))
      | FStar_Syntax_Syntax.Sig_let (uu____23258,uu____23259) when
          FStar_All.pipe_right se.FStar_Syntax_Syntax.sigquals
            (FStar_Util.for_some
               (fun uu___93_23268  ->
                  match uu___93_23268 with
                  | FStar_Syntax_Syntax.Discriminator uu____23269 -> true
                  | uu____23270 -> false))
          -> ([], env)
      | FStar_Syntax_Syntax.Sig_let (uu____23273,lids) when
          (FStar_All.pipe_right lids
             (FStar_Util.for_some
                (fun l  ->
                   let uu____23284 =
                     let uu____23285 = FStar_List.hd l.FStar_Ident.ns in
                     uu____23285.FStar_Ident.idText in
                   uu____23284 = "Prims")))
            &&
            (FStar_All.pipe_right se.FStar_Syntax_Syntax.sigquals
               (FStar_Util.for_some
                  (fun uu___94_23289  ->
                     match uu___94_23289 with
                     | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen 
                         -> true
                     | uu____23290 -> false)))
          -> ([], env)
      | FStar_Syntax_Syntax.Sig_let ((false ,lb::[]),uu____23294) when
          FStar_All.pipe_right se.FStar_Syntax_Syntax.sigquals
            (FStar_Util.for_some
               (fun uu___95_23311  ->
                  match uu___95_23311 with
                  | FStar_Syntax_Syntax.Projector uu____23312 -> true
                  | uu____23317 -> false))
          ->
          let fv = FStar_Util.right lb.FStar_Syntax_Syntax.lbname in
          let l = (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
          let uu____23320 = try_lookup_free_var env l in
          (match uu____23320 with
           | FStar_Pervasives_Native.Some uu____23327 -> ([], env)
           | FStar_Pervasives_Native.None  ->
               let se1 =
                 let uu___128_23331 = se in
                 {
                   FStar_Syntax_Syntax.sigel =
                     (FStar_Syntax_Syntax.Sig_declare_typ
                        (l, (lb.FStar_Syntax_Syntax.lbunivs),
                          (lb.FStar_Syntax_Syntax.lbtyp)));
                   FStar_Syntax_Syntax.sigrng = (FStar_Ident.range_of_lid l);
                   FStar_Syntax_Syntax.sigquals =
                     (uu___128_23331.FStar_Syntax_Syntax.sigquals);
                   FStar_Syntax_Syntax.sigmeta =
                     (uu___128_23331.FStar_Syntax_Syntax.sigmeta);
                   FStar_Syntax_Syntax.sigattrs =
                     (uu___128_23331.FStar_Syntax_Syntax.sigattrs)
                 } in
               encode_sigelt env se1)
      | FStar_Syntax_Syntax.Sig_let ((is_rec,bindings),uu____23338) ->
          encode_top_level_let env (is_rec, bindings)
            se.FStar_Syntax_Syntax.sigquals
      | FStar_Syntax_Syntax.Sig_bundle (ses,uu____23356) ->
          let uu____23365 = encode_sigelts env ses in
          (match uu____23365 with
           | (g,env1) ->
               let uu____23382 =
                 FStar_All.pipe_right g
                   (FStar_List.partition
                      (fun uu___96_23405  ->
                         match uu___96_23405 with
                         | FStar_SMTEncoding_Term.Assume
                             {
                               FStar_SMTEncoding_Term.assumption_term =
                                 uu____23406;
                               FStar_SMTEncoding_Term.assumption_caption =
                                 FStar_Pervasives_Native.Some
                                 "inversion axiom";
                               FStar_SMTEncoding_Term.assumption_name =
                                 uu____23407;
                               FStar_SMTEncoding_Term.assumption_fact_ids =
                                 uu____23408;_}
                             -> false
                         | uu____23411 -> true)) in
               (match uu____23382 with
                | (g',inversions) ->
                    let uu____23426 =
                      FStar_All.pipe_right g'
                        (FStar_List.partition
                           (fun uu___97_23447  ->
                              match uu___97_23447 with
                              | FStar_SMTEncoding_Term.DeclFun uu____23448 ->
                                  true
                              | uu____23459 -> false)) in
                    (match uu____23426 with
                     | (decls,rest) ->
                         ((FStar_List.append decls
                             (FStar_List.append rest inversions)), env1))))
      | FStar_Syntax_Syntax.Sig_inductive_typ
          (t,uu____23477,tps,k,uu____23480,datas) ->
          let quals = se.FStar_Syntax_Syntax.sigquals in
          let is_logical =
            FStar_All.pipe_right quals
              (FStar_Util.for_some
                 (fun uu___98_23497  ->
                    match uu___98_23497 with
                    | FStar_Syntax_Syntax.Logic  -> true
                    | FStar_Syntax_Syntax.Assumption  -> true
                    | uu____23498 -> false)) in
          let constructor_or_logic_type_decl c =
            if is_logical
            then
              let uu____23507 = c in
              match uu____23507 with
              | (name,args,uu____23512,uu____23513,uu____23514) ->
                  let uu____23519 =
                    let uu____23520 =
                      let uu____23531 =
                        FStar_All.pipe_right args
                          (FStar_List.map
                             (fun uu____23548  ->
                                match uu____23548 with
                                | (uu____23555,sort,uu____23557) -> sort)) in
                      (name, uu____23531, FStar_SMTEncoding_Term.Term_sort,
                        FStar_Pervasives_Native.None) in
                    FStar_SMTEncoding_Term.DeclFun uu____23520 in
                  [uu____23519]
            else FStar_SMTEncoding_Term.constructor_to_decl c in
          let inversion_axioms tapp vars =
            let uu____23584 =
              FStar_All.pipe_right datas
                (FStar_Util.for_some
                   (fun l  ->
                      let uu____23590 =
                        FStar_TypeChecker_Env.try_lookup_lid env.tcenv l in
                      FStar_All.pipe_right uu____23590 FStar_Option.isNone)) in
            if uu____23584
            then []
            else
              (let uu____23622 =
                 fresh_fvar "x" FStar_SMTEncoding_Term.Term_sort in
               match uu____23622 with
               | (xxsym,xx) ->
                   let uu____23631 =
                     FStar_All.pipe_right datas
                       (FStar_List.fold_left
                          (fun uu____23670  ->
                             fun l  ->
                               match uu____23670 with
                               | (out,decls) ->
                                   let uu____23690 =
                                     FStar_TypeChecker_Env.lookup_datacon
                                       env.tcenv l in
                                   (match uu____23690 with
                                    | (uu____23701,data_t) ->
                                        let uu____23703 =
                                          FStar_Syntax_Util.arrow_formals
                                            data_t in
                                        (match uu____23703 with
                                         | (args,res) ->
                                             let indices =
                                               let uu____23749 =
                                                 let uu____23750 =
                                                   FStar_Syntax_Subst.compress
                                                     res in
                                                 uu____23750.FStar_Syntax_Syntax.n in
                                               match uu____23749 with
                                               | FStar_Syntax_Syntax.Tm_app
                                                   (uu____23761,indices) ->
                                                   indices
                                               | uu____23783 -> [] in
                                             let env1 =
                                               FStar_All.pipe_right args
                                                 (FStar_List.fold_left
                                                    (fun env1  ->
                                                       fun uu____23807  ->
                                                         match uu____23807
                                                         with
                                                         | (x,uu____23813) ->
                                                             let uu____23814
                                                               =
                                                               let uu____23815
                                                                 =
                                                                 let uu____23822
                                                                   =
                                                                   mk_term_projector_name
                                                                    l x in
                                                                 (uu____23822,
                                                                   [xx]) in
                                                               FStar_SMTEncoding_Util.mkApp
                                                                 uu____23815 in
                                                             push_term_var
                                                               env1 x
                                                               uu____23814)
                                                    env) in
                                             let uu____23825 =
                                               encode_args indices env1 in
                                             (match uu____23825 with
                                              | (indices1,decls') ->
                                                  (if
                                                     (FStar_List.length
                                                        indices1)
                                                       <>
                                                       (FStar_List.length
                                                          vars)
                                                   then failwith "Impossible"
                                                   else ();
                                                   (let eqs =
                                                      let uu____23851 =
                                                        FStar_List.map2
                                                          (fun v1  ->
                                                             fun a  ->
                                                               let uu____23867
                                                                 =
                                                                 let uu____23872
                                                                   =
                                                                   FStar_SMTEncoding_Util.mkFreeV
                                                                    v1 in
                                                                 (uu____23872,
                                                                   a) in
                                                               FStar_SMTEncoding_Util.mkEq
                                                                 uu____23867)
                                                          vars indices1 in
                                                      FStar_All.pipe_right
                                                        uu____23851
                                                        FStar_SMTEncoding_Util.mk_and_l in
                                                    let uu____23875 =
                                                      let uu____23876 =
                                                        let uu____23881 =
                                                          let uu____23882 =
                                                            let uu____23887 =
                                                              mk_data_tester
                                                                env1 l xx in
                                                            (uu____23887,
                                                              eqs) in
                                                          FStar_SMTEncoding_Util.mkAnd
                                                            uu____23882 in
                                                        (out, uu____23881) in
                                                      FStar_SMTEncoding_Util.mkOr
                                                        uu____23876 in
                                                    (uu____23875,
                                                      (FStar_List.append
                                                         decls decls'))))))))
                          (FStar_SMTEncoding_Util.mkFalse, [])) in
                   (match uu____23631 with
                    | (data_ax,decls) ->
                        let uu____23900 =
                          fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort in
                        (match uu____23900 with
                         | (ffsym,ff) ->
                             let fuel_guarded_inversion =
                               let xx_has_type_sfuel =
                                 if
                                   (FStar_List.length datas) >
                                     (Prims.parse_int "1")
                                 then
                                   let uu____23911 =
                                     FStar_SMTEncoding_Util.mkApp
                                       ("SFuel", [ff]) in
                                   FStar_SMTEncoding_Term.mk_HasTypeFuel
                                     uu____23911 xx tapp
                                 else
                                   FStar_SMTEncoding_Term.mk_HasTypeFuel ff
                                     xx tapp in
                               let uu____23915 =
                                 let uu____23922 =
                                   let uu____23923 =
                                     let uu____23934 =
                                       add_fuel
                                         (ffsym,
                                           FStar_SMTEncoding_Term.Fuel_sort)
                                         ((xxsym,
                                            FStar_SMTEncoding_Term.Term_sort)
                                         :: vars) in
                                     let uu____23949 =
                                       FStar_SMTEncoding_Util.mkImp
                                         (xx_has_type_sfuel, data_ax) in
                                     ([[xx_has_type_sfuel]], uu____23934,
                                       uu____23949) in
                                   FStar_SMTEncoding_Util.mkForall
                                     uu____23923 in
                                 let uu____23964 =
                                   varops.mk_unique
                                     (Prims.strcat "fuel_guarded_inversion_"
                                        t.FStar_Ident.str) in
                                 (uu____23922,
                                   (FStar_Pervasives_Native.Some
                                      "inversion axiom"), uu____23964) in
                               FStar_SMTEncoding_Util.mkAssume uu____23915 in
                             FStar_List.append decls [fuel_guarded_inversion]))) in
          let uu____23967 =
            let uu____23980 =
              let uu____23981 = FStar_Syntax_Subst.compress k in
              uu____23981.FStar_Syntax_Syntax.n in
            match uu____23980 with
            | FStar_Syntax_Syntax.Tm_arrow (formals,kres) ->
                ((FStar_List.append tps formals),
                  (FStar_Syntax_Util.comp_result kres))
            | uu____24026 -> (tps, k) in
          (match uu____23967 with
           | (formals,res) ->
               let uu____24049 = FStar_Syntax_Subst.open_term formals res in
               (match uu____24049 with
                | (formals1,res1) ->
                    let uu____24060 =
                      encode_binders FStar_Pervasives_Native.None formals1
                        env in
                    (match uu____24060 with
                     | (vars,guards,env',binder_decls,uu____24085) ->
                         let uu____24098 =
                           new_term_constant_and_tok_from_lid env t in
                         (match uu____24098 with
                          | (tname,ttok,env1) ->
                              let ttok_tm =
                                FStar_SMTEncoding_Util.mkApp (ttok, []) in
                              let guard =
                                FStar_SMTEncoding_Util.mk_and_l guards in
                              let tapp =
                                let uu____24117 =
                                  let uu____24124 =
                                    FStar_List.map
                                      FStar_SMTEncoding_Util.mkFreeV vars in
                                  (tname, uu____24124) in
                                FStar_SMTEncoding_Util.mkApp uu____24117 in
                              let uu____24133 =
                                let tname_decl =
                                  let uu____24143 =
                                    let uu____24144 =
                                      FStar_All.pipe_right vars
                                        (FStar_List.map
                                           (fun uu____24176  ->
                                              match uu____24176 with
                                              | (n1,s) ->
                                                  ((Prims.strcat tname n1),
                                                    s, false))) in
                                    let uu____24189 = varops.next_id () in
                                    (tname, uu____24144,
                                      FStar_SMTEncoding_Term.Term_sort,
                                      uu____24189, false) in
                                  constructor_or_logic_type_decl uu____24143 in
                                let uu____24198 =
                                  match vars with
                                  | [] ->
                                      let uu____24211 =
                                        let uu____24212 =
                                          let uu____24215 =
                                            FStar_SMTEncoding_Util.mkApp
                                              (tname, []) in
                                          FStar_All.pipe_left
                                            (fun _0_44  ->
                                               FStar_Pervasives_Native.Some
                                                 _0_44) uu____24215 in
                                        push_free_var env1 t tname
                                          uu____24212 in
                                      ([], uu____24211)
                                  | uu____24222 ->
                                      let ttok_decl =
                                        FStar_SMTEncoding_Term.DeclFun
                                          (ttok, [],
                                            FStar_SMTEncoding_Term.Term_sort,
                                            (FStar_Pervasives_Native.Some
                                               "token")) in
                                      let ttok_fresh =
                                        let uu____24231 = varops.next_id () in
                                        FStar_SMTEncoding_Term.fresh_token
                                          (ttok,
                                            FStar_SMTEncoding_Term.Term_sort)
                                          uu____24231 in
                                      let ttok_app = mk_Apply ttok_tm vars in
                                      let pats = [[ttok_app]; [tapp]] in
                                      let name_tok_corr =
                                        let uu____24245 =
                                          let uu____24252 =
                                            let uu____24253 =
                                              let uu____24268 =
                                                FStar_SMTEncoding_Util.mkEq
                                                  (ttok_app, tapp) in
                                              (pats,
                                                FStar_Pervasives_Native.None,
                                                vars, uu____24268) in
                                            FStar_SMTEncoding_Util.mkForall'
                                              uu____24253 in
                                          (uu____24252,
                                            (FStar_Pervasives_Native.Some
                                               "name-token correspondence"),
                                            (Prims.strcat
                                               "token_correspondence_" ttok)) in
                                        FStar_SMTEncoding_Util.mkAssume
                                          uu____24245 in
                                      ([ttok_decl; ttok_fresh; name_tok_corr],
                                        env1) in
                                match uu____24198 with
                                | (tok_decls,env2) ->
                                    ((FStar_List.append tname_decl tok_decls),
                                      env2) in
                              (match uu____24133 with
                               | (decls,env2) ->
                                   let kindingAx =
                                     let uu____24308 =
                                       encode_term_pred
                                         FStar_Pervasives_Native.None res1
                                         env' tapp in
                                     match uu____24308 with
                                     | (k1,decls1) ->
                                         let karr =
                                           if
                                             (FStar_List.length formals1) >
                                               (Prims.parse_int "0")
                                           then
                                             let uu____24326 =
                                               let uu____24327 =
                                                 let uu____24334 =
                                                   let uu____24335 =
                                                     FStar_SMTEncoding_Term.mk_PreType
                                                       ttok_tm in
                                                   FStar_SMTEncoding_Term.mk_tester
                                                     "Tm_arrow" uu____24335 in
                                                 (uu____24334,
                                                   (FStar_Pervasives_Native.Some
                                                      "kinding"),
                                                   (Prims.strcat
                                                      "pre_kinding_" ttok)) in
                                               FStar_SMTEncoding_Util.mkAssume
                                                 uu____24327 in
                                             [uu____24326]
                                           else [] in
                                         let uu____24339 =
                                           let uu____24342 =
                                             let uu____24345 =
                                               let uu____24346 =
                                                 let uu____24353 =
                                                   let uu____24354 =
                                                     let uu____24365 =
                                                       FStar_SMTEncoding_Util.mkImp
                                                         (guard, k1) in
                                                     ([[tapp]], vars,
                                                       uu____24365) in
                                                   FStar_SMTEncoding_Util.mkForall
                                                     uu____24354 in
                                                 (uu____24353,
                                                   FStar_Pervasives_Native.None,
                                                   (Prims.strcat "kinding_"
                                                      ttok)) in
                                               FStar_SMTEncoding_Util.mkAssume
                                                 uu____24346 in
                                             [uu____24345] in
                                           FStar_List.append karr uu____24342 in
                                         FStar_List.append decls1 uu____24339 in
                                   let aux =
                                     let uu____24381 =
                                       let uu____24384 =
                                         inversion_axioms tapp vars in
                                       let uu____24387 =
                                         let uu____24390 =
                                           pretype_axiom env2 tapp vars in
                                         [uu____24390] in
                                       FStar_List.append uu____24384
                                         uu____24387 in
                                     FStar_List.append kindingAx uu____24381 in
                                   let g =
                                     FStar_List.append decls
                                       (FStar_List.append binder_decls aux) in
                                   (g, env2))))))
      | FStar_Syntax_Syntax.Sig_datacon
          (d,uu____24397,uu____24398,uu____24399,uu____24400,uu____24401)
          when FStar_Ident.lid_equals d FStar_Parser_Const.lexcons_lid ->
          ([], env)
      | FStar_Syntax_Syntax.Sig_datacon
          (d,uu____24409,t,uu____24411,n_tps,uu____24413) ->
          let quals = se.FStar_Syntax_Syntax.sigquals in
          let uu____24421 = new_term_constant_and_tok_from_lid env d in
          (match uu____24421 with
           | (ddconstrsym,ddtok,env1) ->
               let ddtok_tm = FStar_SMTEncoding_Util.mkApp (ddtok, []) in
               let uu____24438 = FStar_Syntax_Util.arrow_formals t in
               (match uu____24438 with
                | (formals,t_res) ->
                    let uu____24473 =
                      fresh_fvar "f" FStar_SMTEncoding_Term.Fuel_sort in
                    (match uu____24473 with
                     | (fuel_var,fuel_tm) ->
                         let s_fuel_tm =
                           FStar_SMTEncoding_Util.mkApp ("SFuel", [fuel_tm]) in
                         let uu____24487 =
                           encode_binders
                             (FStar_Pervasives_Native.Some fuel_tm) formals
                             env1 in
                         (match uu____24487 with
                          | (vars,guards,env',binder_decls,names1) ->
                              let fields =
                                FStar_All.pipe_right names1
                                  (FStar_List.mapi
                                     (fun n1  ->
                                        fun x  ->
                                          let projectible = true in
                                          let uu____24557 =
                                            mk_term_projector_name d x in
                                          (uu____24557,
                                            FStar_SMTEncoding_Term.Term_sort,
                                            projectible))) in
                              let datacons =
                                let uu____24559 =
                                  let uu____24578 = varops.next_id () in
                                  (ddconstrsym, fields,
                                    FStar_SMTEncoding_Term.Term_sort,
                                    uu____24578, true) in
                                FStar_All.pipe_right uu____24559
                                  FStar_SMTEncoding_Term.constructor_to_decl in
                              let app = mk_Apply ddtok_tm vars in
                              let guard =
                                FStar_SMTEncoding_Util.mk_and_l guards in
                              let xvars =
                                FStar_List.map FStar_SMTEncoding_Util.mkFreeV
                                  vars in
                              let dapp =
                                FStar_SMTEncoding_Util.mkApp
                                  (ddconstrsym, xvars) in
                              let uu____24617 =
                                encode_term_pred FStar_Pervasives_Native.None
                                  t env1 ddtok_tm in
                              (match uu____24617 with
                               | (tok_typing,decls3) ->
                                   let tok_typing1 =
                                     match fields with
                                     | uu____24629::uu____24630 ->
                                         let ff =
                                           ("ty",
                                             FStar_SMTEncoding_Term.Term_sort) in
                                         let f =
                                           FStar_SMTEncoding_Util.mkFreeV ff in
                                         let vtok_app_l =
                                           mk_Apply ddtok_tm [ff] in
                                         let vtok_app_r =
                                           mk_Apply f
                                             [(ddtok,
                                                FStar_SMTEncoding_Term.Term_sort)] in
                                         let uu____24675 =
                                           let uu____24686 =
                                             FStar_SMTEncoding_Term.mk_NoHoist
                                               f tok_typing in
                                           ([[vtok_app_l]; [vtok_app_r]],
                                             [ff], uu____24686) in
                                         FStar_SMTEncoding_Util.mkForall
                                           uu____24675
                                     | uu____24711 -> tok_typing in
                                   let uu____24720 =
                                     encode_binders
                                       (FStar_Pervasives_Native.Some fuel_tm)
                                       formals env1 in
                                   (match uu____24720 with
                                    | (vars',guards',env'',decls_formals,uu____24745)
                                        ->
                                        let uu____24758 =
                                          let xvars1 =
                                            FStar_List.map
                                              FStar_SMTEncoding_Util.mkFreeV
                                              vars' in
                                          let dapp1 =
                                            FStar_SMTEncoding_Util.mkApp
                                              (ddconstrsym, xvars1) in
                                          encode_term_pred
                                            (FStar_Pervasives_Native.Some
                                               fuel_tm) t_res env'' dapp1 in
                                        (match uu____24758 with
                                         | (ty_pred',decls_pred) ->
                                             let guard' =
                                               FStar_SMTEncoding_Util.mk_and_l
                                                 guards' in
                                             let proxy_fresh =
                                               match formals with
                                               | [] -> []
                                               | uu____24789 ->
                                                   let uu____24796 =
                                                     let uu____24797 =
                                                       varops.next_id () in
                                                     FStar_SMTEncoding_Term.fresh_token
                                                       (ddtok,
                                                         FStar_SMTEncoding_Term.Term_sort)
                                                       uu____24797 in
                                                   [uu____24796] in
                                             let encode_elim uu____24807 =
                                               let uu____24808 =
                                                 FStar_Syntax_Util.head_and_args
                                                   t_res in
                                               match uu____24808 with
                                               | (head1,args) ->
                                                   let uu____24851 =
                                                     let uu____24852 =
                                                       FStar_Syntax_Subst.compress
                                                         head1 in
                                                     uu____24852.FStar_Syntax_Syntax.n in
                                                   (match uu____24851 with
                                                    | FStar_Syntax_Syntax.Tm_uinst
                                                        ({
                                                           FStar_Syntax_Syntax.n
                                                             =
                                                             FStar_Syntax_Syntax.Tm_fvar
                                                             fv;
                                                           FStar_Syntax_Syntax.pos
                                                             = uu____24862;
                                                           FStar_Syntax_Syntax.vars
                                                             = uu____24863;_},uu____24864)
                                                        ->
                                                        let encoded_head =
                                                          lookup_free_var_name
                                                            env'
                                                            fv.FStar_Syntax_Syntax.fv_name in
                                                        let uu____24870 =
                                                          encode_args args
                                                            env' in
                                                        (match uu____24870
                                                         with
                                                         | (encoded_args,arg_decls)
                                                             ->
                                                             let guards_for_parameter
                                                               orig_arg arg
                                                               xv =
                                                               let fv1 =
                                                                 match 
                                                                   arg.FStar_SMTEncoding_Term.tm
                                                                 with
                                                                 | FStar_SMTEncoding_Term.FreeV
                                                                    fv1 ->
                                                                    fv1
                                                                 | uu____24913
                                                                    ->
                                                                    let uu____24914
                                                                    =
                                                                    let uu____24919
                                                                    =
                                                                    let uu____24920
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    orig_arg in
                                                                    FStar_Util.format1
                                                                    "Inductive type parameter %s must be a variable ; You may want to change it to an index."
                                                                    uu____24920 in
                                                                    (FStar_Errors.Fatal_NonVaribleInductiveTypeParameter,
                                                                    uu____24919) in
                                                                    FStar_Errors.raise_error
                                                                    uu____24914
                                                                    orig_arg.FStar_Syntax_Syntax.pos in
                                                               let guards1 =
                                                                 FStar_All.pipe_right
                                                                   guards
                                                                   (FStar_List.collect
                                                                    (fun g 
                                                                    ->
                                                                    let uu____24936
                                                                    =
                                                                    let uu____24937
                                                                    =
                                                                    FStar_SMTEncoding_Term.free_variables
                                                                    g in
                                                                    FStar_List.contains
                                                                    fv1
                                                                    uu____24937 in
                                                                    if
                                                                    uu____24936
                                                                    then
                                                                    let uu____24950
                                                                    =
                                                                    FStar_SMTEncoding_Term.subst
                                                                    g fv1 xv in
                                                                    [uu____24950]
                                                                    else [])) in
                                                               FStar_SMTEncoding_Util.mk_and_l
                                                                 guards1 in
                                                             let uu____24952
                                                               =
                                                               let uu____24965
                                                                 =
                                                                 FStar_List.zip
                                                                   args
                                                                   encoded_args in
                                                               FStar_List.fold_left
                                                                 (fun
                                                                    uu____25015
                                                                     ->
                                                                    fun
                                                                    uu____25016
                                                                     ->
                                                                    match 
                                                                    (uu____25015,
                                                                    uu____25016)
                                                                    with
                                                                    | 
                                                                    ((env2,arg_vars,eqns_or_guards,i),
                                                                    (orig_arg,arg))
                                                                    ->
                                                                    let uu____25111
                                                                    =
                                                                    let uu____25118
                                                                    =
                                                                    FStar_Syntax_Syntax.new_bv
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Syntax_Syntax.tun in
                                                                    gen_term_var
                                                                    env2
                                                                    uu____25118 in
                                                                    (match uu____25111
                                                                    with
                                                                    | 
                                                                    (uu____25131,xv,env3)
                                                                    ->
                                                                    let eqns
                                                                    =
                                                                    if
                                                                    i < n_tps
                                                                    then
                                                                    let uu____25139
                                                                    =
                                                                    guards_for_parameter
                                                                    (FStar_Pervasives_Native.fst
                                                                    orig_arg)
                                                                    arg xv in
                                                                    uu____25139
                                                                    ::
                                                                    eqns_or_guards
                                                                    else
                                                                    (let uu____25141
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkEq
                                                                    (arg, xv) in
                                                                    uu____25141
                                                                    ::
                                                                    eqns_or_guards) in
                                                                    (env3,
                                                                    (xv ::
                                                                    arg_vars),
                                                                    eqns,
                                                                    (i +
                                                                    (Prims.parse_int
                                                                    "1")))))
                                                                 (env', [],
                                                                   [],
                                                                   (Prims.parse_int
                                                                    "0"))
                                                                 uu____24965 in
                                                             (match uu____24952
                                                              with
                                                              | (uu____25156,arg_vars,elim_eqns_or_guards,uu____25159)
                                                                  ->
                                                                  let arg_vars1
                                                                    =
                                                                    FStar_List.rev
                                                                    arg_vars in
                                                                  let ty =
                                                                    FStar_SMTEncoding_Util.mkApp
                                                                    (encoded_head,
                                                                    arg_vars1) in
                                                                  let xvars1
                                                                    =
                                                                    FStar_List.map
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    vars in
                                                                  let dapp1 =
                                                                    FStar_SMTEncoding_Util.mkApp
                                                                    (ddconstrsym,
                                                                    xvars1) in
                                                                  let ty_pred
                                                                    =
                                                                    FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                                                    (FStar_Pervasives_Native.Some
                                                                    s_fuel_tm)
                                                                    dapp1 ty in
                                                                  let arg_binders
                                                                    =
                                                                    FStar_List.map
                                                                    FStar_SMTEncoding_Term.fv_of_term
                                                                    arg_vars1 in
                                                                  let typing_inversion
                                                                    =
                                                                    let uu____25189
                                                                    =
                                                                    let uu____25196
                                                                    =
                                                                    let uu____25197
                                                                    =
                                                                    let uu____25208
                                                                    =
                                                                    add_fuel
                                                                    (fuel_var,
                                                                    FStar_SMTEncoding_Term.Fuel_sort)
                                                                    (FStar_List.append
                                                                    vars
                                                                    arg_binders) in
                                                                    let uu____25219
                                                                    =
                                                                    let uu____25220
                                                                    =
                                                                    let uu____25225
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_and_l
                                                                    (FStar_List.append
                                                                    elim_eqns_or_guards
                                                                    guards) in
                                                                    (ty_pred,
                                                                    uu____25225) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____25220 in
                                                                    ([
                                                                    [ty_pred]],
                                                                    uu____25208,
                                                                    uu____25219) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____25197 in
                                                                    (uu____25196,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "data constructor typing elim"),
                                                                    (Prims.strcat
                                                                    "data_elim_"
                                                                    ddconstrsym)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____25189 in
                                                                  let subterm_ordering
                                                                    =
                                                                    if
                                                                    FStar_Ident.lid_equals
                                                                    d
                                                                    FStar_Parser_Const.lextop_lid
                                                                    then
                                                                    let x =
                                                                    let uu____25248
                                                                    =
                                                                    varops.fresh
                                                                    "x" in
                                                                    (uu____25248,
                                                                    FStar_SMTEncoding_Term.Term_sort) in
                                                                    let xtm =
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    x in
                                                                    let uu____25250
                                                                    =
                                                                    let uu____25257
                                                                    =
                                                                    let uu____25258
                                                                    =
                                                                    let uu____25269
                                                                    =
                                                                    let uu____25274
                                                                    =
                                                                    let uu____25277
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_Precedes
                                                                    xtm dapp1 in
                                                                    [uu____25277] in
                                                                    [uu____25274] in
                                                                    let uu____25282
                                                                    =
                                                                    let uu____25283
                                                                    =
                                                                    let uu____25288
                                                                    =
                                                                    FStar_SMTEncoding_Term.mk_tester
                                                                    "LexCons"
                                                                    xtm in
                                                                    let uu____25289
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_Precedes
                                                                    xtm dapp1 in
                                                                    (uu____25288,
                                                                    uu____25289) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____25283 in
                                                                    (uu____25269,
                                                                    [x],
                                                                    uu____25282) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____25258 in
                                                                    let uu____25308
                                                                    =
                                                                    varops.mk_unique
                                                                    "lextop" in
                                                                    (uu____25257,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "lextop is top"),
                                                                    uu____25308) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____25250
                                                                    else
                                                                    (let prec
                                                                    =
                                                                    let uu____25315
                                                                    =
                                                                    FStar_All.pipe_right
                                                                    vars
                                                                    (FStar_List.mapi
                                                                    (fun i 
                                                                    ->
                                                                    fun v1 
                                                                    ->
                                                                    if
                                                                    i < n_tps
                                                                    then []
                                                                    else
                                                                    (let uu____25343
                                                                    =
                                                                    let uu____25344
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    v1 in
                                                                    FStar_SMTEncoding_Util.mk_Precedes
                                                                    uu____25344
                                                                    dapp1 in
                                                                    [uu____25343]))) in
                                                                    FStar_All.pipe_right
                                                                    uu____25315
                                                                    FStar_List.flatten in
                                                                    let uu____25351
                                                                    =
                                                                    let uu____25358
                                                                    =
                                                                    let uu____25359
                                                                    =
                                                                    let uu____25370
                                                                    =
                                                                    add_fuel
                                                                    (fuel_var,
                                                                    FStar_SMTEncoding_Term.Fuel_sort)
                                                                    (FStar_List.append
                                                                    vars
                                                                    arg_binders) in
                                                                    let uu____25381
                                                                    =
                                                                    let uu____25382
                                                                    =
                                                                    let uu____25387
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_and_l
                                                                    prec in
                                                                    (ty_pred,
                                                                    uu____25387) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____25382 in
                                                                    ([
                                                                    [ty_pred]],
                                                                    uu____25370,
                                                                    uu____25381) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____25359 in
                                                                    (uu____25358,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "subterm ordering"),
                                                                    (Prims.strcat
                                                                    "subterm_ordering_"
                                                                    ddconstrsym)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____25351) in
                                                                  (arg_decls,
                                                                    [typing_inversion;
                                                                    subterm_ordering])))
                                                    | FStar_Syntax_Syntax.Tm_fvar
                                                        fv ->
                                                        let encoded_head =
                                                          lookup_free_var_name
                                                            env'
                                                            fv.FStar_Syntax_Syntax.fv_name in
                                                        let uu____25408 =
                                                          encode_args args
                                                            env' in
                                                        (match uu____25408
                                                         with
                                                         | (encoded_args,arg_decls)
                                                             ->
                                                             let guards_for_parameter
                                                               orig_arg arg
                                                               xv =
                                                               let fv1 =
                                                                 match 
                                                                   arg.FStar_SMTEncoding_Term.tm
                                                                 with
                                                                 | FStar_SMTEncoding_Term.FreeV
                                                                    fv1 ->
                                                                    fv1
                                                                 | uu____25451
                                                                    ->
                                                                    let uu____25452
                                                                    =
                                                                    let uu____25457
                                                                    =
                                                                    let uu____25458
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    orig_arg in
                                                                    FStar_Util.format1
                                                                    "Inductive type parameter %s must be a variable ; You may want to change it to an index."
                                                                    uu____25458 in
                                                                    (FStar_Errors.Fatal_NonVaribleInductiveTypeParameter,
                                                                    uu____25457) in
                                                                    FStar_Errors.raise_error
                                                                    uu____25452
                                                                    orig_arg.FStar_Syntax_Syntax.pos in
                                                               let guards1 =
                                                                 FStar_All.pipe_right
                                                                   guards
                                                                   (FStar_List.collect
                                                                    (fun g 
                                                                    ->
                                                                    let uu____25474
                                                                    =
                                                                    let uu____25475
                                                                    =
                                                                    FStar_SMTEncoding_Term.free_variables
                                                                    g in
                                                                    FStar_List.contains
                                                                    fv1
                                                                    uu____25475 in
                                                                    if
                                                                    uu____25474
                                                                    then
                                                                    let uu____25488
                                                                    =
                                                                    FStar_SMTEncoding_Term.subst
                                                                    g fv1 xv in
                                                                    [uu____25488]
                                                                    else [])) in
                                                               FStar_SMTEncoding_Util.mk_and_l
                                                                 guards1 in
                                                             let uu____25490
                                                               =
                                                               let uu____25503
                                                                 =
                                                                 FStar_List.zip
                                                                   args
                                                                   encoded_args in
                                                               FStar_List.fold_left
                                                                 (fun
                                                                    uu____25553
                                                                     ->
                                                                    fun
                                                                    uu____25554
                                                                     ->
                                                                    match 
                                                                    (uu____25553,
                                                                    uu____25554)
                                                                    with
                                                                    | 
                                                                    ((env2,arg_vars,eqns_or_guards,i),
                                                                    (orig_arg,arg))
                                                                    ->
                                                                    let uu____25649
                                                                    =
                                                                    let uu____25656
                                                                    =
                                                                    FStar_Syntax_Syntax.new_bv
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Syntax_Syntax.tun in
                                                                    gen_term_var
                                                                    env2
                                                                    uu____25656 in
                                                                    (match uu____25649
                                                                    with
                                                                    | 
                                                                    (uu____25669,xv,env3)
                                                                    ->
                                                                    let eqns
                                                                    =
                                                                    if
                                                                    i < n_tps
                                                                    then
                                                                    let uu____25677
                                                                    =
                                                                    guards_for_parameter
                                                                    (FStar_Pervasives_Native.fst
                                                                    orig_arg)
                                                                    arg xv in
                                                                    uu____25677
                                                                    ::
                                                                    eqns_or_guards
                                                                    else
                                                                    (let uu____25679
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkEq
                                                                    (arg, xv) in
                                                                    uu____25679
                                                                    ::
                                                                    eqns_or_guards) in
                                                                    (env3,
                                                                    (xv ::
                                                                    arg_vars),
                                                                    eqns,
                                                                    (i +
                                                                    (Prims.parse_int
                                                                    "1")))))
                                                                 (env', [],
                                                                   [],
                                                                   (Prims.parse_int
                                                                    "0"))
                                                                 uu____25503 in
                                                             (match uu____25490
                                                              with
                                                              | (uu____25694,arg_vars,elim_eqns_or_guards,uu____25697)
                                                                  ->
                                                                  let arg_vars1
                                                                    =
                                                                    FStar_List.rev
                                                                    arg_vars in
                                                                  let ty =
                                                                    FStar_SMTEncoding_Util.mkApp
                                                                    (encoded_head,
                                                                    arg_vars1) in
                                                                  let xvars1
                                                                    =
                                                                    FStar_List.map
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    vars in
                                                                  let dapp1 =
                                                                    FStar_SMTEncoding_Util.mkApp
                                                                    (ddconstrsym,
                                                                    xvars1) in
                                                                  let ty_pred
                                                                    =
                                                                    FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                                                    (FStar_Pervasives_Native.Some
                                                                    s_fuel_tm)
                                                                    dapp1 ty in
                                                                  let arg_binders
                                                                    =
                                                                    FStar_List.map
                                                                    FStar_SMTEncoding_Term.fv_of_term
                                                                    arg_vars1 in
                                                                  let typing_inversion
                                                                    =
                                                                    let uu____25727
                                                                    =
                                                                    let uu____25734
                                                                    =
                                                                    let uu____25735
                                                                    =
                                                                    let uu____25746
                                                                    =
                                                                    add_fuel
                                                                    (fuel_var,
                                                                    FStar_SMTEncoding_Term.Fuel_sort)
                                                                    (FStar_List.append
                                                                    vars
                                                                    arg_binders) in
                                                                    let uu____25757
                                                                    =
                                                                    let uu____25758
                                                                    =
                                                                    let uu____25763
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_and_l
                                                                    (FStar_List.append
                                                                    elim_eqns_or_guards
                                                                    guards) in
                                                                    (ty_pred,
                                                                    uu____25763) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____25758 in
                                                                    ([
                                                                    [ty_pred]],
                                                                    uu____25746,
                                                                    uu____25757) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____25735 in
                                                                    (uu____25734,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "data constructor typing elim"),
                                                                    (Prims.strcat
                                                                    "data_elim_"
                                                                    ddconstrsym)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____25727 in
                                                                  let subterm_ordering
                                                                    =
                                                                    if
                                                                    FStar_Ident.lid_equals
                                                                    d
                                                                    FStar_Parser_Const.lextop_lid
                                                                    then
                                                                    let x =
                                                                    let uu____25786
                                                                    =
                                                                    varops.fresh
                                                                    "x" in
                                                                    (uu____25786,
                                                                    FStar_SMTEncoding_Term.Term_sort) in
                                                                    let xtm =
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    x in
                                                                    let uu____25788
                                                                    =
                                                                    let uu____25795
                                                                    =
                                                                    let uu____25796
                                                                    =
                                                                    let uu____25807
                                                                    =
                                                                    let uu____25812
                                                                    =
                                                                    let uu____25815
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_Precedes
                                                                    xtm dapp1 in
                                                                    [uu____25815] in
                                                                    [uu____25812] in
                                                                    let uu____25820
                                                                    =
                                                                    let uu____25821
                                                                    =
                                                                    let uu____25826
                                                                    =
                                                                    FStar_SMTEncoding_Term.mk_tester
                                                                    "LexCons"
                                                                    xtm in
                                                                    let uu____25827
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_Precedes
                                                                    xtm dapp1 in
                                                                    (uu____25826,
                                                                    uu____25827) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____25821 in
                                                                    (uu____25807,
                                                                    [x],
                                                                    uu____25820) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____25796 in
                                                                    let uu____25846
                                                                    =
                                                                    varops.mk_unique
                                                                    "lextop" in
                                                                    (uu____25795,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "lextop is top"),
                                                                    uu____25846) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____25788
                                                                    else
                                                                    (let prec
                                                                    =
                                                                    let uu____25853
                                                                    =
                                                                    FStar_All.pipe_right
                                                                    vars
                                                                    (FStar_List.mapi
                                                                    (fun i 
                                                                    ->
                                                                    fun v1 
                                                                    ->
                                                                    if
                                                                    i < n_tps
                                                                    then []
                                                                    else
                                                                    (let uu____25881
                                                                    =
                                                                    let uu____25882
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkFreeV
                                                                    v1 in
                                                                    FStar_SMTEncoding_Util.mk_Precedes
                                                                    uu____25882
                                                                    dapp1 in
                                                                    [uu____25881]))) in
                                                                    FStar_All.pipe_right
                                                                    uu____25853
                                                                    FStar_List.flatten in
                                                                    let uu____25889
                                                                    =
                                                                    let uu____25896
                                                                    =
                                                                    let uu____25897
                                                                    =
                                                                    let uu____25908
                                                                    =
                                                                    add_fuel
                                                                    (fuel_var,
                                                                    FStar_SMTEncoding_Term.Fuel_sort)
                                                                    (FStar_List.append
                                                                    vars
                                                                    arg_binders) in
                                                                    let uu____25919
                                                                    =
                                                                    let uu____25920
                                                                    =
                                                                    let uu____25925
                                                                    =
                                                                    FStar_SMTEncoding_Util.mk_and_l
                                                                    prec in
                                                                    (ty_pred,
                                                                    uu____25925) in
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    uu____25920 in
                                                                    ([
                                                                    [ty_pred]],
                                                                    uu____25908,
                                                                    uu____25919) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____25897 in
                                                                    (uu____25896,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "subterm ordering"),
                                                                    (Prims.strcat
                                                                    "subterm_ordering_"
                                                                    ddconstrsym)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____25889) in
                                                                  (arg_decls,
                                                                    [typing_inversion;
                                                                    subterm_ordering])))
                                                    | uu____25944 ->
                                                        ((let uu____25946 =
                                                            let uu____25951 =
                                                              let uu____25952
                                                                =
                                                                FStar_Syntax_Print.lid_to_string
                                                                  d in
                                                              let uu____25953
                                                                =
                                                                FStar_Syntax_Print.term_to_string
                                                                  head1 in
                                                              FStar_Util.format2
                                                                "Constructor %s builds an unexpected type %s\n"
                                                                uu____25952
                                                                uu____25953 in
                                                            (FStar_Errors.Warning_ConstructorBuildsUnexpectedType,
                                                              uu____25951) in
                                                          FStar_Errors.log_issue
                                                            se.FStar_Syntax_Syntax.sigrng
                                                            uu____25946);
                                                         ([], []))) in
                                             let uu____25958 = encode_elim () in
                                             (match uu____25958 with
                                              | (decls2,elim) ->
                                                  let g =
                                                    let uu____25978 =
                                                      let uu____25981 =
                                                        let uu____25984 =
                                                          let uu____25987 =
                                                            let uu____25990 =
                                                              let uu____25991
                                                                =
                                                                let uu____26002
                                                                  =
                                                                  let uu____26005
                                                                    =
                                                                    let uu____26006
                                                                    =
                                                                    FStar_Syntax_Print.lid_to_string
                                                                    d in
                                                                    FStar_Util.format1
                                                                    "data constructor proxy: %s"
                                                                    uu____26006 in
                                                                  FStar_Pervasives_Native.Some
                                                                    uu____26005 in
                                                                (ddtok, [],
                                                                  FStar_SMTEncoding_Term.Term_sort,
                                                                  uu____26002) in
                                                              FStar_SMTEncoding_Term.DeclFun
                                                                uu____25991 in
                                                            [uu____25990] in
                                                          let uu____26011 =
                                                            let uu____26014 =
                                                              let uu____26017
                                                                =
                                                                let uu____26020
                                                                  =
                                                                  let uu____26023
                                                                    =
                                                                    let uu____26026
                                                                    =
                                                                    let uu____26029
                                                                    =
                                                                    let uu____26030
                                                                    =
                                                                    let uu____26037
                                                                    =
                                                                    let uu____26038
                                                                    =
                                                                    let uu____26049
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkEq
                                                                    (app,
                                                                    dapp) in
                                                                    ([[app]],
                                                                    vars,
                                                                    uu____26049) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____26038 in
                                                                    (uu____26037,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "equality for proxy"),
                                                                    (Prims.strcat
                                                                    "equality_tok_"
                                                                    ddtok)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____26030 in
                                                                    let uu____26062
                                                                    =
                                                                    let uu____26065
                                                                    =
                                                                    let uu____26066
                                                                    =
                                                                    let uu____26073
                                                                    =
                                                                    let uu____26074
                                                                    =
                                                                    let uu____26085
                                                                    =
                                                                    add_fuel
                                                                    (fuel_var,
                                                                    FStar_SMTEncoding_Term.Fuel_sort)
                                                                    vars' in
                                                                    let uu____26096
                                                                    =
                                                                    FStar_SMTEncoding_Util.mkImp
                                                                    (guard',
                                                                    ty_pred') in
                                                                    ([
                                                                    [ty_pred']],
                                                                    uu____26085,
                                                                    uu____26096) in
                                                                    FStar_SMTEncoding_Util.mkForall
                                                                    uu____26074 in
                                                                    (uu____26073,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "data constructor typing intro"),
                                                                    (Prims.strcat
                                                                    "data_typing_intro_"
                                                                    ddtok)) in
                                                                    FStar_SMTEncoding_Util.mkAssume
                                                                    uu____26066 in
                                                                    [uu____26065] in
                                                                    uu____26029
                                                                    ::
                                                                    uu____26062 in
                                                                    (FStar_SMTEncoding_Util.mkAssume
                                                                    (tok_typing1,
                                                                    (FStar_Pervasives_Native.Some
                                                                    "typing for data constructor proxy"),
                                                                    (Prims.strcat
                                                                    "typing_tok_"
                                                                    ddtok)))
                                                                    ::
                                                                    uu____26026 in
                                                                  FStar_List.append
                                                                    uu____26023
                                                                    elim in
                                                                FStar_List.append
                                                                  decls_pred
                                                                  uu____26020 in
                                                              FStar_List.append
                                                                decls_formals
                                                                uu____26017 in
                                                            FStar_List.append
                                                              proxy_fresh
                                                              uu____26014 in
                                                          FStar_List.append
                                                            uu____25987
                                                            uu____26011 in
                                                        FStar_List.append
                                                          decls3 uu____25984 in
                                                      FStar_List.append
                                                        decls2 uu____25981 in
                                                    FStar_List.append
                                                      binder_decls
                                                      uu____25978 in
                                                  ((FStar_List.append
                                                      datacons g), env1)))))))))
and encode_sigelts:
  env_t ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      (FStar_SMTEncoding_Term.decl Prims.list,env_t)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun ses  ->
      FStar_All.pipe_right ses
        (FStar_List.fold_left
           (fun uu____26142  ->
              fun se  ->
                match uu____26142 with
                | (g,env1) ->
                    let uu____26162 = encode_sigelt env1 se in
                    (match uu____26162 with
                     | (g',env2) -> ((FStar_List.append g g'), env2)))
           ([], env))
let encode_env_bindings:
  env_t ->
    FStar_TypeChecker_Env.binding Prims.list ->
      (FStar_SMTEncoding_Term.decls_t,env_t) FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun bindings  ->
      let encode_binding b uu____26219 =
        match uu____26219 with
        | (i,decls,env1) ->
            (match b with
             | FStar_TypeChecker_Env.Binding_univ uu____26251 ->
                 ((i + (Prims.parse_int "1")), [], env1)
             | FStar_TypeChecker_Env.Binding_var x ->
                 let t1 =
                   FStar_TypeChecker_Normalize.normalize
                     [FStar_TypeChecker_Normalize.Beta;
                     FStar_TypeChecker_Normalize.Eager_unfolding;
                     FStar_TypeChecker_Normalize.Simplify;
                     FStar_TypeChecker_Normalize.Primops;
                     FStar_TypeChecker_Normalize.EraseUniverses] env1.tcenv
                     x.FStar_Syntax_Syntax.sort in
                 ((let uu____26257 =
                     FStar_All.pipe_left
                       (FStar_TypeChecker_Env.debug env1.tcenv)
                       (FStar_Options.Other "SMTEncoding") in
                   if uu____26257
                   then
                     let uu____26258 = FStar_Syntax_Print.bv_to_string x in
                     let uu____26259 =
                       FStar_Syntax_Print.term_to_string
                         x.FStar_Syntax_Syntax.sort in
                     let uu____26260 = FStar_Syntax_Print.term_to_string t1 in
                     FStar_Util.print3 "Normalized %s : %s to %s\n"
                       uu____26258 uu____26259 uu____26260
                   else ());
                  (let uu____26262 = encode_term t1 env1 in
                   match uu____26262 with
                   | (t,decls') ->
                       let t_hash = FStar_SMTEncoding_Term.hash_of_term t in
                       let uu____26278 =
                         let uu____26285 =
                           let uu____26286 =
                             let uu____26287 =
                               FStar_Util.digest_of_string t_hash in
                             Prims.strcat uu____26287
                               (Prims.strcat "_" (Prims.string_of_int i)) in
                           Prims.strcat "x_" uu____26286 in
                         new_term_constant_from_string env1 x uu____26285 in
                       (match uu____26278 with
                        | (xxsym,xx,env') ->
                            let t2 =
                              FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                FStar_Pervasives_Native.None xx t in
                            let caption =
                              let uu____26303 = FStar_Options.log_queries () in
                              if uu____26303
                              then
                                let uu____26306 =
                                  let uu____26307 =
                                    FStar_Syntax_Print.bv_to_string x in
                                  let uu____26308 =
                                    FStar_Syntax_Print.term_to_string
                                      x.FStar_Syntax_Syntax.sort in
                                  let uu____26309 =
                                    FStar_Syntax_Print.term_to_string t1 in
                                  FStar_Util.format3 "%s : %s (%s)"
                                    uu____26307 uu____26308 uu____26309 in
                                FStar_Pervasives_Native.Some uu____26306
                              else FStar_Pervasives_Native.None in
                            let ax =
                              let a_name = Prims.strcat "binder_" xxsym in
                              FStar_SMTEncoding_Util.mkAssume
                                (t2, (FStar_Pervasives_Native.Some a_name),
                                  a_name) in
                            let g =
                              FStar_List.append
                                [FStar_SMTEncoding_Term.DeclFun
                                   (xxsym, [],
                                     FStar_SMTEncoding_Term.Term_sort,
                                     caption)]
                                (FStar_List.append decls' [ax]) in
                            ((i + (Prims.parse_int "1")),
                              (FStar_List.append decls g), env'))))
             | FStar_TypeChecker_Env.Binding_lid (x,(uu____26325,t)) ->
                 let t_norm = whnf env1 t in
                 let fv =
                   FStar_Syntax_Syntax.lid_as_fv x
                     FStar_Syntax_Syntax.Delta_constant
                     FStar_Pervasives_Native.None in
                 let uu____26339 = encode_free_var false env1 fv t t_norm [] in
                 (match uu____26339 with
                  | (g,env') ->
                      ((i + (Prims.parse_int "1")),
                        (FStar_List.append decls g), env'))
             | FStar_TypeChecker_Env.Binding_sig_inst
                 (uu____26362,se,uu____26364) ->
                 let uu____26369 = encode_sigelt env1 se in
                 (match uu____26369 with
                  | (g,env') ->
                      ((i + (Prims.parse_int "1")),
                        (FStar_List.append decls g), env'))
             | FStar_TypeChecker_Env.Binding_sig (uu____26386,se) ->
                 let uu____26392 = encode_sigelt env1 se in
                 (match uu____26392 with
                  | (g,env') ->
                      ((i + (Prims.parse_int "1")),
                        (FStar_List.append decls g), env'))) in
      let uu____26409 =
        FStar_List.fold_right encode_binding bindings
          ((Prims.parse_int "0"), [], env) in
      match uu____26409 with | (uu____26432,decls,env1) -> (decls, env1)
let encode_labels:
  'Auu____26444 'Auu____26445 .
    ((Prims.string,FStar_SMTEncoding_Term.sort)
       FStar_Pervasives_Native.tuple2,'Auu____26445,'Auu____26444)
      FStar_Pervasives_Native.tuple3 Prims.list ->
      (FStar_SMTEncoding_Term.decl Prims.list,FStar_SMTEncoding_Term.decl
                                                Prims.list)
        FStar_Pervasives_Native.tuple2
  =
  fun labs  ->
    let prefix1 =
      FStar_All.pipe_right labs
        (FStar_List.map
           (fun uu____26513  ->
              match uu____26513 with
              | (l,uu____26525,uu____26526) ->
                  FStar_SMTEncoding_Term.DeclFun
                    ((FStar_Pervasives_Native.fst l), [],
                      FStar_SMTEncoding_Term.Bool_sort,
                      FStar_Pervasives_Native.None))) in
    let suffix =
      FStar_All.pipe_right labs
        (FStar_List.collect
           (fun uu____26572  ->
              match uu____26572 with
              | (l,uu____26586,uu____26587) ->
                  let uu____26596 =
                    FStar_All.pipe_left
                      (fun _0_45  -> FStar_SMTEncoding_Term.Echo _0_45)
                      (FStar_Pervasives_Native.fst l) in
                  let uu____26597 =
                    let uu____26600 =
                      let uu____26601 = FStar_SMTEncoding_Util.mkFreeV l in
                      FStar_SMTEncoding_Term.Eval uu____26601 in
                    [uu____26600] in
                  uu____26596 :: uu____26597)) in
    (prefix1, suffix)
let last_env: env_t Prims.list FStar_ST.ref = FStar_Util.mk_ref []
let init_env: FStar_TypeChecker_Env.env -> Prims.unit =
  fun tcenv  ->
    let uu____26626 =
      let uu____26629 =
        let uu____26630 = FStar_Util.smap_create (Prims.parse_int "100") in
        let uu____26633 =
          let uu____26634 = FStar_TypeChecker_Env.current_module tcenv in
          FStar_All.pipe_right uu____26634 FStar_Ident.string_of_lid in
        {
          bindings = [];
          depth = (Prims.parse_int "0");
          tcenv;
          warn = true;
          cache = uu____26630;
          nolabels = false;
          use_zfuel_name = false;
          encode_non_total_function_typ = true;
          current_module_name = uu____26633
        } in
      [uu____26629] in
    FStar_ST.op_Colon_Equals last_env uu____26626
let get_env: FStar_Ident.lident -> FStar_TypeChecker_Env.env -> env_t =
  fun cmn  ->
    fun tcenv  ->
      let uu____26693 = FStar_ST.op_Bang last_env in
      match uu____26693 with
      | [] -> failwith "No env; call init first!"
      | e::uu____26749 ->
          let uu___129_26752 = e in
          let uu____26753 = FStar_Ident.string_of_lid cmn in
          {
            bindings = (uu___129_26752.bindings);
            depth = (uu___129_26752.depth);
            tcenv;
            warn = (uu___129_26752.warn);
            cache = (uu___129_26752.cache);
            nolabels = (uu___129_26752.nolabels);
            use_zfuel_name = (uu___129_26752.use_zfuel_name);
            encode_non_total_function_typ =
              (uu___129_26752.encode_non_total_function_typ);
            current_module_name = uu____26753
          }
let set_env: env_t -> Prims.unit =
  fun env  ->
    let uu____26757 = FStar_ST.op_Bang last_env in
    match uu____26757 with
    | [] -> failwith "Empty env stack"
    | uu____26812::tl1 -> FStar_ST.op_Colon_Equals last_env (env :: tl1)
let push_env: Prims.unit -> Prims.unit =
  fun uu____26870  ->
    let uu____26871 = FStar_ST.op_Bang last_env in
    match uu____26871 with
    | [] -> failwith "Empty env stack"
    | hd1::tl1 ->
        let refs = FStar_Util.smap_copy hd1.cache in
        let top =
          let uu___130_26934 = hd1 in
          {
            bindings = (uu___130_26934.bindings);
            depth = (uu___130_26934.depth);
            tcenv = (uu___130_26934.tcenv);
            warn = (uu___130_26934.warn);
            cache = refs;
            nolabels = (uu___130_26934.nolabels);
            use_zfuel_name = (uu___130_26934.use_zfuel_name);
            encode_non_total_function_typ =
              (uu___130_26934.encode_non_total_function_typ);
            current_module_name = (uu___130_26934.current_module_name)
          } in
        FStar_ST.op_Colon_Equals last_env (top :: hd1 :: tl1)
let pop_env: Prims.unit -> Prims.unit =
  fun uu____26989  ->
    let uu____26990 = FStar_ST.op_Bang last_env in
    match uu____26990 with
    | [] -> failwith "Popping an empty stack"
    | uu____27045::tl1 -> FStar_ST.op_Colon_Equals last_env tl1
let init: FStar_TypeChecker_Env.env -> Prims.unit =
  fun tcenv  ->
    init_env tcenv;
    FStar_SMTEncoding_Z3.init ();
    FStar_SMTEncoding_Z3.giveZ3 [FStar_SMTEncoding_Term.DefPrelude]
let push: Prims.string -> Prims.unit =
  fun msg  -> push_env (); varops.push (); FStar_SMTEncoding_Z3.push msg
let pop: Prims.string -> Prims.unit =
  fun msg  -> pop_env (); varops.pop (); FStar_SMTEncoding_Z3.pop msg
let open_fact_db_tags: env_t -> FStar_SMTEncoding_Term.fact_db_id Prims.list
  = fun env  -> []
let place_decl_in_fact_dbs:
  env_t ->
    FStar_SMTEncoding_Term.fact_db_id Prims.list ->
      FStar_SMTEncoding_Term.decl -> FStar_SMTEncoding_Term.decl
  =
  fun env  ->
    fun fact_db_ids  ->
      fun d  ->
        match (fact_db_ids, d) with
        | (uu____27138::uu____27139,FStar_SMTEncoding_Term.Assume a) ->
            FStar_SMTEncoding_Term.Assume
              (let uu___131_27147 = a in
               {
                 FStar_SMTEncoding_Term.assumption_term =
                   (uu___131_27147.FStar_SMTEncoding_Term.assumption_term);
                 FStar_SMTEncoding_Term.assumption_caption =
                   (uu___131_27147.FStar_SMTEncoding_Term.assumption_caption);
                 FStar_SMTEncoding_Term.assumption_name =
                   (uu___131_27147.FStar_SMTEncoding_Term.assumption_name);
                 FStar_SMTEncoding_Term.assumption_fact_ids = fact_db_ids
               })
        | uu____27148 -> d
let fact_dbs_for_lid:
  env_t -> FStar_Ident.lid -> FStar_SMTEncoding_Term.fact_db_id Prims.list =
  fun env  ->
    fun lid  ->
      let uu____27163 =
        let uu____27166 =
          let uu____27167 = FStar_Ident.lid_of_ids lid.FStar_Ident.ns in
          FStar_SMTEncoding_Term.Namespace uu____27167 in
        let uu____27168 = open_fact_db_tags env in uu____27166 :: uu____27168 in
      (FStar_SMTEncoding_Term.Name lid) :: uu____27163
let encode_top_level_facts:
  env_t ->
    FStar_Syntax_Syntax.sigelt ->
      (FStar_SMTEncoding_Term.decl Prims.list,env_t)
        FStar_Pervasives_Native.tuple2
  =
  fun env  ->
    fun se  ->
      let fact_db_ids =
        FStar_All.pipe_right (FStar_Syntax_Util.lids_of_sigelt se)
          (FStar_List.collect (fact_dbs_for_lid env)) in
      let uu____27190 = encode_sigelt env se in
      match uu____27190 with
      | (g,env1) ->
          let g1 =
            FStar_All.pipe_right g
              (FStar_List.map (place_decl_in_fact_dbs env1 fact_db_ids)) in
          (g1, env1)
let encode_sig:
  FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.sigelt -> Prims.unit =
  fun tcenv  ->
    fun se  ->
      let caption decls =
        let uu____27226 = FStar_Options.log_queries () in
        if uu____27226
        then
          let uu____27229 =
            let uu____27230 =
              let uu____27231 =
                let uu____27232 =
                  FStar_All.pipe_right (FStar_Syntax_Util.lids_of_sigelt se)
                    (FStar_List.map FStar_Syntax_Print.lid_to_string) in
                FStar_All.pipe_right uu____27232 (FStar_String.concat ", ") in
              Prims.strcat "encoding sigelt " uu____27231 in
            FStar_SMTEncoding_Term.Caption uu____27230 in
          uu____27229 :: decls
        else decls in
      (let uu____27243 = FStar_TypeChecker_Env.debug tcenv FStar_Options.Low in
       if uu____27243
       then
         let uu____27244 = FStar_Syntax_Print.sigelt_to_string se in
         FStar_Util.print1 "+++++++++++Encoding sigelt %s\n" uu____27244
       else ());
      (let env =
         let uu____27247 = FStar_TypeChecker_Env.current_module tcenv in
         get_env uu____27247 tcenv in
       let uu____27248 = encode_top_level_facts env se in
       match uu____27248 with
       | (decls,env1) ->
           (set_env env1;
            (let uu____27262 = caption decls in
             FStar_SMTEncoding_Z3.giveZ3 uu____27262)))
let encode_modul:
  FStar_TypeChecker_Env.env -> FStar_Syntax_Syntax.modul -> Prims.unit =
  fun tcenv  ->
    fun modul  ->
      let name =
        FStar_Util.format2 "%s %s"
          (if modul.FStar_Syntax_Syntax.is_interface
           then "interface"
           else "module") (modul.FStar_Syntax_Syntax.name).FStar_Ident.str in
      (let uu____27274 = FStar_TypeChecker_Env.debug tcenv FStar_Options.Low in
       if uu____27274
       then
         let uu____27275 =
           FStar_All.pipe_right
             (FStar_List.length modul.FStar_Syntax_Syntax.exports)
             Prims.string_of_int in
         FStar_Util.print2
           "+++++++++++Encoding externals for %s ... %s exports\n" name
           uu____27275
       else ());
      (let env = get_env modul.FStar_Syntax_Syntax.name tcenv in
       let encode_signature env1 ses =
         FStar_All.pipe_right ses
           (FStar_List.fold_left
              (fun uu____27310  ->
                 fun se  ->
                   match uu____27310 with
                   | (g,env2) ->
                       let uu____27330 = encode_top_level_facts env2 se in
                       (match uu____27330 with
                        | (g',env3) -> ((FStar_List.append g g'), env3)))
              ([], env1)) in
       let uu____27353 =
         encode_signature
           (let uu___132_27362 = env in
            {
              bindings = (uu___132_27362.bindings);
              depth = (uu___132_27362.depth);
              tcenv = (uu___132_27362.tcenv);
              warn = false;
              cache = (uu___132_27362.cache);
              nolabels = (uu___132_27362.nolabels);
              use_zfuel_name = (uu___132_27362.use_zfuel_name);
              encode_non_total_function_typ =
                (uu___132_27362.encode_non_total_function_typ);
              current_module_name = (uu___132_27362.current_module_name)
            }) modul.FStar_Syntax_Syntax.exports in
       match uu____27353 with
       | (decls,env1) ->
           let caption decls1 =
             let uu____27379 = FStar_Options.log_queries () in
             if uu____27379
             then
               let msg = Prims.strcat "Externals for " name in
               FStar_List.append ((FStar_SMTEncoding_Term.Caption msg) ::
                 decls1)
                 [FStar_SMTEncoding_Term.Caption (Prims.strcat "End " msg)]
             else decls1 in
           (set_env
              (let uu___133_27387 = env1 in
               {
                 bindings = (uu___133_27387.bindings);
                 depth = (uu___133_27387.depth);
                 tcenv = (uu___133_27387.tcenv);
                 warn = true;
                 cache = (uu___133_27387.cache);
                 nolabels = (uu___133_27387.nolabels);
                 use_zfuel_name = (uu___133_27387.use_zfuel_name);
                 encode_non_total_function_typ =
                   (uu___133_27387.encode_non_total_function_typ);
                 current_module_name = (uu___133_27387.current_module_name)
               });
            (let uu____27389 =
               FStar_TypeChecker_Env.debug tcenv FStar_Options.Low in
             if uu____27389
             then FStar_Util.print1 "Done encoding externals for %s\n" name
             else ());
            (let decls1 = caption decls in FStar_SMTEncoding_Z3.giveZ3 decls1)))
let encode_query:
  (Prims.unit -> Prims.string) FStar_Pervasives_Native.option ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.term ->
        (FStar_SMTEncoding_Term.decl Prims.list,FStar_SMTEncoding_ErrorReporting.label
                                                  Prims.list,FStar_SMTEncoding_Term.decl,
          FStar_SMTEncoding_Term.decl Prims.list)
          FStar_Pervasives_Native.tuple4
  =
  fun use_env_msg  ->
    fun tcenv  ->
      fun q  ->
        (let uu____27441 =
           let uu____27442 = FStar_TypeChecker_Env.current_module tcenv in
           uu____27442.FStar_Ident.str in
         FStar_SMTEncoding_Z3.query_logging.FStar_SMTEncoding_Z3.set_module_name
           uu____27441);
        (let env =
           let uu____27444 = FStar_TypeChecker_Env.current_module tcenv in
           get_env uu____27444 tcenv in
         let bindings =
           FStar_TypeChecker_Env.fold_env tcenv
             (fun bs  -> fun b  -> b :: bs) [] in
         let uu____27456 =
           let rec aux bindings1 =
             match bindings1 with
             | (FStar_TypeChecker_Env.Binding_var x)::rest ->
                 let uu____27491 = aux rest in
                 (match uu____27491 with
                  | (out,rest1) ->
                      let t =
                        let uu____27521 =
                          FStar_Syntax_Util.destruct_typ_as_formula
                            x.FStar_Syntax_Syntax.sort in
                        match uu____27521 with
                        | FStar_Pervasives_Native.Some uu____27526 ->
                            let uu____27527 =
                              FStar_Syntax_Syntax.new_bv
                                FStar_Pervasives_Native.None
                                FStar_Syntax_Syntax.t_unit in
                            FStar_Syntax_Util.refine uu____27527
                              x.FStar_Syntax_Syntax.sort
                        | uu____27528 -> x.FStar_Syntax_Syntax.sort in
                      let t1 =
                        FStar_TypeChecker_Normalize.normalize
                          [FStar_TypeChecker_Normalize.Eager_unfolding;
                          FStar_TypeChecker_Normalize.Beta;
                          FStar_TypeChecker_Normalize.Simplify;
                          FStar_TypeChecker_Normalize.Primops;
                          FStar_TypeChecker_Normalize.EraseUniverses]
                          env.tcenv t in
                      let uu____27532 =
                        let uu____27535 =
                          FStar_Syntax_Syntax.mk_binder
                            (let uu___134_27538 = x in
                             {
                               FStar_Syntax_Syntax.ppname =
                                 (uu___134_27538.FStar_Syntax_Syntax.ppname);
                               FStar_Syntax_Syntax.index =
                                 (uu___134_27538.FStar_Syntax_Syntax.index);
                               FStar_Syntax_Syntax.sort = t1
                             }) in
                        uu____27535 :: out in
                      (uu____27532, rest1))
             | uu____27543 -> ([], bindings1) in
           let uu____27550 = aux bindings in
           match uu____27550 with
           | (closing,bindings1) ->
               let uu____27575 =
                 FStar_Syntax_Util.close_forall_no_univs
                   (FStar_List.rev closing) q in
               (uu____27575, bindings1) in
         match uu____27456 with
         | (q1,bindings1) ->
             let uu____27598 =
               let uu____27603 =
                 FStar_List.filter
                   (fun uu___99_27608  ->
                      match uu___99_27608 with
                      | FStar_TypeChecker_Env.Binding_sig uu____27609 ->
                          false
                      | uu____27616 -> true) bindings1 in
               encode_env_bindings env uu____27603 in
             (match uu____27598 with
              | (env_decls,env1) ->
                  ((let uu____27634 =
                      ((FStar_TypeChecker_Env.debug tcenv FStar_Options.Low)
                         ||
                         (FStar_All.pipe_left
                            (FStar_TypeChecker_Env.debug tcenv)
                            (FStar_Options.Other "SMTEncoding")))
                        ||
                        (FStar_All.pipe_left
                           (FStar_TypeChecker_Env.debug tcenv)
                           (FStar_Options.Other "SMTQuery")) in
                    if uu____27634
                    then
                      let uu____27635 = FStar_Syntax_Print.term_to_string q1 in
                      FStar_Util.print1 "Encoding query formula: %s\n"
                        uu____27635
                    else ());
                   (let uu____27637 = encode_formula q1 env1 in
                    match uu____27637 with
                    | (phi,qdecls) ->
                        let uu____27658 =
                          let uu____27663 =
                            FStar_TypeChecker_Env.get_range tcenv in
                          FStar_SMTEncoding_ErrorReporting.label_goals
                            use_env_msg uu____27663 phi in
                        (match uu____27658 with
                         | (labels,phi1) ->
                             let uu____27680 = encode_labels labels in
                             (match uu____27680 with
                              | (label_prefix,label_suffix) ->
                                  let query_prelude =
                                    FStar_List.append env_decls
                                      (FStar_List.append label_prefix qdecls) in
                                  let qry =
                                    let uu____27717 =
                                      let uu____27724 =
                                        FStar_SMTEncoding_Util.mkNot phi1 in
                                      let uu____27725 =
                                        varops.mk_unique "@query" in
                                      (uu____27724,
                                        (FStar_Pervasives_Native.Some "query"),
                                        uu____27725) in
                                    FStar_SMTEncoding_Util.mkAssume
                                      uu____27717 in
                                  let suffix =
                                    FStar_List.append
                                      [FStar_SMTEncoding_Term.Echo "<labels>"]
                                      (FStar_List.append label_suffix
                                         [FStar_SMTEncoding_Term.Echo
                                            "</labels>";
                                         FStar_SMTEncoding_Term.Echo "Done!"]) in
                                  (query_prelude, labels, qry, suffix)))))))