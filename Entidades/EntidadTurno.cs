using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadTurno
    {      
            private int _idTurno;
            private string _legMedico;
            private string _dniPaciente;
            private DateTime _fechaTur;
            private TimeSpan _horaTur;
            private string _asistencia;
            private string _observaciones;
            private bool _estadoTur;
            private string _nombreCompletoPaciente;

        
        public EntidadTurno() { }

            public int IdTurno
            {
                get { return _idTurno; }
                set { _idTurno = value; }
            }

            public string LegMedico
            {
                get { return _legMedico; }
                set { _legMedico = value; }
            }

            public string DniPaciente
            {
                get { return _dniPaciente; }
                set { _dniPaciente = value; }
            }

            public DateTime FechaTur
            {
                get { return _fechaTur; }
                set { _fechaTur = value; }
            }

            public TimeSpan HoraTur
            {
                get { return _horaTur; }
                set { _horaTur = value; }
            }

            public string Asistencia
            {
                get { return _asistencia; }
                set { _asistencia = value; }
            }

            public string Observaciones
            {
                get { return _observaciones; }
                set { _observaciones = value; }
        }

        public bool EstadoTur
        {
            get { return _estadoTur; }
            set { _estadoTur = value; }


        }

        public string NombreCompletoPaciente
        {
            get { return _nombreCompletoPaciente; }
            set { _nombreCompletoPaciente = value; }
        }
    }
}


