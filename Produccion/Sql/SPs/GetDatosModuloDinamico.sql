SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDatosModuloDinamico]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDatosModuloDinamico] AS' 
END
GO
ALTER procedure [dbo].[GetDatosModuloDinamico]
(
	 @IdEmpresa int
	,@IdCadena varchar(max) = NULL
	,@IdPuntoDeVenta varchar(max) = NULL
	,@IdLocalidad varchar(max) = NULL
	,@IdZona varchar(max) = NULL
	,@IdUsuario varchar(max) = NULL
	,@FechaDesde datetime = null
	,@FechaHasta datetime = null
)
as
begin

	

	Select	ltrim(rtrim(c.nombre)) as Cliente
			,convert(varchar,r.fechaCreacion,103) as FechaReporte
			,r.IdReporte as Reporte
			,ltrim(rtrim(p.Nombre)) as Pdv
			,ltrim(rtrim(u.Apellido)) + ', '+ ltrim(rtrim(u.Nombre)) collate database_default as Rtm
			--,ltrim(rtrim(m.nombre)) as Marca
			,ltrim(rtrim(mm.Nombre)) as Modulo
			,ltrim(rtrim(mi.Nombre)) as Item
			,case when isnull(rmi.Valor1,'0')='1' then (select labelcampo1 from MD_Item where IdItem=rmi.iditem) else '' end as Valor1
			,case when isnull(rmi.Valor2,'0')='1' then (select labelcampo2 from MD_Item where IdItem=rmi.iditem) else '' end as Valor2
			,case when isnull(rmi.Valor3,'0')='1' then (select labelcampo3 from MD_Item where IdItem=rmi.iditem) else '' end as Valor3
			,case when isnull(rmi.Valor4,'')<>'' then (select labelcampo4 from MD_Item where IdItem=rmi.iditem) else '' end as Valor4
	from MD_ReporteModuloItem rmi
	inner join reporte r on r.IdReporte=rmi.IdReporte
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join usuario u on u.IdUsuario=r.IdUsuario
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	inner join MD_Item mi on mi.IdItem=rmi.IdItem
	inner join MD_Modulo mm on mm.IdModulo=mi.IdModulo
	inner join marca m on m.IdMarca=rmi.IdMarca
	where	r.IdEmpresa=@IdEmpresa
			and r.FechaCreacion between @FechaDesde and @FechaHasta
			and (isnull(rmi.Valor1,'0')='1' or isnull(rmi.Valor2,'0')='1' or isnull(rmi.Valor3,'0')='1' or isnull(rmi.Valor4,'')<>'')
	order by c.IdCliente, r.FechaCreacion, r.IdReporte, rmi.IdItem
end
GO
