<%@ Page Title="Gestión de Pacientes" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Pacientes.aspx.cs" Inherits="Vistas.Pacientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Gestión de Pacientes</h2>
    <p>&nbsp;</p> 

    <%-- ==========================================================
         AJAX: un único UpdatePanel envuelve los tres bloques
         (formulario + búsqueda + grilla) para que toda la pantalla
         se refresque sin parpadeo. El ScriptManager se hereda de
         Principal.Master, por eso no se declara acá.
         ========================================================== --%>
    <asp:UpdatePanel ID="UpdatePanelPacientes" runat="server">
        <ContentTemplate>

    <%-- ==========================================================
         BLOQUE 1: FORMULARIO DE CARGA (DATOS DEL PACIENTE)
         ========================================================== --%>
            <div id="formularioPaciente"></div>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Datos del paciente</div>
                <asp:Panel ID="pnlAltaPaciente" runat="server" DefaultButton="btnGuardar">

                    <table class="tabla-pacientes">
                        <tr class="fila-titulo">
                            <td style="width: 24%;">
                                <asp:Label ID="lblDni" runat="server" Text="DNI" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td style="width: 38%;">
                                <asp:Label ID="lblNombre" runat="server" Text="NOMBRE" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td style="width: 38%;">
                                <asp:Label ID="lblApellido" runat="server" Text="APELLIDO" CssClass="fomato-Label"></asp:Label>
                            </td>
                        </tr>
                        <tr class="fila-campo">
                            <td>
                                <asp:TextBox ID="txtDni" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Ej: 40123456"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDni" runat="server" ControlToValidate="txtDni" CssClass="validador-error" ErrorMessage="El DNI es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revDni" runat="server" ControlToValidate="txtDni" CssClass="validador-error" ErrorMessage="Solo números (7 u 8 dígitos)." ValidationExpression="^\d{7,8}$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Nombre/s"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" CssClass="validador-error" ErrorMessage="El nombre es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revNombre" runat="server" ControlToValidate="txtNombre" CssClass="validador-error" Display="Dynamic" ErrorMessage="El nombre solo puede contener letras y espacios" Font-Size="Small" ForeColor="Red" ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$" ValidationGroup="GrupoAltaPaciente"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtApellido" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Apellido/s"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" CssClass="validador-error" ErrorMessage="El apellido es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revApellido" runat="server" ControlToValidate="txtApellido" CssClass="validador-error" Display="Dynamic" ErrorMessage="El nombre solo puede contener letras y espacios" Font-Size="Small" ForeColor="Red" ValidationExpression="^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$" ValidationGroup="GrupoAltaPaciente"></asp:RegularExpressionValidator>
                            </td>
                        </tr>

                        <tr class="fila-titulo">
                            <td>
                                <asp:Label ID="lblSexo" runat="server" Text="SEXO" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblNacionalidad" runat="server" Text="NACIONALIDAD" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblFechaNacimiento" runat="server" Text="FECHA DE NACIMIENTO" CssClass="fomato-Label"></asp:Label>
                            </td>
                        </tr>
                        <tr class="fila-campo">
                            <td>
                                <asp:DropDownList ID="ddlSexo" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="">--Seleccionar--</asp:ListItem>
                                    <asp:ListItem>Masculino</asp:ListItem>
                                    <asp:ListItem>Femenino</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvSexo" runat="server" ControlToValidate="ddlSexo" CssClass="validador-error" InitialValue="" ErrorMessage="Seleccione un sexo." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                            </td>
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
                                <asp:RequiredFieldValidator ID="rfvNacionalidad" runat="server" ControlToValidate="ddlNacionalidad" CssClass="validador-error" InitialValue="" ErrorMessage="Seleccione nacionalidad." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFechaNacimiento" runat="server" ControlToValidate="txtFechaNacimiento" CssClass="validador-error" ErrorMessage="La fecha es obligatoria." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvFecha" runat="server" ControlToValidate="txtFechaNacimiento" CssClass="validador-error" Display="Dynamic" ErrorMessage="La fecha debe estar entre 01/01/1900 y hoy." Font-Size="Small" ForeColor="Red" MinimumValue="1900-01-01" Type="Date" ValidationGroup="GrupoAltaPaciente"></asp:RangeValidator>
                            </td>
                        </tr>

                        <tr class="fila-titulo">
                            <td>
                                <asp:Label ID="lblDireccion" runat="server" Text="DIRECCION" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblProvincia" runat="server" Text="PROVINCIA" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="lblLocalidad" runat="server" Text="LOCALIDAD" CssClass="fomato-Label"></asp:Label>
                            </td>
                        </tr>
                        <tr class="fila-campo">
                            <td>
                                <asp:TextBox ID="txtDireccion" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Calle y número"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" CssClass="validador-error" ErrorMessage="La dirección es obligatoria." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlProvincia" runat="server" CssClass="fomato-TextBox-Ddl" AutoPostBack="True" OnSelectedIndexChanged="ddlProvincia_SelectedIndexChanged">
                                    <asp:ListItem Value="">--Seleccionar--</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvProvincia" runat="server" ControlToValidate="ddlProvincia" CssClass="validador-error" InitialValue="" ErrorMessage="Seleccione provincia." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlLocalidad" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="">--Seleccionar--</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvLocalidad" runat="server" ControlToValidate="ddlLocalidad" CssClass="validador-error" InitialValue="" ErrorMessage="Seleccione localidad." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                            </td>
                        </tr>

                        <tr class="fila-titulo">
                            <td>
                                <asp:Label ID="lblCorreoElectronico" runat="server" Text="CORREO ELECTRONICO" CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td>&nbsp;</td>
                            <td>
                                <asp:Label ID="lblTelefono" runat="server" Text="TELEFONO" CssClass="fomato-Label"></asp:Label>
                            </td>
                        </tr>
                        <tr class="fila-campo">
                            <td colspan="2">
                                <asp:TextBox ID="txtCorreoElectronico" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="ejemplo@mail.com"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCorreoElectronico" runat="server" ControlToValidate="txtCorreoElectronico" CssClass="validador-error" ErrorMessage="El correo es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revCorreoElectronico" runat="server" ControlToValidate="txtCorreoElectronico" CssClass="validador-error" ErrorMessage="Formato de correo electrónico inválido." ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$" ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RegularExpressionValidator>
                            </td>
                            <td>
                                <asp:TextBox ID="txtTelefono" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Ej: 1155556666"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono" CssClass="validador-error" ErrorMessage="El teléfono es obligatorio." ForeColor="Red" Display="Dynamic" Font-Size="Small" ValidationGroup="GrupoAltaPaciente"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revTelefono" runat="server" ControlToValidate="txtTelefono" CssClass="validador-error" Display="Dynamic" ErrorMessage="Solo números (entre 10 y 15 dígitos)." Font-Size="Small" ForeColor="Red" ValidationExpression="^\d{10,15}$" ValidationGroup="GrupoAltaPaciente"></asp:RegularExpressionValidator>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="3">
                                <div class="formato-btnAlineados">
                                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="formato-btnBase formato1-btn" OnClick="btnGuardar_Click" ValidationGroup="GrupoAltaPaciente" />
                                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="formato-btnBase formato2-btn" CausesValidation="False" OnClick="btnLimpiar_Click" />
                                    <br />
                                    <br />
                                    <asp:Label ID="lblConfirmacion" runat="server"></asp:Label>
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

    <%-- ==========================================================
         BLOQUE 2: BARRA DE BÚSQUEDA 
         ========================================================== --%>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Buscar</div>
                <asp:Panel ID="pnlBuscarPaciente" runat="server" DefaultButton="btnBuscar">

                    <table class="tabla-pacientes">
                        <tr>
                            <td class="pac-col-busqueda">&nbsp;</td>
                            <td class="pac-col-sexo">
                                <asp:Label ID="lblSexo0" runat="server" Text="SEXO" CssClass="fomato-Label" Width="246px"></asp:Label>
                            </td>
                            <td class="pac-col-estado">
                                <asp:Label ID="lblEstadoFiltro" runat="server" Text="ESTADO" CssClass="fomato-Label" Width="246px"></asp:Label>
                            </td>
                            <td class="pac-col-accion">&nbsp;</td>
                        </tr>
                        <tr>
                            <td class="pac-col-busqueda">
                                <asp:TextBox ID="txtBuscar" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Por nombre, apellido o DNI" Width="322px"></asp:TextBox>
                            </td>
                            <td class="pac-col-sexo">
                                <asp:DropDownList ID="ddlFiltroSexo" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="">-- Todos --</asp:ListItem>
                                    <asp:ListItem>Masculino</asp:ListItem>
                                    <asp:ListItem>Femenino</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="pac-col-estado">
                                <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="fomato-TextBox-Ddl">
                                    <asp:ListItem Value="-1">-- Todos --</asp:ListItem>
                                    <asp:ListItem Value="1">Activo</asp:ListItem>
                                    <asp:ListItem Value="0">Inactivo</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td class="pac-col-accion">
                                <asp:Button ID="btnBuscar" runat="server" CssClass="formato-btnBase formato1-btn" Text="Buscar" CausesValidation="False" OnClick="btnBuscar_Click" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

    <%-- ==========================================================
         BLOQUE 3: GRILLA DE RESULTADOS (LISTADO DE PACIENTES)
         ========================================================== --%>
<div class="formato-Bloque-Contenedor">
    <div class="formato-Titulo">Listado de Pacientes</div>
    <asp:Panel ID="Panel_GV" runat="server" ScrollBars="Horizontal">
        <asp:GridView ID="gvPacientes" runat="server" 
            DataKeyNames="DNI" 
            AutoGenerateColumns="False" 
            CssClass="custom-grid" 
            Width="100%" 
            CellPadding="10" 
            GridLines="None" 
            AllowPaging="True" 
            OnPageIndexChanging="gvPacientes_PageIndexChanging" 
            OnRowCommand="gvPacientes_RowCommand"
            PageSize="5" 
            EmptyDataText="No existen datos que coincidan con los criterios de busqueda utilizados.">
            <EmptyDataRowStyle Font-Bold="True" CssClass="texto-rojo-fijo" />
            <Columns>
                <asp:TemplateField HeaderText="<div style='text-align: center;'>Acciones</div>">
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
                            CommandName="BajaPaciente"
                            CommandArgument='<%# ((GridViewRow)Container).RowIndex %>'
                            CausesValidation="False"
                            Visible='<%# Eval("Estado").ToString() == "Activo" %>'
                            OnClientClick="return confirm('¿Está seguro que desea dar de baja este paciente?');" />
                        <asp:Button ID="btnAlta" runat="server"
                            Text="Dar de alta"
                            CssClass="formato-btnBase formato1-btn"
                            CommandName="ReactivarPaciente"
                            CommandArgument='<%# ((GridViewRow)Container).RowIndex %>'
                            CausesValidation="False"
                            Visible='<%# Eval("Estado").ToString() == "Inactivo" %>'
                            OnClientClick="return confirm('¿Está seguro que desea dar de alta este paciente?');" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="DNI">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Dni" runat="server" Text='<%# Eval("DNI") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Nombre">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Nombre" runat="server" Text='<%# Eval("Nombre") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Apellido">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Apellido" runat="server" Text='<%# Eval("Apellido") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Sexo">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Sexo" runat="server" Text='<%# Eval("Sexo") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Nacionalidad">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Nacionalidad" runat="server" Text='<%# Eval("Nacionalidad") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Fecha de Nacimiento">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Fecha" runat="server" Text='<%# Eval("Fecha de Nacimiento") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Dirección">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Direccion" runat="server" Text='<%# Eval("Dirección") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Provincia">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Provincia" runat="server" Text='<%# Eval("Provincia") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Localidad">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Localidad" runat="server" Text='<%# Eval("Localidad") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Correo Electrónico">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Correo" runat="server" Text='<%# Eval("Correo Electrónico") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Teléfono">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Telefono" runat="server" Text='<%# Eval("Teléfono") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <asp:Label ID="lbl_it_Estado" runat="server" Text='<%# Eval("Estado") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
</div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>