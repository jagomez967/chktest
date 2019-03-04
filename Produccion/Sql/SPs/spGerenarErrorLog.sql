SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGerenarErrorLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGerenarErrorLog] AS' 
END
GO
ALTER procedure [dbo].[spGerenarErrorLog]
(
@tipoAlerta varchar(max)
)
AS
BEGIN
insert logABM_Reporting(mensaje)
values (@tipoAlerta)
END

GO
