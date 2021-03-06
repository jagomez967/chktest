SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosLocalidades]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosLocalidades] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosLocalidades]
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
	SELECT	max(LO.[IdLocalidad])	as IdItem    
			,LO.[Nombre]		as Descripcion
	FROM [dbo].[Localidad] LO  
	INNER JOIN PuntoDeVenta PDV ON (PDV.[IdLocalidad] = LO.[IdLocalidad])
	where exists(select 1 from #clientes where idCliente = pdv.idCliente)
	AND  (isnull(@texto,'') = '' or LO.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY LO.[Nombre]
	ORDER BY LO.[Nombre]

	set rowcount 0

end

GO
