
open Prims

let gen_wps_for_free = (fun env binders a wp_a tc_decl tc_term ed -> (

let normalize = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.UnfoldUntil (FStar_Syntax_Syntax.Delta_constant))::[]))
in (

let d = (fun s -> (FStar_Util.print1 "\\x1b[01;36m%s\\x1b[00m\n" s))
in (

let _57_17 = (d "Elaborating extra WP combinators")
in (

let _57_19 = (let _149_24 = (FStar_Syntax_Print.term_to_string wp_a)
in (FStar_Util.print1 "wp_a is: %s\n" _149_24))
in (

let check = (fun env str t -> if (FStar_TypeChecker_Env.debug env (FStar_Options.Other ("ED"))) then begin
(

let _57_25 = (d str)
in (

let _57_27 = (let _149_31 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print2 "Generated term for %s: %s\n" str _149_31))
in (

let _57_40 = (tc_term env t)
in (match (_57_40) with
| (t, {FStar_Syntax_Syntax.eff_name = _57_36; FStar_Syntax_Syntax.res_typ = res_typ; FStar_Syntax_Syntax.cflags = _57_33; FStar_Syntax_Syntax.comp = _57_31}, _57_39) -> begin
(

let res_typ = (normalize env res_typ)
in (let _149_33 = (FStar_Syntax_Print.term_to_string res_typ)
in (FStar_Util.print2 "Inferred type for %s: %s\n" str _149_33)))
end))))
end else begin
()
end)
in (

let rec collect_binders = (fun t -> (match ((let _149_36 = (FStar_Syntax_Subst.compress t)
in _149_36.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (bs, comp) -> begin
(

let rest = (match (comp.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t) -> begin
t
end
| _57_51 -> begin
(FStar_All.failwith "wp_a contains non-Tot arrow")
end)
in (let _149_37 = (collect_binders rest)
in (FStar_List.append bs _149_37)))
end
| FStar_Syntax_Syntax.Tm_type (_57_54) -> begin
[]
end
| _57_57 -> begin
(FStar_All.failwith "wp_a doesn\'t end in Type0")
end))
in (

let mk_lid = (fun name -> (FStar_Ident.lid_of_path (FStar_Ident.path_of_text (Prims.strcat (Prims.strcat (FStar_Ident.text_of_lid ed.FStar_Syntax_Syntax.mname) "_") name)) FStar_Range.dummyRange))
in (

let gamma = (let _149_40 = (normalize env wp_a)
in (collect_binders _149_40))
in (

let unknown = (FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown None FStar_Range.dummyRange)
in (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None FStar_Range.dummyRange))
in (

let register = (fun env lident def -> (

let _57_68 = (d (FStar_Ident.text_of_lid lident))
in (

let _57_70 = (let _149_49 = (FStar_Syntax_Print.term_to_string def)
in (FStar_Util.print2 "Registering top-level definition: %s\n%s\n" (FStar_Ident.text_of_lid lident) _149_49))
in (

let fv = (let _149_50 = (FStar_Syntax_Util.incr_delta_qualifier def)
in (FStar_Syntax_Syntax.lid_as_fv lident _149_50 None))
in (

let lbname = FStar_Util.Inr (fv)
in (

let _57_78 = (tc_term env def)
in (match (_57_78) with
| (def, comp, _57_77) -> begin
(

let comp = (comp.FStar_Syntax_Syntax.comp ())
in (

let _57_82 = (FStar_TypeChecker_Util.generalize_universes env def)
in (match (_57_82) with
| (univ_vars, def) -> begin
(

let lb = (let _149_52 = (let _149_51 = (FStar_Syntax_Util.close_univs_and_mk_letbinding None lbname univ_vars unknown (FStar_Syntax_Util.comp_effect_name comp) def)
in (_149_51)::[])
in ((false), (_149_52)))
in (

let sig_ctx = FStar_Syntax_Syntax.Sig_let (((lb), (FStar_Range.dummyRange), ((lident)::[]), ([])))
in (

let _57_87 = (tc_decl env sig_ctx)
in (match (_57_87) with
| (se, env) -> begin
(

let _57_112 = (match (se) with
| FStar_Syntax_Syntax.Sig_let ((_57_89, ({FStar_Syntax_Syntax.lbname = _57_98; FStar_Syntax_Syntax.lbunivs = _57_96; FStar_Syntax_Syntax.lbtyp = t; FStar_Syntax_Syntax.lbeff = _57_93; FStar_Syntax_Syntax.lbdef = _57_91})::[]), _57_103, _57_105, _57_107) -> begin
(let _149_53 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print1 "Inferred type: %s\n" _149_53))
end
| _57_111 -> begin
(FStar_All.failwith "nope")
end)
in (let _149_54 = (mk (FStar_Syntax_Syntax.Tm_fvar (fv)))
in ((env), (_149_54))))
end))))
end)))
end)))))))
in (

let binders_of_list = (FStar_List.map (fun _57_116 -> (match (_57_116) with
| (t, b) -> begin
(let _149_57 = (FStar_Syntax_Syntax.as_implicit b)
in ((t), (_149_57)))
end)))
in (

let mk_all_implicit = (FStar_List.map (fun t -> (let _149_60 = (FStar_Syntax_Syntax.as_implicit true)
in (((Prims.fst t)), (_149_60)))))
in (

let args_of_binders = (FStar_List.map (fun bv -> (let _149_63 = (FStar_Syntax_Syntax.bv_to_name (Prims.fst bv))
in (FStar_Syntax_Syntax.as_arg _149_63))))
in (

let _57_147 = (

let _57_128 = (

let mk = (fun f -> (

let t = (FStar_Syntax_Syntax.gen_bv "t" None FStar_Syntax_Util.ktype0)
in (

let body = (let _149_76 = (let _149_75 = (FStar_Syntax_Syntax.bv_to_name t)
in (f _149_75))
in (FStar_Syntax_Util.arrow gamma _149_76))
in (let _149_81 = (let _149_80 = (let _149_79 = (FStar_Syntax_Syntax.mk_binder a)
in (let _149_78 = (let _149_77 = (FStar_Syntax_Syntax.mk_binder t)
in (_149_77)::[])
in (_149_79)::_149_78))
in (FStar_List.append binders _149_80))
in (FStar_Syntax_Util.abs _149_81 body None)))))
in (let _149_83 = (mk FStar_Syntax_Syntax.mk_Total)
in (let _149_82 = (mk FStar_Syntax_Syntax.mk_GTotal)
in ((_149_83), (_149_82)))))
in (match (_57_128) with
| (ctx_def, gctx_def) -> begin
(

let ctx_lid = (mk_lid "ctx")
in (

let _57_132 = (register env ctx_lid ctx_def)
in (match (_57_132) with
| (env, ctx_fv) -> begin
(

let gctx_lid = (mk_lid "gctx")
in (

let _57_136 = (register env gctx_lid gctx_def)
in (match (_57_136) with
| (env, gctx_fv) -> begin
(

let mk_app = (fun fv t -> (let _149_113 = (let _149_112 = (let _149_111 = (let _149_110 = (FStar_List.map (fun _57_143 -> (match (_57_143) with
| (bv, _57_142) -> begin
(let _149_102 = (FStar_Syntax_Syntax.bv_to_name bv)
in (let _149_101 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_102), (_149_101))))
end)) binders)
in (let _149_109 = (let _149_108 = (let _149_104 = (FStar_Syntax_Syntax.bv_to_name a)
in (let _149_103 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_104), (_149_103))))
in (let _149_107 = (let _149_106 = (let _149_105 = (FStar_Syntax_Syntax.as_implicit false)
in ((t), (_149_105)))
in (_149_106)::[])
in (_149_108)::_149_107))
in (FStar_List.append _149_110 _149_109)))
in ((fv), (_149_111)))
in FStar_Syntax_Syntax.Tm_app (_149_112))
in (mk _149_113)))
in ((env), ((mk_app ctx_fv)), ((mk_app gctx_fv))))
end)))
end)))
end))
in (match (_57_147) with
| (env, mk_ctx, mk_gctx) -> begin
(

let c_pure = (

let t = (FStar_Syntax_Syntax.gen_bv "t" None FStar_Syntax_Util.ktype0)
in (

let x = (let _149_118 = (FStar_Syntax_Syntax.bv_to_name t)
in (FStar_Syntax_Syntax.gen_bv "x" None _149_118))
in (

let ret = (let _149_123 = (let _149_122 = (let _149_121 = (let _149_120 = (let _149_119 = (FStar_Syntax_Syntax.bv_to_name t)
in (mk_ctx _149_119))
in (FStar_Syntax_Syntax.mk_Total _149_120))
in (FStar_Syntax_Util.lcomp_of_comp _149_121))
in FStar_Util.Inl (_149_122))
in Some (_149_123))
in (

let body = (let _149_124 = (FStar_Syntax_Syntax.bv_to_name x)
in (FStar_Syntax_Util.abs gamma _149_124 ret))
in (let _149_127 = (let _149_126 = (mk_all_implicit binders)
in (let _149_125 = (binders_of_list ((((a), (true)))::(((t), (true)))::(((x), (false)))::[]))
in (FStar_List.append _149_126 _149_125)))
in (FStar_Syntax_Util.abs _149_127 body ret))))))
in (

let _57_155 = (let _149_128 = (mk_lid "pure")
in (register env _149_128 c_pure))
in (match (_57_155) with
| (env, c_pure) -> begin
(

let c_app = (

let t1 = (FStar_Syntax_Syntax.gen_bv "t1" None FStar_Syntax_Util.ktype0)
in (

let t2 = (FStar_Syntax_Syntax.gen_bv "t2" None FStar_Syntax_Util.ktype0)
in (

let l = (let _149_136 = (let _149_135 = (let _149_134 = (let _149_131 = (let _149_130 = (let _149_129 = (FStar_Syntax_Syntax.bv_to_name t1)
in (FStar_Syntax_Syntax.new_bv None _149_129))
in (FStar_Syntax_Syntax.mk_binder _149_130))
in (_149_131)::[])
in (let _149_133 = (let _149_132 = (FStar_Syntax_Syntax.bv_to_name t2)
in (FStar_Syntax_Syntax.mk_GTotal _149_132))
in (FStar_Syntax_Util.arrow _149_134 _149_133)))
in (mk_gctx _149_135))
in (FStar_Syntax_Syntax.gen_bv "l" None _149_136))
in (

let r = (let _149_138 = (let _149_137 = (FStar_Syntax_Syntax.bv_to_name t1)
in (mk_gctx _149_137))
in (FStar_Syntax_Syntax.gen_bv "r" None _149_138))
in (

let ret = (let _149_143 = (let _149_142 = (let _149_141 = (let _149_140 = (let _149_139 = (FStar_Syntax_Syntax.bv_to_name t2)
in (mk_gctx _149_139))
in (FStar_Syntax_Syntax.mk_Total _149_140))
in (FStar_Syntax_Util.lcomp_of_comp _149_141))
in FStar_Util.Inl (_149_142))
in Some (_149_143))
in (

let outer_body = (

let gamma_as_args = (args_of_binders gamma)
in (

let inner_body = (let _149_149 = (FStar_Syntax_Syntax.bv_to_name l)
in (let _149_148 = (let _149_147 = (let _149_146 = (let _149_145 = (let _149_144 = (FStar_Syntax_Syntax.bv_to_name r)
in (FStar_Syntax_Util.mk_app _149_144 gamma_as_args))
in (FStar_Syntax_Syntax.as_arg _149_145))
in (_149_146)::[])
in (FStar_List.append gamma_as_args _149_147))
in (FStar_Syntax_Util.mk_app _149_149 _149_148)))
in (FStar_Syntax_Util.abs gamma inner_body ret)))
in (let _149_152 = (let _149_151 = (mk_all_implicit binders)
in (let _149_150 = (binders_of_list ((((a), (true)))::(((t1), (true)))::(((t2), (true)))::(((l), (false)))::(((r), (false)))::[]))
in (FStar_List.append _149_151 _149_150)))
in (FStar_Syntax_Util.abs _149_152 outer_body ret))))))))
in (

let _57_167 = (let _149_153 = (mk_lid "app")
in (register env _149_153 c_app))
in (match (_57_167) with
| (env, c_app) -> begin
(

let c_lift1 = (

let t1 = (FStar_Syntax_Syntax.gen_bv "t1" None FStar_Syntax_Util.ktype0)
in (

let t2 = (FStar_Syntax_Syntax.gen_bv "t2" None FStar_Syntax_Util.ktype0)
in (

let t_f = (let _149_158 = (let _149_155 = (let _149_154 = (FStar_Syntax_Syntax.bv_to_name t1)
in (FStar_Syntax_Syntax.null_binder _149_154))
in (_149_155)::[])
in (let _149_157 = (let _149_156 = (FStar_Syntax_Syntax.bv_to_name t2)
in (FStar_Syntax_Syntax.mk_GTotal _149_156))
in (FStar_Syntax_Util.arrow _149_158 _149_157)))
in (

let f = (FStar_Syntax_Syntax.gen_bv "f" None t_f)
in (

let a1 = (let _149_160 = (let _149_159 = (FStar_Syntax_Syntax.bv_to_name t1)
in (mk_gctx _149_159))
in (FStar_Syntax_Syntax.gen_bv "a1" None _149_160))
in (

let ret = (let _149_165 = (let _149_164 = (let _149_163 = (let _149_162 = (let _149_161 = (FStar_Syntax_Syntax.bv_to_name t2)
in (mk_gctx _149_161))
in (FStar_Syntax_Syntax.mk_Total _149_162))
in (FStar_Syntax_Util.lcomp_of_comp _149_163))
in FStar_Util.Inl (_149_164))
in Some (_149_165))
in (let _149_177 = (let _149_167 = (mk_all_implicit binders)
in (let _149_166 = (binders_of_list ((((a), (true)))::(((t1), (true)))::(((t2), (true)))::(((f), (false)))::(((a1), (false)))::[]))
in (FStar_List.append _149_167 _149_166)))
in (let _149_176 = (let _149_175 = (let _149_174 = (let _149_173 = (let _149_170 = (let _149_169 = (let _149_168 = (FStar_Syntax_Syntax.bv_to_name f)
in (_149_168)::[])
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_169))
in (FStar_Syntax_Util.mk_app c_pure _149_170))
in (let _149_172 = (let _149_171 = (FStar_Syntax_Syntax.bv_to_name a1)
in (_149_171)::[])
in (_149_173)::_149_172))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_174))
in (FStar_Syntax_Util.mk_app c_app _149_175))
in (FStar_Syntax_Util.abs _149_177 _149_176 ret)))))))))
in (

let _57_177 = (let _149_178 = (mk_lid "lift1")
in (register env _149_178 c_lift1))
in (match (_57_177) with
| (env, c_lift1) -> begin
(

let c_lift2 = (

let t1 = (FStar_Syntax_Syntax.gen_bv "t1" None FStar_Syntax_Util.ktype0)
in (

let t2 = (FStar_Syntax_Syntax.gen_bv "t2" None FStar_Syntax_Util.ktype0)
in (

let t3 = (FStar_Syntax_Syntax.gen_bv "t3" None FStar_Syntax_Util.ktype0)
in (

let t_f = (let _149_186 = (let _149_183 = (let _149_179 = (FStar_Syntax_Syntax.bv_to_name t1)
in (FStar_Syntax_Syntax.null_binder _149_179))
in (let _149_182 = (let _149_181 = (let _149_180 = (FStar_Syntax_Syntax.bv_to_name t2)
in (FStar_Syntax_Syntax.null_binder _149_180))
in (_149_181)::[])
in (_149_183)::_149_182))
in (let _149_185 = (let _149_184 = (FStar_Syntax_Syntax.bv_to_name t3)
in (FStar_Syntax_Syntax.mk_GTotal _149_184))
in (FStar_Syntax_Util.arrow _149_186 _149_185)))
in (

let f = (FStar_Syntax_Syntax.gen_bv "f" None t_f)
in (

let a1 = (let _149_188 = (let _149_187 = (FStar_Syntax_Syntax.bv_to_name t1)
in (mk_gctx _149_187))
in (FStar_Syntax_Syntax.gen_bv "a1" None _149_188))
in (

let a2 = (let _149_190 = (let _149_189 = (FStar_Syntax_Syntax.bv_to_name t2)
in (mk_gctx _149_189))
in (FStar_Syntax_Syntax.gen_bv "a2" None _149_190))
in (

let ret = (let _149_195 = (let _149_194 = (let _149_193 = (let _149_192 = (let _149_191 = (FStar_Syntax_Syntax.bv_to_name t3)
in (mk_gctx _149_191))
in (FStar_Syntax_Syntax.mk_Total _149_192))
in (FStar_Syntax_Util.lcomp_of_comp _149_193))
in FStar_Util.Inl (_149_194))
in Some (_149_195))
in (let _149_211 = (let _149_196 = (binders_of_list ((((a), (true)))::(((t1), (true)))::(((t2), (true)))::(((t3), (true)))::(((f), (false)))::(((a1), (false)))::(((a2), (false)))::[]))
in (FStar_List.append binders _149_196))
in (let _149_210 = (let _149_209 = (let _149_208 = (let _149_207 = (let _149_204 = (let _149_203 = (let _149_202 = (let _149_199 = (let _149_198 = (let _149_197 = (FStar_Syntax_Syntax.bv_to_name f)
in (_149_197)::[])
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_198))
in (FStar_Syntax_Util.mk_app c_pure _149_199))
in (let _149_201 = (let _149_200 = (FStar_Syntax_Syntax.bv_to_name a1)
in (_149_200)::[])
in (_149_202)::_149_201))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_203))
in (FStar_Syntax_Util.mk_app c_app _149_204))
in (let _149_206 = (let _149_205 = (FStar_Syntax_Syntax.bv_to_name a2)
in (_149_205)::[])
in (_149_207)::_149_206))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_208))
in (FStar_Syntax_Util.mk_app c_app _149_209))
in (FStar_Syntax_Util.abs _149_211 _149_210 ret)))))))))))
in (

let _57_189 = (let _149_212 = (mk_lid "lift2")
in (register env _149_212 c_lift2))
in (match (_57_189) with
| (env, c_lift2) -> begin
(

let c_push = (

let t1 = (FStar_Syntax_Syntax.gen_bv "t1" None FStar_Syntax_Util.ktype0)
in (

let t2 = (FStar_Syntax_Syntax.gen_bv "t2" None FStar_Syntax_Util.ktype0)
in (

let t_f = (let _149_218 = (let _149_214 = (let _149_213 = (FStar_Syntax_Syntax.bv_to_name t1)
in (FStar_Syntax_Syntax.null_binder _149_213))
in (_149_214)::[])
in (let _149_217 = (let _149_216 = (let _149_215 = (FStar_Syntax_Syntax.bv_to_name t2)
in (mk_gctx _149_215))
in (FStar_Syntax_Syntax.mk_Total _149_216))
in (FStar_Syntax_Util.arrow _149_218 _149_217)))
in (

let f = (FStar_Syntax_Syntax.gen_bv "f" None t_f)
in (

let ret = (let _149_228 = (let _149_227 = (let _149_226 = (let _149_225 = (let _149_224 = (let _149_223 = (let _149_220 = (let _149_219 = (FStar_Syntax_Syntax.bv_to_name t1)
in (FStar_Syntax_Syntax.null_binder _149_219))
in (_149_220)::[])
in (let _149_222 = (let _149_221 = (FStar_Syntax_Syntax.bv_to_name t2)
in (FStar_Syntax_Syntax.mk_GTotal _149_221))
in (FStar_Syntax_Util.arrow _149_223 _149_222)))
in (mk_ctx _149_224))
in (FStar_Syntax_Syntax.mk_Total _149_225))
in (FStar_Syntax_Util.lcomp_of_comp _149_226))
in FStar_Util.Inl (_149_227))
in Some (_149_228))
in (

let e1 = (let _149_229 = (FStar_Syntax_Syntax.bv_to_name t1)
in (FStar_Syntax_Syntax.gen_bv "e1" None _149_229))
in (

let body = (let _149_238 = (let _149_231 = (let _149_230 = (FStar_Syntax_Syntax.mk_binder e1)
in (_149_230)::[])
in (FStar_List.append gamma _149_231))
in (let _149_237 = (let _149_236 = (FStar_Syntax_Syntax.bv_to_name f)
in (let _149_235 = (let _149_234 = (let _149_232 = (FStar_Syntax_Syntax.bv_to_name e1)
in (FStar_Syntax_Syntax.as_arg _149_232))
in (let _149_233 = (args_of_binders gamma)
in (_149_234)::_149_233))
in (FStar_Syntax_Util.mk_app _149_236 _149_235)))
in (FStar_Syntax_Util.abs _149_238 _149_237 ret)))
in (let _149_241 = (let _149_240 = (mk_all_implicit binders)
in (let _149_239 = (binders_of_list ((((a), (true)))::(((t1), (true)))::(((t2), (true)))::(((f), (false)))::[]))
in (FStar_List.append _149_240 _149_239)))
in (FStar_Syntax_Util.abs _149_241 body ret)))))))))
in (

let _57_200 = (let _149_242 = (mk_lid "push")
in (register env _149_242 c_push))
in (match (_57_200) with
| (env, c_push) -> begin
(

let ret_tot_wp_a = (let _149_245 = (let _149_244 = (let _149_243 = (FStar_Syntax_Syntax.mk_Total wp_a)
in (FStar_Syntax_Util.lcomp_of_comp _149_243))
in FStar_Util.Inl (_149_244))
in Some (_149_245))
in (

let wp_if_then_else = (

let c = (FStar_Syntax_Syntax.gen_bv "c" None FStar_Syntax_Util.ktype0)
in (let _149_254 = (let _149_246 = (FStar_Syntax_Syntax.binders_of_list ((a)::(c)::[]))
in (FStar_List.append binders _149_246))
in (let _149_253 = (

let l_ite = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.ite_lid (FStar_Syntax_Syntax.Delta_unfoldable (2)) None)
in (let _149_252 = (let _149_251 = (let _149_250 = (let _149_249 = (let _149_248 = (let _149_247 = (FStar_Syntax_Syntax.bv_to_name c)
in (FStar_Syntax_Syntax.as_arg _149_247))
in (_149_248)::[])
in (FStar_Syntax_Util.mk_app l_ite _149_249))
in (_149_250)::[])
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_251))
in (FStar_Syntax_Util.mk_app c_lift2 _149_252)))
in (FStar_Syntax_Util.abs _149_254 _149_253 ret_tot_wp_a))))
in (

let _57_205 = (let _149_255 = (FStar_Syntax_Util.abs binders wp_if_then_else None)
in (check env "wp_if_then_else" _149_255))
in (

let wp_assert = (

let q = (FStar_Syntax_Syntax.gen_bv "q" None FStar_Syntax_Util.ktype0)
in (

let wp = (FStar_Syntax_Syntax.gen_bv "wp" None wp_a)
in (

let l_and = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.and_lid (FStar_Syntax_Syntax.Delta_unfoldable (1)) None)
in (

let body = (let _149_266 = (let _149_265 = (let _149_264 = (let _149_261 = (let _149_260 = (let _149_259 = (let _149_258 = (let _149_257 = (let _149_256 = (FStar_Syntax_Syntax.bv_to_name q)
in (FStar_Syntax_Syntax.as_arg _149_256))
in (_149_257)::[])
in (FStar_Syntax_Util.mk_app l_and _149_258))
in (_149_259)::[])
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_260))
in (FStar_Syntax_Util.mk_app c_pure _149_261))
in (let _149_263 = (let _149_262 = (FStar_Syntax_Syntax.bv_to_name wp)
in (_149_262)::[])
in (_149_264)::_149_263))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_265))
in (FStar_Syntax_Util.mk_app c_app _149_266))
in (let _149_267 = (FStar_Syntax_Syntax.binders_of_list ((a)::(q)::(wp)::[]))
in (FStar_Syntax_Util.abs _149_267 body ret_tot_wp_a))))))
in (

let _57_212 = (let _149_268 = (FStar_Syntax_Util.abs binders wp_assert None)
in (check env "wp_assert" _149_268))
in (

let wp_assume = (

let q = (FStar_Syntax_Syntax.gen_bv "q" None FStar_Syntax_Util.ktype0)
in (

let wp = (FStar_Syntax_Syntax.gen_bv "wp" None wp_a)
in (

let l_imp = (FStar_Syntax_Syntax.fvar FStar_Syntax_Const.imp_lid (FStar_Syntax_Syntax.Delta_unfoldable (1)) None)
in (

let body = (let _149_279 = (let _149_278 = (let _149_277 = (let _149_274 = (let _149_273 = (let _149_272 = (let _149_271 = (let _149_270 = (let _149_269 = (FStar_Syntax_Syntax.bv_to_name q)
in (FStar_Syntax_Syntax.as_arg _149_269))
in (_149_270)::[])
in (FStar_Syntax_Util.mk_app l_imp _149_271))
in (_149_272)::[])
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_273))
in (FStar_Syntax_Util.mk_app c_pure _149_274))
in (let _149_276 = (let _149_275 = (FStar_Syntax_Syntax.bv_to_name wp)
in (_149_275)::[])
in (_149_277)::_149_276))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_278))
in (FStar_Syntax_Util.mk_app c_app _149_279))
in (let _149_280 = (FStar_Syntax_Syntax.binders_of_list ((a)::(q)::(wp)::[]))
in (FStar_Syntax_Util.abs _149_280 body ret_tot_wp_a))))))
in (

let _57_219 = (let _149_281 = (FStar_Syntax_Util.abs binders wp_assume None)
in (check env "wp_assume" _149_281))
in (

let wp_close = (

let b = (FStar_Syntax_Syntax.gen_bv "b" None FStar_Syntax_Util.ktype0)
in (

let t_f = (let _149_285 = (let _149_283 = (let _149_282 = (FStar_Syntax_Syntax.bv_to_name b)
in (FStar_Syntax_Syntax.null_binder _149_282))
in (_149_283)::[])
in (let _149_284 = (FStar_Syntax_Syntax.mk_Total wp_a)
in (FStar_Syntax_Util.arrow _149_285 _149_284)))
in (

let f = (FStar_Syntax_Syntax.gen_bv "f" None t_f)
in (

let body = (let _149_294 = (let _149_293 = (let _149_292 = (let _149_286 = (FStar_List.map FStar_Syntax_Syntax.as_arg ((FStar_Syntax_Util.tforall)::[]))
in (FStar_Syntax_Util.mk_app c_pure _149_286))
in (let _149_291 = (let _149_290 = (let _149_289 = (let _149_288 = (let _149_287 = (FStar_Syntax_Syntax.bv_to_name f)
in (_149_287)::[])
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_288))
in (FStar_Syntax_Util.mk_app c_push _149_289))
in (_149_290)::[])
in (_149_292)::_149_291))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_293))
in (FStar_Syntax_Util.mk_app c_app _149_294))
in (let _149_295 = (FStar_Syntax_Syntax.binders_of_list ((a)::(b)::(f)::[]))
in (FStar_Syntax_Util.abs _149_295 body ret_tot_wp_a))))))
in (

let _57_226 = (let _149_296 = (FStar_Syntax_Util.abs binders wp_close None)
in (check env "wp_close" _149_296))
in (

let ret_tot_type0 = (let _149_299 = (let _149_298 = (let _149_297 = (FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0)
in (FStar_All.pipe_left FStar_Syntax_Util.lcomp_of_comp _149_297))
in FStar_Util.Inl (_149_298))
in Some (_149_299))
in (

let mk_forall = (fun x body -> (let _149_310 = (let _149_309 = (let _149_308 = (let _149_307 = (let _149_306 = (let _149_305 = (let _149_304 = (FStar_Syntax_Syntax.mk_binder x)
in (_149_304)::[])
in (FStar_Syntax_Util.abs _149_305 body ret_tot_type0))
in (FStar_Syntax_Syntax.as_arg _149_306))
in (_149_307)::[])
in ((FStar_Syntax_Util.tforall), (_149_308)))
in FStar_Syntax_Syntax.Tm_app (_149_309))
in (FStar_Syntax_Syntax.mk _149_310 None FStar_Range.dummyRange)))
in (

let rec mk_leq = (fun t x y -> (match ((let _149_318 = (let _149_317 = (FStar_Syntax_Subst.compress t)
in (normalize env _149_317))
in _149_318.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_type (_57_237) -> begin
(FStar_Syntax_Util.mk_imp x y)
end
| (FStar_Syntax_Syntax.Tm_arrow ((binder)::[], {FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.GTotal (b); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _})) | (FStar_Syntax_Syntax.Tm_arrow ((binder)::[], {FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Total (b); FStar_Syntax_Syntax.tk = _; FStar_Syntax_Syntax.pos = _; FStar_Syntax_Syntax.vars = _})) when (FStar_Syntax_Syntax.is_null_binder binder) -> begin
(

let a = (Prims.fst binder).FStar_Syntax_Syntax.sort
in (

let a1 = (FStar_Syntax_Syntax.gen_bv "a1" None a)
in (

let a2 = (FStar_Syntax_Syntax.gen_bv "a2" None a)
in (

let body = (let _149_330 = (let _149_320 = (FStar_Syntax_Syntax.bv_to_name a1)
in (let _149_319 = (FStar_Syntax_Syntax.bv_to_name a2)
in (mk_leq a _149_320 _149_319)))
in (let _149_329 = (let _149_328 = (let _149_323 = (let _149_322 = (let _149_321 = (FStar_Syntax_Syntax.bv_to_name a1)
in (FStar_Syntax_Syntax.as_arg _149_321))
in (_149_322)::[])
in (FStar_Syntax_Util.mk_app x _149_323))
in (let _149_327 = (let _149_326 = (let _149_325 = (let _149_324 = (FStar_Syntax_Syntax.bv_to_name a2)
in (FStar_Syntax_Syntax.as_arg _149_324))
in (_149_325)::[])
in (FStar_Syntax_Util.mk_app y _149_326))
in (mk_leq b _149_328 _149_327)))
in (FStar_Syntax_Util.mk_imp _149_330 _149_329)))
in (let _149_331 = (mk_forall a2 body)
in (mk_forall a1 _149_331))))))
end
| FStar_Syntax_Syntax.Tm_arrow ((binder)::binders, comp) -> begin
(

let t = (

let _57_273 = t
in (let _149_335 = (let _149_334 = (let _149_333 = (let _149_332 = (FStar_Syntax_Util.arrow binders comp)
in (FStar_Syntax_Syntax.mk_Total _149_332))
in (((binder)::[]), (_149_333)))
in FStar_Syntax_Syntax.Tm_arrow (_149_334))
in {FStar_Syntax_Syntax.n = _149_335; FStar_Syntax_Syntax.tk = _57_273.FStar_Syntax_Syntax.tk; FStar_Syntax_Syntax.pos = _57_273.FStar_Syntax_Syntax.pos; FStar_Syntax_Syntax.vars = _57_273.FStar_Syntax_Syntax.vars}))
in (mk_leq t x y))
end
| FStar_Syntax_Syntax.Tm_arrow (_57_277) -> begin
(FStar_All.failwith "unhandled arrow")
end
| _57_280 -> begin
(FStar_Syntax_Util.mk_eq t t x y)
end))
in (

let stronger = (

let wp1 = (FStar_Syntax_Syntax.gen_bv "wp1" None wp_a)
in (

let wp2 = (FStar_Syntax_Syntax.gen_bv "wp2" None wp_a)
in (

let body = (let _149_337 = (FStar_Syntax_Syntax.bv_to_name wp1)
in (let _149_336 = (FStar_Syntax_Syntax.bv_to_name wp2)
in (mk_leq wp_a _149_337 _149_336)))
in (let _149_338 = (FStar_Syntax_Syntax.binders_of_list ((wp1)::(wp2)::[]))
in (FStar_Syntax_Util.abs _149_338 body ret_tot_type0)))))
in (

let _57_285 = (let _149_342 = (let _149_341 = (let _149_340 = (let _149_339 = (FStar_Syntax_Syntax.mk_binder a)
in (_149_339)::[])
in (FStar_List.append binders _149_340))
in (FStar_Syntax_Util.abs _149_341 stronger None))
in (check env "stronger" _149_342))
in (

let null_wp = (Prims.snd ed.FStar_Syntax_Syntax.null_wp)
in (

let wp_trivial = (

let wp = (FStar_Syntax_Syntax.gen_bv "wp" None wp_a)
in (

let body = (let _149_350 = (let _149_349 = (let _149_348 = (let _149_345 = (let _149_344 = (let _149_343 = (FStar_Syntax_Syntax.bv_to_name a)
in (FStar_Syntax_Syntax.as_arg _149_343))
in (_149_344)::[])
in (FStar_Syntax_Util.mk_app null_wp _149_345))
in (let _149_347 = (let _149_346 = (FStar_Syntax_Syntax.bv_to_name wp)
in (_149_346)::[])
in (_149_348)::_149_347))
in (FStar_List.map FStar_Syntax_Syntax.as_arg _149_349))
in (FStar_Syntax_Util.mk_app stronger _149_350))
in (let _149_351 = (FStar_Syntax_Syntax.binders_of_list ((a)::(wp)::[]))
in (FStar_Syntax_Util.abs _149_351 body ret_tot_type0))))
in (

let _57_291 = (let _149_352 = (FStar_Syntax_Util.abs binders wp_trivial None)
in (check env "wp_trivial" _149_352))
in (

let _57_293 = (d "End Dijkstra monads for free")
in ((env), ((

let _57_295 = ed
in {FStar_Syntax_Syntax.qualifiers = _57_295.FStar_Syntax_Syntax.qualifiers; FStar_Syntax_Syntax.mname = _57_295.FStar_Syntax_Syntax.mname; FStar_Syntax_Syntax.univs = _57_295.FStar_Syntax_Syntax.univs; FStar_Syntax_Syntax.binders = _57_295.FStar_Syntax_Syntax.binders; FStar_Syntax_Syntax.signature = _57_295.FStar_Syntax_Syntax.signature; FStar_Syntax_Syntax.ret_wp = _57_295.FStar_Syntax_Syntax.ret_wp; FStar_Syntax_Syntax.bind_wp = _57_295.FStar_Syntax_Syntax.bind_wp; FStar_Syntax_Syntax.if_then_else = (([]), (wp_if_then_else)); FStar_Syntax_Syntax.ite_wp = _57_295.FStar_Syntax_Syntax.ite_wp; FStar_Syntax_Syntax.stronger = _57_295.FStar_Syntax_Syntax.stronger; FStar_Syntax_Syntax.close_wp = (([]), (wp_close)); FStar_Syntax_Syntax.assert_p = (([]), (wp_assert)); FStar_Syntax_Syntax.assume_p = (([]), (wp_assume)); FStar_Syntax_Syntax.null_wp = _57_295.FStar_Syntax_Syntax.null_wp; FStar_Syntax_Syntax.trivial = (([]), (wp_trivial)); FStar_Syntax_Syntax.repr = _57_295.FStar_Syntax_Syntax.repr; FStar_Syntax_Syntax.return_repr = _57_295.FStar_Syntax_Syntax.return_repr; FStar_Syntax_Syntax.bind_repr = _57_295.FStar_Syntax_Syntax.bind_repr; FStar_Syntax_Syntax.actions = _57_295.FStar_Syntax_Syntax.actions})))))))))))))))))))))
end)))
end)))
end)))
end)))
end)))
end)))))))))))))))))


type env =
{env : FStar_TypeChecker_Env.env; definitions : (FStar_Ident.lid * FStar_Syntax_Syntax.typ) Prims.list; subst : FStar_Syntax_Syntax.subst_elt Prims.list; tc_const : FStar_Const.sconst  ->  FStar_Syntax_Syntax.typ}


let is_Mkenv : env  ->  Prims.bool = (Obj.magic ((fun _ -> (FStar_All.failwith "Not yet implemented:is_Mkenv"))))


let empty : FStar_TypeChecker_Env.env  ->  (FStar_Const.sconst  ->  FStar_Syntax_Syntax.typ)  ->  env = (fun env tc_const -> {env = env; definitions = []; subst = []; tc_const = tc_const})


type env_ =
env


type nm =
| N of FStar_Syntax_Syntax.typ
| M of FStar_Syntax_Syntax.typ


let is_N = (fun _discr_ -> (match (_discr_) with
| N (_) -> begin
true
end
| _ -> begin
false
end))


let is_M = (fun _discr_ -> (match (_discr_) with
| M (_) -> begin
true
end
| _ -> begin
false
end))


let ___N____0 = (fun projectee -> (match (projectee) with
| N (_57_306) -> begin
_57_306
end))


let ___M____0 = (fun projectee -> (match (projectee) with
| M (_57_309) -> begin
_57_309
end))


type nm_ =
nm


let nm_of_comp : FStar_Syntax_Syntax.comp'  ->  nm = (fun _57_1 -> (match (_57_1) with
| FStar_Syntax_Syntax.Total (t) -> begin
N (t)
end
| FStar_Syntax_Syntax.Comp (c) when (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.effect_name FStar_Syntax_Const.monadic_lid) -> begin
M (c.FStar_Syntax_Syntax.result_typ)
end
| _57_316 -> begin
(FStar_All.failwith "[nm_of_comp]: impossible")
end))


let string_of_nm : nm  ->  Prims.string = (fun _57_2 -> (match (_57_2) with
| N (t) -> begin
(let _149_413 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format1 "N[%s]" _149_413))
end
| M (t) -> begin
(let _149_414 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format1 "M[%s]" _149_414))
end))


let is_monadic_arrow : FStar_Syntax_Syntax.term'  ->  nm = (fun n -> (match (n) with
| FStar_Syntax_Syntax.Tm_arrow (_57_324, {FStar_Syntax_Syntax.n = n; FStar_Syntax_Syntax.tk = _57_330; FStar_Syntax_Syntax.pos = _57_328; FStar_Syntax_Syntax.vars = _57_326}) -> begin
(nm_of_comp n)
end
| _57_336 -> begin
(FStar_All.failwith "unexpected_argument: [is_monadic_arrow]")
end))


let is_monadic_comp = (fun c -> (match ((nm_of_comp c.FStar_Syntax_Syntax.n)) with
| M (_57_339) -> begin
true
end
| N (_57_342) -> begin
false
end))


let rec mk_star_to_type : (FStar_Syntax_Syntax.term'  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax)  ->  env  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax = (fun mk env a -> (let _149_438 = (let _149_437 = (let _149_436 = (let _149_434 = (let _149_433 = (let _149_431 = (star_type env a)
in (FStar_Syntax_Syntax.null_bv _149_431))
in (let _149_432 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_433), (_149_432))))
in (_149_434)::[])
in (let _149_435 = (FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0)
in ((_149_436), (_149_435))))
in FStar_Syntax_Syntax.Tm_arrow (_149_437))
in (mk _149_438)))
and star_type : env  ->  (FStar_Syntax_Syntax.term', FStar_Syntax_Syntax.term') FStar_Syntax_Syntax.syntax  ->  FStar_Syntax_Syntax.term = (fun env t -> (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None t.FStar_Syntax_Syntax.pos))
in (

let mk_star_to_type = (mk_star_to_type mk)
in (

let normalize = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.UnfoldUntil (FStar_Syntax_Syntax.Delta_constant))::[]) env.env)
in (

let t = (normalize t)
in (

let t = (FStar_Syntax_Subst.compress t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_arrow (binders, _57_357) -> begin
(

let binders = (FStar_List.map (fun _57_362 -> (match (_57_362) with
| (bv, aqual) -> begin
(let _149_448 = (

let _57_363 = bv
in (let _149_447 = (star_type env bv.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _57_363.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _57_363.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _149_447}))
in ((_149_448), (aqual)))
end)) binders)
in (match ((is_monadic_arrow t.FStar_Syntax_Syntax.n)) with
| N (hn) -> begin
(let _149_452 = (let _149_451 = (let _149_450 = (let _149_449 = (star_type env hn)
in (FStar_Syntax_Syntax.mk_Total _149_449))
in ((binders), (_149_450)))
in FStar_Syntax_Syntax.Tm_arrow (_149_451))
in (mk _149_452))
end
| M (a) -> begin
(let _149_461 = (let _149_460 = (let _149_459 = (let _149_457 = (let _149_456 = (let _149_455 = (let _149_453 = (mk_star_to_type env a)
in (FStar_Syntax_Syntax.null_bv _149_453))
in (let _149_454 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_455), (_149_454))))
in (_149_456)::[])
in (FStar_List.append binders _149_457))
in (let _149_458 = (FStar_Syntax_Syntax.mk_Total FStar_Syntax_Util.ktype0)
in ((_149_459), (_149_458))))
in FStar_Syntax_Syntax.Tm_arrow (_149_460))
in (mk _149_461))
end))
end
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(

let rec is_valid_application = (fun head -> (match ((let _149_464 = (FStar_Syntax_Subst.compress head)
in _149_464.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar (fv) when (((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.option_lid) || (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Syntax_Const.either_lid)) || (let _149_465 = (FStar_Syntax_Subst.compress head)
in (FStar_Syntax_Util.is_tuple_constructor _149_465))) -> begin
true
end
| FStar_Syntax_Syntax.Tm_uinst (head, _57_380) -> begin
(is_valid_application head)
end
| _57_384 -> begin
false
end))
in if (is_valid_application head) then begin
(let _149_470 = (let _149_469 = (let _149_468 = (FStar_List.map (fun _57_387 -> (match (_57_387) with
| (t, qual) -> begin
(let _149_467 = (star_type env t)
in ((_149_467), (qual)))
end)) args)
in ((head), (_149_468)))
in FStar_Syntax_Syntax.Tm_app (_149_469))
in (mk _149_470))
end else begin
(let _149_473 = (let _149_472 = (let _149_471 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format1 "For now, only [either] and [option] are supported in the definition language (got: %s)" _149_471))
in FStar_Syntax_Syntax.Err (_149_472))
in (Prims.raise _149_473))
end)
end
| (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_name (_)) | (FStar_Syntax_Syntax.Tm_type (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) -> begin
t
end
| FStar_Syntax_Syntax.Tm_abs (binders, repr, something) -> begin
(

let subst = (FStar_Syntax_Subst.opening_of_binders binders)
in (

let repr = (FStar_Syntax_Subst.subst subst repr)
in (

let env = (

let _57_407 = env
in (let _149_474 = (FStar_TypeChecker_Env.push_binders env.env binders)
in {env = _149_474; definitions = _57_407.definitions; subst = _57_407.subst; tc_const = _57_407.tc_const}))
in (

let repr = (star_type env repr)
in (

let repr = (FStar_Syntax_Subst.close binders repr)
in (mk (FStar_Syntax_Syntax.Tm_abs (((binders), (repr), (something))))))))))
end
| (FStar_Syntax_Syntax.Tm_abs (_)) | (FStar_Syntax_Syntax.Tm_uinst (_)) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_refine (_)) | (FStar_Syntax_Syntax.Tm_match (_)) | (FStar_Syntax_Syntax.Tm_ascribed (_)) | (FStar_Syntax_Syntax.Tm_let (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) | (FStar_Syntax_Syntax.Tm_meta (_)) | (FStar_Syntax_Syntax.Tm_unknown) -> begin
(let _149_477 = (let _149_476 = (let _149_475 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format1 "The following term is outside of the definition language: %s" _149_475))
in FStar_Syntax_Syntax.Err (_149_476))
in (Prims.raise _149_477))
end
| FStar_Syntax_Syntax.Tm_delayed (_57_441) -> begin
(FStar_All.failwith "impossible")
end)))))))


let star_definition = (fun env t f -> (match ((let _149_490 = (FStar_Syntax_Subst.compress t)
in _149_490.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = lid; FStar_Syntax_Syntax.fv_delta = _57_449; FStar_Syntax_Syntax.fv_qual = _57_447}) -> begin
(

let _57_453 = (FStar_Util.print1 "Recording definition of %s\n" (FStar_Ident.text_of_lid lid.FStar_Syntax_Syntax.v))
in (

let _57_467 = (match ((let _149_492 = (FStar_TypeChecker_Env.lookup_definition (FStar_TypeChecker_Env.Unfold (FStar_Syntax_Syntax.Delta_constant)) env.env lid.FStar_Syntax_Syntax.v)
in (let _149_491 = (FStar_TypeChecker_Env.lookup_lid env.env lid.FStar_Syntax_Syntax.v)
in ((_149_492), (_149_491))))) with
| (Some ([], e), ([], t)) -> begin
(f env e)
end
| _57_464 -> begin
(Prims.raise (FStar_Syntax_Syntax.Err ("Bad definition in [star_type_definition]")))
end)
in (match (_57_467) with
| (store, ret) -> begin
(((

let _57_468 = env
in {env = _57_468.env; definitions = (((lid.FStar_Syntax_Syntax.v), (store)))::env.definitions; subst = _57_468.subst; tc_const = _57_468.tc_const})), (ret))
end)))
end
| FStar_Syntax_Syntax.Tm_uinst (_57_471) -> begin
(Prims.raise (FStar_Syntax_Syntax.Err ("Ill-formed definition (hint: use Type0, not Type)")))
end
| _57_474 -> begin
(let _149_495 = (let _149_494 = (let _149_493 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.format1 "Ill-formed definition: %s" _149_493))
in FStar_Syntax_Syntax.Err (_149_494))
in (Prims.raise _149_495))
end))


let star_type_definition : env  ->  FStar_Syntax_Syntax.term  ->  (env * FStar_Syntax_Syntax.term) = (fun env t -> (star_definition env t (fun env e -> (

let t = (star_type env e)
in ((t), (t))))))


let is_monadic : (FStar_Syntax_Syntax.lcomp, FStar_Ident.lident) FStar_Util.either Prims.option  ->  Prims.bool = (fun _57_3 -> (match (_57_3) with
| None -> begin
(FStar_All.failwith "un-annotated lambda?!")
end
| (Some (FStar_Util.Inl ({FStar_Syntax_Syntax.eff_name = lid; FStar_Syntax_Syntax.res_typ = _; FStar_Syntax_Syntax.cflags = _; FStar_Syntax_Syntax.comp = _}))) | (Some (FStar_Util.Inr (lid))) -> begin
(FStar_Ident.lid_equals lid FStar_Syntax_Const.monadic_lid)
end))


let rec is_C : FStar_Syntax_Syntax.typ  ->  Prims.bool = (fun t -> (match ((let _149_506 = (FStar_Syntax_Subst.compress t)
in _149_506.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_app (head, args) when (FStar_Syntax_Util.is_tuple_constructor head) -> begin
(

let r = (let _149_508 = (let _149_507 = (FStar_List.hd args)
in (Prims.fst _149_507))
in (is_C _149_508))
in if r then begin
(

let _57_504 = if (not ((FStar_List.for_all (fun _57_503 -> (match (_57_503) with
| (h, _57_502) -> begin
(is_C h)
end)) args))) then begin
(FStar_All.failwith "not a C (A * C)")
end else begin
()
end
in true)
end else begin
(

let _57_510 = if (not ((FStar_List.for_all (fun _57_509 -> (match (_57_509) with
| (h, _57_508) -> begin
(not ((is_C h)))
end)) args))) then begin
(FStar_All.failwith "not a C (C * A)")
end else begin
()
end
in false)
end)
end
| FStar_Syntax_Syntax.Tm_arrow (binders, comp) -> begin
(match ((nm_of_comp comp.FStar_Syntax_Syntax.n)) with
| M (t) -> begin
(

let _57_518 = if (is_C t) then begin
(FStar_All.failwith "not a C (C -> C)")
end else begin
()
end
in true)
end
| N (t) -> begin
(is_C t)
end)
end
| (FStar_Syntax_Syntax.Tm_meta (t, _)) | (FStar_Syntax_Syntax.Tm_uinst (t, _)) | (FStar_Syntax_Syntax.Tm_ascribed (t, _, _)) -> begin
(is_C t)
end
| _57_538 -> begin
false
end))


let mk_return : env  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun env t e -> (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None e.FStar_Syntax_Syntax.pos))
in (

let p_type = (mk_star_to_type mk env t)
in (

let p = (FStar_Syntax_Syntax.gen_bv "p\'" None p_type)
in (

let body = (let _149_524 = (let _149_523 = (let _149_522 = (FStar_Syntax_Syntax.bv_to_name p)
in (let _149_521 = (let _149_520 = (let _149_519 = (FStar_Syntax_Syntax.as_implicit false)
in ((e), (_149_519)))
in (_149_520)::[])
in ((_149_522), (_149_521))))
in FStar_Syntax_Syntax.Tm_app (_149_523))
in (mk _149_524))
in (let _149_526 = (let _149_525 = (FStar_Syntax_Syntax.mk_binder p)
in (_149_525)::[])
in (FStar_Syntax_Util.abs _149_526 body None)))))))


let is_unknown : FStar_Syntax_Syntax.term'  ->  Prims.bool = (fun _57_4 -> (match (_57_4) with
| FStar_Syntax_Syntax.Tm_unknown -> begin
true
end
| _57_550 -> begin
false
end))


let rec check : env  ->  FStar_Syntax_Syntax.term  ->  nm  ->  (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term) = (fun env e context_nm -> (

let _57_554 = (let _149_572 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.print1 "[debug]: check %s\n" _149_572))
in (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None e.FStar_Syntax_Syntax.pos))
in (

let return_if = (fun _57_562 -> (match (_57_562) with
| (rec_nm, s_e, u_e) -> begin
(

let check = (fun t1 t2 -> if ((not ((is_unknown t2.FStar_Syntax_Syntax.n))) && (not ((let _149_581 = (FStar_TypeChecker_Rel.teq env.env t1 t2)
in (FStar_TypeChecker_Rel.is_trivial _149_581))))) then begin
(let _149_586 = (let _149_585 = (let _149_584 = (FStar_Syntax_Print.term_to_string e)
in (let _149_583 = (FStar_Syntax_Print.term_to_string t1)
in (let _149_582 = (FStar_Syntax_Print.term_to_string t2)
in (FStar_Util.format3 "[check]: the expression [%s] has type [%s] but should have type [%s]" _149_584 _149_583 _149_582))))
in FStar_Syntax_Syntax.Err (_149_585))
in (Prims.raise _149_586))
end else begin
()
end)
in (match (((rec_nm), (context_nm))) with
| ((N (t1), N (t2))) | ((M (t1), M (t2))) -> begin
(

let _57_574 = (check t1 t2)
in ((rec_nm), (s_e), (u_e)))
end
| (N (t1), M (t2)) -> begin
(

let _57_581 = (check t1 t2)
in (let _149_587 = (mk_return env t1 s_e)
in ((M (t1)), (_149_587), (u_e))))
end
| (M (_57_584), N (_57_587)) -> begin
(Prims.raise (FStar_Syntax_Syntax.Err ("[check]: got an effectful computation in lieu of a pure computation")))
end))
end))
in (match ((let _149_588 = (FStar_Syntax_Subst.compress e)
in _149_588.FStar_Syntax_Syntax.n)) with
| (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_name (_)) | (FStar_Syntax_Syntax.Tm_fvar (_)) | (FStar_Syntax_Syntax.Tm_abs (_)) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_app (_)) -> begin
(let _149_589 = (infer env e)
in (return_if _149_589))
end
| FStar_Syntax_Syntax.Tm_let ((false, (binding)::[]), e2) -> begin
(mk_let env binding e2 (fun env e2 -> (check env e2 context_nm)) (fun env e2 -> (

let strip_m = (fun _57_5 -> (match (_57_5) with
| (M (t), s_e, u_e) -> begin
((t), (s_e), (u_e))
end
| _57_624 -> begin
(FStar_All.failwith "impossible")
end))
in (match (context_nm) with
| N (t) -> begin
(let _149_596 = (check env e2 (M (t)))
in (strip_m _149_596))
end
| M (_57_629) -> begin
(let _149_597 = (check env e2 context_nm)
in (strip_m _149_597))
end))))
end
| FStar_Syntax_Syntax.Tm_match (e0, branches) -> begin
(mk_match env e0 branches (fun env body -> (check env body context_nm)))
end
| (FStar_Syntax_Syntax.Tm_meta (e, _)) | (FStar_Syntax_Syntax.Tm_uinst (e, _)) | (FStar_Syntax_Syntax.Tm_ascribed (e, _, _)) -> begin
(check env e context_nm)
end
| FStar_Syntax_Syntax.Tm_let (_57_655) -> begin
(let _149_603 = (let _149_602 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[check]: Tm_let %s" _149_602))
in (FStar_All.failwith _149_603))
end
| FStar_Syntax_Syntax.Tm_type (_57_658) -> begin
(FStar_All.failwith "impossible (stratified)")
end
| FStar_Syntax_Syntax.Tm_arrow (_57_661) -> begin
(FStar_All.failwith "impossible (stratified)")
end
| FStar_Syntax_Syntax.Tm_refine (_57_664) -> begin
(let _149_605 = (let _149_604 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[check]: Tm_refine %s" _149_604))
in (FStar_All.failwith _149_605))
end
| FStar_Syntax_Syntax.Tm_uvar (_57_667) -> begin
(let _149_607 = (let _149_606 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[check]: Tm_uvar %s" _149_606))
in (FStar_All.failwith _149_607))
end
| FStar_Syntax_Syntax.Tm_delayed (_57_670) -> begin
(FStar_All.failwith "impossible (compressed)")
end
| FStar_Syntax_Syntax.Tm_unknown -> begin
(let _149_612 = (let _149_611 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[check]: Tm_unknown %s" _149_611))
in (FStar_All.failwith _149_612))
end)))))
and infer : env  ->  FStar_Syntax_Syntax.term  ->  (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term) = (fun env e -> (

let _57_675 = (let _149_615 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.print1 "[debug]: infer %s\n" _149_615))
in (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None e.FStar_Syntax_Syntax.pos))
in (

let normalize = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Normalize.Beta)::(FStar_TypeChecker_Normalize.Inline)::(FStar_TypeChecker_Normalize.UnfoldUntil (FStar_Syntax_Syntax.Delta_constant))::[]) env.env)
in (match ((let _149_619 = (FStar_Syntax_Subst.compress e)
in _149_619.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_bvar (bv) -> begin
(FStar_All.failwith "I failed to open a binder... boo")
end
| FStar_Syntax_Syntax.Tm_name (bv) -> begin
((N (bv.FStar_Syntax_Syntax.sort)), (e), (e))
end
| FStar_Syntax_Syntax.Tm_abs (binders, body, what) -> begin
(

let binders = (FStar_Syntax_Subst.open_binders binders)
in (

let subst = (FStar_Syntax_Subst.opening_of_binders binders)
in (

let body = (FStar_Syntax_Subst.subst subst body)
in (

let env = (

let _57_692 = env
in (let _149_620 = (FStar_TypeChecker_Env.push_binders env.env binders)
in {env = _149_620; definitions = _57_692.definitions; subst = _57_692.subst; tc_const = _57_692.tc_const}))
in (

let s_binders = (FStar_List.map (fun _57_697 -> (match (_57_697) with
| (bv, qual) -> begin
(

let sort = (star_type env bv.FStar_Syntax_Syntax.sort)
in (((

let _57_699 = bv
in {FStar_Syntax_Syntax.ppname = _57_699.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _57_699.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = sort})), (qual)))
end)) binders)
in (

let _57_721 = (FStar_List.fold_left (fun _57_704 _57_707 -> (match (((_57_704), (_57_707))) with
| ((env, acc), (bv, qual)) -> begin
(

let c = (normalize bv.FStar_Syntax_Syntax.sort)
in if (is_C c) then begin
(

let xw = (let _149_624 = (star_type env c)
in (FStar_Syntax_Syntax.gen_bv (Prims.strcat bv.FStar_Syntax_Syntax.ppname.FStar_Ident.idText "^w") None _149_624))
in (

let x = (

let _57_710 = bv
in (let _149_626 = (let _149_625 = (FStar_Syntax_Syntax.bv_to_name xw)
in (trans_F env c _149_625))
in {FStar_Syntax_Syntax.ppname = _57_710.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _57_710.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _149_626}))
in (

let env = (

let _57_713 = env
in (let _149_630 = (let _149_629 = (let _149_628 = (let _149_627 = (FStar_Syntax_Syntax.bv_to_name xw)
in ((bv), (_149_627)))
in FStar_Syntax_Syntax.NT (_149_628))
in (_149_629)::env.subst)
in {env = _57_713.env; definitions = _57_713.definitions; subst = _149_630; tc_const = _57_713.tc_const}))
in (let _149_634 = (let _149_633 = (FStar_Syntax_Syntax.mk_binder x)
in (let _149_632 = (let _149_631 = (FStar_Syntax_Syntax.mk_binder xw)
in (_149_631)::acc)
in (_149_633)::_149_632))
in ((env), (_149_634))))))
end else begin
(

let x = (

let _57_716 = bv
in (let _149_635 = (star_type env bv.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _57_716.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _57_716.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _149_635}))
in (let _149_637 = (let _149_636 = (FStar_Syntax_Syntax.mk_binder x)
in (_149_636)::acc)
in ((env), (_149_637))))
end)
end)) ((env), ([])) binders)
in (match (_57_721) with
| (env, u_binders) -> begin
(

let u_binders = (FStar_List.rev u_binders)
in (

let _57_731 = (

let check_what = if (is_monadic what) then begin
check_m
end else begin
check_n
end
in (

let _57_727 = (check_what env body)
in (match (_57_727) with
| (t, s_body, u_body) -> begin
(let _149_643 = (let _149_642 = if (is_monadic what) then begin
M (t)
end else begin
N (t)
end
in (comp_of_nm _149_642))
in ((_149_643), (s_body), (u_body)))
end)))
in (match (_57_731) with
| (comp, s_body, u_body) -> begin
(

let t = (

let binders = (FStar_List.map (fun _57_735 -> (match (_57_735) with
| (bv, _57_734) -> begin
(let _149_646 = (let _149_645 = (normalize bv.FStar_Syntax_Syntax.sort)
in (FStar_Syntax_Syntax.null_bv _149_645))
in (FStar_Syntax_Syntax.mk_binder _149_646))
end)) binders)
in (

let binders = (FStar_Syntax_Subst.close_binders binders)
in (mk (FStar_Syntax_Syntax.Tm_arrow (((binders), (comp)))))))
in (

let s_body = (FStar_Syntax_Subst.close s_binders s_body)
in (

let s_binders = (FStar_Syntax_Subst.close_binders s_binders)
in (

let s_term = (mk (FStar_Syntax_Syntax.Tm_abs (((s_binders), (s_body), (what)))))
in (

let u_body = (FStar_Syntax_Subst.close u_binders u_body)
in (

let u_binders = (FStar_Syntax_Subst.close_binders u_binders)
in (

let u_term = (mk (FStar_Syntax_Syntax.Tm_abs (((u_binders), (u_body), (what)))))
in ((N (t)), (s_term), (u_term)))))))))
end)))
end)))))))
end
| FStar_Syntax_Syntax.Tm_fvar ({FStar_Syntax_Syntax.fv_name = {FStar_Syntax_Syntax.v = lid; FStar_Syntax_Syntax.ty = _57_752; FStar_Syntax_Syntax.p = _57_750}; FStar_Syntax_Syntax.fv_delta = _57_748; FStar_Syntax_Syntax.fv_qual = _57_746}) -> begin
(match ((FStar_List.find (fun _57_760 -> (match (_57_760) with
| (lid', _57_759) -> begin
(FStar_Ident.lid_equals lid lid')
end)) env.definitions)) with
| Some (_57_762, t) -> begin
(

let _57_766 = (let _149_648 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print2 "[debug]: lookup %s hit %s\n" (FStar_Ident.text_of_lid lid) _149_648))
in ((N (t)), (e), (e)))
end
| None -> begin
(

let _57_772 = (FStar_TypeChecker_Env.lookup_lid env.env lid)
in (match (_57_772) with
| (_57_770, t) -> begin
(

let txt = (FStar_Ident.text_of_lid lid)
in (

let allowed_prefixes = ("Mktuple")::("Left")::("Right")::("Some")::("None")::[]
in (

let _57_775 = (let _149_649 = (FStar_Syntax_Print.term_to_string t)
in (FStar_Util.print2 "[debug]: lookup %s miss %s\n" txt _149_649))
in if (FStar_List.existsb (fun s -> (FStar_Util.starts_with txt (Prims.strcat "Prims." s))) allowed_prefixes) then begin
((N (t)), (e), (e))
end else begin
(let _149_652 = (let _149_651 = (FStar_Util.format1 "The %s constructor has not been whitelisted for the definition language" txt)
in FStar_Syntax_Syntax.Err (_149_651))
in (Prims.raise _149_652))
end)))
end))
end)
end
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(

let _57_785 = (check_n env head)
in (match (_57_785) with
| (t_head, s_head, u_head) -> begin
(

let t_head = (normalize t_head)
in (

let _57_795 = (match ((let _149_653 = (FStar_Syntax_Subst.compress t_head)
in _149_653.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, comp) -> begin
((binders), (comp))
end
| _57_792 -> begin
(let _149_656 = (let _149_655 = (let _149_654 = (FStar_Syntax_Print.term_to_string t_head)
in (FStar_Util.format1 "%s: not a function type" _149_654))
in FStar_Syntax_Syntax.Err (_149_655))
in (Prims.raise _149_656))
end)
in (match (_57_795) with
| (binders, comp) -> begin
(

let _57_796 = (let _149_657 = (FStar_Syntax_Print.term_to_string t_head)
in (FStar_Util.print1 "[debug] type of [head] is %s\n" _149_657))
in (

let n = (FStar_List.length binders)
in (

let n' = (FStar_List.length args)
in (

let _57_800 = if ((FStar_List.length binders) < (FStar_List.length args)) then begin
(let _149_662 = (let _149_661 = (let _149_660 = (FStar_Util.string_of_int n)
in (let _149_659 = (FStar_Util.string_of_int (n' - n))
in (let _149_658 = (FStar_Util.string_of_int n)
in (FStar_Util.format3 "The head of this application, after being applied to %s arguments, is an effectful computation (leaving %s arguments to be applied). Please let-bind the head applied to the %s first arguments." _149_660 _149_659 _149_658))))
in FStar_Syntax_Syntax.Err (_149_661))
in (Prims.raise _149_662))
end else begin
()
end
in (

let _57_804 = (FStar_Syntax_Subst.open_comp binders comp)
in (match (_57_804) with
| (binders, comp) -> begin
(

let rec final_type = (fun subst _57_809 args -> (match (_57_809) with
| (binders, comp) -> begin
(match (((binders), (args))) with
| ([], []) -> begin
(let _149_670 = (let _149_669 = (FStar_Syntax_Subst.subst_comp subst comp)
in _149_669.FStar_Syntax_Syntax.n)
in (nm_of_comp _149_670))
end
| (binders, []) -> begin
(match ((let _149_673 = (let _149_672 = (let _149_671 = (mk (FStar_Syntax_Syntax.Tm_arrow (((binders), (comp)))))
in (FStar_Syntax_Subst.subst subst _149_671))
in (FStar_Syntax_Subst.compress _149_672))
in _149_673.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_arrow (binders, comp) -> begin
(let _149_677 = (let _149_676 = (let _149_675 = (let _149_674 = (FStar_Syntax_Subst.close_comp binders comp)
in ((binders), (_149_674)))
in FStar_Syntax_Syntax.Tm_arrow (_149_675))
in (mk _149_676))
in N (_149_677))
end
| _57_822 -> begin
(FStar_All.failwith "wat?")
end)
end
| ([], (_57_827)::_57_825) -> begin
(FStar_All.failwith "just checked that?!")
end
| (((bv, _57_833))::binders, ((arg, _57_839))::args) -> begin
(final_type ((FStar_Syntax_Syntax.NT (((bv), (arg))))::subst) ((binders), (comp)) args)
end)
end))
in (

let final_type = (final_type [] ((binders), (comp)) args)
in (

let _57_844 = (let _149_678 = (string_of_nm final_type)
in (FStar_Util.print1 "[debug]: final type of application is %s\n" _149_678))
in (

let _57_866 = (let _149_695 = (FStar_List.map2 (fun _57_849 _57_852 -> (match (((_57_849), (_57_852))) with
| ((bv, _57_848), (arg, q)) -> begin
(match ((let _149_682 = (let _149_681 = (normalize bv.FStar_Syntax_Syntax.sort)
in (FStar_Syntax_Subst.compress _149_681))
in _149_682.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_type (_57_854) -> begin
(

let arg = (let _149_683 = (normalize arg)
in ((_149_683), (q)))
in ((arg), ((arg)::[])))
end
| _57_858 -> begin
(

let _57_863 = (check_n env arg)
in (match (_57_863) with
| (_57_860, s_arg, u_arg) -> begin
(let _149_694 = (let _149_684 = (FStar_Syntax_Syntax.as_implicit false)
in ((s_arg), (_149_684)))
in (let _149_693 = if (is_C bv.FStar_Syntax_Syntax.sort) then begin
(let _149_690 = (let _149_686 = (FStar_Syntax_Subst.subst env.subst s_arg)
in (let _149_685 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_686), (_149_685))))
in (let _149_689 = (let _149_688 = (let _149_687 = (FStar_Syntax_Syntax.as_implicit false)
in ((u_arg), (_149_687)))
in (_149_688)::[])
in (_149_690)::_149_689))
end else begin
(let _149_692 = (let _149_691 = (FStar_Syntax_Syntax.as_implicit false)
in ((u_arg), (_149_691)))
in (_149_692)::[])
end
in ((_149_694), (_149_693))))
end))
end)
end)) binders args)
in (FStar_List.split _149_695))
in (match (_57_866) with
| (s_args, u_args) -> begin
(

let u_args = (FStar_List.flatten u_args)
in (let _149_697 = (mk (FStar_Syntax_Syntax.Tm_app (((s_head), (s_args)))))
in (let _149_696 = (mk (FStar_Syntax_Syntax.Tm_app (((u_head), (u_args)))))
in ((final_type), (_149_697), (_149_696)))))
end)))))
end))))))
end)))
end))
end
| FStar_Syntax_Syntax.Tm_let ((false, (binding)::[]), e2) -> begin
(mk_let env binding e2 infer check_m)
end
| FStar_Syntax_Syntax.Tm_match (e0, branches) -> begin
(mk_match env e0 branches infer)
end
| (FStar_Syntax_Syntax.Tm_uinst (e, _)) | (FStar_Syntax_Syntax.Tm_meta (e, _)) | (FStar_Syntax_Syntax.Tm_ascribed (e, _, _)) -> begin
(infer env e)
end
| FStar_Syntax_Syntax.Tm_constant (c) -> begin
(let _149_699 = (let _149_698 = (env.tc_const c)
in N (_149_698))
in ((_149_699), (e), (e)))
end
| FStar_Syntax_Syntax.Tm_let (_57_897) -> begin
(let _149_701 = (let _149_700 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[infer]: Tm_let %s" _149_700))
in (FStar_All.failwith _149_701))
end
| FStar_Syntax_Syntax.Tm_type (_57_900) -> begin
(FStar_All.failwith "impossible (stratified)")
end
| FStar_Syntax_Syntax.Tm_arrow (_57_903) -> begin
(FStar_All.failwith "impossible (stratified)")
end
| FStar_Syntax_Syntax.Tm_refine (_57_906) -> begin
(let _149_703 = (let _149_702 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[infer]: Tm_refine %s" _149_702))
in (FStar_All.failwith _149_703))
end
| FStar_Syntax_Syntax.Tm_uvar (_57_909) -> begin
(let _149_705 = (let _149_704 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[infer]: Tm_uvar %s" _149_704))
in (FStar_All.failwith _149_705))
end
| FStar_Syntax_Syntax.Tm_delayed (_57_912) -> begin
(FStar_All.failwith "impossible (compressed)")
end
| FStar_Syntax_Syntax.Tm_unknown -> begin
(let _149_710 = (let _149_709 = (FStar_Syntax_Print.term_to_string e)
in (FStar_Util.format1 "[infer]: Tm_unknown %s" _149_709))
in (FStar_All.failwith _149_710))
end)))))
and mk_match : env  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.branch Prims.list  ->  (env  ->  FStar_Syntax_Syntax.term  ->  (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term))  ->  (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term) = (fun env e0 branches f -> (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None e0.FStar_Syntax_Syntax.pos))
in (

let _57_925 = (check_n env e0)
in (match (_57_925) with
| (_57_922, s_e0, u_e0) -> begin
(

let _57_942 = (let _149_726 = (FStar_List.map (fun b -> (match ((FStar_Syntax_Subst.open_branch b)) with
| (pat, None, body) -> begin
(

let env = (

let _57_931 = env
in (let _149_725 = (let _149_724 = (FStar_Syntax_Syntax.pat_bvs pat)
in (FStar_List.fold_left FStar_TypeChecker_Env.push_bv env.env _149_724))
in {env = _149_725; definitions = _57_931.definitions; subst = _57_931.subst; tc_const = _57_931.tc_const}))
in (

let _57_937 = (f env body)
in (match (_57_937) with
| (nm, s_body, u_body) -> begin
((nm), (((pat), (None), (((s_body), (u_body))))))
end)))
end
| _57_939 -> begin
(Prims.raise (FStar_Syntax_Syntax.Err ("No when clauses in the definition language")))
end)) branches)
in (FStar_List.split _149_726))
in (match (_57_942) with
| (nms, branches) -> begin
(

let t1 = (match ((FStar_List.hd nms)) with
| (M (t1)) | (N (t1)) -> begin
t1
end)
in (

let has_m = (FStar_List.existsb (fun _57_6 -> (match (_57_6) with
| M (_57_949) -> begin
true
end
| _57_952 -> begin
false
end)) nms)
in (

let _57_987 = (let _149_737 = (FStar_List.map2 (fun nm _57_960 -> (match (_57_960) with
| (pat, guard, (s_body, u_body)) -> begin
(

let check = (fun t t' -> if (not ((let _149_734 = (FStar_TypeChecker_Rel.teq env.env t' t)
in (FStar_TypeChecker_Rel.is_trivial _149_734)))) then begin
(Prims.raise (FStar_Syntax_Syntax.Err ("[infer]: branches do not have the same type")))
end else begin
()
end)
in (match (((nm), (has_m))) with
| ((N (t2), false)) | ((M (t2), true)) -> begin
(

let _57_971 = (check t2 t1)
in ((nm), (((pat), (guard), (s_body))), (((pat), (guard), (u_body)))))
end
| (N (t2), true) -> begin
(

let _57_977 = (check t2 t1)
in (let _149_736 = (let _149_735 = (mk_return env t2 s_body)
in ((pat), (guard), (_149_735)))
in ((M (t2)), (_149_736), (((pat), (guard), (u_body))))))
end
| (M (_57_980), false) -> begin
(FStar_All.failwith "impossible")
end))
end)) nms branches)
in (FStar_List.unzip3 _149_737))
in (match (_57_987) with
| (nms, s_branches, u_branches) -> begin
(

let s_branches = (FStar_List.map FStar_Syntax_Subst.close_branch s_branches)
in (

let u_branches = (FStar_List.map FStar_Syntax_Subst.close_branch u_branches)
in (let _149_739 = (mk (FStar_Syntax_Syntax.Tm_match (((s_e0), (s_branches)))))
in (let _149_738 = (mk (FStar_Syntax_Syntax.Tm_match (((u_e0), (u_branches)))))
in ((if has_m then begin
M (t1)
end else begin
N (t1)
end), (_149_739), (_149_738))))))
end))))
end))
end))))
and mk_let : env_  ->  FStar_Syntax_Syntax.letbinding  ->  FStar_Syntax_Syntax.term  ->  (env_  ->  FStar_Syntax_Syntax.term  ->  (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term))  ->  (env_  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term))  ->  (nm * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term) = (fun env binding e2 proceed ensure_m -> (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None e2.FStar_Syntax_Syntax.pos))
in (

let e1 = binding.FStar_Syntax_Syntax.lbdef
in (

let x = (FStar_Util.left binding.FStar_Syntax_Syntax.lbname)
in (

let x_binders = (let _149_759 = (FStar_Syntax_Syntax.mk_binder x)
in (_149_759)::[])
in (

let _57_1002 = (FStar_Syntax_Subst.open_term x_binders e2)
in (match (_57_1002) with
| (x_binders, e2) -> begin
(match ((infer env e1)) with
| (N (t1), s_e1, u_e1) -> begin
(

let env = (

let _57_1008 = env
in (let _149_760 = (FStar_TypeChecker_Env.push_bv env.env (

let _57_1010 = x
in {FStar_Syntax_Syntax.ppname = _57_1010.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _57_1010.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = t1}))
in {env = _149_760; definitions = _57_1008.definitions; subst = _57_1008.subst; tc_const = _57_1008.tc_const}))
in (

let _57_1016 = (proceed env e2)
in (match (_57_1016) with
| (nm_rec, s_e2, u_e2) -> begin
(let _149_768 = (let _149_763 = (let _149_762 = (let _149_761 = (FStar_Syntax_Subst.close x_binders s_e2)
in ((((false), (((

let _57_1017 = binding
in {FStar_Syntax_Syntax.lbname = _57_1017.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _57_1017.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _57_1017.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _57_1017.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = s_e1}))::[]))), (_149_761)))
in FStar_Syntax_Syntax.Tm_let (_149_762))
in (mk _149_763))
in (let _149_767 = (let _149_766 = (let _149_765 = (let _149_764 = (FStar_Syntax_Subst.close x_binders u_e2)
in ((((false), (((

let _57_1019 = binding
in {FStar_Syntax_Syntax.lbname = _57_1019.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _57_1019.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _57_1019.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _57_1019.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = u_e1}))::[]))), (_149_764)))
in FStar_Syntax_Syntax.Tm_let (_149_765))
in (mk _149_766))
in ((nm_rec), (_149_768), (_149_767))))
end)))
end
| (M (t1), s_e1, u_e1) -> begin
(

let env = (

let _57_1026 = env
in (let _149_769 = (FStar_TypeChecker_Env.push_bv env.env (

let _57_1028 = x
in {FStar_Syntax_Syntax.ppname = _57_1028.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _57_1028.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = t1}))
in {env = _149_769; definitions = _57_1026.definitions; subst = _57_1026.subst; tc_const = _57_1026.tc_const}))
in (

let _57_1034 = (ensure_m env e2)
in (match (_57_1034) with
| (t2, s_e2, u_e2) -> begin
(

let p_type = (mk_star_to_type mk env t2)
in (

let p = (FStar_Syntax_Syntax.gen_bv "p\'\'" None p_type)
in (

let s_e2 = (let _149_775 = (let _149_774 = (let _149_773 = (let _149_772 = (let _149_771 = (FStar_Syntax_Syntax.bv_to_name p)
in (let _149_770 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_771), (_149_770))))
in (_149_772)::[])
in ((s_e2), (_149_773)))
in FStar_Syntax_Syntax.Tm_app (_149_774))
in (mk _149_775))
in (

let s_e2 = (FStar_Syntax_Util.abs x_binders s_e2 None)
in (

let body = (let _149_780 = (let _149_779 = (let _149_778 = (let _149_777 = (let _149_776 = (FStar_Syntax_Syntax.as_implicit false)
in ((s_e2), (_149_776)))
in (_149_777)::[])
in ((s_e1), (_149_778)))
in FStar_Syntax_Syntax.Tm_app (_149_779))
in (mk _149_780))
in (let _149_787 = (let _149_782 = (let _149_781 = (FStar_Syntax_Syntax.mk_binder p)
in (_149_781)::[])
in (FStar_Syntax_Util.abs _149_782 body None))
in (let _149_786 = (let _149_785 = (let _149_784 = (let _149_783 = (FStar_Syntax_Subst.close x_binders u_e2)
in ((((false), (((

let _57_1040 = binding
in {FStar_Syntax_Syntax.lbname = _57_1040.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _57_1040.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _57_1040.FStar_Syntax_Syntax.lbtyp; FStar_Syntax_Syntax.lbeff = _57_1040.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = u_e1}))::[]))), (_149_783)))
in FStar_Syntax_Syntax.Tm_let (_149_784))
in (mk _149_785))
in ((M (t2)), (_149_787), (_149_786)))))))))
end)))
end)
end)))))))
and check_n : env_  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term) = (fun env e -> (

let mn = (let _149_790 = (FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown None e.FStar_Syntax_Syntax.pos)
in N (_149_790))
in (match ((check env e mn)) with
| (N (t), s_e, u_e) -> begin
((t), (s_e), (u_e))
end
| _57_1051 -> begin
(FStar_All.failwith "[check_n]: impossible")
end)))
and check_m : env_  ->  FStar_Syntax_Syntax.term  ->  (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term) = (fun env e -> (

let mn = (let _149_793 = (FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown None e.FStar_Syntax_Syntax.pos)
in M (_149_793))
in (match ((check env e mn)) with
| (M (t), s_e, u_e) -> begin
((t), (s_e), (u_e))
end
| _57_1061 -> begin
(FStar_All.failwith "[check_m]: impossible")
end)))
and comp_of_nm : nm_  ->  FStar_Syntax_Syntax.comp = (fun nm -> (match (nm) with
| N (t) -> begin
(FStar_Syntax_Syntax.mk_Total t)
end
| M (t) -> begin
(mk_M t)
end))
and mk_M : FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.comp = (fun t -> (FStar_Syntax_Syntax.mk_Comp {FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.monadic_lid; FStar_Syntax_Syntax.result_typ = t; FStar_Syntax_Syntax.effect_args = []; FStar_Syntax_Syntax.flags = []}))
and type_of_comp : (FStar_Syntax_Syntax.comp', Prims.unit) FStar_Syntax_Syntax.syntax  ->  FStar_Syntax_Syntax.typ = (fun t -> (match (t.FStar_Syntax_Syntax.n) with
| (FStar_Syntax_Syntax.Total (t)) | (FStar_Syntax_Syntax.GTotal (t)) | (FStar_Syntax_Syntax.Comp ({FStar_Syntax_Syntax.effect_name = _; FStar_Syntax_Syntax.result_typ = t; FStar_Syntax_Syntax.effect_args = _; FStar_Syntax_Syntax.flags = _})) -> begin
t
end))
and trans_F : env_  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun env c wp -> (

let _57_1083 = if (not ((is_C c))) then begin
(FStar_All.failwith "not a C")
end else begin
()
end
in (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None c.FStar_Syntax_Syntax.pos))
in (match ((let _149_802 = (FStar_Syntax_Subst.compress c)
in _149_802.FStar_Syntax_Syntax.n)) with
| FStar_Syntax_Syntax.Tm_app (head, args) -> begin
(

let _57_1093 = (FStar_Syntax_Util.head_and_args wp)
in (match (_57_1093) with
| (wp_head, wp_args) -> begin
(

let _57_1094 = if ((not (((FStar_List.length wp_args) = (FStar_List.length args)))) || (not ((let _149_803 = (FStar_Syntax_Util.mk_tuple_data_lid (FStar_List.length wp_args) FStar_Range.dummyRange)
in (FStar_Syntax_Util.is_constructor wp_head _149_803))))) then begin
(FStar_All.failwith "mismatch")
end else begin
()
end
in (let _149_810 = (let _149_809 = (let _149_808 = (FStar_List.map2 (fun _57_1099 _57_1103 -> (match (((_57_1099), (_57_1103))) with
| ((arg, _57_1098), (wp_arg, _57_1102)) -> begin
(let _149_807 = (trans_F env arg wp_arg)
in (let _149_806 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_807), (_149_806))))
end)) args wp_args)
in ((head), (_149_808)))
in FStar_Syntax_Syntax.Tm_app (_149_809))
in (mk _149_810)))
end))
end
| FStar_Syntax_Syntax.Tm_arrow (binders, comp) -> begin
(

let binders = (FStar_Syntax_Subst.open_binders binders)
in (

let _57_1111 = (FStar_Syntax_Subst.open_comp binders comp)
in (match (_57_1111) with
| (binders, comp) -> begin
(

let _57_1120 = (let _149_822 = (FStar_List.map (fun _57_1114 -> (match (_57_1114) with
| (bv, q) -> begin
(

let h = bv.FStar_Syntax_Syntax.sort
in if (is_C h) then begin
(

let w' = (let _149_812 = (star_type env h)
in (FStar_Syntax_Syntax.gen_bv (Prims.strcat bv.FStar_Syntax_Syntax.ppname.FStar_Ident.idText "-w\'") None _149_812))
in (let _149_818 = (let _149_817 = (FStar_Syntax_Syntax.mk_binder w')
in (let _149_816 = (let _149_815 = (let _149_814 = (let _149_813 = (FStar_Syntax_Syntax.bv_to_name bv)
in (trans_F env h _149_813))
in (FStar_Syntax_Syntax.null_binder _149_814))
in (_149_815)::[])
in (_149_817)::_149_816))
in ((w'), (_149_818))))
end else begin
(

let x = (let _149_819 = (star_type env h)
in (FStar_Syntax_Syntax.gen_bv (Prims.strcat bv.FStar_Syntax_Syntax.ppname.FStar_Ident.idText "-x") None _149_819))
in (let _149_821 = (let _149_820 = (FStar_Syntax_Syntax.mk_binder x)
in (_149_820)::[])
in ((x), (_149_821))))
end)
end)) binders)
in (FStar_List.split _149_822))
in (match (_57_1120) with
| (bvs, binders) -> begin
(

let binders = (FStar_List.flatten binders)
in (

let app = (let _149_828 = (let _149_827 = (let _149_826 = (FStar_List.map (fun bv -> (let _149_825 = (FStar_Syntax_Syntax.bv_to_name bv)
in (let _149_824 = (FStar_Syntax_Syntax.as_implicit false)
in ((_149_825), (_149_824))))) bvs)
in ((wp), (_149_826)))
in FStar_Syntax_Syntax.Tm_app (_149_827))
in (mk _149_828))
in (

let comp = (let _149_830 = (type_of_comp comp)
in (let _149_829 = (is_monadic_comp comp)
in (trans_G env _149_830 _149_829 app)))
in (

let comp = (FStar_Syntax_Subst.close_comp binders comp)
in (

let binders = (FStar_Syntax_Subst.close_binders binders)
in (mk (FStar_Syntax_Syntax.Tm_arrow (((binders), (comp))))))))))
end))
end)))
end
| _57_1128 -> begin
(FStar_All.failwith "impossible trans_F")
end))))
and trans_G : env_  ->  FStar_Syntax_Syntax.typ  ->  Prims.bool  ->  FStar_Syntax_Syntax.typ  ->  FStar_Syntax_Syntax.comp = (fun env h is_monadic wp -> (

let mk = (fun x -> (FStar_Syntax_Syntax.mk x None h.FStar_Syntax_Syntax.pos))
in if is_monadic then begin
(let _149_841 = (let _149_840 = (star_type env h)
in (let _149_839 = (let _149_838 = (let _149_837 = (FStar_Syntax_Syntax.as_implicit false)
in ((wp), (_149_837)))
in (_149_838)::[])
in {FStar_Syntax_Syntax.effect_name = FStar_Syntax_Const.effect_PURE_lid; FStar_Syntax_Syntax.result_typ = _149_840; FStar_Syntax_Syntax.effect_args = _149_839; FStar_Syntax_Syntax.flags = []}))
in (FStar_Syntax_Syntax.mk_Comp _149_841))
end else begin
(let _149_842 = (trans_F env h wp)
in (FStar_Syntax_Syntax.mk_Total _149_842))
end))


let star_expr_definition : env  ->  FStar_Syntax_Syntax.term  ->  (env * (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.term)) = (fun env t -> (star_definition env t (fun env e -> (

let _57_1142 = (check_n env e)
in (match (_57_1142) with
| (t, s_e, s_u) -> begin
((t), (((s_e), (s_u))))
end)))))




