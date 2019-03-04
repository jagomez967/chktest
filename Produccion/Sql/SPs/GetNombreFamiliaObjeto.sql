IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNombreFamiliaObjeto]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetNombreFamiliaObjeto] AS' 
END
GO
ALTER PROCEDURE [dbo].GetNombreFamiliaObjeto
(
	@idFamilia	INT,
	@idUsuario INT
)
AS
BEGIN
	DECLARE @CultureName char(2)
	DECLARE @idIdioma int 

	SELECT @CultureName = idioma FROM usuario WHERE idUsuario = @idUsuario

	SELECT @idIdioma = id FROM ReportingIdiomas 
	WHERE cultureName = @CultureName
	
	IF(@@rowcount=0)
	BEGIN
		SET @idIdioma = 1
	END

	DECLARE @Nombre VARCHAR(MAX)

	SELECT 
		@Nombre =ISNULL(TituloGrafico,'')
	FROM
		reportingDiccionarioObjeto 
	WHERE 
		idFamiliaObjeto = @idFamilia
	AND idIdioma = @idIdioma

	SELECT ISNULL(@Nombre,'') 'Nombre'

END
GO
