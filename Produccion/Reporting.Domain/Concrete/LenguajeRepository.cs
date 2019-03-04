using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reporting.Domain.Abstract;
using System.Data.SqlClient;
using System.Data;

namespace Reporting.Domain.Concrete
{
    public class LenguajeRepository:ILenguajeRepository
    {
        public List<KeyValuePair<string, string>> GetDiccionario(string idioma, string view)
        {
            List<KeyValuePair<string, string>> diccionario = new List<KeyValuePair<string, string>>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetValoresDiccionario", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Idioma", SqlDbType.VarChar).Value = idioma;
                cmd.Parameters.Add("@View", SqlDbType.VarChar).Value = view;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        diccionario.Add(new KeyValuePair<string, string>(r["keyValue"].ToString(), r["texto"].ToString()));
                    }
                }
            }

            return diccionario;
        }
    }
}
