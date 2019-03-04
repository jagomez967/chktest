using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.SS.Util;
using NPOI.XSSF.UserModel;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;

namespace Reporting.Domain.Concrete
{
    public class CommonRepository : ICommonRepository
    {
        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();
        private readonly RepContext context = new RepContext();
        private readonly string _pathFoto = @"\\checkposdiag742.file.core.windows.net\fotos\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Fotos\";
        private readonly string _directoryArchivos = @"\\checkposdiag742.file.core.windows.net\fotos\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Reporting\Content\downloadPriceRequest\";
        private readonly string _templateFile = @"\\checkposdiag742.file.core.windows.net\fotos\templates\PriceRequestTemplate.xlsx";

        //private readonly string _pathFoto = @"C:\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Fotos\";
        //private readonly string _directoryArchivos = @"C:\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Reporting\Content\downloadPriceRequest\";
        //private readonly string _templateFile = @"C:\templates\PriceRequestTemplate.xlsx";


        public bool tieneFiltrosAsignados(int idModulo, int clienteId)
        {
            return context.ReportingFiltros.Any(f => f.ReportingFiltrosModulo.Any(rf => rf.idCliente == clienteId && rf.idModulo == idModulo));
        }

        // BAJA DE PRECIOS EPSON    
        #region PriceRequest
        public List<PriceRequestModel> GetPriceRequest(int clientID,int productID, Dictionary<int, string> selectedCompetitors)
        {
            List<PriceRequestModel> res = new List<PriceRequestModel>();
            foreach(KeyValuePair<int,string> Competitor in selectedCompetitors)
            {
                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("GetPriceRequestForm")
                    {
                        CommandType = CommandType.StoredProcedure,
                        CommandTimeout = 30
                    };
                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clientID;
                    cmd.Parameters.Add("@IdProducto", SqlDbType.Int).Value = productID;
                    cmd.Parameters.Add("@IdCompetidor", SqlDbType.Int).Value = Competitor.Key;
                    cmd.Parameters.Add("@Cadenas", SqlDbType.VarChar).Value = Competitor.Value;

                    cmd.Connection = cn;
                    cn.Open();

                    SqlDataReader r = cmd.ExecuteReader();

                    if (r.HasRows)
                    {
                        while (r.Read())
                        {
                            PriceRequestModel PriceRequest = new PriceRequestModel()
                            {
                                Account = r["account"].ToString(),
                                AccountId = int.Parse(r["accountId"].ToString()),
                                NetAsp = decimal.Parse(r["netAsp"].ToString()),
                                NetAspCondition = decimal.Parse(r["netAspCondition"].ToString()),
                                IdealGap = decimal.Parse(r["idealGap"].ToString()),
                                PriceGap = decimal.Parse(r["priceGap"].ToString()),
                                Product = new Product_M()
                                {
                                    EOL = false,
                                    Id = int.Parse(r["ownProductId"].ToString()),
                                    BrandId = int.Parse(r["ownBrandId"].ToString()),
                                    Name = r["ownProductName"].ToString(),
                                    Brand = r["ownBrandName"].ToString(),
                                    Price = decimal.Parse(r["ownProductPrice"].ToString()),
                                    Inventory = int.Parse(r["ownProductInventory"].ToString()),
                                    SellIn = int.Parse(r["ownSellIn"].ToString()),
                                    SellOut = int.Parse(r["ownSellOut"].ToString())
                                },
                                Competitor = new Product_M()
                                {
                                    EOL = false,
                                    Id = int.Parse(r["competitorProductId"].ToString()),
                                    BrandId = int.Parse(r["competitorBrandId"].ToString()),
                                    Name = r["competitorProductName"].ToString(),
                                    Brand = r["competitorBrandName"].ToString(),
                                    Price = decimal.Parse(r["competitorProductPrice"].ToString()),
                                    Inventory = int.Parse(r["competitorProductInventory"].ToString()),
                                    PriceGap = decimal.Parse(r["PriceGap"].ToString()),
                                    SellIn = int.Parse(r["competitorSellIn"].ToString()),
                                    SellOut = int.Parse(r["competitorSellOut"].ToString())
                                }
                            };
                            res.Add(PriceRequest);
                        }
                    }
                }
            }           
            return res;
        }

        public string getAccountPhoto(int idAccount)
        {
            string image64 = "";
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetAccountPhoto")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@IdCadena", SqlDbType.Int).Value = idAccount;
                cmd.Connection = cn;               
                cn.Open();
               
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        image64 = r["image64"].ToString();
                    }
                }
            }
            return image64;
        }

        public GapModel GetGap(int clienteId)
        {
            GapModel gapList = new GapModel();

            SqlCommand cmd = new SqlCommand("GetGapCliente")
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables.Count <= 0)
                {
                    return gapList;
                }

                DataTable dtData = ds.Tables[0];
                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        gapList.Detail.Add(new GapModelDetail()
                        {
                            AccountId = int.Parse(dr["IdCadena"].ToString()),
                            ProductId = int.Parse(dr["IdProducto"].ToString()),
                            CompetitorId = int.Parse(dr["IdCompetencia"].ToString()),
                            SelfPrice = decimal.Parse(dr["PrecioPropio"].ToString()),
                            CompetitorPrice = decimal.Parse(dr["PrecioCompetencia"].ToString()),
                            PriceGap = decimal.Parse(dr["Gap"].ToString()),
                            Color = dr["Color"].ToString(),
                            SellIn = int.Parse(dr["SellIn"].ToString()),
                            Inventory = int.Parse(dr["Inventory"].ToString()),
                            OrderMath = float.Parse(dr["OrderMath"].ToString())
                        });
                    }
                }

                //cadenas
                DataTable dtData_account = ds.Tables[1];

                if (dtData_account.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData_account.Rows)
                    {
                        gapList.Accounts.Add(new GapModelAccount()
                        {
                            Id = int.Parse(dr["IdCadena"].ToString()),
                            Name = dr["Nombre"].ToString(),
                            Image = dr["Imagen"].ToString()
                        });
                    }
                }
                //Productos
                DataTable dtData_Products = ds.Tables[2];

                if (dtData_Products.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData_Products.Rows)
                    {
                        gapList.Products.Add(new GapModelProduct()
                        {
                            Id = int.Parse(dr["IdProducto"].ToString()),
                            Name = dr["Nombre"].ToString(),
                            Image = dr["Imagen"].ToString()
                        });
                    }
                }
            }
            return gapList;
        }
        public string UpdatePriceRequest(List<NewPriceRequestForm> formList, int IdCliente, int IdUsuario, string GUID)
        {
            foreach (NewPriceRequestForm f in formList)
            {
                SqlCommand cmd = new SqlCommand("PriceRequest_update")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 240
                };

                cmd.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cmd.Parameters.Add("@IdCadena", SqlDbType.Int).Value = f.AccountId;
                cmd.Parameters.Add("@IdProducto", SqlDbType.Int).Value = f.ProductId;
                cmd.Parameters.Add("@IdProductoCompetencia", SqlDbType.Int).Value = f.CompetitorId;
                cmd.Parameters.Add("@FotoPropia", SqlDbType.VarChar).Value = f.SelfPhoto;
                cmd.Parameters.Add("@FotoCompetencia", SqlDbType.VarChar).Value = f.CompPhoto;
                cmd.Parameters.Add("@EOLPropio", SqlDbType.Int).Value = f.EOLSelf;
                cmd.Parameters.Add("@EOLCompetencia", SqlDbType.Int).Value = f.EOLComp;
                cmd.Parameters.Add("@InventarioPropio", SqlDbType.Int).Value = f.SelfInventory;
                cmd.Parameters.Add("@InventarioCompetencia", SqlDbType.Int).Value = f.CompInventory;
                cmd.Parameters.Add("@UBP", SqlDbType.Decimal).Value = f.UBP;
                cmd.Parameters.Add("@NetASP", SqlDbType.Decimal).Value = f.NetAsp;
                cmd.Parameters.Add("@NetASPCondition", SqlDbType.Decimal).Value = f.NetAspCondition;
                cmd.Parameters.Add("@PrecioPropio", SqlDbType.Decimal).Value = f.SelfPrice;
                cmd.Parameters.Add("@PrecioCompetencia", SqlDbType.Decimal).Value = f.CompPrice;
                cmd.Parameters.Add("@idealGap", SqlDbType.Decimal).Value = f.IdealGap;
                cmd.Parameters.Add("@PriceGap", SqlDbType.Decimal).Value = f.PriceGap;               
                cmd.Parameters.Add("@aspVariancePercent", SqlDbType.Decimal).Value = f.ASPVariancePercent;                
                cmd.Parameters.Add("@aspVariancePrice", SqlDbType.Decimal).Value = f.ASPVariancePrice;
                cmd.Parameters.Add("@UBPProposal", SqlDbType.Decimal).Value = f.UBPProposal;

                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    cmd.Connection = cn;
                    cn.Open();                   
                    cmd.ExecuteNonQuery();                    
                    cn.Close();                    
                }
            }
            return GUID;
        }

        public string SendNewPriceRequest(List<NewPriceRequestForm> formList, int IdCliente, int IdUsuario)
        {
            string newPRGUID = "";
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd_g = new SqlCommand("GetNewPRGUID")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd_g.Parameters.Add("@idCliente", SqlDbType.Int).Value = IdCliente;
                cmd_g.Parameters.Add("@idUsuario", SqlDbType.Int).Value = IdUsuario;

                cmd_g.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd_g.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        newPRGUID = r["GUID"].ToString();
                    }
                }
            }

            foreach (NewPriceRequestForm f in formList)
            {
                SqlCommand cmd = new SqlCommand("PriceRequest_add")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 240
                };

                cmd.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(newPRGUID);
                cmd.Parameters.Add("@IdCadena", SqlDbType.Int).Value = f.AccountId;
                cmd.Parameters.Add("@IdProducto", SqlDbType.Int).Value = f.ProductId;
                cmd.Parameters.Add("@IdProductoCompetencia", SqlDbType.Int).Value = f.CompetitorId;
                cmd.Parameters.Add("@FotoPropia", SqlDbType.VarChar).Value = f.SelfPhoto;
                cmd.Parameters.Add("@FotoCompetencia", SqlDbType.VarChar).Value = f.CompPhoto;
                cmd.Parameters.Add("@EOLPropio", SqlDbType.Int).Value = f.EOLSelf;
                cmd.Parameters.Add("@EOLCompetencia", SqlDbType.Int).Value = f.EOLComp;                
                cmd.Parameters.Add("@InventarioPropio", SqlDbType.Int).Value = f.SelfInventory;
                cmd.Parameters.Add("@InventarioCompetencia", SqlDbType.Int).Value = f.CompInventory;
                cmd.Parameters.Add("@UBP", SqlDbType.Decimal).Value = f.UBP;
                cmd.Parameters.Add("@NetASP", SqlDbType.Decimal).Value = f.NetAsp;                
                cmd.Parameters.Add("@NetASPCondition", SqlDbType.Decimal).Value = f.NetAspCondition;
                cmd.Parameters.Add("@PrecioPropio", SqlDbType.Decimal).Value = f.SelfPrice;
                cmd.Parameters.Add("@PrecioCompetencia", SqlDbType.Decimal).Value = f.CompPrice;
                cmd.Parameters.Add("@idealGap", SqlDbType.Decimal).Value = f.IdealGap;
                cmd.Parameters.Add("@PriceGap", SqlDbType.Decimal).Value = f.PriceGap;
                cmd.Parameters.Add("@aspVariancePercent", SqlDbType.Decimal).Value = f.ASPVariancePercent;               
                cmd.Parameters.Add("@aspVariancePrice", SqlDbType.Decimal).Value = f.ASPVariancePrice;
                cmd.Parameters.Add("@UBPProposal", SqlDbType.Decimal).Value = f.UBPProposal;

                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    cmd.Connection = cn;
                    cn.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        logger.Error(e, "error en SendNewPriceRequest - commonRepository: " + e.Message);
                        return string.Empty;
                    }
                    finally
                    {
                        cn.Close();
                    }
                }
            }
            return newPRGUID;
        }

        //Lo tuve que hacer publico para accederlo directamente desde el admin para editarlo
        public bool UpdatePriceRequestStatus(int idUsuario, int Status, string GUID, string message = "")
        {
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd_e = new SqlCommand("UpdatePriceRequestStatus")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 100
                };
                cmd_e.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cmd_e.Parameters.Add("@NewStatus", SqlDbType.Int).Value = Status;
                cmd_e.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = idUsuario;
                cmd_e.Parameters.Add("@Mensaje", SqlDbType.VarChar).Value = message;

                cmd_e.Connection = cn;
                try
                {
                    cn.Open();
                    cmd_e.ExecuteNonQuery();
                }
                catch (Exception exc)
                {
                    logger.Error(exc, "Error en UpdatePriceRequestStatus - commonRepository: " + exc.Message);
                    return false;
                }
            }
            return true;
        }

        public List<PhotoProductModel> GetPhotosProduct(int ProductID, string Price, int IdCadena)
        {
            List<PhotoProductModel> listaFotos = new List<PhotoProductModel>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetPhotosPriceRequest")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 200
                };
                cmd.Parameters.Add("@idProducto", SqlDbType.Int).Value = ProductID;
                cmd.Parameters.Add("@precio", SqlDbType.VarChar).Value = Price;
                cmd.Parameters.Add("@idCadena", SqlDbType.Int).Value = IdCadena;
                cmd.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        listaFotos.Add(new PhotoProductModel()
                        {
                            IdPuntoDeVenta = int.Parse(r["IdPuntoDeVenta"].ToString()),
                            PuntoDeVenta = r["PuntoDeVenta"].ToString(),
                            Direccion = r["Direccion"].ToString(),
                            IdImagen = int.Parse(r["IdImagen"].ToString()),
                            IdProducto = int.Parse(r["IdProducto"].ToString()),
                            IdUsuario = int.Parse(r["IdUsuario"].ToString()),
                            IdReporte = int.Parse(r["IdReporte"].ToString()),
                            Usuario = r["Usuario"].ToString(),
                            Fecha = r["Fecha"].ToString(),
                            IdEmpresa = int.Parse(r["IdEmpresa"].ToString()),
                            FotoTag = bool.Parse(r["TieneTag"].ToString())
                        });
                    }
                }
            }

            foreach (PhotoProductModel photo in listaFotos)
            {
                Byte[] bytes = null;
                string pathFoto = _pathFoto + photo.IdEmpresa + @"\thumb" + photo.IdImagen + ".jpg";
                string pathFotoJpeg = _pathFoto + photo.IdEmpresa + @"\thumb" + photo.IdImagen + ".jpeg";

                if (File.Exists(pathFoto))
                {
                    bytes = File.ReadAllBytes(pathFoto);
                }
                else if (File.Exists(pathFotoJpeg))
                {
                    bytes = File.ReadAllBytes(pathFotoJpeg);
                }

                if (bytes == null)
                {
                    photo.Base64 = string.Empty;
                }
                else
                {
                    photo.Base64 = Convert.ToBase64String(bytes);
                }
            }
            return listaFotos;
        }

        public List<RequestDownPriceItemModel> GetUserPriceRequestList(int clientId, int idUser)
        {
            List<RequestDownPriceItemModel> requestList = new List<RequestDownPriceItemModel>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetUserPriceRequest")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 200
                };
                cmd.Parameters.Add("@idCliente", SqlDbType.Int).Value = clientId;
                cmd.Parameters.Add("@idUsuario", SqlDbType.Int).Value = idUser;
                cmd.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        string PreNewArrayAccount = r["Cuentas"].ToString();
                        string[] newArrayAccount = PreNewArrayAccount.ToString().Split(';');

                        List<string> newListAccount = newArrayAccount.ToList();
                        requestList.Add(new RequestDownPriceItemModel()
                        {
                            GUID = r["Id"].ToString(),
                            Country = r["Pais"].ToString(),
                            CountryCode = r["CodigoPais"].ToString(),
                            UserName = r["Usuario"].ToString(),
                            Date = r["Fecha"].ToString(),
                            DateNextAlert = r["FechaAlerta"].ToString(),
                            Status = new PriceRequestStatusModel()
                            {
                                Id = int.Parse(r["idEstado"].ToString()),
                                Description = r["Estado"].ToString()
                            },
                            AccountList = newListAccount,
                            ProductName = r["Producto"].ToString()
                        });
                    }
                }
            }
            return requestList;
        }

        public List<RequestDownPriceItemModel> GetClientPriceRequestList(int ClientId)
        {
            List<RequestDownPriceItemModel> requestList = new List<RequestDownPriceItemModel>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetClientPriceRequest")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 200
                };
                cmd.Parameters.Add("@idCliente", SqlDbType.Int).Value = ClientId;

                cmd.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        requestList.Add(new RequestDownPriceItemModel()
                        {
                            GUID = r["Id"].ToString(),
                            Country = r["Pais"].ToString(),
                            CountryCode = r["CodigoPais"].ToString(),
                            UserName = r["Usuario"].ToString(),
                            Date = r["Fecha"].ToString(),
                            DateNextAlert = r["FechaAlerta"].ToString(),
                            Status = new PriceRequestStatusModel()
                            {
                                Id = int.Parse(r["idEstado"].ToString()),
                                Description = r["Estado"].ToString()
                            },
                            AccountList = r["Cuentas"].ToString().Split(';').ToList(),
                            ProductName = r["Producto"].ToString()
                        });
                    }
                }
            }
            return requestList;
        }
        public List<PriceRequestModel> GetPriceRequest(string GUID)
        {
            List<PriceRequestModel> res = new List<PriceRequestModel>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetPriceRequestFormByGUID")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@ID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cmd.Connection = cn;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        PriceRequestModel PriceRequest = new PriceRequestModel()
                        {
                            Account = r["account"].ToString(),
                            AccountId = int.Parse(r["accountId"].ToString()),
                            NetAsp = decimal.Parse(r["netAsp"].ToString()),
                            NetAspCondition = decimal.Parse(r["netAspCondition"].ToString()),
                            IdealGap = decimal.Parse(r["idealGap"].ToString()),
                            PriceGap = decimal.Parse(r["priceGap"].ToString()),
                            Product = new Product_M()
                            {
                                EOL = bool.Parse(r["SelfEOL"].ToString()),
                                Id = int.Parse(r["ownProductId"].ToString()),
                                BrandId= int.Parse(r["ownBrandId"].ToString()),
                                Name = r["ownProductName"].ToString(),
                                Brand = r["ownBrandName"].ToString(),
                                Price = decimal.Parse(r["ownProductPrice"].ToString()),
                                Inventory = int.Parse(r["ownProductInventory"].ToString()),
                                UBP = decimal.Parse(r["ownProductUBP"].ToString()),
                                UBPProposal = decimal.Parse(r["ownProductUBPP"].ToString()),
                                Photo = r["selfPhoto"].ToString()
                            },
                            Competitor = new Product_M()
                            {
                                EOL = bool.Parse(r["CompetitorEOL"].ToString()),
                                Id = int.Parse(r["competitorProductId"].ToString()),
                                BrandId = int.Parse(r["competitorBrandId"].ToString()),
                                Name = r["competitorProductName"].ToString(),
                                Brand = r["competitorBrandName"].ToString(),
                                Price = decimal.Parse(r["competitorProductPrice"].ToString()),
                                Inventory = int.Parse(r["competitorProductInventory"].ToString()),
                                UBP = decimal.Parse(r["competitorProductUBP"].ToString()),
                                UBPProposal = decimal.Parse(r["competitorProductUBPP"].ToString()),
                                PriceGap = decimal.Parse(r["PriceGap"].ToString()),
                                Photo = r["CompetitorPhoto"].ToString()
                            }
                        };
                        res.Add(PriceRequest);
                    }                
                }
            }
            return res;
        }
        public List<PriceRequestHistoryModel> getHistoryPriceRequest(string GUID)
        {
            List<PriceRequestHistoryModel> res = new List<PriceRequestHistoryModel>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetPriceRequestHistory")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@ID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cmd.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        res.Add(new PriceRequestHistoryModel()
                        {
                            Date = r["fecha"].ToString(),
                            Commentary = r["comentario"].ToString(),
                            GUID = GUID,
                            State = new PriceRequestStatusModel()
                            {
                                Id = int.Parse(r["idEstado"].ToString()),
                                Description = r["estado"].ToString()
                            },
                            User = r["usuario"].ToString()
                        });
                    }
                }
            }
            return res;
        }

        public bool DeletePriceRequest(string GUID)
        {
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd_e = new SqlCommand("DeletePriceRequest")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 100
                };
                cmd_e.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);

                cmd_e.Connection = cn;
                try
                {
                    cn.Open();
                    cmd_e.ExecuteNonQuery();
                }
                catch (Exception exc)
                {
                    logger.Error(exc, "Error en DeletePriceRequest - commonRepository: " + exc.Message);
                    return false;
                }
            }
            return true;
        }

        public PriceRequestSendDetailsModel GetSimpleDataFormRequest(string GUID)
        {
            PriceRequestSendDetailsModel data = new PriceRequestSendDetailsModel();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetPriceRequestSimpleData")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@ID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cmd.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {                    
                    while (r.Read())
                    {
                        data.Date = r["fecha"].ToString();
                        data.Country = r["pais"].ToString();
                        data.GUID = r["GUID"].ToString();
                        data.Id = int.Parse(r["ID"].ToString());
                        data.User = r["usuario"].ToString();
                    }                 
                }
            }
            return data;
        }
        public bool SendStatusMail(string GUID, int Status, string message, int idUsuario)
        {
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("EnviarMailPriceRequest")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 200
                };
                cmd.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = idUsuario;
                cmd.Parameters.Add("@Estado", SqlDbType.Int).Value = Status;
                cmd.Parameters.Add("@mensaje", SqlDbType.VarChar).Value = message;

                cmd.Connection = cn;
                try
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception exc)
                {
                    logger.Error(exc, "Error en SendStatusMail - CommonRepository: " + exc.Message);
                    return false;
                }
            }
            return true;
        }

        private int GetIdEmpresaPriceRequest(string GUID)
        {
            int result = -1;
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetIdEmpresaPriceRequest")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 200
                };
                cmd.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);

                cmd.Connection = cn;
                cn.Open();
                
                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {                
                    while (r.Read())
                    {
                        result = int.Parse(r["IdEmpresa"].ToString());
                    }                
                }
                return result;
            }
        }

        public List<Imagen> GetFotosRequest(string GUID)
        {
            List<Imagen> imagenes = new List<Imagen>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetFotosPriceRequest", cn)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 240
                };
                cmd.Parameters.Add("@GUID", SqlDbType.UniqueIdentifier).Value = new Guid(GUID);
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        Imagen img = new Imagen
                        {
                            nombrePuntoDeVenta = r["nombrePuntoDeVenta"].ToString(),
                            id = int.Parse(r["IdPuntoDeVentaFoto"].ToString()),
                            idPuntoDeVenta = int.Parse(r["idPuntoDeVenta"].ToString()),
                            comentarios = r["comentarios"].ToString(),
                            fechaCreacion = r["fechaCreacion"].ToString()
                        };
                        imagenes.Add(img);
                    }
                }
            }
            return imagenes;
        }


        //tenes ganas de refactorizar?.. refactorizame esta....
        private void AddProductToExcel(ISheet sheet, PriceRequestModel pr, Int32 iNextRow)
        {
            Int32 lastRowNum = sheet.LastRowNum - 1;
            Int32 rowStep = 1;

            int actualRowNum;

            IRow FirstShiftRow = sheet.GetRow(iNextRow);
            IRow newProductRow;
            
            if (FirstShiftRow != null)
            {
                sheet.ShiftRows(iNextRow, lastRowNum, rowStep, false, false);
                newProductRow = sheet.GetRow(iNextRow + 1);
                actualRowNum = iNextRow + 2;
            }
            else
            {
                newProductRow = sheet.CreateRow(iNextRow);
                actualRowNum = iNextRow + 1;
            }

            ICell cellProduct = newProductRow.GetCell(0);
            if (cellProduct == null) cellProduct = newProductRow.CreateCell(0);
            cellProduct.SetCellValue(pr.Product.Name);

            ICell cellRetail = newProductRow.GetCell(1);
            if (cellRetail == null) cellRetail = newProductRow.CreateCell(1);
            cellRetail.SetCellValue(pr.Account);

            ICell cellUBP = newProductRow.GetCell(2);
            if (cellUBP == null) cellUBP = newProductRow.CreateCell(2);
            cellUBP.SetCellValue(double.Parse(pr.Product.UBP.ToString()));
            cellUBP.SetCellType(CellType.Numeric);

            ICell cellSellOut = newProductRow.GetCell(3);
            if (cellSellOut == null) cellSellOut = newProductRow.CreateCell(3);
            cellSellOut.SetCellValue(pr.Product.Inventory);
            cellSellOut.SetCellType(CellType.Numeric);

            ICell cellNetASP = newProductRow.GetCell(4);
            if (cellNetASP == null) cellNetASP = newProductRow.CreateCell(4);
            cellNetASP.SetCellValue(double.Parse(pr.NetAsp.ToString()));

            /* COMPETITOR */
            ICell cellCompetitor = newProductRow.GetCell(6);
            if (cellCompetitor == null) cellCompetitor = newProductRow.CreateCell(6);
            cellCompetitor.SetCellValue(pr.Competitor.Name);

            ICell cellUBPCompetitor = newProductRow.GetCell(7);
            if (cellUBPCompetitor == null) cellUBPCompetitor = newProductRow.CreateCell(7);
            cellUBPCompetitor.SetCellValue(double.Parse(pr.Competitor.Price.ToString()));

            ICell cellGAP = newProductRow.GetCell(8);
            if (cellGAP == null) cellGAP = newProductRow.CreateCell(8);
            cellGAP.SetCellValue(double.Parse(pr.Competitor.PriceGap.ToString()));

            /* PROPOSAL */
            ICell cellUBPProp = newProductRow.GetCell(10);
            if (cellUBPProp == null) cellUBPProp = newProductRow.CreateCell(10);
            cellUBPProp.SetCellValue(double.Parse(pr.Product.UBPProposal.ToString()));

            ICell cellGAPProp = newProductRow.GetCell(11);
            if (cellGAPProp == null) cellGAPProp = newProductRow.CreateCell(11);
            cellGAPProp.SetCellValue(double.Parse(pr.PriceGap.ToString()));

            ICell cellNetASPProp = newProductRow.GetCell(13);
            if (cellNetASPProp == null) cellNetASPProp = newProductRow.CreateCell(13);
            cellNetASPProp.SetCellValue(double.Parse(pr.NetAspCondition.ToString()));

            string rebateFormula = "E" + actualRowNum.ToString().Trim() + "-N" + actualRowNum.ToString().Trim();
            string rebateAmountFormula = "M" + actualRowNum.ToString().Trim() + "*O" + actualRowNum.ToString().Trim() ;

            ICell cellRebateUnit = newProductRow.GetCell(14);
            if (cellRebateUnit == null) cellRebateUnit = newProductRow.CreateCell(14);
            cellRebateUnit.SetCellFormula(rebateFormula);

            ICell cellRebateAmount = newProductRow.GetCell(15);
            if (cellRebateAmount == null) cellRebateAmount = newProductRow.CreateCell(15);
            cellRebateAmount.SetCellFormula(rebateAmountFormula);
        }

        private void TotalizePriceRequest(ISheet sheet, Int32 finalRow) {
            Int32 lastRowNum = sheet.LastRowNum - 1;
            Int32 rowStep = 1;
            Int32 firstRow = 8;

            IRow FirstShiftRow = sheet.GetRow(finalRow);
            IRow newFinalRow;

            if (FirstShiftRow != null)
            {
                sheet.ShiftRows(finalRow, lastRowNum, rowStep, false, false);
                newFinalRow = sheet.GetRow(finalRow + 1);
            }
            else
            {
                newFinalRow = sheet.CreateRow(finalRow);
            }

            CellRangeAddress cellProductRange = new CellRangeAddress(firstRow - 1, finalRow, 0, 0);
            sheet.AddMergedRegion(cellProductRange);

            ICell cellTotalCurrent = newFinalRow.GetCell(1);
            if (cellTotalCurrent == null) cellTotalCurrent = newFinalRow.CreateCell(1);
            cellTotalCurrent.SetCellValue("Total");
            cellTotalCurrent.SetCellType(CellType.String);

            CellRangeAddress cellCurrentRange = new CellRangeAddress(finalRow, finalRow, 1, 2);
            sheet.AddMergedRegion(cellCurrentRange);

            /*FORMULA*/
            //SUM(D12:D13)
            string strFmTotalSellOut = "SUM(D"+firstRow.ToString().Trim()+":D"+finalRow.ToString().Trim()+")";
            //SUMPRODUCT(D12:D13;E12:E13)/D14
            string strFmTotalCurrentAsp = "SUMPRODUCT(D" + firstRow.ToString().Trim() + ":D" + finalRow.ToString().Trim() +
                                          ",E" + firstRow.ToString().Trim() + ":E" + finalRow.ToString().Trim() + ")/D" + (finalRow + 1).ToString().Trim();
            //SUM(M12:M13)
            string strFmTotalProposalSellOut = "SUM(M" + firstRow.ToString().Trim() + ":M" + finalRow.ToString().Trim() + ")";
            //SUMPRODUCT(M12:M13;N12:N13)/M14
            string strFmTotalProposalASP = "SUMPRODUCT(M" + firstRow.ToString().Trim() + ":M" + finalRow.ToString().Trim() +
                                          ",N" + firstRow.ToString().Trim() + ":N" + finalRow.ToString().Trim() + ")/M" + (finalRow + 1).ToString().Trim();
            //SUMPRODUCT(N12:N13;O12:O13)/N14
            string strFmTotalProposalRB = "SUMPRODUCT(N" + firstRow.ToString().Trim() + ":N" + finalRow.ToString().Trim() +
                                          ",O" + firstRow.ToString().Trim() + ":O" + finalRow.ToString().Trim() + ")/N" + (finalRow + 1).ToString().Trim();
            //SUM(P12:P13)
            string strFmTotalRBAmount = "SUM(P" + firstRow.ToString().Trim() + ":P" + finalRow.ToString().Trim() + ")";


            /*********/
            ICell cellTotalSellOut = newFinalRow.GetCell(3);
            if (cellTotalSellOut == null) cellTotalSellOut = newFinalRow.CreateCell(3);
            cellTotalSellOut.SetCellFormula(strFmTotalSellOut);

            ICell cellTotalCurrentAsp = newFinalRow.GetCell(4);
            if (cellTotalCurrentAsp == null) cellTotalCurrentAsp = newFinalRow.CreateCell(4);
            cellTotalCurrentAsp.SetCellFormula(strFmTotalCurrentAsp);

            ICell cellProposalSellOut = newFinalRow.GetCell(12);
            if (cellProposalSellOut == null) cellProposalSellOut = newFinalRow.CreateCell(12);
            cellProposalSellOut.SetCellFormula(strFmTotalProposalSellOut);

            ICell cellProposalAsp = newFinalRow.GetCell(13);
            if (cellProposalAsp == null) cellProposalAsp = newFinalRow.CreateCell(13);
            cellProposalAsp.SetCellFormula(strFmTotalProposalASP);

            ICell cellProposalRebate = newFinalRow.GetCell(14);
            if (cellProposalRebate == null) cellProposalRebate = newFinalRow.CreateCell(14);
            cellProposalRebate.SetCellFormula(strFmTotalProposalRB);

            ICell cellProposalRebateAmount = newFinalRow.GetCell(15);
            if (cellProposalRebateAmount == null) cellProposalRebateAmount = newFinalRow.CreateCell(15);
            cellProposalRebateAmount.SetCellFormula(strFmTotalRBAmount);
        }

        private int EditExcelPriceRequest(ISheet sheet, string GUID)
        {
            List<PriceRequestModel> priceRequest = GetPriceRequest(GUID);
            PriceRequestSendDetailsModel headerData = GetSimpleDataFormRequest(GUID);
            /*EDITO HEADER*/
            IRow rowCountry = sheet.GetRow(1);
            IRow rowDate = sheet.GetRow(2);

            ICell cellCountry = rowCountry.GetCell(0);
            ICell cellDate = rowDate.GetCell(0);

            cellCountry.SetCellValue(string.Concat("Country: ", headerData.Country));
            cellDate.SetCellValue(string.Concat("Date: ", headerData.Date));

            Int32 iNextRow = 7;
            foreach (PriceRequestModel PRItem in priceRequest)
            {
                /*INSERTO PRODUCTO*/
                AddProductToExcel(sheet, PRItem, iNextRow);
                iNextRow++;
            }

            TotalizePriceRequest(sheet, iNextRow);

            return iNextRow;
        }

        private void ApplyFormat(IWorkbook excel, int lastRow) {

            Int32 iFirstRow = 7; //Esto es el indice, el numero de fila de excel lleva + 1
            XSSFCellStyle oddRowStyle = (XSSFCellStyle)excel.CreateCellStyle();
            XSSFCellStyle oddRowStyle_neg = (XSSFCellStyle)excel.CreateCellStyle();
            XSSFCellStyle evenRowStyle = (XSSFCellStyle)excel.CreateCellStyle();
            XSSFCellStyle evenRowStyle_neg = (XSSFCellStyle)excel.CreateCellStyle();
            XSSFCellStyle finalRow = (XSSFCellStyle)excel.CreateCellStyle();
            XSSFCellStyle ProductNameCell = (XSSFCellStyle)excel.CreateCellStyle();
            XSSFFont TotFont = (XSSFFont)excel.CreateFont();
            XSSFFont RedFont = (XSSFFont)excel.CreateFont();

            TotFont.IsBold = true;
            RedFont.Color = NPOI.HSSF.Util.HSSFColor.DarkRed.Index;

            oddRowStyle.SetFont(RedFont);           //Fila impar
            evenRowStyle.SetFont(RedFont);          //Fila par
            ProductNameCell.SetFont(RedFont);
            oddRowStyle_neg.SetFont(RedFont);       //Fila impar negativa
            evenRowStyle_neg.SetFont(RedFont);      //Fila par negativa

            finalRow.SetFont(TotFont);          //Totalizador

            oddRowStyle.SetFillForegroundColor(new XSSFColor(System.Drawing.ColorTranslator.FromHtml("#F2F2F2")));
            oddRowStyle.FillPattern = FillPattern.SolidForeground;
            evenRowStyle.SetFillForegroundColor(new XSSFColor(System.Drawing.ColorTranslator.FromHtml("#FFFFFF")));
            evenRowStyle.FillPattern = FillPattern.SolidForeground;
            oddRowStyle_neg.SetFillForegroundColor(new XSSFColor(System.Drawing.ColorTranslator.FromHtml("#F2F2F2")));
            oddRowStyle_neg.FillPattern = FillPattern.SolidForeground;
            evenRowStyle_neg.SetFillForegroundColor(new XSSFColor(System.Drawing.ColorTranslator.FromHtml("#FFFFFF")));
            evenRowStyle_neg.FillPattern = FillPattern.SolidForeground;
            finalRow.SetFillForegroundColor(new XSSFColor(System.Drawing.ColorTranslator.FromHtml("#FFF2CC")));
            finalRow.FillPattern = FillPattern.SolidForeground;
            ProductNameCell.SetFillForegroundColor(new XSSFColor(System.Drawing.ColorTranslator.FromHtml("#F2F2F2")));
            ProductNameCell.FillPattern = FillPattern.SolidForeground;

            ProductNameCell.Alignment = HorizontalAlignment.Center;
            ProductNameCell.VerticalAlignment = VerticalAlignment.Top;
            ProductNameCell.WrapText = true;
            ISheet sheet = excel.GetSheetAt(0);

            IRow firstRow = sheet.GetRow(iFirstRow);

            ICell ProductCell = firstRow.GetCell(0);
            if (ProductCell == null) ProductCell = firstRow.CreateCell(0);
            ProductCell.CellStyle = ProductNameCell;


            for (int i = iFirstRow; i < lastRow ; i++)
            {
                IRow actualRow = sheet.GetRow(i);

                ICell Channel = actualRow.GetCell(1);
                if (Channel == null) Channel = actualRow.CreateCell(1);
                ICell CurrentUBP = actualRow.GetCell(2);
                if (CurrentUBP == null) CurrentUBP = actualRow.CreateCell(2);
                ICell CurrentSellOut = actualRow.GetCell(3);
                if (CurrentSellOut == null) CurrentSellOut = actualRow.CreateCell(3);
                ICell CurrentNetAsp = actualRow.GetCell(4);
                if (CurrentNetAsp == null) CurrentNetAsp = actualRow.CreateCell(4);

                ICell CompetitorProduct = actualRow.GetCell(6);
                if (CompetitorProduct == null) CompetitorProduct = actualRow.CreateCell(6);
                ICell CompetitorUBP = actualRow.GetCell(7);
                if (CompetitorUBP == null) CompetitorUBP = actualRow.CreateCell(7);
                ICell PriceGap = actualRow.GetCell(8);
                if (PriceGap == null) PriceGap = actualRow.CreateCell(8);

                ICell ProposalUBP = actualRow.GetCell(10);
                if (ProposalUBP == null) ProposalUBP = actualRow.CreateCell(10);
                ICell ProposalGAP = actualRow.GetCell(11);
                if (ProposalGAP == null) ProposalGAP = actualRow.CreateCell(11);
                ICell ProposalSellOut = actualRow.GetCell(12);
                if (ProposalSellOut == null) ProposalSellOut = actualRow.CreateCell(12);
                ICell ProposalNetAsp = actualRow.GetCell(13);
                if (ProposalNetAsp == null) ProposalNetAsp = actualRow.CreateCell(13);
                ICell ProposalRebate = actualRow.GetCell(14);
                if (ProposalRebate == null)ProposalRebate = actualRow.CreateCell(14);
                ICell ProposalAmount = actualRow.GetCell(15);
                if (ProposalAmount == null) Channel = actualRow.CreateCell(15);                           

                    Channel.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    CurrentUBP.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    CurrentSellOut.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    CurrentNetAsp.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    CompetitorProduct.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    CompetitorUBP.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    PriceGap.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    ProposalUBP.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    ProposalGAP.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    ProposalSellOut.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    ProposalNetAsp.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    ProposalRebate.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);
                    ProposalAmount.CellStyle = (i % 2 == 0 ? oddRowStyle : evenRowStyle);

            }

            IRow totalRow = sheet.GetRow(lastRow);
            
            ICell TotalFinalCell = totalRow.GetCell(1);
            if (TotalFinalCell == null) TotalFinalCell = totalRow.CreateCell(1);
            TotalFinalCell.CellStyle = finalRow;

            ICell SellOutCell = totalRow.GetCell(3);
            if (SellOutCell == null) SellOutCell = totalRow.CreateCell(3);
            SellOutCell.CellStyle = finalRow;

            ICell NetAspCell = totalRow.GetCell(4);
            if (NetAspCell == null) NetAspCell = totalRow.CreateCell(4);
            NetAspCell.CellStyle = finalRow;

            ICell EmptyCell1 = totalRow.GetCell(10);
            if (EmptyCell1 == null) EmptyCell1 = totalRow.CreateCell(10);
            EmptyCell1.CellStyle = finalRow;

            ICell EmptyCell2 = totalRow.GetCell(11);
            if (EmptyCell2 == null) EmptyCell2 = totalRow.CreateCell(11);
            EmptyCell2.CellStyle = finalRow;

            ICell SellOutPropCell = totalRow.GetCell(12);
            if (SellOutPropCell == null) SellOutPropCell = totalRow.CreateCell(12);
            SellOutPropCell.CellStyle = finalRow;

            ICell NetAspPropCell = totalRow.GetCell(13);
            if (NetAspPropCell == null) NetAspPropCell = totalRow.CreateCell(13);
            NetAspPropCell.CellStyle = finalRow;

            ICell RebateCell = totalRow.GetCell(14);
            if (RebateCell == null) RebateCell = totalRow.CreateCell(14);
            RebateCell.CellStyle = finalRow;

            ICell RebateAmountCell = totalRow.GetCell(15);
            if (RebateAmountCell == null) RebateAmountCell = totalRow.CreateCell(15);
            RebateAmountCell.CellStyle = finalRow;

        }

        private bool GenerarExcelPriceRequest(string GUID, string pathexcel, string directoryname, int idEmpresa)
        {
            string pathExcelTemplate = _templateFile;
            IWorkbook hssfwb;

            using (FileStream fs = new FileStream(pathExcelTemplate, FileMode.Open, FileAccess.Read))
            {
                hssfwb = new XSSFWorkbook(fs);
                fs.Close();
            }
            ISheet sheet = hssfwb.GetSheetAt(0);
            int lastRow = EditExcelPriceRequest(sheet, GUID);

            ApplyFormat(hssfwb, lastRow);
            using (FileStream fs = new FileStream(Path.Combine(pathexcel, directoryname, "priceRequest.xlsx"), FileMode.Create, FileAccess.Write))
            {
                hssfwb.Write(fs);
                fs.Close();
            }
            return true;
        }

        private bool GenerarFotosPriceRequest(string GUID, string pathfoto, string directoryname, int idEmpresa)
        {
            List<Imagen> fotos = GetFotosRequest(GUID);

            if (!Directory.Exists(Path.Combine(pathfoto, directoryname, "Fotos")))
                Directory.CreateDirectory(Path.Combine(pathfoto, directoryname, "Fotos"));

            foreach (Imagen img in fotos)
            {
                try
                {
                    File.Copy(Path.Combine(_pathFoto, idEmpresa.ToString(), img.id.ToString() + ".jpg"), Path.Combine(pathfoto, directoryname, "Fotos", img.nombrePuntoDeVenta + '_' + img.idPuntoDeVenta.ToString() + ".jpg"));
                }
                catch (Exception e)
                {
                    logger.Error(e, "error en GenerarFotosPriceRequest : " + e.Message);
                }
            }
            return true;
        }


        public string GenerarTokenPriceRequest(string GUID)
        {
            int IdEmpresa = GetIdEmpresaPriceRequest(GUID);
            string _path = _directoryArchivos;
            string directoryname = string.Format("EPSONPR{0}{1}{2}{3}{4}{5}{6}", DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second, DateTime.Now.Millisecond);

            if (!Directory.Exists(Path.Combine(_path, directoryname)))
                Directory.CreateDirectory(Path.Combine(_path, directoryname));

            if (!GenerarFotosPriceRequest(GUID, _path, directoryname, IdEmpresa)) return string.Empty;
            if (!GenerarExcelPriceRequest(GUID, _path, directoryname, IdEmpresa)) return string.Empty;

            ZipOutputStream zip = new ZipOutputStream(File.Create(Path.Combine(_path, directoryname + ".zip")));
            CompressFolder(Path.Combine(_path, directoryname), zip, Path.Combine(_path, directoryname));
            zip.Finish();
            zip.Close();

            Directory.Delete(Path.Combine(_path, directoryname), true);
            return directoryname;
        }

        private void CompressFolder(string path, ZipOutputStream zipStream, string root)
        {
            string[] files = Directory.GetFiles(path);

            foreach (string filename in files)
            {

                FileInfo fi = new FileInfo(filename);

                string entryName = filename.Substring(root.Length + 1);

                ZipEntry newEntry = new ZipEntry(entryName);
                newEntry.DateTime = fi.LastWriteTime;

                newEntry.Size = fi.Length;

                zipStream.PutNextEntry(newEntry);

                byte[] buffer = new byte[4096];
                using (FileStream streamReader = File.OpenRead(filename))
                {
                    StreamUtils.Copy(streamReader, zipStream, buffer);
                }
                zipStream.CloseEntry();
            }

            string[] folders = Directory.GetDirectories(path);

            foreach (string folder in folders)
            {
                CompressFolder(folder, zipStream, root);
            }
        }
        public string GetCountryCodeByName(string Country)
        {
            return string.Empty;
        }
        #endregion
    }
}
