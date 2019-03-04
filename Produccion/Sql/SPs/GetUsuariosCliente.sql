ALTER PROCEDURE [dbo].[GetUsuariosCliente]
(
	@IdCliente	int,
	@Filtros			FiltrosReporting readonly
)
AS
BEGIN

create table #Clientes (idCliente int)

insert  #clientes(idCliente)
select idCliente 
From familiaClientes 
where familia in (
	select familia 
	from familiaclientes 
	where idCliente  = @idCliente  
		and activo = 1 )
if @@ROWCOUNT = 0
insert #clientes(idCliente)
values(@idCliente)

	create table #usuarios
	(
		idUsuario int
	)
	create table #tipoRtm
	(
		idTipoRtm int
	)

	create table #puntosdeventa
	(
		idPuntoDeVenta int
	)

	declare @cUsuarios varchar(max)
	declare @cPuntosDeVenta varchar(max)

	insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''
	set @cUsuarios = @@ROWCOUNT

	insert #puntosdeventa (idPuntoDeVenta) select clave as idPuntoDeVenta from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPuntosDeVenta'),',') where isnull(clave,'')<>''
	set @cPuntosDeVenta = @@ROWCOUNT

	SELECT DISTINCT
			U.Nombre,
			U.Apellido,
			U.IdUsuario,
			U.Imagen
		FROM 
			Usuario U
			INNER JOIN Usuario_Cliente UC ON UC.IdUsuario = U.IdUsuario
			inner join puntodeventa_cliente_usuario pcu on pcu.idUsuario = u.idUsuario
			and pcu.idCliente = uc.idCliente 
			LEFT JOIN UsuarioGrupo UG ON U.idUsuario = UG.idUsuario		
		WHERE
			UC.IdCliente in(select idCliente from #clientes)
			AND ISNULL(U.esCheckPos,0) = 0
			AND ISNULL(U.Activo,0) = 1
			AND ISNULL(UG.idGrupo,2) != 1		
			AND pcu.Activo = 1
			and not exists 
			(select 1 from puntodeventa_cliente_usuario 
			where activo = 0 and fecha > pcu.fecha 
			and idCliente = pcu.idCliente 
			and idUsuario = pcu.idUsuario
			and idPuntodeventa = pcu.idPuntodeventa)
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pcu.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = u.IdUsuario))	

END
go


