SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Material_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Material_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Material_Update]

    @IdMaterial int
   ,@IdCliente int
   ,@Nombre varchar(100)
   ,@Activo bit
   
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[VM_Material]
    SET [IdCliente] = @IdCliente
       ,[Nombre] = @Nombre
       ,[Activo] = @Activo
    WHERE [IdMaterial]=@IdMaterial
    
END
GO
