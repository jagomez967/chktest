SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Empresamail_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Empresamail_Add] AS' 
END
GO
ALTER procedure [dbo].[Empresamail_Add]
(
	@IdReporte int 
    ,@MailFrom varchar(100) = null
    ,@MailTo varchar(max)  = null
    ,@MailBody varchar(max)  = null
    ,@MailSubject varchar(200)  = null
    ,@MailAdjuntos varchar(max)  = null
    ,@Autorizado bit = 0
    ,@UsuarioAutorizacion int = null
    ,@Enviado bit  = 0
    ,@FechaCreacion datetime = null
    ,@FechaAutorizacion datetime = null
    ,@FechaEnvio datetime = null
	,@IdAlerta int
)
as
begin

select @fechaAutorizacion = dateadd(minute,1,@fechaCreacion)

if(exists(select 1 from Alertas where id = @IdAlerta and ISNULL(activo,0)=1 and ISNULL(eliminado, 0)=0))
begin
	INSERT INTO [dbo].[EmpresaMail]
			   ([IdReporte]
			   ,[MailFrom]
			   ,[MailBody]
			   ,[MailSubject]
			   ,[MailAdjuntos]
			   ,[FechaCreacion]
			   ,[IdAlerta]
			   ,[FechaAutorizacion])
		 VALUES
			   (@IdReporte
			   ,@MailFrom
			   ,@MailBody
			   ,@MailSubject
			   ,@MailAdjuntos
			   ,getdate()
			   ,@IdAlerta
			   ,@fechaAutorizacion)
	end
end
GO
