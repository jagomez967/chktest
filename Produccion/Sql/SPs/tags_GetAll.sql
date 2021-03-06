SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tags_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[tags_GetAll] AS' 
END
GO
ALTER procedure [dbo].[tags_GetAll]
(
	@IdTag int = null,
	@Leyenda varchar(100) = null,
	@IdCliente int = null
)
as
begin

	select t.idTag as IdTag,t.idCliente,t.tabla as idTabla,tc.tabla as Tabla,t.campos as idCampo,tc.campo as Campo,valores as Valor, leyenda as Leyenda
	,activo,fecha
	from tags t
	inner join tagConfig tc 
	on t.tabla = tc.id
	where	(@IdTag is null or idtag=@IdTag)
			and (@Leyenda is null or leyenda like '%'+@Leyenda+'%')
			and (@IdCliente is null or idcliente=@IdCliente)
			and activo=1
	order by leyenda asc
end

GO