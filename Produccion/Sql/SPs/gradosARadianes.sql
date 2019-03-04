CREATE FUNCTION dbo.gradosAradianes(@grados decimal (18,8))
returns decimal(18,8)
WITH EXECUTE AS CALLER
as
BEGIN
	declare @Rad decimal(18,8)

	set @Rad = @grados * pi() / 180.0

	return @rad
END
GO
