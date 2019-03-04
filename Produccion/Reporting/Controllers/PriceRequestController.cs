using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using Reporting.Filters;
using Reporting.ViewModels;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;
 
namespace Reporting.Controllers
{
    public class PriceRequestController : BaseController
    {
        private readonly int IdModulo;
        public PriceRequestController(ITableroRepository tableroRepository, IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository)
        {
            IdModulo = 9;
            this.tableroRepository = tableroRepository;
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.filtroRepository = filtroRepository;
            this.commonRepository = commonRepository;
        }

        [Autorizar(Permiso = "enviarBajaDePrecio")]
        public ActionResult Index()
        {
            //REHACER TODA ESTA MIERDA!!!             
            int clienteId = GetClienteSeleccionado();
            List<ProductGapDetailViewModel> _model = new List<ProductGapDetailViewModel>();
            GapModel gm = commonRepository.GetGap(clienteId);

            if(gm.Detail.Count == 0)
            {
                return View("_emptyPriceGap");
            }


            foreach (GapModelDetail det in gm.Detail)
            {
                if (_model.Any(p => p.ProductId == det.ProductId))
                {
                    var oldProd_ix = _model.FindIndex(p => p.ProductId == det.ProductId);
                    _model[oldProd_ix].Inventory += det.Inventory;
                    _model[oldProd_ix].SellIn += det.SellIn;

                   // EL valor mas NEGATIVO es el PEOR
                   if(_model[oldProd_ix].OrderMath > det.OrderMath) 
                    {
                        _model[oldProd_ix].PriceGap = det.PriceGap;
                        _model[oldProd_ix].Color = det.Color;
                    }

                    if (_model[oldProd_ix].Competitors.Any(c => c.ProductId == det.CompetitorId))
                    {
                        var oldComp_ix = _model[oldProd_ix].Competitors.FindIndex(c => c.ProductId == det.CompetitorId);

                        //Para mantener la integridad deberia comparar si existe la cuenta y lanzar un error
                        _model[oldProd_ix].Competitors[oldComp_ix].Accounts.Add(new CompetitorAccountViewModel()
                        {
                            Account = new AccountViewModel()
                            {
                                Id = det.AccountId,
                                Name = gm.Accounts.FirstOrDefault(a => a.Id == det.AccountId).Name,
                                Image = gm.Accounts.FirstOrDefault(a => a.Id == det.AccountId).Image
                            },
                            AccountGap = det.PriceGap,
                            Color = det.Color,
                            Inventory = det.Inventory,
                            SellIn = det.SellIn,
                            SelfPrice = det.SelfPrice,
                            CompetitorPrice = det.CompetitorPrice,
                            Request = det.Request,
                            SelfProductId = det.ProductId,
                            CompetitorProductId = det.CompetitorId
                        });
                    }
                    else//no existe el competidor
                    {
                        CompetitorAccountViewModel _newAccount = new CompetitorAccountViewModel()
                        {
                            Account = new AccountViewModel()
                            {
                                Id = det.AccountId,
                                Name = gm.Accounts.FirstOrDefault(a => a.Id == det.AccountId).Name,
                                Image = gm.Accounts.FirstOrDefault(a => a.Id == det.AccountId).Image
                            },
                            AccountGap = det.PriceGap,
                            Color = det.Color,
                            Inventory = det.Inventory,
                            SellIn = det.SellIn,
                            SelfPrice = det.SelfPrice,
                            CompetitorPrice = det.CompetitorPrice,
                            Request = det.Request,
                            SelfProductId = det.ProductId,
                            CompetitorProductId = det.CompetitorId
                        };

                        CompetitorGapViewModel _newCompetitor = new CompetitorGapViewModel()
                        {
                            ProductId = det.CompetitorId,
                            ProductName = gm.Products.FirstOrDefault(p => p.Id == det.CompetitorId).Name
                        };
                        _newCompetitor.Accounts.Add(_newAccount);

                        _model[oldProd_ix].Competitors.Add(_newCompetitor);
                    }
                    // deberian ir al final, una vez que se inserto el nuevo Item en competencia y account
                    _model[oldProd_ix].TotalCompetitors = _model[oldProd_ix].Competitors.Distinct().Count();
                    _model[oldProd_ix].TotalStores = _model[oldProd_ix].Competitors
                                                                          .SelectMany(c => c.Accounts
                                                                                             .Select(a => a.Account.Id))
                                                                                                    .Distinct()
                                                                                                    .Count();
                }
                else
                {
                    //Si no existe Creo el producto, con la competencia y la cadena
                    CompetitorAccountViewModel _newAccount = new CompetitorAccountViewModel()
                    {
                        Account = new AccountViewModel()
                        {
                            Id = det.AccountId,
                            Name = gm.Accounts.FirstOrDefault(a => a.Id == det.AccountId).Name,
                            Image = gm.Accounts.FirstOrDefault(a => a.Id == det.AccountId).Image
                        },
                        AccountGap = det.PriceGap,
                        Color = det.Color,
                        Inventory = det.Inventory,
                        SellIn = det.SellIn,
                        SelfPrice = det.SelfPrice,
                        CompetitorPrice = det.CompetitorPrice,
                        Request = det.Request,
                        SelfProductId = det.ProductId,
                        CompetitorProductId = det.CompetitorId
                    };

                    CompetitorGapViewModel _newCompetitor = new CompetitorGapViewModel()
                    {
                        ProductId = det.CompetitorId,
                        ProductName = gm.Products.FirstOrDefault(p => p.Id == det.CompetitorId).Name
                    };
                    _newCompetitor.Accounts.Add(_newAccount);

                    ProductGapDetailViewModel _newGapDet = new ProductGapDetailViewModel()
                    {
                        ProductId = det.ProductId,
                        ProductName = gm.Products.FirstOrDefault(p => p.Id == det.ProductId).Name,
                        Image = gm.Products.FirstOrDefault(p => p.Id == det.ProductId).Image,
                        Inventory = det.Inventory,
                        SellIn = det.SellIn,
                        
                        PriceGap = det.PriceGap,
                        Color = det.Color,                       
                        TotalCompetitors = 1,
                        TotalStores = 1,
                        OrderMath = det.OrderMath
                    };
                    _newGapDet.Competitors.Add(_newCompetitor);

                    _model.Add(_newGapDet);
                }
            }
            return View(_model);
        }

        [HttpPost]
        public ActionResult CreateRequestForm(ProductGapDetailViewModel model)
        {

            List<CompetitorGapViewModel> CompetitorAccounts = model.Competitors.Where(c => c.Accounts.Any(a => a.Request)).ToList();

            int productID = model.ProductId;
            //Diccionario donde la clave es el competidor y el string son las cuentas separadas por punto y coma
            Dictionary<int, string> selectedCompetitors = CompetitorAccounts
                                                        .Select(c => new
                                                        {
                                                            c.ProductId,
                                                            accounts = c.Accounts
                                                                        .Where(a => a.Request)
                                                                        .Select(a => a.Account.Id.ToString())
                                                                        .Aggregate((cur, acc) => cur + ";" + acc)
                                                        })
                                                        .ToDictionary(c => c.ProductId, c => c.accounts);

            List<PriceRequestViewModel> ListPR = commonRepository.GetPriceRequest(GetClienteSeleccionado(), productID, selectedCompetitors)
                                      .Select(p => new PriceRequestViewModel()
                                      {
                                          Account = p.Account,
                                          AccountId = p.AccountId,
                                          Competitor = new ProductPR(p.Competitor),
                                          Product = new ProductPR(p.Product),
                                          IdealGap = p.IdealGap,
                                          NetAsp = 0,
                                          NetAspCondition = 0,
                                          PriceGap = p.PriceGap
                                      }).ToList();
            PriceRequestFormViewModel modelOut = new PriceRequestFormViewModel()
            {
                Editable = true,
                GUID = "",
                PriceRequests = ListPR,
                WaitAprrobe = false
            };

            return View("PriceRequestForm", modelOut);
        }

        [HttpPost]
        public ActionResult GetAccountPhoto(int idAccount)
        {
            string base64Image = commonRepository.getAccountPhoto(idAccount);
            return PartialView("_AccountImage", base64Image);
        }

        [HttpPost]
        public ActionResult FormAction(PriceRequestFormViewModel model)
        {
            int idUser = GetUsuarioLogueado();
            idUser = usuarioRepository.GetUsuarioPerformance(idUser);

            //SEND PRICE REQUEST 
            List<NewPriceRequestForm> FormPRList = model.PriceRequests.Select(p => new NewPriceRequestForm()
            {
                AccountId = p.AccountId,
                CompetitorId = p.Competitor.Id,
                CompInventory = p.Competitor.Inventory,
                CompPhoto = p.Competitor.Photo,
                CompPrice = p.Competitor.Price,
                EOLComp = p.Competitor.EOL,
                ProductId = p.Product.Id,
                SelfInventory = p.Product.Inventory,
                SelfPhoto = p.Product.Photo,
                SelfPrice = p.Product.Price,
                IdealGap = p.IdealGap,
                UBP = p.Product.Price,
                UBPProposal = p.Product.UBPProposal,
                PriceGap = (((p.Product.UBPProposal / p.Competitor.Price) * 100M) - 100M),
                NetAsp = p.NetAsp,
                NetAspCondition = p.NetAspCondition,
                EOLSelf = p.Product.EOL,
                ASPVariancePercent = p.AspVariancePercent,
                ASPVariancePrice = p.AspVariancePrice,
                CompSellIn = p.Competitor.SellIn,
                CompSellOut = p.Competitor.SellOut,
                SelfSellIn = p.Product.SellIn,
                SelfSellOut = p.Product.SellOut
            }).ToList();

            string nGUID = commonRepository.SendNewPriceRequest(FormPRList, GetClienteSeleccionado(), idUser);

            if (nGUID != string.Empty)
                UpdatePriceRequestStatus(nGUID, 1, Resources.PriceRequest.InitialStatus);

            return PriceRequestFormSended(nGUID);
        }

        [HttpGet]
        public ActionResult PriceRequestFormSended(string reqGUID)
        {
            PriceRequestSendDetailsModel dataModel = commonRepository.GetSimpleDataFormRequest(reqGUID);
            PriceRequestSendDetails data = new PriceRequestSendDetails()
            {
                Id = dataModel.Id,
                GUID = dataModel.GUID,
                Country = dataModel.Country,
                Date = dataModel.Date,
                User = dataModel.User
            };

            return View("PriceRequestFormSended", data);
        }

        [Autorizar(Permiso = "adminBajaDePrecio")]
        public ActionResult Admin()
        {
            int clientId = GetClienteSeleccionado();
            int idUser = usuarioRepository.GetUsuarioPerformance(GetUsuarioLogueado());

            bool UserPm = usuarioRepository.IsAuthorized(clientId, idUser, "enviarBajaDePrecio");
            PriceRequestPolicies model = new PriceRequestPolicies()
            {
                IsAdmin = true,
                IsPm = UserPm,
                IsMultiClient = (clientId == 194) //LA PU TA MA DRE
            };
            return View("Admin", model);
        }

        [Autorizar(Permiso = "verBajaDePrecio")]
        public ActionResult AdminSelf()
        {
            PriceRequestPolicies model = new PriceRequestPolicies()
            {
                IsAdmin = false,
                IsPm = true,
                IsMultiClient = false   //SIEMPRE DEBERIA SER FALSE, EL MULTICLIENTE NO DEBERIA PODER CARGAR P.R.
            };
            return View("Admin", model);
        }

        //[HttpGet]
        public ActionResult Admintable(bool UserAdmin = true, bool UserPm = false, string Search = "")
        {
            int clientId = GetClienteSeleccionado();
            int idUser = GetUsuarioLogueado();
            idUser = usuarioRepository.GetUsuarioPerformance(idUser);

            List<RequestDownPriceItemModel> preModel;

            if (UserAdmin)
            {
                preModel = commonRepository.GetClientPriceRequestList(clientId);
            }
            else
            {
                preModel = commonRepository.GetUserPriceRequestList(clientId, idUser);
            }

            if (Search != "")
            {
                Search = Search.Trim(); //Primero limpio los espacios
                List<RequestDownPriceItemModel> pmFiltered = new List<RequestDownPriceItemModel>();
                pmFiltered.AddRange(preModel.Where(p => p.Country.Contains(Search) ||
                                                        p.Date.Contains(Search) ||
                                                        p.GUID.Contains(Search) ||
                                                        p.ProductName.Contains(Search) ||
                                                        p.AccountList.Any(a => a.Contains(Search)) ||
                                                        p.CountryCode.Contains(Search) ||
                                                        p.UserName.Contains(Search)
                                                        ));
                preModel = pmFiltered;
            }

            List<RequestDownPriceItem> model = preModel
                                                .Select(c => new RequestDownPriceItem()
                                                {
                                                    Country = c.Country,
                                                    Date = c.Date,
                                                    DateNextAlert = c.DateNextAlert,
                                                    GUID = c.GUID,
                                                    ProductName = c.ProductName,
                                                    AccountList = c.AccountList,
                                                    CountryCode = c.CountryCode,
                                                    Status = new PriceRequestStatus()
                                                    {
                                                        Id = c.Status.Id,
                                                        Description = c.Status.Description
                                                    },
                                                    UserName = c.UserName
                                                }).ToList();
            if (clientId != 194)
            {
                //HARCODEOO!!!!! si es latinoamerica la vista deberia estar agrupada por pais, sino muestro lista
                return PartialView("_PriceRequestTable", new RequestDownPriceTable()
                {
                    ListItem = model,
                    IsAdmin = UserAdmin,
                    IsPm = UserPm
                });
            }
            else
            {
                RequestDownPriceTableRegion totalRegionModel = new RequestDownPriceTableRegion
                {
                    Countries = model
                                .Select(m => new RequestTableByCountry()
                                {
                                    CountryCode = m.CountryCode,
                                    Country = m.Country,
                                    RequestTable = new RequestDownPriceTable()
                                    {
                                        ListItem = model.Where(t => t.Country == m.Country).ToList(),
                                        IsAdmin = UserAdmin,
                                        IsPm = UserPm
                                    }
                                })
                                .Distinct(new RequestTableByCountryComp())
                                .ToList()//LA PUTA MADRE;
                };
                return PartialView("_PriceRequestTableRegion", totalRegionModel);
            }
        }

        [HttpPost]
        public ActionResult GetPhotosRequestForm(int ProductID, string Price, int IdCadena, bool Editable)
        {
            List<PhotoProductModel> listPhotoRepo = commonRepository.GetPhotosProduct(ProductID, Price, IdCadena);

            var ListPhotoVM = listPhotoRepo.Select(l => new PhotoProductViewModel()
            {
                IdEmpresa = l.IdEmpresa,
                IdImagen = l.IdImagen,
                Direccion = l.Direccion,
                Base64 = l.Base64,
                IdProducto = l.IdProducto,
                IdPuntoDeVenta = l.IdPuntoDeVenta,
                IdReporte = l.IdReporte,
                IdUsuario = l.IdUsuario,
                Fecha = l.Fecha,
                PuntoDeVenta = l.PuntoDeVenta,
                Usuario = l.Usuario,
                IdCadena = IdCadena,
                FotoTag = l.FotoTag
            }).ToList();

            PhotoProductGroupVM model = new PhotoProductGroupVM()
            {
                ListPhoto = ListPhotoVM,
                IsEditable = Editable,
                AccountId = IdCadena,
                ProductId = ProductID
            };
            return PartialView("_PhotoProductList", model);
        }

        [HttpPost]
        public JsonResult ApprobePriceRequest(string GUID)
        {
            string message = Reporting.Resources.PriceRequest.RequestApproved;
            bool Estado = UpdatePriceRequestStatus(GUID, 2, message);
            return Json(Estado, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult RejectPriceRequest(string GUID, string message = "")
        {
            if (message == string.Empty) { message = Resources.PriceRequest.RequestRejected; }
            bool Estado = UpdatePriceRequestStatus(GUID, -2, message);
            return Json(Estado, JsonRequestBehavior.AllowGet);
        }

        private bool UpdatePriceRequestStatus(string GUID, int newStatus, string message = "")
        {
            int idUser = GetUsuarioLogueado();
            idUser = usuarioRepository.GetUsuarioPerformance(idUser);

            if (commonRepository.UpdatePriceRequestStatus(idUser, newStatus, GUID, message))
            {
                return SendMailWithUpdateStatus(GUID, newStatus, message, idUser);
            }
            return false;
        }

        private bool SendMailWithUpdateStatus(string GUID, int newStatus, string message, int idUsuario)
        {
            return commonRepository.SendStatusMail(GUID, newStatus, message, idUsuario);
        }

        //[Autorizar(Permiso ="enviarBajaDePrecio")]
        public ActionResult EditRequestForm(string GUID, bool Editable, bool WaitApprobal = false)
        {
            //PERO LA PUTA MADRE REPETI EL CODIGO (LINEA 178 - Florencio Varela - Pompeya)
            List<PriceRequestViewModel> model = commonRepository.GetPriceRequest(GUID)
                                                .Select(c => new PriceRequestViewModel()
                                                {
                                                    Account = c.Account,
                                                    AccountId = c.AccountId,
                                                    IdealGap = c.IdealGap,
                                                    NetAsp = c.NetAsp,
                                                    NetAspCondition = c.NetAspCondition,
                                                    PriceGap = c.PriceGap,
                                                    Product = new ProductPR(c.Product),
                                                    Competitor = new ProductPR(c.Competitor)
                                                }).ToList();

            PriceRequestFormViewModel newModel = new PriceRequestFormViewModel()
            {
                PriceRequests = model,
                Editable = Editable,
                GUID = GUID,
                WaitAprrobe = WaitApprobal
            };

            return View("PriceRequestForm", newModel);
        }

        [HttpPost]
        public ActionResult GetPrHistory(string GUID)
        {
            List<PriceRequestHistory> model = commonRepository.getHistoryPriceRequest(GUID)
                                        .Select(h => new PriceRequestHistory()
                                        {
                                            GUID = h.GUID,
                                            Commentary = h.Commentary,
                                            User = h.User,
                                            Date = h.Date,
                                            State = new PriceRequestStatus()
                                            {
                                                Id = h.State.Id,
                                                Description = h.State.Description
                                            }
                                        }).ToList();

            return PartialView("_PriceRequestHistory", model);
        }

        [HttpPost]
        public JsonResult DeletePR(string GUID)
        {
            bool Estado = commonRepository.DeletePriceRequest(GUID);
            return Json(Estado, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult AprobeAndClosePR(string GUID)
        {
            bool Estado = UpdatePriceRequestStatus(GUID, 4, Resources.PriceRequest.PriceRequestClosed);
            return Json(Estado, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult RejectAndClosePR(string GUID, string message = "")
        {
            if (message == string.Empty) { message = Resources.PriceRequest.RequestRejected; }
            bool Estado = UpdatePriceRequestStatus(GUID, -4, message);
            return Json(Estado, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public string GetTokenPriceRequest(string GUID)
        {
            string _token = commonRepository.GenerarTokenPriceRequest(GUID);
            if (string.IsNullOrEmpty(_token))
                return null;
            else
            {
                if (!UpdatePriceRequestStatus(GUID, 3))
                {
                    return string.Empty;
                }
                return _token;
            }
        }

        public void DownloadFileByToken(string token)
        {
            string _directoryArchivos = @"C:\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Reporting\Content\downloadPriceRequest\";

            string _path = System.IO.Path.Combine(_directoryArchivos, token + ".zip");
            string strFileName = System.IO.Path.GetFileName(_path);

            if (!System.IO.File.Exists(_path))
            {
                Response.Close();
                return;
            }

            System.IO.Stream oStream = null;

            try
            {
                oStream = new System.IO.FileStream
                        (path: _path,
                        mode: System.IO.FileMode.Open,
                        share: System.IO.FileShare.Read,
                        access: System.IO.FileAccess.Read);

                Response.Buffer = false;

                Response.ContentType = "application/octet-stream";

                Response.AddHeader("Content-Disposition", "attachment; filename=" + strFileName);

                long lngFileLength = oStream.Length;

                Response.AddHeader("Content-Length", lngFileLength.ToString());

                long lngDataToRead = lngFileLength;

                while (lngDataToRead > 0)
                {
                    if (Response.IsClientConnected)
                    {
                        int intBufferSize = 8 * 1024;

                        byte[] bytBuffers =
                            new System.Byte[intBufferSize];

                        int intTheBytesThatReallyHasBeenReadFromTheStream =
                            oStream.Read(buffer: bytBuffers, offset: 0, count: intBufferSize);

                        Response.OutputStream.Write
                            (buffer: bytBuffers, offset: 0,
                            count: intTheBytesThatReallyHasBeenReadFromTheStream);

                        Response.Flush();

                        lngDataToRead =
                            lngDataToRead - intTheBytesThatReallyHasBeenReadFromTheStream;
                    }
                    else
                    {
                        lngDataToRead = -1;
                    }
                }
            }
            finally
            {
                if (oStream != null)
                {
                    oStream.Close();
                    oStream.Dispose();
                    oStream = null;
                }
                Response.Close();
                imagenesRepository.EliminarZip(strFileName);
            }
        }

    }
}