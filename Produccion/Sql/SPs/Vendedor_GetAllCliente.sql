SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vendedor_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Vendedor_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Vendedor_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente INT = NULL
	,@Nombre varchar(50) = NULL
	AS
	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT V.[IdVendedor]
		  ,V.[IdEquipo]
		  ,V.[Nombre]
		  ,V.[Telefono]
		  ,V.[Email]
		  ,E.Nombre AS Equipo
	FROM [dbo].[Vendedor] V
  	INNER JOIN [dbo].[Equipo] E ON (E.[IdEquipo] = V.[IdEquipo])
	--INNER JOIN @ListaClientes LC ON (LC.IdCliente = E.IdCliente)
	WHERE (E.IdCliente = @IdCliente) AND
	      (@Nombre IS NULL OR V.[Nombre] like '%' + @Nombre + '%')
  

END
GO
