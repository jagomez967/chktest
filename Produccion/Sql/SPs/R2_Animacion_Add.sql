SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Animacion_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Animacion_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Animacion_Add]
	-- Add the parameters for the stored procedure here
    @IdMarca int
   ,@Descripcion varchar(100)
   ,@Orden int = NULL
   ,@Activo bit
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [R2_Animacion]
           ([IdMarca]
           ,[Descripcion]
           ,[Orden]
           ,[Activo])
     VALUES
           (@IdMarca
           ,@Descripcion
           ,@Orden
           ,@Activo)

END
GO
