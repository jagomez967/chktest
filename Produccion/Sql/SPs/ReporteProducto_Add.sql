SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteProducto_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteProducto_Add] AS' 
END
GO

ALTER PROCEDURE [dbo].[ReporteProducto_Add]
    @IdReporte int
   ,@IdProducto int
   ,@Cantidad int = NULL
   ,@Precio decimal(18,3) = NULL
   ,@Stock int = NULL
   ,@NoTrabaja int = NULL
   ,@IdExhibidor int = NULL
   ,@Cantidad2 int = NULL
   ,@IdExhibidor2 int = NULL
   ,@Precio2 decimal(18,3) = NULL
   ,@Precio3 decimal(18,3) = NULL
AS
BEGIN

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
	
	if(@Precio2<0)
	begin
		set @Precio2=0
	end
	
	if(@Precio3<0)
	begin
		set @Precio3=0
	end

	INSERT INTO [dbo].[ReporteProducto]
           ([IdReporte]
           ,[IdProducto]
           ,[Cantidad]
           ,[Precio]
           ,[Stock]
           ,[NoTrabaja]
           ,[IdExhibidor]
           ,[Cantidad2]
           ,[IdExhibidor2]
		   ,[Precio2]
		   ,[Precio3])
     VALUES
           (@IdReporte
           ,@IdProducto
           ,@Cantidad
           ,@Precio
           ,@Stock
           ,@NoTrabaja
           ,@IdExhibidor
           ,@Cantidad2
           ,@IdExhibidor2
		   ,@Precio2
		   ,@Precio3)
END
GO
