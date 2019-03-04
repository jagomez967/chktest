SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provincia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Provincia_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Provincia_Add]
	-- Add the parameters for the stored procedure here
	 @IdCliente INT 
	,@Nombre varchar(50)
	
AS
BEGIN

	SET NOCOUNT ON;
    
	INSERT INTO [dbo].[Provincia]
           ([IdCliente]
           ,[Nombre])
     VALUES
           (@IdCliente
           ,@Nombre)



END
GO
