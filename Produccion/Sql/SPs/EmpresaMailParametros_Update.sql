SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaMailParametros_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaMailParametros_Update] AS' 
END
GO
ALTER procedure [dbo].[EmpresaMailParametros_Update]
(
	@IdEmpresaMailParametros int,
	@IdEmpresa int,
	@IdPuntoDeVenta int,
	@IdEmpresaMailTipoMail int,
	@Emails varchar(max) = null,
	@Activo bit = 0
)
as
begin
	update EmpresaMailParametros
	set IdEMpresa =	@IdEmpresa
		,IdPuntoDeVenta = @IdPuntoDeVenta
		,IdEmpresaMailTipoMail = @IdEmpresaMailTipoMail
		,Emails = @Emails
		,Activo = @Activo
	where IdEmpresaMailParametros = @IdEmpresaMailParametros

end
GO
