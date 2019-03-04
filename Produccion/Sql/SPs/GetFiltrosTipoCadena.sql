SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosTipoCadena]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosTipoCadena] AS' 
END
GO

ALTER PROCEDURE [dbo].[GetFiltrosTipoCadena]
(
	@IdCliente		INT,
	@Top			INT = 0,
	@texto			VARCHAR(MAX) = ''
)
AS
BEGIN

	CREATE TABLE #Clientes
	(
		idCliente INT
	)
	
	INSERT INTO #clientes(idCliente) 
	SELECT 
		FC.idCliente 
	FROM 
		familiaClientes FC
	WHERE 
		FC.familia IN (SELECT familia FROM familiaClientes WHERE idCliente = @idCLiente	AND activo = 1)
		
		IF @@rowcount = 0 BEGIN
			INSERT INTO #clientes(idcliente) VALUES (@idCliente) 
		END

	SET ROWCOUNT @Top


	SELECT 
		TC.idTipoCadena idItem,
		TC.Nombre Descripcion
	FROM 
		TipoCadena TC
	WHERE
		EXISTS(SELECT 1 FROM #clientes WHERE idCliente = TC.idCliente)
		AND (ISNULL(@texto,'') = '' OR TC.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)

	SET ROWCOUNT 0

END

GO
