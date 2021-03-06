SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailReporteQuiebreStock]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailReporteQuiebreStock] AS' 
END
GO
ALTER PROCEDURE [dbo].[spGenerarMailReporteQuiebreStock] (
	@IdReporte INT
	,@IdAlerta INT
	)
AS
BEGIN
	DECLARE @MailFrom VARCHAR(100) = ''
	DECLARE @MailBody VARCHAR(max) = ''
	DECLARE @MailSubject VARCHAR(200) = ''
	DECLARE @idPuntoDeVenta INT
	DECLARE @idmarca INT
	DECLARE @idproducto INT
	DECLARE @NombreMarca VARCHAR(100) = ''
	DECLARE @NombreProducto VARCHAR(100) = ''
	DECLARE @NombrePuntoDeVenta VARCHAR(200) = ''
	DECLARE @NombreCadena VARCHAR(50) = ''
	DECLARE @DireccionPuntoDeVenta VARCHAR(500) = ''
	DECLARE @NombreLocalidad VARCHAR(50) = ''
	DECLARE @RTM VARCHAR(150) = ''
	DECLARE @IdEmpresa INT
	DECLARE @MailHeader VARCHAR(max)
	DECLARE @MailFooter VARCHAR(max)
	DECLARE @PdvCodigoAdicional VARCHAR(50)
	--	Declare @FirmaAdjunta varchar(2000)
	DECLARE @pdvRazonSocial VARCHAR(200)
	DECLARE @IdCliente INT

	IF NOT EXISTS (
			SELECT 1
			FROM ReporteProducto
			WHERE idReporte = @idReporte
				AND isnull(Stock, 1) = 1
			)
		RETURN

	SET @MailFrom = 'noreply@checkpos.com'

	--Variables Grales
	SELECT TOP 1 @IdCliente = C.IdCliente
		,@IdEmpresa = isnull(C.IdEmpresa, R.idEmpresa)
	FROM Cliente C
	INNER JOIN Empresa E ON E.IdEmpresa = C.IdEmpresa
	INNER JOIN Reporte R ON R.IdEmpresa = E.IdEmpresa
	WHERE R.IdReporte = @idReporte

	SELECT TOP 1 @IdEmpresa = R.IdEmpresa
		,@idPuntoDeVenta = R.IdPuntoDeVenta
		,@NombrePuntoDeVenta = PDV.Nombre
		,@DireccionPuntoDeVenta = PDV.direccion
		,@NombreCadena = C.Nombre
		,@NombreLocalidad = L.Nombre
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

	print 'verificando'
	if exists (select 1 from AlertasProductos where idAlerta = @idAlerta)
	BEGIN
		if not exists (
			select 1 from alertasProductos ap
			inner join reporteProducto rp
			on rp.idProducto = ap.idProducto 
			where ap.idAlerta =@idAlerta
			and rp.idReporte = @idReporte
			and rp.stock = 1)
		BEGIN
			return;
		END
	END
	print 'armando mail'

	SELECT @MailSubject = 'Quiebres de Stock' + isnull(' - ' + Descripcion, '') 
	from alertas where id = @idAlerta 
	if @@ROWCOUNT = 0
	BEGIN		
		set @MailSubject = 'Quiebres de Stock'
	END

	SET @MailHeader = '<!DOCTYPE html>'
	SET @MailHeader = @MailHeader + '<html><head><title>Quiebre de Stock</title><meta charset="utf-8">'
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
		SET @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 10px 50px 30px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	END
	ELSE
	BEGIN
		SET @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	END

	SET @MailHeader = @MailHeader + 'h3{color:#FDA515;padding: 0;margin: 0;}'
	SET @MailHeader = @MailHeader + 'p{padding:0;margin:0;}'
	SET @MailHeader = @MailHeader + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}'
	SET @MailHeader = @MailHeader + 'table{width: 100%;}'
	SET @MailHeader = @MailHeader + 'td{border-bottom: 1px #ddd solid;}'
	SET @MailHeader = @MailHeader + 'thead{text-align: left;}'
	SET @MailHeader = @MailHeader + '</style>'
	SET @MailHeader = @MailHeader + '</head>'
	SET @MailHeader = @MailHeader + '<body><div class="container">'
	SET @MailBody = ''
	SET @MailBody = @MailBody + '<div class="header">'
	SET @MailBody = @MailBody + '<h1>Quiebre de Stock</h1>'
	SET @MailBody = @MailBody + '<h3>Reporte #' + cast(@idReporte AS VARCHAR) + '</h3>'
	SET @MailBody = @MailBody + '</div>'
	SET @MailBody = @MailBody + '<div class="middle">'
	SET @MailBody = @MailBody + '<p><strong>Cadena: </strong>' + ltrim(rtrim(isnull(@NombreCadena, ''))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Punto de Venta: </strong>' + ltrim(rtrim(isnull(@NombrePuntoDeVenta, ''))) + '</p>'

	IF (
			@idCliente = 98
			OR @idEmpresa = 537
			)
	BEGIN
		SET @MailBody = @MailBody + '<p><strong>Codigo Cliente: </strong>' + ltrim(rtrim(isnull(@PdvCodigoAdicional, ''))) + '</p>'
		SET @MailBody = @MailBody + '<p><strong>Razon Social: </strong>' + ltrim(rtrim(isnull(@PdvRazonSocial, ''))) + '</p>'
	END

	SET @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>' + ltrim(rtrim(isnull(@DireccionPuntoDeVenta, ''))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Localidad: </strong>' + ltrim(rtrim(isnull(@NombreLocalidad, ''))) + '</p>'
	SET @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>' + ltrim(rtrim(isnull(@RTM, ''))) + '</p>'
	SET @MailBody = @MailBody + '</div>'

/*
	declare @currentMarca int

	declare cur_productos cursor
	for	
		Select M.idMarca, P.idproducto, M.Nombre, P.Nombre from ReporteProducto RP
		inner join Producto P on P.idProducto = RP.idProducto
		inner join Marca M on M.IdMarca = P.IdMarca
		where RP.IdReporte = @idReporte and isnull(RP.Stock,0)=1
		order by M.idMarca, P.idproducto

	open cur_productos
	fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto

	while @@FETCH_STATUS = 0
	begin
		select @currentMarca = @idmarca

		set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h3>'+ltrim(rtrim(isnull(@NombreMarca,'')))+'</h3>'
		set @MailBody = @MailBody + '<table><tbody>'

		while (@@FETCH_STATUS = 0 and @currentMarca = @idmarca)
		begin
			set @MailBody = @MailBody + '<tr>'
			set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(@NombreProducto,'')))+'</td>'
			set @MailBody = @MailBody + '</tr>'

			fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto
		end

		set @MailBody = @MailBody + '</tbody></table></div>'
	
		--fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto
	end

	close cur_productos
	deallocate cur_productos
	*/
		--MEJORA DE PERFORMANCE 45%
		;

	WITH productos_CTE (
		idMarca
		,marca
		,producto
		)
	AS (
		SELECT M.idMarca AS idmarca
			,M.Nombre AS marca
			,P.Nombre AS producto
		FROM ReporteProducto RP
		INNER JOIN Producto P ON P.idProducto = RP.idProducto
		INNER JOIN Marca M ON M.IdMarca = P.IdMarca
		WHERE RP.IdReporte = @idReporte
			AND isnull(RP.Stock, 0) = 1
			and 
			( not exists (select 1 From AlertasProductos where IdAlerta = @idAlerta)
			or
			(rp.idProducto in(
						 select idProducto From AlertasProductos where IdAlerta = @idAlerta)))
		)
	SELECT @mailbody = COALESCE(@mailbody, '') + isnull(list + '</tbody></table></div>', '')
	FROM (
		SELECT DISTINCT '<div class="data">' + '<h3>' + ltrim(rtrim(isnull(Marca, ''))) + '</h3>' + '<table><tbody>' + cast((
					SELECT (
							SELECT producto AS td
							FROM productos_CTE
							WHERE idMarca = t.idMarca
							FOR XML PATH('tr')
							)
					) AS VARCHAR(max)) AS list
		FROM productos_CTE t
		) x

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


