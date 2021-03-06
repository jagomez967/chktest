SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MantenimientoMaterial_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MantenimientoMaterial_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MantenimientoMaterial_Add]
	-- Add the parameters for the stored procedure here	 
	 @Nombre varchar(100)
	,@Observaciones varchar(max) = NULL
	,@Activo bit
	,@IdMantenimientoMaterial int output
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[MantenimientoMaterial]
           ([Nombre]
           ,[Observaciones]
           ,[Activo])
     VALUES
           (@Nombre
           ,@Observaciones
           ,@Activo)
           
      SET @IdMantenimientoMaterial = @@Identity
      
END
GO
