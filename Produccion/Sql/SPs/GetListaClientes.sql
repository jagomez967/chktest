SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetListaClientes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetListaClientes] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetListaClientes] 
( 
	@idCliente int
)
AS
BEGIN
	
	IF NOT EXISTS(SELECT 1 FROM FamiliaClientes where idCliente = @idCliente and activo = 1)
	BEGIN
		select @idCliente
	END
	ELSE
	BEGIN
		select fh.idCliente From FamiliaClientes f
		inner join FamiliaClientes fh
		on fh.familia = f.familia
		where f.activo = 1 
		and f.idCliente = @idCliente 
		--and fh.idCLiente <> 194 --PERDONNNN
	END
END

GO
