SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ReporteModuloItem_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ReporteModuloItem_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ReporteModuloItem_Add]	
    @IdItem int
   ,@Valor1 bit
   ,@Valor2 bit = NULL
   ,@Valor3 bit = NULL
   ,@Valor4 varchar(MAX) = NULL
   ,@IdReporte int
   ,@IdMarca int = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	select @idMarca = isnull(@idMarca,m.idMarca) from md_item i inner join md_moduloMarca m on m.idModulo = i.idModulo where i.idItem = @idItem

INSERT INTO [dbo].[MD_ReporteModuloItem]
           ([IdItem],[Valor1],[Valor2],[Valor3],[Valor4],[IdReporte],[IdMarca])
     VALUES
           (@IdItem,@Valor1,@Valor2,@Valor3,@Valor4,@IdReporte,@IdMarca)
END
GO

