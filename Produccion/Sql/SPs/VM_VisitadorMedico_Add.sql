SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_VisitadorMedico_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_VisitadorMedico_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[VM_VisitadorMedico_Add]
	-- Add the parameters for the stored procedure here
    @IdCliente int 
   ,@Apellido varchar(50)
   ,@Nombre varchar(50) = NULL
   ,@IdUsuario int = NULL
   ,@Activo bit
   ,@IdVisitadorMedico int OUTPUT
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[VM_VisitadorMedico]
           ([IdCliente]
           ,[Apellido]
           ,[Nombre]
           ,[IdUsuario]
           ,[Activo])
     VALUES
           (@IdCliente
           ,@Apellido
           ,@Nombre
           ,@IdUsuario
           ,@Activo)
           
     SET @IdVisitadorMedico = @@Identity
     
     END
GO
