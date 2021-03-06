SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailReporteCreado]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailReporteCreado] AS' 
END
GO

ALTER procedure [dbo].[spGenerarMailReporteCreado]
(
	@IdReporte int,
	@IdAlerta int
)
as
begin
	set nocount on

	--Declaraciones
	declare @DatosGenerales varchar(max)
	declare @IdMarca int
	declare @MarcaNombre varchar(100)
	declare @IdEmpresa int
	declare @IdCliente int
	declare @IdDina int --para mod dinamicos
	declare @FilaModDina varchar(max)--para mod dinamicos
	declare @IdModuloDina int--para mod dinamicos
	declare @idExhibicion int
	declare @FilaExhibicion varchar(max)
	declare @idPop int
	declare @FilaPop varchar(max)
	declare @idProductos int
	declare @FilaProductos varchar(max)
	declare @idProductosComp int
	declare @FilaProductosComp varchar(max)
	declare @idMantenimiento int
	declare @FilaMantenimiento varchar(max)
	declare @ReporteMarcaHtml varchar(max)
	declare @IdReporteFila varchar(max)
	declare @FilaReporte varchar(max)
	declare @MailFrom varchar(100)
	declare @MailSubject varchar(200)
	declare @MailBody varchar(max)
	declare @MailHeader varchar(max)
	declare @MailFooter varchar(max)
	declare @idPuntoDeVenta int
	declare @FilaModuloDinamico varchar(max)
	declare @flgExhibiciones bit=0
	declare @flgPop bit=0
	declare @flgProducto bit=0
	declare @flgProductoComp bit=0
	declare @flgMantenimiento bit=0
	declare @flgModDina bit=0
	declare @ProductosColumnas varchar(max)
	declare @ProductosCompColumnas varchar(max)
	declare @idModDinaFila int
	declare @FilaModuloDinamicoCab varchar(max)
	declare @FilaModuloDinamicoDet varchar(max)
	declare @PdvNombre varchar(max)
	declare	@CadenaNombre varchar(max)
	declare	@PdvId varchar(max)
	declare	@PdvDireccion varchar(max)
	declare	@LocalidadNombre varchar(max)
	declare	@RTM varchar(max)
	declare @tienedatos int
	declare @cantFotos int
	declare @seccionmodulo varchar(max)
	declare @modulotienedatos int
	declare @muestroseccion bit
	declare @PdvCodigoAdicional varchar(max)
	declare @Descripcion varchar(200) = ''
	
	set @MailFrom = 'noreply@checkpos.com'

	set @MailHeader = '<!DOCTYPE html>'
	set @MailHeader = @MailHeader + '<html><head><title>Informe de Reporte</title><meta charset="utf-8">'
	set @MailHeader = @MailHeader + '<style type="text/css">'
	set @MailHeader = @MailHeader + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	set @MailHeader = @MailHeader + 'body{height: 100%;width: 100%;padding:20px;}'
	set @MailHeader = @MailHeader + 'h1{color: #ffffff;padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.container{width: 100%;height: 100%;}'
	set @MailHeader = @MailHeader + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'
	if @idCliente = 98
		set @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 10px 50px 30px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	else
		set @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'	
	set @MailHeader = @MailHeader + 'h3{padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'h4{padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'h2{color:#FDA515;padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'p{padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}'
	set @MailHeader = @MailHeader + 'table{border-collapse: collapse;width: 100%;background:#ffffff;margin:0;padding:0;}'
	set @MailHeader = @MailHeader + 'th, td{text-align: left;padding: 8px;}'
	set @MailHeader = @MailHeader + 'tr:nth-child(even){background-color: #f2f2f2}'
	set @MailHeader = @MailHeader + '</style>'
	set @MailHeader = @MailHeader + '</head>'
	set @MailHeader = @MailHeader +  '<body><div class="container">'

	set @MailBody = ''
	set @MailBody = @MailBody + '<div class="header">'
	set @MailBody = @MailBody + '<h1>Informe de Reporte</h1>'
	set @MailBody = @MailBody + '<h2>#'+cast(@idReporte as varchar)+'</h2>'
	set @MailBody = @MailBody + '</div>'

	set @MailBody = @MailBody + '</div>'

	set @MailSubject = 'Informe Consolidado: Creacion de Reporte' --'Informe de Reporte #' + ltrim(rtrim(str(@idreporte))) + '  [PDV: ' + LTRIM(rtrim(str(isnull(@PdvId,0)))) + ' - ' + LTRIM(rtrim(isnull(@PdvNombre,''))) + ']'
	
	select @Descripcion = descripcion from alertas where id = @IdAlerta
	and len(descripcion) < 150

	if (isnull(@Descripcion,'') != '')
	BEGIN
		set @MailSubject = @Descripcion + ' - ' + @MailSubject
	END

	set @MailBody = @MailBody + '<div class="data">'

	set @MailBody = @MailBody + '<h3>'+'Los resultados se encuentran disponibles en '

	set @MailBody = @MailBody + '<a href="https://login.checkpos.com/1/reporting"> Reporting</a>'
	
	set @MailBody = @MailBody + '</h3>'
	
	set	@MailFooter = '</div></body></html>'

	if isnull(@MailFrom,'')<>'' and isnull(@MailBody,'')<>''
	begin
		insert EmpresaMail (IdReporte
								,IdAlerta
								,MailFrom
								,MailBody
								,MailSubject
								,MailHeader
								,MailFooter
								,MailAdjuntos
								,Autorizado
								,UsuarioAutorizacion
								,Enviado
								,FechaCreacion
								,FechaAutorizacion
								,FechaEnvio)
		values(@idReporte
				,@IdAlerta
				,'noreply@checkpos.com'
				,@MailBody
				,@MailSubject
				,@MailHeader
				,@MailFooter
				,null
				,1
				,null
				,0
				,getdate()
				,getdate()
				,null
				)
	end
end


GO
