SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Familia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Familia_GetAll] AS' 
END
GO



ALTER procedure [dbo].[Familia_GetAll]
(
	@IdCliente int=null
	,@Nombre varchar(100)=null
	,@IdMarca int=null
	,@idFamilia int = null
)
as
begin
	set nocount on

	SELECT DISTINCT
		F.idFamilia,
		F.idMarca,
		F.Nombre,
		M.Nombre Marca
	FROM 
		Marca M
		INNER JOIN Familia F ON M.idMarca = F.idMarca
		LEFT JOIN Cliente C ON M.idEmpresa = C.idEmpresa
	WHERE 
		1 = CASE WHEN ISNULL(@idCliente,0) = 0 THEN 1 ELSE CASE WHEN C.IdCliente = ISNULL(@idCliente,C.idCliente) THEN 1 ELSE 0 END END 
		AND F.Nombre LIKE '%' + ISNULL(@Nombre,F.Nombre) + '%'
		AND M.idMarca = ISNULL(@idMarca,M.idMarca)
		AND F.idFamilia = ISNULL(@idFamilia,F.idFamilia)
	UNION
	SELECT DISTINCT
		F.idFamilia,
		F.idMarca,
		F.Nombre,
		M.Nombre Marca
	FROM 
		MarcaCompetencia MC
		INNER JOIN Familia F ON MC.IdMarcaCompetencia = F.idMarca
		INNER JOIN Marca M ON MC.idMarcaCompetencia = M.idMarca
	WHERE 
		MC.IdMarca IN (
					SELECT 
						M.IdMarca
					FROM 
						Marca M
						INNER JOIN Cliente C ON M.idEmpresa = C.idEmpresa
					WHERE 
						1 = CASE WHEN ISNULL(@idCliente,0) = 0 THEN 1 ELSE CASE WHEN C.IdCliente = ISNULL(@idCliente,C.idCliente) THEN 1 ELSE 0 END END 
				)
		AND F.Nombre LIKE '%' + ISNULL(@Nombre,F.Nombre) + '%'
		AND M.idMarca = ISNULL(@idMarca,M.idMarca)
		AND F.idFamilia = ISNULL(@idFamilia,F.idFamilia)
	ORDER BY
		F.Nombre

	/*
	Select	distinct F.IdFamilia as IdFamilia
			,F.IdMarca as IdMarca
			,F.Nombre as Nombre
			,M.Nombre as Marca
	from Cliente C, Familia F
	inner join Marca M on F.IdMarca=M.IdMarca
	--inner join Cliente C on C.IdEmpresa=M.IdEmpresa
	where (@IdCliente is null or C.IdCliente=@IdCliente)
			and (@Nombre is null or F.Nombre like '%'+@Nombre+'%')
			and (@IdMarca is null or M.IdMarca=@IdMarca)
			and (@idFamilia is null or f.idFamilia = @idFamilia)
	order by F.Nombre
	*/
end

GO
