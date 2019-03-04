SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Modulo_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Modulo_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_Modulo_Delete]
	 @IdModulo int	
    
AS
BEGIN
	SET NOCOUNT ON;

    DELETE FROM [dbo].[MD_Modulo]	
	WHERE @IdModulo = [IdModulo] 
 
END
GO
