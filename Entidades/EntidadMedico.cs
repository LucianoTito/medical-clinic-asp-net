using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadMedico : EntidadPersona
    {

        private string _legajoMed;
        private int _idEspecialidadMed;
        private bool _estadoMed;

        public EntidadMedico() : base() { }

        public string LegajoMed
        {
            get { return _legajoMed; }
            set { _legajoMed = value; }
        }

        public int IdEspecialidadMed
        {
            get { return _idEspecialidadMed; }
            set { _idEspecialidadMed = value; }
        }

        public bool EstadoMed
        {
            get { return _estadoMed; }
            set { _estadoMed = value; }
        }

    }
}
