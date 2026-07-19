using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAO;
using Entidades;

namespace Negocio
{
    public class NegocioPaciente
    {

        private DaoPaciente pdao = new DaoPaciente();

        public EntidadPaciente BuscarPacientePorDni(string dni)
        {
            DataTable tabla = pdao.BuscarPorDni(dni);

            if (tabla.Rows.Count > 0)
            {
                EntidadPaciente pac = new EntidadPaciente();

                pac.Dni = tabla.Rows[0]["Dni_Pac"].ToString();
                pac.Nombre = tabla.Rows[0]["Nombre_Pac"].ToString();
                pac.Apellido = tabla.Rows[0]["Apellido_Pac"].ToString();
                pac.EstadoPac = Convert.ToBoolean(tabla.Rows[0]["Estado_Pac"]);

                return pac;
            }

            return null; 
        }

        public DataTable ListarPacientes()
        {
            return pdao.ListarPacientes();
        }

        public DataTable FiltrarPacientes(string busqueda, string sexo, int estado)
        {
            return pdao.FiltrarPacientes(busqueda, sexo, estado);
        }

        public int AltaPaciente(EntidadPaciente p)
        {
            return pdao.AltaPaciente(p);
        }

        public int ModificarPaciente(EntidadPaciente p)
        {
            return pdao.ModificarPaciente(p);
        }

        public int BajaPaciente(string dni)
        {
            return pdao.BajaPaciente(dni);
        }

        public int ReactivarPaciente(string dni)
        {
            return pdao.ReactivarPaciente(dni);
        }

    }
}
