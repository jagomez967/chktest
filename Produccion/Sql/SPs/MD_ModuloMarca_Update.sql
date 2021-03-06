SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ModuloMarca_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ModuloMarca_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ModuloMarca_Update]
	-- Add the parameters for the stored procedure here
	 @IdModulo int
    ,@IdMarca int
    ,@Orden int = NULL
    ,@Ponderacion decimal(18,2) = NULL
    ,@Activo bit
    
AS
BEGIN
	
	SET NOCOUNT ON;
    UPDATE [dbo].[MD_ModuloMarca]
    SET [FechaUltimaModificacion] = GETDATE()
       ,[Orden]  = @Orden
       ,[Ponderacion]=@Ponderacion
       ,[Activo] = @Activo
    WHERE @IdModulo = [IdModulo]  AND
          @IdMarca = [IdMarca] 

END
GO
