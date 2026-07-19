using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    internal class EntidadEspecialidad
    {
        private int _idEspecialidad;
        private string _descripcionEsp;

       
        public EntidadEspecialidad() { }

        
        public int IdEspecialidad
        {
            get { return _idEspecialidad; }
            set { _idEspecialidad = value; }
        }

        public string DescripcionEsp
        {
            get { return _descripcionEsp; }
            set { _descripcionEsp = value; }
        }

    }
}
