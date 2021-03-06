SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailReporte] AS' 
END
GO
ALTER procedure [dbo].[spGenerarMailReporte]
(
	@IdReporte int
)
as
begin

	declare @idEmpresa int
	declare @SP varchar(200)
	declare @IdPuntoDeVenta int


	--#1: Busco el IdEmpresa en la tabla Reporte
	Select @idEmpresa = idEmpresa, @IdPuntoDeVenta = IdPuntoDeVenta from Reporte where idReporte = @IdReporte

	if isnull(@idEmpresa,-1) = -1 or isnull(@IdPuntoDeVenta,-1)=-1
		return

	--EmpresaMailParametros
	Select @SP = ltrim(rtrim(EMT.Nombre))
	from EmpresaMailParametros EMP
	inner join EmpresaMailTipoMail EMT on EMT.IdEmpresaMailTipoMail = EMP.IdEmpresaMailTipoMail
	where	EMP.idEmpresa = @idEmpresa
			and EMP.IdPuntoDeVenta = @IdPuntoDeVenta
			and EMP.Activo = 1
	
	if isnull(@SP,'')<>''
	begin
		set @SP = @SP + ' ' + ltrim(rtrim(str(@IdReporte)))
		execute(@SP)
	end
end
GO
