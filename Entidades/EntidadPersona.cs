using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


    namespace Entidades
    {        
        public class EntidadPersona
        {
            private string _dni;
            private string _nombre;
            private string _apellido;
            private string _sexo;
            private string _nacionalidad;
            private DateTime _fechaNacimiento;
            private string _direccion;
            private int _idLocalidad;
            private string _correoElectronico;
            private string _telefono;

            public EntidadPersona() { }

            public string Dni
            {
                get { return _dni; }
                set { _dni = value; }
            }

            public string Nombre
            {
                get { return _nombre; }
                set { _nombre = value; }
            }

            public string Apellido
            {
                get { return _apellido; }
                set { _apellido = value; }
            }

            public string Sexo
            {
                get { return _sexo; }
                set { _sexo = value; }
            }

            public string Nacionalidad
            {
                get { return _nacionalidad; }
                set { _nacionalidad = value; }
            }

            public DateTime FechaNacimiento 
            {
                get { return _fechaNacimiento; }
                set { _fechaNacimiento = value; }
            }

            public string Direccion
            {
                get { return _direccion; }
                set { _direccion = value; }
            }

            public int IdLocalidad
            {
                get { return _idLocalidad; }
                set { _idLocalidad = value; }
            }

            public string CorreoElectronico
            {
                get { return _correoElectronico; }
                set { _correoElectronico = value; }
            }

            public string Telefono
            {
                get { return _telefono; }
                set { _telefono = value; }
            }

            public string NombreCompleto
            {
                get { return _apellido + ", " + _nombre; }
            }
        }
    }
