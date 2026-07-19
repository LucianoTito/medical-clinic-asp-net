using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Entidades;
using Negocio;

namespace Vistas
{
    public partial class TurnosMedico : System.Web.UI.Page
    {
        NegocioTurnos negocioTurnos = new NegocioTurnos();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarTurnos();
            }
        }

        private void CargarTurnos()
        {
            EntidadUsuario usuario = (EntidadUsuario)Session["Usuario"];
            if (usuario == null || string.IsNullOrEmpty(usuario.LegajoMed)) return;

            bool hayFiltros = !string.IsNullOrWhiteSpace(txtBuscarPaciente.Text) ||
                              !string.IsNullOrWhiteSpace(txtFechaDesde.Text) ||
                              !string.IsNullOrWhiteSpace(txtFechaHasta.Text);

            DataTable dt;

            if (hayFiltros)
            {
                dt = negocioTurnos.ListarTurnosFiltrados(usuario.LegajoMed, txtBuscarPaciente.Text, txtFechaDesde.Text, txtFechaHasta.Text);
            }
            else
            {
                dt = negocioTurnos.ListarTurnosFiltrados(usuario.LegajoMed, null, DateTime.Now.ToString(), null);
            }

            gvTurnosMedico.DataSource = dt;
            gvTurnosMedico.DataBind();
            gvTurnosMedico.Visible = true;
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            lblMensaje.Text = "";

            // Tercera capa de validacion: si los validadores de fecha del
            // GrupoTurnosMedico no pasaron en el servidor, no se filtra.
            if (!Page.IsValid) return;

            if (string.IsNullOrWhiteSpace(txtBuscarPaciente.Text) &&
                string.IsNullOrWhiteSpace(txtFechaDesde.Text) &&
                string.IsNullOrWhiteSpace(txtFechaHasta.Text))
            {
                lblMensaje.Text = "Debe ingresar al menos un criterio para realizar la búsqueda";
                lblMensaje.CssClass = "msg-error";
                return;
            }

            gvTurnosMedico.EditIndex = -1;
            CargarTurnos();
        }

        protected void gvTurnosMedico_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvTurnosMedico.EditIndex = e.NewEditIndex;
            CargarTurnos();
        }

        protected void gvTurnosMedico_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTurnosMedico.EditIndex = -1;
            CargarTurnos();
        }

        protected void gvTurnosMedico_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int idTurno = Convert.ToInt32(gvTurnosMedico.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvTurnosMedico.Rows[e.RowIndex];

                DropDownList ddlAsistencia = (DropDownList)row.FindControl("ddlAsistenciaEdit");
                TextBox txtObservaciones = (TextBox)row.FindControl("txtObservacionesEdit");

                if (ddlAsistencia != null && txtObservaciones != null)
                {
                    bool ok = negocioTurnos.ActualizarTurnoNeg(idTurno, ddlAsistencia.SelectedValue, txtObservaciones.Text);
                    if (ok)
                    {
                        lblMensaje.CssClass = "msg-ok";
                        lblMensaje.Text = "Turno actualizado con éxito.";
                    }
                }

                gvTurnosMedico.EditIndex = -1;
                CargarTurnos();
            }
            catch (Exception ex)
            {
                lblMensaje.CssClass = "msg-error";
                lblMensaje.Text = "Error al actualizar: " + ex.Message;
            }
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            txtBuscarPaciente.Text = string.Empty;
            txtFechaDesde.Text = string.Empty;
            txtFechaHasta.Text = string.Empty;
            lblMensaje.Text = "";
            gvTurnosMedico.EditIndex = -1;
            CargarTurnos();
        }

        protected void gvTurnosMedico_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvTurnosMedico.PageIndex = e.NewPageIndex;
            gvTurnosMedico.EditIndex = -1;
            CargarTurnos();
        }
    }
}