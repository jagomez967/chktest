SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_Add]
	-- Add the parameters for the stored procedure here
	 @IdDrogueria int output
	,@Nombre varchar(50) = NULL
	
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [dbo].[Drogueria]
           ([Nombre])
     VALUES
           (@Nombre)
           
     Set @IdDrogueria = @@identity

END
GO
