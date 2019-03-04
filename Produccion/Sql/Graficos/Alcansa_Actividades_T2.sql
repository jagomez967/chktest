IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Alcansa_Actividades_T2'))
   exec('CREATE PROCEDURE [dbo].[Alcansa_Actividades_T2] AS BEGIN SET NOCOUNT ON; END')
Go
ALTER procedure [dbo].Alcansa_Actividades_T2
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
)
as
begin
/*
	
	Para filtrar en un query:
	Utilizar las vistas con filtros aplicados.
	De ser necesario agregar filtros debajo de esta linea (multiClientes)
*/		

	SET LANGUAGE spanish
	set nocount on

	if @lenguaje = 'es' set language spanish
	if @lenguaje = 'en' set language english

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		idReporte int,
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, idReporte)
	select distinct r.IdPuntoDeVenta, r.IdEmpresa, max(r.IdReporte)
	from f_Reporte(@filtros) r
	inner join f_PuntoDeVenta(@filtros) pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
	group by r.idPuntoDeVenta, r.idEmpresa


	create table #datosRes
	(
		categoria varchar(100),
		total int,
	)


	insert #datosRes (categoria, total)
	select mp.Nombre, count(rmp.idMarcaPropiedad) from #reportesMesPdv r
	inner join ReporteMarcaPropiedad rmp on r.idReporte = rmp.idReporte
	inner join MarcaPropiedad mp on mp.idMarcaPropiedad = rmp.idMarcaPropiedad
	group by mp.Nombre

	select categoria, total from #datosRes



end

GO



