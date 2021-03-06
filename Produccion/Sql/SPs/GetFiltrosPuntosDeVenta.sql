SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosPuntosDeVenta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosPuntosDeVenta] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosPuntosDeVenta]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)='',
	@IdModulo int = 0
)
as
BEGIN
	CREATE TABLE #Clientes (idCliente INT)
	Declare @Multicliente bit = 1 
	
	INSERT #clientes (idCliente)
	SELECT fc.idCliente
	FROM familiaClientes fc
	WHERE fc.familia IN (
			SELECT familia
			FROM familiaClientes
			WHERE idCliente = @idCLiente
				AND activo = 1
			)
	
	IF @@rowcount = 0
	BEGIN
		set @Multicliente = 0
		insert #clientes(idCliente)
		values(@idCliente)
	END

	SET ROWCOUNT @Top
	
	IF(@MultiCliente = 0)
	BEGIN
		SELECT pdv.IdPuntoDeVenta as IdItem,
			   cast(pdv.IdPuntoDeVenta as nvarchar(20)) + ' - ' 
			   + isnull(pdv.Nombre,'') + Isnull(' - ' + pdv.Direccion,'') collate database_default as Descripcion
		FROM PuntoDeVenta pdv
		WHERE pdv.idCliente = @idCliente
		and (isnull(@texto,'') = '' or PDV.[Nombre] like '%'+@texto +'%' or PDV.[Direccion] like '%' + @texto + '%' or CAST(PDV.[IdPuntoDeVenta] AS NVARCHAR(10)) like '%' + @texto + '%')
	END
	ELSE
	BEGIN 
		SELECT max(pdv.IdPuntoDeVenta) as IdItem,
			   isnull(pdv.Nombre,'') + Isnull(' - ' + pdv.Direccion,'') collate database_default as Descripcion
		FROM PuntoDeVenta pdv
		WHERE pdv.idCliente in(SELECT idCliente from #clientes)
		and (isnull(@texto,'') = '' or PDV.[Nombre] like '%'+@texto +'%' or PDV.[Direccion] like '%' + @texto + '%' or CAST(PDV.[IdPuntoDeVenta] AS NVARCHAR(10)) like '%' + @texto + '%')
		GROUP BY isnull(pdv.Nombre,'') + Isnull(' - ' + pdv.Direccion,'') collate database_default
	END
	SET ROWCOUNT 0
END
GO

