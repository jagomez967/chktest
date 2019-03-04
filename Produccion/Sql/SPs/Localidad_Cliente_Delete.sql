SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Localidad_Cliente_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Localidad_Cliente_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Localidad_Cliente_Delete]
	-- Add the parameters for the stored procedure here
	@IdLocalidad int
   ,@IdCliente int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [dbo].[Localidad_Cliente]
    WHERE (@IdLocalidad IS NULL OR  [IdLocalidad] = @IdLocalidad) AND
          (@IdCliente IS NULL OR [IdCliente] = @IdCliente)
	
END
GO
