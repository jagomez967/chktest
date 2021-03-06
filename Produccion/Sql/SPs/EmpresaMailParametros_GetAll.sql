SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaMailParametros_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaMailParametros_GetAll] AS' 
END
GO
ALTER procedure [dbo].[EmpresaMailParametros_GetAll]
(
	@IdEmpresa int=null,
	@IdEmpresaMailParametros int = null,
	@PuntoDeVenta varchar(200) = null
)
as
begin
	--exec EmpresaMailParametros_GetAll null, null
	Select	EMP.IdEmpresaMailParametros as Id
			,EMP.IdEmpresa as IdEmpresa
			,EMP.IdPuntoDeVenta as IdPuntoDeVenta
			,EMP.IdEmpresaMailTipoMail as IdEmpresaMailTipoMail
			,case when isnull((len(EMP.Emails)-len(replace(EMP.Emails,'@',''))),0)=1 then EMP.Emails else ltrim(rtrim(str(isnull(len(EMP.Emails)-len(replace(EMP.Emails,'@','')),0)))) + ' mails...' end as Emails
			,EMP.Emails as EmailsAll
			,EMP.Activo as Activo
			,E.Nombre as Empresa
			,PDV.Nombre as PuntoDeVenta
			,EMTM.Descripcion as TipoMail
	from EmpresaMailParametros EMP
	inner join Empresa E on E.IdEmpresa = EMP.IdEmpresa
	inner join PuntoDeVenta PDV on PDV.IdPuntoDeVenta = EMP.IdPuntoDeVenta
	inner join EmpresaMailTipoMail EMTM on EMTM.IdEmpresaMailTipoMail = EMP.IdEmpresaMailTipoMail
	where (@IdEmpresaMailParametros is null or IdEmpresaMailParametros = @IdEmpresaMailParametros)
	and (@PuntoDeVenta is null or PDV.Nombre like '%'+@PuntoDeVenta+'%')
	and (@idempresa is null or E.idEmpresa = @idEmpresa)
	order by PDV.Nombre

end
GO
