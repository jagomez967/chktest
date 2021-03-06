SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vendedor_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Vendedor_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Vendedor_Add]
	-- Add the parameters for the stored procedure here
    @IdEquipo int
   ,@Nombre varchar(50)
   ,@Telefono varchar(50) = NULL
   ,@Email varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Vendedor]
           ([IdEquipo]
           ,[Nombre]
           ,[Telefono]
           ,[Email])
     VALUES
           (@IdEquipo
           ,@Nombre
           ,@Telefono
           ,@Email)
           
END
GO
