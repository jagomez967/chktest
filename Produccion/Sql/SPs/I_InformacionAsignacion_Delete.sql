SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_InformacionAsignacion_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_InformacionAsignacion_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[I_InformacionAsignacion_Delete]
	
	@IdInformacionAsignacion int
	
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[I_InformacionAsignacion]
    WHERE IdInformacionAsignacion=@IdInformacionAsignacion

END
GO
