SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Estados_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Estados_GetAll] AS' 
END
GO
ALTER procedure [dbo].[Estados_GetAll] 	
(
	@IdUsuario			int
)
as
begin
	select distinct e.Id, e.Nombre
	from Estados e
	inner join EstadosClientes ec on e.Id=ec.IdEstado
	inner join Usuario_Cliente uc on uc.IdCliente = ec.IdCliente
	where uc.IdUsuario = @IdUsuario
end
GO
