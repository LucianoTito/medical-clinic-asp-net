using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadUsuario
    {
        private int idUsuario;
        private string nombreUsuario;
        private string contrasena;
        private string tipoUsuario;
        private string legajoMed;
        private string legajoAdm;
        private string nombreCompleto;
        private bool activo;

        public int IdUsuario
        {
            get { return idUsuario; }
            set { idUsuario = value; }
        }

        public string NombreUsuario
        {
            get { return nombreUsuario; }
            set { nombreUsuario = value; }
        }

        public string Contrasena
        {
            get { return contrasena; }
            set { contrasena = value; }
        }

        public string TipoUsuario
        {
            get { return tipoUsuario; }
            set { tipoUsuario = value; }
        }

        public string LegajoMed
        {
            get { return legajoMed; }
            set { legajoMed = value; }
        }

        public string LegajoAdm
        {
            get { return legajoAdm; }
            set { legajoAdm = value; }
        }

        public string NombreCompleto
        {
            get { return nombreCompleto; }
            set { nombreCompleto = value; }
        }

        public bool Activo
        {
            get { return activo; }
            set { activo = value; }
        }
    }
}
