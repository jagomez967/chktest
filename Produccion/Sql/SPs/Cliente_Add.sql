SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Cliente_Add]
	-- Add the parameters for the stored procedure here
	  
	  @Nombre varchar(50)
     ,@IdEmpresa int
     ,@Transfer bit
     ,@Dermoestetica bit
     ,@Mantenimiento bit
     ,@VisitadorMedico bit
     ,@Capacitacion bit
     ,@Imagen varchar(MAX) = NULL
     ,@IdCliente int OUTPUT
	 ,@CodigoBarras bit=0
	 ,@StockDefaultValue bit=0
	 ,@PermiteFotosDeBiblioteca bit=0
	 ,@LabelMarca varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Cliente]
           ([Nombre]
           ,[IdEmpresa]
           ,[Transfer]
           ,[Dermoestetica]
           ,[Mantenimiento]
           ,[VisitadorMedico]
           ,[Capacitacion]
           ,[Imagen]
		   ,[CodigoBarras]
		   ,[StockDefaultValue]
		   ,[ImagenWeb]
		   ,[ImagenMovil]
		   ,[PermiteFotosDeBiblioteca]
		   ,[marcaLabel])
     VALUES
           (@Nombre
           ,@IdEmpresa
           ,@Transfer
           ,@Dermoestetica
           ,@Mantenimiento
           ,@VisitadorMedico
           ,@Capacitacion
           ,@Imagen
		   ,@CodigoBarras
		   ,@StockDefaultValue
		   ,@Imagen
		   ,@Imagen
		   ,@PermiteFotosDeBiblioteca
		   ,@LabelMarca)
	
	SET @IdCliente = @@identity

END

GO
