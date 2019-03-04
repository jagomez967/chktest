IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ClaroChile_MejoresSucursales_T9'))
   exec('CREATE PROCEDURE [dbo].[ClaroChile_MejoresSucursales_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[ClaroChile_MejoresSucursales_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
	,@mejores           bit = 0
)
as
begin
exec ClaroChile_RankingSucursales_T9 
 	@IdCliente			= @IdCliente
	,@Filtros			= @Filtros
	,@NumeroDePagina	= @NumeroDePagina
	,@Lenguaje			= @Lenguaje
	,@IdUsuarioConsulta = @IdUsuarioConsulta
	,@TamañoPagina		= @TamañoPagina
	,@mejores           = 0
end