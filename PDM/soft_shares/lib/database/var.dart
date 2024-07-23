library globals;

var idCentro = 1;
var idArea = 0;
var idSubArea = 0;

int? idUtilizador = 0;
String? nomeUtilizador = '';

var idPublicacao = 0;

var nomArea = '';

String? token = '';

var imagem = '';

var idFavorito = 0;
var idConteudo = 0;
var idSubAreaFAV = 0;
var idAvaliacao = 0;
var idEventoINSC = 0;

var idAreaEdit = 0;

// Registo USER
var idCentroUSER = 1;

var nome = '';
var descricaoU = '';
var moradaU = '';
var telefoneU = 0;
var email = '';
var password = '';
DateTime dataNascimento = DateTime.now();

// Criar Publicação
var nomeP = '';
var moradaP = '';
var horarioP = '';
var telefoneP = 0;
var websiteP = '';
var acessibilidadeP = '';

// Eventos
var idEvento = 0;
String? nomeEvento = '';
String? localizacaoEvento = '';
String? websiteEvento = '';
String? acessibilidadeEvento = '';
String? horarioEvento = '';
int? telefoneEvento = 0;
DateTime? dataEvento;
double? precoEvento = 0.0;
String? descricaoEvento = '';
String? imagemEvento = '';
