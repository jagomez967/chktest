SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Instancia_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Instancia_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Instancia_Update]
	
        @IdInstancia int
       ,@Nombre varchar(200)=NULL
       ,@ImagenWeb varchar(MAX)=NULL
       ,@ImagenMovil varchar(MAX)=NULL
       ,@BaseDatos varchar(200)=NULL
       ,@Usuario varchar(200)=NULL
       ,@Clave varchar(200)=NULL
       ,@URL varchar(200)=NULL
       ,@AplicacionWeb varchar(200)=NULL
       ,@Latitud decimal(11,8)=NULL
       ,@Longitud decimal(11,8)=NULL
       ,@DiferenciaHora int = NULL
       ,@DiferenciaMinutos int=NULL
       
       
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Instancia]
    SET [IdInstancia] = @IdInstancia
       ,[Nombre] = @Nombre
       ,[ImagenWeb] = @ImagenWeb
       ,[ImagenMovil] = @ImagenMovil
       ,[BaseDatos] = @BaseDatos
       ,[Usuario] = @Usuario
       ,[Clave] = @Clave
       ,[URL] = @URL
       ,[AplicacionWeb] = @AplicacionWeb
       ,[Latitud] = @Latitud 
       ,[Longitud] = @Longitud
       ,[DiferenciaHora] = @DiferenciaHora
       ,[DiferenciaMinutos] = @DiferenciaMinutos
       
END
GO
