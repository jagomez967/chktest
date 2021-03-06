SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketShare_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarketShare_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarketShare_Add]
	-- Add the parameters for the stored procedure here
        @Nombre varchar(50)
       ,@Nivel int
       ,@IdMarketSharePadre int
       ,@Activo bit
       ,@IdMarketShare int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [MarketShare]
           ([Nombre]
           ,[Nivel]
           ,[IdMarketSharePadre]
           ,[Activo])
     VALUES
           (@Nombre
           ,@Nivel
           ,@IdMarketSharePadre
           ,@Activo)

	SET @IdMarketShare = @@identity
	
END
GO
