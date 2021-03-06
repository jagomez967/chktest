SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Item_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Item_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_Item_Update]

    @IdItem int
   ,@IdModulo int
   ,@IdTipoItem int
   ,@Nombre varchar(500)
   ,@Orden int = NULL
   ,@LabelCampo1 varchar(50) = NULL
   ,@LabelCampo2 varchar(50) = NULL
   ,@LabelCampo3 varchar(50) = NULL   
   ,@LabelCampo4 varchar(50) = NULL   
   ,@Activo bit
   ,@IdProducto INT = NULL
   
   
AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE [dbo].[MD_Item]
	   SET [IdModulo] = @IdModulo
	      ,[IdTipoItem] = @IdTipoItem
		  ,[Nombre] = @Nombre
		  ,[Orden] = @Orden
		  ,[LabelCampo1] = @LabelCampo1
		  ,[LabelCampo2] = @LabelCampo2
		  ,[LabelCampo3] = @LabelCampo3
		  ,[LabelCampo4] = @LabelCampo4
		  ,[Activo] = @Activo
		  ,[IdProducto] = @IdProducto
	 WHERE @IdItem = [IdItem]

           
END
GO
