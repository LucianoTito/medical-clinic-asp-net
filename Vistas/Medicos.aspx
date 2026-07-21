<%@ Page Title="Gestión de Médicos" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Medicos.aspx.cs" Inherits="Vistas.Medicos" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Gestión de Médicos</h2>
    <p>&nbsp;</p>

    <asp:UpdatePanel ID="UpdatePanelMedicos" runat="server">
        <ContentTemplate>

    <%-- ========================= DATOS DEL MÉDICO (ALTA) ========================= --%>
            <div id="formularioMedico"></div>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Datos del médico</div>
                <asp:Panel ID="pnlAltaMedico" runat="server" DefaultButton="btnGuardar">

                    <div class="subtitulo-medicos" style="font-weight: bold; margin-bottom: 10px; color: #0B3D6F;">Datos personales</div>
                    <table class="tabla-pacientes">
                        <tr>
                            <td style="width: 33%;">
                                <asp:Label ID="lblLegajo" runat="server" Text="Legajo" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 33%;">
                                <asp:Label ID="lblDni" runat="server" Text="DNI" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 33%;">
                                <asp:Label ID="lblSexo" runat="server" Text="Sexo" CssClass="fomato-Label"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtLegajo" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Ej: MED0001"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLegajo" runat="server" ControlToValidate="txtLegajo" CssClass="validador-error" ErrorMessage="El legajo es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revLegajo" runat="server" ControlToValidate="txtLegajo" CssClass="validador-error" ErrorMessage="Formato de legajo inválido (ej: MED0001)." ValidationExpression="^MED\d{4}$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtDni" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Ej: 30123456"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDni" runat="server" ControlToValidate="txtDni" CssClass="validador-error" ErrorMessage="El DNI es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revDni" runat="server" ControlToValidate="txtDni" CssClass="validador-error" ErrorMessage="Solo números (7 u 8 dígitos)." ValidationExpression="^\d{7,8}$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlSexo" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="">--Seleccionar--</asp:ListItem>
                                    <asp:ListItem>Masculino</asp:ListItem>
                                    <asp:ListItem>Femenino</asp:ListItem>
                                    <asp:ListItem>Otro</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvSexo" runat="server" ControlToValidate="ddlSexo" InitialValue="" CssClass="validador-error" ErrorMessage="Seleccione el sexo." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblNombre" runat="server" Text="Nombre" CssClass="fomato-Label"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblApellido" runat="server" Text="Apellido" CssClass="fomato-Label"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblFechaNacimiento" runat="server" Text="Fecha de nacimiento" CssClass="fomato-Label"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Nombre del médico"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" CssClass="validador-error" ErrorMessage="El nombre es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revNombre" runat="server" ControlToValidate="txtNombre" CssClass="validador-error" ErrorMessage="El nombre solo puede contener letras y espacios." ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtApellido" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Apellido del médico"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" CssClass="validador-error" ErrorMessage="El apellido es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revApellido" runat="server" ControlToValidate="txtApellido" CssClass="validador-error" ErrorMessage="El apellido solo puede contener letras y espacios." ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFechaNacimiento" runat="server" ControlToValidate="txtFechaNacimiento" CssClass="validador-error" ErrorMessage="La fecha es obligatoria." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvFechaNacimiento" runat="server" ControlToValidate="txtFechaNacimiento" CssClass="validador-error" ErrorMessage="La fecha debe estar entre 01/01/1900 y hoy." MinimumValue="1900-01-01" Type="Date" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RangeValidator>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblNacionalidad" runat="server" Text="Nacionalidad" CssClass="fomato-Label"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblCorreo" runat="server" Text="Correo electrónico" CssClass="fomato-Label"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblTelefono" runat="server" Text="Teléfono" CssClass="fomato-Label"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList ID="ddlNacionalidad" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="">--Seleccionar--</asp:ListItem>
                                    <asp:ListItem>Argentina</asp:ListItem>
                                    <asp:ListItem>Bolivia</asp:ListItem>
                                    <asp:ListItem>Brasil</asp:ListItem>
                                    <asp:ListItem>Chile</asp:ListItem>
                                    <asp:ListItem>Paraguay</asp:ListItem>
                                    <asp:ListItem>Uruguay</asp:ListItem>
                                    <asp:ListItem>Otros</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvNacionalidad" runat="server" ControlToValidate="ddlNacionalidad" CssClass="validador-error" InitialValue="" ErrorMessage="La nacionalidad es obligatoria." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtCorreo" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Email" placeholder="ejemplo@mail.com"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtCorreo" CssClass="validador-error" ErrorMessage="El correo es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revCorreo" runat="server" ControlToValidate="txtCorreo" CssClass="validador-error" ErrorMessage="Formato de correo electrónico inválido." ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtTelefono" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="1155556666"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono" CssClass="validador-error" ErrorMessage="El teléfono es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" CssClass="validador-error" Display="Dynamic" ErrorMessage="Solo números (entre 10 y 15 dígitos)." Font-Size="Small" ForeColor="Red" ValidationExpression="^\d{10,15}$" ValidationGroup="GrupoAltaMedico"></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                    </table>
                    <br />

                    <div class="subtitulo-medicos" style="font-weight: bold; margin-bottom: 10px; color: #0B3D6F;">Dirección</div>
                    <table class="tabla-pacientes">
                        <tr>
                            <td style="width: 50%;">
                                <asp:Label ID="lblDireccion" runat="server" Text="Dirección" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 25%;">
                                <asp:Label ID="lblProvincia" runat="server" Text="Provincia" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 25%;">
                                <asp:Label ID="lblLocalidad" runat="server" Text="Localidad" CssClass="fomato-Label"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Calle y número"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" CssClass="validador-error" ErrorMessage="La dirección es obligatoria." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlProvincia" runat="server" CssClass="fomato-TextBox-Ddl" AutoPostBack="True" OnSelectedIndexChanged="ddlProvincia_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvProvincia" runat="server" ControlToValidate="ddlProvincia" InitialValue="" CssClass="validador-error" ErrorMessage="Seleccione provincia." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlLocalidad" runat="server" CssClass="fomato-TextBox-Ddl">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvLocalidad" runat="server" ControlToValidate="ddlLocalidad" InitialValue="" CssClass="validador-error" ErrorMessage="Seleccione localidad." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                    <br />

                    <div class="subtitulo-medicos" style="font-weight: bold; margin-bottom: 10px; color: #0B3D6F;">Especialidad</div>
                    <table class="tabla-pacientes">
                        <tr>
                            <td style="width: 33%;">
                                <asp:Label ID="lblEspecialidad" runat="server" Text="Especialidad" CssClass="fomato-Label"></asp:Label></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:DropDownList ID="ddlEspecialidad" runat="server" CssClass="fomato-TextBox-Ddl">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvEspecialidad" runat="server" ControlToValidate="ddlEspecialidad" InitialValue="" CssClass="validador-error" ErrorMessage="Seleccione una especialidad." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:RequiredFieldValidator>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                    <br />
                    <asp:Panel ID="pnlHorarios" runat="server">
                        <div class="subtitulo-medicos">Días y horarios de atención</div>

                        <table class="tabla-medicos">
                            <tr>
                                <td style="width: 35%;">
                                    <asp:Label ID="lblDiaAtencion" runat="server" Text="Día" CssClass="fomato-Label"></asp:Label>
                                </td>
                                <td style="width: 35%;">
                                    <asp:Label ID="lblHorarioAtencion" runat="server" Text="Horario" CssClass="fomato-Label"></asp:Label>
                                </td>
                                <td style="width: 30%;"></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlDiaAtencion" runat="server" CssClass="fomato-TextBox-Ddl"></asp:DropDownList>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlHorarioAtencion" runat="server" CssClass="fomato-TextBox-Ddl"></asp:DropDownList>
                                </td>
                                <td style="vertical-align: bottom;">
                                    <asp:Button ID="btnAgregarHorario" runat="server" Text="Agregar horario"
                                        CssClass="formato-btnBase formato1-btn"
                                        CausesValidation="False"
                                        OnClick="btnAgregarHorario_Click" />
                                </td>
                            </tr>
                        </table>
                        <asp:GridView ID="gvHorariosMedico" runat="server"
                            CssClass="custom-grid"
                            AutoGenerateColumns="False"
                            Width="100%"
                            DataKeyNames="Id_Dia,Id_Horario"
                            OnRowCommand="gvHorariosMedico_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="Descripcion_Dia" HeaderText="Día" />
                                <asp:BoundField DataField="Horario" HeaderText="Horario" />

                                <asp:TemplateField HeaderText="Acción">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEliminarHorario" runat="server"
                                            Text="Eliminar"
                                            CssClass="formato-btnBase formato2-btn"
                                            CommandName="EliminarHorario"
                                            CommandArgument='<%# ((GridViewRow)Container).RowIndex %>'
                                            CausesValidation="False"
                                            OnClientClick="return confirm('¿Está seguro que desea eliminar este horario?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                    <div class="subtitulo-medicos" style="font-weight: bold; margin-bottom: 10px; color: #0B3D6F;">Credenciales de acceso</div>
                    <table class="tabla-pacientes">
                        <tr>
                            <td style="width: 33%;">
                                <asp:Label ID="lblUsuario" runat="server" Text="Usuario" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 33%;">
                                <asp:Label ID="lblPass" runat="server" Text="Contraseña" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 33%;">
                                <asp:Label ID="lblPassConfirm" runat="server" Text="Confirmar contraseña" CssClass="fomato-Label"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtUsuario" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Nombre de usuario"></asp:TextBox></td>
                            <td>
                                <asp:TextBox ID="txtPass" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Password" placeholder="••••••••"></asp:TextBox></td>
                            <td>
                                <asp:TextBox ID="txtPassConfirm" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                                <asp:CompareValidator ID="cmpPass" runat="server" ControlToValidate="txtPassConfirm" ControlToCompare="txtPass" CssClass="validador-error" ErrorMessage="Las contraseñas no coinciden." Operator="Equal" Type="String" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaMedico"></asp:CompareValidator>
                            </td>
                        </tr>
                    </table>
                    <br />

                    <div class="formato-btnAlineados">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="formato-btnBase formato1-btn" OnClick="btnGuardar_Click" ValidationGroup="GrupoAltaMedico" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="formato-btnBase formato2-btn" CausesValidation="False" OnClick="btnLimpiar_Click" />
                        <br />
                        <br />
                        <asp:Label ID="lblConfirmacion" runat="server"></asp:Label>
                    </div>
                </asp:Panel>
            </div>

    <%-- ========================= BUSCAR MÉDICO ========================= --%>

            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Buscar médico</div>
                <asp:Panel ID="pnlBusquedaMedicos" runat="server" DefaultButton="btnBuscar">
                    <table class="tabla-pacientes">
                        <tr>
                            <td style="width: 40%;">
                                <asp:Label ID="lblBuscar" runat="server" Text="Buscar" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 20%;">
                                <asp:Label ID="lblFiltroEspecialidad" runat="server" Text="Especialidad" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 20%;">
                                <asp:Label ID="lblFiltroEstado" runat="server" Text="Estado" CssClass="fomato-Label"></asp:Label></td>
                            <td style="width: 20%;"></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtBuscar" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Nombre, apellido, legajo o DNI..."></asp:TextBox>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlFiltroEspecialidad" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="">Todas</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="-1">Todos</asp:ListItem>
                                    <asp:ListItem Value="1">Activo</asp:ListItem>
                                    <asp:ListItem Value="0">Inactivo</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="vertical-align: bottom;">
                                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="formato-btnBase formato1-btn" CausesValidation="False" OnClick="btnBuscar_Click" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

    <%-- ========================= LISTADO DE MÉDICOS ========================= --%>
    

    <div class="formato-Bloque-Contenedor">
        <div class="formato-Titulo">Listado de médicos</div>
        <asp:Label ID="lblMensajeGrilla" runat="server" CssClass="mensaje-grilla"></asp:Label>
        <div class="contenedor-grilla">
            <asp:GridView ID="gvMedicos" runat="server"
                CssClass="custom-grid"
                Width="100%"
                GridLines="None" 
                AllowPaging="True"
                PageSize="5"
                AutoGenerateColumns="True"
                DataKeyNames="Legajo"
                OnPageIndexChanging="gvMedicos_PageIndexChanging"
                OnRowCommand="gvMedicos_RowCommand" EmptyDataText="No existen datos que coincidan con los criterios de busqueda utilizados.">
                <Columns>
                    <asp:TemplateField HeaderText="Acción">
                        <ItemTemplate>
                            <asp:Button ID="btnSeleccionarModificar" runat="server"
                                Text="Modificar"
                                CssClass="formato-btnBase formato1-btn"
                                CommandName="SeleccionarModificar"
                                CommandArgument='<%# ((GridViewRow)Container).RowIndex %>'
                                CausesValidation="False" />

                            <asp:Button ID="btnBaja" runat="server"
                                Text="Dar de baja"
                                CssClass="formato-btnBase formato2-btn"
                                CommandName="BajaMedico"
                                CommandArgument='<%# ((GridViewRow)Container).RowIndex %>'
                                CausesValidation="False"
                                Visible='<%# Eval("Estado").ToString() == "Activo" %>'
                                OnClientClick="return confirm('¿Está seguro que desea dar de baja este médico?');" />

                            <asp:Button ID="btnAlta" runat="server"
                                Text="Dar de alta"
                                CssClass="formato-btnBase formato1-btn"
                                CommandName="ReactivarMedico"
                                CommandArgument='<%# ((GridViewRow)Container).RowIndex %>'
                                CausesValidation="False"
                                Visible='<%# Eval("Estado").ToString() == "Inactivo" %>'
                                OnClientClick="return confirm('¿Está seguro que desea dar de alta este médico?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataRowStyle CssClass="texto-rojo-fijo" />
            </asp:GridView>
        </div>
    </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
