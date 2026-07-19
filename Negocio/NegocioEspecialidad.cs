using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAO;

namespace Negocio
{
    public class NegocioEspecialidad
    {
        private DaoEspecialidad dao = new DaoEspecialidad();
        public DataTable GetEspecialidades()
        {
            return dao.ObtenerEspecialidades();
        }

    }
}
