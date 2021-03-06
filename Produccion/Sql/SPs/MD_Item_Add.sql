SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Item_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Item_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_Item_Add]
	@IdModulo int
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

	INSERT INTO [dbo].[MD_Item]
           ([IdModulo]
           ,[IdTipoItem]
           ,[Nombre]
           ,[Orden]
           ,[LabelCampo1]
           ,[LabelCampo2]
           ,[LabelCampo3]
           ,[LabelCampo4]
           ,[Activo]
           ,[IdProducto])
     VALUES
           (@IdModulo
           ,@IdTipoItem
           ,@Nombre
           ,@Orden
           ,@LabelCampo1
           ,@LabelCampo2
           ,@LabelCampo3
           ,@LabelCampo4
           ,@Activo
           ,@IdProducto)
           
           
END
GO
