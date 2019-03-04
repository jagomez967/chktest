SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubMarca_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SubMarca_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SubMarca_Update]
	-- Add the parameters for the stored procedure here
	@idMarca int,
    @idSubMarca int,
	@nombre varchar(max),
	@marcaColor varchar(max) = null,
	@imagenMarca varchar(max) = null,
	@idEmpresa int = null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if (charindex('<img src',@imagenMarca) <= 0) 
	BEGIN
		set @imagenMarca = '<img src="data:image/png;base64,' + @imagenMarca + '" style="height:28px;vertical-align=middle">'
	END


    -- Insert statements for procedure here
	UPDATE [dbo].[SubMarca]
    SET nombre = @nombre,
		marcaColor = @marcaColor,
		imagenMarca = @imagenMarca 
	WHERE @IdMarca = IdMarca	
	AND @idSubMarca = IdSubMarca 

END
GO
