using Entidades;
using Negocio;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Vistas
{
    public partial class Medicos : System.Web.UI.Page
    {
        private NegocioMedico negocioMedico = new NegocioMedico();
        private NegocioEspecialidad negocioEspecialidad = new NegocioEspecialidad();
        private NegocioUbicacion negocioUbicacion = new NegocioUbicacion();
        private NegocioUsuario negocioUsuario = new NegocioUsuario();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEspecialidades();
                CargarProvincias();
                pnlHorarios.Visible = false;
                CargarGrillaMedicos();
                CargarDiasYHorarios();
                string fechaMaxima = DateTime.Today.ToString("yyyy-MM-dd");
                rvFechaNacimiento.MaximumValue = fechaMaxima;
            }
        }


        private void CargarEspecialidades()
        {
            DataTable tabla = negocioEspecialidad.GetEspecialidades();

            ddlEspecialidad.DataSource = tabla;
            ddlEspecialidad.DataTextField = "Descripcion_Esp";
            ddlEspecialidad.DataValueField = "Id_Especialidad";
            ddlEspecialidad.DataBind();
            ddlEspecialidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));

            ddlFiltroEspecialidad.DataSource = tabla;
            ddlFiltroEspecialidad.DataTextField = "Descripcion_Esp";
            ddlFiltroEspecialidad.DataValueField = "Id_Especialidad";
            ddlFiltroEspecialidad.DataBind();
            ddlFiltroEspecialidad.Items.Insert(0, new ListItem("Todas", "0"));
        }

        private void CargarProvincias()
        {
            ddlProvincia.DataSource = negocioUbicacion.ListarProvincias();
            ddlProvincia.DataValueField = "Id_Provincia";
            ddlProvincia.DataTextField = "Descripcion_Prov";
            ddlProvincia.DataBind();
            ddlProvincia.Items.Insert(0, new ListItem("--Seleccionar--", ""));
        }

        protected void ddlProvincia_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlLocalidad.Items.Clear();

            if (!string.IsNullOrEmpty(ddlProvincia.SelectedValue))
            {
                int idProvincia = Convert.ToInt32(ddlProvincia.SelectedValue);
                ddlLocalidad.DataSource = negocioUbicacion.ListarLocalidadesPorProvincia(idProvincia);
                ddlLocalidad.DataValueField = "Id_Localidad";
                ddlLocalidad.DataTextField = "Descripcion_Loc";
                ddlLocalidad.DataBind();
            }

            ddlLocalidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));
        }

        private void CargarGrillaMedicos()
        {
            ViewState["FiltroBusqueda"] = null; // la carga completa resetea el filtro de texto
            gvMedicos.DataSource = negocioMedico.ListarMedicos();
            gvMedicos.DataBind();
        }

        protected void gvMedicos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            lblMensajeGrilla.Text = "";
            gvMedicos.PageIndex = e.NewPageIndex;
            gvMedicos.DataSource = ObtenerDatosFiltrados();
            gvMedicos.DataBind();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            MostrarMensajeGrilla("", "");
            ViewState["FiltroBusqueda"] = txtBuscar.Text.Trim();
            gvMedicos.PageIndex = 0;
            gvMedicos.DataSource = ObtenerDatosFiltrados();
            gvMedicos.DataBind();
            lblConfirmacion.Text = "";
        }
        private DataTable ObtenerDatosFiltrados()
        {
            // El texto buscado se guarda en ViewState porque txtBuscar se limpia
            // despues de buscar: sin esto, al cambiar de pagina se perdia el filtro.
            string texto = ViewState["FiltroBusqueda"] != null ? ViewState["FiltroBusqueda"].ToString() : "";
            int idEspecialidad = Convert.ToInt32(ddlFiltroEspecialidad.SelectedValue);
            int estado = Convert.ToInt32(ddlFiltroEstado.SelectedValue);

            return negocioMedico.BuscarMedicos(texto, idEspecialidad, estado);
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            MostrarMensaje("", "");
            lblMensajeGrilla.Text = "";

            if (!Page.IsValid) return;



            EntidadMedico medico = ObtenerMedicoDesdeFormulario();

            bool modoEdicion = ViewState["ModoEdicion"] != null && (bool)ViewState["ModoEdicion"];

            int resultado;

            bool quiereCrearUsuario = QuiereCrearUsuario();


            if (!ValidarDatosUsuario(modoEdicion, quiereCrearUsuario))
                return;


            if (modoEdicion)
            {
                resultado = negocioMedico.ModificarMedico(medico);
            }
            else
            {
                if (quiereCrearUsuario && negocioUsuario.ExisteUsuario(txtUsuario.Text.Trim()))
                {
                    MostrarMensaje("Ya existe ese nombre de usuario.", "msg-error");
                    return;
                }
                resultado = negocioMedico.AgregarMedico(medico);
            }

            if (resultado == 1)
            {
                bool usuarioOk = CrearUsuarioMedico(quiereCrearUsuario, medico.LegajoMed);

                // El medico ya quedo guardado en la base: la grilla se refresca
                // siempre, incluso si fallo la creacion del usuario.
                CargarGrillaMedicos();

                if (!usuarioOk)
                    return; // el mensaje de error ya quedo seteado por CrearUsuarioMedicoSiCorresponde

                string mensaje = ObtenerMensajeExito(modoEdicion, quiereCrearUsuario);
                LimpiarFormulario();
                MostrarMensaje(mensaje, "msg-ok");
            }
            else if (resultado == 0)
            {
                MostrarMensaje("Ya existe un médico con ese legajo o DNI.", "msg-error");
            }
            else
            {
                MostrarMensaje("Hubo un problema al conectar con la base de datos.", "msg-error");
            }

        }
        private EntidadMedico ObtenerMedicoDesdeFormulario()
        {
            EntidadMedico medico = new EntidadMedico();

            medico.LegajoMed = txtLegajo.Text.Trim();
            medico.Dni = txtDni.Text.Trim();
            medico.Nombre = txtNombre.Text.Trim();
            medico.Apellido = txtApellido.Text.Trim();
            medico.Sexo = ddlSexo.SelectedValue;
            medico.Nacionalidad = ddlNacionalidad.SelectedValue;
            medico.FechaNacimiento = Convert.ToDateTime(txtFechaNacimiento.Text);
            medico.Direccion = txtDireccion.Text.Trim();
            medico.IdLocalidad = Convert.ToInt32(ddlLocalidad.SelectedValue);
            medico.CorreoElectronico = txtCorreo.Text.Trim();
            medico.Telefono = txtTelefono.Text.Trim();
            medico.IdEspecialidadMed = Convert.ToInt32(ddlEspecialidad.SelectedValue);

            return medico;
        }
        private bool QuiereCrearUsuario()
        {
            bool cambioUsuario = ViewState["UsuarioOriginal"] == null
                || txtUsuario.Text.Trim() != ViewState["UsuarioOriginal"].ToString();

            return cambioUsuario
                || !string.IsNullOrWhiteSpace(txtPass.Text)
                || !string.IsNullOrWhiteSpace(txtPassConfirm.Text);
        }
        private bool ValidarDatosUsuario(bool modoEdicion, bool quiereCrearUsuario)
        {
            bool completoUsuario = !string.IsNullOrWhiteSpace(txtUsuario.Text);
            bool completoPass = !string.IsNullOrWhiteSpace(txtPass.Text);
            bool completoConfirm = !string.IsNullOrWhiteSpace(txtPassConfirm.Text);

            if (!modoEdicion && !quiereCrearUsuario)
            {
                MostrarMensaje("Para registrar un médico debe completar usuario, contraseña y confirmación.", "msg-error");
                return false;
            }

            if (modoEdicion && !quiereCrearUsuario)
                return true;

            if (!completoUsuario || !completoPass || !completoConfirm)
            {
                MostrarMensaje("Para crear el usuario debe completar usuario, contraseña y confirmación.", "msg-error");
                return false;
            }

            return true;
        }
        private bool CrearUsuarioMedico(bool quiereCrearUsuario, string legajoMed)
        {
            if (!quiereCrearUsuario)
                return true;

            int resultadoUsuario;

            if (negocioUsuario.ExisteUsuarioParaMedico(legajoMed))
            {
                resultadoUsuario = negocioUsuario.ModificarUsuarioMedico(
                    txtUsuario.Text.Trim(),
                    txtPass.Text.Trim(),
                    legajoMed
                );
            }
            else
            {
                if (negocioUsuario.ExisteUsuario(txtUsuario.Text.Trim()))
                {
                    MostrarMensaje("Ya existe un usuario con ese nombre.", "msg-error");
                    return false;
                }

                resultadoUsuario = negocioUsuario.AgregarUsuarioMedico(
                    txtUsuario.Text.Trim(),
                    txtPass.Text.Trim(),
                    legajoMed
                );
            }

            if (resultadoUsuario <= 0)
            {
                MostrarMensaje("No se pudo guardar el usuario. Puede que el nombre de usuario ya exista.", "msg-error");
                return false;
            }

            return true;
        }
        private string ObtenerMensajeExito(bool modoEdicion, bool quiereCrearUsuario)
        {
            if (modoEdicion && quiereCrearUsuario)
                return "Médico modificado y usuario guardado correctamente.";

            if (modoEdicion)
                return "Médico modificado correctamente.";

            if (quiereCrearUsuario)
                return "Médico y usuario registrados correctamente.";

            return "Médico registrado correctamente.";
        }


        private void MostrarMensaje(string mensaje, string cssClass)
        {
            lblConfirmacion.Text = mensaje;
            lblConfirmacion.CssClass = cssClass;
        }
        private void MostrarMensajeGrilla(string mensaje, string cssClass)
        {
            lblMensajeGrilla.Text = mensaje;
            lblMensajeGrilla.CssClass = cssClass;
        }
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        private void LimpiarFormulario()
        {
            txtLegajo.Text = "";
            txtDni.Text = "";
            txtNombre.Text = "";
            txtApellido.Text = "";
            ddlSexo.SelectedIndex = 0;
            ddlNacionalidad.SelectedIndex = 0;
            txtFechaNacimiento.Text = "";
            txtDireccion.Text = "";
            ddlProvincia.SelectedIndex = 0;
            ddlLocalidad.Items.Clear();
            ddlLocalidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));
            txtCorreo.Text = "";
            txtTelefono.Text = "";
            ddlEspecialidad.SelectedIndex = 0;
            txtUsuario.Text = "";
            txtPass.Text = "";
            txtPassConfirm.Text = "";
            txtUsuario.Enabled = true;
            txtPass.Enabled = true;
            txtPassConfirm.Enabled = true;
            txtLegajo.Enabled = true;
            txtDni.Enabled = true;
            if (ddlDiaAtencion.Items.Count > 0)
                ddlDiaAtencion.SelectedIndex = 0;

            if (ddlHorarioAtencion.Items.Count > 0)
                ddlHorarioAtencion.SelectedIndex = 0;

            gvHorariosMedico.DataSource = null;
            gvHorariosMedico.DataBind();

            lblConfirmacion.Text = "";
            lblMensajeGrilla.Text = "";

            ViewState["ModoEdicion"] = false;
            pnlHorarios.Visible = false;


        }

        protected void gvMedicos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            lblConfirmacion.Text = "";

            if (e.CommandName == "BajaMedico")
            {
                int indice = Convert.ToInt32(e.CommandArgument);
                string legajo = gvMedicos.DataKeys[indice].Value.ToString();

                int resultado = negocioMedico.BajaLogicaMedico(legajo);

                if (resultado > 0)
                {
                    MostrarMensajeGrilla("Médico dado de baja correctamente.", "msg-ok");
                    CargarGrillaMedicos();
                }
                else
                {
                    MostrarMensajeGrilla("No se pudo dar de baja el médico.", "msg-error");
                }
            }

            if (e.CommandName == "ReactivarMedico")
            {
                int indice = Convert.ToInt32(e.CommandArgument);
                string legajo = gvMedicos.DataKeys[indice].Value.ToString();

                int resultado = negocioMedico.ReactivarMedico(legajo);

                if (resultado > 0)
                {
                    MostrarMensajeGrilla("Médico dado de alta correctamente.", "msg-ok");
                    CargarGrillaMedicos();
                }
                else
                {
                    MostrarMensajeGrilla("No se pudo dar de alta el médico.", "msg-error");
                }
            }

            if (e.CommandName == "SeleccionarModificar")
            {
                int indice = Convert.ToInt32(e.CommandArgument);
                string legajo = gvMedicos.DataKeys[indice].Value.ToString();

                CargarMedicoEnFormulario(legajo);


                ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "scrollFormularioMedico",
                "setTimeout(function(){ window.scrollTo({ top: document.getElementById('formularioMedico').offsetTop, behavior: 'smooth' }); }, 300);",
                true

                );
            }
        }
        private void CargarMedicoEnFormulario(string legajo)
        {
            System.Data.DataTable tabla = negocioMedico.ObtenerMedicoPorLegajo(legajo);

            if (tabla == null || tabla.Rows.Count == 0)
                return;

            System.Data.DataRow fila = tabla.Rows[0];

            txtLegajo.Text = fila["Legajo_Med"].ToString().Trim();
            txtLegajo.Enabled = false;

            txtDni.Text = fila["Dni_Med"].ToString();
            txtDni.Enabled = false;
            txtNombre.Text = fila["Nombre_Med"].ToString();
            txtApellido.Text = fila["Apellido_Med"].ToString();
            ddlSexo.SelectedValue = fila["Sexo_Med"].ToString();
            ddlNacionalidad.SelectedValue = fila["Nacionalidad_Med"].ToString();

            DateTime fechaNacimiento = Convert.ToDateTime(fila["FechaNacimiento_Med"]);
            txtFechaNacimiento.Text = fechaNacimiento.ToString("yyyy-MM-dd");

            txtDireccion.Text = fila["Direccion_Med"].ToString();

            ddlProvincia.SelectedValue = fila["Id_Provincia_Loc"].ToString();
            int idProvincia = Convert.ToInt32(fila["Id_Provincia_Loc"]);
            ddlLocalidad.DataSource = negocioUbicacion.ListarLocalidadesPorProvincia(idProvincia);
            ddlLocalidad.DataValueField = "Id_Localidad";
            ddlLocalidad.DataTextField = "Descripcion_Loc";
            ddlLocalidad.DataBind();
            ddlLocalidad.Items.Insert(0, new ListItem("--Seleccionar--", ""));
            ddlLocalidad.SelectedValue = fila["Id_Localidad_Med"].ToString();

            txtCorreo.Text = fila["CorreoElectronico_Med"].ToString();
            txtTelefono.Text = fila["Telefono_Med"].ToString();
            ddlEspecialidad.SelectedValue = fila["Id_Especialidad_Med"].ToString();


            string usuarioMedico = negocioUsuario.ObtenerUsuarioPorMedico(legajo);

            txtUsuario.Text = usuarioMedico;
            txtPass.Text = "";
            txtPassConfirm.Text = "";

            ViewState["UsuarioOriginal"] = usuarioMedico;

            txtUsuario.Enabled = true;
            txtPass.Enabled = true;
            txtPassConfirm.Enabled = true;

            ViewState["ModoEdicion"] = true;
            pnlHorarios.Visible = true;
            CargarHorariosMedico(legajo);
        }

        private void CargarDiasYHorarios()
        {
            ddlDiaAtencion.DataSource = negocioMedico.ListarDiasSemana();
            ddlDiaAtencion.DataTextField = "Descripcion_Dia";
            ddlDiaAtencion.DataValueField = "Id_Dia";
            ddlDiaAtencion.DataBind();
            ddlDiaAtencion.Items.Insert(0, new ListItem("--Seleccionar--", ""));

            ddlHorarioAtencion.DataSource = negocioMedico.ListarHorariosAtencion();
            ddlHorarioAtencion.DataTextField = "DescripcionHorario";
            ddlHorarioAtencion.DataValueField = "Id_Horario";
            ddlHorarioAtencion.DataBind();
            ddlHorarioAtencion.Items.Insert(0, new ListItem("--Seleccionar--", ""));
        }
        protected void btnAgregarHorario_Click(object sender, EventArgs e)
        {
            lblConfirmacion.Text = "";

            if (string.IsNullOrWhiteSpace(txtLegajo.Text) ||
                string.IsNullOrWhiteSpace(ddlDiaAtencion.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlHorarioAtencion.SelectedValue))
            {
                MostrarMensaje("Seleccione un día y un horario.", "msg-error");
                return;
            }

            int resultado = negocioMedico.AgregarHorarioMedico(
                txtLegajo.Text.Trim(),
                Convert.ToInt32(ddlDiaAtencion.SelectedValue),
                ddlHorarioAtencion.SelectedValue
            );

            if (resultado == 1)
            {
                MostrarMensaje("Horario agregado correctamente.", "msg-ok");

                CargarHorariosMedico(txtLegajo.Text.Trim());

                ddlDiaAtencion.SelectedIndex = 0;
                ddlHorarioAtencion.SelectedIndex = 0;
            }
            else if (resultado == 2)
            {
                MostrarMensaje("Ese horario ya esta asignado al médico.", "msg-error");
            }
            else
            {
                MostrarMensaje("No se pudo asignar el horario.", "msg-error");
            }
        }
        protected void gvHorariosMedico_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EliminarHorario")
            {
                int indice = Convert.ToInt32(e.CommandArgument);

                int idDia = Convert.ToInt32(gvHorariosMedico.DataKeys[indice]["Id_Dia"]);
                string idHorario = gvHorariosMedico.DataKeys[indice]["Id_Horario"].ToString();

                string legajo = txtLegajo.Text.Trim();

                int resultado = negocioMedico.EliminarHorarioMedico(legajo, idDia, idHorario);

                if (resultado > 0)
                {
                    MostrarMensaje("Horario eliminado correctamente.", "msg-ok");
                    CargarHorariosMedico(legajo);
                }
                else
                {
                    MostrarMensaje("No se pudo eliminar el horario.", "msg-error");
                }
            }
        }
        private void CargarHorariosMedico(string legajo)
        {
            gvHorariosMedico.DataSource = negocioMedico.ListarHorariosPorMedico(legajo);
            gvHorariosMedico.DataBind();
        }
    }
}