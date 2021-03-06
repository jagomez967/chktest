SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Cliente_GetAllMantenimiento]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Cliente_GetAllMantenimiento] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_Cliente_GetAllMantenimiento]
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
		  ,C.[Capacitacion]
		  ,C.[VisitadorMedico] 
		  ,C.[Imagen]
		  ,C.[ImagenWeb]
		  ,C.[ImagenMovil]
		  ,C.[Latitud]
		  ,C.[Longitud]
		  ,C.[DiferenciaHora]
		  ,C.[DiferenciaMinutos]
	  FROM [dbo].[Usuario_Cliente] UC
	  INNER JOIN  Cliente C ON (C.[IdCliente] = UC.[IdCliente])
	  INNER JOIN  Empresa E ON (C.[IdEmpresa] = E.[IdEmpresa])
	  INNER JOIN [dbo].[Negocio] N ON (N.[IdNegocio] = E.[IdNegocio])
	  INNER JOIN [dbo].[Usuario] U ON (U.[IdUsuario] = UC.[IdUsuario])
	  WHERE UC.[IdUsuario] = @IdUsuario AND C.[Mantenimiento] = 1
	  ORDER BY E.Nombre
	  
END
GO
