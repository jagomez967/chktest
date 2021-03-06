SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_Reporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_Reporte] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_Reporte]
	
	@IdPuntoDeVenta int = NULL 
   ,@FechaDesde DateTime = NULL
   ,@FechaHasta DateTime = NULL
   ,@IdEmpresa int = NULL
   ,@IdLocalidad int = NULL
   ,@IdZona int = NULL   
   ,@IdCadena int = NULL
   ,@IdUsuario int = NULL
   ,@observaciones varchar(max)=null
   
   
   
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @IdPuntoDeVentaFoto int
DECLARE @FechaCreacion Datetime
DECLARE @Estado bit

IF (NOT @FechaHasta IS NULL) SET @FechaHasta  = DATEADD(SECOND,-1, DATEADD(day, 1, @FechaHasta))
  
  
IF (@FechaDesde IS NULL) SET @FechaDesde = CONVERT(DATETIME,'2013-01-01',120)  
IF (@FechaHasta IS NULL) SET @FechaHasta = GETDATE()
  
DECLARE cur_foto CURSOR FOR 

 SELECT PDVF.[IdPuntoDeVentaFoto]
       ,PDVF.[FechaCreacion]
       ,dbo.PuntoDeVentaFoto_Estado(PDVF.[IdPuntoDeVentaFoto],PDVF.[Partes]) AS Estado
  FROM [dbo].[PuntoDeVentaFoto] PDVF
  INNER JOIN [dbo].[PuntoDeVenta] PDV ON (PDV.IdPuntoDeVenta = PDVF.IdPuntoDeVenta)  
  WHERE  [Estado]=0 AND
        (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDVF.[IdPuntoDeVenta]) AND
        ([FechaCreacion] BETWEEN @FechaDesde AND @FechaHasta) AND
        (@IdEmpresa IS NULL OR @IdEmpresa = [IdEmpresa]) AND
        (@IdLocalidad IS NULL OR @IdLocalidad = PDV.IdLocalidad) AND
        (@IdZona IS NULL OR @IdZona = PDV.IdZona) AND
        (@IdCadena IS NULL OR @IdCadena = PDV.IdCadena) AND        
        (@IdUsuario IS NULL OR @IdUsuario = PDVF.IdUsuario) and
		(@observaciones is null or pdvf.comentario like '%'+@observaciones+'%')
        

OPEN cur_foto;

FETCH NEXT FROM cur_foto 
INTO @IdPuntoDeVentaFoto, @FechaCreacion, @Estado;

WHILE @@FETCH_STATUS = 0
BEGIN

	IF @Estado=1
	BEGIN
		UPDATE [dbo].[PuntoDeVentaFoto]
		SET  [Estado] = 1      
		WHERE IdPuntoDeVentaFoto = @IdPuntoDeVentaFoto 
		
		DELETE FROM [dbo].[PuntoDeVentaFotoParte]
		WHERE IdPuntoDeVentaFoto = @IdPuntoDeVentaFoto 
		
	END

	FETCH NEXT FROM cur_foto 
	INTO @IdPuntoDeVentaFoto, @FechaCreacion, @Estado;	
END

CLOSE cur_foto;
DEALLOCATE cur_foto;

SELECT X.*
      ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As Usuario
      ,[dbo].[PuntoDeVenta_Descripcion] (X.IdPuntoDeVenta) AS PDV
	  --,null as Foto
FROM 
(SELECT PDVF.*, ROW_NUMBER() OVER(ORDER BY [FechaCreacion] ASC) AS ROWNUMBER
FROM [dbo].[PuntoDeVentaFoto] PDVF
INNER JOIN [dbo].[PuntoDeVenta] PDV ON (PDV.IdPuntoDeVenta = PDVF.IdPuntoDeVenta)  
WHERE  [Estado]=1 AND
       (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDVF.[IdPuntoDeVenta]) AND
       ([FechaCreacion] BETWEEN @FechaDesde AND @FechaHasta) AND
       (@IdEmpresa IS NULL OR @IdEmpresa = [IdEmpresa]) AND
       (@IdLocalidad IS NULL OR @IdLocalidad = PDV.IdLocalidad) AND
       (@IdZona IS NULL OR @IdZona = PDV.IdZona) AND
       (@IdCadena IS NULL OR @IdCadena = PDV.IdCadena) AND        
       (@IdUsuario IS NULL OR @IdUsuario = PDVF.IdUsuario) AND
	   (@observaciones is null or pdvf.comentario like '%'+@observaciones+'%')) X
INNER JOIN Usuario U ON (U.IdUsuario = X.IdUsuario)
WHERE NOT (X.ROWNUMBER%2)=0


SELECT X.*
      ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As Usuario
	  ,[dbo].[PuntoDeVenta_Descripcion] (X.IdPuntoDeVenta) AS PDV
	  --,null as Foto
FROM
(SELECT PDVF.*, ROW_NUMBER() OVER(ORDER BY [FechaCreacion] ASC) AS ROWNUMBER
FROM [dbo].[PuntoDeVentaFoto] PDVF
INNER JOIN [dbo].[PuntoDeVenta] PDV ON (PDV.IdPuntoDeVenta = PDVF.IdPuntoDeVenta)  
WHERE  [Estado]=1 AND
       (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDVF.[IdPuntoDeVenta]) AND
       ([FechaCreacion] BETWEEN @FechaDesde AND @FechaHasta) AND
       (@IdEmpresa IS NULL OR @IdEmpresa = [IdEmpresa]) AND
       (@IdLocalidad IS NULL OR @IdLocalidad = PDV.IdLocalidad) AND
       (@IdZona IS NULL OR @IdZona = PDV.IdZona) AND
       (@IdCadena IS NULL OR @IdCadena = PDV.IdCadena) AND        
       (@IdUsuario IS NULL OR @IdUsuario = PDVF.IdUsuario) AND
	   (@observaciones is null or pdvf.comentario like '%'+@observaciones+'%')) X
INNER JOIN Usuario U ON (U.IdUsuario = X.IdUsuario)
WHERE (X.ROWNUMBER%2)=0

select Imagen as Logo from cliente where idEmpresa = @IdEmpresa
END





GO
