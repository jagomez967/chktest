SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCamposAlerta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetCamposAlerta] AS' 
END
GO
ALTER procedure [dbo].[GetCamposAlerta] 	
(
	@IdCliente int
)
as
begin

select	m.IdMarca			as IdMarca
		,mc.IdModulo		as IdSeccion
		,i.IdModuloItem		as IdCampo
		,m.Nombre			as MarcaDescr
		,mc.Descripcion		as SeccionDescr
		,i.Leyenda			as CampoDescr
from Marca m
inner join cliente c on c.IdEmpresa=m.IdEmpresa
inner join M_ModuloCliente mc on mc.IdCliente = c.idcliente
inner join M_ModuloItem i on i.IdModulo=mc.IdModulo
inner join M_Modulo mm on mm.IdModulo=mc.IdModulo
where	c.IdCliente=@IdCliente 
		and m.Reporte=1
		and mc.Activo=1
		and i.Activo=1
		and isnull(i.Leyenda,'')<>''
		and mm.Activo=1
		and i.IdTipoItem<>1
end

GO
