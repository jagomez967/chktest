SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_ListaPrecios_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_ListaPrecios_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_ListaPrecios_Add]
	
    @Codigo varchar(50)
   ,@FechaDesde datetime = NULL
   ,@SinImpuestos decimal(18,2) = NULL
   ,@IVA decimal(18,2) = NULL
   ,@Comercio decimal(18,2) = NULL
   ,@PrecioSugerido decimal(18,2) = NULL
   ,@IdSistema int = NULL
   ,@Activo bit = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_ListaPrecios]
           ([Codigo]
           ,[FechaDesde]
           ,[SinImpuestos]
           ,[IVA]
           ,[Comercio]
           ,[PrecioSugerido]
           ,[IdSistema]
           ,[Activo])
     VALUES
           (@Codigo
           ,@FechaDesde
           ,@SinImpuestos
           ,@IVA
           ,@Comercio
           ,@PrecioSugerido
           ,@IdSistema
           ,@Activo)

END
GO
