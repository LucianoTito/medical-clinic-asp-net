using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using Entidades;

namespace DAO
{
    public class DaoTurnos
    {
        private AccesoDatos ds = new AccesoDatos();

        public bool CancelarTurnoEnBD(int idTurno)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Id_Turno", idTurno);

            int filasAfectadas = ds.EjecutarProcedimientoAlmacenado(cmd, "SP_CancelarTurno");
            return filasAfectadas > 0;
        }

        public DataTable ObtenerTurnosPorDni(string dni)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Dni_Paciente", dni);

            return ds.ObtenerTablaConSP(cmd, "SP_ObtenerTurnosPorDni");
        }

        // Agenda completa de 30 dias generada por la base:
        // dias/franjas del medico + estado ocupado/libre de cada franja.
        public DataTable TraerAgendaCompleta(string legajo)
        {
            SqlParameter param = new SqlParameter("@Leg_Medico", legajo);
            return ds.ObtenerTablaConSP_Parametro("SP_ObtenerAgendaCompleta", param);
        }

        public bool InsertarTurno(EntidadTurno turno)
        {
            SqlCommand cmd = new SqlCommand();

            cmd.Parameters.AddWithValue("@Leg_Medico", turno.LegMedico.Trim());
            cmd.Parameters.AddWithValue("@Dni_Paciente", turno.DniPaciente.Trim());
            cmd.Parameters.AddWithValue("@Fecha_Tur", turno.FechaTur);
            cmd.Parameters.AddWithValue("@Hora_Tur", turno.HoraTur);

            int filas = ds.EjecutarProcedimientoAlmacenado(cmd, "SP_ReservarTurno");

            return filas > 0;
        }

        // Filtros opcionales: las fechas viajan como DBNull cuando vienen en null
        // y el SP las ignora con la condición (@Param IS NULL OR ...),
        // igual que en DaoInformes. La traducción string -> DateTime? la hace Negocio.
        public DataTable FiltrarTurnos(string legajo, string busqueda, DateTime? fechaDesde, DateTime? fechaHasta)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@LegajoMedico", legajo);

            cmd.Parameters.AddWithValue("@BusquedaPaciente", string.IsNullOrEmpty(busqueda) ? (object)DBNull.Value : busqueda);

            SqlParameter pDesde = new SqlParameter("@FechaDesde", SqlDbType.Date);
            if (fechaDesde != null)
                pDesde.Value = fechaDesde;
            else
                pDesde.Value = DBNull.Value;
            cmd.Parameters.Add(pDesde);

            SqlParameter pHasta = new SqlParameter("@FechaHasta", SqlDbType.Date);
            if (fechaHasta != null)
                pHasta.Value = fechaHasta;
            else
                pHasta.Value = DBNull.Value;
            cmd.Parameters.Add(pHasta);

            return ds.ObtenerTablaConSP(cmd, "SP_ObtenerTurnosPorMedico");
        }

        public bool ActualizarTurno(int idTurno, string asistencia, string observaciones)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Id_Turno", idTurno);
            cmd.Parameters.AddWithValue("@Asistencia", asistencia);
            cmd.Parameters.AddWithValue("@Observaciones", observaciones);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_ModificarTurno") > 0;
        }

        public DataTable HistorialTurnosPaciente(string dniPaciente)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Dni_Paciente", dniPaciente);

            return ds.ObtenerTablaConSP(cmd, "SP_ObtenerHistorialTurnosPorDni");

        }

    }
}