using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Etapa3bd;

namespace Etapa3bd
{
    public partial class Contros : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

         protected void btnInserir_Click(object sender, EventArgs e)
        {
            Base_de_Dados bd = new Base_de_Dados();
            bd.insere_Centro(txtIdCentro.Text, txtCentro.Text, txtMorada.Text, txtTelefone.Text);
            GridView1.DataBind(); // Refresh GridView
            txtIdCentro.Text = "";
            txtCentro.Text = "";
            txtMorada.Text = "";
            txtTelefone.Text = "";
        }

        protected void btnAtualizar_Click(object sender, EventArgs e)
        {
            Base_de_Dados bd = new Base_de_Dados();
            bd.update_Centro(txtIdCentro.Text, txtCentro.Text, txtMorada.Text, txtTelefone.Text);
            GridView1.DataBind(); // Refresh GridView
            txtIdCentro.Text = "";
            txtCentro.Text = "";
            txtMorada.Text = "";
            txtTelefone.Text = "";
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            Base_de_Dados bd = new Base_de_Dados();
            bd.delete_Centro(txtIdCentro.Text);
            GridView1.DataBind(); // Refresh GridView
            txtIdCentro.Text = "";
            txtCentro.Text = "";
            txtMorada.Text = "";
            txtTelefone.Text = "";
        }
    }
}