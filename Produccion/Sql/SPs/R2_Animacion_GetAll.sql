SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Animacion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Animacion_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Animacion_GetAll]
	-- Add the parameters for the stored procedure here
	@IdAnimacion int = NULL
   ,@Descripcion varchar(100) = NULL 
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT A.[IdAnimacion]
	      ,A.[IdMarca]
		  ,A.[Descripcion]
		  ,A.[Orden]
		  ,A.[Activo]
		  ,M.Nombre As NombreMarca
	FROM [dbo].[R2_Animacion] A
	INNER JOIN Marca M ON (M.IdMarca = A.[IdMarca])
	WHERE (@IdAnimacion IS NULL OR @IdAnimacion = A.[IdAnimacion]) AND
	      (@Descripcion IS NULL OR (A.[Descripcion] like '%' + @Descripcion + '%'))
  
END
GO
