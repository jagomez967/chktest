SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_FacingCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_FacingCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_FacingCliente] 	
	 @IdEmpresa int
	,@Dia varchar(max)=NULL
	,@Mes varchar(max)=NULL
	,@Ano varchar(max)=NULL
	,@Semana varchar(max)=NULL
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



SELECT	P.Nombre as Producto,
		COUNT(distinct R.IdPuntoDeVenta) as CantidadPDV
FROM Reporte R
INNER JOIN (SELECT IdEmpresa,IdPuntoDeVenta, MAX(FechaCreacion) as FechaCreacion
			FROM Reporte
			WHERE IdEmpresa = @IdEmpresa
			and (@Ano IS NULL OR YEAR(FechaCreacion) IN (SELECT clave FROM dbo.fnSplitString(@Ano,','))) 
			and (@Mes IS NULL OR Convert(nchar(6),FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))
			--and (DAY(R.FechaCreacion) = @Dia OR @Dia is NULL)
			and (@Semana IS NULL OR Convert(char(6),(YEAR(FechaCreacion)*100) + DATEPART(WK,FechaCreacion)) IN (SELECT clave FROM dbo.fnSplitString(@Semana,',')))
			and (@IdPuntoDeVenta is NULL OR IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
			GROUP BY IdEmpresa, IdPuntoDeVenta) R1 on R1.IdEmpresa = R.IdEmpresa and R1.IdPuntoDeVenta  = R.IdPuntoDeVenta and R1.FechaCreacion = R.FechaCreacion
INNER JOIN ReporteProducto RP on R.IdReporte = RP.IdReporte
INNER JOIN Empresa E on R.IdEmpresa = E.IdEmpresa
INNER JOIN Producto P on RP.IdProducto = P.IdProducto
INNER JOIN PuntoDeVenta PDV on R.IdPuntoDeVenta = PDV.IdPuntoDeVenta
WHERE (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
and (ISNULL(Cantidad,0) + ISNULL(Cantidad2,0) > 0)
GROUP BY P.Nombre


END
GO
