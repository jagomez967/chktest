SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tipo_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Tipo_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Tipo_Add]
	-- Add the parameters for the stored procedure here
	 @Nombre varchar(50)
    ,@IdNegocio int
    --,@IdCliente int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
select * from Tipo
    -- Insert statements for procedure here
	INSERT INTO [dbo].[Tipo]
           ([Nombre]
           ,[IdNegocio]
           ,[IdCliente])
     SELECT	@Nombre,
			@IdNegocio,
			c.IdCliente from Cliente c
			INNER JOIN Empresa e on c.IdEmpresa = e.IdEmpresa
			where e.IdNegocio = @IdNegocio
           

END

GO
