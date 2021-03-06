SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetEmails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetEmails] AS' 
END
GO
ALTER procedure [dbo].[spGetEmails]
as
begin

	Select e.IdEmpresaMail, 'no-reply@checkpos.com' as MailFrom, e.MailBody, e.MailSubject, e.MailAdjuntos, e.MailHeader, e.MailFooter, a.Destinatarios as MailTo, a.Consolidado, a.Hora, a.Id as IdAlerta, e.IdReporte, e.FechaCreacion,isnull(e.ArchivoAdjunto,'') as Attachments
	from EmpresaMail e
	inner join alertas a on a.id=e.idalerta
	where	isnull(e.enviado,0)=0
			and isnull(e.autorizado,0)=1
			and isnull(Consolidado,0)=0
			and ISNULL(a.activo,0)=1
			and ISNULL(a.Eliminado,0)=0
			and dateadd(minute,4,e.FechaCreacion) < getdate() --NECESITO EL TIEMPO PARA QUE SE CARGEN LAS FOTOS Y LOS TAGS
	order by e.IdEmpresaMail


	Select e.IdEmpresaMail, 'no-reply@checkpos.com' as MailFrom, e.MailBody, e.MailSubject, e.MailAdjuntos, e.MailHeader, e.MailFooter, a.Destinatarios as MailTo, a.Consolidado, a.Hora, a.Id as IdAlerta, e.IdReporte, e.FechaCreacion,isnull(e.ArchivoAdjunto,'') as Attachments
	from EmpresaMail e
	inner join alertas a on a.id=e.idalerta
	where	isnull(e.enviado,0)=0
			and isnull(e.autorizado,0)=1
			and isnull(a.Consolidado,0)=1
			and isnull(a.Hora,'')<>''
			and ISNULL(a.activo,0)=1
			and ISNULL(a.Eliminado,0)=0
			--and e.fechaAutorizacion < getdate()
	order by a.Id, e.idReporte desc, e.IdEmpresaMail
end


GO
