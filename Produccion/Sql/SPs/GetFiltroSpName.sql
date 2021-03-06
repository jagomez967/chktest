SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltroSpName]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltroSpName] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltroSpName]
(
	@IdCLiente int,
	@identificador varchar(max),
	@texto varchar(max) = ''
)
as
BEGIN

	declare @spName varchar(max)
	declare @sqlText varchar(max)

	select @spName = storedProcedure
	From reportingFiltros
	where identificador = @identificador

	select @sqlText = @spName+' @IdCliente='+ cast(@idCliente as varchar)+', @Top=10, @texto='''+ @texto+''''
	
	exec(@sqlText)

END

GO
