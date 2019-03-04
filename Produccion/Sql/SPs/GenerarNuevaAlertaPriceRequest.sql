SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GenerarNuevaAlertaPriceRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GenerarNuevaAlertaPriceRequest] AS' 
END
GO
ALTER procedure [dbo].[GenerarNuevaAlertaPriceRequest]
(
	@Destinatario varchar(max)
)
AS  
BEGIN

declare @FechaCreacion datetime
declare @NewAlertaId int
select @FechaCreacion = GETDATE()

	INSERT INTO Alertas(IdCliente,IdUsuario,Descripcion,Consolidado,hora,lunes,martes,miercoles,jueves,viernes,Sabado,domingo,
	AccionTriggerSeleccionada,TipoReporteSeleccionado,destinatarios,activo,fechaCreacion,PuntosDeVenta,eliminado)

	SELECT IdCliente,IdUsuario,Descripcion,Consolidado,hora,lunes,martes,miercoles,jueves,viernes,Sabado,domingo,
	AccionTriggerSeleccionada,TipoReporteSeleccionado,@Destinatario,1,@fechaCreacion,PuntosDeVenta,0
	FROM Alertas WHERE id = 1074

	select @NewAlertaID = SCOPE_IDENTITY()

	return @NewAlertaID
END