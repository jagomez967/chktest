SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spMarcarMailCondolidadoEnviado]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spMarcarMailCondolidadoEnviado] AS' 
END
GO
ALTER procedure [dbo].[spMarcarMailCondolidadoEnviado]
(
	@IdAlerta int
)
as
begin
--exec spMarcarMailEnviado 5
	update EmpresaMail set enviado = 1, FechaEnvio = getdate() where IdAlerta=@IdAlerta
end
GO
