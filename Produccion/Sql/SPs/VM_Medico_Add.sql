SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Medico_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Medico_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Medico_Add]
	-- Add the parameters for the stored procedure here

    @Nombre varchar(100) 
   ,@IdCliente int 
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
	INSERT INTO [dbo].[VM_Medico]
           ([IdCliente]
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
           ,[Especialidad])
     VALUES
           (@IdCliente
           ,@Nombre
           ,@Domicilio
           ,@IdZona
           ,@IdLocalidad
           ,@LocalidadOriginal
           ,@CodigoPostal
           ,@Matricula
           ,@Categoria
           ,@Telefono
           ,@Email
           ,@Especialidad)
END
GO
