<%@ Page Title="" Language="C#" MasterPageFile="~/MedicosPrincipal.Master" AutoEventWireup="true" CodeBehind="TurnosMedico.aspx.cs" Inherits="Vistas.TurnosMedico" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Gestión de Turnos y Atención Médica</h2>
    <p>&nbsp;</p>


    <asp:UpdatePanel ID="UpdatePanelTurnosMedico" runat="server">
        <ContentTemplate>

    <%-- ==========================================================
         FILTROS DE BÚSQUEDA 
         ========================================================== --%>
    <div class="formato-Bloque-Contenedor">
        <div class="formato-Titulo">Filtrar Turnos Asignados</div>
        <asp:Panel ID="pnlFiltrosTurnosMedico" runat="server" DefaultButton="btnFiltrar">

            <table class="tabla-pacientes">
                <tr>
                    <td style="width: 30%;">
                        <asp:Label ID="lblBuscarPaciente" runat="server" Text="BUSCAR POR PACIENTE (DNI O NOMBRE)" CssClass="fomato-Label"></asp:Label>
                        <asp:TextBox ID="txtBuscarPaciente" runat="server" CssClass="fomato-TextBox-Ddl" placeholder="Ej: Juan Pérez"></asp:TextBox>
                    </td>
                    <td style="width: 25%;">
                        <asp:Label ID="lblFechaDesde" runat="server" Text="FECHA DESDE" CssClass="fomato-Label"></asp:Label>
                        <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                        <asp:CompareValidator ID="cvFechaDesdeFormato" runat="server" ControlToValidate="txtFechaDesde" CssClass="validador-error" Display="Dynamic" ErrorMessage="La Fecha Desde no es una fecha válida." Font-Size="Small" ForeColor="Red" Operator="DataTypeCheck" Type="Date" ValidationGroup="GrupoTurnosMedico"></asp:CompareValidator>
                    </td>
                    <td style="width: 25%;">
                        <asp:Label ID="lblFechaHasta" runat="server" Text="FECHA HASTA" CssClass="fomato-Label"></asp:Label>
                        <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date" ValidationGroup="GrupoTurnosMedico"></asp:TextBox>
                        <asp:CompareValidator ID="cvFechaHastaFormato" runat="server" ControlToValidate="txtFechaHasta" CssClass="validador-error" Display="Dynamic" ErrorMessage="La Fecha Hasta no es una fecha válida." Font-Size="Small" ForeColor="Red" Operator="DataTypeCheck" Type="Date" ValidationGroup="GrupoTurnosMedico"></asp:CompareValidator>
                        <asp:CompareValidator ID="cvFechaHasta" runat="server" ControlToCompare="txtFechaDesde" ControlToValidate="txtFechaHasta" CssClass="validador-error" Display="Dynamic" ErrorMessage="La Fecha Hasta debe ser mayor o igual a la Fecha Desde." Font-Size="Small" ForeColor="Red" Operator="GreaterThanEqual" Type="Date" ValidationGroup="GrupoTurnosMedico"></asp:CompareValidator>
                    </td>
                    <td style="width: 20%; vertical-align: bottom;">
                        <div class="formato-btnAlineados" style="margin-top: 0;">
                            <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="formato-btnBase formato1-btn" OnClick="btnFiltrar_Click" ValidationGroup="GrupoTurnosMedico" />
                            <asp:Button ID="btnLimpiarFiltros" runat="server" Text="Limpiar" CssClass="formato-btnBase formato2-btn" OnClick="btnLimpiarFiltros_Click" />
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </div>

    <%-- ==========================================================
         GRILLA DE TURNOS Y ATENCIÓN
         ========================================================== --%>
    <div class="formato-Bloque-Contenedor">
        <div class="formato-Titulo">Listado de Turnos </div>

        <%-- Permite que el médico cargue Asistencia y Observaciones --%>
        <asp:GridView ID="gvTurnosMedico" runat="server"
            AutoGenerateColumns="False"
            OnRowEditing="gvTurnosMedico_RowEditing"
            OnRowUpdating="gvTurnosMedico_RowUpdating"
            OnRowCancelingEdit="gvTurnosMedico_RowCancelingEdit"
            DataKeyNames="Id_Turno"
            CssClass="custom-grid"
            Width="100%"
            AllowPaging="True"
            PageSize="5"
            EmptyDataText="No se encontraron turnos para los criterios seleccionados."
            OnPageIndexChanging="gvTurnosMedico_PageIndexChanging">

            <Columns>

                <%-- TextBox para cargar las observaciones médicas --%>
                <asp:CommandField ButtonType="Button"  EditText="Modificar" ShowEditButton="True" ControlStyle-CssClass="formato-btnBase formato1-btn"/>
                <asp:BoundField DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" ReadOnly="True" />
                <asp:BoundField DataField="Hora" HeaderText="Hora" ReadOnly="True" />
                <asp:BoundField DataField="NombreCompletoPaciente" HeaderText="Paciente" ReadOnly="True" />

                <asp:TemplateField HeaderText="Asistencia">
                    <ItemTemplate>
                        <asp:Label ID="lblAsistencia" runat="server" Text='<%# Bind("Asistencia") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlAsistenciaEdit" runat="server" CssClass="fomato-TextBox-Ddl">
                            <asp:ListItem>Pendiente</asp:ListItem>
                            <asp:ListItem>Presente</asp:ListItem>
                            <asp:ListItem>Ausente</asp:ListItem>
                        </asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Observaciones">
                    <ItemTemplate>
                        <asp:Label ID="lblObservaciones" runat="server" Text='<%# Bind("Observaciones") %>'></asp:Label>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtObservacionesEdit" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="MultiLine" Rows="2" Text='<%# Bind("Observaciones") %>'></asp:TextBox>
                    </EditItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
        <div style="text-align: center; margin-top: 10px;">
    <asp:Label ID="lblMensaje" runat="server" Text="" ForeColor="Red" Font-Bold="true"></asp:Label>
</div>
    </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
