<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ListaCentro.aspx.cs" Inherits="Etapa3bd.ListaCentro" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .auto-style1 {
            height: 26px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width:100%;">
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>Código do centro</td>
                    <td>
                        <asp:TextBox ID="txtCodCentro" runat="server"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="btnPesqCentro" runat="server" Text="Pesquisar centro" OnClick="btnPesqCentro_Click" />
                    </td>
                    <td>
                        <asp:Button ID="btnLimparCentro" runat="server" Text="Limpar Código de Centro" OnClick="btnLimparCentro_Click"/>
                    </td>
                </tr>
                <tr>
                    <td class="auto-style1"></td>
                    <td class="auto-style1"></td>
                    <td class="auto-style1"></td>
                </tr>
                <tr>
                    <td>Centros</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </div>
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ID_CENTRO" DataSourceID="SqlDataSource1">
            <Columns>
                <asp:BoundField DataField="ID_CENTRO" HeaderText="ID_CENTRO" ReadOnly="True" SortExpression="ID_CENTRO" />
                <asp:BoundField DataField="CENTRO" HeaderText="CENTRO" SortExpression="CENTRO" />
                <asp:BoundField DataField="MORADA" HeaderText="MORADA" SortExpression="MORADA" />
                <asp:BoundField DataField="TELEFONE" HeaderText="TELEFONE" SortExpression="TELEFONE" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConflictDetection="CompareAllValues" ConnectionString="<%$ ConnectionStrings:BD23Etapa3 %>" OldValuesParameterFormatString="original_{0}" ProviderName="<%$ ConnectionStrings:BD23Etapa3.ProviderName %>" SelectCommand="SELECT * FROM [CENTRO]">
            <DeleteParameters>
                <asp:Parameter Name="original_ID_CENTRO" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="ID_CENTRO" Type="Int32" />
                <asp:Parameter Name="CENTRO" Type="String" />
                <asp:Parameter Name="MORADA" Type="String" />
                <asp:Parameter Name="TELEFONE" Type="Int32" />
            </InsertParameters>
        </asp:SqlDataSource>
    </form>
</body>
</html>
