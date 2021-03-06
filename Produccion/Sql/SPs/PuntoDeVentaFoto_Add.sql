SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_Add]
    @IdPuntoDeVenta int
   ,@IdEmpresa int = NULL
   ,@IdUsuario int = NULL
   ,@FechaCreacion datetime = NULL
   ,@Estado bit  = NULL
   ,@Partes int = NULL
   ,@Comentario varchar(500) = NULL
   ,@IdReporte int = NULL
   ,@IdPuntoDeVentaFoto int output
AS
BEGIN
	SET NOCOUNT ON;

	declare @IdEmpresaMail int

	INSERT INTO [dbo].[PuntoDeVentaFoto]
           ([IdPuntoDeVenta]
           ,[IdEmpresa]
           ,[IdUsuario]
           ,[FechaCreacion]
           ,[Estado]
           ,[Partes]
           ,[Comentario]
           ,[IdReporte])
     VALUES
           (@IdPuntoDeVenta 
           ,@IdEmpresa
           ,@IdUsuario
           ,@FechaCreacion
           ,@Estado
           ,@Partes
           ,@Comentario
           ,@IdReporte)

	 SET @IdPuntoDeVentaFoto = SCOPE_IDENTITY()

	 select @IdEmpresaMail = max(idEmpresaMail) from empresamail 
	 where	idReporte = @idReporte 
	 and	datediff(day,fechaCreacion,@fechaCreacion) = 0
	 and	IdAlerta in(select Id from Alertas where TipoReporteSeleccionado = 'reportecompleto')

	 if (@@rowcount > 0)
	 BEGIN
		exec spUpdateMailReporteCompleto @idReporte,@idEmpresaMail
	 end
END
GO
