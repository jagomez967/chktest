SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaMailParametros_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaMailParametros_Delete] AS' 
END
GO
ALTER procedure [dbo].[EmpresaMailParametros_Delete]
(
	@IdEmpresaMailParametros int
)
as
begin
	delete EmpresaMailParametros where IdEmpresaMailParametros = @IdEmpresaMailParametros
end
GO
