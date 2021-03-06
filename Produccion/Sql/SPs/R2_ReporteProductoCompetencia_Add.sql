SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteProductoCompetencia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteProductoCompetencia_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,dbo.R2_ReporteEmpresaCompetencia_Delete,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteProductoCompetencia_Add]

    @IdReporte2 int
   ,@IdMarca int
   ,@IdProducto int
   ,@IdExhibidor int = NULL
   ,@Stock int = NULL
   ,@SellOut int = NULL
   ,@Comentarios varchar(MAX) = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [R2_ReporteProductoCompetencia]
           ([IdReporte2]
           ,[IdMarca]
           ,[IdProducto]
           ,[IdExhibidor]
           ,[Stock]
           ,[SellOut]
           ,[Comentarios])
     VALUES
           (@IdReporte2
           ,@IdMarca
           ,@IdProducto
           ,@IdExhibidor
           ,@Stock
           ,@SellOut
           ,@Comentarios)

END
GO
