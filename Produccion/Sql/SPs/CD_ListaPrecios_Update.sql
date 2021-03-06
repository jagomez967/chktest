SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_ListaPrecios_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_ListaPrecios_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_ListaPrecios_Update]
	
    @Codigo varchar(50)
   ,@FechaDesde datetime
   ,@SinImpuestos decimal(18,2) = NULL
   ,@IVA decimal(18,2) = NULL
   ,@Comercio decimal(18,2) = NULL
   ,@PrecioSugerido decimal(18,2) = NULL
   ,@IdSistema int = NULL
   ,@Activo bit = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE  [dbo].[CD_ListaPrecios]
   SET [FechaDesde] = @FechaDesde
      ,[SinImpuestos] = @SinImpuestos
      ,[IVA] = @IVA 
      ,[Comercio] = @Comercio 
      ,[PrecioSugerido] = @PrecioSugerido 
      ,[IdSistema] = @IdSistema 
      ,[Activo] = @Activo 
 WHERE @Codigo = [Codigo] AND @FechaDesde = [FechaDesde]


END
GO
