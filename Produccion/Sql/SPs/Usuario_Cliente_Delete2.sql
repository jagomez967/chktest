SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Cliente_Delete2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Cliente_Delete2] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_Cliente_Delete2]
	-- Add the parameters for the stored procedure here
    @IdUsuario int
   ,@IdCliente int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [dbo].[Usuario_Cliente]
    WHERE [IdUsuario] = @IdUsuario and IdCliente=@IdCliente
   
END

GO
