<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Centros.aspx.cs" Inherits="Etapa3bd.Contros" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
<form id="form1" runat="server">
    <div>
        <table style="width:100%;">
            <tr>
                <td>ID do Centro</td>
                <td><asp:TextBox ID="txtIdCentro" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Centro</td>
                <td><asp:TextBox ID="txtCentro" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Morada</td>
                <td><asp:TextBox ID="txtMorada" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Telefone</td>
                <td><asp:TextBox ID="txtTelefone" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="btnInserir" runat="server" Text="Inserir" OnClick="btnInserir_Click" />
                    <asp:Button ID="btnAtualizar" runat="server" Text="Atualizar" OnClick="btnAtualizar_Click" />
                    <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" OnClick="btnEliminar_Click" />
                </td>
            </tr>
        </table>
        <p></p>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID_CENTRO" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="ID_CENTRO" HeaderText="ID_CENTRO" ReadOnly="True" SortExpression="ID_CENTRO" />
                <asp:BoundField DataField="CENTRO" HeaderText="CENTRO" SortExpression="CENTRO" />
                <asp:BoundField DataField="MORADA" HeaderText="MORADA" SortExpression="MORADA" />
                <asp:BoundField DataField="TELEFONE" HeaderText="TELEFONE" SortExpression="TELEFONE" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:BD23Etapa3 %>" SelectCommand="SELECT * FROM [CENTRO]"></asp:SqlDataSource>
    </div>
</form>
    </body>
</html>
