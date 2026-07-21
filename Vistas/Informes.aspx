<%@ Page Title="Informes y Estadísticas" Language="C#" MasterPageFile="~/Principal.Master" AutoEventWireup="true" CodeBehind="Informes.aspx.cs" Inherits="Vistas.Informes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">



    <asp:UpdatePanel ID="UpdatePanelInformes" runat="server">
        <ContentTemplate>

            <h2>Módulo de Informes y Reportes</h2>
            <p>&nbsp;</p>

            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Generar Reporte de TURNOS POR MEDICO</div>
                <asp:Panel ID="pnlFiltroInformes" runat="server" DefaultButton="btnGenerarReporte">

                    <table class="tabla-pacientes" style="width: 100%;">
                        <tr>
                            <td style="width: 25%;">
                                <asp:Label ID="lblDesde" runat="server" Text="Fecha Desde" CssClass="fomato-Label"></asp:Label>
                                <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                            </td>
                            <td style="width: 25%;">
                                <asp:Label ID="lblHasta" runat="server" Text="Fecha Hasta" CssClass="fomato-Label"></asp:Label>
                                <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                            </td>
                            <td style="width: 25%;">
                                <asp:Label ID="lblEspecialidadInfo" runat="server" Text="Filtrar por Especialidad" CssClass="fomato-Label"></asp:Label>

                                <asp:DropDownList ID="ddlEspecialidades" runat="server" CssClass="fomato-TextBox-Ddl">
                                </asp:DropDownList>
                            </td>
                            <td style="width: 25%; vertical-align: bottom;">
                                <asp:Button ID="btnGenerarReporte" runat="server" Text="Generar"
                                    CssClass="formato-btnBase formato1-btn"
                                    ValidationGroup="grupoInformes"
                                    OnClick="btnGenerarReporte_Click" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">

                                <asp:CompareValidator ID="cvFechaDesde" runat="server"
                                    ControlToValidate="txtFechaDesde"
                                    Operator="DataTypeCheck" Type="Date"
                                    ValidationGroup="grupoInformes"
                                    ForeColor="Red" Display="Dynamic"
                                    ErrorMessage="La Fecha Desde no es una fecha válida.">
                                </asp:CompareValidator>

                                <asp:CompareValidator ID="cvFechaHasta" runat="server"
                                    ControlToValidate="txtFechaHasta"
                                    Operator="DataTypeCheck" Type="Date"
                                    ValidationGroup="grupoInformes"
                                    ForeColor="Red" Display="Dynamic"
                                    ErrorMessage="La Fecha Hasta no es una fecha válida.">
                                </asp:CompareValidator>


                                <asp:CompareValidator ID="cvRangoFechas" runat="server"
                                    ControlToValidate="txtFechaHasta"
                                    ControlToCompare="txtFechaDesde"
                                    Operator="GreaterThanEqual" Type="Date"
                                    ValidationGroup="grupoInformes"
                                    ForeColor="Red" Display="Dynamic"
                                    ErrorMessage="La Fecha Hasta debe ser mayor o igual a la Fecha Desde.">
                                </asp:CompareValidator>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">TURNOS POR MEDICO</div>
                
                <%-- mensaje de error por si falla la búsqueda --%>
                <asp:Label ID="lblMensaje" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
                <br />

                
                <asp:GridView ID="gvInformes" runat="server" 
        AutoGenerateColumns="False" 
        CssClass="horarios-table" 
        Width="100%" 
        AllowPaging="True" 
        PageSize="10"
        OnPageIndexChanging="gvInformes_PageIndexChanging"
        EmptyDataText="No hay datos para mostrar con los filtros seleccionados.">
    <Columns>
        <asp:BoundField DataField="Medico" HeaderText="Médico" />
        <asp:BoundField DataField="Especialidad" HeaderText="Especialidad" />
        <asp:BoundField DataField="Turnos_Asignados" HeaderText="Turnos Asignados" />
        <asp:BoundField DataField="Presentes" HeaderText="Presentes" />
        <asp:BoundField DataField="Ausentes" HeaderText="Ausentes" />
        <asp:BoundField DataField="Pendientes" HeaderText="Pendientes" />
        <asp:BoundField DataField="Porcentaje_Presentes" HeaderText="% Presentes" />
        <asp:BoundField DataField="Porcentaje_Ausentes" HeaderText="% Ausentes" />
    </Columns>
    <HeaderStyle BackColor="#f0f4fa" ForeColor="#0B3D6F" Font-Bold="true" />
</asp:GridView>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:UpdatePanel ID="UpdatePanelPacientes" runat="server">
    <ContentTemplate>

        <div class="formato-Bloque-Contenedor">
            <div class="formato-Titulo">Generar Reporte de Asistencias POR PACIENTE</div>
            <asp:Panel ID="pnlInformeAsistencia" runat="server" DefaultButton="btnGenerarPacientes">

                <table class="tabla-pacientes" style="width: 100%;">
                    <tr>
                        <td style="width: 25%;">
                            <asp:Label ID="lblDesdePac" runat="server" Text="Fecha Desde" CssClass="fomato-Label"></asp:Label>
                            <asp:TextBox ID="txtFechaDesdePac" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                        </td>
                        <td style="width: 25%;">
                            <asp:Label ID="lblHastaPac" runat="server" Text="Fecha Hasta" CssClass="fomato-Label"></asp:Label>
                            <asp:TextBox ID="txtFechaHastaPac" runat="server" CssClass="fomato-TextBox-Ddl" TextMode="Date"></asp:TextBox>
                        </td>
                        <td style="width: 50%; vertical-align: bottom;">
                            <asp:Button ID="btnGenerarPacientes" runat="server" Text="Generar"
                                CssClass="formato-btnBase formato1-btn"
                                ValidationGroup="grupoPacientes"
                                OnClick="btnGenerarPacientes_Click" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <asp:CompareValidator ID="cvFechaDesdePac" runat="server"
                                ControlToValidate="txtFechaDesdePac"
                                Operator="DataTypeCheck" Type="Date"
                                ValidationGroup="grupoPacientes"
                                ForeColor="Red" Display="Dynamic"
                                ErrorMessage="La Fecha Desde no es una fecha válida.">
                            </asp:CompareValidator>

                            <asp:CompareValidator ID="cvFechaHastaPac" runat="server"
                                ControlToValidate="txtFechaHastaPac"
                                Operator="DataTypeCheck" Type="Date"
                                ValidationGroup="grupoPacientes"
                                ForeColor="Red" Display="Dynamic"
                                ErrorMessage="La Fecha Hasta no es una fecha válida."></asp:CompareValidator>

                            <asp:CompareValidator ID="cvRangoPac" runat="server"
                                ControlToValidate="txtFechaHastaPac"
                                ControlToCompare="txtFechaDesdePac"
                                Operator="GreaterThanEqual" Type="Date"
                                ValidationGroup="grupoPacientes"
                                ForeColor="Red" Display="Dynamic"
                                ErrorMessage="La Fecha Hasta debe ser mayor o igual a la Fecha Desde.">
                            </asp:CompareValidator>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>

        <div class="formato-Bloque-Contenedor">
            <div class="formato-Titulo">ASISTENCIAS POR PACIENTE</div>

           
            <asp:Label ID="lblResumenPac" runat="server" Font-Bold="true" ForeColor="#0B3D6F"></asp:Label>
            <br /><br />

            <asp:Label ID="lblMensajePac" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>

            <asp:GridView ID="gvPacientes" runat="server"
        AutoGenerateColumns="False"
        CssClass="horarios-table"
        Width="100%"
        AllowPaging="True"
        PageSize="10"
        OnPageIndexChanging="gvPacientes_PageIndexChanging"
        EmptyDataText="No hay datos para mostrar con los filtros seleccionados.">
    <Columns>
        <asp:BoundField DataField="DNI" HeaderText="DNI" />
        <asp:BoundField DataField="Paciente" HeaderText="Paciente" />
        <asp:BoundField DataField="Veces_Presente" HeaderText="Veces Presente" />
        <asp:BoundField DataField="Veces_Ausente" HeaderText="Veces Ausente" />
        <asp:BoundField DataField="Turnos_Cerrados" HeaderText="Turnos Cerrados" />
        <asp:BoundField DataField="Porcentaje_Asistencia" HeaderText="% Asistencia" />
    </Columns>
    <HeaderStyle BackColor="#f0f4fa" ForeColor="#0B3D6F" Font-Bold="true" />
</asp:GridView>
        </div>

    </ContentTemplate>
</asp:UpdatePanel>

    <asp:UpdatePanel ID="UpdatePanelEspecialidades" runat="server">
        <ContentTemplate>

            <div class="formato-Bloque-Contenedor">
                <div class="formato-Titulo">Ranking de Especialidades Más Solicitadas</div>
                <asp:Panel ID="pnlRankingEspecialidades" runat="server" DefaultButton="btnGenerarEspecialidades">

                    <table class="tabla-pacientes" style="width: 100%;">
                        <tr>
                            <td>
                                <asp:Label ID="lblInfoEspecialidades" runat="server"
                                    Text="Listado de especialidades ordenadas por cantidad de turnos solicitados."
                                    CssClass="fomato-Label"></asp:Label>
                            </td>
                            <td style="text-align: right;">
                                <asp:Button ID="btnGenerarEspecialidades" runat="server" Text="Generar Ranking"
                                    CssClass="formato-btnBase formato1-btn"
                                    OnClick="btnGenerarEspecialidades_Click" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

        <div class="formato-Bloque-Contenedor">
            <div class="formato-Titulo">Ranking de Especialidades</div>

            <asp:Label ID="lblMensajeEsp" runat="server" Font-Bold="true"></asp:Label>

            <asp:GridView ID="gvEspecialidades" runat="server"
        AutoGenerateColumns="False"
        CssClass="horarios-table"
        Width="100%"
        AllowPaging="True"
        PageSize="10"
        OnPageIndexChanging="gvEspecialidades_PageIndexChanging"
        EmptyDataText="No hay datos para mostrar.">
    <Columns>
        <asp:BoundField DataField="Especialidad" HeaderText="Especialidad" />
        <asp:BoundField DataField="Total_Turnos" HeaderText="Total de Turnos" />
        <asp:BoundField DataField="Medicos_Activos" HeaderText="Médicos Activos" />
    </Columns>
    <HeaderStyle BackColor="#f0f4fa" ForeColor="#0B3D6F" Font-Bold="true" />
</asp:GridView>
        </div>

    </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>