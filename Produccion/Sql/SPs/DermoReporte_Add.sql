SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DermoReporte_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DermoReporte_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DermoReporte_Add]
	-- Add the parameters for the stored procedure here
    @IdPuntoDeVenta int
   ,@IdUsuario int
   ,@Fecha datetime
   ,@IdDermoAccion int
   ,@HorarioEntrada varchar(10) = NULL
   ,@HorarioSalida varchar(10)= NULL
   ,@TurnosTomados int= NULL
   ,@TurnoAsistencia int= NULL
   ,@ClientesCaptados int = NULL
   ,@Contactos int= NULL
   ,@VentasSinAccionLRP int = NULL
   ,@VentasSinAccionVICHY int = NULL
   ,@Visitas int = NULL
   ,@ClientesBeauty int = NULL
   ,@VoucherVichy int = NULL
   ,@VoucherLRP int = NULL
   ,@Problemas varchar(MAX) = NULL
   ,@Comentarios varchar(MAX) = NULL
   ,@ComprasLuegoAsesoriamiento int = NULL
   ,@ObjetivoVentas int = NULL
   ,@IdDermoReporte int output


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[DermoReporte]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
           ,[Fecha]
           ,[IdDermoAccion]
           ,[HorarioEntrada]
           ,[HorarioSalida]
           ,[TurnosTomados]
           ,[TurnoAsistencia]
           ,[ClientesCaptados]
           ,[Contactos]
           ,[VentasSinAccionLRP]
           ,[VentasSinAccionVICHY]
           ,[Visitas]
           ,[ClientesBeauty]
           ,[VoucherVichy]
           ,[VoucherLRP]
           ,[Problemas]
           ,[Comentarios]
           ,[ComprasLuegoAsesoriamiento]
           ,[ObjetivoVentas])
     VALUES
           (@IdPuntoDeVenta
           ,@IdUsuario
           ,@Fecha
           ,@IdDermoAccion
           ,@HorarioEntrada
           ,@HorarioSalida
           ,@TurnosTomados
           ,@TurnoAsistencia
           ,@ClientesCaptados
           ,@Contactos
           ,@VentasSinAccionLRP
           ,@VentasSinAccionVICHY
           ,@Visitas
           ,@ClientesBeauty
           ,@VoucherVichy
           ,@VoucherLRP
           ,@Problemas
           ,@Comentarios           
           ,@ComprasLuegoAsesoriamiento
           ,@ObjetivoVentas)

	SET @IdDermoReporte = @@identity
	
END
GO
