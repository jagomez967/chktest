SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[imagenesTags_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[imagenesTags_Add] AS' 
END
GO
ALTER procedure [dbo].[imagenesTags_Add]
(
	@IdImagen int,
	@IdTag int,
	@IdUsuario int
)
as
begin	
	insert imagenesTags (idImagen, idTag, fecha, idUsuario) values (@IdImagen, @IdTag, getdate(), @IdUsuario)

	declare @idEmpresaMail int

	select @IdEmpresaMail = max(idEmpresaMail) 
	from empresamail 
	where	--idReporte = @idReporte 	
		mailsubject = 'Informe Consolidado: Reporte Completo'
	and mailbody like '%<div class="tags_' +ltrim(rtrim(str(isnull(@idImagen,0))))+ '"></div>%'

	if (@@rowcount > 0)
	BEGIN
		exec spAddTagMailReporteCompleto @idImagen,@idEmpresaMail,@idTag --TENGO QUE AGREGAR EL IDTAG
	end

end
GO

