using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAO;
using Entidades;

namespace Negocio
{
    public class NegocioTurnos
    {
        private DaoTurnos tDao = new DaoTurnos();

        public bool CancelarTurno(int idTurno)
        {
            return tDao.CancelarTurnoEnBD(idTurno);
        }

        public DataTable ListarTurnosPaciente(string dni)
        {
            return tDao.ObtenerTurnosPorDni(dni);
        }

        // La agenda (30 dias, franjas del medico y estado ocupado/libre)
        // se genera completa en la base con SP_ObtenerAgendaCompleta.
        public DataTable ObtenerAgendaCompleta(string legajo)
        {
            return tDao.TraerAgendaCompleta(legajo);
        }

        // Devuelve false si la fecha u hora no tienen un formato válido,
        // sin lanzar excepción: la página muestra su mensaje de error normal.
        public bool InsertarNuevoTurno(string legajo, string dni, string fecha, string hora)
        {
            if (!DateTime.TryParseExact(fecha, "dd/MM/yyyy", CultureInfo.InvariantCulture,
                    DateTimeStyles.None, out DateTime fechaTurno))
                return false;

            if (!TimeSpan.TryParse(hora, out TimeSpan horaTurno))
                return false;

            EntidadTurno nuevoTurno = new EntidadTurno();

            nuevoTurno.LegMedico = legajo.Trim();
            nuevoTurno.DniPaciente = dni.Trim();
            nuevoTurno.FechaTur = fechaTurno;
            nuevoTurno.HoraTur = horaTurno;

            return tDao.InsertarTurno(nuevoTurno);
        }

        // Traducción de tipos (string -> DateTime?) en la capa de negocio,
        // igual que en NegocioInformes: campo vacío o inválido queda en null
        // y el filtro se ignora en el SP.
        public DataTable ListarTurnosFiltrados(string legajo, string busqueda, string fechaDesdeStr, string fechaHastaStr)
        {
            DateTime? fechaDesde = null;
            DateTime? fechaHasta = null;

            if (DateTime.TryParse(fechaDesdeStr, out DateTime fd))
                fechaDesde = fd;

            if (DateTime.TryParse(fechaHastaStr, out DateTime fh))
                fechaHasta = fh;

            return tDao.FiltrarTurnos(legajo, busqueda, fechaDesde, fechaHasta);
        }

        public bool ActualizarTurnoNeg(int id, string asist, string obs)
        {
            return tDao.ActualizarTurno(id, asist, obs);
        }

        public DataTable ListarHistorialTurnosPaciente(string dni)
        {
            return tDao.HistorialTurnosPaciente(dni);
        }

    }
}