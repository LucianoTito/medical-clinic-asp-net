using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAO
{
    public class DaoUbicacion
    {
        private AccesoDatos ds = new AccesoDatos();

        public DataTable ListarProvincias()
        {
            return ds.ObtenerTablaConSP("SP_ListarProvincias");
        }

        public DataTable ListarLocalidadesPorProvincia(int idProvincia)
        {
            SqlParameter parametro = new SqlParameter("@Id_Provincia", idProvincia);
            return ds.ObtenerTablaConSP_Parametro("SP_ListarLocalidadesPorProvincia", parametro);
        }
    }
}
