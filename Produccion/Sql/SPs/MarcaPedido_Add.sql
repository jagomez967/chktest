SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaPedido_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaPedido_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaPedido_Add]
	-- Add the parameters for the stored procedure here
	 @Nombre varchar(100)
	,@IdEmpresa int
	,@Orden int = NULL
	,@IdMarcaPedido int output
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[MarcaPedido]
           ([Nombre]
           ,[IdEmpresa]
           ,[Orden])
     VALUES
           (@Nombre
           ,@IdEmpresa
           ,@Orden)
                      
     SET @IdMarcaPedido = @@identity   
           

END
GO
