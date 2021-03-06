SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tags_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[tags_GetAllCliente] AS' 
END
GO
ALTER procedure [dbo].[tags_GetAllCliente]
(
	@IdTag int = null,
	@IdCliente int = null,
	@Tabla varchar(100) = null
)
as
begin
	
	select T.idTag as IdTag, T.idCliente as IdCliente, T.tabla as IdTabla, TC.Tabla AS Tabla, T.campos as IdCampo,
	TC.Campo AS Campo, T.valores as Valor, T.leyenda as Leyenda, T.activo as Activo, T.fecha as Fecha
	from tags T
	inner join dbo.TagConfig  TC ON (T.tabla = TC.Id)
	where	(@IdTag is null or idtag=@IdTag)
			--and (@Tabla is null or TC.tabla like '%'+@Tabla+'%')
			AND T.Leyenda LIKE '%' + ISNULL(@Tabla,T.Leyenda) + '%'
			and (@IdCliente is null or idcliente=@IdCliente)
		order by t.leyenda asc
end
GO



