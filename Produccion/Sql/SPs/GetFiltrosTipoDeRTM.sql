SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosTipoDeRTM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosTipoDeRTM] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltrosTipoDeRTM]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
begin

	set rowcount @Top
	select	p.idPerfil as IdItem
			,p.Descripcion as Descripcion
	from Perfil p
	where p.IdPerfil in (33,34)
	AND  (isnull(@texto,'') = '' or p.Descripcion like @texto +'%' COLLATE DATABASE_DEFAULT)
	set rowcount 0
end

GO
