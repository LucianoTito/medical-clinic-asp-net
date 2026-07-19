using DAO;
using Entidades;
using System.Data;

namespace Negocio
{
    public class NegocioMedico
    {
        private DaoMedico mdao = new DaoMedico();

        public DataTable ListarMedicosPorEspecialidad(int idEspecialidad)
        {
            return mdao.ObtenerMedicosPorEspecialidad(idEspecialidad);
        }

        public DataTable ListarMedicos()
        {
            return mdao.ObtenerTodosLosMedicos();
        }

        public DataTable BuscarMedicos(string texto, int idEspecialidad, int estado)
        {
            return mdao.BuscarMedicos(texto, idEspecialidad, estado);
        }

        // Devuelve: 1 = OK, 0 = ya existe legajo/DNI, -1 = error de base.
        public int AgregarMedico(EntidadMedico medico)
        {
           //la regla de negocio (no repetir legajo/DNI) va en negocio.
            if (mdao.ExisteMedicoPorLegajoODni(medico.LegajoMed, medico.Dni))
                return 0;

            return mdao.AgregarMedico(medico);
        }

        public int BajaLogicaMedico(string legajo)
        {
            return mdao.BajaLogicaMedico(legajo);
        }
        public DataTable ObtenerMedicoPorLegajo(string legajo)
        {
            return mdao.ObtenerMedicoPorLegajo(legajo);
        }

        public int ModificarMedico(EntidadMedico medico)
        {
            return mdao.ModificarMedico(medico);
        }

        public DataTable ListarDiasSemana()
        {
            return mdao.ListarDiasSemana();
        }

        public DataTable ListarHorariosAtencion()
        {
            return mdao.ListarHorariosAtencion();
        }

        public int AgregarHorarioMedico(string legajoMedico, int idDia, string idHorario)
        {
            if (string.IsNullOrWhiteSpace(legajoMedico) || idDia <= 0 || string.IsNullOrWhiteSpace(idHorario))
                return 0;

            if (mdao.ExisteHorarioMedico(legajoMedico, idDia, idHorario))
                return 2;

            return mdao.AgregarHorarioMedico(legajoMedico, idDia, idHorario);
        }
        public int EliminarHorarioMedico(string legajoMedico, int idDia, string idHorario)
        {
            if (string.IsNullOrWhiteSpace(legajoMedico) || idDia <= 0 || string.IsNullOrWhiteSpace(idHorario))
                return 0;

            return mdao.EliminarHorarioMedico(legajoMedico, idDia, idHorario);
        }
        public DataTable ListarHorariosPorMedico(string legajoMedico)
        {
            return mdao.ListarHorariosPorMedico(legajoMedico);
        }

        public int ReactivarMedico(string legajo)
        {
            return mdao.ReactivarMedico(legajo);
        }
    }
}