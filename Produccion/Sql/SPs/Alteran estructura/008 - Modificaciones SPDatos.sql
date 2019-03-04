drop procedure Sp_ObjCoberturaUsuarios
drop procedure Sp_ObjCoberturaZona
drop procedure Sp_ObjCoberturaMeses
drop procedure Sp_ObjCoberturaMesesWithLine
drop procedure Sp_ObjFacingCliCompDrill
drop procedure Sp_ObjFacingEmpresasStacked
drop procedure Sp_ObjShareEmpresas
drop procedure Sp_ObjCoberturaMesUsuDrill
drop procedure Sp_TblCoberturaUsuarios
drop procedure Sp_TblCoberturaMeses
drop procedure Sp_ObjShareEvolucion
drop procedure Sp_ObjCoberturaUsuariosPie
drop procedure Sp_ObjFacingEmpresasTabla
drop procedure Sp_FacingMarcaPropia
drop procedure Sp_FacingMarcaProductoPropio
drop procedure Sp_FacingProductoPropio
drop procedure Sp_FacingProductoPropioTabla
drop procedure Sp_FacingMarcaProductoSoloCompetencia
drop procedure Sp_FacingMarcaProductoSoloCompetenciaPromedio
drop procedure Sp_FacingMarcaProductoPropioPromedio
drop procedure Sp_ObjShareEmpresasTabla
drop procedure Sp_ObjShareEvolucionTabla
drop procedure Sp_ObjShareEmpresasMarcasPie
drop procedure Sp_ShareMarcaProductoPropioPie
drop procedure Sp_ShareMarcaProductosCompetencia
drop procedure Sp_ShareMarcaPropiaPie
drop procedure Sp_ShareMarcaPropiaTabla
drop procedure Sp_ShareMarcaCompetencia
drop procedure Sp_ShareMarcaCompetenciaTabla
drop procedure Sp_ShareProductoPropio
drop procedure Sp_ShareProductoPropioTabla
drop procedure Sp_ShareProductoCompetencia
drop procedure Sp_ShareProductoCompetenciaTabla
drop procedure Sp_PrecioProductoPropio
drop procedure Sp_PrecioProductoCompetencia
drop procedure Sp_PrecioProductoPropioTabla
drop procedure Sp_PrecioProductoCompetenciaTabla
drop procedure Sp_PrecioProductoPropioLine
drop procedure Sp_PrecioProductoCompetenciaLine
drop procedure Sp_PrecioProductoPropioVsCompetencia
drop procedure Sp_QuiebreStockTabla
drop procedure Sp_QuiebreStockPdv
drop procedure Sp_QuiebreMarcaProducto
drop procedure Sp_PopMarcaDetalleDrill
drop procedure Sp_PopMarcaDetalleTabla
drop procedure Sp_ObjShareEvolucionMarcaPropia
drop procedure Sp_ObjShareEvolucionMarcaCompetencia

update reportingObjeto set spdatos = 'Fac_MarcaProd_T6' where spdatos = 'Sp_FacingMarcaProductoPropio'
update reportingObjeto set spdatos = 'Fac_MarcaProdComp_T6' where spdatos = 'Sp_FacingMarcaProductoSoloCompetencia'
update reportingObjeto set spdatos = 'Fac_Marca_T3' where spdatos = 'Sp_FacingMarcaPropia'
update reportingObjeto set spdatos = 'Fac_Prod_T3' where spdatos = 'Sp_FacingProductoPropio'
update reportingObjeto set spdatos = 'Fac_Prod_T9' where spdatos = 'Sp_FacingProductoPropioTabla'
update reportingObjeto set spdatos = 'Cob_Mensual_T1' where spdatos = 'Sp_ObjCoberturaMeses'
update reportingObjeto set spdatos = 'Cob_Mensual_T5' where spdatos = 'Sp_ObjCoberturaMesesWithLine'
update reportingObjeto set spdatos = 'Cob_MesUsuario_T7' where spdatos = 'Sp_ObjCoberturaMesUsuDrill'
update reportingObjeto set spdatos = 'Cob_Usuarios_T1' where spdatos = 'Sp_ObjCoberturaUsuarios'
update reportingObjeto set spdatos = 'Cob_Usuarios_T2' where spdatos = 'Sp_ObjCoberturaUsuariosPie'
update reportingObjeto set spdatos = 'Cob_Zona_T2' where spdatos = 'Sp_ObjCoberturaZona'
update reportingObjeto set spdatos = 'Fac_ClienteComp_T6' where spdatos = 'Sp_ObjFacingCliCompDrill'
update reportingObjeto set spdatos = 'Fac_Empresas_T3' where spdatos = 'Sp_ObjFacingEmpresasStacked'
update reportingObjeto set spdatos = 'Fac_Empresas_T9' where spdatos = 'Sp_ObjFacingEmpresasTabla'
update reportingObjeto set spdatos = 'Sha_Empresas_T2' where spdatos = 'Sp_ObjShareEmpresas'
update reportingObjeto set spdatos = 'Sha_EmpresasMarca_T11' where spdatos = 'Sp_ObjShareEmpresasMarcasPie'
update reportingObjeto set spdatos = 'Sha_Empresas_T9' where spdatos = 'Sp_ObjShareEmpresasTabla'
update reportingObjeto set spdatos = 'Sha_Evol_T10' where spdatos = 'Sp_ObjShareEvolucion'
update reportingObjeto set spdatos = 'Sha_EvolMarcaComp_T10' where spdatos = 'Sp_ObjShareEvolucionMarcaCompetencia'
update reportingObjeto set spdatos = 'Sha_EvolMarca_T10' where spdatos = 'Sp_ObjShareEvolucionMarcaPropia'
update reportingObjeto set spdatos = 'Sha_Evol_T9' where spdatos = 'Sp_ObjShareEvolucionTabla'
update reportingObjeto set spdatos = 'Met_Pop_T6' where spdatos = 'Sp_PopMarcaDetalleDrill'
update reportingObjeto set spdatos = 'Met_Pop_T9' where spdatos = 'Sp_PopMarcaDetalleTabla'
update reportingObjeto set spdatos = 'Met_PrecioComp_T3' where spdatos = 'Sp_PrecioProductoCompetencia'
update reportingObjeto set spdatos = 'Met_PrecioComp_T10' where spdatos = 'Sp_PrecioProductoCompetenciaLine'
update reportingObjeto set spdatos = 'Met_PrecioComp_T9' where spdatos = 'Sp_PrecioProductoCompetenciaTabla'
update reportingObjeto set spdatos = 'Met_Precio_T3' where spdatos = 'Sp_PrecioProductoPropio'
update reportingObjeto set spdatos = 'Met_Precio_T10' where spdatos = 'Sp_PrecioProductoPropioLine'
update reportingObjeto set spdatos = 'Met_Precio_T9' where spdatos = 'Sp_PrecioProductoPropioTabla'
update reportingObjeto set spdatos = 'Met_PrecioVs_T3' where spdatos = 'Sp_PrecioProductoPropioVsCompetencia'
update reportingObjeto set spdatos = 'Met_Quiebre_T6' where spdatos = 'Sp_QuiebreMarcaProducto'
update reportingObjeto set spdatos = 'Met_Quiebre_T1' where spdatos = 'Sp_QuiebreStockPdv'
update reportingObjeto set spdatos = 'Met_Quiebre_T9' where spdatos = 'Sp_QuiebreStockTabla'
update reportingObjeto set spdatos = 'Sha_MarcaComp_T11' where spdatos = 'Sp_ShareMarcaCompetencia'
update reportingObjeto set spdatos = 'Sha_MarcaComp_T9' where spdatos = 'Sp_ShareMarcaCompetenciaTabla'
update reportingObjeto set spdatos = 'Sha_MarcaProd_T11' where spdatos = 'Sp_ShareMarcaProductoPropioPie'
update reportingObjeto set spdatos = 'Sha_MarcaProdComp_T11' where spdatos = 'Sp_ShareMarcaProductosCompetencia'
update reportingObjeto set spdatos = 'Sha_Marca_T11' where spdatos = 'Sp_ShareMarcaPropiaPie'
update reportingObjeto set spdatos = 'Sha_Marca_T9' where spdatos = 'Sp_ShareMarcaPropiaTabla'
update reportingObjeto set spdatos = 'Sha_ProdComp_T11' where spdatos = 'Sp_ShareProductoCompetencia'
update reportingObjeto set spdatos = 'Sha_ProdComp_T9' where spdatos = 'Sp_ShareProductoCompetenciaTabla'
update reportingObjeto set spdatos = 'Sha_Prod_T11' where spdatos = 'Sp_ShareProductoPropio'
update reportingObjeto set spdatos = 'Sha_Prod_T9' where spdatos = 'Sp_ShareProductoPropioTabla'
update reportingObjeto set spdatos = 'Cob_Mensual_T9' where spdatos = 'Sp_TblCoberturaMeses'
update reportingObjeto set spdatos = 'Cob_Usuarios_T9' where spdatos = 'Sp_TblCoberturaUsuarios'
