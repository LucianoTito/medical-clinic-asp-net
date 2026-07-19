using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Entidades;
using DAO;

namespace Negocio
{
    public class NegocioUsuario
    {
        private DAO.DaoUsuario daoUsuario = new DAO.DaoUsuario();

        public EntidadUsuario ValidarUsuario(string nombreUsuario, string contrasena)
        {
            return daoUsuario.ValidarUsuario(nombreUsuario, contrasena);
        }
        public bool ExisteUsuarioParaMedico(string legajoMed)
        {
            return daoUsuario.ExisteUsuarioParaMedico(legajoMed);
        }
        public bool ExisteUsuario(string nombreUsuario)
        {
            return daoUsuario.ExisteUsuario(nombreUsuario);
        }
        public int AgregarUsuarioMedico(string nombreUsuario, string contrasena, string legajoMed)
        {
            return daoUsuario.AgregarUsuarioMedico(nombreUsuario, contrasena, legajoMed);
        }
        public int ModificarUsuarioMedico(string nombreUsuario, string contrasena, string legajoMed)
        {
            return daoUsuario.ModificarUsuarioMedico(nombreUsuario, contrasena, legajoMed);
        }
        public string ObtenerUsuarioPorMedico(string legajoMed)
        {
            return daoUsuario.ObtenerUsuarioPorMedico(legajoMed);
        }
    }
}