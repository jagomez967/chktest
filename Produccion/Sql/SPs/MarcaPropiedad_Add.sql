SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaPropiedad_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaPropiedad_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaPropiedad_Add]
	-- Add the parameters for the stored procedure here
	@IdMarca int
   ,@Nombre varchar(100)
   ,@Descripcion varchar(200) = NULL 
   ,@Opcional bit = NULL
   ,@NoExhibe bit = NULL
   ,@NoAutorizada bit = NULL
   ,@NoTrabaja bit = NULL
  
   AS
   
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[MarcaPropiedad]
           ([IdMarca]
           ,[Nombre]
           ,[Descripcion]
           ,[Opcional]
           ,[NoExhibe]
           ,[NoAutorizada]
           ,[NoTrabaja])
     VALUES
           (@IdMarca
           ,@Nombre
           ,@Descripcion
           ,@Opcional
           ,@NoExhibe
           ,@NoAutorizada
           ,@NoTrabaja)
           
END
GO
