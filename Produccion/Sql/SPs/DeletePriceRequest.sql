SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeletePriceRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DeletePriceRequest] AS' 
END
GO
ALTER procedure [dbo].[DeletePriceRequest]
(
@GUID UNIQUEIDENTIFIER
)
AS
BEGIN
	update PriceRequest
	set activo = 0
	where ID = @GUID
END
