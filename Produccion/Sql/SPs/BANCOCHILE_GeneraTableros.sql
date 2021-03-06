SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BANCOCHILE_GeneraTableros]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[BANCOCHILE_GeneraTableros] AS' 
END
GO

ALTER procedure [dbo].[BANCOCHILE_GeneraTableros]
as
BEGIN

set nocount on;

declare @idTablero int
declare @idUsuario int

declare @newIdZona as int,
	    @newNombreZona as nvarchar(255),
	    @newPuntoDeVenta as int,
	    @newNombrePDV as varchar(255),
	    @newDireccionPDV as varchar(500)

		
DECLARE CHILE_USUARIOS CURSOR FOR 
select distinct idUsuario from [dbo].[TMP_BcoChile_Usuarios_Multiples_PDV]
--where idUsuario = 980
--set @idUsuario = 1230
OPEN CHILE_USUARIOS

FETCH NEXT FROM CHILE_USUARIOS     
into @idUsuario

declare @ListaPDV nvarchar(max)
declare @ListaZonas nvarchar(max)


WHILE @@FETCH_STATUS = 0
BEGIN

	insert into reportingTableroUsuario_BKP(idTablero,idUsuario,permiteEscritura,fechaBKP)
	select idTablero,idusuario,permiteEscritura,GETDATE()
	from reportingTableroUsuario
	where IdUsuario = @idUsuario
	
	delete reportingTableroUsuario where IdUsuario = @idUsuario
	
	--begin tran --SI VOY A LOGUEAR TODO ME CONVIENE ABRIR UNA TRANSACCION
	
	
	
	set @ListaPDV = ''
	set @ListaZonas = ''

	
	

	---Genero lista de puntos de venta
	DECLARE PUNTOS_DE_VENTA CURSOR FOR
	select distinct p.idPuntoDeVenta,pdv.nombre,pdv.direccion from TMP_BcoChile_Usuarios_Multiples_PDV p
	inner join puntodeventa pdv on pdv.idPuntoDeVenta = p.idPuntoDeVenta
	where p.idUsuario = @idUsuario
	
	OPEN PUNTOS_DE_VENTA	

	FETCH NEXT FROM PUNTOS_DE_VENTA     
	into @newPuntoDeVenta,@newNombrePDV,@newDireccionPDV
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--ARMO LA DATA EN JSON
		set @ListaPDV = @ListaPDV + 
		',{"IdItem":"'+ cast(@newPuntoDeventa as varchar) +'","Descripcion":"'
					 + cast(@newPuntoDeVenta as varchar) + ' - '+ 
					 + @newNombrePDV +' - ' 
					 + @newDireccionPDV + '","Selected":true,"TipoItem":null,"isLocked":false}'

		FETCH NEXT FROM PUNTOS_DE_VENTA     
		into @newPuntoDeVenta,@newNombrePDV,@newDireccionPDV
	END

	set @ListaPDV = stuff(@listaPDV,1,1,'')

	close PUNTOS_DE_VENTA;

	DEALLOCATE PUNTOS_DE_VENTA;


	DECLARE CUR_ZONAS CURSOR FOR
	select distinct idZona,NombreZona from TMP_BcoChile_Usuarios_Multiples_PDV
	where idUsuario = @idUsuario

	OPEN CUR_ZONAS	

	FETCH NEXT FROM CUR_ZONAS     
	into @newidZona,@newNombreZona
	

	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @ListaZonas = @ListaZonas + 
		',{"IdItem":"'+cast(@newIdZona as varchar) +'","Descripcion":"'
						+@newNombreZona+'","Selected":true,"TipoItem":null,"isLocked":false}'

		FETCH NEXT FROM CUR_ZONAS     
		into @newidZona,@newNombreZona
	END
	
	set @ListaZonas = stuff(@ListaZonas,1,1,'')
	CLOSE CUR_ZONAS;
	DEALLOCATE CUR_ZONAS;
	
	--select @listaZonas
	--select @listaPDV
	--select @idUsuario 
	--Inserto tablero en reportingTablero, con los filtros (USUARIO AGOS)
	
	insert reportingTablero(nombre,descripcion,idUsuario,idCliente,idModulo,new,datamigrationId,datamigrationid2,filtrosBloqueados)
	select rt.nombre,rt.descripcion,rt.idUsuario,rt.idCliente,rt.idModulo,rt.new,rt.datamigrationId,rt.datamigrationid2,
		'{"FiltrosChecks":
			[
			{"Id":"fltZonas","Nombre":"Zonas","Items":
				['
					+ @ListaZonas +
				']
			},
			{"Id":"fltSucursal","Nombre":null,"Items":
				['
					+ @ListaPDV +
				']
			}
			],
			"FiltrosFechas":[],"isLocked":false,"permitebloquearfiltros":false}'
	as filtrosBloqueados
	From reportingTablero rt where rt.idUsuario = 1625
	and rt.idCliente = 89
	and nombre = 'Performance General'
	and id = 1988
	set @idTablero = scope_identity()
	
	
	insert bancochile_tableros_usuarios_pdv(idUsuario,idPuntodeventa,idtablero,Nombretablero,fechaCreacion)
	select @idUsuario,p.idPuntodeventa,@idTablero,'Performance General',GETDATE() from TMP_BcoChile_Usuarios_Multiples_PDV p where p.idUsuario = @idUsuario

	--print 'Tablero creado: '+ isnull(cast(@idtablero as varchar),'')
	--Inserto objetos en tablero, reportingtableroObjeto
	
	insert reportingTableroObjeto(idtablero,idObjeto,size,orden)
	select @idTablero, idObjeto,size,orden From [dbo].[ReportingTableroObjeto] where idtablero = 1092 --TABLERO DE COPIA


	insert [dbo].[ReportingTableroUsuario] (idTablero,idUsuario,permiteEscritura)
	values(@idTablero,@idUsuario,0)
	
	--------------------------          2           -----------------------------------
	--Inserto tablero en reportingTablero, con los filtros (USUARIO AGOS)
	
	insert reportingTablero(nombre,descripcion,idUsuario,idCliente,idModulo,new,datamigrationId,datamigrationid2,filtrosBloqueados)
	select rt.nombre,rt.descripcion,rt.idUsuario,rt.idCliente,rt.idModulo,rt.new,rt.datamigrationId,rt.datamigrationid2,
		'{"FiltrosChecks":
			[
			{"Id":"fltZonas","Nombre":"Zonas","Items":
				['
					+ @ListaZonas +
				']
			},
			{"Id":"fltSucursal","Nombre":null,"Items":
				['
					+ @ListaPDV +
				']
			}
			],
			"FiltrosFechas":[],"isLocked":false,"permitebloquearfiltros":false}'
	as filtrosBloqueados
	From reportingTablero rt where rt.idUsuario = 1625
	and rt.idCliente = 89
	and nombre = 'Sucursal Detalle Mensual'
	and id = 1989
	set @idTablero = scope_identity()

	insert bancochile_tableros_usuarios_pdv(idUsuario,idPuntodeventa,idtablero,Nombretablero,fechaCreacion)
	select @idUsuario,p.idPuntodeventa,@idTablero,'Sucursal Detalle Mensual',GETDATE() from TMP_BcoChile_Usuarios_Multiples_PDV p where p.idUsuario = @idUsuario
	
	--Inserto objetos en tablero, reportingtableroObjeto
	insert reportingTableroObjeto(idtablero,idObjeto,size,orden)
	select @idtablero, idObjeto,size,orden From [dbo].[ReportingTableroObjeto] where idtablero = 1097

	insert [dbo].[ReportingTableroUsuario] (idTablero,idUsuario,permiteEscritura)
	values(@idTablero,@idUsuario,0)

	FETCH NEXT FROM CHILE_USUARIOS     
	into @idUsuario

	--commit tran

	--select 'FIN DE CICLO tablero:' + cast(@idTablero as varchar)
END	 


close CHILE_USUARIOS;
DEALLOCATE CHILE_USUARIOS;

END







GO
