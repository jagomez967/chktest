SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Marca_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Marca_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Marca_Update]
	-- Add the parameters for the stored procedure here
	 @IdMarca int
	,@IdCliente int
    ,@Nombre varchar(100)
    ,@Activo bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[VM_Marca]
	   SET [IdCliente] = @IdCliente
		  ,[Nombre] = @Nombre
		  ,[Activo] = @Activo
	 WHERE @IdMarca = [IdMarca]
	 
END
GO
