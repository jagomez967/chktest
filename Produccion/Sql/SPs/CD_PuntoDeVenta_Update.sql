SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_Update]
	
	@IdPuntoDeVenta int 
   ,@Codigo varchar(50) = NULL
   ,@Nombre varchar(255) = NULL
   ,@Direccion varchar(255) = NULL
   ,@IdCadena int = NULL  
   ,@IdRegion int = NULL
   ,@Activo bit = NULL
   
   
AS
BEGIN
	SET NOCOUNT ON;

UPDATE [dbo].[CD_PuntoDeVenta]
   SET [Codigo] = @Codigo
      ,[Nombre] = @Nombre
      ,[Direccion] = @Direccion
      ,[IdCadena] = @IdCadena
      ,[IdRegion] = @IdRegion
      ,[Activo] = @Activo
 WHERE @IdPuntoDeVenta= [IdPuntoDeVenta] 
           
END
GO
