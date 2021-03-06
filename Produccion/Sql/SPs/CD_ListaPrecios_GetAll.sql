SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_ListaPrecios_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_ListaPrecios_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_ListaPrecios_GetAll]
	-- Add the parameters for the stored procedure here
	@Codigo varchar(50) = NULL
   ,@FechaDesde Datetime = NULL
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [Codigo]
      ,[FechaDesde]
      ,[SinImpuestos]
      ,[IVA]
      ,[Comercio]
      ,[PrecioSugerido]
      ,[IdSistema]
      ,[Activo]
  FROM [dbo].[CD_ListaPrecios]
  WHERE (@Codigo IS NULL OR @Codigo = Codigo) AND
        (@FechaDesde IS NULL OR @FechaDesde = FechaDesde)
  ORDER BY FechaDesde DESC
     
END
GO
