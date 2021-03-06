SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marca_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Marca_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Marca_Add]
	-- Add the parameters for the stored procedure here
	 @Nombre varchar(100)
	,@IdEmpresa int
	,@Orden int = NULL
	,@Reporte bit 
	,@Imagen varchar(MAX) = NULL
	,@IdMarca int output
	,@SoloCompetencia bit = NULL
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Marca]
           ([Nombre]
           ,[IdEmpresa]
           ,[Orden]
           ,[Reporte]
           ,[Imagen]
           ,[SoloCompetencia])
     VALUES
           (@Nombre
           ,@IdEmpresa
           ,@Orden
           ,@Reporte
           ,@Imagen
           ,@SoloCompetencia)
                      
     SET @IdMarca = @@identity   
           

END
GO
