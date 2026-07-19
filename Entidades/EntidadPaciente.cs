using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadPaciente : EntidadPersona
    {

        
        private bool _estadoPac;

        public EntidadPaciente() : base() { }

        public bool EstadoPac
        {
            get { return _estadoPac; }
            set { _estadoPac = value; }
        }
    }

}

