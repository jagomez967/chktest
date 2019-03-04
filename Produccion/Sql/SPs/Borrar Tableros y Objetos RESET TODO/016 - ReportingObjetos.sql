delete from reportingTableroObjeto
delete from reportingTablero
delete from ReportingClienteObjeto
delete from reportingObjeto
delete from reportingObjetoCategoria
delete from ReportingFamiliaNombreCliente
delete from reportingFamiliaObjeto
delete from reportingTableroUsuario

DBCC CHECKIDENT ('[ReportingFamiliaObjeto]', RESEED, 0)
DBCC CHECKIDENT ('[ReportingTablero]', RESEED, 0)
DBCC CHECKIDENT ('[ReportingObjetoCategoria]', RESEED, 0)
DBCC CHECKIDENT ('[ReportingObjeto]', RESEED, 0)

insert ReportingObjetoCategoria (Nombre) values ('Cobertura')
insert ReportingObjetoCategoria (Nombre) values ('Facing')
insert ReportingObjetoCategoria (Nombre) values ('Share')
insert ReportingObjetoCategoria (Nombre) values ('Precio')
insert ReportingObjetoCategoria (Nombre) values ('Metricas')
insert ReportingObjetoCategoria (Nombre) values ('Encuestas')
insert ReportingObjetoCategoria (Nombre) values ('DirecTV')
insert ReportingObjetoCategoria (Nombre) values ('Mattel')
insert ReportingObjetoCategoria (Nombre) values ('Neopop')
insert ReportingObjetoCategoria (Nombre) values ('Imagenes')
insert ReportingObjetoCategoria (Nombre) values ('Anwo')
insert ReportingObjetoCategoria (Nombre) values ('Ventas')
insert ReportingObjetoCategoria (Nombre) values ('Pper')
insert ReportingObjetoCategoria (Nombre) values ('GardenHouse')
insert ReportingObjetoCategoria (Nombre) values ('Varios')
insert ReportingObjetoCategoria (Nombre) values ('PF')
insert ReportingObjetoCategoria (Nombre) values ('Candy')
insert ReportingObjetoCategoria (Nombre) values ('Colgram')
insert ReportingObjetoCategoria (Nombre) values ('Skechers')

insert ReportingFamiliaObjeto (Nombre) values('Cobertura por Usuario')
insert ReportingFamiliaObjeto (Nombre) values('Cobertura por Zona')
insert ReportingFamiliaObjeto (Nombre) values('Cobertura Mensual')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Empresa y Marca')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Empresa')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share por Empresa')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Evolucion')
insert ReportingFamiliaObjeto (Nombre) values('Facing de Marca Propia')
insert ReportingFamiliaObjeto (Nombre) values('Cobertura por Mes y Usuario')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Marca y Producto')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Producto')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Marca y Producto Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Marca y Producto Competencia Promedio')
insert ReportingFamiliaObjeto (Nombre) values('Facing por Marca y Producto Promedio')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Empresa/Marca')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Marca/Producto')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Marca/Producto Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Marca Propia')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Marca Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Producto Propio')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Producto Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Precio Productos Propios')
insert ReportingFamiliaObjeto (Nombre) values('Precio Productos Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Precio Producto Propio vs Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Quiebre de Stock')
insert ReportingFamiliaObjeto (Nombre) values('Quiebre de Stock por Punto de Venta')
insert ReportingFamiliaObjeto (Nombre) values('Quiebre de Stock Marca/Producto')
insert ReportingFamiliaObjeto (Nombre) values('Pop por Marca')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Evolución por Marca Propia')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Evolución por Marca Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Métricas encuestas')
insert ReportingFamiliaObjeto (Nombre) values('Preguntas Encuestas')
insert ReportingFamiliaObjeto (Nombre) values('Evolución Encuestas')
insert ReportingFamiliaObjeto (Nombre) values('Preguntas por Marca')
insert ReportingFamiliaObjeto (Nombre) values('Ventas Brutas')
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Asesores en Pdv',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Estado del Pdv',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Estado del Pdv - Porcentual',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Publicidad',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Publicidad - Porcentual',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Asesor',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Asesor - Porcentual',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Retail',7)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Retail - Porcentual',7)
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Actividades')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Canal')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Inicio de Actividad')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Mitad de Actividad')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Cierre de Actividad')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Publicidad')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Auditoría no autorizada')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Número de Asesores')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Estado del Pdv')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Asesores')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Retail')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Tipo PDV - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Supervisor - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Coordinador - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Cadenas - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share Empresas - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Neopop - ISE Score por marca')
insert ReportingFamiliaObjeto (Nombre) values('Pallets - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share PDV - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Quiebre de Stock - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('POS Space Report - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('POS Space Report Share - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Segmento SOS - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Segmento SOS Share - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('HotSpots - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('HotSpots Share - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('HotSpots Totales - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Listados Reportados - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Listados No Reportados - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Precios Sugeridos - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('POS Space Report evo - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Pallets x Cadena - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Precios Sugeridos Competencia - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Imagenes')
insert ReportingFamiliaObjeto (Nombre) values('POP por PDV')
insert ReportingFamiliaObjeto (Nombre) values('Informe Login/Logout')
insert ReportingFamiliaObjeto (Nombre) values('Layout Pdv')
insert ReportingFamiliaObjeto (Nombre) values('Ventas por Productos')
insert ReportingFamiliaObjeto (Nombre) values('Pper - Incidencias')
insert ReportingFamiliaObjeto (Nombre) values('Pper - Estados por Punto de Venta')
insert ReportingFamiliaObjeto (Nombre) values('Shelf Share - Marca propia vs Competencia')
insert ReportingFamiliaObjeto (Nombre) values('Cobertura Diaria')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Porcentaje Agotados')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Mix de Categorización')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Mix de Exhibición')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Mix de POP')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Transferencias')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Auditoria No Autorizada')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Tiendas Reportadas')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Sugerencias Arreglo del PDV')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Cajas de Exhibición')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Tamaño de Exhibición')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - # Nivel de Exhibición')
insert ReportingFamiliaObjeto (Nombre) values('DirectV - Ubicación de Exhibición')
insert ReportingFamiliaObjeto (Nombre) values('DirecTV - Relevo DTV')
insert ReportingFamiliaObjeto (Nombre) values('PDV Asignados RTM')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Cumplimiento Ventas')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Real Ventas')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Cumplimiento Transferencias')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Real Transferencistas')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Transferencias Copidrogas')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Cuota Clientes Directos')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Promedio Visitas Diarias')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Porcentaje Cobertura')
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Reporte Producto Propio', 15)
insert ReportingFamiliaObjeto (Nombre, IdCategoria) values('Reporte Producto Competencia', 15)
insert ReportingFamiliaObjeto (Nombre) values('PF - Reporte Promocion')
insert ReportingFamiliaObjeto (Nombre) values('Quiebre Producto x Cadena - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Quiebre Productos - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('PF - Check In Promotora')
insert ReportingFamiliaObjeto (Nombre) values('Neopop - Comentarios PDV')
insert ReportingFamiliaObjeto (Nombre) values('Detalle Cajas - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Share Cajas - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Exhibición Adicional - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Precio Sugerido Propio - Mattel')
insert ReportingFamiliaObjeto (Nombre) values('Garden - Primer y Ultima Transferencia')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Exhibiciones Adicionales Totales - Mattel',8, 'ExhibicionesAdicionalesTotales')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Colgram - Presentación Productos', 18, 'PresentacionProductos')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Cajas Por Cadena - Mattel',8, 'CajasPorCadena')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Quiebre Ponderado',5, 'QuiebrePonderado')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Quiebre Portfolio',5, 'QuiebrePortfolio')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Quiebre x Marcas Portfolio',5, 'QuiebreMarcasPortfolio')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Quiebre Ponderado Portfolio',5, 'QuiebrePonderadoPortfolio')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Resumen Marcas',1, 'ResumenMarcas')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Cuadro de Mando',1, 'CuadroMando')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta Aud No Aut',1, 'PdvAudNoAut')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta Trabajan',1, 'PdvTrabajan')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta Distribucion x Producto',1, 'PdvConDistProd')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta NO Trabajan Total',1, 'PdvNoTrabajanTotal')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta con Distribucion',1, 'PdvConDist')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta con Localizacion',1, 'PdvLocalizacion')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta sin Exhibicion',1, 'PdvSinExhibicion')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta con Exhibicion',1, 'PdvConExhibicion')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Propiedades',5, 'Propiedades')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Resumen Equipos',1, 'ResumenEquipos')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Quiebre x Marca',5, 'QuiebreMarcas')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('DIST - EXH - QUIEBRE',1, 'DistExhQuiebre')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Objetivo Cobertura',1, 'CobObjetivo')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Cobertura Nacional x Zona',1, 'CobNacZona')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Cobertura Nacional x RTM',1, 'CobNacRTM')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta NO Trabajan x Marca',1, 'PdvsNoTrabajanMarca')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Puntos de Venta con Dist x Marca',1, 'PdvDistMarca')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Registro Check in / Check out',19, 'RegistroCheckinout')
insert ReportingFamiliaObjeto (Nombre, IdCategoria, Identificador) values('Colgram - POP por PDV',18, 'ColgramPOPporPDV')



update ReportingFamiliaObjeto set IdCategoria = 1 where nombre like '%Cobertura%'
update ReportingFamiliaObjeto set IdCategoria = 2 where nombre like '%Facing%'
update ReportingFamiliaObjeto set IdCategoria = 3 where nombre like '%Share%'
update ReportingFamiliaObjeto set IdCategoria = 4 where nombre like '%Precio%'
update ReportingFamiliaObjeto set IdCategoria = 5 where nombre like '%Metricas%'
update ReportingFamiliaObjeto set IdCategoria = 6 where nombre like '%Encuestas%'
update ReportingFamiliaObjeto set IdCategoria = 7 where nombre like '%DirecTV%'
update ReportingFamiliaObjeto set IdCategoria = 8 where nombre like '%Mattel%'
update ReportingFamiliaObjeto set IdCategoria = 9 where nombre like '%Neopop%'
update ReportingFamiliaObjeto set IdCategoria = 10 where nombre like '%Imagenes%'
update ReportingFamiliaObjeto set IdCategoria = 11 where nombre like '%Anwo%'
update ReportingFamiliaObjeto set IdCategoria = 12 where nombre like '%Ventas%'
update ReportingFamiliaObjeto set IdCategoria = 13 where nombre like '%Pper%'
update ReportingFamiliaObjeto set IdCategoria = 14 where nombre like '%GardenHouse%'
update ReportingFamiliaObjeto set IdCategoria = 14 where nombre like '%Garden%'
update ReportingFamiliaObjeto set IdCategoria = 5 where idcategoria is null

SET IDENTITY_INSERT [dbo].[ReportingObjeto] ON 

GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (1, 1, N'Cob_Usuarios_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (2, 2, N'Cob_Zona_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (3, 3, N'Cob_Mensual_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (4, 3, N'Cob_Mensual_T5', 5)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (5, 4,  N'Fac_ClienteComp_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (6, 5, N'Fac_Empresas_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (7, 6, N'Sha_Empresas_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (8, 9, N'Cob_MesUsuario_T7', 7)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (9, 1, N'Cob_Usuarios_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (10, 3, N'Cob_Mensual_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (11, 7, N'Sha_Evol_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (12, 1, N'Cob_Usuarios_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (13, 5, N'Fac_Empresas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (14, 8, N'Fac_Marca_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (15, 10, N'Fac_MarcaProd_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (16, 11, N'Fac_Prod_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (17, 11, N'Fac_Prod_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (18, 12, N'Fac_MarcaProdComp_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (19, 13, N'Fac_Promedio_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (20, 14, N'Fac_PromedioMarcaProd_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (21, 6, N'Sha_Empresas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (22, 7, N'Sha_Evol_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (23, 15, N'Sha_EmpresasMarca_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (24, 16, N'Sha_MarcaProd_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (25, 17, N'Sha_MarcaProdComp_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (26, 18, N'Sha_Marca_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (27, 18, N'Sha_Marca_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (28, 19, N'Sha_MarcaComp_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (29, 19, N'Sha_MarcaComp_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (30, 20, N'Sha_Prod_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (31, 20, N'Sha_Prod_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (32, 21, N'Sha_ProdComp_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (33, 21, N'Sha_ProdComp_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (34, 22, N'Met_Precio_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (35, 23, N'Met_PrecioComp_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (36, 22, N'Met_Precio_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (37, 23, N'Met_PrecioComp_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (38, 22, N'Met_Precio_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (39, 23, N'Met_PrecioComp_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (40, 24, N'Met_PrecioVs_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (41, 25, N'Met_Quiebre_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (42, 26, N'Met_Quiebre_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (43, 27, N'Met_Quiebre_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (44, 28, N'Met_Pop_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (45, 28, N'Met_Pop_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (46, 29, N'Sha_EvolMarca_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (47, 30, N'Sha_EvolMarcaComp_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (48, 31, N'Met_Encuestas_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (49, 32, N'Met_Preguntas_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (50, 33, N'Met_Encuestas_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (51, 34, N'Met_Encuestas_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (52, 35, N'Directv_CierreAct_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (53, 36, N'Directv_AsesoresPdv_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (54, 37, N'DirecTV_EstadoPdv_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (55, 38, N'DirecTV_EstadoPdvPorcentaje_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (56, 39, N'DirecTV_Publicidad_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (57, 40, N'DirecTV_PublicidadPorcentaje_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (58, 41, N'DirecTV_Asesor_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (59, 42, N'DirecTV_AsesorPorcentaje_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (60, 43, N'DirecTV_Retail_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (61, 44, N'DirecTV_RetailPorcentaje_T13', 13)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (62, 45, N'Mattel_ShaPropio_Empresas_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (63, 46, N'DirecTv_Actividades_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (64, 47, N'DirecTv_Canal_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (65, 48, N'DirecTv_InicioAct_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (66, 49, N'DirecTv_MitadActividad_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (67, 50, N'DirecTv_CierreActividad_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (68, 51, N'DirecTv_Publicidad_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (69, 52, N'DirecTv_AudNoAutorizadas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (70, 53, N'DirecTv_NumAsesores_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (71, 54, N'DirecTv_EstadoPDV_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (72, 55, N'DirecTv_Asesor_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (73, 56, N'DirecTv_Retail_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (74, 57, N'Mattel_ShaPropio_TipoPDV_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (75, 58, N'Mattel_ShaPropio_Usuario_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (76, 59, N'Mattel_ShaPropio_Coordinador_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (77, 60, N'Mattel_ShaPropio_Cadenas_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (78, 62, N'Neopop_iseScore_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (79, 62, N'Neopop_iseScore_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (80, 62, N'Neopop_iseScore_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (81, 63, N'Mattel_Pallets_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (82, 61, N'Mattel_ShaPropio_Empresas_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (83, 64, N'Mattel_ShaPDV_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (84, 65, N'Mattel_QuiebrePropio_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (85, 66, N'Mattel_POSReport_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (86, 67, N'Mattel_POSReportShare_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (87, 68, N'Mattel_SegmentoSOS_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (88, 69, N'Mattel_SegmentoSOSShare_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (89, 70, N'Mattel_HotSpots_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (90, 71, N'Mattel_HotSpotsShare_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (91, 72, N'Mattel_HotSpots_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (92, 73, N'Mattel_CobUsuarioPDV_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (93, 74, N'Mattel_CobUsuarioPDVnrep_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (94, 75, N'Mattel_PrecioSugerido_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (95, 76, N'Mattel_POSReport_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (96, 77, N'Mattel_PalletsCadena_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (97, 78, N'Mattel_PrecioSugeridoComp_T9', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (98, 79, N'Img_Fotos_T15', 15)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (99, 41, N'DirecTV_Asesor_T1', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (100, 42, N'DirecTV_AsesorPorcentaje_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (101, 38, N'DirecTV_EstadoPdvPorcentaje_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (102, 43, N'DirecTV_Retail_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (103, 44, N'DirecTV_RetailPorcentaje_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (104, 37, N'DirecTV_EstadoPdv_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (105, 39, N'DirecTV_Publicidad_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (106, 40, N'DirecTV_PublicidadPorcentaje_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (107, 80, N'Met_PopxPdv_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (108, 81, N'Anwo_LoginLogut_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (109, 82, N'Img_Layout_T16', 16)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (110, 83, N'Ventas_Productos_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (111, 83, N'Ventas_Productos_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (112, 84, N'Pper_Incidencias_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (113, 85, N'Pper_Estado_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (114, 86, N'Sha_MarcaPropiaYComp_T11', 11)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (115, 86, N'Sha_MarcaPropiaYComp_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (116, 87, N'Cob_Diaria_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (117, 88, N'Garden_AgotadosPorSku_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (118, 89, N'Garden_MixPop_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (119, 90, N'Garden_Exhibicion_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (120, 91, N'Garden_Categorizacion_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (121, 92, N'Garden_Transferencia_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (122, 93, N'Garden_TiendasReportadas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (123, 94, N'Garden_AudNoAutorizadas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (124, 95, N'DirecTv_SugerenciasPDV_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (125, 96, N'DirecTv_RetailCajasExh_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (126, 97, N'DirecTv_TamañoExh_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (127, 98, N'DirecTv_NivelesExh_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (128, 99, N'DirecTv_UbicacionExh_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (129, 52, N'DirecTv_AudNoAutorizadas_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (130, 100, N'Dtv_Relevo_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (131, 101, N'Cob_AsignadosRTM_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (132, 102, N'Garden_CumplimientoVentas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (133, 103, N'Garden_RealVentas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (134, 104, N'Garden_CumplimientoTransferencias_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (135, 105, N'Garden_RealTransferencistas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (136, 106, N'Garden_TransCopidrogas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (137, 107, N'Garden_CuotaClDirectos_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (138, 108, N'Cob_PromedioDiario_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (139, 9, N'Cob_MesUsuario_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (140, 110, N'Fac_RepProdPropio_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (141, 111, N'Fac_RepProdCompetencia_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (142, 112, N'PF_Relevo_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (143, 113, N'Mattel_QuiebreCadenaProducto_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (144, 114, N'Mattel_QuiebreProductos_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (145, 115, N'PF_CheckInRelevo_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (147, 116, N'Neopop_ComentarioPdv_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (148, 117, N'Mattel_DetalleCajas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (149, 118, N'Mattel_ShaCajas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (150, 119, N'Mattel_ExhAdicional_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (151, 120, N'Mattel_PrecioSugeridoPropio_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (152, 121, N'Garden_MaxMinReporte_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (153, 122, N'Mattel_ExhAdicional_T2', 2)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (154, 123, N'Mattel_ExhAdicional_T2', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (155, 124, N'Mattel_CajasxCadena_T6', 6)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (156, 80, N'Met_PopxPdv_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (157, 125, N'Met_QuiebrePonderado_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (158, 126, N'Met_QuiebrePortfolio_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (159, 127, N'Met_QuiebreMarcasPortfolio_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (160, 128, N'Met_QuiebrePonderadoPortfolio_T10', 10)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (161, 126, N'Met_QuiebrePortfolio_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (162, 129, N'Cob_ResumenMarcas_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (163, 130, N'Cob_CuadroDeMando_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (164, 131, N'Cob_PdvAudNoAut_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (165, 132, N'Cob_PdvTrabajan_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (166, 133, N'Cob_PdvConDistPorProd_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (167, 134, N'Cob_PdvNOTrabajanTotal_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (168, 135, N'Cob_PdvConDistribucion_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (169, 136, N'Cob_PdvConLocalizacion_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (170, 137, N'Cob_PdvSinExhibicion_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (171, 138, N'Cob_PdvConExhibicion_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (172, 139, N'Met_Propiedades_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (173, 140, N'Cob_ResumenEquipos_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (174, 141, N'Met_QuiebreMarcas_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (175, 142, N'Cob_DistExhQuiebre_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (176, 138, N'Cob_PdvExhibicion_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (177, 143, N'Cob_Objetivo_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (178, 144, N'Cob_NacionalZona_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (179, 145, N'Cob_NacionalRTM_T12', 12)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (180, 139, N'Met_Propiedades_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (181, 146, N'Cob_PdvsNoTrabajaMarca_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (182, 147, N'Cob_PdvsDistMarca_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (184, 133, N'Cob_PdvConDistPorProd_T3', 3)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (185, 137, N'Cob_PdvSinExhibicion_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (186, 149, N'GyT_Relevo_T9', 9)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (187, 131, N'Cob_PdvAudNoAut_T1', 1)
GO
INSERT [dbo].[ReportingObjeto] ([Id], [IdFamiliaObjeto], [SPDatos], [TipoChart]) VALUES (188, 151, N'Colgram_PopxPdv_T9', 9)
GO
SET IDENTITY_INSERT [dbo].[ReportingObjeto] OFF
GO

update ReportingObjeto set SpAnidado='Cob_Usuarios_T9_Datos_Anidados' where SpDatos='Cob_Usuarios_T9'
update ReportingObjeto set SpAnidado='Mattel_ShaCajas_T9_Datos_Anidados' where SpDatos='Mattel_ShaCajas_T9'
update ReportingObjeto set SpAnidado='Mattel_HotSpots_T9_Datos_Anidados' where SpDatos='Mattel_HotSpots_T9'
update ReportingObjeto set SpAnidado='Mattel_ExhAdicional_T9_Datos_Anidados' where SpDatos='Mattel_ExhAdicional_T9'