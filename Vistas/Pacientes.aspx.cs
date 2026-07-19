using Entidades;
using Negocio;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Vistas
{
    public partial class Pacientes : System.Web.UI.Page
    {
        private NegocioUbicacion negUbi = new NegocioUbicacion();
        private NegocioPaciente negPac = new NegocioPaciente();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarProvincias();
                CargarGrilla();
                ViewState["ModoEdicion"] = false;
                string fechaMaxima = DateTime.Today.ToString("yyyy-MM-dd");
                rvFecha.MaximumValue = fechaMaxima;
            }
        }

        private void CargarGrilla()
        {
            ViewState["FiltroBusqueda"] = null; // la carga completa resetea el filtro de texto
            DataTable tabla = negPac.ListarPacientes();
            gvPacientes.DataSource = tabla;
            gvPacientes.DataBind();
        }

        protected void gvPacientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPacientes.PageIndex = e.NewPageIndex;
            gvPacientes.DataSource = ObtenerDatosFiltrados();
            gvPacientes.DataBind();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            ViewState["FiltroBusqueda"] = txtBuscar.Text.Trim();
            gvPacientes.PageIndex = 0;
            gvPacientes.DataSource = ObtenerDatosFiltrados();
            gvPacientes.DataBind();
            lblConfirmacion.Text = "";
        }

        private DataTable ObtenerDatosFiltrados()
        {
            // El texto buscado se guarda en ViewState porque txtBuscar se limpia
            // despues de buscar: sin esto, al cambiar de pagina se perdia el filtro.
            string busqueda = ViewState["FiltroBusqueda"] != null ? ViewState["FiltroBusqueda"].ToString() : "";
            string sexo = ddlFiltroSexo.SelectedValue;
            int estado = Convert.ToInt32(ddlFiltroEstado.SelectedValue);

            return negPac.FiltrarPacientes(busqueda, sexo, estado);
        }

        private void CargarProvincias()
        {
            DataTable tabla = negUbi.ListarProvincias();
            ddlProvincia.DataSource = tabla;
            ddlProvincia.DataTextField = "Descripcion_Prov";
            ddlProvincia.DataValueField = "Id_Provincia";
            ddlProvincia.DataBind();
            ddlProvincia.Items.Insert(0, new ListItem("--Seleccionar--", ""));
        }

        protected void ddlProvincia_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlLocalidad.Items.Clear();
            if (!string.IsNullOrEmpty(ddlProvincia.SelectedValue))
            {
                int idProvincia = Convert.ToInt32(ddlProvincia.SelectedValue);
                DataTable tabla = negUbi.ListarLocalidadesPorProvincia(idProvincia);

                ddlLocalidad.DataSource = tabla;
                ddlLocalidad.DataTextField = "Descripcion_Loc";
                ddlLocalidad.DataValueField = "Id_Localidad";
                ddlLocalidad.DataBind();
            }
            ddlLocalidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));
        }


        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            EntidadPaciente p = new EntidadPaciente();
            p.Dni = txtDni.Text.Trim();
            p.Nombre = txtNombre.Text.Trim();
            p.Apellido = txtApellido.Text.Trim();
            p.Sexo = ddlSexo.SelectedValue;
            p.Nacionalidad = ddlNacionalidad.SelectedValue;
            p.FechaNacimiento = Convert.ToDateTime(txtFechaNacimiento.Text);
            p.Direccion = txtDireccion.Text.Trim();
            p.IdLocalidad = Convert.ToInt32(ddlLocalidad.SelectedValue);
            p.CorreoElectronico = txtCorreoElectronico.Text.Trim();
            p.Telefono = txtTelefono.Text.Trim();

            bool modoEdicion = ViewState["ModoEdicion"] != null && (bool)ViewState["ModoEdicion"];
            int resultado;

            if (modoEdicion)
            {
                resultado = negPac.ModificarPaciente(p);
            }
            else
            {
                resultado = negPac.AltaPaciente(p);
            }

            if (resultado == 1)
            {
                LimpiarFormulario();
                CargarGrilla();

                lblConfirmacion.Text = modoEdicion ? "Paciente modificado exitosamente." : "Paciente registrado exitosamente.";
                lblConfirmacion.CssClass = "msg-ok";
            }
            else if (resultado == 0)
            {
                lblConfirmacion.Text = modoEdicion ? "No se pudieron actualizar los datos del paciente." : "Ya existe un paciente registrado con ese DNI.";
                lblConfirmacion.CssClass = "msg-error";
            }
            else
            {
                lblConfirmacion.Text = "Hubo un problema al conectar con la base de datos.";
                lblConfirmacion.CssClass = "msg-error";
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        private void LimpiarFormulario()
        {
            txtDni.Text = "";
            txtDni.Enabled = true;
            txtNombre.Text = "";
            txtApellido.Text = "";
            ddlSexo.SelectedIndex = 0;
            ddlNacionalidad.SelectedIndex = 0;
            txtFechaNacimiento.Text = "";
            txtDireccion.Text = "";
            ddlProvincia.SelectedIndex = 0;
            ddlLocalidad.Items.Clear();
            ddlLocalidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));
            txtCorreoElectronico.Text = "";
            txtTelefono.Text = "";

            lblConfirmacion.Text = "";
            ViewState["ModoEdicion"] = false;
            btnLimpiar.Text = "Limpiar";
        }

        protected void gvPacientes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            lblConfirmacion.Text = "";

            if (e.CommandName == "BajaPaciente")
            {
                int indice = Convert.ToInt32(e.CommandArgument);
                string dni = gvPacientes.DataKeys[indice].Value.ToString();

                int resultado = negPac.BajaPaciente(dni);

                if (resultado > 0)
                {
                    lblConfirmacion.Text = "Paciente dado de baja correctamente.";
                    lblConfirmacion.CssClass = "msg-ok";
                    CargarGrilla();
                }
                else
                {
                    lblConfirmacion.Text = "No se pudo dar de baja al paciente.";
                    lblConfirmacion.CssClass = "msg-error";
                }
            }

            if (e.CommandName == "SeleccionarModificar")
            {
                int indice = Convert.ToInt32(e.CommandArgument);
                string dni = gvPacientes.DataKeys[indice].Value.ToString();

                CargarPacienteEnFormulario(dni);


                ScriptManager.RegisterStartupScript(
                    this,
                    GetType(),
                    "scrollFormularioPaciente",
                    "setTimeout(function(){ window.scrollTo({ top: document.getElementById('formularioPaciente').offsetTop, behavior: 'smooth' }); }, 300);",
                    true
                );
            }

            if (e.CommandName == "ReactivarPaciente")
            {
                int indice = Convert.ToInt32(e.CommandArgument);
                string dni = gvPacientes.DataKeys[indice].Value.ToString();

                int resultado = negPac.ReactivarPaciente(dni);

                if (resultado > 0)
                {
                    lblConfirmacion.Text = "Paciente dado de alta correctamente.";
                    lblConfirmacion.CssClass = "msg-ok";
                    CargarGrilla();
                }
                else
                {
                    lblConfirmacion.Text = "No se pudo dar de alta al paciente.";
                    lblConfirmacion.CssClass = "msg-error";
                }
            }
        }


        private void CargarPacienteEnFormulario(string dni)
        {

            DataTable tabla = negPac.FiltrarPacientes(dni, "", -1);
            if (tabla == null || tabla.Rows.Count == 0) return;

            DataRow fila = tabla.Rows[0];

            txtDni.Text = fila["DNI"].ToString().Trim();
            txtDni.Enabled = false;

            txtNombre.Text = fila["Nombre"].ToString();
            txtApellido.Text = fila["Apellido"].ToString();
            ddlSexo.SelectedValue = fila["Sexo"].ToString();
            ddlNacionalidad.SelectedValue = fila["Nacionalidad"].ToString();

            if (fila["Fecha de Nacimiento"] != DBNull.Value)
            {
                DateTime fechaNac = Convert.ToDateTime(fila["Fecha de Nacimiento"]);
                txtFechaNacimiento.Text = fechaNac.ToString("yyyy-MM-dd");
            }

            txtDireccion.Text = fila["Dirección"].ToString();


            if (fila["Provincia"] != DBNull.Value && fila["IdLocalidad"] != DBNull.Value)
            {
                string nombreProvincia = fila["Provincia"].ToString();
                int idLocalidadActual = Convert.ToInt32(fila["IdLocalidad"]);

                DataTable dtProvincias = negUbi.ListarProvincias();

                string idProvinciaStr = ObtenerIdProvinciaPorNombre(nombreProvincia, dtProvincias);

                if (!string.IsNullOrEmpty(idProvinciaStr))
                {

                    ddlProvincia.SelectedValue = idProvinciaStr;

                    int idProvincia = Convert.ToInt32(idProvinciaStr);
                    ddlLocalidad.DataSource = negUbi.ListarLocalidadesPorProvincia(idProvincia);
                    ddlLocalidad.DataValueField = "Id_Localidad";
                    ddlLocalidad.DataTextField = "Descripcion_Loc";
                    ddlLocalidad.DataBind();
                    ddlLocalidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));

                    ddlLocalidad.SelectedValue = idLocalidadActual.ToString();
                }
            }

            txtCorreoElectronico.Text = fila["Correo Electrónico"].ToString();
            txtTelefono.Text = fila["Teléfono"].ToString();

            ViewState["ModoEdicion"] = true;
            btnLimpiar.Text = "Cancelar";
        }

        private string ObtenerIdProvinciaPorNombre(string nombreProvincia, DataTable provincias)
        {
            foreach (DataRow fila in provincias.Rows)
            {
                if (fila["Descripcion_Prov"].ToString() == nombreProvincia)
                    return fila["Id_Provincia"].ToString();
            }
            return "";
        }
    }
}