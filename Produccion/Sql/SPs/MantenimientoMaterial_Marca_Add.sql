SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MantenimientoMaterial_Marca_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MantenimientoMaterial_Marca_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MantenimientoMaterial_Marca_Add]
	-- Add the parameters for the stored procedure here
    @IdMantenimientoMaterial int
   ,@IdMarca int
   ,@Activo bit
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[MantenimientoMaterial_Marca]
           ([IdMantenimientoMaterial]
           ,[IdMarca]
           ,[Activo])
     VALUES
           (@IdMantenimientoMaterial
           ,@IdMarca
           ,@Activo)
           
END
GO
