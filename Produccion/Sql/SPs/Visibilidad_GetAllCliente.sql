SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Visibilidad_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Visibilidad_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Visibilidad_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	,@Nombre varchar(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  	SELECT [IdVisibilidad]
 		  ,[Nombre]
	  FROM [dbo].[Visibilidad] V
	  --INNER JOIN @ListaNegocios LN ON (V.IdNegocio = LN.IdNegocio)
      WHERE (IdCliente = @IdCliente)
      ORDER BY [Nombre]

END
GO
