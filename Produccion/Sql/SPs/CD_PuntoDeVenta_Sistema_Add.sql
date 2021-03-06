SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_Sistema_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_Sistema_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_Sistema_Add]
	-- Add the parameters for the stored procedure here
    @IdPuntoDeVenta int
   ,@IdSistema int
   ,@IdVisitador int = NULL
   ,@IdRepresentante int = NULL
   ,@Activo bit = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_PuntoDeVenta_Sistema]
           ([IdPuntoDeVenta]
           ,[IdSistema]
           ,[IdVisitador]
           ,[IdRepresentante]
           ,[Activo])
     VALUES
           (@IdPuntoDeVenta
           ,@IdSistema
           ,@IdVisitador
           ,@IdRepresentante
           ,@Activo)

END
GO
