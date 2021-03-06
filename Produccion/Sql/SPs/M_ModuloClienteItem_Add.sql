SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[M_ModuloClienteItem_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[M_ModuloClienteItem_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[M_ModuloClienteItem_Add]
    @IdModuloItem int
   ,@IdModuloCliente int
   ,@Leyenda varchar (50)
   ,@Visibilidad bit
   ,@Obligatorio bit
   ,@ValorMaximo decimal(18,3) =NULL
   ,@Activo bit 
	,@Orden int=0
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS (SELECT * FROM [dbo].[M_ModuloClienteItem] WHERE @IdModuloItem = [IdModuloItem] AND @IdModuloCliente=[IdModuloCliente])
	BEGIN
		UPDATE [dbo].[M_ModuloClienteItem]
	   SET [Leyenda] = @Leyenda
		  ,[Visibilidad] = @Visibilidad
		  ,[Obligatorio] = @Obligatorio
		  ,[ValorMaximo] = ISNULL(@ValorMaximo,0)
		  ,[Activo] = @Activo
		  ,[Orden]=@Orden
		WHERE @IdModuloItem = [IdModuloItem] AND @IdModuloCliente=[IdModuloCliente]
	END
	ELSE
	BEGIN    
		INSERT INTO [dbo].[M_ModuloClienteItem]
			   ([IdModuloItem],[IdModuloCliente],[Leyenda],[Visibilidad],[Obligatorio],[ValorMaximo],[Activo],[Orden])
		 VALUES
			   (@IdModuloItem,@IdModuloCliente,@Leyenda,@Visibilidad,@Obligatorio,ISNULL(@ValorMaximo,0),@Activo,@Orden)	
	END			   
END

GO
