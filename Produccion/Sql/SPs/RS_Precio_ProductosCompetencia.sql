SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_Precio_ProductosCompetencia]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_Precio_ProductosCompetencia] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_Precio_ProductosCompetencia] 	
	 @IdEmpresa int
	,@Dia varchar(max)=NULL
	,@Mes varchar(max)=NULL--(yyyymm)
	,@Ano varchar(max)=NULL
	,@Semana varchar(max)=NULL--(yyyyss)
	,@IdMarca varchar(max)=NULL
	,@IdProducto varchar(max)=NULL
	,@IdCadena varchar(max)=NULL
	,@IdPuntoDeVenta varchar(max)=NULL
	,@IdLocalidad varchar(max)=NULL
	,@IdZona varchar(max)=NULL
	,@IdUsuario varchar(max)=NULL
	

AS
BEGIN

	SET NOCOUNT ON;
	--DECLARE @IdCliente int
	--SELECT  @IdCliente = [IdCliente] FROM [Cliente] WHERE [IdEmpresa] = @IdEmpresa

	SELECT P.IdProducto
	      ,P.Nombre as NombreProducto
	      ,AVG(RPC.Precio) as Promedio
	      ,MAX(RPC.Precio) as Maximo
		  ,MIN(RPC.Precio) as Minimo
		  ,NULL as Moda
	FROM dbo.Reporte R
    INNER JOIN dbo.ReporteProductoCompetencia RPC ON RPC.IdReporte = R.IdReporte -- and (RPC.IdMarca IS NULL OR RPC.IdMarca = @IdMarca)
    INNER JOIN dbo.Producto P ON P.IdProducto = RPC.IdProducto
    INNER JOIN dbo.ProductoCompetencia PC ON P.IdProducto = PC.IdProductoCompetencia 
    INNER JOIN dbo.Producto P2 ON P2.IdProducto = PC.IdProducto
    INNER JOIN dbo.Marca M ON M.IdMarca = P2.IdMarca
    --INNER JOIN dbo.Empresa E ON E.IdEmpresa = M.IdEmpresa
    INNER JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
    WHERE  M.IdEmpresa = @IdEmpresa
    	and (@Ano IS NULL OR YEAR(R.FechaCreacion) IN (SELECT clave FROM dbo.fnSplitString(@Ano,','))) 
		and (@Mes IS NULL OR Convert(nchar(6),R.FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))
		--and (DAY(R.FechaCreacion) = @Dia OR @Dia is NULL)
		and (@Semana IS NULL OR Convert(char(6),(YEAR(R.FechaCreacion)*100) + DATEPART(WK,R.FechaCreacion)) IN (SELECT clave FROM dbo.fnSplitString(@Semana,',')))
		and (@IdMarca is NULL OR P2.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
		and (@IdProducto is NULL OR P2.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
		and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
		and (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
		and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
		and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
		and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
		and (RPC.Precio<>0)
    GROUP BY P.IdProducto
            ,P.Nombre

END
GO
