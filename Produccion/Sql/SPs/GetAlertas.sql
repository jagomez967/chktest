SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetAlertas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetAlertas] AS' 
END
GO
ALTER procedure [dbo].[GetAlertas]
as
begin
	--exec GetAlertas
	select Id, IdCliente, IdUsuario, Descripcion, Consolidado, Hora, Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo, AccionTriggerSeleccionada, TipoReporteSeleccionado, Destinatarios, FechaCreacion, PuntosDeVenta, FechaUltimoEnvio from alertas
	where consolidado=1 and activo = 1 and eliminado = 0
	and hora is not null

end

GO
  
  --
