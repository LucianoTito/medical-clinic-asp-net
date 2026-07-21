<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Vistas.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - UTM|GR16 </title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700&family=Source+Sans+3:wght@400;500;600&display=swap" rel="stylesheet" />
    <link rel="icon" type="image/png" href="/img/favicon_UTMGR16.png" />
    <link href="EstilosClinica.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        
 
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="upLogin" runat="server">
            <ContentTemplate>

                <table class="login-table">
                    <tr>
                        <td class="login-left">
                            <img src="img/logo_UTMGR16.jpg" alt="UTM GR16" />
                            <h1>UTM | GR16</h1>
                            <p class="text">Unidad de Tratamiento Médico</p>
                            <p class="footer-text">UTN FRGP — Programación III — Grupo 16</p>
                        </td>
                        
                        <td class="login-right">
                            <div class="login-card">
                                <div class="card-stripe"></div>
                                <div class="card-body">
                                    <h3>Iniciar sesión</h3>
                                    <p class="subtitle">Ingrese sus credenciales para acceder al sistema</p>

                                    <div class="field-group">
                                        <label>Usuario</label>
                                        <asp:TextBox ID="txtUsuario" runat="server" CssClass="input-field" 
                                            placeholder="Ingrese su usuario" />
                                        <asp:RequiredFieldValidator ID="rfvUsuario" runat="server"
                                            ControlToValidate="txtUsuario"
                                            ErrorMessage="Ingrese su usuario."
                                            CssClass="validador-error"
                                            Display="Dynamic"
                                            ValidationGroup="GrupoLogin" />
                                    </div>

                                    <div class="field-group">
                                        <label>Contraseña</label>
                                        <asp:TextBox ID="txtContrasenia" runat="server" CssClass="input-field"
                                            TextMode="Password" placeholder="••••••••" />
                                        <asp:RequiredFieldValidator ID="rfvContrasenia" runat="server"
                                            ControlToValidate="txtContrasenia"
                                            ErrorMessage="Ingrese su contraseña."
                                            CssClass="validador-error"
                                            Display="Dynamic"
                                            ValidationGroup="GrupoLogin" />
                                    </div>

                                    <asp:Button ID="btnIngresar" runat="server" Text="Ingresar"
                                        CssClass="btn-ingresar" OnClick="btnIngresarClick"
                                        ValidationGroup="GrupoLogin" />
                                    
                                    <div style="margin-top: 15px; text-align: center;">
                                        <asp:Label ID="lblMensaje" runat="server" ForeColor="Red" Font-Bold="true" />
                                    </div>

                                </div>
                            </div>
                        </td>
                    </tr>
                </table>

            </ContentTemplate>
        </asp:UpdatePanel>  

    </form>
</body>
</html>