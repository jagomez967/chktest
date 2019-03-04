IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Bayton_Tabla_Detalle_Preguntas_Gondolas_T9'))
   exec('CREATE PROCEDURE [dbo].[Bayton_Tabla_Detalle_Preguntas_Gondolas_T9] AS BEGIN SET NOCOUNT ON; END')
GO 
alter PROCEDURE [dbo].[Bayton_Tabla_Detalle_Preguntas_Gondolas_T9] 
 
(  
 @IdCliente   int  
 ,@Filtros   FiltrosReporting readonly  
 ,@NumeroDePagina int = -1  
 ,@Lenguaje   varchar(10) = 'es'  
 ,@IdUsuarioConsulta int = 0  
 ,@TamañoPagina  int = 0  
)  
as  
begin  
 /*  
   
 Para filtrar en un query hacer:  
 ===============================  
 * (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))  
 * (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))  
  
 */    
  
 SET LANGUAGE spanish  
 set nocount on  
  
 if @lenguaje = 'es' set language spanish  
 if @lenguaje = 'en' set language english  
  
 declare @strFDesde varchar(30)  
 declare @strFHasta varchar(30)  
 declare @fechaDesde datetime  
 declare @fechaHasta datetime  
   
 create table #fechaCreacionReporte  
 (  
  id int identity(1,1)  
  ,fecha varchar(10)  
 )  
  
 create table #zonas  
 (  
  idZona int  
 )  
  
 create table #cadenas  
 (  
  idCadena int  
 )  
  
 create table #localidades  
 (  
  idLocalidad int  
 )  
  
 create table #puntosdeventa  
 (  
  idPuntoDeVenta int  
 )  
  
 create table #usuarios  
 (  
  idUsuario int  
 )  
  
 create table #marcas  
 (  
  idMarca int  
 )  
  
 create table #productos  
 (  
  idProducto int  
 )  
  
 create table #competenciaPrimaria  
 (  
  idMarcaComp int  
 )  
  
 create table #vendedores  
 (  
  idVendedor int  
 )  
  
 create table #tipoRtm  
 (  
  idTipoRtm int  
 )  
  
 create table #Provincias  
 (  
  idProvincia int  
 )  
  
 create table #Tags  
 (  
  IdTag int  
 )  
 create table #Familia  
 (  
  idFamilia int  
 )  
 create table #TipoPDV  
 (  
  idTipo int  
 )  
   
 create table #Clientes  
 (  
  idCliente int  
 )  
  
 create table #Cantidad_Bandejas  
 (  
  idCantidad_Bandeja int  
 )  
  
 declare @cMarcas varchar(max)  
 declare @cProductos varchar(max)  
 declare @cCadenas varchar(max)  
 declare @cZonas varchar(max)  
 declare @cLocalidades varchar(max)  
 declare @cUsuarios varchar(max)  
 declare @cPuntosDeVenta varchar(max)  
 declare @cCompetenciaPrimaria varchar(max)  
 declare @cVendedores varchar(max)  
 declare @cTipoRtm varchar(max)  
 declare @cProvincias varchar(max)  
 declare @cTags varchar(max)  
 declare @cFamilia varchar(max)  
 declare @cTipoPDV varchar(max)  
 declare @cClientes varchar(max)  
 declare @cCantidad_Bandejas varchar(max)  
  
 insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''    
  
 insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''  
 set @cMarcas = @@ROWCOUNT  
  
 insert #Cantidad_Bandejas (idCantidad_Bandeja) select clave as idCantidad_Bandeja from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCantidad_Bandeja'),',') where isnull(clave,'')<>''  
 set @cCantidad_Bandejas = @@ROWCOUNT  
   
 insert #productos (idproducto) select clave as idproducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProductos'),',') where isnull(clave,'')<>''  
 set @cProductos = @@ROWCOUNT  
   
 insert #cadenas (idCadena) select clave as idCadena from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCadenas'),',') where isnull(clave,'')<>''  
 set @cCadenas = @@ROWCOUNT  
  
 insert #zonas (idZona) select clave as idZona from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltZonas'),',') where isnull(clave,'')<>''  
 set @cZonas = @@ROWCOUNT  
  
 insert #localidades (idLocalidad) select clave as idLocalidad from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltLocalidades'),',') where isnull(clave,'')<>''  
 set @cLocalidades = @@ROWCOUNT  
  
 insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''  
 set @cUsuarios = @@ROWCOUNT  
  
 insert #puntosdeventa (idPuntoDeVenta) select clave as idPuntoDeVenta from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPuntosDeVenta'),',') where isnull(clave,'')<>''  
 set @cPuntosDeVenta = @@ROWCOUNT  
  
 insert #competenciaPrimaria (idMarcaComp) select clave as idMarcaComp from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''  
 set @cCompetenciaPrimaria = @@ROWCOUNT  
  
 insert #vendedores (idVendedor) select clave as idVendedor from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltVendedores'),',') where isnull(clave,'')<>''  
 set @cVendedores = @@ROWCOUNT  
  
 insert #tipoRtm (idTipoRtm) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoDeRTM'),',') where isnull(clave,'')<>''  
 set @cTipoRtm = @@ROWCOUNT  
  
 insert #Provincias (idProvincia) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProvincias'),',') where isnull(clave,'')<>''  
 set @cProvincias = @@ROWCOUNT  
  
 insert #Tags (IdTag) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTags'),',') where isnull(clave,'')<>''  
 set @cTags = @@ROWCOUNT  
   
 insert #Familia (IdFamilia) select clave as idFamilia from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFamilia'),',') where isnull(clave,'')<>''  
 set @cFamilia = @@ROWCOUNT  
   
 insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''  
 set @cTipoPDV = @@ROWCOUNT  
   
 insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''  
 set @cClientes = @@ROWCOUNT  
   
 if @cClientes = 0   
 begin  
  insert #clientes(idCliente)   
  select fc.idCliente from familiaClientes fc  
  where familia in (select familia from familiaClientes where idCliente = @idCliente  
         and activo = 1)  
  if @@rowcount = 0  
  BEGIN  
   insert #clientes(idcliente)  
   values ( @idCliente)   
  END  
 end  
   
 select @strFDesde = fecha from #fechaCreacionReporte where id = 2  
 select @strFHasta = fecha from #fechaCreacionReporte where id = 3  
  
 if(@strFDesde='00010101' or @strFDesde is null)  
  set @fechaDesde = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)  
 else  
  select @fechaDesde=fecha from #fechaCreacionReporte where id = 2  
  
 if(@strFHasta='00010101' or @strFHasta is null)  
  set @fechaHasta = getdate()  
 else  
  select @fechaHasta =  fecha from #fechaCreacionReporte where id = 3  
  
 -------------------------------------------------------------------- END (Tablas de trabajo) ----------------------------------------------------------------  
  create table #tempReporte  
 (  
  idPuntoDeVenta int,  
  mes varchar(8),  
  idReporte int,  
  usuario varchar(200),  
  direccion  varchar(200),  
  pdv  varchar(200),  
  localidad  varchar(200),  
  idzona  int  
 )  
   
   
  
  -------------------------------------------------------------------- END (Tablas de trabajo) ----------------------------------------------------------------  
   
insert #tempReporte (idPuntoDeVenta,mes,idReporte, usuario,direccion, pdv,localidad,idzona )  
select distinct r.idpuntodeventa,   
convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes,
---r.fechacreacion,  
max(r.idreporte),   
ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default,   
ltrim(rtrim(pdv.direccion)),  
pdv.nombre,  
l.nombre,  
pdv.idzona 
from MD_ReporteModuloItem rmi
	inner join Reporte r on r.IdReporte = rmi.IdReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Usuario u on u.idUsuario = r.idUsuario
	inner join Localidad l on l.idLocalidad = pdv.idLocalidad
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and isnull(u.escheckpos,0) = 0
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
group by r.idpuntodeventa, r.IdEmpresa, ltrim(rtrim(u.nombre)),ltrim(rtrim(u.apellido)),
ltrim(rtrim(pdv.direccion)),pdv.nombre, l.nombre, pdv.idzona,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
 
 

  
   
 create table #datosFinal_valor1
 (  
  id int identity(1,1),  
  idpdv int,
  fecha varchar(10),  
  usuario varchar(100),  
  pdv varchar(200),  
  direccion varchar(100),  
  localidad  varchar(200),  
  zona  varchar(200),  
  Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE varchar(2),
  Productos_ARSA_precio_segun_ubicacion varchar(2),
  Comunicacion_de_marca_con_POP varchar(2)
    
 )  
   
 ----- DATOS DE ENCUESTAS
 insert #datosFinal_valor1 (fecha,idpdv,usuario,pdv,direccion,localidad,zona, Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE, Productos_ARSA_precio_segun_ubicacion, 
 Comunicacion_de_marca_con_POP )  
 select   
 r.mes as fecha, 
 r.idPuntoDeVenta, 
 r.usuario,  
 ltrim(rtrim(r.pdv)),  
 r.direccion,
 r.localidad,
 z.nombre, 
case when exists (select 1 from md_reporteModuloItem where idItem in (11108,11160) and idReporte = r.idReporte and valor1> 0) then 'SI' else 'NO' end,---Las 3 Categorías de ARSA, en simultáneo, están al lado de DANONE? (SI/NO)
case when exists (select 1 from md_reporteModuloItem where idItem in (11109,11161) and idReporte = r.idReporte and valor1> 0) then 'SI' else 'NO' end,---Todos los Productos de ARSA tienen correctamente comunicado su precio en el fleje según ubicación
case when exists (select 1 from md_reporteModuloItem where idItem in (11110,11162) and idReporte = r.idReporte and valor1> 0) then 'SI' 
when exists (select 1 from md_reporteModuloItem where idItem in (11110,11162) and idReporte = r.idReporte and valor3> 0) then 'NA' else 'NO'end	--En cualquiera de las 3 Categorías de ARSA hay al menos 1 comunicación de marca con POP? NA (No Aplic
FROM #tempReporte r 
inner join zona z on z.idzona = r.idzona 
group by r.mes,r.idPuntoDeVenta,r.usuario,ltrim(rtrim(r.pdv)), r.direccion,r.localidad, z.nombre,idReporte


 
 create table #datosFinal_arsa
 (  
  id int identity(1,1),  
  idpdv int,
  fecha varchar(10),  
  usuario varchar(100),  
  pdv varchar(200),  
  direccion varchar(100),  
  localidad  varchar(200),  
  zona  varchar(200),   
  Productos_ARSA_con_vencimiento_menor_a_8_dias int
    
    
 )  
   
 -----Cuántos productos exclusivos de ARSA tienen fecha de vencimiento menor a 8 días?
 insert #datosFinal_arsa (fecha,idpdv,usuario,pdv,direccion,localidad,zona,Productos_ARSA_con_vencimiento_menor_a_8_dias)  
 select   
 r.mes as fecha, 
 r.idPuntoDeVenta, 
 r.usuario,  
 ltrim(rtrim(r.pdv)),  
 r.direccion,  
 r.localidad,  
 z.nombre,     
 SUM(case when rmi.Valor4 not like '%[^0-9]%' then convert(int,rmi.Valor4) else 0 end) AS ARSA  
 from MD_ReporteModuloItem rmi  
 inner join #tempReporte r on r.IdReporte = rmi.IdReporte  
 inner join MD_Item mi on mi.idItem = rmi.idItem  
 inner join zona z on z.idzona = r.idzona  
 where rmi.IdItem in (11111,11163)
 and mi.idmodulo in (2422,2431)
 group by mi.nombre,r.idPuntoDeVenta,r.pdv,r.mes,r.usuario,r.direccion,r.localidad,z.nombre  
 
 ---select  * from #datosFinal_arsa
 
 create table #valores_final  
 (  
  id int identity(1,1),  
  fecha varchar(10),  
  usuario varchar(100),
  id_pdv int,  
  pdv varchar(200),  
  direccion varchar(100),  
  localidad  varchar(200),  
  zona  varchar(200),  
  Productos_ARSA_con_vencimiento_menor_a_8_dias int,  
  Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE varchar(2),
  Productos_ARSA_precio_segun_ubicacion varchar(2),
  Comunicacion_de_marca_con_POP varchar(2)
    
    
 )  
   insert into #valores_final (fecha,usuario,pdv,direccion,localidad,zona,Productos_ARSA_con_vencimiento_menor_a_8_dias,
   Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE,Productos_ARSA_precio_segun_ubicacion,Comunicacion_de_marca_con_POP)
   select distinct a.fecha,a.usuario,a.pdv,a.direccion,a.localidad,a.zona,isnull(a.Productos_ARSA_con_vencimiento_menor_a_8_dias,0), c.Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE, 
   c.Productos_ARSA_precio_segun_ubicacion,
   c.Comunicacion_de_marca_con_POP
   from #datosFinal_arsa a
   left join #datosFinal_valor1 c on  c.idpdv = a.idpdv and c.fecha= a.fecha and a.usuario = c.usuario
   group by a.fecha,a.usuario,a.pdv,a.direccion,a.localidad,a.zona,isnull(a.Productos_ARSA_con_vencimiento_menor_a_8_dias,0),
   c.Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE,c.Productos_ARSA_precio_segun_ubicacion,
   c.Comunicacion_de_marca_con_POP
 
 ---select  * from #valores_final
 
 --Cantidad de páginas  
 declare @maxpag int  
   
 if(@TamañoPagina=0)  
  set @maxpag=1  
 else  
  select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #valores_final
   
 select @maxpag  
   
 --Configuracion de columnas  
   
 create table #columnasConfiguracion  
 (  
  name varchar(50),  
  title varchar(50),  
  width int,  
  orden int  
    
 )  
   
 if(@lenguaje='es')  
  insert #columnasConfiguracion (name, title, width,orden) values   
  ('fecha','fecha',5,1),('usuario','usuario',5,2),('pdv','pdv',5,3),  
  ('direccion','direccion',5,4),('localidad','localidad',5,5),  
  ('zona','zona',5,6), ('Productos_ARSA_con_vencimiento_menor_a_8_dias','Productos_ARSA_con_vencimiento_menor_a_8_dias',5,7),
  ('Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE','Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE',5,9),
  ('Productos_ARSA_precio_segun_ubicacion','Productos_ARSA_precio_segun_ubicacion',5,10),
  ('Comunicacion_de_marca_con_POP','Comunicacion_de_marca_con_POP',5,11)
	
 if(@lenguaje='en')  
  insert #columnasConfiguracion (name, title, width,orden) values   
     ('fecha','fecha',5,1),('usuario','usuario',5,2),('pdv','pdv',5,3),  
  ('direccion','direccion',5,4),('localidad','localidad',5,5),  
  ('zona','zona',5,6), ('Productos_ARSA_con_vencimiento_menor_a_8_dias','Productos_ARSA_con_vencimiento_menor_a_8_dias',5,7),
  ('Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE','Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE',5,9),
  ('Productos_ARSA_precio_segun_ubicacion','Productos_ARSA_precio_segun_ubicacion',5,10),
  ('Comunicacion_de_marca_con_POP','Comunicacion_de_marca_con_POP',5,11)
  
 select name, title, width,orden from #columnasConfiguracion order by orden, name  
   
 ----Datos  
 if(@NumeroDePagina>0)  
  select fecha,usuario,pdv,direccion,localidad,zona,Productos_ARSA_con_vencimiento_menor_a_8_dias,
   Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE,Productos_ARSA_precio_segun_ubicacion,Comunicacion_de_marca_con_POP
  from #valores_final where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
  order by pdv
   
 if(@NumeroDePagina=0)  
    select fecha,usuario,pdv,direccion,localidad,zona,Productos_ARSA_con_vencimiento_menor_a_8_dias,
   Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE,Productos_ARSA_precio_segun_ubicacion,Comunicacion_de_marca_con_POP
  from #valores_final where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)  
  order by pdv
  
 if(@NumeroDePagina<0)  
  select fecha,usuario,pdv,direccion,localidad,zona,Productos_ARSA_con_vencimiento_menor_a_8_dias,
   Las_3_Cat_ARSA_que_estan_al_lado_de_DANONE,Productos_ARSA_precio_segun_ubicacion,Comunicacion_de_marca_con_POP
  from #valores_final
  order by pdv
   
end  
go