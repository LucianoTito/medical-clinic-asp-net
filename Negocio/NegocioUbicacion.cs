using DAO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class NegocioUbicacion
    {
        private DaoUbicacion udao = new DaoUbicacion();

        public DataTable ListarProvincias()
        {
            return udao.ListarProvincias();
        }

        public DataTable ListarLocalidadesPorProvincia(int idProvincia)
        {
            return udao.ListarLocalidadesPorProvincia(idProvincia);
        }
    }
}
