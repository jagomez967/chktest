SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaPedido_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaPedido_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaPedido_Update]
	-- Add the parameters for the stored procedure here
	 @Nombre varchar(100)
	,@IdEmpresa int
	,@Orden int = NULL
	,@IdMarcaPedido int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[MarcaPedido]
    SET [Nombre] = @Nombre
       ,[IdEmpresa] = @IdEmpresa
       ,[Orden] = @Orden
	WHERE @IdMarcaPedido = IdMarcaPedido

END
GO
