SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_ShareVariacion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_ShareVariacion] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_ShareVariacion] 	
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



SELECT	PDV.IdPuntoDeVenta,
		ltrim(rtrim(PDV.Nombre)) as PuntoDeVenta,
		z.nombre as Zona,
		l.Nombre as Localidad,
		SUM(Case When Substring(Convert(varchar,R.FechaCreacion,112),1,6) = Left(@Mes,6)
				 Then ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)
				 Else 0 
				 End) as Mes1,
		SUM(Case When Substring(Convert(varchar,R.FechaCreacion,112),1,6) = Right(@Mes,6)
				 Then ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)
				 Else 0 
				 End) as Mes2	
		,SUBSTRING(@Mes,5,2) +'/'+ Left(@Mes,4) as MesNombre1
		,Right(@Mes,2) +'/'+ SUBSTRING(@Mes,8,4) as MesNombre2			 
FROM Reporte R
INNER JOIN (SELECT IdEmpresa,IdPuntoDeVenta, MAX(FechaCreacion) as FechaCreacion
			FROM Reporte
			WHERE IdEmpresa = @IdEmpresa
			and (@Mes IS NULL OR Convert(nchar(6),FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))
			and (@IdPuntoDeVenta is NULL OR IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
			GROUP BY IdEmpresa, IdPuntoDeVenta) R1 on R1.IdEmpresa = R.IdEmpresa and R1.IdPuntoDeVenta  = R.IdPuntoDeVenta and R1.FechaCreacion = R.FechaCreacion
INNER JOIN ReporteProducto RP on R.IdReporte = RP.IdReporte
INNER JOIN Empresa E on R.IdEmpresa = E.IdEmpresa
INNER JOIN Producto P on RP.IdProducto = P.IdProducto
INNER JOIN PuntoDeVenta PDV on R.IdPuntoDeVenta = PDV.IdPuntoDeVenta
INNER JOIN Zona z on PDV.IdZona = z.IdZona
INNER JOIN Localidad l on PDV.IdLocalidad = l.IdLocalidad
WHERE (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
GROUP BY PDV.IdPuntoDeVenta,
		PDV.Nombre,
		z.nombre,
		l.Nombre


END
GO
