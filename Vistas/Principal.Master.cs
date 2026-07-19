using Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Vistas
{
    public partial class Principal : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes["novalidate"] = "novalidate";
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));

            if (Session["Usuario"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            EntidadUsuario usuario = (EntidadUsuario)Session["Usuario"];

            if (usuario.TipoUsuario != "Administrador")
            {
                Response.Redirect("TurnosMedico.aspx");
                return;
            }

            lblUsuarioLogueado.Text = usuario.NombreCompleto;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
