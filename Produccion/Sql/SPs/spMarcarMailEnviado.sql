SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spMarcarMailEnviado]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spMarcarMailEnviado] AS' 
END
GO
ALTER procedure [dbo].[spMarcarMailEnviado]
(
	@Id int
)
as
begin
--exec spMarcarMailEnviado 5
	update EmpresaMail set enviado = 1, FechaEnvio = getdate() where IdEmpresaMail = @Id
end
GO
