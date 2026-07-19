
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entidades;
using Dao;

namespace DAO
{
    public class DaoUsuario
    {
        private AccesoDatos acceso = new AccesoDatos();

        public EntidadUsuario ValidarUsuario(string nombreUsuario, string contrasena)
        {
            EntidadUsuario usuario = null;
            SqlConnection cn = acceso.ObtenerConexion();

            if (cn == null)
                return null;

            try
            {

                SqlCommand cmd = new SqlCommand("SP_ValidarUsuario", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@NombreUsuario", nombreUsuario);
                cmd.Parameters.AddWithValue("@Contrasena", contrasena);

                SqlDataReader lector = cmd.ExecuteReader();

                if (lector.Read())
                {
                    usuario = new EntidadUsuario();
                    usuario.IdUsuario = (int)lector["Id_Usuario"];
                    usuario.NombreUsuario = lector["NombreUsuario"].ToString();
                    usuario.Contrasena = lector["Contrasena"].ToString();
                    usuario.TipoUsuario = lector["TipoUsuario"].ToString();
                    usuario.Activo = (bool)lector["Activo"];

                    if (lector["Legajo_Med"] != DBNull.Value)
                        usuario.LegajoMed = lector["Legajo_Med"].ToString().Trim();
                    else
                        usuario.LegajoMed = null;
                    if (lector["Legajo_Adm"] != DBNull.Value)
                        usuario.LegajoAdm = lector["Legajo_Adm"].ToString().Trim();
                    else
                        usuario.LegajoAdm = null;

                    usuario.NombreCompleto = lector["NombreCompleto"].ToString();
                }

                lector.Close();
            }
            finally
            {
                cn.Close();
            }

            return usuario;
        }
        public bool ExisteUsuarioParaMedico(string legajoMed)
        {
            bool existe = false;
            SqlConnection cn = acceso.ObtenerConexion();

            if (cn == null)
                return false;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_ExisteUsuarioParaMedico", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Legajo_Med", legajoMed);

                int cantidad = Convert.ToInt32(cmd.ExecuteScalar());

                existe = cantidad > 0;
            }
            finally
            {
                cn.Close();
            }

            return existe;
        }
        public bool ExisteUsuario(string nombreUsuario)
        {
            bool existe = false;
            SqlConnection cn = acceso.ObtenerConexion();

            if (cn == null)
                return false;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_ExisteUsuario", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@NombreUsuario", nombreUsuario);

                int cantidad = Convert.ToInt32(cmd.ExecuteScalar());

                existe = cantidad > 0;
            }
            finally
            {
                cn.Close();
            }

            return existe;
        }
        public int AgregarUsuarioMedico(string nombreUsuario, string contrasena, string legajoMed)
        {
            int filasAfectadas = 0;
            SqlConnection cn = acceso.ObtenerConexion();

            if (cn == null)
                return -1;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_AgregarUsuarioMedico", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@NombreUsuario", nombreUsuario);
                cmd.Parameters.AddWithValue("@Contrasena", contrasena);
                cmd.Parameters.AddWithValue("@Legajo_Med", legajoMed);

                filasAfectadas = cmd.ExecuteNonQuery();
            }
            finally
            {
                cn.Close();
            }

            return filasAfectadas;
        }
        public int ModificarUsuarioMedico(string nombreUsuario, string contrasena, string legajoMed)
        {
            int filasAfectadas = 0;
            SqlConnection cn = acceso.ObtenerConexion();

            if (cn == null)
                return -1;

            try
            {
                SqlCommand cmd = new SqlCommand("SP_ModificarUsuarioMedico", cn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@NombreUsuario", nombreUsuario);
                cmd.Parameters.AddWithValue("@Contrasena", contrasena);
                cmd.Parameters.AddWithValue("@Legajo_Med", legajoMed);

                filasAfectadas = Convert.ToInt32(cmd.ExecuteScalar());
            }
            finally
            {
                cn.Close();
            }

            return filasAfectadas;
        }
        public string ObtenerUsuarioPorMedico(string legajoMed)
        {
            string nombreUsuario = "";
            SqlConnection cn = acceso.ObtenerConexion();

            if (cn == null)
                return "";

            try
            {
                SqlCommand cmd = new SqlCommand("SP_ObtenerUsuarioPorMedico", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Legajo_Med", legajoMed);

                object resultado = cmd.ExecuteScalar();

                if (resultado != null)
                    nombreUsuario = resultado.ToString();
            }
            finally
            {
                cn.Close();
            }

            return nombreUsuario;
        }
    }
}

