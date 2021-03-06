SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibidor_Marca_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibidor_Marca_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Exhibidor_Marca_GetAllCliente]
	-- Add the parameters for the stored procedure here
	@IdMarca int = NULL
   ,@IdCliente int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT EM.[Id]
          ,EM.[IdExhibidor]
          ,E.[Nombre] AS NombreExhibidor
          ,EM.[IdMarca]
          ,M.[Nombre] AS NombreMarca
    FROM [dbo].[Exhibidor_Marca] EM
    INNER JOIN [Exhibidor] E ON (E.IdExhibidor = EM.[IdExhibidor])
    INNER JOIN [Marca] M ON (M.[IdMarca] = EM.[IdMarca])
    WHERE (@IdMarca IS NULL OR  EM.[IdMarca] = @IdMarca) AND
          (@IdCliente IS NULL OR E.[IdCliente] = @IdCliente)
        
END
GO
