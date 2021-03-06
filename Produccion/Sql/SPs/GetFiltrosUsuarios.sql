SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosUsuarios]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosUsuarios] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltrosUsuarios]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
begin

	create table #Clientes
	(
		idCliente int
	)
	
	insert #clientes(idCliente) 
	select fc.idCliente from familiaClientes fc
	where fc.familia in (select familia from familiaClientes where idCliente = @idCLiente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END

	set rowcount @Top

    SELECT U.[IdUsuario]	as IdItem	  
		   ,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT as Descripcion
	  FROM [dbo].[Usuario_Cliente] UC
	  INNER JOIN Cliente C ON (C.[IdCliente] = UC.[IdCliente])
	  INNER JOIN Usuario U ON (U.[IdUsuario] = UC.[IdUsuario])
	  inner join UsuarioGrupo ug on ug.IdUsuario=u.IdUsuario
	  where exists(select 1 from #clientes where idCliente = uc.idCliente) and ug.IdGrupo=2 and isnull(u.esCheckpos,0) = 0
	  AND  (isnull(@texto,'') = '' or U.Apellido like @texto +'%' COLLATE DATABASE_DEFAULT or U.Nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
	  GROUP BY U.[IdUsuario],U.Nombre,U.Apellido
	  ORDER BY U.Apellido

	set rowcount 0
end
GO
