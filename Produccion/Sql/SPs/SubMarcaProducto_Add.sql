SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubMarcaProducto_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SubMarcaProducto_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SubMarcaProducto_Add]
	-- Add the parameters for the stored procedure here
    @idSubMarca int,
	@idProducto int,
	@idMarca int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	INSERT INTO [dbo].[SubMarca_Producto]
           ([idProducto],[idSubMarca])
     VALUES
           (@idProducto,
		    @idSubMarca)		  
END
GO
