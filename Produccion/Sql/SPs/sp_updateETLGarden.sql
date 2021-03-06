SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_updateETLGarden]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_updateETLGarden] AS' 
END
GO
ALTER procedure [dbo].[sp_updateETLGarden]  
(  
 @año char(4),  
 @tablename varchar(255)  
)  
as  
begin  
 Create table #OperacionesGarden
(	nombreTable varchar(200),
	Operacion NVARCHAR(10),
	idzona int,
	año int,
	mes int,
	valorNuevo numeric(12,1),
	valorAnterior numeric(12,1)
) 
declare @colPivot varchar(max)  
declare @cuotaVentas varchar(100)  
declare @tablename_EQ varchar(255)  
  
--set @tablename = 'ETL_RealVentasGarden'  
--set @año = '2016'  
  
if (@tablename = 'ETL_RealVentasGarden'   
 or @tablename = 'ETL_RealTransferencistasGarden')  
 set @CuotaVentas = 'Ventas'  
  
if (@tablename = 'ETL_CumplimientoTransferencistasGarden'  
 or @tablename = 'ETL_CumplimientoVentasGarden')  
 set @CuotaVentas = 'Cuota'  
  
if @tablename like '%transferencistas%'  
 set @tablename_EQ = 'ETL_ZonasTransferencistas'  
if @tablename like '%ventas%'  
 set @tablename_EQ = 'ETL_ZonasVentas'  
  
;with Meses as (  
 select 1 as mes  
 union all  
 select mes + 1  
 from Meses  
 where mes < 12  
)   
  
select @colPivot = coalesce(@colPivot + ', [' +cast(mes as varchar) + '/1/' + @año + ']',   
       '['+ cast(mes as varchar) + '/1/'+ @año + ']')  
from meses  
  
declare @sqlExec varchar(max)  
  
set @sqlExec =   
'  
  
  
update dbo.['''+@año+'$'']  
set [id user/zona] = ZV.idZona  
from dbo.['''+@año+'$''] x  
inner join '+@tablename_EQ+' ZV  
on ZV.descripcion = x.[Zona]   
where x.[id user/zona] is null  
  
  
SELECT   
   [id User/Zona] as idZona,  
   year(fecha) as año,  
   cast(substring(fecha,0,charindex(''/'',fecha,0)) as integer) as mes,  
   cast('+@CuotaVentas+' as float) as '+@CuotaVentas+'  
 into #tempPivot  
 FROM  
(SELECT [id User/Zona],'+@colPivot+'   
FROM  dbo.['''+@año+'$'']) P  
UNPIVOT ('+@CuotaVentas+' FOR fecha IN ('+@colPivot+')) AS Unpvt;  
  
  
MERGE '+@tablename+' as Target  
USING   
(  
 select idZona,año,mes,'+@CuotaVentas+'  
 from #TempPivot  
)  
 AS source (idZona,año,mes,'+@CuotaVentas+')  
ON( target.idZona = source.idZona  
 and target.año = source.año   
 and target.mes = source.mes)  
WHEN MATCHED THEN  
 UPDATE SET '+@CuotaVentas+' = source.'+@CuotaVentas+'  
WHEN NOT MATCHED BY TARGET THEN  
 INSERT (idZona,año,mes,'+@CuotaVentas+')  
 VALUES (source.idZona,source.año,source.mes,source.'+@CuotaVentas+')  
WHEN NOT MATCHED BY SOURCE and target.año = '+@año+'  
 THEN DELETE   
	OUTPUT
	'''+@tablename+''',
	$action,
	coalesce(inserted.idZona,deleted.idZona),
	coalesce(inserted.año,deleted.año),
	coalesce(inserted.mes,deleted.mes),
	coalesce(inserted.'+@CuotaVentas+',0),
	coalesce(deleted.'+@CuotaVentas+',0)	
	INTO #OperacionesGarden
	;'  
  
exec(@sqlExec)  
if @@error <> 0   
 return 1  
  
  
  

delete from #OperacionesGarden
where Operacion = 'UPDATE'
and valorNuevo = valorAnterior

insert Log_ETL_JOBS(nombreJOB,nombreTABLA,Descripcion,es_error,NuevoValor,AntiguoValor)
select 'JOB_Garden_PE_Cumplimiento',
	   op.nombreTable,
	   u.Usuario + '(ID:' + CAST(op.idZona as varchar) + ')'
	   + ' mes:' + CAST(op.mes as varchar)
	   + ' año:' + CAST(op.año as varchar)
	   + ' - ' + op.Operacion ,
	   0,
	   op.valorNuevo,
	   op.valorAnterior
	   from #OperacionesGarden op
	   inner join Usuario u on u.IdUsuario = op.idZona  
  
  DROP table #OperacionesGarden

return 0  
end  
GO
