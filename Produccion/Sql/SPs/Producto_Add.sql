SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Producto_Add]
    @IdMarca int
   ,@Nombre varchar(100)
   ,@Reporte bit
   ,@GenericoPorMarca bit
   ,@IdFamilia int=null
   ,@IdProducto int output
   ,@CodigoBarras varchar(100)=null
   ,@Orden	int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Producto]
           ([IdMarca]
           ,[Nombre]
           ,[Reporte]
           ,[GenericoPorMarca]
		   ,[IdFamilia]
		   ,[CodigoBarras]
		   ,[Orden] )
     VALUES
           (@IdMarca
           ,@Nombre
           ,@Reporte
           ,@GenericoPorMarca
		   ,@IdFamilia
		   ,@CodigoBarras
		   ,@Orden)

	SET @IdProducto = @@Identity
	
END

GO
