// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._private();
  static Database? _database;

  DatabaseHelper._private();

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
         ID_CENTRO            int                  not null,
         CENTRO               varchar(100)                 not null,
         MORADA               varchar(100)                 not null,
         TELEFONE             int                  null,
         constraint PK_CENTRO primary key (ID_CENTRO)
      )
      go

      create table UTILIZADORES (
         ID_UTILIZADOR        int                  not null,
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
         constraint PK_UTILIZADORES primary key (ID_UTILIZADOR),
         constraint FK_UTILIZAD_FAZ_PARTE_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      )
      go

      create table ADMINISTRADORES (
         ID_UTILIZADOR        int                  not null,
         ID_CENTRO            int                  not null,
         DATAFICOUADMIN       datetime             null,
         constraint PK_ADMINISTRADORES primary key (ID_UTILIZADOR),
         constraint FK_ADMINIST_ADMINS_CE_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO),
         constraint FK_ADMINIST_UTILIZADO_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table AREASDEATUACAO (
         ID_AREA              int                  not null,
         ID_CENTRO            int                  null,
         ADMIN_CRIOU          int                  null,
         ADMIN_EDITOU         int                  null,
         DATA_CRIACAO         datetime             null,
         IMAGEMAREA           varchar(255)                null,
         NOME                 varchar(100)                 not null,
         NOMEENG              varchar(100)                 null,
         NOMEESP              varchar(100)                 null,
         DATA_ALTERACAO       datetime             null,
         constraint PK_AREASDEATUACAO primary key (ID_AREA),
         constraint FK_AREASDEA_ADMINS_AR_ADMINIST foreign key (ADMIN_CRIOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_AREASDEA_ADMIN_EDI_ADMINIST foreign key (ADMIN_EDITOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_AREASDEA_AREAS_CEN_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      )
      go

      create table SUB_AREA_ATUACAO (
         ID_SUBAREA           int                  not null,
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
         constraint PK_SUB_AREA_ATUACAO primary key (ID_SUBAREA),
         constraint FK_SUB_AREA_SUBAREA_A_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA),
         constraint FK_SUB_AREA_ADMINS_SU_ADMINIST foreign key (ADMIN_CRIOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_SUB_AREA_ADMIN_EDI_ADMINIST foreign key (ADMIN_EDITOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_SUB_AREA_SUBAREAS__CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      )
      go

      create table CONTEUDO (
         ID_CONTEUDO          int                  not null,
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
         constraint PK_CONTEUDO primary key (ID_CONTEUDO),
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
      )
      go

      create table AVALIACOES (
         ID_AVALIACAO         int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         AVALIACAOGERAL       int              null,
         AVALIACAOPRECO       int              null,
         DATAAVALIACAO        datetime             not null,
         constraint PK_AVALIACOES primary key (ID_AVALIACAO),
         constraint FK_AVALIACO_AVALIACAO_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO),
         constraint FK_AVALIACO_REALIZAM_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table DOCUMENTOS (
         ID_DOCUMENTO         int                  not null,
         ID_SUBAREA           int                  not null,
         ID_ADMIN             int                  null,
         DESCRICAO            varchar(100)                 null,
         TIPO                 varchar(100)                 not null,
         CAMINHO_URL          varchar(100)                 not null,
         DATACRIACAO          datetime             null,
         constraint PK_DOCUMENTOS primary key (ID_DOCUMENTO),
         constraint FK_DOCUMENT_SUBAREA_C_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_DOCUMENT_ADMINS_DO_ADMINIST foreign key (ID_ADMIN)
            references ADMINISTRADORES (ID_UTILIZADOR)
      )
      go

      create table EVENTOS (
         ID_EVENTO            int                  not null,
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
         constraint PK_EVENTOS primary key (ID_EVENTO),
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
      )
      go

      create table FAVORITOS (
         IDFAVORITO           int                  not null,
         ID_CENTRO            int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         DATAFAVORITO         datetime             null,
         constraint PK_FAVORITOS primary key (IDFAVORITO),
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
      )
      go

      create table FOTOGRAFIAS_CONTEUDO (
         ID_FOTO              int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         DESCRICAO            varchar(100)                 null,
         LOCALIZACAO          varchar(100)                 null,
         DATA_CRIACAO         datetime             null,
         IMAGEM               varchar(255)                null,
         VISIBILIDADE         bit                  null default 1,
         DATA_ULT_ALTERACAO   datetime             null,
         constraint PK_FOTOGRAFIAS_CONTEUDO primary key (ID_FOTO),
         constraint FK_FOTOGRAF_U_ADD_FOT_CONTEUDO foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FOTOGRAF_FOTOS_CON_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO)
      )
      go

      create table FOTOGRAFIAS_EVENTOS (
         ID_FOTO_EVENTO       int                  not null,
         ID_EVENTO            int                  not null,
         ID_UTILIZADOR        int                  not null,
         DESCRICAO            varchar(100)                 null,
         LOCALIZACAO          varchar(100)                 null,
         DATA_CRIACAO         datetime             null,
         IMAGEM               varchar(255)                null,
         VISIBILIDADE         bit                  null default 1,
         DATA_ULT_ALTERACAO   datetime             null,
         constraint PK_FOTOGRAFIAS_EVENTOS primary key (ID_FOTO_EVENTO),
         constraint FK_FOTOGRAF_U_ADD_FOT_EVENTOS foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FOTOGRAF_FOTOS_EVE_EVENTOS foreign key (ID_EVENTO)
            references EVENTOS (ID_EVENTO)
      )
      go

      create table GRUPOS (
         ID_GRUPO             int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_UTILIZADOR        int                  not null,
         NOME                 varchar(100)                 not null,
         NMAXIMOMEMBROS       int                  null,
         IMAGEM               image                null,
         DATA_CRIACAO         datetime             null,
         constraint PK_GRUPOS primary key (ID_GRUPO),
         constraint FK_GRUPOS_GRUPO_SUB_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_GRUPOS_GRUPO_ARE_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA),
         constraint FK_GRUPOS_U_CRIA_GR_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table INSCRICOES_EVENTOS (
         ID_INSCRICAO         int                  not null,
         ID_EVENTO            int                  not null,
         ID_UTILIZADOR        int                  not null,
         DATAINSCRICAO        datetime             null,
         constraint PK_INSCRICOES_EVENTOS primary key (ID_INSCRICAO),
         constraint FK_INSCRICO_INSCRICAO_EVENTOS foreign key (ID_EVENTO)
            references EVENTOS (ID_EVENTO),
         constraint FK_INSCRICO_U_INSCREV_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table INSCRICOES_GRUPOS (
         ID_INSCRICAOGRUPO    int                  not null,
         ID_UTILIZADOR        int                  not null,
         ID_GRUPO             int                  not null,
         DATAINSCRICAO        datetime             null,
         constraint PK_INSCRICOES_GRUPOS primary key (ID_INSCRICAOGRUPO),
         constraint FK_INSCRICO_INSCRICOE_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_INSCRICO_INSCREVE_GRUPOS foreign key (ID_GRUPO)
            references GRUPOS (ID_GRUPO)
      )
      go
    ''',
    );
  }

  Future<void> criartabela() async {
    final db = await instance.database;
    await db.execute('''
      create table CENTRO (
         ID_CENTRO            int                  not null,
         CENTRO               varchar(100)                 not null,
         MORADA               varchar(100)                 not null,
         TELEFONE             int                  null,
         constraint PK_CENTRO primary key (ID_CENTRO)
      )
      go

      create table UTILIZADORES (
         ID_UTILIZADOR        int                  not null,
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
         constraint PK_UTILIZADORES primary key (ID_UTILIZADOR),
         constraint FK_UTILIZAD_FAZ_PARTE_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      )
      go

      create table ADMINISTRADORES (
         ID_UTILIZADOR        int                  not null,
         ID_CENTRO            int                  not null,
         DATAFICOUADMIN       datetime             null,
         constraint PK_ADMINISTRADORES primary key (ID_UTILIZADOR),
         constraint FK_ADMINIST_ADMINS_CE_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO),
         constraint FK_ADMINIST_UTILIZADO_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table AREASDEATUACAO (
         ID_AREA              int                  not null,
         ID_CENTRO            int                  null,
         ADMIN_CRIOU          int                  null,
         ADMIN_EDITOU         int                  null,
         DATA_CRIACAO         datetime             null,
         IMAGEMAREA           varchar(255)                null,
         NOME                 varchar(100)                 not null,
         NOMEENG              varchar(100)                 null,
         NOMEESP              varchar(100)                 null,
         DATA_ALTERACAO       datetime             null,
         constraint PK_AREASDEATUACAO primary key (ID_AREA),
         constraint FK_AREASDEA_ADMINS_AR_ADMINIST foreign key (ADMIN_CRIOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_AREASDEA_ADMIN_EDI_ADMINIST foreign key (ADMIN_EDITOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_AREASDEA_AREAS_CEN_CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      )
      go

      create table SUB_AREA_ATUACAO (
         ID_SUBAREA           int                  not null,
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
         constraint PK_SUB_AREA_ATUACAO primary key (ID_SUBAREA),
         constraint FK_SUB_AREA_SUBAREA_A_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA),
         constraint FK_SUB_AREA_ADMINS_SU_ADMINIST foreign key (ADMIN_CRIOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_SUB_AREA_ADMIN_EDI_ADMINIST foreign key (ADMIN_EDITOU)
            references ADMINISTRADORES (ID_UTILIZADOR),
         constraint FK_SUB_AREA_SUBAREAS__CENTRO foreign key (ID_CENTRO)
            references CENTRO (ID_CENTRO)
      )
      go

      create table CONTEUDO (
         ID_CONTEUDO          int                  not null,
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
         constraint PK_CONTEUDO primary key (ID_CONTEUDO),
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
      )
      go

      create table AVALIACOES (
         ID_AVALIACAO         int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         AVALIACAOGERAL       int              null,
         AVALIACAOPRECO       int              null,
         DATAAVALIACAO        datetime             not null,
         constraint PK_AVALIACOES primary key (ID_AVALIACAO),
         constraint FK_AVALIACO_AVALIACAO_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO),
         constraint FK_AVALIACO_REALIZAM_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table DOCUMENTOS (
         ID_DOCUMENTO         int                  not null,
         ID_SUBAREA           int                  not null,
         ID_ADMIN             int                  null,
         DESCRICAO            varchar(100)                 null,
         TIPO                 varchar(100)                 not null,
         CAMINHO_URL          varchar(100)                 not null,
         DATACRIACAO          datetime             null,
         constraint PK_DOCUMENTOS primary key (ID_DOCUMENTO),
         constraint FK_DOCUMENT_SUBAREA_C_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_DOCUMENT_ADMINS_DO_ADMINIST foreign key (ID_ADMIN)
            references ADMINISTRADORES (ID_UTILIZADOR)
      )
      go

      create table EVENTOS (
         ID_EVENTO            int                  not null,
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
         constraint PK_EVENTOS primary key (ID_EVENTO),
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
      )
      go

      create table FAVORITOS (
         IDFAVORITO           int                  not null,
         ID_CENTRO            int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         DATAFAVORITO         datetime             null,
         constraint PK_FAVORITOS primary key (IDFAVORITO),
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
      )
      go

      create table FOTOGRAFIAS_CONTEUDO (
         ID_FOTO              int                  not null,
         ID_CONTEUDO          int                  not null,
         ID_UTILIZADOR        int                  not null,
         DESCRICAO            varchar(100)                 null,
         LOCALIZACAO          varchar(100)                 null,
         DATA_CRIACAO         datetime             null,
         IMAGEM               varchar(255)                null,
         VISIBILIDADE         bit                  null default 1,
         DATA_ULT_ALTERACAO   datetime             null,
         constraint PK_FOTOGRAFIAS_CONTEUDO primary key (ID_FOTO),
         constraint FK_FOTOGRAF_U_ADD_FOT_CONTEUDO foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FOTOGRAF_FOTOS_CON_CONTEUDO foreign key (ID_CONTEUDO)
            references CONTEUDO (ID_CONTEUDO)
      )
      go

      create table FOTOGRAFIAS_EVENTOS (
         ID_FOTO_EVENTO       int                  not null,
         ID_EVENTO            int                  not null,
         ID_UTILIZADOR        int                  not null,
         DESCRICAO            varchar(100)                 null,
         LOCALIZACAO          varchar(100)                 null,
         DATA_CRIACAO         datetime             null,
         IMAGEM               varchar(255)                null,
         VISIBILIDADE         bit                  null default 1,
         DATA_ULT_ALTERACAO   datetime             null,
         constraint PK_FOTOGRAFIAS_EVENTOS primary key (ID_FOTO_EVENTO),
         constraint FK_FOTOGRAF_U_ADD_FOT_EVENTOS foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_FOTOGRAF_FOTOS_EVE_EVENTOS foreign key (ID_EVENTO)
            references EVENTOS (ID_EVENTO)
      )
      go

      create table GRUPOS (
         ID_GRUPO             int                  not null,
         ID_AREA              int                  not null,
         ID_SUBAREA           int                  not null,
         ID_UTILIZADOR        int                  not null,
         NOME                 varchar(100)                 not null,
         NMAXIMOMEMBROS       int                  null,
         IMAGEM               image                null,
         DATA_CRIACAO         datetime             null,
         constraint PK_GRUPOS primary key (ID_GRUPO),
         constraint FK_GRUPOS_GRUPO_SUB_SUB_AREA foreign key (ID_SUBAREA)
            references SUB_AREA_ATUACAO (ID_SUBAREA),
         constraint FK_GRUPOS_GRUPO_ARE_AREASDEA foreign key (ID_AREA)
            references AREASDEATUACAO (ID_AREA),
         constraint FK_GRUPOS_U_CRIA_GR_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table INSCRICOES_EVENTOS (
         ID_INSCRICAO         int                  not null,
         ID_EVENTO            int                  not null,
         ID_UTILIZADOR        int                  not null,
         DATAINSCRICAO        datetime             null,
         constraint PK_INSCRICOES_EVENTOS primary key (ID_INSCRICAO),
         constraint FK_INSCRICO_INSCRICAO_EVENTOS foreign key (ID_EVENTO)
            references EVENTOS (ID_EVENTO),
         constraint FK_INSCRICO_U_INSCREV_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR)
      )
      go

      create table INSCRICOES_GRUPOS (
         ID_INSCRICAOGRUPO    int                  not null,
         ID_UTILIZADOR        int                  not null,
         ID_GRUPO             int                  not null,
         DATAINSCRICAO        datetime             null,
         constraint PK_INSCRICOES_GRUPOS primary key (ID_INSCRICAOGRUPO),
         constraint FK_INSCRICO_INSCRICOE_UTILIZAD foreign key (ID_UTILIZADOR)
            references UTILIZADORES (ID_UTILIZADOR),
         constraint FK_INSCRICO_INSCREVE_GRUPOS foreign key (ID_GRUPO)
            references GRUPOS (ID_GRUPO)
      )
      ''',
    );
  }

  /*Future<void> adicionarprod(String nome, String desc) async {
    final db = await instance.database;
    await db.insert(
      'products',
      {'nome': nome, 'desc': desc},
    );
  }*/

  /*Future<List<Map<String, dynamic>>> getprodutos() async {
    final db = await instance.database;
    return await db.query('products');
  }*/

  /*Future <String> pesquisarprod(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    return maps[0]['nome'];
  }*/

  Future<void> apagartabela() async {
    final db = await instance.database;
    await db.execute('''
      drop table INSCRICOES_GRUPOS
      go
      drop table INSCRICOES_EVENTOS
      go
      drop table GRUPOS
      go
      drop table FOTOGRAFIAS_EVENTOS
      go
      drop table FOTOGRAFIAS_CONTEUDO
      go
      drop table FAVORITOS
      go
      drop table EVENTOS
      go
      drop table DOCUMENTOS
      go
      drop table AVALIACOES
      go
      drop table CONTEUDO
      go
      drop table SUB_AREA_ATUACAO
      go
      drop table AREASDEATUACAO
      go
      drop table ADMINISTRADORES
      go
      drop table UTILIZADORES
      go
      drop table CENTRO
      go
      ''');
    await _createTable(db, 1);
  }

  /*Future<void> consultasimples() async {
    final db = await instance.database;
    List<Map> resultado = await db.rawQuery('SELECT id, nome, desc FROM products');
    resultado.forEach((linha) {print(linha);});
  }*/
}