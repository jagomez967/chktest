SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TagConfig_GetAllTablas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TagConfig_GetAllTablas] AS' 
END
GO
ALTER procedure [dbo].[TagConfig_GetAllTablas]
as
begin
	
	select distinct id, Tabla
	from TagConfig
	
end
GO
