SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Delete]
	
	@IdMedico int
      
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM [dbo].[CD_Medico]
	WHERE @IdMedico = [IdMedico]

END
GO
