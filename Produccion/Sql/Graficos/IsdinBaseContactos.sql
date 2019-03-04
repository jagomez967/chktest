
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IsdinBaseContactos'))
   exec('CREATE PROCEDURE [dbo].[IsdinBaseContactos] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[IsdinBaseContactos]
(
	@Modo INT = 0
)
as
begin

	IF @Modo = 0 BEGIN
		create table #OtrasActividades
		(
			contactos float,
			objetivo float,
			idUsuario int,
			idPuntodeventa int,
			idModulo int,
			idItem int,
			idCLiente int,
			dia date,
			respuesta varchar(500)
		)


		insert #OtrasActividades(contactos,objetivo,idUsuario,dia,idCliente,idModulo,idItem,respuesta)
		select sum(rmi.Valor1*isnull(act.contactos,0)) as contactos,
		o.objetivo,r.idUsuario,r.dia,r.idCliente,i.idModulo,i.idItem,rmi.valor4
		from md_ReporteModuloItem RMI
		inner join #tempReporte r
		on r.idReporte = RMI.idReporte
		inner join md_item i
		on i.idItem = RMI.idItem
		inner join IsdinActividades act
		on act.idModulo = i.idModulo
		and act.idItem = i.IdItem
		inner join isdinObjetivoDiarios o
		on o.idCliente = r.idCliente
		where rmi.Valor1*isnull(act.contactos,0)!= 0
		and r.idCliente in (163,161,160)
		group by o.objetivo,r.idUsuario,r.dia,r.idCliente,i.idModulo,i.idItem,rmi.valor4


		create table #vmTemp
		( contactos float,
		  idUsuario int,
		  dia date,
		  idCliente int,
		  idPuntodeventa int,
		  idItem int,
		  idModulo int,
		  idReporte int
		 )


		insert #vmTemp(idUsuario,dia,idCliente,contactos,idPuntodeventa,idItem,idModulo,idreporte)
		select r.idUsuario,r.dia,r.idCliente,1,r.idPuntodeventa,null,-1,r.idReporte
		from #tempReporte r
		where r.idCliente in(153,154)
		---Agrego LAM Reunion  (cliente = 152)
		union 
		select r.idUsuario,r.dia, r.idCliente,1,idPuntodeventa,null,-2,r.idReporte
		from #tempReporte r
		where r.idCliente = 152
		--Agrego LAM Charla/TALK/XL
		union 
		select r.idUsuario,r.dia, r.idCliente,3,idPuntodeventa,null,-3,r.idReporte
		from #tempReporte r
		where r.idCliente = 156
		--Agrego LAM Visita a Asesora
		union 
		select r.idUsuario,r.dia, r.idCliente,2,idPuntodeventa,null,-4,r.idReporte
		from #tempReporte r
		where r.idCliente = 158
		--LAM IMPULSO TIENE PONDERACION
		union
		select r.idUsuario,r.dia, r.idCliente,
		case when i.nombre = '25%' then 1.5
			 when i.nombre = '50%' then 3.0
			 when i.nombre = '75%' then 4.5
			 when i.nombre = '100%' then 6
		end ,idPuntodeventa,i.idItem,i.idModulo,r.idReporte
		from #tempReporte r
		inner join MD_ReporteModuloItem RMI
		on rmi.IdReporte = r.idReporte
		inner join md_item I
		on rmi.IdItem = i.idItem
		inner join md_modulo md
		on md.IdModulo = i.IdModulo 
		where r.idCliente = 159
			and md.nombre = '% de Jornada'
			and rmi.valor1 = 1
		--LAM EVENTOS TIENE PONDERACION
		union
		select r.idUsuario,r.dia, r.idCliente,
		case when i.nombre = '25%' then 1.5
			 when i.nombre = '50%' then 3.0
			 when i.nombre = '75%' then 4.5
			 when i.nombre = '100%' then 6
		end ,idPuntodeventa,i.idItem,i.idModulo,r.idReporte
		from #tempReporte r
		inner join MD_ReporteModuloItem RMI
		on rmi.IdReporte = r.idReporte
		inner join md_item I
		on rmi.IdItem = i.idItem
		inner join md_modulo md
		on md.IdModulo = i.IdModulo 
		where r.idCliente = 157
			and md.nombre = '% de Jornada'
			and rmi.valor1 = 1
		--REPORTE ASESORA TIENE PORCENTAJE
		union
		select r.idUsuario,r.dia, r.idCliente,
		case when i.nombre = '25%' then 0.25
			 when i.nombre = '50%' then 0.5
			 when i.nombre = '75%' then 0.75
			 when i.nombre = '100%' then 1
		end ,idPuntodeventa,i.idItem,i.idModulo,r.idReporte
		from #tempReporte r
		inner join MD_ReporteModuloItem RMI
		on rmi.IdReporte = r.idReporte
		inner join md_item I
		on rmi.IdItem = i.idItem
		inner join md_modulo md
		on md.IdModulo = i.IdModulo 
		where r.idCliente = 162
		and md.nombre = '% de Jornada'
			and rmi.valor1 = 1

		insert #baseContactos(idPuntodeventa,idUsuario,nombreModulo,nombreItem,respuesta,contactos,fecha,idReporte,idModulo)
		select null,idUsuario,m.nombre,i.nombre,o.respuesta,o.contactos,o.dia,null,o.idModulo
		from #OtrasActividades o 
		inner join md_item i on i.idItem = o.idItem
		inner join md_modulo m on m.idModulo = o.idModulo
		union
		select v.idPuntoDeVenta, v.idUsuario, 
		---MODULO
		case v.idCliente 
			 when  153 then 'Visita Medica' 
			 when  154 then 'Visita Farmacia' 
			 when  162 then 'Isdin - Reporte Asesora' 
			 when  152 then 'Isdin - Visita Farmacia'	  
			 when  159 then 'Isdin - Impulso' 
			 when  156 then 'Isdin - Talk/Charla/XL' 
			 when  158 then 'Isdin - Visita a Asesora' 
			 when  157 then 'Isdin - Eventos' 
		end ,
		---Item 	
		m.nombre + ':' + i.nombre,
		null, --Respuesta
		v.contactos,
		v.dia,
		v.idReporte,
		v.idModulo
		from #vmTemp v
		left join md_item i on i.idItem = v.idItem
		left join md_modulo m on m.idModulo = v.idModulo
		left join md_reporteModuloItem rmi on rmi.idReporte = v.idReporte and rmi.idItem = v.idItem

		update bc
		set respuesta = 
		'<b>' +m.nombre + '</b><br/><ul class="list-unstyled">' +
		(
		select  x.item + ': ' + isnull(x.texto,'') as li
		from
				(select m2.nombre as modulo, i2.nombre as Item, md2.valor4  as texto
				from md_reporteModuloItem md2
				inner join md_item i2 on i2.idItem = md2.idItem
				inner join md_modulo m2 on m2.idModulo = i2.idModulo
				where md2.valor1 = 1
				and isnull(md2.valor4,'') <> ''
				and md2.idreporte = md.idReporte
				and md2.idMarca = md.idMarca
				and i2.idModulo = i.idModulo
				)x
		for XML PATH('')
		)
		+ '</ul>'

		from md_reporteModuloItem md
		inner join marca mar on md.idMarca = mar.idMarca
		inner join md_item i on i.idItem = md.idItem
		inner join md_modulo m on m.idModulo = i.idModulo
		inner join  #baseContactos bc on bc.idreporte = md.idReporte
		where md.valor4 <> ''



		insert #baseContactos(idPuntodeventa,idUsuario,nombreModulo,nombreItem,respuesta,contactos,fecha,idReporte,idModulo)
		SELECT R.idPuntoDeVenta,R.idUsuario,'Reporte Vacio','','',1,R.FechaCreacion,t.idReporte,NULL
		FROM #tempReporte T
		INNER JOIN Reporte R ON T.idReporte = R.idReporte
		LEFT JOIN MD_ReporteModuloItem RMI ON R.idReporte = RMI.idReporte
		WHERE R.AuditoriaNoAutorizada = 0 AND ISNULL(RMI.idReporte,0) = 0

	END
	ELSE BEGIN
		insert #baseContactos(idPuntodeventa,idUsuario,nombreModulo,nombreItem,respuesta,contactos,fecha,idReporte,idModulo)
		select t.idPuntodeventa,t.idUsuario,m.nombre,i.nombre,rmi.valor4,null,null,t.idReporte,null
		from #tempReporte t
		inner join md_reporteModuloItem rmi on rmi.idReporte = t.idReporte
		inner join md_item i on i.idItem = rmi.idItem
		inner join md_modulo m on m.idModulo = i.idModulo
		where rmi.valor1 = 1
		union
		SELECT R.idPuntoDeVenta,R.idUsuario,'Reporte Vacio','','',1,R.FechaCreacion,t.idReporte,NULL
		FROM #tempReporte T
		INNER JOIN Reporte R ON T.idReporte = R.idReporte
		LEFT JOIN MD_ReporteModuloItem RMI ON R.idReporte = RMI.idReporte
		WHERE R.AuditoriaNoAutorizada = 0 AND ISNULL(RMI.idReporte,0) = 0
		order by t.idReporte, m.nombre desc, i.nombre
		
		END
END
Go