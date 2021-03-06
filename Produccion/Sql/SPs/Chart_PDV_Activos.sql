SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Chart_PDV_Activos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Chart_PDV_Activos] AS' 
END
GO
ALTER PROCEDURE [dbo].[Chart_PDV_Activos]
AS
BEGIN


/* PDV Asignados */
SELECT
'ASIGNADOS' AS NOMBRE, COUNT(*) as TOTAL
FROM PUNTODEVENTA P 
WHERE EXISTS
(
SELECT IDVENDEDOR FROM PUNTODEVENTA_VENDEDOR V
WHERE V.IDPUNTODEVENTA = P.IDPUNTODEVENTA
)
UNION
/* PDV sin Asignar */
SELECT
'SIN ASIGNAR',COUNT(*) as TOTAL
FROM PUNTODEVENTA P 
WHERE NOT EXISTS
(
SELECT IDVENDEDOR FROM PUNTODEVENTA_VENDEDOR V
WHERE V.IDPUNTODEVENTA = P.IDPUNTODEVENTA
)

END
GO
