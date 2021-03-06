SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[Cliente_Update]
	  @IdCliente int
	 ,@Nombre varchar(50)
     ,@IdEmpresa int
     ,@Transfer bit
     ,@Dermoestetica bit
     ,@Mantenimiento bit
     ,@Capacitacion bit
     ,@VisitadorMedico bit
     ,@Imagen varchar(MAX) = NULL
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
	UPDATE [dbo].[Cliente]
	SET [Nombre] = @Nombre
       ,[IdEmpresa] = @IdEmpresa
       ,[Transfer] = @Transfer
       ,[Dermoestetica] = @Dermoestetica
       ,[Mantenimiento] = @Mantenimiento
       ,[VisitadorMedico] = @VisitadorMedico
       ,[Capacitacion] = @Capacitacion
       ,[Imagen] = @Imagen
	   ,[CodigoBarras] = @CodigoBarras
	   ,[StockDefaultValue] = @StockDefaultValue
	   ,[ImagenWeb] =  @Imagen
	   ,[ImagenMovil] =  @Imagen
	   ,[PermiteFotosDeBiblioteca] = @PermiteFotosDeBiblioteca
	   ,[marcaLabel] = @LabelMarca
	 WHERE [IdCliente] = @IdCliente

END

GO
