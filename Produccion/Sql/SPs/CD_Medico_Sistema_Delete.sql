SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Sistema_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Sistema_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Sistema_Delete]

	@IdMedico_Sistemar int
   
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[CD_Medico_Sistema]
	WHERE @IdMedico_Sistemar = [IdMedico_Sistemar]
 
END
GO
