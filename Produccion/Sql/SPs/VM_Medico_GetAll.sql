SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Medico_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Medico_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Medico_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMedico int = NULL
   ,@IdCliente int = NULL
   ,@Nombre varchar(100) = NULL
   ,@Domicilio varchar(100) = NULL
   ,@IdZona int = NULL
   ,@IdLocalidad int = NULL
   ,@LocalidadOriginal varchar(200) = NULL
   ,@CodigoPostal varchar(10) = NULL
   ,@Matricula varchar(50) = NULL
   ,@Categoria int = NULL
   ,@Telefono varchar(50) = NULL
   ,@Email varchar(50) = NULL
   ,@Especialidad varchar(10) = NULL   
   
   AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdMedico]
	      ,[IdCliente]
		  ,[Nombre]
		  ,[Domicilio]
		  ,[IdZona]
		  ,[IdLocalidad]
		  ,[LocalidadOriginal]
		  ,[CodigoPostal]
		  ,[Matricula]
		  ,[Categoria]
		  ,[Telefono]
		  ,[Email]
		  ,[Especialidad]
	  FROM [dbo].[VM_Medico]
	  WHERE (@IdMedico IS NULL OR @IdMedico = [IdMedico]) AND
		    (@IdCliente IS NULL OR @IdCliente = [IdCliente]) AND
		    (@Nombre IS NULL OR [Nombre] LIKE  '%' + @Nombre + '%') AND
		    (@Domicilio IS NULL OR [Domicilio] LIKE  '%' + @Domicilio + '%') AND
		    (@IdZona IS NULL OR @IdZona =[IdZona]) AND
		    (@IdLocalidad IS NULL OR @IdLocalidad=[IdLocalidad]) AND
		    (@Categoria IS NULL OR @Categoria=[Categoria]) AND
		    (@Especialidad IS NULL OR @Especialidad=[Especialidad])
	  ORDER BY [Nombre]

END
GO
