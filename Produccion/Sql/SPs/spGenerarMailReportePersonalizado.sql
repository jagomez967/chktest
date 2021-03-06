SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailReportePersonalizado]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailReportePersonalizado] AS' 
END
GO
ALTER PROCEDURE [dbo].[spGenerarMailReportePersonalizado] (
	@IdReporte INT
	,@IdAlerta INT
	)
AS
BEGIN
	SET NOCOUNT ON

	--Declaraciones
	DECLARE @DatosGenerales VARCHAR(max)
	DECLARE @IdMarca INT
	DECLARE @MarcaNombre VARCHAR(100)
	DECLARE @IdEmpresa INT
	DECLARE @IdCliente INT
	DECLARE @IdDina INT --para mod dinamicos
	DECLARE @FilaModDina VARCHAR(max) --para mod dinamicos
	DECLARE @IdModuloDina INT --para mod dinamicos
	DECLARE @idExhibicion INT
	DECLARE @FilaExhibicion VARCHAR(max)
	DECLARE @idPop INT
	DECLARE @FilaPop VARCHAR(max)
	DECLARE @idProductos INT
	DECLARE @FilaProductos VARCHAR(max)
	DECLARE @idProductosComp INT
	DECLARE @FilaProductosComp VARCHAR(max)
	DECLARE @idMantenimiento INT
	DECLARE @FilaMantenimiento VARCHAR(max)
	DECLARE @ReporteMarcaHtml VARCHAR(max)
	DECLARE @IdReporteFila VARCHAR(max)
	DECLARE @FilaReporte VARCHAR(max)
	DECLARE @MailFrom VARCHAR(100)
	DECLARE @MailSubject VARCHAR(200)
	DECLARE @MailBody VARCHAR(max)
	DECLARE @MailHeader VARCHAR(max)
	DECLARE @MailFooter VARCHAR(max)
	DECLARE @idPuntoDeVenta INT
	DECLARE @FilaModuloDinamico VARCHAR(max)
	DECLARE @flgExhibiciones BIT = 0
	DECLARE @flgPop BIT = 0
	DECLARE @flgProducto BIT = 0
	DECLARE @flgProductoComp BIT = 0
	DECLARE @flgMantenimiento BIT = 0
	DECLARE @flgModDina BIT = 0
	DECLARE @ProductosColumnas VARCHAR(max)
	DECLARE @ProductosCompColumnas VARCHAR(max)
	DECLARE @idModDinaFila INT
	DECLARE @FilaModuloDinamicoCab VARCHAR(max)
	DECLARE @FilaModuloDinamicoDet VARCHAR(max)
	DECLARE @PdvNombre VARCHAR(max)
	DECLARE @CadenaNombre VARCHAR(max)
	DECLARE @PdvId VARCHAR(max)
	DECLARE @PdvDireccion VARCHAR(max)
	DECLARE @LocalidadNombre VARCHAR(max)
	DECLARE @RTM VARCHAR(max)
	DECLARE @tienedatos INT
	DECLARE @PdvCodigoAdicional VARCHAR(max)
	DECLARE @FirmaAdjunta VARCHAR(2000)
	DECLARE @pdvRazonSocial VARCHAR(200)

	CREATE TABLE #itemsAlerta (iditem INT)

	--Variables Grales
	SELECT TOP 1 @IdCliente = C.IdCliente
		,@IdEmpresa = C.IdEmpresa
		,@idPuntoDeVenta = IdPuntoDeVenta
	FROM Cliente C
	INNER JOIN Empresa E ON E.IdEmpresa = C.IdEmpresa
	INNER JOIN Reporte R ON R.IdEmpresa = E.IdEmpresa
	WHERE R.IdReporte = @idReporte

	--Datos Generales
	SELECT TOP 1 @PdvNombre = PDV.Nombre
		,@CadenaNombre = C.Nombre
		,@PdvId = PDV.IdPuntoDeVenta
		,@PdvDireccion = PDV.direccion
		,@LocalidadNombre = L.Nombre
		,@RTM = U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT
		,@pdvCodigoAdicional = isnull(pdv.codigoAdicional, '') collate database_default
		,@pdvRazonSocial = isnull(pdv.RazonSocial, '') collate database_default
	FROM Reporte R
	INNER JOIN PuntoDeVenta PDV ON PDV.idPuntoDeVenta = R.idPuntoDeVenta
	LEFT JOIN Cadena C ON C.idCadena = PDV.idCadena
	LEFT JOIN Localidad L ON L.idLocalidad = PDV.idLocalidad
	LEFT JOIN Usuario U ON U.idUsuario = R.idUsuario
	INNER JOIN Cliente Cl ON Cl.IdEmpresa = R.IdEmpresa
	WHERE R.idReporte = @idReporte

	SET @MailFrom = 'noreply@checkpos.com'
	SET @MailHeader = '<!DOCTYPE html>'
	SET @MailHeader = @MailHeader + '<html><head><title>Informe de Reporte</title><meta charset="utf-8">'
	SET @MailHeader = @MailHeader + '<style type="text/css">'
	SET @MailHeader = @MailHeader + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	SET @MailHeader = @MailHeader + 'body{height: 100%;width: 100%;padding:20px;}'
	SET @MailHeader = @MailHeader + 'h1{color: #ffffff;padding:0;margin:0;}'
	SET @MailHeader = @MailHeader + '.container{width: 100%;height: 100%;}'
	SET @MailHeader = @MailHeader + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'

	IF (
			@idCliente = 98
			OR @idEmpresa = 537
			)
	BEGIN
		SET @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 120px;padding: 5px 50px 35px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	END
	ELSE
	BEGIN
		SET @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	END

	SET @MailHeader = @MailHeader + 'h3{padding: 0;margin: 0;}'
	SET @MailHeader = @MailHeader + 'h4{padding: 0;margin: 0;}'
	SET @MailHeader = @MailHeader + 'h2{color:#FDA515;padding: 0;margin: 0;}'
	SET @MailHeader = @MailHeader + 'p{padding:0;margin:0;}'
	SET @MailHeader = @MailHeader + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}'
	SET @MailHeader = @MailHeader + 'table{border-collapse: collapse;width: 100%;background:#ffffff;margin:0;padding:0;}'
	SET @MailHeader = @MailHeader + 'th, td{text-align: left;padding: 8px;}'
	SET @MailHeader = @MailHeader + 'tr:nth-child(even){background-color: #f2f2f2}'
	SET @MailHeader = @MailHeader + '</style>'
	SET @MailHeader = @MailHeader + '</head>'
	SET @MailHeader = @MailHeader + '<body><div class="container">'
	SET @MailBody = ''
	SET @MailBody = @MailBody + '<div class="header">'
	SET @MailBody = @MailBody + '<h1>Informe de Reporte</h1>'
	SET @MailBody = @MailBody + '<h2>#' + cast(@idReporte AS VARCHAR) + '</h2>'
	SET @MailBody = @MailBody + '</div>'
	SET @MailBody = @MailBody + '<div class="middle">'
	SET @MailBody = @MailBody + '<p><strong>Reporte: </strong>' + ltrim(rtrim(str(@idReporte))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Cadena: </strong>' + ltrim(rtrim(isnull(@CadenaNombre, ''))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Punto de Venta: </strong>' + ltrim(rtrim(isnull(@PdvNombre, ''))) + '</p>'

	IF (
			@idCliente = 98
			OR @idEmpresa = 537
			)
	BEGIN
		SET @MailBody = @MailBody + '<p><strong>Codigo Cliente: </strong>' + ltrim(rtrim(isnull(@PdvCodigoAdicional, ''))) + '</p>'
		SET @MailBody = @MailBody + '<p><strong>Razon Social: </strong>' + ltrim(rtrim(isnull(@PdvRazonSocial, ''))) + '</p>'
	END

	SET @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>' + ltrim(rtrim(isnull(@PdvDireccion, ''))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Localidad: </strong>' + ltrim(rtrim(isnull(@LocalidadNombre, ''))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>' + ltrim(rtrim(isnull(@RTM, ''))) + '</p>'
	SET @MailBody = @MailBody + '</div>'
	--SET @MailSubject = 'Informe de Reporte #' + ltrim(rtrim(str(@idreporte))) + '  [PDV: ' + LTRIM(rtrim(str(isnull(@PdvId, 0)))) + ' - ' + LTRIM(rtrim(isnull(@PdvNombre, ''))) + ']'


	select @MailSubject = LEFT(isnull(Descripcion,''),199) 
	From Alertas where id = @IdAlerta 

	CREATE TABLE #ModulosDinamicos (
		idmodulo INT
		,descripcion VARCHAR(500)
		)

	--Busco las marcas del reporte:
	CREATE TABLE #Marcas (
		idMarca INT
		,Nombre VARCHAR(100)
		)

	INSERT #Marcas
	SELECT M.IdMarca AS IdMarca
		,M.Nombre AS Nombre
	FROM Marca M
	INNER JOIN Reporte R ON R.IdEmpresa = M.IdEmpresa
	WHERE R.IdReporte = @idReporte
		AND M.Reporte = 1

	--Por cada marca tengo que armar las tablas
	WHILE EXISTS (
			SELECT *
			FROM #Marcas
			)
	BEGIN
		SELECT TOP 1 @IdMarca = IdMarca
			,@MarcaNombre = isnull(Nombre, '')
		FROM #Marcas
		ORDER BY idMarca

		SET @MailBody = @MailBody + '<div class="data">'
		SET @MailBody = @MailBody + '<h2>' + ltrim(rtrim(isnull(@MarcaNombre, ''))) + '</h2>'

		--Exhibiciones
		DECLARE @seccion VARCHAR(max) = ''

		SET @seccion = @seccion + '<hr />'

		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion, M.Descripcion))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (
				M.IdModulo = MC.IdModulo
				AND (@IdCliente = MC.IdCliente)
				)
		WHERE M.IdModulo = 2
		and mc.Activo = 1
		ORDER BY M.[IdModulo]
		SET @tienedatos = @@rowcount

		SET @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr><th>Nombre</th><th>Cantidad</th></tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(E.Nombre, ''))) + '</td><td>' + ltrim(rtrim(str(isnull(RE.Cantidad, 0)))) + '</td></tr>'
		FROM ReporteExhibicion RE
		INNER JOIN Exhibidor E ON E.IdExhibidor = RE.IdExhibidor
		WHERE RE.IdReporte = @idReporte
			AND RE.IdMarca = @IdMarca
			AND RE.Cantidad > 0
		ORDER BY E.Nombre
			,RE.Cantidad
		
		SET @seccion = @seccion + '</tbody></table>'

		IF (@tienedatos > 0)
		BEGIN
			SET @MailBody = @MailBody + @seccion
		END

		SET @seccion = ''
		--Pop
		SET @seccion = @seccion + '<hr />'

		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion, M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (
				M.IdModulo = MC.IdModulo
				AND (@IdCliente = MC.IdCliente)
				)
		WHERE M.IdModulo = 5
		ORDER BY M.[IdModulo]

		SET @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr><th>Producto</th><th>Cantidad</th></tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre, ''))) + '</td><td>' + ltrim(rtrim(str(isnull(RP.Cantidad, 0)))) + '</td></tr>'
		FROM Pop P
		LEFT JOIN ReportePop RP ON (
				RP.IdReporte = @idReporte
				AND RP.IdMarca = @IdMarca
				AND RP.IdPop = P.IdPop
				)
		INNER JOIN POP_Marca PM ON (
				PM.IdMarca = @IdMarca
				AND P.IdPop = PM.IdPop
				)
		WHERE RP.IdPop IS NOT NULL
			AND RP.Cantidad > 0
		ORDER BY P.Nombre
			,RP.Cantidad

		SET @tienedatos = @@rowcount
		SET @seccion = @seccion + '</tbody></table>'

		IF (@tienedatos > 0)
		BEGIN
			SET @MailBody = @MailBody + @seccion
		END

		SET @seccion = ''
		--Productos
		SET @seccion = @seccion + '<hr />'

		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion, M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (
				M.IdModulo = MC.IdModulo
				AND (@IdCliente = MC.IdCliente)
				)
		WHERE M.IdModulo = 3
		ORDER BY M.[IdModulo]

		SET @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr>'
		SET @seccion = @seccion + '<th>Producto</th>'

		DELETE
		FROM #itemsAlerta

		INSERT #itemsAlerta (iditem)
		SELECT ac.iditem
		FROM alertasCampos ac
		WHERE ac.IdModulo = 3
			AND ac.idAlerta = @IdAlerta
			AND ac.idMarca = @IdMarca

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 6

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 2

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 4

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 11

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 9

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 15

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 13

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 10

		SET @seccion = @seccion + '</tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre, ''))) + '</td>'
			--p.nombre + 
			+ CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 6
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RP.Precio), ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 2
						)
					THEN '<td>' + ltrim(rtrim((
									CASE 
										WHEN isnull(RP.Stock, 1) = 1
											THEN 'SI'
										ELSE ''
										END
									))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 4
						)
					THEN '<td>' + ltrim(rtrim((
									CASE 
										WHEN isnull(RP.NoTrabaja, 0) = 1
											THEN 'NO'
										ELSE ''
										END
									))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 11
						)
					THEN '<td>' + ltrim(rtrim(isnull(E1.Nombre, ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 9
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RP.Cantidad), ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 15
						)
					THEN '<td>' + ltrim(rtrim(isnull(E2.Nombre, ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 13
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RP.Cantidad2), ''))) + '</td></tr>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 10
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RP.Cantidad), ''))) + '</td></tr>'
				ELSE ''
				END
		FROM Producto P
		LEFT JOIN ReporteProducto RP ON (
				RP.[IdReporte] = @idReporte
				AND P.IdProducto = RP.IdProducto
				)
		INNER JOIN Marca M ON M.IdMarca = P.IdMarca
		LEFT JOIN Exhibidor E1 ON E1.IdExhibidor = RP.IdExhibidor
		LEFT JOIN Exhibidor E2 ON E2.IdExhibidor = RP.IdExhibidor2
		WHERE P.IdMarca = @IdMarca
			AND P.Reporte = 1
			AND (
				(
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 9
						)
					AND isnull(RP.Cantidad, 0) > 0
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 13
						)
					AND isnull(RP.Cantidad2, 0) > 0
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 2
						)
					AND isnull(RP.Stock, 0) = 1
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 4
						)
					AND isnull(RP.NoTrabaja, 0) = 1
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 6
						)
					AND isnull(RP.Precio, 0) > 0
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 10
						)
					AND isnull(RP.cantidad, 0) > 0
					)
				)
		ORDER BY P.Nombre
			,RP.Stock DESC
			,RP.NoTrabaja DESC

		SET @tienedatos = @@rowcount
		SET @seccion = @seccion + '</tbody></table>'

		IF (@tienedatos > 0)
		BEGIN
			SET @MailBody = @MailBody + @seccion
		END

		SET @seccion = ''
		--ProductosCompetencia
		SET @seccion = @seccion + '<hr />'

		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion, M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (
				M.IdModulo = MC.IdModulo
				AND (@IdCliente = MC.IdCliente)
				)
		WHERE M.IdModulo = 4
		ORDER BY M.[IdModulo]

		SET @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr>'
		SET @seccion = @seccion + '<th>Producto</th>'

		DELETE
		FROM #itemsAlerta

		INSERT #itemsAlerta (iditem)
		SELECT ac.iditem
		FROM alertasCampos ac
		WHERE ac.IdModulo = 3
			AND ac.idAlerta = @IdAlerta
			AND ac.idMarca = @IdMarca

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 6

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 2

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 4

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 11

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 9

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 15

		SELECT @seccion = @seccion + '<th>' + isnull(MMC.Leyenda, '') + '</th>'
		FROM M_ModuloCliente MC
		INNER JOIN M_ModuloClienteItem MMC ON MMC.IdModuloCliente = MC.IdModuloCliente
		INNER JOIN #itemsAlerta ac ON ac.idItem = MMC.IdModuloItem
		WHERE MC.IdCliente = @IdCliente
			AND MC.IdModulo = 3
			AND ac.IdItem = 13

		SET @seccion = @seccion + '</tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre, ''))) + '</td>' + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 17
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RPC.Precio), ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 21
						)
					THEN '<td>' + ltrim(rtrim(isnull(E1.Nombre, ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 19
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RPC.Cantidad), ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 25
						)
					THEN '<td>' + ltrim(rtrim(isnull(E2.Nombre, ''))) + '</td>'
				ELSE ''
				END + CASE 
				WHEN EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 23
						)
					THEN '<td>' + ltrim(rtrim(isnull(str(RPC.Cantidad2), ''))) + '</td></tr>'
				ELSE ''
				END
		FROM Producto P
		LEFT JOIN ReporteProductoCompetencia RPC ON (
				RPC.IdReporte = @idReporte
				AND RPC.IdProducto = P.IdProducto
				AND (
					RPC.IdMarca IS NULL
					OR RPC.IdMarca = @IdMarca
					)
				)
		INNER JOIN ProductoCompetencia PC ON (
				P.IdProducto = PC.IdProductoCompetencia
				AND (
					ISNULL(PC.Reporte, 1) = 1
					OR NOT RPC.IdProducto IS NULL
					)
				)
		INNER JOIN Producto P2 ON (
				P2.IdProducto = PC.IdProducto
				AND P2.IdMarca = @IdMarca
				)
		INNER JOIN Marca M ON P.IdMarca = M.IdMarca
		INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
		LEFT JOIN Exhibidor E1 ON E1.IdExhibidor = RPC.IdExhibidor
		LEFT JOIN Exhibidor E2 ON E2.IdExhibidor = RPC.IdExhibidor2
		WHERE isnull(RPC.Cantidad, 0) > 0
			OR isnull(RPC.Cantidad2, 0) > 0
			OR isnull(RPC.Precio, 0) > 0
			AND P.IdMarca = @IdMarca
			AND P.Reporte = 1
			AND (
				(
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 19
						)
					AND isnull(RPC.Cantidad, 0) > 0
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 23
						)
					AND isnull(RPC.Cantidad2, 0) > 0
					)
				OR (
					EXISTS (
						SELECT 1
						FROM #itemsAlerta
						WHERE iditem = 17
						)
					AND isnull(RPC.Precio, 0) > 0
					)
				)
		ORDER BY P.Nombre

		SET @tienedatos = @@rowcount
		SET @seccion = @seccion + '</tbody></table>'

		--SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(P.Nombre,''))) + '</td>'
		--	  + '<td>' + ltrim(rtrim(isnull(str(RPC.Precio),''))) + '</td>'
		--	  + '<td>' + ltrim(rtrim(isnull(E1.Nombre,''))) + '</td>'
		--	  + '<td>' + ltrim(rtrim(isnull(str(RPC.Cantidad),''))) + '</td>'
		--	  + '<td>' + ltrim(rtrim(isnull(E2.Nombre,''))) + '</td>'
		--	  + '<td>' + ltrim(rtrim(isnull(str(RPC.Cantidad2),''))) + '</td></tr>'
		--FROM Producto P 	
		--LEFT JOIN ReporteProductoCompetencia RPC ON (RPC.IdReporte = @idReporte and RPC.IdProducto = P.IdProducto and (RPC.IdMarca IS NULL OR RPC.IdMarca = @IdMarca))
		--INNER JOIN ProductoCompetencia PC ON (P.IdProducto=PC.IdProductoCompetencia AND (ISNULL(PC.Reporte,1) = 1 OR NOT RPC.IdProducto IS NULL)) 
		--INNER JOIN Producto P2 ON (P2.IdProducto = PC.IdProducto and P2.IdMarca = @IdMarca)
		--INNER JOIN Marca M ON P.IdMarca=M.IdMarca 
		--INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
		--left join Exhibidor E1 on E1.IdExhibidor = RPC.IdExhibidor
		--left join Exhibidor E2 on E2.IdExhibidor = RPC.IdExhibidor2
		--where isnull(RPC.Cantidad,0)>0 or isnull(RPC.Cantidad2,0)>0 or isnull(RPC.Precio,0)>0
		--ORDER BY E.Nombre, P.Nombre
		--set @tienedatos=@@rowcount
		--set @seccion = @seccion + '</tbody></table>'
		IF (@tienedatos > 0)
		BEGIN
			SET @MailBody = @MailBody + @seccion
		END

		SET @seccion = ''
		--Mantenimiento
		SET @seccion = @seccion + '<hr />'

		SELECT @seccion = @seccion + '<h3>' + ltrim(rtrim(ISNULL(MC.Descripcion, M.[Descripcion]))) + '</h3>'
		FROM [M_Modulo] M
		LEFT JOIN M_ModuloCliente MC ON (
				M.IdModulo = MC.IdModulo
				AND (@IdCliente = MC.IdCliente)
				)
		WHERE M.IdModulo = 6
		ORDER BY M.[IdModulo]

		SET @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr><th>Material</th><th>Estado</th><th>Observaciones</th></tr></thead><tbody>'

		SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(MM.Nombre, ''))) + '</td>' + + '<td>' + ltrim(rtrim(isnull(ME.Estado, ''))) + '</td>' + + '<td>' + ltrim(rtrim(isnull(RM.Observaciones, ''))) + '</td></tr>'
		FROM [MantenimientoMaterial] MM
		INNER JOIN MantenimientoMaterial_Marca MMM ON (
				MM.[IdMantenimientoMaterial] = MMM.[IdMantenimientoMaterial]
				AND MMM.IdMarca = @IdMarca
				)
		LEFT JOIN [ReporteMantenimiento] RM ON (
				RM.IdReporte = @idReporte
				AND RM.IdMarca = @IdMarca
				AND RM.[IdMantenimientoMaterial] = MM.[IdMantenimientoMaterial]
				)
		LEFT JOIN MantenimientoEstado ME ON (ME.IdMantenimientoEstado = RM.IdMantenimientoEstado)
		WHERE RM.IdReporteMantenimiento IS NOT NULL
		ORDER BY MM.Nombre

		SET @tienedatos = @@rowcount
		SET @seccion = @seccion + '</tbody></table>'

		IF (@tienedatos > 0)
		BEGIN
			SET @MailBody = @MailBody + @seccion
		END

		SET @seccion = ''
		--Módulo Dinámico
		SET @seccion = @seccion + '<hr />'

		--Por cada modulo dinamico armo una tabla
		SELECT @seccion = @seccion + '<h3>Módulos Dinámicos</h3>'

		INSERT #ModulosDinamicos (
			idModulo
			,descripcion
			)
		SELECT M.idmodulo
			,ltrim(rtrim(ISNULL(M.Descripcion, M.Nombre)))
		FROM [dbo].[MD_ModuloMarca] MM
		INNER JOIN [dbo].[MD_Modulo] M ON (MM.IdModulo = M.IdModulo)
		WHERE @IdMarca = MM.[IdMarca]
			AND MM.[Activo] = 1
		ORDER BY MM.Orden

		--por cada modulo tengo que armar una tabla
		DECLARE @currentidmodulo INT

		WHILE (
				EXISTS (
					SELECT 1
					FROM #ModulosDinamicos
					)
				)
		BEGIN
			SELECT TOP 1 @currentidmodulo = idmodulo
			FROM #ModulosDinamicos

			SELECT @seccion = @seccion + '<h4><em>' + ltrim(rtrim(ISNULL(descripcion, ''))) + '</em></h4>'
			FROM #ModulosDinamicos
			WHERE idmodulo = @currentidmodulo

			SET @seccion = @seccion + '<table bgcolor="#ffffff"><thead><tr><th>Item</th><th></th><th></th><th></th><th></th></tr></thead><tbody>'

			SELECT @seccion = @seccion + '<tr><td>' + ltrim(rtrim(isnull(MI.Nombre, ''))) + '</td>' + '<td>' + CASE 
					WHEN isnull(RM.Valor1, 0) = 1
						THEN ltrim(rtrim(isnull(MI.LabelCampo1, '')))
					ELSE ''
					END + '</td>' + '<td>' + CASE 
					WHEN isnull(RM.Valor2, 0) = 1
						THEN ltrim(rtrim(isnull(MI.LabelCampo2, '')))
					ELSE ''
					END + '</td>' + '<td>' + CASE 
					WHEN isnull(RM.valor3, 0) = 1
						THEN ltrim(rtrim(isnull(MI.LabelCampo3, '')))
					ELSE ''
					END + '</td>' + '<td>' + ltrim(rtrim(isnull(RM.Valor4, ''))) + '</td></tr>'
			FROM MD_Item MI
			LEFT JOIN MD_ReporteModuloItem RM ON (MI.IdItem = RM.IdItem)
			LEFT JOIN MD_ModuloMarcaItem MMI ON (
					MI.IdItem = MMI.IdItem
					AND RM.idMarca = MMI.IdMarca
					)
			WHERE MMI.Activo = 1
				AND MI.Activo = 1
				AND MI.IdModulo = @currentidmodulo
				AND (
					isnull(RM.Valor1, 0) = 1
					OR isnull(RM.Valor2, 0) = 1
					OR isnull(RM.Valor3, 0) = 1
					OR isnull(RM.Valor4, 0) = 1
					)
				AND @idReporte = RM.IdReporte
				AND @IdMarca = RM.IdMarca
			ORDER BY MI.Orden

			IF (@tienedatos = 0)
				SET @tienedatos = @@rowcount
			SET @seccion = @seccion + '</tbody></table>'

			DELETE
			FROM #ModulosDinamicos
			WHERE idmodulo = @currentidmodulo
		END

		IF (@tienedatos > 0)
		BEGIN
			SET @MailBody = @MailBody + @seccion
		END

		SET @seccion = ''
		--------------------------------------------------------------------------------------------------------------------------------
		--listo, proxima marca
		SET @MailBody = @MailBody + '</div>'

		DELETE #Marcas
		WHERE idMarca = @IdMarca
	END

	--set @MailBody = @MailBody + '</div>'
	SET @MailFooter = '</div></body></html>'

	IF isnull(@MailFrom, '') <> ''
		AND isnull(@MailBody, '') <> ''
	BEGIN
		INSERT EmpresaMail (
			IdReporte
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
			)
		VALUES (
			@idReporte
			,@IdAlerta
			,'noreply@checkpos.com'
			,@MailBody
			,@MailSubject
			,@MailHeader
			,@MailFooter
			,NULL
			,1
			,NULL
			,0
			,getdate()
			,getdate()
			,NULL
			)
	END
END
GO
