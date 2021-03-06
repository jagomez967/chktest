SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaMailTipoMail_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaMailTipoMail_GetAll] AS' 
END
GO
ALTER procedure [dbo].[EmpresaMailTipoMail_GetAll]
(
	@IdEmpresaMailTipoMail int = null
)
as
begin
	--EmpresaMailTipoMail_GetAll null
	Select IdEmpresaMailTipoMail, Nombre, Descripcion, Activo
	from EmpresaMailTipoMail
	where @IdEmpresaMailTipoMail is null or IdEmpresaMailTipoMail = @IdEmpresaMailTipoMail
end
GO
