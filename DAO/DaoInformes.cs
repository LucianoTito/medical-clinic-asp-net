using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Dao;


namespace DAO
{
    public class DaoInformes
    {

        private AccesoDatos ds = new AccesoDatos();


        public DataTable ObtenerReporteAsistencias(DateTime? fechaDesde, DateTime? fechaHasta, int idEspecialidad)
        {
            SqlCommand cmd = new SqlCommand();

            // --- Fecha Desde ---
            // Si la fecha vino cargada se envía su valor; si no, se envía DBNull
            // para que el SP la ignore con la condición (@FechaDesde IS NULL OR ...).
            SqlParameter pDesde = new SqlParameter("@FechaDesde", System.Data.SqlDbType.Date);
            if (fechaDesde != null)
                pDesde.Value = fechaDesde;
            else
                pDesde.Value = DBNull.Value;
            cmd.Parameters.Add(pDesde);

            // --- Fecha Hasta ---
            SqlParameter pHasta = new SqlParameter("@FechaHasta", System.Data.SqlDbType.Date);
            if (fechaHasta != null)
                pHasta.Value = fechaHasta;
            else
                pHasta.Value = DBNull.Value;
            cmd.Parameters.Add(pHasta);

            // --- Especialidad ---
            // Convención: 0 = "Todas las especialidades" (el SP lo resuelve con @IdEspecialidad = 0 OR ...).
            cmd.Parameters.Add(new SqlParameter("@IdEspecialidad", idEspecialidad));

            return ds.ObtenerTablaConSP(cmd, "SP_Informe_AsistenciaAvanzado");
        }

        public DataTable ListarEspecialidades()
        {

            return ds.ObtenerTablaConSP("SP_ListarEspecialidades");
        }


        public DataTable ObtenerPacientesPorAsistencia(DateTime? fechaDesde, DateTime? fechaHasta)
        {
            SqlCommand cmd = new SqlCommand();

            // --- Fecha Desde ---
            // Cada parámetro se decide mirando SU PROPIA variable:
            // acá corresponde preguntar por fechaDesde (antes, por error, se
            // preguntaba por fechaHasta y el filtro "Desde" se enviaba mal).
            SqlParameter pDesde = new SqlParameter("@FechaDesde", System.Data.SqlDbType.Date);
            if (fechaDesde != null)
                pDesde.Value = fechaDesde;
            else
                pDesde.Value = DBNull.Value;
            cmd.Parameters.Add(pDesde);

            // --- Fecha Hasta ---
            SqlParameter pHasta = new SqlParameter("@FechaHasta", System.Data.SqlDbType.Date);
            if (fechaHasta != null)
                pHasta.Value = fechaHasta;
            else
                pHasta.Value = DBNull.Value;
            cmd.Parameters.Add(pHasta);

            return ds.ObtenerTablaConSP(cmd, "SP_Informe_PacientesPorAsistencia");
        }

        public DataTable ObtenerEspecialidadesMasSolicitadas()
        {

            return ds.ObtenerTablaConSP("SP_Informe_EspecialidadesMasSolicitadas");
        }
    }
}
