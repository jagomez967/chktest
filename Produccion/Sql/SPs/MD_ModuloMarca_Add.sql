SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ModuloMarca_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ModuloMarca_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ModuloMarca_Add]
	-- Add the parameters for the stored procedure here
	 @IdModulo int
    ,@IdMarca int
    ,@Orden int = NULL
    ,@Ponderacion decimal(18,2) = NULL
    ,@Activo bit
    
AS
BEGIN
	
	SET NOCOUNT ON;
    
	INSERT INTO [dbo].[MD_ModuloMarca]
           ([IdModulo]
           ,[IdMarca]
           ,[Orden] 
           ,[FechaAlta]
           ,[FechaUltimaModificacion]
           ,[Ponderacion]
           ,[Activo])
     VALUES
           (@IdModulo
           ,@IdMarca
           ,@Orden
           ,GETDATE()
           ,GETDATE()
           ,@Ponderacion
           ,@Activo)

END
GO
