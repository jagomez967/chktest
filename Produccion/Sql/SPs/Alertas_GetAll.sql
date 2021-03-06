SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Alertas_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Alertas_GetAll] AS' 
END
GO
ALTER procedure [dbo].[Alertas_GetAll]
(
	@IdEmpresa	int
)
as
begin

declare @idCLiente int
select @idCliente  = idCLiente from cliente where idEmpresa = @idEmpresa



CREATE TABLE #Clientes (idCliente INT)

	INSERT #clientes (idCliente)
	SELECT fc.idCliente
	FROM familiaClientes fc
	WHERE fc.familia IN (
			SELECT familia
			FROM familiaClientes
			WHERE idCliente = @idCLiente
				--AND activo = 1
			)

	IF @@rowcount = 0
	BEGIN
		INSERT #clientes (idcliente)
		VALUES (@idCliente)
	END
	
	--exec Alertas_GetAll 1
	select	a.Id
			,a.IdCliente
			,a.IdUsuario
			,a.Descripcion
			,a.Consolidado
			,a.Hora
			,a.Lunes
			,a.Martes
			,a.Miercoles
			,a.Jueves
			,a.Viernes
			,a.Sabado
			,a.Domingo
			,a.AccionTriggerSeleccionada
			,a.TipoReporteSeleccionado
			,a.Destinatarios
			,a.Activo
			,a.FechaCreacion
			,a.PuntosDeVenta
			,a.Distancia
	from alertas a
	inner join cliente c on c.idcliente = a.idcliente
	where--	(@IdEmpresa is null or c.IdEmpresa = @IdEmpresa)
			c.idCLiente in (select idCliente from #clientes)
			and isnull(a.Activo,0)=1
			and isnull(a.Eliminado,0)=0
end

GO


--select *From familiaClientes where familia = 'LAM_ISDIN'