<%@ Page Title="" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="AltaBajaTurnos.aspx.cs" Inherits="Vistas.AltaBajaTurnos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <h2>Gestión de Turnos</h2>


            <%-- ====================================
         BLOQUE 1: SELECCION DE PACIENTE 
         ================================== --%>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Paciente</div>
                <asp:Panel ID="pnlBuscarPaciente" runat="server" DefaultButton="btnBuscarPaciente">
                    <table class="tabla-pacientes" style="width: 100%;">
                        <tr>
                            <td style="width: 40%;">
                                <asp:Label ID="lblDniPaciente" runat="server" Text="INGRESE DNI DEL PACIENTE" CssClass="fomato-Label" />
                                <asp:TextBox ID="txtDniBuscar" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Ej: 35123456" TextMode="Number" />
                                <asp:RegularExpressionValidator ID="revDni" runat="server" ControlToValidate="txtDniBuscar" CssClass="validador-error" Display="Dynamic" ErrorMessage="Solo números (7 u 8 dígitos)." Font-Size="Small" ForeColor="Red" ValidationExpression="^\d{7,8}$" ValidationGroup="GrupoGestionDeTurnos"></asp:RegularExpressionValidator>
                            </td>
                            <td style="width: 20%; vertical-align: bottom;">
                                <asp:Button ID="btnBuscarPaciente" runat="server" Text="Buscar" CssClass="formato-btnBase formato1-btn" OnClick="btnBuscarPaciente_Click" ValidationGroup="GrupoGestionDeTurnos" />
                            </td>
                            <td style="width: 40%;">
                                <asp:Label ID="lblPacienteSeleccionado" runat="server" Text="Nombre Paciente " CssClass="fomato-Label" />
                                <asp:TextBox ID="txtNombrePacienteOk" runat="server" CssClass="fomato-TextBox-Ddl" ReadOnly="true" placeholder="Ningún paciente seleccionado" /></td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

            <%-- ==============================================
         BLOQUE 2: SELECCION DE ESPECIALIDAD Y MEDICO 
         ============================================== --%>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Nuevo Turno - Seleccionar Especialidad y Médico</div>
                <table class="tabla-pacientes" style="width: 100%;">
                    <tr>
                        <td style="width: 50%;">
                                <asp:Label ID="lblEspecialidad" runat="server" Text="ESPECIALIDAD" CssClass="fomato-Label" />

                            <asp:DropDownList ID="ddlEspecialidad" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEspecialidad_SelectedIndexChanged" CssClass="fomato-TextBox-Ddl" />
                        </td>
                        <td style="width: 50%;">
                            <asp:Label ID="lblMedico" runat="server" Text="MÉDICO" CssClass="fomato-Label" />
                            <asp:DropDownList ID="ddlMedico" runat="server"
                                AutoPostBack="true"
                                CssClass="fomato-TextBox-Ddl"
                                OnSelectedIndexChanged="ddlMedico_SelectedIndexChanged1" />
                        </td>
                    </tr>
                </table>
            </div>

            <%-- =====================================
         BLOQUE 3: GRIDVIEW AGENDAR TURNOS 
         =================================== --%>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">
                    Agendar Turno Medico:
            <asp:Label ID="lblNombreMedico" runat="server" Font-Size="Large"></asp:Label>
                </div>

                <asp:GridView ID="gvHorariosDisponibles" runat="server" AutoGenerateColumns="False"
                    CssClass="custom-grid"
                    Width="62%"
                    AllowPaging="true"
                    PageSize="5"
                    DataKeyNames="Fecha,Hora"
                    OnPageIndexChanging="gvHorariosDisponibles_PageIndexChanging"
                    OnRowCommand="gvHorariosDisponibles_RowCommand"
                    OnRowDataBound="gvHorariosDisponibles_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="DiaSemana" HeaderText="Día" />
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" />
                        <asp:BoundField DataField="Hora" HeaderText="Hora" />
                        <asp:TemplateField ItemStyle-Width="1%" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:Button ID="btnReservar" runat="server" Text="Confirmar"
                                    CssClass="formato-btnBase formato1-btn"
                                    CommandName="Reservar"
                                    CommandArgument='<%# Container.DisplayIndex %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <div style="margin-top: 15px; text-align: center;">
                    <asp:Label ID="lblMensajeAgendarTurno" runat="server" Font-Bold="True" Font-Size="Large"></asp:Label>
                </div>
            </div>

            <%-- ===================================
         BLOQUE 4: GRIDVIEW CANCELAR TURNOS 
         ===================================--%>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">
                    Turnos Agendados del Paciente:
            <asp:Label ID="lblNombrePaciente" runat="server" Font-Size="Large"></asp:Label>
                </div>

                <asp:GridView ID="gvTurnosDelPaciente" runat="server" AutoGenerateColumns="False"
                    CssClass="custom-grid" Width="100%"
                    OnRowCommand="gvTurnosDelPaciente_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha Turno" />
                        <asp:BoundField DataField="Hora" HeaderText="Horario" />
                        <asp:BoundField DataField="Medico" HeaderText="Médico" />
                        <asp:BoundField DataField="Especialidad" HeaderText="Especialidad" />

                        <asp:TemplateField ItemStyle-Width="1%" ItemStyle-Wrap="false">
                            <ItemTemplate>
                                <asp:Button ID="btnCancelarTurno" runat="server" Text="Cancelar Turno"
                                    CssClass="formato-btnBase btn-danger"
                                    CommandName="Cancelar"
                                    OnClientClick="return confirm('¿Está seguro de que desea cancelar el turno?');"
                                    CommandArgument='<%# Eval("Id_Turno") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div style="margin-top: 15px; text-align: center;">
                    <asp:Label ID="lblMensajeCancelar" runat="server" Font-Bold="True"></asp:Label>
                </div>
            </div>
            <%-- ===================================
            BLOQUE 5: HISTORIAL DE TURNOS 
            =================================== --%>
            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">atenciones previas del paciente</div>

                <div style="padding: 10px;">
                    <asp:Button ID="btnVerHistorial" runat="server" Text="Ver Historial"
                        CssClass="formato-btnBase formato1-btn"
                        OnClick="btnVerHistorial_Click" />
                </div>

                <asp:GridView ID="gvHistorialTurnos" runat="server" AutoGenerateColumns="False"
                    CssClass="custom-grid" Width="100%" Visible="false"
                    AllowPaging="true"
                    PageSize="5"
                    OnPageIndexChanging="gvHistorialTurnos_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="Fecha" HeaderText="Fecha" />
                        <asp:BoundField DataField="Hora" HeaderText="Hora" />
                        <asp:BoundField DataField="Medico" HeaderText="Médico" />
                        <asp:BoundField DataField="Especialidad" HeaderText="Especialidad" />
                    </Columns>
                </asp:GridView>

                <div style="margin-top: 10px; text-align: center;">
                    <asp:Label ID="lblMensajeHistorialVacio" runat="server" Font-Bold="True" ForeColor="Red"  ></asp:Label>
                    
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>