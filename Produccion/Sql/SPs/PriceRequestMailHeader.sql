SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceRequestMailHeader]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PriceRequestMailHeader] AS' 
END
GO
ALTER procedure [dbo].[PriceRequestMailHeader]
(
	@Usuario Varchar(max),
	@Titulo varchar(max),
	@MailHeader varchar(max) out)
AS 
BEGIN

	set @MailHeader = '<!DOCTYPE html>'
	set @MailHeader = @MailHeader + '<html><head><title>Price Request Status Change</title><meta charset="utf-8">'
	set @MailHeader = @MailHeader + '<style type="text/css">'
	set @MailHeader = @MailHeader + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	set @MailHeader = @MailHeader + 'body{height: 100%;width: 100%;padding:20px;}'
	set @MailHeader = @MailHeader + 'h1{color: #ffffff;padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.container{width: 100%;height: 100%;}'
	set @MailHeader = @MailHeader + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'
	set @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 60px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	set @MailHeader = @MailHeader + 'h3{color:#FDA515;padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'p{padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;padding: 15px 50px 15px 50px;}'
	set @MailHeader = @MailHeader + 'table{width: 100%;}'
	set @MailHeader = @MailHeader + 'td{border-bottom: 1px #ddd solid;text-align: center}'
	set @MailHeader = @MailHeader + 'thead{text-align: left;}'
	set @MailHeader = @MailHeader + '</style>'
	set @MailHeader = @MailHeader + '</head>'
	set @MailHeader = @MailHeader + '<body>'
	set @MailHeader = @MailHeader + '<div class="container">'
	set @MailHeader = @MailHeader + '<div class="header">'
	set @MailHeader = @MailHeader + '<h1>Price Request</h1>'
	set @MailHeader = @MailHeader + '</div>'
	set @MailHeader = @MailHeader + '<div class="middle">'
	set @MailHeader = @MailHeader + '<p><strong>' + @Titulo + '</strong></p>'
	set @MailHeader = @MailHeader + '<p><strong>Usuario: </strong>'+ltrim(rtrim(isnull(@Usuario,'')))+'</p>'
	set @MailHeader = @MailHeader + '</div>'

END