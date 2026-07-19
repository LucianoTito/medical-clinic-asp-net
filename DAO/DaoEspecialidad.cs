using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dao;

namespace DAO
{
    public class DaoEspecialidad
    {
        private AccesoDatos ds = new AccesoDatos();

        public DataTable ObtenerEspecialidades()
        {

            DataTable tabla = ds.ObtenerTablaConSP("SP_ListarEspecialidades");

            return tabla;
        }

    }
}
