SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_Update]
	-- Add the parameters for the stored procedure here
	 @IdDrogueria int
	,@Nombre varchar(50) = NULL
	
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[Drogueria]
    SET [Nombre] = @Nombre
	WHERE [IdDrogueria]  = @IdDrogueria

END
GO
