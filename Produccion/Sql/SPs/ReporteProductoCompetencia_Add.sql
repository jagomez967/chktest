SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteProductoCompetencia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteProductoCompetencia_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteProductoCompetencia_Add]
	-- Add the parameters for the stored procedure here
    @IdReporte int
   ,@IdProducto int
   ,@IdMarca int = NULL
   ,@Cantidad int = NULL
   ,@Precio decimal(18,3) = NULL
   ,@IdExhibidor int = NULL
   ,@Cantidad2 int = NULL
   ,@IdExhibidor2 int = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@Cantidad<0)
	begin
		set @Cantidad=0
	end
	
	if(@Cantidad2<0)
	begin
		set @Cantidad2=0
	end
	
	if(@Precio<0)
	begin
		set @Precio=0
	end

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ReporteProductoCompetencia]
           ([IdReporte]
           ,[IdProducto]
           ,[IdMarca]
           ,[Cantidad]
           ,[Precio]
           ,[IdExhibidor]
           ,[Cantidad2]
           ,[IdExhibidor2])
     VALUES
           (@IdReporte
           ,@IdProducto
           ,@IdMarca
           ,@Cantidad
           ,@Precio
           ,@IdExhibidor
           ,@Cantidad2
           ,@IdExhibidor2)
END

GO
