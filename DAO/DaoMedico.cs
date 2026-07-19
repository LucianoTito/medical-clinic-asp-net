using Dao;
using Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Dao
{
    public class DaoMedico
    {
        private AccesoDatos ds = new AccesoDatos();

        public DataTable ObtenerMedicosPorEspecialidad(int idEspecialidad)
        {
            SqlParameter parametro = new SqlParameter("@IdEspecialidad", idEspecialidad);
            return ds.ObtenerTablaConSP_Parametro("SP_ListarMedicosPorEspecialidad", parametro);
        }

        public DataTable ObtenerTodosLosMedicos()
        {
            return ds.ObtenerTablaConSP("SP_ListarMedicos");
        }

       public DataTable BuscarMedicos(string texto, int idEspecialidad, int estado)
        {
            SqlCommand cmd = new SqlCommand();

            cmd.Parameters.AddWithValue("@Texto", texto);
            cmd.Parameters.AddWithValue("@IdEspecialidad", idEspecialidad);
            cmd.Parameters.AddWithValue("@Estado", estado);

            return ds.ObtenerTablaConSP(cmd, "SP_BuscarMedicos");
        }
        

        // Devuelve: 1 = alta OK, 0 = no insertó, -1 = error de base.
        public int AgregarMedico(EntidadMedico medico)
        {
            SqlCommand cmd = new SqlCommand();

            cmd.Parameters.AddWithValue("@Legajo_Med", medico.LegajoMed);
            cmd.Parameters.AddWithValue("@Dni_Med", medico.Dni);
            cmd.Parameters.AddWithValue("@Nombre_Med", medico.Nombre);
            cmd.Parameters.AddWithValue("@Apellido_Med", medico.Apellido);
            cmd.Parameters.AddWithValue("@Sexo_Med", medico.Sexo);
            cmd.Parameters.AddWithValue("@Nacionalidad_Med", medico.Nacionalidad);
            cmd.Parameters.AddWithValue("@FechaNacimiento_Med", medico.FechaNacimiento);
            cmd.Parameters.AddWithValue("@Direccion_Med", medico.Direccion);
            cmd.Parameters.AddWithValue("@Id_Localidad_Med", medico.IdLocalidad);
            cmd.Parameters.AddWithValue("@CorreoElectronico_Med", medico.CorreoElectronico);
            cmd.Parameters.AddWithValue("@Telefono_Med", medico.Telefono);
            cmd.Parameters.AddWithValue("@Id_Especialidad_Med", medico.IdEspecialidadMed);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_AgregarMedico");
        }
       
        public bool ExisteMedicoPorLegajoODni(string legajo, string dni)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Legajo_Med", legajo);
            cmd.Parameters.AddWithValue("@Dni_Med", dni);

            object resultado = ds.ObtenerEscalarConSP(cmd, "SP_ExisteMedicoPorLegajoODni");

            // Si no pudimos verificar (base caída), no arriesgamos un alta duplicada.
            if (resultado == null)
                return true;

            return Convert.ToInt32(resultado) > 0;
        }
        public int BajaLogicaMedico(string legajo)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Legajo_Med", legajo);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_BajaLogicaMedico");
        }

        public int ReactivarMedico(string legajo)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Legajo_Med", legajo);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_ReactivarMedico");
        }

        public DataTable ObtenerMedicoPorLegajo(string legajo)
        {
            SqlParameter parametro = new SqlParameter("@Legajo_Med", legajo);
            return ds.ObtenerTablaConSP_Parametro("SP_ObtenerMedicoPorLegajo", parametro);
        }

        public int ModificarMedico(EntidadMedico medico)
        {
            SqlCommand cmd = new SqlCommand();

            cmd.Parameters.AddWithValue("@Legajo_Med", medico.LegajoMed);
            cmd.Parameters.AddWithValue("@Dni_Med", medico.Dni);
            cmd.Parameters.AddWithValue("@Nombre_Med", medico.Nombre);
            cmd.Parameters.AddWithValue("@Apellido_Med", medico.Apellido);
            cmd.Parameters.AddWithValue("@Sexo_Med", medico.Sexo);
            cmd.Parameters.AddWithValue("@Nacionalidad_Med", medico.Nacionalidad);
            cmd.Parameters.AddWithValue("@FechaNacimiento_Med", medico.FechaNacimiento);
            cmd.Parameters.AddWithValue("@Direccion_Med", medico.Direccion);
            cmd.Parameters.AddWithValue("@Id_Localidad_Med", medico.IdLocalidad);
            cmd.Parameters.AddWithValue("@CorreoElectronico_Med", medico.CorreoElectronico);
            cmd.Parameters.AddWithValue("@Telefono_Med", medico.Telefono);
            cmd.Parameters.AddWithValue("@Id_Especialidad_Med", medico.IdEspecialidadMed);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_ModificarMedico");
        }

        public DataTable ListarDiasSemana()
        {
            return ds.ObtenerTablaConSP("SP_ListarDiasSemana");
        }

        public DataTable ListarHorariosAtencion()
        {
            return ds.ObtenerTablaConSP("SP_ListarHorariosAtencion");
        }

        public int AgregarHorarioMedico(string legajoMedico, int idDia, string idHorario)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Leg_Medico", legajoMedico);
            cmd.Parameters.AddWithValue("@Id_Dia", idDia);
            cmd.Parameters.AddWithValue("@Id_Horario", idHorario);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_AgregarHorarioMedico");
        }
        public int EliminarHorarioMedico(string legajoMedico, int idDia, string idHorario)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Leg_Medico", legajoMedico);
            cmd.Parameters.AddWithValue("@Id_Dia", idDia);
            cmd.Parameters.AddWithValue("@Id_Horario", idHorario);

            return ds.EjecutarProcedimientoAlmacenado(cmd, "SP_EliminarHorarioMedico");
        }

        public DataTable ListarHorariosPorMedico(string legajoMedico)
        {
            SqlParameter parametro = new SqlParameter("@Leg_Medico", legajoMedico);
            return ds.ObtenerTablaConSP_Parametro("SP_ListarHorariosPorMedico", parametro);
        }
        public bool ExisteHorarioMedico(string legajoMedico, int idDia, string idHorario)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Parameters.AddWithValue("@Leg_Medico", legajoMedico);
            cmd.Parameters.AddWithValue("@Id_Dia", idDia);
            cmd.Parameters.AddWithValue("@Id_Horario", idHorario);

            object resultado = ds.ObtenerEscalarConSP(cmd, "SP_ExisteHorarioMedico");

            return resultado != null && Convert.ToInt32(resultado) > 0;
        }
    }
}