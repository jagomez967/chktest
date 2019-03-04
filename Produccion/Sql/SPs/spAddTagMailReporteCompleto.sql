ALTER procedure spAddTagMailReporteCompleto
(
	@IdImagen int,
	@IdEmpresaMail int,
	@IdTag int
)
AS

BEGIN
	declare @newTag varchar(max) = ''
	declare @leyendaTag varchar(max) = ''
	declare @oldTag varchar(max) =''

	select @leyendaTag = leyenda 
	from tags where idTag = @IdTag

	select @OldTag = '<div class="tags_' +ltrim(rtrim(str(isnull(@idImagen,0))))+ '"></div>'
	
	--Estructura:
	/*
	reemplazo <div class="tags_xxxxx></div> donde xxxxx es el idFoto Por:

	<h5>   ESTE NECESITA UN ID PARA NO CONFUNDIRLO CON OTRO (ejemplo Titulo_xxx, donde xxx es el idImagen)
		<u>TAGS: </u>
		<ul>
			<li style="display:inline;border-style:double;"> Cocina </li>
			... Nuevos items
			<div class="tags_xxxxx></div>	
			(    Lo cambio por: 
				 <li style="display:inline;border-style:double;"> @newTag </li>   )
		</ul>
	</h5>

	Trabaja de la siguiente manera.
	Si no existe el titulo lo inserto con toda la estructura
	Si ya existe el titulo, solo reemplazo el div por un nuevo item en la lista, 
	dejando la posibilidad de agregar mas items de esta manera
	*/
	

	if not exists (select 1 
					from empresamail 
					where idEmpresamail = @idEmpresaMail 
						and mailbody like '%titulotag_'+ltrim(rtrim(str(isnull(@idImagen,0))))+'%')
		BEGIN
			--Titulo
			select @newTag = @newTag + '<h5 id="titulotag_'+ltrim(rtrim(str(isnull(@idImagen,0))))+'">'
			select @newTag = @newTag + '<u> TAGS: </u>'

			--Lista
			select @newTag = @newTag + '<ul>'

			--ItemLista
			select @newTag = @newTag + '<li style="display:inline;border-style:double;">'+@leyendaTag+'</li>'

			--Proximo Tag
			select @newTag = @newTag + @oldTag

			--Fin Lista
			select @newTag = @newTag + '</ul>'

			--Fin texto
			select @newTag = @newTag + '</h5>'

		END
	ELSE
		BEGIN
			--ItemLista
			select @newTag = @newTag + '<li style="display:inline;border-style:double;">'+@leyendaTag+'</li>'

			--Proximo Tag
			select @newTag = @newTag + @oldTag
		END
	if(@newTag != '')				
		update empresamail
		set MailBody = replace(MailBody,@oldTag,@newTag)		
		where idEmpresaMail = @idEmpresaMail	
		
END

