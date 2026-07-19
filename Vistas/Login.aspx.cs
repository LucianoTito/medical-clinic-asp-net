using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Entidades;
using Negocio;

namespace Vistas
{
    public partial class Login : System.Web.UI.Page
    {
        private NegocioUsuario negocioUsuario = new NegocioUsuario();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Limpiamos la sesión si entran al login
                Session["Usuario"] = null;
                Session.Clear();
            }
        }

        protected void btnIngresarClick(object sender, EventArgs e)
        {
            // Limpiamos mensajes anteriores
            lblMensaje.Text = "";

            string usuario = txtUsuario.Text.Trim();
            string contrasenia = txtContrasenia.Text;

            if (usuario == "" || contrasenia == "")
            {
                lblMensaje.Text = "Complete usuario y contraseña.";
                return;
            }

            EntidadUsuario usuarioLogueado = negocioUsuario.ValidarUsuario(usuario, contrasenia);

            if (usuarioLogueado != null)
            {
                Session["Usuario"] = usuarioLogueado;

                if (usuarioLogueado.TipoUsuario == "Administrador")
                    Response.Redirect("Pacientes.aspx");
                else if (usuarioLogueado.TipoUsuario == "Medico")
                    Response.Redirect("TurnosMedico.aspx");
                else
                    lblMensaje.Text = "El usuario no tiene un rol válido asignado. Contacte al administrador.";
            }
            else
            {
                lblMensaje.Text = "Usuario o contraseña incorrectos.";
            }
        }
    }
}