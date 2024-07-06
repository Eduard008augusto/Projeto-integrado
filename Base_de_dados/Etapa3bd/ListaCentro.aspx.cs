using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Etapa3bd
{
    public partial class ListaCentro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnPesqCentro_Click(object sender, EventArgs e)
        {
            if (txtCodCentro.Text != "")
            {
                SqlDataSource1.SelectCommand = "SELECT * FROM CENTRO WHERE ID_CENTRO = " + txtCodCentro.Text;
                SqlDataSource1.DataBind();
            }
        }

        protected void btnLimparCentro_Click(object sender, EventArgs e)
        {
            txtCodCentro.Text = "";
            SqlDataSource1.SelectCommand = "SELECT * FROM CENTRO";
            SqlDataSource1.DataBind();
        }
    }
}
