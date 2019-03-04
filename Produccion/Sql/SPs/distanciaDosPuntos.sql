
alter FUNCTION dbo.distanciaDosPuntos(@lat1 decimal(18,8),@lon1 decimal(18,8),@lat2 decimal(18,8),@lon2 decimal(18,8))
returns decimal(18,8)
WITH EXECUTE AS CALLER
as
BEGIN
	declare @radioTierra int
	declare @Distancia decimal(18,8)

	declare @dLat decimal(18,8)
	declare @dLon decimal(18,8)

	declare @a decimal(28,18)
	declare @c decimal(18,8)

	set @radioTierra = 6371000 --MTS
	set @dLat = dbo.gradosARadianes(@lat2 - @lat1)
	set @dLon = dbo.gradosAradianes(@lon2 - @lon1)

	set @lat1 = dbo.gradosAradianes(@lat1)
	set @lat2 = dbo.gradosAradianes(@lat2)

	set @a = sin(@dlat/2.0) * sin(@dlat/2.0) +
			sin(@dlon/2.0) * sin(@dlon / 2.0) * cos(@lat1) * cos(@lat2)
	set @c = 2.0 * atn2(sqrt(@a),sqrt(1-@a))

	return convert(decimal(18,8),@c * @radioTierra)
END

go