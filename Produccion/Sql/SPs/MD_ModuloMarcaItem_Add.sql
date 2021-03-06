SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ModuloMarcaItem_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ModuloMarcaItem_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ModuloMarcaItem_Add]
    @IdMarca int
   ,@IdItem int
   ,@Ponderacion Decimal(18,2) =  NULL
   ,@Activo bit
   ,@Obligatorio bit = 0
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[MD_ModuloMarcaItem]
           ([IdMarca]
           ,[IdItem]
           ,[Ponderacion]
           ,[Activo]
           ,[Obligatorio])
     VALUES
           (@IdMarca
           ,@IdItem
           ,@Ponderacion
           ,@Activo
           ,@Obligatorio)

END
GO
