
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IsdinBaseObjetivo'))
   exec('CREATE PROCEDURE [dbo].[IsdinBaseObjetivo] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[IsdinBaseObjetivo]
(
	@fechaDesde DATE,
	@fechaHasta	DATE,
	@idCliente	INT = 175
)
as
begin

	;WITH DateTable
	AS
	(
		SELECT @fechaDesde AS [DATE]
		UNION ALL
		SELECT DATEADD(dd, 1, [DATE])
		FROM DateTable 
		WHERE DATEADD(dd, 1, [DATE]) <= @fechaHasta
	)
	SELECT 
		DT.DATE Dia
	INTO
		#fechas
	FROM 
		[DateTable] DT        
		LEFT JOIN IsdinDiasExcluidos DE ON DT.DATE = DE.Fecha
	WHERE DE.Fecha IS NULL
	OPTION (MAXRECURSION 0)
	 
	insert #baseObjetivo(idUsuario,objetivo,fecha)
	select distinct u.idUsuario,d.objetivo,f.dia
	 From Usuario u
	 left join usuario_cliente uc on u.idusuario = uc.idusuario
	 left join UsuarioGrupo ug on ug.IdUsuario=u.IdUsuario
	left join #tempReporte r on u.idusuario = r.idusuario
	left join ISDINObjetivoDiarios d on isnull(r.idCliente,uc.idcliente) = d.idCliente
	cross join #fechas f
	where uc.idcliente in ((select fc.idCliente from familiaClientes fc  
								where fc.familia in (select familia from familiaClientes where idCliente = @idCliente  
								and activo = 1)  ))
			 and u.escheckpos=0 and u.activo = 1 and ug.idgrupo = 2

	drop table #fechas
END

go

