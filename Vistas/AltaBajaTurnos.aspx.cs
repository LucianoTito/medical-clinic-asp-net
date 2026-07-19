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
    public partial class AltaBajaTurnos : System.Web.UI.Page
    {
        private NegocioPaciente negocioPaciente = new NegocioPaciente();
        private NegocioEspecialidad negocioEspecialidad = new NegocioEspecialidad();
        private NegocioMedico negocioMedico = new NegocioMedico();
        private NegocioTurnos negocioTurnos = new NegocioTurnos();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEspecialidades();
            }
        }

        private void CargarEspecialidades()
        {
            ddlEspecialidad.DataSource = negocioEspecialidad.GetEspecialidades();

            ddlEspecialidad.DataValueField = "Id_Especialidad";
            ddlEspecialidad.DataTextField = "Descripcion_Esp";

            ddlEspecialidad.DataBind();

            ddlEspecialidad.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione una Especialidad --", "0"));
        }

        protected void btnBuscarPaciente_Click(object sender, EventArgs e)
        {
            string dniBuscar = txtDniBuscar.Text.Trim();

            LimpiarInterfazPaciente();

            if (string.IsNullOrEmpty(dniBuscar))
            {

                txtNombrePacienteOk.Text = "Ingrese un DNI por favor";
                lblNombrePaciente.Text = string.Empty;
                gvTurnosDelPaciente.DataSource = null;
                gvTurnosDelPaciente.DataBind();

                return;
            }

            EntidadPaciente pacienteEncontrado = negocioPaciente.BuscarPacientePorDni(dniBuscar);

            if (pacienteEncontrado != null)
            {

                txtNombrePacienteOk.Text = pacienteEncontrado.NombreCompleto;
                lblNombrePaciente.Text = pacienteEncontrado.NombreCompleto;
                CargarTurnosDelPaciente(dniBuscar);
            }
            else
            {

                txtNombrePacienteOk.Text = "Paciente inexistente";
                lblNombrePaciente.Text = string.Empty;
                gvTurnosDelPaciente.DataSource = null;
                gvTurnosDelPaciente.DataBind();
                lblMensajeHistorialVacio.Text = string.Empty;
            }
        }

        protected void ddlEspecialidad_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idEsp = Convert.ToInt32(ddlEspecialidad.SelectedValue);

            if (idEsp <= 0)
            {
                ddlMedico.Items.Clear();
                ddlMedico.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione un Médico --", "0"));

                LimpiarInterfazMedico();
                return;
            }

            DataTable tablaMedicos = negocioMedico.ListarMedicosPorEspecialidad(idEsp);

            ddlMedico.DataSource = tablaMedicos;
            ddlMedico.DataValueField = "Legajo_Med";
            ddlMedico.DataTextField = "NombreCompleto";
            ddlMedico.DataBind();

            ddlMedico.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione un Médico --", "0"));
        }


        protected void ddlMedico_SelectedIndexChanged1(object sender, EventArgs e)
        {
            if (ddlMedico.SelectedValue == "0")
            {
                LimpiarInterfazMedico();
                return;
            }
            lblNombreMedico.Text = ddlMedico.SelectedItem.Text;
            gvHorariosDisponibles.PageIndex = 0;
            CargarGrillaAgenda();
        }

        protected void gvHorariosDisponibles_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvHorariosDisponibles.PageIndex = e.NewPageIndex;
            CargarGrillaAgenda();
        }

        // La agenda completa (30 dias, franjas del medico, ocupado/libre)
        // la arma la base de datos con SP_ObtenerAgendaCompleta.
        private void CargarGrillaAgenda()
        {
            string legajo = ddlMedico.SelectedValue;

            if (string.IsNullOrEmpty(legajo) || legajo == "0")
            {
                LimpiarInterfazMedico();
                return;
            }

            DataTable dtAgenda = negocioTurnos.ObtenerAgendaCompleta(legajo);

            if (dtAgenda == null || dtAgenda.Rows.Count == 0)
            {
                lblMensajeAgendarTurno.Text = "El médico no tiene horarios disponibles en los próximos 30 días.";
                lblMensajeAgendarTurno.ForeColor = System.Drawing.Color.Red;
                gvHorariosDisponibles.DataSource = null;
                gvHorariosDisponibles.DataBind();
                return;
            }

            lblMensajeAgendarTurno.Text = string.Empty;
            gvHorariosDisponibles.DataSource = dtAgenda;
            gvHorariosDisponibles.DataBind();
        }


        protected void gvHorariosDisponibles_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                bool Ocupado = Convert.ToBoolean(rowView["Ocupado"]);

                if (Ocupado)
                {
                    Button btn = (Button)e.Row.FindControl("btnReservar");
                    if (btn != null)
                    {
                        btn.Enabled = false;
                        btn.Text = "Reservado";
                        btn.CssClass = "formato-btnBase btn-deshabilitado";
                    }
                }
            }
        }

        protected void gvHorariosDisponibles_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "Reservar")
            {

                if (string.IsNullOrEmpty(txtDniBuscar.Text) || txtNombrePacienteOk.Text == "Paciente inexistente")
                {
                    lblMensajeAgendarTurno.Text = "Seleccione un paciente antes de reservar.";
                    lblMensajeAgendarTurno.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                int index = Convert.ToInt32(e.CommandArgument);

                string fecha = gvHorariosDisponibles.DataKeys[index].Values["Fecha"].ToString();
                string hora = gvHorariosDisponibles.DataKeys[index].Values["Hora"].ToString();
                string legajo = ddlMedico.SelectedValue.Trim();
                string dniPaciente = txtDniBuscar.Text.Trim();

                bool operacionExitosa = negocioTurnos.InsertarNuevoTurno(legajo, dniPaciente, fecha, hora);

                if (operacionExitosa)
                {
                    CargarGrillaAgenda();
                    CargarTurnosDelPaciente(dniPaciente);

                    lblMensajeAgendarTurno.Text = "Turno reservado correctamente";
                    lblMensajeAgendarTurno.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblMensajeAgendarTurno.Text = "Error al reservar el turno. Verifique si ya fue ocupado.";
                    lblMensajeAgendarTurno.ForeColor = System.Drawing.Color.Red;
                    CargarGrillaAgenda();
                }
            }
        }

        protected void gvTurnosDelPaciente_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancelar")
            {
                int idTurno = Convert.ToInt32(e.CommandArgument);

                bool exito = negocioTurnos.CancelarTurno(idTurno);

                if (exito)
                {
                    string dni = txtDniBuscar.Text.Trim();
                    CargarTurnosDelPaciente(dni);


                    CargarGrillaAgenda();

                    lblMensajeAgendarTurno.Text = "Turno cancelado y horario liberado.";
                    lblMensajeAgendarTurno.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    lblMensajeAgendarTurno.Text = "No se pudo cancelar el turno.";
                    lblMensajeAgendarTurno.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
        private void CargarTurnosDelPaciente(string dni)
        {
            DataTable dtTurnos = negocioTurnos.ListarTurnosPaciente(dni);

            if (dtTurnos != null && dtTurnos.Rows.Count > 0)
            {
                gvTurnosDelPaciente.DataSource = dtTurnos;
                gvTurnosDelPaciente.DataBind();

                lblMensajeCancelar.Text = string.Empty;
            }
            else
            {
                gvTurnosDelPaciente.DataSource = null;
                gvTurnosDelPaciente.DataBind();

                lblMensajeCancelar.Text = "No hay turnos proximos registrados para este paciente.";
                lblMensajeCancelar.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void CargarHistorialTurnosPaciente(string dni)
        {
            DataTable dtHistorialTurnos = negocioTurnos.ListarHostorialTurnosPaciente(dni);

            if (dtHistorialTurnos != null && dtHistorialTurnos.Rows.Count > 0)
            {
                lblMensajeHistorialVacio.Text = string.Empty;
                gvHistorialTurnos.Visible = true;
                gvHistorialTurnos.DataSource = dtHistorialTurnos;
                gvHistorialTurnos.DataBind();

            }
            else
            {
                lblMensajeHistorialVacio.Text = "No hay turnos registrados para este paciente.";
                gvHistorialTurnos.Visible = false;
                gvHistorialTurnos.DataSource = null;
                gvHistorialTurnos.DataBind();
            }
        }


        protected void btnVerHistorial_Click(object sender, EventArgs e)
        {
            string dniPaciente = txtDniBuscar.Text.Trim();

            if (string.IsNullOrEmpty(dniPaciente))
            {
                LimpiarInterfazPaciente();

                return;
            }
            else
            {
                CargarHistorialTurnosPaciente(dniPaciente);
            }

        }

        protected void gvHistorialTurnos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {

            gvHistorialTurnos.PageIndex = e.NewPageIndex;
            lblMensajeHistorialVacio.Text = string.Empty;
            string dni = txtDniBuscar.Text.Trim();
            CargarHistorialTurnosPaciente(dni);
        }


        private void LimpiarInterfazMedico()
        {
            lblNombreMedico.Text = string.Empty;
            lblMensajeAgendarTurno.Text = string.Empty;
            gvHorariosDisponibles.DataSource = null;
            gvHorariosDisponibles.DataBind();
        }

        private void LimpiarInterfazPaciente()
        {
            lblMensajeAgendarTurno.Text = string.Empty;
            gvHistorialTurnos.Visible = false;
            gvHistorialTurnos.DataSource = null;
            gvHistorialTurnos.DataBind();
            lblMensajeHistorialVacio.Text = string.Empty;
        }
    }
}
