SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TagConfig_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TagConfig_GetAll] AS' 
END
GO
ALTER procedure [dbo].[TagConfig_GetAll]
(
	@Tabla varchar(100) = NULL
)
as
begin
	
	select Campo
	from TagConfig
	where	(@Tabla is null or Tabla=@Tabla)
	
end
GO
