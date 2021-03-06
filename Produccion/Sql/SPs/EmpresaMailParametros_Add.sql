SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaMailParametros_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaMailParametros_Add] AS' 
END
GO
ALTER procedure [dbo].[EmpresaMailParametros_Add]
(
	@IdEmpresa int,
	@IdPuntoDeVenta int,
	@IdEmpresaMailTipoMail int,
	@Emails varchar(max) = null,
	@Activo bit = 0
)
as
begin

	insert EmpresaMailParametros (IdEmpresa, IdPuntoDeVenta, IdEmpresaMailTipoMail, Emails, Activo, FechaCreacion)
	values (@IdEmpresa, @IdPuntoDeVenta, @IdEmpresaMailTipoMail, @Emails, @Activo, getdate())

end
GO
