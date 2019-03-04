--drop table #tablaPonderaciones
--drop table #Marcas
create table #tablaPonderaciones
(	idReporte int,
	idMarca int,
	ponderacionMarca decimal(9,5),
	idModulo int,
	ponderacionModulo decimal(9,5),
	idItem int,
	PonderacionItem decimal(9,5),
	Valor bit
)
create table #marcas
(
idMarca int
)


IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_Calculo_Ponderacion'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_Calculo_Ponderacion] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_Calculo_Ponderacion] 	
as
begin
	declare @contadorCiclos int,
		    @numMarcas int,
			@cMarcas int 





	select @cMarcas = count(1) from #marcas

	create table #ponderacionMarca 
	(idReporte int,
	 sumaponderacion decimal(12,9))
	
	create table #ponderacionModulo 
	(idReporte int,
	 idMarca int,
	 sumaponderacion decimal(12,9))

	 create table #ponderacionItem 
	(idReporte int,
	 idMarca int,
	 idModulo int,
	 sumaponderacion decimal(12,9))


	 
--CREATE NONCLUSTERED INDEX IX_reporte  
--ON #tablaPonderaciones (idReporte)  
--INCLUDE ([PonderacionMarca]);

CREATE NONCLUSTERED INDEX IX_reporte_full
ON #tablaPonderaciones (idReporte,idMarca,idModulo)  
INCLUDE ([PonderacionMarca]);

CREATE INDEX IX_ponderacionModulo
ON #tablaPonderaciones (idReporte,idMarca) INCLUDE (PonderacionModulo)

CREATE INDEX IX_ponderacionModulo_2
ON #ponderacionModulo (idReporte,idMarca) INCLUDE (sumaPonderacion)

CREATE INDEX IX_ponderacionItem
ON #tablaPonderaciones (idReporte,idMarca,idModulo) INCLUDE (PonderacionItem)

CREATE INDEX IX_ponderacionItem_2
ON #ponderacionItem (idReporte,idMarca,idModulo) INCLUDE (sumaPonderacion)



	insert #tablaPonderaciones (idReporte, idMarca,ponderacionMarca,idModulo,PonderacionModulo,idItem,PonderacionItem,Valor)
	select  RMI.idReporte
	        ,RMI.idMarca 
			,MP.ponderacion
			,MM.idModulo 
			,MO.ponderacion
			,I.idItem
			,MMI.Ponderacion as ponderacionItem
			,RMI.valor1
	from md_reporteModuloItem rmi
	inner join #tempReporte t on t.idReporte = RMI.idReporte
	inner join md_item I on I.idItem = rmi.idItem
	inner join md_modulo MM on MM.idModulo = I.idModulo
	inner join md_moduloMarca MO on MO.idModulo = MM.idModulo
		and MO.idMarca = RMI.idMarca
	inner join md_moduloMarcaItem MMI on MMI.idMarca = RMI.idMarca
		and MMI.idItem = I.idItem 
	inner join marca M on M.idMarca = RMI.idMarca
		and M.idEmpresa = t.idEmpresa
	inner join MD_MarcaPonderacion MP on MP.idMarca = RMI.idMarca
	where (isnull(@cMarcas,0)=0 or exists(select 1 from #marcas where idMarca = RMI.idMarca))
	and (rmi.valor2 | rmi.valor1) = 1
	 
	 /*delete t
	 From #tablaponderaciones t
	 where t.valor = 0
	 and not exists (select 1 from
	 #tablaponderaciones t2 where 
	 t2.idReporte = t.idReporte and
	 t2.idMarca = t.idMarca and
	 t2.idModulo = t.idModulo and
	 t2.valor = 1)
	 --order by idReporte,idMarca,idModulo,
	 */
	 
	;WITH Marca_ponderada (idReporte,idMarca,ponderacionMarca)  
	AS  
	(  
    select distinct idReporte,idMarca,ponderacionMarca from  #tablaPonderaciones
	) 
	
	--Total Ponderacion(MARCA) por reporte
	insert #ponderacionMarca (idReporte,sumaPonderacion)
	select idReporte,sum(ponderacionMarca) from
	Marca_ponderada
	group by idReporte
	having sum(ponderacionMarca) <> 100

	update #tablaPonderaciones
	set ponderacionMarca = ((t.ponderacionMarca * 100.0)/pm.sumaPonderacion)
	from #tablaPonderaciones t
	inner join #ponderacionMarca pm
	on pm.idReporte = t.idReporte


	set @NumMarcas = 1
	set @contadorCiclos = 0
	--Total ponderacion(MODULO) por reporte-marca
	while @NumMarcas >= 0 and @contadorCiclos < 2 begin

		insert #ponderacionModulo (idreporte,idMarca,sumaPonderacion)
		select idReporte,idMarca,sum(ponderacionModulo) from
		(select distinct idreporte,idMarca,idModulo,PonderacionModulo from #tablaPonderaciones)y
		group by idReporte,idMarca
		having sum(ponderacionModulo) <> 100
		set @NumMarcas = @@rowcount

		update #tablaPonderaciones
		set ponderacionModulo = ((t.ponderacionModulo * 100.0)/pm.sumaPonderacion)
		from #tablaPonderaciones t
		inner join #ponderacionModulo pm
		on pm.idReporte = t.idReporte
		and pm.idMarca = t.idMarca
		
		delete from #ponderacionModulo
		
		set @contadorCiclos = @contadorCiclos + 1
	end


	insert #ponderacionItem (idreporte,idMarca,idModulo,sumaPonderacion)
	select idReporte,idMarca,idModulo,sum(ponderacionItem) from
	(select distinct idreporte,idMarca,idModulo,idItem,PonderacionItem from #tablaPonderaciones)y
	group by idReporte,idMarca,idModulo
	having sum(ponderacionItem) <> 100
	

	update #tablaPonderaciones
	set ponderacionItem = ((t.ponderacionItem * 100.0)/pm.sumaPonderacion)
	from #tablaPonderaciones t
	inner join #ponderacionItem pm
	on pm.idReporte = t.idReporte
	and pm.idMarca = t.idMarca
	and pm.idModulo = t.idModulo

	Drop table #ponderacionMarca 
	Drop table #ponderacionModulo 
	Drop table #ponderacionItem 

end

go
drop table #tablaPonderaciones
go
drop table #Marcas
go



