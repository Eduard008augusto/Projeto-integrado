using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
namespace Etapa3bd
{
    public class Base_de_Dados
    {
        public string strc = "Persist Security Info=True; Data Source=193.137.7.32;User ID = aluno23_111; Password=Rafaus12pj";
        public Base_de_Dados()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public void insere_Centro(string IdCentro, string Centro,string Morada, string Telefone)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter parIdCentro = new SqlParameter();
            SqlParameter parCentro = new SqlParameter();
            SqlParameter parMorada = new SqlParameter();
            SqlParameter parTelefone = new SqlParameter();
            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            //storedprocedure é um tipo da classe commandtype acima declarada
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.CommandText = "InserirCentro";//Nome do procedimento aramazenado
            parIdCentro.ParameterName = "Id_Centro";//nome do parâmetro na definição do procedimento
            parIdCentro.Direction = ParameterDirection.Input;//tipo de parâmetro (entrada, neste caso)
            parIdCentro.Value = IdCentro;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parIdCentro);//adicionar o parâmetro ao objeto command

            parCentro.ParameterName = "Centro";//nome do parâmetro na definição do procedimento
            parCentro.Direction = ParameterDirection.Input; //tipo de parâmetro (entrada, neste caso)
            parCentro.Value = Centro;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parCentro);//adicionar o parâmetro ao objeto command

            parMorada.ParameterName = "Morada";//nome do parâmetro na definição do procedimento
            parMorada.Direction = ParameterDirection.Input; //tipo de parâmetro (entrada, neste caso)
            parMorada.Value = Morada;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parMorada);//adicionar o parâmetro ao objeto command

            parTelefone.ParameterName = "Telefone";//nome do parâmetro na definição do procedimento
            parTelefone.Direction = ParameterDirection.Input; //tipo de parâmetro (entrada, neste caso)
            parTelefone.Value = Telefone;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parTelefone);//adicionar o parâmetro ao objeto command

            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void update_Centro(string IdCentro, string Centro, string Morada, string Telefone)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter parIdCentro = new SqlParameter();
            SqlParameter parCentro = new SqlParameter();
            SqlParameter parMorada = new SqlParameter();
            SqlParameter parTelefone = new SqlParameter();
            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            //storedprocedure é um tipo da classe commandtype acima declarada
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.CommandText = "UpdateCentro";//Nome do procedimento aramazenado

            parIdCentro.ParameterName = "Id_Centro";//nome do parâmetro na definição do procedimento
            parIdCentro.Direction = ParameterDirection.Input;//tipo de parâmetro (entrada, neste caso)
            parIdCentro.Value = IdCentro;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parIdCentro);//adicionar o parâmetro ao objeto command

            parCentro.ParameterName = "Centro";//nome do parâmetro na definição do procedimento
            parCentro.Direction = ParameterDirection.Input; //tipo de parâmetro (entrada, neste caso)
            parCentro.Value = Centro;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parCentro);//adicionar o parâmetro ao objeto command

            parMorada.ParameterName = "Morada";//nome do parâmetro na definição do procedimento
            parMorada.Direction = ParameterDirection.Input; //tipo de parâmetro (entrada, neste caso)
            parMorada.Value = Morada;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parMorada);//adicionar o parâmetro ao objeto command

            parTelefone.ParameterName = "Telefone";//nome do parâmetro na definição do procedimento
            parTelefone.Direction = ParameterDirection.Input; //tipo de parâmetro (entrada, neste caso)
            parTelefone.Value = Telefone;//valor do parâmetro do método e que é passado no code behind
            cmd.Parameters.Add(parTelefone);//adicionar o parâmetro ao objeto command

            cmd.ExecuteNonQuery();
            con.Close();
        }

        public void delete_Centro(string IdCentro)
        {
            SqlConnection con = new SqlConnection();
            SqlCommand cmd = new SqlCommand();
            SqlParameter parIdCentro = new SqlParameter();
            con.ConnectionString = strc;
            con.Open();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.CommandText = "DeleteCentro";
            parIdCentro.ParameterName = "Id_Centro";
            parIdCentro.Direction = ParameterDirection.Input;
            parIdCentro.Value = IdCentro;
            cmd.Parameters.Add(parIdCentro);

            cmd.ExecuteNonQuery();
            con.Close();
        }
    }
}