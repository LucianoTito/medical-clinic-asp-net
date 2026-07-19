using DAO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class NegocioInformes
    {
        private DaoInformes dao = new DaoInformes();

        public DataTable GenerarReporteAsistencias(string fechaDesdeStr, string fechaHastaStr, string idEspecialidadStr)
        {
         
            if (!int.TryParse(idEspecialidadStr, out int idEspecialidad))
                idEspecialidad = 0;

            // Si el campo viene vacío o inválido, lo dejamos en null.
            DateTime? fechaDesde = null;
            DateTime? fechaHasta = null;

            if (DateTime.TryParse(fechaDesdeStr, out DateTime fd))
                fechaDesde = fd;

            if (DateTime.TryParse(fechaHastaStr, out DateTime fh))
                fechaHasta = fh;

            return dao.ObtenerReporteAsistencias(fechaDesde, fechaHasta, idEspecialidad);
        }

        public DataTable ListarEspecialidades()
        {
            return dao.ListarEspecialidades();
        }

        public DataTable GenerarReportePacientes (string fechaDesdeStr, string fechaHastaStr)
        {
            DateTime? fechaDesde = null;
            DateTime? fechaHasta = null;

            if (DateTime.TryParse(fechaDesdeStr, out DateTime fd))
                fechaDesde = fd;

            if (DateTime.TryParse(fechaHastaStr, out DateTime fh))
                fechaHasta = fh;

            return dao.ObtenerPacientesPorAsistencia(fechaDesde, fechaHasta);
        }

        public DataTable GenerarReporteEspecialidades()
        {
            return dao.ObtenerEspecialidadesMasSolicitadas();
        }
    }
}


