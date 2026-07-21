using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;

namespace DAO
{
    public class AccesoDatos
    {
        
        private string rutaBDClinica = ConfigurationManager.ConnectionStrings["ClinicaMedica"].ConnectionString;
        public SqlConnection ObtenerConexion()
        {
            SqlConnection cn = new SqlConnection(rutaBDClinica);
            try
            {
                cn.Open();
                return cn;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al conectar a la BD: " + ex.Message);
            }
        }

        public DataTable ObtenerTablaConSP(string nombreSP)
        {
            DataTable dt = new DataTable();
            SqlConnection conexion = ObtenerConexion();

            if (conexion == null)
                return null;

            try
            {
                SqlCommand cmd = new SqlCommand(nombreSP, conexion);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);

                return dt;
            }
            catch (Exception)
            {

                return null;
            }
            finally
            {
                conexion.Close();
            }
        }

        public DataTable ObtenerTablaConSP_Parametro(string nombreSP, SqlParameter parametro)
        {
            DataTable dt = new DataTable();
            SqlConnection conexion = ObtenerConexion();
            if (conexion == null)
                return null;

            try
            {
                SqlCommand cmd = new SqlCommand(nombreSP, conexion);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add(parametro);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);

                return dt;
            }
            catch (Exception)
            {
                return null;
            }
            finally
            {
                conexion.Close();
            }
        }

        public DataTable ObtenerTablaConSP(SqlCommand comando, string nombreSP)
        {
            DataTable dt = new DataTable();
            SqlConnection conexion = ObtenerConexion();

            if (conexion == null)
                return null;

            try
            {
                comando.Connection = conexion;
                comando.CommandType = CommandType.StoredProcedure;
                comando.CommandText = nombreSP;

                SqlDataAdapter adapter = new SqlDataAdapter(comando);
                adapter.Fill(dt);

                return dt;
            }
            catch (Exception)
            {
                return null;
            }
            finally
            {
                conexion.Close();
            }
        }

        // ===== Métodos genéricos para escrituras / escalares por SP =====
        // Reciben el comando ya armado con sus parámetros, sin importar la cantidad.

        // Para INSERT / UPDATE / DELETE vía SP.
        // Devuelve: filas afectadas, o -1 si no conectó o falló la ejecución.
        public int EjecutarProcedimientoAlmacenado(SqlCommand comando, string nombreSP)
        {
            SqlConnection conexion = ObtenerConexion();

            if (conexion == null)
                return -1;

            comando.Connection = conexion;
            comando.CommandType = CommandType.StoredProcedure;
            comando.CommandText = nombreSP;

            int filasAfectadas;
            try
            {
                filasAfectadas = comando.ExecuteNonQuery();
            }
            catch (Exception)
            {
                filasAfectadas = -1;
            }
            finally
            {
                conexion.Close();
            }

            return filasAfectadas;
        }

        // Para SP que devuelven un único valor (ej: COUNT de duplicados).
        // Devuelve: el escalar, o null si no conectó o falló.
        public object ObtenerEscalarConSP(SqlCommand comando, string nombreSP)
        {
            SqlConnection conexion = ObtenerConexion();

            if (conexion == null)
                return null;

            comando.Connection = conexion;
            comando.CommandType = CommandType.StoredProcedure;
            comando.CommandText = nombreSP;

            object resultado;
            try
            {
                resultado = comando.ExecuteScalar();
            }
            catch (Exception)
            {
                resultado = null;
            }
            finally
            {
                conexion.Close();
            }

            return resultado;
        }
    }
}