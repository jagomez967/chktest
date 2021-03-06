SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cobertura]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cobertura] AS' 
END
GO
ALTER PROCEDURE [dbo].[Cobertura]
@FECHADESDE DATETIME=NULL,
@FECHAHASTA DATETIME=NULL
AS
BEGIN
 
IF @FECHADESDE IS NULL SET @FECHADESDE = GETDATE()-365
IF @FECHAHASTA IS NULL SET @FECHAHASTA = GETDATE()+1

  SELECT
  'PDV Activos' AS PDV,
ISNULL(SUM(CASE WHEN T.NOMBRE='Moderna'
           THEN 1 END),0) AS MODERNA,
ISNULL(SUM(CASE WHEN T.NOMBRE='Tradicional'
           THEN 1 END),0) AS TRADICIONAL, 
ISNULL(SUM(CASE WHEN T.NOMBRE='Perfumeria'
           THEN 1 END),0) AS PERFUMERIA
FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO 
UNION
SELECT
'PDV Visitados',
ISNULL(SUM(CASE WHEN T.NOMBRE='Moderna'
           THEN 1 END),0) AS MODERNA,
ISNULL(SUM(CASE WHEN T.NOMBRE='Tradicional'
           THEN 1 END),0) AS TRADICIONAL,
ISNULL(SUM(CASE WHEN T.NOMBRE='Perfumeria'
           THEN 1 END),0) AS PERFUMERIA
FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO
WHERE EXISTS
(
SELECT IDREPORTE FROM REPORTE R
WHERE R.IDPUNTODEVENTA = P.IDPUNTODEVENTA
AND R.FECHACREACION BETWEEN @FECHADESDE AND @FECHAHASTA
)
/*
UNION
SELECT
'Porcentaje' AS PDV,
ROUND((SELECT COUNT(*) FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO AND T.NOMBRE='Moderna'
WHERE EXISTS
(
SELECT IDREPORTE FROM REPORTE R
WHERE R.IDPUNTODEVENTA = P.IDPUNTODEVENTA
AND R.FECHACREACION BETWEEN @FECHADESDE AND @FECHAHASTA
))
/
CONVERT(DECIMAL,
ISNULL((SELECT COUNT(*) FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO AND T.NOMBRE='Moderna'),1))*100,2),

ROUND((SELECT COUNT(*) FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO AND T.NOMBRE='Tradicional'
WHERE EXISTS
(
SELECT IDREPORTE FROM REPORTE R
WHERE R.IDPUNTODEVENTA = P.IDPUNTODEVENTA
AND R.FECHACREACION BETWEEN @FECHADESDE AND @FECHAHASTA
))
/
CONVERT(DECIMAL,ISNULL((SELECT COUNT(*) FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO AND T.NOMBRE='Tradicional'),1))*100,2),

ROUND((SELECT COUNT(*) FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO AND T.NOMBRE='Perfumeria'
WHERE EXISTS
(
SELECT IDREPORTE FROM REPORTE R
WHERE R.IDPUNTODEVENTA = P.IDPUNTODEVENTA
AND R.FECHACREACION BETWEEN @FECHADESDE AND @FECHAHASTA
))
/
CONVERT(DECIMAL,ISNULL((SELECT COUNT(*) FROM PUNTODEVENTA P INNER JOIN TIPO T
ON P.IDTIPO = T.IDTIPO AND T.NOMBRE='Perfumeria'),1))*100,2)
*/

END
GO
