using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dao;
using DAO;
using Entidades;

namespace Negocio
{
    public class NegocioTurnos
    {
        private DaoTurnos tDao = new DaoTurnos();

        public DataTable ListarTurnosMedico(string legajoMedico)
        {
            return tDao.ObtenerTurnosMedico(legajoMedico);
        }

        public bool ModificarTurnoEnBase(int idTurno, string dniPaciente)
        {
            return tDao.ReservarTurnoEnBD(idTurno, dniPaciente);
        }

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

        public bool InsertarNuevoTurno(string legajo, string dni, string fecha, string hora)
        {
            EntidadTurno nuevoTurno = new EntidadTurno();

            nuevoTurno.LegMedico = legajo.Trim();
            nuevoTurno.DniPaciente = dni.Trim();
            nuevoTurno.FechaTur = DateTime.ParseExact(fecha, "dd/MM/yyyy", null);
            nuevoTurno.HoraTur = TimeSpan.Parse(hora);

            return tDao.InsertarTurno(nuevoTurno);
        }

        public DataTable ListarTurnosFiltrados(string legajo, string busqueda, string fechaDesde, string fechaHasta)
        {
            return tDao.FiltrarTurnos(legajo, busqueda, fechaDesde, fechaHasta);
        }

        public bool ActualizarTurnoNeg(int id, string asist, string obs)
        {
            return tDao.ActualizarTurno(id, asist, obs);
        }

        public DataTable ListarHostorialTurnosPaciente(string dni)
        {
            return tDao.HistorialTurnosPaciente(dni);
        }


    }
}
