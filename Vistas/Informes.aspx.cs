using Negocio;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Vistas
{
    public partial class Informes : System.Web.UI.Page
    {

        private NegocioInformes negInformes = new NegocioInformes();
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                CargarEspecialidades();
            }
        }

        private void CargarEspecialidades()
        {
            DataTable dt = negInformes.ListarEspecialidades();

            ddlEspecialidades.DataSource = dt;
            ddlEspecialidades.DataTextField = "Descripcion_Esp";   // lo que ve el usuario
            ddlEspecialidades.DataValueField = "Id_Especialidad";  // el valor real que viaja
            ddlEspecialidades.DataBind();


            ddlEspecialidades.Items.Insert(0, new ListItem("-- Todas las Especialidades --", "0"));
        }

        private void CargarInforme()
        {
            lblMensaje.Text = "";

            string fechaDesde = txtFechaDesde.Text;
            string fechaHasta = txtFechaHasta.Text;
            string especialidad = ddlEspecialidades.SelectedValue;

            DataTable dt = negInformes.GenerarReporteAsistencias(fechaDesde, fechaHasta, especialidad);


            if (dt == null)
            {
           
                lblMensaje.ForeColor = System.Drawing.Color.Red;
                lblMensaje.Text = "No se pudo generar el reporte. Verifique la conexión con la base.";
                gvInformes.DataSource = null;
                gvInformes.DataBind();
                return;
            }

            
            gvInformes.DataSource = dt;
            gvInformes.DataBind();

            // mje explícito cuando la consulta fue OK pero sin resultados.
            if (dt.Rows.Count == 0)
            {
                lblMensaje.ForeColor = System.Drawing.Color.DarkBlue;
                lblMensaje.Text = "La consulta no devolvió resultados para los filtros seleccionados.";
            }
        }

        private void CargarInformePacientes()
        {
            lblMensajePac.Text = "";
            lblResumenPac.Text = "";

            string fechaDesde = txtFechaDesdePac.Text;
            string fechaHasta = txtFechaHastaPac.Text;

            DataTable dt = negInformes.GenerarReportePacientes(fechaDesde, fechaHasta);

            if (dt == null)
            {
                lblMensajePac.ForeColor = System.Drawing.Color.Red;
                lblMensajePac.Text = "No se pudo generar el reporte. Verifique la conexión con la base.";
                gvPacientes.DataSource = null;
                gvPacientes.DataBind();
                return;
            }


            if (dt.Rows.Count > 0)
            {
                int totalPresentes = 0;
                int totalAusentes = 0;

                foreach (DataRow fila in dt.Rows)
                {
                    totalPresentes += Convert.ToInt32(fila["Veces_Presente"]);
                    totalAusentes += Convert.ToInt32(fila["Veces_Ausente"]);
                }

                int totalCerrados = totalPresentes + totalAusentes;

                if (totalCerrados > 0)
                {
                    decimal porcPresentes = (decimal)totalPresentes / totalCerrados * 100;
                    decimal porcAusentes = (decimal)totalAusentes / totalCerrados * 100;

                    lblResumenPac.Text = "Total de turnos cerrados: " + totalCerrados +
                        " | Presentes: " + porcPresentes.ToString("N2") + "%" +
                        " | Ausentes: " + porcAusentes.ToString("N2") + "%";
                }
            }

            gvPacientes.DataSource = dt;
            gvPacientes.DataBind();

            
            if (dt.Rows.Count == 0)
            {
                lblMensajePac.ForeColor = System.Drawing.Color.DarkBlue;
                lblMensajePac.Text = "La consulta no devolvió resultados para los filtros seleccionados.";
            }
        }

        protected void btnGenerarPacientes_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            gvPacientes.PageIndex = 0;
            CargarInformePacientes();
        }

        protected void gvPacientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPacientes.PageIndex = e.NewPageIndex;
            CargarInformePacientes();
        }

        protected void btnGenerarReporte_Click(object sender, EventArgs e)
        {
            
            if (!Page.IsValid)
                return;

            gvInformes.PageIndex = 0;
            CargarInforme();
        }

        protected void gvInformes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvInformes.PageIndex = e.NewPageIndex;
            CargarInforme();
        }

        private void CargarInformeEspecialidades()
        {
            lblMensajeEsp.Text = "";

            DataTable dt = negInformes.GenerarReporteEspecialidades();

            if (dt == null)
            {
                lblMensajeEsp.ForeColor = System.Drawing.Color.Red;
                lblMensajeEsp.Text = "No se pudo generar el reporte. Verifique la conexión con la base de datos.";
                gvEspecialidades.DataSource = null;
                gvEspecialidades.DataBind();
                return;
            }

            gvEspecialidades.DataSource = dt;
            gvEspecialidades.DataBind();

            if (dt.Rows.Count == 0)
            {
                lblMensajeEsp.ForeColor = System.Drawing.Color.DarkBlue;
                lblMensajeEsp.Text = "La consulta no devolvió resultados.";
            }
        }

        protected void btnGenerarEspecialidades_Click(object sender, EventArgs e)
        {
            gvEspecialidades.PageIndex = 0;
            CargarInformeEspecialidades();
        }

        protected void gvEspecialidades_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEspecialidades.PageIndex = e.NewPageIndex;
            CargarInformeEspecialidades();
        }
    }
}