SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_GetEmpresa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_GetEmpresa] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cliente_GetEmpresa]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdCliente]
		  ,[Nombre]
		  ,[IdEmpresa]
		  ,[Transfer]
		  ,[Dermoestetica]
		  ,[Mantenimiento]
		  ,[VisitadorMedico]
		  ,[Capacitacion]
		  ,[Imagen]
		  ,[ImagenWeb]
		  ,[ImagenMovil]
		  ,[Latitud]
		  ,[Longitud]
		  ,[DiferenciaHora]
		  ,[DiferenciaMinutos]
		  ,[StockDefaultValue]
		  ,[marcaLabel]
		  ,[CodigoBarras]
		  ,[PermiteFotosDeBiblioteca]
  FROM [dbo].[Cliente]
  WHERE IdEmpresa = @IdEmpresa
  
END
GO
