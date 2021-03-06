SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[regenerarUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[regenerarUsuario] AS' 
END
GO
ALTER procedure [dbo].[regenerarUsuario]
(
	@IdUsuario	int
)
as
BEGIN
	declare @id int

	select @id = idAspUsuario from ReportingAspNetUsuario where idUsuario = @idUsuario

	set rowcount 1
	delete from CheckPOS_Security.dbo.aspnetusers where id = @id

	delete from ReportingAspNetUsuario where IdAspUsuario = @id
	set rowcount 0

	select 1  
END
GO
