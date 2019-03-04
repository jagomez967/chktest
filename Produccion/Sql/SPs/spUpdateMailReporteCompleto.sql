
alter procedure spUpdateMailReporteCompleto
(
	@IdReporte int,
	@IdEmpresaMail int
)
AS

BEGIN

	declare @cantFotos int
	declare @seccion varchar(max) = ''
	declare @cantidadAnterior varchar(max) = ''
	declare @cantidadNueva varchar(max) = ''
	declare @fechaOld datetime 

	select @cantFotos = count(*) from puntodeventafoto where idreporte = @IdReporte
	
	if (@cantFotos <=1)
	BEGIN	
		set @seccion = @seccion + '<h3>Fotos</h3><h6>Se cargaron ' + ltrim(rtrim(str(isnull(@cantFotos,0)))) + ' en el reporte</h6>'
	END
	ELSE
	BEGIN
		select @cantidadAnterior = substring(mailbody,
						charindex('<h3>Fotos</h3><h6>Se cargaron ',mailbody),
						charindex(' en el reporte</h6>',mailbody) - charindex('<h3>Fotos</h3><h6>Se cargaron ',mailbody)
						)
		from empresamail where idEmpresaMail = @idEmpresaMAil

		select @cantidadNueva =	'<h3>Fotos</h3><h6>Se cargaron ' + ltrim(rtrim(str(isnull(@cantFotos,0))))

		update empresamail
		set MailBody = replace(MailBody,@cantidadAnterior,@cantidadNueva)		
		where idEmpresaMail = @idEmpresaMail
	END

	declare @idPuntodeventafoto int
	declare @LeyendaTag varchar(max)

	SELECT @seccion = @seccion + '<a href="https://login.checkpos.com/1/Fotos_2/'+ ltrim(rtrim(str(f.idEmpresa))) +'/'+ ltrim(rtrim(str(max(f.IdPuntoDeVentaFoto)))) +'.jpg"><img src="https://login.checkpos.com/1/Fotos_2/'+ ltrim(rtrim(str(f.idEmpresa))) +'/'+ ltrim(rtrim(str(max(f.IdPuntoDeVentaFoto)))) +'.jpg" alt="Foto de Reporte" style="margin:10px;" width="150">'
			,@idPuntodeventaFoto = max(f.IdPuntoDeVentaFoto)
	from puntodeventafoto f
	inner join reporte r on r.idreporte=f.idreporte
	where r.idreporte = @idreporte
	group by f.idEmpresa

	select @seccion = @seccion + '<div>' + isnull(f.comentario,'') + '</div>' 
	from puntodeventafoto f
	where f.idPuntodeventafoto = @idPuntodeventafoto

	set @seccion = @seccion + '<div class="tags_' +ltrim(rtrim(str(isnull(@idPuntodeventaFoto,0))))+ '"></div>' 

	select @seccion = @seccion + '</a><div class="hiddenFoto"></div>'

	update empresamail
	set MailBody = replace(MailBody,'<div class="hiddenFoto"></div>',@seccion)	
	, fechaRealModificacion	= getdate()
	where idEmpresaMail = @idEmpresaMail

END