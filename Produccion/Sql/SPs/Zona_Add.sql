SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Zona_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Zona_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Zona_Add]
	-- Add the parameters for the stored procedure here
	 @IdCliente INT
	,@Nombre varchar(100)
	
AS
BEGIN

	SET NOCOUNT ON;
    
	INSERT INTO [dbo].[Zona]
           ([IdCliente]
           ,[Nombre])
     VALUES
           (@IdCliente
           ,@Nombre)



END
GO
