alter PROCEDURE GetFiltrosCadenas  
(  
 @IdCliente int,
 @Top int = 0,
 @texto varchar(max)=''
)  
AS
BEGIN  
	CREATE TABLE #Clientes (idCliente INT)

	INSERT #clientes (idCliente)
	SELECT fc.idCliente
	FROM familiaClientes fc
	WHERE fc.familia IN (
			SELECT familia
			FROM familiaClientes
			WHERE idCliente = @idCLiente
				AND activo = 1
			)
	
	IF @@rowcount = 0
	BEGIN
		INSERT #clientes (idCliente)
		values( @IdCliente)
	END

	SET ROWCOUNT @Top
	
	if(@idcliente in (178,183,185,186)) --crtl+click => https://i1.wp.com/442.perfil.com/wp-content/uploads/2017/05/0511_tano_pasman_g_cedoc.jpg
	begin
		SELECT CA.[IdCadena] AS IdItem
		,CA.[Nombre] AS Descripcion
		FROM [dbo].[Cadena] CA
		inner join empresa e on e.idnegocio=ca.idnegocio
		inner join cliente c on c.idempresa=e.idempresa
		where c.idcliente=@idcliente
		AND  (isnull(@texto,'') = '' or CA.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
	end
	else
	begin
		SELECT max(CA.[IdCadena]) AS IdItem
		,CA.[Nombre] AS Descripcion
		FROM [dbo].[Cadena] CA
		INNER JOIN PuntoDeVenta PDV ON (PDV.IdCadena = CA.[IdCadena])
		WHERE pdv.IdCliente in (select idCliente from #clientes)
		AND  (isnull(@texto,'') = '' or CA.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
		GROUP BY CA.[Nombre]		
		ORDER BY CA.[Nombre]
	end


   SET ROWCOUNT 0

END
GO

