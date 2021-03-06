SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Cliente_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Cliente_GetAll] AS' 
END
GO

ALTER PROCEDURE [dbo].[Usuario_Cliente_GetAll]
	-- Add the parameters for the stored procedure here
	@IdUsuario int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UC.[IdCliente]
		  ,UC.[IdUsuario]
		  ,C.[IdEmpresa]
		  ,E.[IdEmpresa]
		  ,E.Nombre
		  ,N.IdNegocio
		  ,C.[Transfer]
		  ,C.[Dermoestetica]
		  ,C.[Mantenimiento]
		  ,C.[VisitadorMedico]
		  ,C.[Capacitacion]
		  ,C.[Imagen]
		  ,C.[CodigoBarras]
		  ,C.[ImagenWeb]
		  ,C.[ImagenMovil]
		  ,C.[Latitud]
		  ,C.[Longitud]
		  ,C.[DiferenciaHora]
		  ,C.[DiferenciaMinutos]
		  ,C.[PermiteFotosDeBiblioteca]
		  ,C.[StockDefaultValue]
	      ,C.[MarcaLabel] as LabelMarca
	  FROM [dbo].[Usuario_Cliente] UC
	  INNER JOIN  Cliente C ON (C.[IdCliente] = UC.[IdCliente])
	  INNER JOIN  Empresa E ON (C.[IdEmpresa] = E.[IdEmpresa])
	  INNER JOIN  Usuario U ON (U.[IdUsuario] = UC.[IdUsuario])
	  INNER JOIN [dbo].[Negocio] N ON (N.[IdNegocio] = E.[IdNegocio])
	  WHERE UC.[IdUsuario] = @IdUsuario
	  ORDER BY E.Nombre
	  
END



GO
