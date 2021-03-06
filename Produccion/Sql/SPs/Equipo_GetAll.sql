SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Equipo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Equipo_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Equipo_GetAll]
	-- Add the parameters for the stored procedure here
     @IdEquipo INT = NULL
	,@IdCliente INT = NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT E.[IdEquipo]
		  ,E.[IdCliente]
          ,E.[Nombre]
          ,C.Nombre AS Cliente
    FROM [dbo].[Equipo] E
  	INNER JOIN [dbo].[Cliente] C ON (C.[IdCliente] = E.[IdCliente])
	WHERE (@IdEquipo IS NULL OR @IdEquipo = E.IdEquipo) AND
		  (@IdCliente IS NULL OR @IdCliente = E.IdCliente) AND
	      (@Nombre IS NULL OR E.[Nombre] like '%' + @Nombre + '%')


END
GO
