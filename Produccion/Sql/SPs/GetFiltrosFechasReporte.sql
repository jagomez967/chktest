SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosFechasReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosFechasReporte] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosFechasReporte]
(
	@IdCliente int
)
as
begin
	--exec GetFiltrosFechasReporte 12

	create table #anios
	(
		anio varchar(4)
	)

	create table #meses
	(
		mes varchar(2)
	)

	insert #meses (mes) values ('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9'),('10'),('11'),('12')

	insert #anios (anio)
	SELECT YEAR(R.FechaCreacion) as anio          
	FROM Reporte R
	inner join Cliente C on C.IdEmpresa = R.IdEmpresa
	WHERE C.IdCliente = @idcliente
	GROUP BY YEAR(R.FechaCreacion)
	ORDER BY YEAR(R.FechaCreacion) DESC

	select anio as ano from #anios

	select a.anio as ano, m.mes as mes
	from #anios a, #meses m

	
end
GO
