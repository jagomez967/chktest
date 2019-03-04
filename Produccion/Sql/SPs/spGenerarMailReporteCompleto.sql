
if not exists(select * from sys.database_principals where name = 'Checkpos_Files2')
	CREATE USER Checkpos_Files2 FROM LOGIN [WS1\CheckPosAdminHernan]
GO


alter procedure spGenerarMailReporteCompleto
(
	@IdReporte int,
	@IdAlerta int
)
with execute as 'Checkpos_Files2'
as
begin
	set nocount on

	--Declaraciones
	declare @DatosGenerales varchar(max)
	declare @IdMarca int
	declare @MarcaNombre varchar(100)
	declare @IdEmpresa int
	declare @IdCliente int
	declare @IdDina int --para mod dinamicos
	declare @FilaModDina varchar(max)--para mod dinamicos
	declare @IdModuloDina int--para mod dinamicos
	declare @idExhibicion int
	declare @FilaExhibicion varchar(max)
	declare @idPop int
	declare @FilaPop varchar(max)
	declare @idProductos int
	declare @FilaProductos varchar(max)
	declare @idProductosComp int
	declare @FilaProductosComp varchar(max)
	declare @idMantenimiento int
	declare @FilaMantenimiento varchar(max)
	declare @ReporteMarcaHtml varchar(max)
	declare @IdReporteFila varchar(max)
	declare @FilaReporte varchar(max)
	declare @MailFrom varchar(100)
	declare @MailSubject varchar(200)
	declare @MailBody varchar(max)
	declare @MailHeader varchar(max)
	declare @MailFooter varchar(max)
	declare @idPuntoDeVenta int
	declare @FilaModuloDinamico varchar(max)
	declare @flgExhibiciones bit=0
	declare @flgPop bit=0
	declare @flgProducto bit=0
	declare @flgProductoComp bit=0
	declare @flgMantenimiento bit=0
	declare @flgModDina bit=0
	declare @ProductosColumnas varchar(max)
	declare @ProductosCompColumnas varchar(max)
	declare @idModDinaFila int
	declare @FilaModuloDinamicoCab varchar(max)
	declare @FilaModuloDinamicoDet varchar(max)
	declare @PdvNombre varchar(max)
	declare	@CadenaNombre varchar(max)
	declare	@PdvId varchar(max)
	declare	@PdvDireccion varchar(max)
	declare	@LocalidadNombre varchar(max)
	declare	@RTM varchar(max)
	declare @tienedatos int
	declare @cantFotos int
	declare @seccionmodulo varchar(max)
	declare @modulotienedatos int
	declare @muestroseccion bit
	declare @PdvCodigoAdicional varchar(max)
	Declare @FirmaAdjunta varchar(2000)
	DECLARE @pdvRazonSocial varchar(200)
	declare @Descripcion varchar(200) = ''
	--Variables Grales
	select top 1 @IdCliente = C.IdCliente, @IdEmpresa = isnull(C.IdEmpresa,R.idEmpresa), @idPuntoDeVenta = IdPuntoDeVenta from Cliente C
	inner join Empresa E on E.IdEmpresa = C.IdEmpresa
	inner join Reporte R on R.IdEmpresa = E.IdEmpresa
	where R.IdReporte = @idReporte


	--Datos Generales
	select top 1
			@PdvNombre = PDV.Nombre
			,@CadenaNombre = C.Nombre
			,@PdvId = PDV.IdPuntoDeVenta
			,@PdvDireccion = PDV.direccion
			,@LocalidadNombre = L.Nombre
			,@RTM = U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT
			,@pdvCodigoAdicional = isnull(pdv.codigoAdicional,'') collate database_default
			,@pdvRazonSocial = isnull(pdv.RazonSocial,'') collate database_default
	from Reporte R
	inner join PuntoDeVenta PDV on PDV.idPuntoDeVenta = R.idPuntoDeVenta
	left join Cadena C on C.idCadena = PDV.idCadena
	left join Localidad L on L.idLocalidad = PDV.idLocalidad
	left join Usuario U on U.idUsuario = R.idUsuario
	inner join Cliente Cl  on Cl.IdEmpresa = R.IdEmpresa
	where R.idReporte = @idReporte

	set @MailFrom = 'noreply@checkpos.com'

	set @MailHeader = '<!DOCTYPE html>'
	set @MailHeader = @MailHeader + '<html><head><title>Informe de Reporte</title><meta charset="utf-8">'
	set @MailHeader = @MailHeader + '<style type="text/css">'
	set @MailHeader = @MailHeader + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	set @MailHeader = @MailHeader + 'body{height: 100%;width: 100%;padding:20px;}'
	set @MailHeader = @MailHeader + 'h1{color: #ffffff;padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.container{width: 100%;height: 100%;}'
	set @MailHeader = @MailHeader + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'
	if (@idCliente = 98 or @idEmpresa =537)
	BEGIN
		set @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 10px 50px 30px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	END
	else
	BEGIN
		set @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'	
	END
	set @MailHeader = @MailHeader + 'h3{padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'h4{padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'h2{color:#FDA515;padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'p{padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}'
	set @MailHeader = @MailHeader + 'table{border-collapse: collapse;width: 100%;background:#ffffff;margin:0;padding:0;}'
	set @MailHeader = @MailHeader + 'th, td{text-align: left;padding: 8px;}'
	set @MailHeader = @MailHeader + 'tr:nth-child(even){background-color: #f2f2f2}'
	set @MailHeader = @MailHeader + '</style>'
	set @MailHeader = @MailHeader + '</head>'
	set @MailHeader = @MailHeader +  '<body><div class="container">'

	set @MailBody = ''
	set @MailBody = @MailBody + '<div class="header">'
	set @MailBody = @MailBody + '<h1>Informe de Reporte</h1>'
	set @MailBody = @MailBody + '<h2>#'+cast(@idReporte as varchar)+'</h2>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Reporte: </strong>'+ltrim(rtrim(str(@idReporte)))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Cadena: </strong>'+ltrim(rtrim(isnull(@CadenaNombre,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Punto de Venta: </strong>'+ltrim(rtrim(isnull(@PdvNombre,'')))+'</p>'
	if (@idCliente = 98 or @idEmpresa =537)
	BEGIN
		set @MailBody = @MailBody + '<p><strong>Codigo Cliente: </strong>'+ltrim(rtrim(isnull(@PdvCodigoAdicional,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Razon Social: </strong>'+ltrim(rtrim(isnull(@PdvRazonSocial,'')))+'</p>'
	END
	set @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>'+ltrim(rtrim(isnull(@PdvDireccion,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Localidad: </strong>'+ltrim(rtrim(isnull(@LocalidadNombre,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>'+ltrim(rtrim(isnull(@RTM,'')))+'</p>'
	set @MailBody = @MailBody + '</div>'

	set @MailSubject = 'Informe Consolidado: Reporte Completo' --'Informe de Reporte #' + ltrim(rtrim(str(@idreporte))) + '  [PDV: ' + LTRIM(rtrim(str(isnull(@PdvId,0)))) + ' - ' + LTRIM(rtrim(isnull(@PdvNombre,''))) + ']'

	select @Descripcion = descripcion from alertas where id = @IdAlerta
	and len(descripcion) < 150
	
	if (isnull(@Descripcion,'') != '')
	BEGIN
		set @MailSubject = @Descripcion + ' - ' + @MailSubject
	END
		

	create table #ModulosDinamicos
	(
		idmodulo int,
		descripcion varchar(500)
	)

	--Busco las marcas del reporte:
	create table #Marcas
	(
		idMarca int,
		Nombre varchar(100)
	)

	insert #Marcas
	SELECT M.IdMarca as IdMarca
		  ,M.Nombre as Nombre
    FROM Marca M
	inner join Reporte R on R.IdEmpresa = M.IdEmpresa
    WHERE	R.IdReporte = @idReporte
			AND M.Reporte = 1


	--Por cada marca tengo que armar las tablas
	While exists(Select * From #Marcas)
	Begin

		Select Top 1 @IdMarca = IdMarca, @MarcaNombre = isnull(Nombre,'') From #Marcas order by idMarca

		set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h2>'+ltrim(rtrim(isnull(@MarcaNombre,'')))+'</h2>'

		--Exhibiciones
		declare @seccion varchar(max)=''

		set @seccion = @seccion + '<hr />'
		SELECT  '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion,M.Descripcion))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND ( 98 = MC.IdCliente))
		where M.IdModulo = 2
		ORDER BY  M.[IdModulo]

		set @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr><th>Nombre</th><th>Cantidad</th></tr></thead><tbody>'

		select @seccion=@seccion+'<tr><td>' + ltrim(rtrim(isnull(E.Nombre,''))) + '</td><td>' + ltrim(rtrim(str(isnull(RE.Cantidad,0)))) + '</td></tr>'
		from ReporteExhibicion RE
		inner join Exhibidor E on E.IdExhibidor = RE.IdExhibidor
		where	RE.IdReporte = @idReporte
				and RE.IdMarca = @IdMarca
				and RE.Cantidad>0
		order by E.Nombre, RE.Cantidad
		set @tienedatos=@@rowcount

		set @seccion = @seccion + '</tbody></table>'

		if(@tienedatos>0)
		begin
			set @MailBody = @MailBody + @seccion
		end
		set @seccion = ''
		


		--Pop
		set @seccion = @seccion + '<hr />'
		SELECT '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion,M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND ( 89 = MC.IdCliente))
		where M.IdModulo = 5
		ORDER BY  M.[IdModulo]

		set @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr> <th></th><th>Cantidad</th></tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre,''))) + '</td><td>' + ltrim(rtrim(str(isnull(RP.Cantidad,0)))) + '</td></tr>'
		FROM Pop P 
		LEFT JOIN ReportePop RP ON (RP.IdReporte = @idReporte and RP.IdMarca = @IdMarca and RP.IdPop = P.IdPop)        
		INNER JOIN POP_Marca PM ON (PM.IdMarca = @IdMarca and P.IdPop = PM.IdPop)
		where RP.IdPop is not null and RP.Cantidad>0
		ORDER BY P.Nombre, RP.Cantidad
		set @tienedatos=@@rowcount

		set @seccion = @seccion + '</tbody></table>'
		
		if(@tienedatos>0)
		begin
			set @MailBody = @MailBody + @seccion
		end
		set @seccion = ''

	

		--Productos
		set @seccion = @seccion + '<hr />'

		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion,M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND ( @IdCliente = MC.IdCliente))
		where M.IdModulo = 3
		ORDER BY  M.[IdModulo]



		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion,M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND ( @IdCliente = MC.IdCliente))
		where M.IdModulo = 3
		ORDER BY  M.[IdModulo]

		set @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr>'
		set @seccion = @seccion + '<th>Producto</th>'
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 7-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 3--and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 5--and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 12-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 10--and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 16-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 14-- and isnull(MMC.Visibilidad,0)=1
		set @seccion = @seccion + '</tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre,''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(str(RP.Precio),''))) + '</td>'
			  + '<td>' + ltrim(rtrim((case when isnull(RP.Stock,1) = 1 then 'SI' else '' end))) + '</td>'
			  + '<td>' + ltrim(rtrim((case when isnull(RP.NoTrabaja,0)=1 then 'NO' else '' end))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(E1.Nombre,''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(str(RP.Cantidad),''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(E2.Nombre,''))) + '</td>'
 			  + '<td>' + ltrim(rtrim(isnull(str(RP.Cantidad2),''))) + '</td></tr>'
		FROM Producto P 	
		LEFT JOIN ReporteProducto RP ON (RP.[IdReporte] = @idReporte and P.IdProducto = RP.IdProducto)
		inner join Marca M on M.IdMarca = P.IdMarca
		left join Exhibidor E1 on E1.IdExhibidor = RP.IdExhibidor
		left join Exhibidor E2 on E2.IdExhibidor = RP.IdExhibidor2
		WHERE P.IdMarca=@IdMarca  and P.Reporte=1
				and (isnull(RP.Cantidad,0)>0
					or isnull(RP.Cantidad2,0)>0
					or isnull(RP.Stock,0)=1
					or isnull(RP.NoTrabaja,0)=1
					or isnull(RP.Precio,0)>0)
		order by P.Nombre, RP.Stock desc, RP.NoTrabaja desc
		set @tienedatos=@@rowcount

		set @seccion = @seccion + '</tbody></table>'
		
		if(@tienedatos>0)
		begin
			set @MailBody = @MailBody + @seccion
		end
		set @seccion = ''

		--ProductosCompetencia
		set @seccion = @seccion + '<hr />'
		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion,M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND ( @IdCliente = MC.IdCliente))
		where M.IdModulo = 4
		ORDER BY  M.[IdModulo]

		set @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr>'
		set @seccion = @seccion + '<th>Producto</th>'
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 4 and MMC.IdModuloItem = 18-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 4 and MMC.IdModuloItem = 22-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 4 and MMC.IdModuloItem = 20-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 4 and MMC.IdModuloItem = 26-- and isnull(MMC.Visibilidad,0)=1
		select @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>' from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 4 and MMC.IdModuloItem = 24-- and isnull(MMC.Visibilidad,0)=1
		set @seccion = @seccion + '</tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre,''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(str(RPC.Precio),''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(E1.Nombre,''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(str(RPC.Cantidad),''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(E2.Nombre,''))) + '</td>'
			  + '<td>' + ltrim(rtrim(isnull(str(RPC.Cantidad2),''))) + '</td></tr>'
		FROM Producto P 	
		LEFT JOIN ReporteProductoCompetencia RPC ON (RPC.IdReporte = @idReporte and RPC.IdProducto = P.IdProducto and (RPC.IdMarca IS NULL OR RPC.IdMarca = @IdMarca))
		INNER JOIN ProductoCompetencia PC ON (P.IdProducto=PC.IdProductoCompetencia AND (ISNULL(PC.Reporte,1) = 1 OR NOT RPC.IdProducto IS NULL)) 
		INNER JOIN Producto P2 ON (P2.IdProducto = PC.IdProducto and P2.IdMarca = @IdMarca)
		INNER JOIN Marca M ON P.IdMarca=M.IdMarca 
		INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
		left join Exhibidor E1 on E1.IdExhibidor = RPC.IdExhibidor
		left join Exhibidor E2 on E2.IdExhibidor = RPC.IdExhibidor2
		where isnull(RPC.Cantidad,0)>0 or isnull(RPC.Cantidad2,0)>0 or isnull(RPC.Precio,0)>0
		ORDER BY E.Nombre, P.Nombre
		set @tienedatos=@@rowcount

		set @seccion = @seccion + '</tbody></table>'
		
		if(@tienedatos>0)
		begin
			set @MailBody = @MailBody + @seccion
		end
		set @seccion = ''



		--Mantenimiento
		set @seccion = @seccion + '<hr />'
		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion,M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND ( @IdCliente = MC.IdCliente))
		where M.IdModulo = 6
		ORDER BY  M.[IdModulo]

		set @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr><th>Material</th><th>Estado</th><th>Observaciones</th></tr></thead><tbody>'
		
		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(MM.Nombre,''))) + '</td>' + 
				+ '<td>' + ltrim(rtrim(isnull(ME.Estado,''))) + '</td>' + 
				+ '<td>' + ltrim(rtrim(isnull(RM.Observaciones,''))) + '</td></tr>'
		FROM [MantenimientoMaterial] MM	 
		INNER JOIN MantenimientoMaterial_Marca MMM ON (MM.[IdMantenimientoMaterial] = MMM.[IdMantenimientoMaterial] AND MMM.IdMarca=@IdMarca)
		LEFT JOIN [ReporteMantenimiento] RM ON (RM.IdReporte = @idReporte AND RM.IdMarca = @IdMarca AND RM.[IdMantenimientoMaterial] = MM.[IdMantenimientoMaterial])
		LEFT JOIN MantenimientoEstado ME ON (ME.IdMantenimientoEstado = RM.IdMantenimientoEstado)
		where RM.IdReporteMantenimiento is not null
		order by MM.Nombre
		set @tienedatos=@@rowcount

		set @seccion = @seccion + '</tbody></table>'
		
		if(@tienedatos>0)
		begin
			set @MailBody = @MailBody + @seccion
		end
		set @seccion = ''


		--Módulo Dinámico
		set @seccion = @seccion + '<hr />'
		--Por cada modulo dinamico armo una tabla
		SELECT @seccion = @seccion + '<h3>Módulos Dinámicos</h3>'

		insert #ModulosDinamicos (idModulo, descripcion)
		SELECT M.idmodulo, ltrim(rtrim(ISNULL(M.Descripcion,M.Nombre)))
		FROM [dbo].[MD_ModuloMarca] MM
		INNER JOIN [dbo].[MD_Modulo] M ON (MM.IdModulo = M.IdModulo)	
		WHERE @IdMarca = MM.[IdMarca] AND MM.[Activo]=1 
		ORDER BY MM.Orden
		set @tienedatos=@@rowcount

		--por cada modulo tengo que armar una tabla

		declare @currentidmodulo int
		select @seccionmodulo = ''

		while (exists(select 1 from #ModulosDinamicos))
		begin
			select top 1 @currentidmodulo = idmodulo from #ModulosDinamicos
			
			SELECT @seccionmodulo = @seccionmodulo + ' <h4><em>' + ltrim(rtrim(ISNULL(descripcion,''))) + '</em></h4>' from #ModulosDinamicos where idmodulo = @currentidmodulo

			set @seccionmodulo = @seccionmodulo + '<table bgcolor="#ffffff"><thead><tr><th>Item</th><th></th><th></th><th></th><th></th></tr></thead><tbody>'

			SELECT	@seccionmodulo = @seccionmodulo + '<tr><td>' + ltrim(rtrim(isnull(MI.Nombre,''))) + '</td>' +
					'<td>' + case when isnull(RM.Valor1,0)=1 then ltrim(rtrim(isnull(MI.LabelCampo1,''))) else '' end + '</td>' +
					'<td>' + case when isnull(RM.Valor2,0)=1 then ltrim(rtrim(isnull(MI.LabelCampo2,''))) else '' end + '</td>' +
					'<td>' + case when isnull(RM.valor3,0)=1 then ltrim(rtrim(isnull(MI.LabelCampo3,''))) else '' end + '</td>' +
					'<td>' + ltrim(rtrim(isnull(RM.Valor4,''))) + '</td></tr>'
			FROM MD_Item MI
			LEFT JOIN MD_ReporteModuloItem RM ON (MI.IdItem = RM.IdItem)
			LEFT JOIN MD_ModuloMarcaItem MMI ON (MI.IdItem = MMI.IdItem AND RM.idMarca = MMI.IdMarca)
			WHERE	MMI.Activo=1 and MI.Activo=1 and MI.IdModulo=@currentidmodulo
					and (isnull(RM.Valor1,0)=1 or isnull(RM.Valor2,0)=1 or isnull(RM.Valor3,0)=1 or isnull(RM.Valor4,'')<>'')
					and @idReporte = RM.IdReporte
					and @IdMarca = RM.IdMarca
			ORDER BY MI.Orden
			set @modulotienedatos = @@rowcount

			set @seccionmodulo = @seccionmodulo + '</tbody></table>'

			if(@modulotienedatos>0)
			begin
				set @muestroseccion = 1
				set @seccion = @seccion + @seccionmodulo
			end

			set @seccionmodulo = ''
			set @modulotienedatos = 0

			delete from #ModulosDinamicos where idmodulo = @currentidmodulo
		end
		
		if(@tienedatos>0 and @muestroseccion=1)
		begin
			set @MailBody = @MailBody + @seccion
		end
		set @seccion = ''
		set @muestroseccion = 0
		--------------------------------------------------------------------------------------------------------------------------------

		--listo, proxima marca
		set @MailBody = @MailBody + '</div>'
	
		Delete #Marcas Where idMarca = @IdMarca
	End
	


	declare @leyendatag varchar(max)
	declare @idPuntodeventaFoto int

	/* Fotos */
		select @cantFotos = count(*) from puntodeventafoto where idreporte = @IdReporte

		--set @seccion = @seccion + '<hr />'
		set @seccion = @seccion + '<h3>Fotos</h3><h6>Se cargaron ' + ltrim(rtrim(str(isnull(@cantFotos,0)))) + ' en el reporte</h6>'

		--set @seccion = @seccion + '<table bgcolor="#ffffff"><tbody><tr>'
		
		DECLARE foto_cursor CURSOR FOR
		Select f.idPuntodeventaFoto
		FROM puntodeventafoto f
		where f.idReporte = @idReporte

		set @tienedatos=@@rowcount

		OPEN foto_cursor
		
		FETCH NEXT FROM foto_cursor
		INTO @idPuntoDeVentaFoto

		WAITFOR DELAY '000:00:02'

		while @@FETCH_STATUS = 0
		BEGIN
		
			SELECT @seccion = @seccion + '<a style="text-decoration:none;color:black;" href="https://login.checkpos.com/1/Fotos_2/'+ ltrim(rtrim(str(f.idEmpresa))) +'/'+ ltrim(rtrim(str(f.IdPuntoDeVentaFoto))) +'.jpg"><img src="https://login.checkpos.com/1/Fotos_2/'+ ltrim(rtrim(str(f.idEmpresa))) +'/'+ ltrim(rtrim(str(f.IdPuntoDeVentaFoto))) +'.jpg" alt="Foto de Reporte" style="margin:1px;" width="150">'
			from puntodeventafoto f
			where f.idPuntodeventafoto = @idPuntodeventafoto

		
			select @seccion = @seccion + '<div>' + isnull(f.comentario,'') + '</div>' 
			from puntodeventafoto f
			where f.idPuntodeventafoto = @idPuntodeventafoto

			if exists(select 1 from imagenestags t 
						where t.idImagen = @idPuntodeventafoto)
			BEGIN
				select @seccion = @seccion + '<h5><u>TAGS: </u><ul>'
			
				DECLARE tag_cursor CURSOR FOR   
				SELECT t.leyenda  
				FROM tags t
				inner join imagenestags it on it.idTag = t.idTag
				where it.idImagen = @idPuntodeventafoto


				OPEN tag_cursor

				FETCH NEXT FROM tag_cursor
				INTO @leyendaTag

				while @@FETCH_STATUS = 0
				BEGIN
					select @seccion = @seccion + '<li style="display:inline;border-style:double;">' +' '+ isnull(@leyendaTag,'') + ' </li>'

					FETCH NEXT FROM tag_cursor
					INTO @leyendaTag
				END

				close tag_cursor;
				deallocate tag_cursor;

				select @seccion = @seccion + '</ul></h5>'

			END

			select @seccion = @seccion + '</a>'

			FETCH NEXT FROM foto_cursor
			INTO @idPuntoDeVentaFoto
		END

		close foto_cursor;
		deallocate foto_cursor;

		--set @seccion = @seccion + '</tr></tbody></table>'
		
		if(@tienedatos>0 And @cantFotos > 0)
		begin
			set @MailBody = @MailBody + '<div class="data">'
			set @MailBody = @MailBody + @seccion
			set @MailBody = @MailBody + '</div>'
		end

		set @MailBody = @MailBody +'<div class="hiddenFoto"></div>'
	/* ---------------------------- */

	/* Firma */

		--set @seccion = @seccion + '<hr />'
		set @seccion = @seccion + '<h3>Firma</h3>'

		--set @seccion = @seccion + '<table bgcolor="#ffffff"><tbody><tr>'
		
		--SELECT @seccion = @seccion + '<img src="data:image/png;base64, '+ltrim(rtrim(firma))+'" alt="Firma de Reporte" style="margin:10px;" max-width="400">'
		--from reporte
		--where idreporte = @idreporte and firma is not null
		
		--Por alguna razon al llamar al sp de generar firma no me deja permisos para crear archivos. Lo itento desde aca
		--exec sp_generarFirma @idReporte
		---------------------------------------------------
		declare @basePath varchar(max)
		declare @folderName varchar(max)
		declare @imageFilename varchar(max)
		declare @serverName varchar(max)
		--declare @idReporte int
		declare @firma varchar(max)

		set @basePath = 'C:\Users\CheckPosAdminHernan\Documents'
		set @folderName = 'resultsDB'
		set @serverName = 'localhost'



		declare @cmd varchar(2000)
		declare @cmdaux varchar(2000)

		DECLARE @output INT

		delete from FirmasJPG
	
		set @imageFileName = 'firma_'+CAST(@idReporte as varchar)+'.jpg'
	

	
		select @cmd = 'del /q /f ' + @basePath + '\' + @folderName + '\' + @imageFileName	
	--	select @cmd

		select @cmdAux = 'DIR "'+ @basePath + '\' + @folderName + '\' + @imageFileName+'" /B'
		--select @cmdAux
		EXEC @output = XP_CMDSHELL @cmdAux
		IF @output = 1
		BEGIN
			  PRINT 'File Donot exists'
		END
		ELSE
		BEGIN
			exec master.sys.xp_cmdShell @cmd
			PRINT 'File exists'
		END


	
		 INSERT INTO FirmasJPG (PhotoBinary)
		 SELECT CAST(N'' AS xml).value('xs:base64Binary(sql:column("Firma"))', 'varbinary(max)')
				FROM reporte
				WHERE idReporte = @idReporte
			
		declare @command as varchar(2000)
		--SELECT TOP 100 PhotoBinary FROM checkPOS_unificada_final_2.dbo.FirmasJPG
		SET @command = 'bcp "SELECT TOP 1 PhotoBinary FROM checkPOS_unificada_final_2.dbo.FirmasJPG" queryout "' + @basePath + '\' + @folderName + '\' + @imageFileName + '"  -U checkposAle -P ch8_POS_9873_@* -S ' + @ServerName + ' -f "C:\Users\CheckPosAdminHernan\Documents\photobinary.fmt"';
		EXEC xp_cmdshell @command



		-----------------------------------------------------

		if exists(select 1 from reporte where idReporte = @idReporte and firma is not null)
		begin
			select @seccion = @seccion + '<img src="cid:firma_'+cast(@idReporte as varchar)+'.jpg" alt="Firma de Reporte" style="margin:4px; max-height: 100%; max-width: 100%;">'
			set @tienedatos=@@rowcount
		end
		else
		begin
			set @tienedatos=0
		end
		
		--set @seccion = @seccion + '</tr></tbody></table>'
		set @firmaAdjunta = ''

		if(@tienedatos>0)
		begin
			set @MailBody = @MailBody + '<div class="data" style="height: 120px; width: 120px;">'
			set @MailBody = @MailBody + @seccion
			set @MailBody = @MailBody + '</div>'
			set @FirmaAdjunta = 'C:\Users\CheckPosAdminHernan\Documents\resultsDB\firma_'+cast(@idReporte as varchar)+'.jpg'
		end
		set @seccion = ''	

		--HARDCODEEEEE

		/* ---------------------------- */




	--set @MailBody = @MailBody + '</div>'
	set @MailFooter = '</div></body></html>'

	if isnull(@MailFrom,'')<>'' and isnull(@MailBody,'')<>''
	begin
		insert EmpresaMail (IdReporte
								,IdAlerta
								,MailFrom
								,MailBody
								,MailSubject
								,MailHeader
								,MailFooter
								,MailAdjuntos
								,Autorizado
								,UsuarioAutorizacion
								,Enviado
								,FechaCreacion
								,FechaAutorizacion
								,FechaEnvio
								,ArchivoAdjunto)
		values(@idReporte
				,@IdAlerta
				,'noreply@checkpos.com'
				,@MailBody
				,@MailSubject
				,@MailHeader
				,@MailFooter
				,null
				,1
				,null
				,0
				,getdate()
				,getdate()
				,null
				,@FirmaAdjunta)
	end
end   
GO