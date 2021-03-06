SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marca_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Marca_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Marca_Update]
	-- Add the parameters for the stored procedure here
	 @Nombre varchar(100)
	,@IdEmpresa int
	,@Orden int = NULL
	,@Reporte bit
	,@IdMarca int 
	,@Imagen varchar(MAX)=NULL
	,@SoloCompetencia bit = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[Marca]
    SET [Nombre] = @Nombre
       ,[IdEmpresa] = @IdEmpresa
       ,[Orden] = @Orden
       ,[Reporte] = @Reporte
       ,[Imagen] = @Imagen
       ,[SoloCompetencia] = @SoloCompetencia
	WHERE @IdMarca = IdMarca

END
GO
