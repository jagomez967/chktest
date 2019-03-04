IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDescripcionObjeto]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDescripcionObjeto] AS' 
END
GO
ALTER PROCEDURE [dbo].GetDescripcionObjeto
(
	@idObjeto	INT,
	@CultureName VARCHAR(16) = 'es'
)
AS
BEGIN
	
	IF (SELECT COUNT(1) FROM ReportingIdiomas WHERE CultureName = @CultureName) = 0 BEGIN
		SET @CultureName = 'es'
	END

	DECLARE @Desc VARCHAR(MAX)

	SELECT 
		@Desc =ISNULL(RDO.DescripcionGrafico,'')
	FROM 
		ReportingObjeto RO
		INNER JOIN ReportingFamiliaObjeto RFO ON RO.idFamiliaObjeto = RFO.Id
		INNER JOIN ReportingDiccionarioObjeto RDO ON RFO.Id = RDO.idFamiliaObjeto
		INNER JOIN ReportingIdiomas RI ON RDO.idIdioma = RI.Id
	WHERE 
		RO.Id = @idObjeto
		AND RI.CultureName = @CultureName

	SELECT ISNULL(@Desc,'') 'Desc'

END