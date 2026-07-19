using Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAO
{
    public class DaoPaciente
    {
        private AccesoDatos ds = new AccesoDatos();

        public DataTable BuscarPorDni(string dni)
        {
            SqlParameter parametro = new SqlParameter("@DNI", dni);

            return ds.ObtenerTablaConSP_Parametro("SP_BuscarPacientePorDNI", parametro);
        }

        public DataTable ListarPacientes()
        {
            return ds.ObtenerTablaConSP("SP_ListarPacientes");
        }

        public DataTable FiltrarPacientes(string busqueda, string sexo, int estado)
        {
            SqlConnection cn = ds.ObtenerConexion();
            if (cn == null) return null;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_FiltrarPacientes", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Busqueda", busqueda);
                cmd.Parameters.AddWithValue("@Sexo", sexo);
                cmd.Parameters.AddWithValue("@Estado", estado);

                DataTable dt = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);

                return dt;
            }
            catch (SqlException)
            {
                return null;
            }
            finally
            {
                cn.Close();
            }
        }

        public int AltaPaciente(EntidadPaciente p)
        {
            SqlConnection cn = ds.ObtenerConexion();
            if (cn == null) return -1;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_AltaPaciente", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Dni", p.Dni);
                cmd.Parameters.AddWithValue("@Nombre", p.Nombre);
                cmd.Parameters.AddWithValue("@Apellido", p.Apellido);
                cmd.Parameters.AddWithValue("@Sexo", p.Sexo);
                cmd.Parameters.AddWithValue("@Nacionalidad", p.Nacionalidad);
                cmd.Parameters.AddWithValue("@FechaNacimiento", p.FechaNacimiento);
                cmd.Parameters.AddWithValue("@Direccion", p.Direccion);
                cmd.Parameters.AddWithValue("@Id_Localidad", p.IdLocalidad);
                cmd.Parameters.AddWithValue("@CorreoElectronico", p.CorreoElectronico);
                cmd.Parameters.AddWithValue("@Telefono", p.Telefono);

                cmd.ExecuteNonQuery();

                return 1; 
            }
            catch (SqlException)
            {
                return 0;
            }
            finally
            {
                cn.Close();
            }
        }

        public int ModificarPaciente(EntidadPaciente p)
        {
            SqlConnection cn = ds.ObtenerConexion();
            if (cn == null) return -1;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_ModificarPaciente", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Dni", p.Dni);
                cmd.Parameters.AddWithValue("@Nombre", p.Nombre);
                cmd.Parameters.AddWithValue("@Apellido", p.Apellido);
                cmd.Parameters.AddWithValue("@Sexo", p.Sexo);
                cmd.Parameters.AddWithValue("@Nacionalidad", p.Nacionalidad);
                cmd.Parameters.AddWithValue("@FechaNacimiento", p.FechaNacimiento);
                cmd.Parameters.AddWithValue("@Direccion", p.Direccion);
                cmd.Parameters.AddWithValue("@Id_Localidad", p.IdLocalidad);
                cmd.Parameters.AddWithValue("@CorreoElectronico", p.CorreoElectronico);
                cmd.Parameters.AddWithValue("@Telefono", p.Telefono);

                cmd.ExecuteNonQuery();

                return 1; 
            }
            catch (SqlException)
            {
                return 0; 
            }
            finally
            {
                cn.Close();
            }

        }

        public int BajaPaciente(string dni)
        {
            SqlConnection cn = ds.ObtenerConexion();
            if (cn == null) return -1;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_BajaPaciente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Dni", dni);

                cmd.ExecuteNonQuery();

                return 1;
            }
            catch (SqlException)
            {
                return 0;
            }
            finally
            {
                cn.Close();
            }
        }

        public int ReactivarPaciente(string dni)
        {
            SqlConnection cn = ds.ObtenerConexion();
            if (cn == null) return -1;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_ReactivarPaciente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Dni", dni);

                cmd.ExecuteNonQuery();

                return 1;
            }
            catch (SqlException)
            {
                return 0;
            }
            finally
            {
                cn.Close();
            }
        }
    }
}
