using Reporting.Domain.Entities;
using System.Collections.Generic;

namespace Reporting.Domain.Abstract
{
    public interface ICommonRepository
    {
        bool tieneFiltrosAsignados(int idModulo, int clienteId);     
        List<PriceRequestModel> GetPriceRequest(int clientID, int productID, Dictionary<int, string> selectedCompetitors);
        List<PriceRequestModel> GetPriceRequest(string GUID);
        GapModel GetGap(int clienteId);
        string getAccountPhoto(int idAccount);
        string SendNewPriceRequest(List<NewPriceRequestForm> formList,int IdCliente,int IdUsuario);
        string UpdatePriceRequest(List<NewPriceRequestForm> formList, int IdCliente, int IdUsuario, string GUID);
        List<PhotoProductModel> GetPhotosProduct(int ProductID, string Price,int IdCadena);
        List<RequestDownPriceItemModel> GetClientPriceRequestList(int ClientId);
        List<RequestDownPriceItemModel> GetUserPriceRequestList(int clientId, int idUser);
        bool UpdatePriceRequestStatus(int idUsuario, int Status, string GUID,string Message);
        List<PriceRequestHistoryModel> getHistoryPriceRequest(string GUID);
        bool DeletePriceRequest(string GUID);
        PriceRequestSendDetailsModel GetSimpleDataFormRequest(string GUID);
        bool SendStatusMail(string GUID,int Status, string message, int idUsuario);
        string GenerarTokenPriceRequest(string GUID);
        string GetCountryCodeByName(string Country);

    } 
}
