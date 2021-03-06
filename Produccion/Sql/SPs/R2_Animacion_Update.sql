SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Animacion_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Animacion_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Animacion_Update]
	-- Add the parameters for the stored procedure here
	@IdAnimacion int
   ,@IdMarca int
   ,@Descripcion varchar(100)
   ,@Orden int = NULL
   ,@Activo bit
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [R2_Animacion]
	   SET [IdMarca] = @IdMarca
	      ,[Descripcion] = @Descripcion
		  ,[Orden] = @Orden
		  ,[Activo] = @Activo
	 WHERE @IdAnimacion = [IdAnimacion]
END
GO
