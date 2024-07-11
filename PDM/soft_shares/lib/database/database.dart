// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:path/path.dart';
import 'package:soft_shares/database/server.dart';
import 'package:sqflite/sqflite.dart';

import 'var.dart' as globals;

class DatabaseHelper {
  DatabaseHelper._private();
  
  //construtor privado
  static final DatabaseHelper instance = DatabaseHelper._private();
  //instancia da base de dados
  static Database? _database;

  

  //padrao singleton
  Future<Database> get database async {
    
    if (_database != null) return _database!;
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      create table CENTRO (
         ID_CENTRO            INTEGER PRIMARY KEY,
         CENTRO               varchar(100)                 not null,
         MORADA               varchar(100)                 not null,
         TELEFONE             int                  null
      ); ''');
    await db.execute('''
      create table UTILIZADORES (
         ID_UTILIZADOR        INTEGER PRIMARY KEY,
         ID_CENTRO            int                  not null,
         NOME                 varchar(100)                 not null,
         DESCRICAO            varchar(100)                 null,
         MORADA               varchar(100)                 null,
         DATANASCIMENTO       datetime             null,
         DATAREGISTO          datetime             null,
         TELEFONE             int                  null,
         EMAIL                varchar(100)                 not null,
         PASSWORD             varchar(255)                 not null,
         IMAGEMPERFIL         varchar(255)         null,
         ATIVO                bit                  null default 1,
         DATAULTIMA_ALTERACAO datetime             null,
         
         constraint FK_UTILIZAD_FAZ_PARTE_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      );''');
    await db.execute('''
      create table ADMINISTRADORES (
         ID_UTILIZADOR        INTEGER PRIMARY KEY,
         ID_CENTRO            int                  not null,
         DATAFICOUADMIN       datetime             null,
         
         constraint FK_ADMINIST_ADMINS_CE_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO),
         constraint FK_ADMINIST_UTILIZADO_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      );''');

    await db.execute('''
      create table AREASDEATUACAO (
         ID_AREA              INTEGER PRIMARY KEY,
         ID_CENTRO            int                  null,
         ADMIN_CRIOU          int                  null,
         ADMIN_EDITOU         int                  null,
         DATA_CRIACAO         datetime             null,
         IMAGEMAREA           varchar(255)                null,
         NOME                 varchar(100)                 not null,
         NOMEENG              varchar(100)                 null,
         NOMEESP              varchar(100)                 null,
         DATA_ALTERACAO       datetime             null,
         
         constraint FK_AREASDEA_ADMINS_AR_ADMINIST foreign key (ADMIN_CRIOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_AREASDEA_ADMIN_EDI_ADMINIST foreign key (ADMIN_EDITOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_AREASDEA_AREAS_CEN_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      );''');

    await db.execute('''
      create table SUB_AREA_ATUACAO (
         ID_SUBAREA           INTEGER PRIMARY KEY,
         ID_CENTRO            int                  null,
         ID_AREA              int                  not null,
         ADMIN_CRIOU          int                  null,
         ADMIN_EDITOU         int                  null,
         DATA_CRIACAO         datetime             null,
         IMAGEMSUBAREA        varchar(255)                null,
         NOME                 varchar(100)                 not null,
         NOMEENG              varchar(100)                 null,
         NOMEESP              varchar(100)                 null,
         DATA_ALTERACAO       datetime             null,
         
         constraint FK_SUB_AREA_SUBAREA_A_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA),
         constraint FK_SUB_AREA_ADMINS_SU_ADMINIST foreign key (ADMIN_CRIOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_SUB_AREA_ADMIN_EDI_ADMINIST foreign key (ADMIN_EDITOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_SUB_AREA_SUBAREAS__CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      );''');


    await db.execute('''
      create table CONTEUDO (
         ID_CONTEUDO          INTEGER PRIMARY KEY,
         ID_CENTRO            int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_UTILIZADOR        int                  not null,
         ADM_ID_UTILIZADOR    int                  null,
         NOMECONTEUDO         varchar(100)                 not null,
         MORADA               varchar(100)                 not null,
         HORARIO              varchar(100)                 null,
         TELEFONE             int                  not null,
         IMAGEMCONTEUDO       varchar(255)                null,
         WEBSITE              varchar(100)                 null,
         ACESSIBILIDADE       varchar(100)                 null,
         DATACRIACAOCONTEUDO  datetime             null,
         REVISTO              bit                  null default 0,
         DATA_ULT_ALTERACAO   datetime             null,
         
         constraint FK_CONTEUDO_CONTEM_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_CONTEUDO_CRIACAO_C_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_CONTEUDO_CONTEUDO__CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO),
         constraint FK_CONTEUDO_ADMINSREV_ADMINIST foreign key (ADM_ID_UTILIZADOR)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_CONTEUDO_AREA_CONT_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA)
      );''');

    await db.execute('''
      create table AVALIACOES (
         ID_AVALIACAO         INTEGER PRIMARY KEY,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         AVALIACAOGERAL       int              null,
         AVALIACAOPRECO       int              null,
         DATAAVALIACAO        datetime             not null,
         
         constraint FK_AVALIACO_AVALIACAO_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO),
         constraint FK_AVALIACO_REALIZAM_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      );''');

    await db.execute('''
      create table EVENTOS (
         ID_EVENTO            INTEGER PRIMARY KEY,
         ID_CENTRO            int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_UTILIZADOR        int                  not null,
         ADM_ID_UTILIZADOR    int                  null,
         NOME                 varchar(100)                 not null,
         DATA                 datetime             not null,
         LOCALIZACAO          varchar(100)                 not null,
         IMAGEMEVENTO         varchar(255)                null,
         TELEFONE             int                  null,
         DESCRICAO            varchar(100)                 null,
         PRECO                decimal              not null,
         DATACRIACAOEVENTO    datetime             null,
         REVISTO              bit                  null default 0,
         DATA_ULTIMA_ALTERACAO datetime             null,
         
         constraint FK_EVENTOS_EVENTOS_P_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_EVENTOS_ADMINREVE_ADMINIST foreign key (ADM_ID_UTILIZADOR)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_EVENTOS_EVENTOS_C_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO),
         constraint FK_EVENTOS_AREA_EVEN_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA),
         constraint FK_EVENTOS_UT_CRIA_E_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      );''');

    await db.execute('''
      create table FAVORITOS (
         IDFAVORITO           INTEGER PRIMARY KEY,
         ID_CENTRO            int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         DATAFAVORITO         datetime             null,
         
         constraint FK_FAVORITO_UTILIZADO_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FAVORITO_RELATIONS_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO),
         constraint FK_FAVORITO_FAVORITOS_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO),
         constraint FK_FAVORITO_SUBAREA_F_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_FAVORITO_AREAS_FAV_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA)
      );''');

    await db.execute('''
      create table FOTOGRAFIAS_CONTEUDO (
         ID_FOTO              INTEGER PRIMARY KEY,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         DESCRICAO            varchar(100)                 null,
         LOCALIZACAO          varchar(100)                 null,
         DATA_CRIACAO         datetime             null,
         IMAGEM               varchar(255)                null,
         VISIBILIDADE         bit                  null default 1,
         DATA_ULT_ALTERACAO   datetime             null,
         
         constraint FK_FOTOGRAF_U_ADD_FOT_CONTEUDO foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FOTOGRAF_FOTOS_CON_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO)
      );''');

    await db.execute('''
      create table FOTOGRAFIAS_EVENTOS (
         ID_FOTO_EVENTO       INTEGER PRIMARY KEY,
         ID_EVENTO            int                  not null,
         ID_UTILIZADOR        int                  not null,
         DESCRICAO            varchar(100)                 null,
         LOCALIZACAO          varchar(100)                 null,
         DATA_CRIACAO         datetime             null,
         IMAGEM               varchar(255)                null,
         VISIBILIDADE         bit                  null default 1,
         DATA_ULT_ALTERACAO   datetime             null,
         
         constraint FK_FOTOGRAF_U_ADD_FOT_EVENTOS foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FOTOGRAF_FOTOS_EVE_EVENTOS foreign key (ID_EVENTO)
            references EVENTOS (ID_EVENTO)
      );''');

    await db.execute('''
      create table INSCRICOES_EVENTOS (
         ID_INSCRICAO         INTEGER PRIMARY KEY,
         ID_EVENTO            int                  not null,
         ID_UTILIZADOR        int                  not null,
         DATAINSCRICAO        datetime             null,
         
         constraint FK_INSCRICO_INSCRICAO_EVENTOS foreign key (ID_EVENTO)
            references EVENTOS (ID_EVENTO),
         constraint FK_INSCRICO_U_INSCREV_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      );''');
  }


//Atualizar os dados vindos do ficheiro server
Future<void> atualizarDados() async{
  await apagartabela();

  //inserir os dados vindos do ficheiro server
  //Centros
  List<Map<String, dynamic>> centros = await getCentros();
  for (var centro in centros) {
    if(centro['TELEFONE'] == null){
      centro['TELEFONE'] = 0;
    }
    await inserircentro(centro['CENTRO'], centro['MORADA'], centro['TELEFONE']);
  }

  //Utilizadores
  List<Map<String, dynamic>> utilizadores = await getUtilizadores();
  for (var utilizador in utilizadores) {
    if(utilizador['TELEFONE'] == null){
      utilizador['TELEFONE'] = 0;
    }
    await inserirutilizador(
      utilizador['ID_CENTRO'],
      utilizador['NOME'].toString(),
      utilizador['DESCRICAO'].toString(),
      utilizador['MORADA'].toString(),
      utilizador['DATANASCIMENTO'].toString(),
      utilizador['DATAREGISTO'].toString(),
      utilizador['TELEFONE'],
      utilizador['EMAIL'].toString(),
      utilizador['PASSWORD'].toString(),
      utilizador['IMAGEMPERFIL'].toString(),
      utilizador['ATIVO'],
      utilizador['DATAULTIMA_ALTERACAO'].toString(),
    );
  }

  //Administradores
  List<Map<String, dynamic>> administradores = await getAdmins();
  for (var administrador in administradores) {
    await inseriradministradores(
      administrador['ID_UTILIZADOR'],
      administrador['ID_CENTRO'],
      administrador['DATAFICOUADMIN'].toString(),
    );
  }

  //Areas
  List<Map<String, dynamic>> areas = await getAreas();
  for (var area in areas) {
    await inserirareasdeatuacao(
      area['ID_AREA'],
      area['ID_CENTRO'],
      area['ADMIN_CRIOU'],
      area['ADMIN_EDITOU'],
      area['DATA_CRIACAO'].toString(),
      area['IMAGEMAREA'].toString(),
      area['NOME'].toString(),
      area['NOMEENG'].toString(),
      area['NOMEESP'].toString(),
      area['DATA_ALTERACAO'].toString(),
    );
  }

  //SubAreas
  List<Map<String, dynamic>> subareas = await getSubAreas();
  for (var subarea in subareas) {
    await inserirsubareaatuacao(
      subarea['ID_SUBAREA'],
      subarea['ID_CENTRO'],
      subarea['ID_AREA'],
      subarea['ADMIN_CRIOU'],
      subarea['ADMIN_EDITOU'],
      subarea['DATA_CRIACAO'].toString(),
      subarea['IMAGEMSUBAREA'].toString(),
      subarea['NOME'].toString(),
      subarea['NOMEENG'].toString(),
      subarea['NOMEESP'].toString(),
      subarea['DATA_ALTERACAO'].toString(),
    );
  }

  //Conteudo
  List<Map<String, dynamic>> conteudos = await getConteudos();
  for (var conteudo in conteudos) {
    if(conteudo['TELEFONE'] == null){
      conteudo['TELEFONE'] = 0;
    }

    if(conteudo['ADM_ID_UTILIZADOR'] == null){
      conteudo['ADM_ID_UTILIZADOR'] = 0;
    }

    await inserirconteudo(
      conteudo['ID_CONTEUDO'],
      conteudo['ID_CENTRO'],
      conteudo['ID_AREA'],
      conteudo['ID_SUBAREA'],
      conteudo['ID_UTILIZADOR'],
      conteudo['ADM_ID_UTILIZADOR'],
      conteudo['NOMECONTEUDO'].toString(),
      conteudo['MORADA'].toString(),
      conteudo['HORARIO'].toString(),
      conteudo['TELEFONE'].toString(),
      conteudo['IMAGEMCONTEUDO'].toString(),
      conteudo['WEBSITE'].toString(),
      conteudo['ACESSIBILIDADE'].toString(),
      conteudo['DATACRIACAOCONTEUDO'].toString(),
      conteudo['REVISTO'],
      conteudo['DATA_ULT_ALTERACAO'].toString(),
    );
  }


  //Avaliacoes
  List<Map<String, dynamic>> avaliacoes = await getAvaliacoes();
  for (var avaliacao in avaliacoes) {
    await inseriravaliacoes(
      avaliacao['ID_AVALIACAO'],
      avaliacao['ID_CONTEUDO'],
      avaliacao['ID_UTILIZADOR'],
      avaliacao['AVALIACAOGERAL'],
      avaliacao['AVALIACAOPRECO'],
      avaliacao['DATAAVALIACAO'].toString(),
    );
  }

  //Eventos
  List<Map<String, dynamic>> eventos = await getEventos();
  for (var evento in eventos) {
    if(evento['TELEFONE'] == null){
      evento['TELEFONE'] = 0;
    }

    if(evento['ADM_ID_UTILIZADOR'] == null){
      evento['ADM_ID_UTILIZADOR'] = 0;
    }

    await inserireventos(
      evento['ID_EVENTO'],
      evento['ID_CENTRO'],
      evento['ID_AREA'],
      evento['ID_SUBAREA'],
      evento['ID_UTILIZADOR'],
      evento['ADM_ID_UTILIZADOR'],
      evento['NOME'].toString(),
      evento['DATA'].toString(),
      evento['LOCALIZACAO'].toString(),
      evento['IMAGEMEVENTO'].toString(),
      evento['TELEFONE'],
      evento['DESCRICAO'].toString(),
      evento['PRECO'].toString(),
      evento['DATACRIACAOEVENTO'].toString(),
      evento['REVISTO'],
      evento['DATA_ULTIMA_ALTERACAO'].toString(),
    );
  }

  //Favoritos
  List<Map<String, dynamic>> favoritos = await getFavoritos();
  for (var favorito in favoritos) {
    await inserirfavoritos(
      favorito['IDFAVORITO'],
      favorito['ID_CENTRO'],
      favorito['ID_AREA'],
      favorito['ID_SUBAREA'],
      favorito['ID_CONTEUDO'],
      favorito['ID_UTILIZADOR'],
      favorito['DATAFAVORITO'].toString(),
    );
  }

  //Fotografias Conteudo
  List<Map<String, dynamic>> fotografiasconteudo = await getFotografiasConteudo();
  for (var fotografiaconteudo in fotografiasconteudo) {
    await inserirfotografiasconteudo(
      fotografiaconteudo['ID_FOTO'],
      fotografiaconteudo['ID_CONTEUDO'],
      fotografiaconteudo['ID_UTILIZADOR'],
      fotografiaconteudo['DESCRICAO'].toString(),
      fotografiaconteudo['LOCALIZACAO'].toString(),
      fotografiaconteudo['DATA_CRIACAO'].toString(),
      fotografiaconteudo['IMAGEM'].toString(),
      fotografiaconteudo['VISIBILIDADE'],
      fotografiaconteudo['DATA_ULT_ALTERACAO'].toString(),
    );
  } 

  //Fotografias Eventos
  List<Map<String, dynamic>> fotografiaseventos = await getFotografiasEventos();
  for (var fotografiaevento in fotografiaseventos) {
    await inserirfotografiaseventos(
      fotografiaevento['ID_FOTO_EVENTO'],
      fotografiaevento['ID_EVENTO'],
      fotografiaevento['ID_UTILIZADOR'],
      fotografiaevento['DESCRICAO'].toString(),
      fotografiaevento['LOCALIZACAO'].toString(),
      fotografiaevento['DATA_CRIACAO'].toString(),
      fotografiaevento['IMAGEM'].toString(),
      fotografiaevento['VISIBILIDADE'],
      fotografiaevento['DATA_ULT_ALTERACAO'].toString(),
    );
  }

  //incrições eventos
  List<Map<String, dynamic>> inscricaoeventos = await getInscricoesEventos();
  for (var inscricaoevento in inscricaoeventos) {
    await inseririnscricaoeventos(
      inscricaoevento['ID_INSCRICAO'],
      inscricaoevento['ID_EVENTO'],
      inscricaoevento['ID_UTILIZADOR'],
      inscricaoevento['DATAINSCRICAO'].toString(),
    );
  }

}



//apagar todas as tabelas da base de dados local
  Future<void> apagartabela() async {
    final db = await instance.database;
    //verificar se existe a tabela centro
    var table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='CENTRO'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE CENTRO');
    }
    
    //verificar se existe a tabela utilizadores
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='UTILIZADORES'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE UTILIZADORES');
    }

    //verificar se existe a tabela administradores
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='ADMINISTRADORES'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE ADMINISTRADORES');
    }

    //verificar se existe a tabela areasdeatuacao
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='AREASDEATUACAO'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE AREASDEATUACAO');
    }

    //verificar se existe a tabela subareaatuacao
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='SUB_AREA_ATUACAO'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE SUB_AREA_ATUACAO');
    }

    //verificar se existe a tabela conteudo
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='CONTEUDO'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE CONTEUDO');
    }

    //verificar se existe a tabela avaliacoes
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='AVALIACOES'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE AVALIACOES');
    }

    //verificar se existe a tabela documentos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='DOCUMENTOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE DOCUMENTOS');
    }

    //verificar se existe a tabela eventos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='EVENTOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE EVENTOS');
    }

    //verificar se existe a tabela favoritos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='FAVORITOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE FAVORITOS');
    }

    //verificar se existe a tabela fotografiasconteudo
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='FOTOGRAFIAS_CONTEUDO'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE FOTOGRAFIAS_CONTEUDO');
    }

    //verificar se existe a tabela fotografiaseventos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='FOTOGRAFIAS_EVENTOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE FOTOGRAFIAS_EVENTOS');
    }

    //verificar se existe a tabela grupos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='GRUPOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE GRUPOS');
    }

    //verificar se existe a tabela inscricaoeventos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='INSCRICOES_EVENTOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE INSCRICOES_EVENTOS');
    }

    //verificar se existe a tabela inscricaogrupos
    table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='INSCRICOES_GRUPOS'");
    if (table.isNotEmpty) {
      await db.execute('DROP TABLE INSCRICOES_GRUPOS');
    }

    await _createTable(db, 1);
  }

  //inserir os dados na base de dados local

  Future<void> inserircentro(String centro, String morada, int telefone) async {
    final db = await instance.database;
    await db.insert(
      'CENTRO' ,
      {'CENTRO': centro, 'MORADA': morada, 'TELEFONE': telefone},
    );
  }

  Future<void> inserirutilizador(
      int idCentro,
      String nome,
      String descricao,
      String morada,
      String datanascimento,
      String dataregisto,
      int telefone,
      String email,
      String password,
      String imagemperfil,
      bool ativo,
       dataultimaalteracao) async {
    final db = await instance.database;
    await db.insert(
      'UTILIZADORES',
      {
        'ID_CENTRO': idCentro,
        'NOME': nome,
        'DESCRICAO': descricao,
        'MORADA': morada,
        'DATANASCIMENTO': datanascimento,
        'DATAREGISTO': dataregisto,
        'TELEFONE': telefone,
        'EMAIL': email,
        'PASSWORD': password,
        'IMAGEMPERFIL': imagemperfil,
        'ATIVO': ativo,
        'DATAULTIMA_ALTERACAO': dataultimaalteracao
      },
    );
  }

  Future<void> inseriradministradores(
      int idUtilizador, int idCentro, String dataficouadmin) async {
    final db = await instance.database;
    await db.insert(
      'ADMINISTRADORES',
      {
        'ID_UTILIZADOR': idUtilizador,
        'ID_CENTRO': idCentro,
        'DATAFICOUADMIN': dataficouadmin,
      },
    );
  }

  Future<void> inserirareasdeatuacao(
      int idArea,
      int idCentro,
      int adminCriou,
      int adminEditou,
      String dataCriacao,
      String imagemarea,
      String nome,
      String nomeeng,
      String nomeesp,
      String dataAlteracao) async {
    final db = await instance.database;
    await db.insert(
      'AREASDEATUACAO',
      {
        'ID_AREA': idArea,
        'ID_CENTRO': idCentro,
        'ADMIN_CRIOU': adminCriou,
        'ADMIN_EDITOU': adminEditou,
        'DATA_CRIACAO': dataCriacao,
        'IMAGEMAREA': imagemarea,
        'NOME': nome,
        'NOMEENG': nomeeng,
        'NOMEESP': nomeesp,
        'DATA_ALTERACAO': dataAlteracao
      },
    );
  }

  Future<void> inserirsubareaatuacao(
      int idSubarea,
      int idCentro,
      int idArea,
      int adminCriou,
      int adminEditou,
      String dataCriacao,
      String imagemsubarea,
      String nome,
      String nomeeng,
      String nomeesp,
      String dataAlteracao) async {
    final db = await instance.database;
    await db.insert(
      'SUB_AREA_ATUACAO',
      {
        'ID_SUBAREA': idSubarea,
        'ID_CENTRO': idCentro,
        'ID_AREA': idArea,
        'ADMIN_CRIOU': adminCriou,
        'ADMIN_EDITOU': adminEditou,
        'DATA_CRIACAO': dataCriacao,
        'IMAGEMSUBAREA': imagemsubarea,
        'NOME': nome,
        'NOMEENG': nomeeng,
        'NOMEESP': nomeesp,
        'DATA_ALTERACAO': dataAlteracao
      },
    );
  }

  Future<void> inserirconteudo(
      int idConteudo,
      int idCentro,
      int idArea,
      int idSubarea,
      int idUtilizador,
      int admIdUtilizador,
      String nomeconteudo,
      String morada,
      String horario,
      String telefone,
      String imagemconteudo,
      String website,
      String acessibilidade,
      String datacriacaoconteudo,
      bool revisto,
      String dataUltAlteracao) async {
    final db = await instance.database;
    await db.insert(
      'CONTEUDO',
      {
        'ID_CONTEUDO': idConteudo,
        'ID_CENTRO': idCentro,
        'ID_AREA': idArea,
        'ID_SUBAREA': idSubarea,
        'ID_UTILIZADOR': idUtilizador,
        'ADM_ID_UTILIZADOR': admIdUtilizador,
        'NOMECONTEUDO': nomeconteudo,
        'MORADA': morada,
        'HORARIO': horario,
        'TELEFONE': telefone,
        'IMAGEMCONTEUDO': imagemconteudo,
        'WEBSITE': website,
        'ACESSIBILIDADE': acessibilidade,
        'DATACRIACAOCONTEUDO': datacriacaoconteudo,
        'REVISTO': revisto,
        'DATA_ULT_ALTERACAO': dataUltAlteracao
      },
    );
  }

  Future<void> inseriravaliacoes(int idAvaliacao, int idConteudo,
      int idUtilizador, int avaliacaogeral, int avaliacaopreco, String dataavaliacao) async {
    final db = await instance.database;
    await db.insert(
      'AVALIACOES',
      {
        'ID_AVALIACAO': idAvaliacao,
        'ID_CONTEUDO': idConteudo,
        'ID_UTILIZADOR': idUtilizador,
        'AVALIACAOGERAL': avaliacaogeral,
        'AVALIACAOPRECO': avaliacaopreco,
        'DATAAVALIACAO': dataavaliacao
      },
    );
  }

  Future<void> inserirdocumentos(int idDocumento, int idSubarea, int idAdmin,
      String descricao, String tipo, String caminhoUrl, String datacriacao) async {
    final db = await instance.database;
    await db.insert(
      'DOCUMENTOS',
      {
        'ID_DOCUMENTO': idDocumento,
        'ID_SUBAREA': idSubarea,
        'ID_ADMIN': idAdmin,
        'DESCRICAO': descricao,
        'TIPO': tipo,
        'CAMINHO_URL': caminhoUrl,
        'DATACRIACAO': datacriacao
      },
    );
  }

  Future<void> inserireventos(
      int idEvento,
      int idCentro,
      int idArea,
      int idSubarea,
      int idUtilizador,
      int admIdUtilizador,
      String nome,
      String data,
      String localizacao,
      String imagemevento,
      int telefone,
      String descricao,
      String preco,
      String datacriacaoevento,
      bool revisto,
      String dataUltimaAlteracao) async {
    final db = await instance.database;
    await db.insert(
      'EVENTOS',
      {
        'ID_EVENTO': idEvento,
        'ID_CENTRO': idCentro,
        'ID_AREA': idArea,
        'ID_SUBAREA': idSubarea,
        'ID_UTILIZADOR': idUtilizador,
        'ADM_ID_UTILIZADOR': admIdUtilizador,
        'NOME': nome,
        'DATA': data,
        'LOCALIZACAO': localizacao,
        'IMAGEMEVENTO': imagemevento,
        'TELEFONE': telefone,
        'DESCRICAO': descricao,
        'PRECO': preco,
        'DATACRIACAOEVENTO': datacriacaoevento,
        'REVISTO': revisto,
        'DATA_ULTIMA_ALTERACAO': dataUltimaAlteracao
      },
    );
  }

  Future<void> inserirfavoritos(int idfavorito, int idCentro, int idArea,
      int idSubarea, int idConteudo, int idUtilizador, String datafavorito) async {
    final db = await instance.database;
    await db.insert(
      'FAVORITOS',
      {
        'IDFAVORITO': idfavorito,
        'ID_CENTRO': idCentro,
        'ID_AREA': idArea,
        'ID_SUBAREA': idSubarea,
        'ID_CONTEUDO': idConteudo,
        'ID_UTILIZADOR': idUtilizador,
        'DATAFAVORITO': datafavorito
      },
    );
  }

  Future<void> inserirfotografiasconteudo(
      int idFoto,
      int idConteudo,
      int idUtilizador,
      String descricao,
      String localizacao,
      String dataCriacao,
      String imagem,
      int visibilidade,
      String dataUltAlteracao) async {
    final db = await instance.database;
    await db.insert(
      'FOTOGRAFIAS_CONTEUDO',
      {
        'ID_FOTO': idFoto,
        'ID_CONTEUDO': idConteudo,
        'ID_UTILIZADOR': idUtilizador,
        'DESCRICAO': descricao,
        'LOCALIZACAO': localizacao,
        'DATA_CRIACAO': dataCriacao,
        'IMAGEM': imagem,
        'VISIBILIDADE': visibilidade,
        'DATA_ULT_ALTERACAO': dataUltAlteracao
      },
    );
  }

  Future<void> inserirfotografiaseventos(
      int idFotoEvento,
      int idEvento,
      int idUtilizador,
      String descricao,
      String localizacao,
      String dataCriacao,
      String imagem,
      bool visibilidade,
      String dataUltAlteracao) async {
    final db = await instance.database;
    await db.insert(
      'FOTOGRAFIAS_EVENTOS',
      {
        'ID_FOTO_EVENTO': idFotoEvento,
        'ID_EVENTO': idEvento,
        'ID_UTILIZADOR': idUtilizador,
        'DESCRICAO': descricao,
        'LOCALIZACAO': localizacao,
        'DATA_CRIACAO': dataCriacao,
        'IMAGEM': imagem,
        'VISIBILIDADE': visibilidade,
        'DATA_ULT_ALTERACAO': dataUltAlteracao
      },
    );
  }

  Future<void> inserirgrupos(int idGrupo, int idArea, int idSubarea,
      int idUtilizador, String nome, int nmaximomembros, String imagem, String dataCriacao) async {
    final db = await instance.database;
    await db.insert(
      'GRUPOS',
      {
        'ID_GRUPO': idGrupo,
        'ID_AREA': idArea,
        'ID_SUBAREA': idSubarea,
        'ID_UTILIZADOR': idUtilizador,
        'NOME': nome,
        'NMAXIMOMEMBROS': nmaximomembros,
        'IMAGEM': imagem,
        'DATA_CRIACAO': dataCriacao
      },
    );
  }	

  Future<void> inseririnscricaoeventos(
      int idInscricao,
      int idEvento,
      int idUtilizador,
      String datainscricao) async {
    final db = await instance.database;
    await db.insert(
      'INSCRICOES_EVENTOS',
      {
        'ID_INSCRICAO': idInscricao,
        'ID_EVENTO': idEvento,
        'ID_UTILIZADOR': idUtilizador,
        'DATAINSCRICAO': datainscricao
      },
    );
  }

  Future<void> inseririnscricaogrupos(
      int idInscricaogrupo,
      int idUtilizador,
      int idGrupo,
      String datainscricao) async {
    final db = await instance.database;
    await db.insert(
      'INSCRICOES_GRUPOS',
      {
        'ID_INSCRICAOGRUPO': idInscricaogrupo,
        'ID_UTILIZADOR': idUtilizador,
        'ID_GRUPO': idGrupo,
        'DATAINSCRICAO': datainscricao
      },
    );
  }

  //consultas simples para a base de dados local

  Future<void> consultaSimplesCentro() async{
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('CENTRO');
    print(result);
  }

  Future<void> inserirDoisCentros() async {
    await inserircentro('Centro 1', 'Rua da Alegria, 1', 123456789);
    await inserircentro('Centro 2', 'Rua da Alegria, 2', 223456789);
  }

  Future<void> inserirDuasAreas() async{
    await inserirareasdeatuacao(1, 1, 1, 1, '2021-10-10', 'imagem1', 'Area 1', 'Area 1', 'Area 1', '2021-10-10');
    await inserirareasdeatuacao(2, 2, 2, 2, '2021-10-10', 'imagem2', 'Area 2', 'Area 2', 'Area 2', '2021-10-10');
  
  }

  Future<void> consultaSimplesAreas() async{
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('AREASDEATUACAO');
    print(result);
  }


  Future<void> mostrarTabelas() async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print(result);
  }

  //retorna lista das tabelas existentes
  Future<List<Map<String, dynamic>>> listCentros() async {
    final db = await instance.database;
    return await db.query('CENTRO');
  }

  Future<List<Map<String, dynamic>>> listUtilizadores() async {
    final db = await instance.database;
    return await db.query('UTILIZADORES');
  }

  Future<List<Map<String, dynamic>>> listAdmins() async {
    final db = await instance.database;
    return await db.query('ADMINISTRADORES');
  }

  Future<List<Map<String, dynamic>>> listAreas() async {
    final db = await instance.database;
    return await db.query('AREASDEATUACAO');
  }

  Future<List<Map<String, dynamic>>> listSubAreas() async {
    final db = await instance.database;
    return await db.query('SUB_AREA_ATUACAO');
  }

  Future<List<Map<String, dynamic>>> listConteudo() async {
    final db = await instance.database;
    return await db.query('CONTEUDO');
  }

  Future<List<Map<String, dynamic>>> listAvaliacoes() async {
    final db = await instance.database;
    return await db.query('AVALIACOES');
  }

  Future<List<Map<String, dynamic>>> listEventos() async {
    final db = await instance.database;
    return await db.query('EVENTOS');
  }

  Future<List<Map<String, dynamic>>> listFavoritos() async {
    final db = await instance.database;
    return await db.query('FAVORITOS');
  }

  Future<List<Map<String, dynamic>>> listFotografiasConteudo() async {
    final db = await instance.database;
    return await db.query('FOTOGRAFIAS_CONTEUDO');
  }

  Future<List<Map<String, dynamic>>> listFotografiasEventos() async {
    final db = await instance.database;
    return await db.query('FOTOGRAFIAS_EVENTOS');
  }

  Future<List<Map<String, dynamic>>> listInscricoesEventos() async {
    final db = await instance.database;
    return await db.query('INSCRICOES_EVENTOS');
  }

  //retorna lista de area de acordo com o id do centro
  Future<List<Map<String, dynamic>>> listAreasCentro() async {
    final db = await instance.database;
    int idCentro = globals.idCentro;
    return await db.query('AREASDEATUACAO', where: 'ID_CENTRO = ?', whereArgs: [idCentro]);
  }

  //retorna as publicaçoes de acordo com o centro area e subarea
  Future<List<Map<String, dynamic>>> listPublicacaoAreaSubArea(int idCentro, int idArea, int idSubArea) async {
    final db = await instance.database;
    return await db.query('CONTEUDO', where: 'ID_CENTRO = ? AND ID_AREA = ? AND ID_SUBAREA = ?', whereArgs: [idCentro, idArea, idSubArea]);
  }

  //retorna a publicaçao de acordo com o id
  Future<Map<String, dynamic>> listPublicacaoId(int idConteudo) async {
    final db = await instance.database;
    Map<String, dynamic> result = (await db.query('CONTEUDO', where: 'ID_CONTEUDO = ?', whereArgs: [idConteudo]))[0];
    return result;
  }

  //retorna a publicaçao de acordo com o id do user
  Future<List<Map<String, dynamic>>> listPublicacaoIdUser(int idUtilizador) async {
    final db = await instance.database;
    return await db.query('CONTEUDO', where: 'ID_UTILIZADOR = ?', whereArgs: [idUtilizador]);
  }

  //retorna as subareas com id area
  Future<List<Map<String, dynamic>>> listSubAreasArea(int idArea) async {
    final db = await instance.database;
    return await db.query('SUB_AREA_ATUACAO', where: 'ID_AREA = ?', whereArgs: [idArea]);
  }

  //retorna um user dando id
  Future<Map<String, dynamic>> listUser(int idUtilizador) async {
    final db = await instance.database;
    Map<String, dynamic> result = (await db.query('UTILIZADORES', where: 'ID_UTILIZADOR = ?', whereArgs: [idUtilizador]))[0];
    return result;
  }

  //login offline e retorna a pessoa 
  Future<Map<String, dynamic>> loginOffline(String email, String password) async {
    final db = await instance.database;
    Map<String, dynamic> result = (await db.query('UTILIZADORES', where: 'EMAIL = ? AND PASSWORD = ?', whereArgs: [email, password]))[0];
    return result;
  }

  Future<void> atualizarDadosServer() async{
    final db = await instance.database;

    //Publicação
    List<Map<String, dynamic>> conteudos = await getConteudos();
    List<Map<String, dynamic>> conteudosLocal = await db.query('CONTEUDO');

    for (var conteudolocal in conteudosLocal){

      bool existe = false;
      for (var conteudo in conteudos){
        if(conteudolocal['ID_CONTEUDO'] == conteudo['ID_CONTEUDO']){
          existe = true;
          break;
        }
      }

      if(!existe){
        await createPublicacao(
          conteudolocal['ID_CENTRO'],
          conteudolocal['ID_AREA'],
          conteudolocal['ID_SUBAREA'],
          conteudolocal['ID_UTILIZADOR'],
          conteudolocal['NOMECONTEUDO'],
          conteudolocal['MORADA'],
          conteudolocal['HORARIO'],
          conteudolocal['TELEFONE'],
          conteudolocal['IMAGEMCONTEUDO'],
          conteudolocal['WEBSITE'],
          conteudolocal['ACESSIBILIDADE']
        );
      }
    }    
  }
} 