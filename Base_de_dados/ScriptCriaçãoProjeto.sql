/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2022                    */
/* Created on:     03/04/2024 11:25:59                          */
/*==============================================================*/


if exists (select 1
            from  sysobjects
           where  id = object_id('INSCRICOES_GRUPOS')
            and   type = 'U')
   drop table INSCRICOES_GRUPOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('INSCRICOES_EVENTOS')
            and   type = 'U')
   drop table INSCRICOES_EVENTOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('GRUPOS')
            and   type = 'U')
   drop table GRUPOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FOTOGRAFIAS_EVENTOS')
            and   type = 'U')
   drop table FOTOGRAFIAS_EVENTOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FOTOGRAFIAS')
            and   type = 'U')
   drop table FOTOGRAFIAS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FAVORITOS')
            and   type = 'U')
   drop table FAVORITOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DOCUMENTOS')
            and   type = 'U')
   drop table DOCUMENTOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AVALIACOES')
            and   type = 'U')
   drop table AVALIACOES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONTEUDO')
            and   type = 'U')
   drop table CONTEUDO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ALBUNS_EVENTOS')
            and   type = 'U')
   drop table ALBUNS_EVENTOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('EVENTOS')
            and   type = 'U')
   drop table EVENTOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SUB_AREA_ATUACAO')
            and   type = 'U')
   drop table SUB_AREA_ATUACAO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ALBUNSMOMENTOS')
            and   type = 'U')
   drop table ALBUNSMOMENTOS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AREASDEATUACAO')
            and   type = 'U')
   drop table AREASDEATUACAO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ADMINSCENTROS')
            and   type = 'U')
   drop table ADMINSCENTROS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('UTILIZADORES')
            and   type = 'U')
   drop table UTILIZADORES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CENTRO')
            and   type = 'U')
   drop table CENTRO
go

/*==============================================================*/
/* Table: CENTRO                                                */
/*==============================================================*/
create table CENTRO (
   ID_CENTRO            int                  not null,
   CENTRO               text                 not null,
   MORADA               text                 not null,
   TELEFONE             int                  null,
   constraint PK_CENTRO primary key (ID_CENTRO)
)
go

/*==============================================================*/
/* Table: UTILIZADORES                                          */
/*==============================================================*/
create table UTILIZADORES (
   ID_UTILIZADOR        int                  not null,
   ID_CENTRO            int                  not null,
   NOME                 text                 not null,
   DESCRICAO            text                 null,
   MORADA               text                 null,
   DATANASCIMENTO       datetime             null,
   DATAREGISTO			datetime             null,
   TELEFONE             int                  null,
   EMAIL                text                 not null,
   PASSWORD             text                 not null,
   IMAGEMPERFIL         image                null,
   constraint PK_UTILIZADORES primary key (ID_UTILIZADOR),
   constraint FK_UTILIZAD_FAZ_PARTE_CENTRO foreign key (ID_CENTRO)
      references CENTRO (ID_CENTRO)
)
go

/*==============================================================*/
/* Table: ADMINSCENTROS                                         */
/*==============================================================*/
create table ADMINSCENTROS (
   IDADMINCENTRO        int                  not null,
   ID_CENTRO            int                  not null,
   ID_UTILIZADOR        int                  not null,
   DATAFICOUADMIN       datetime             null,
   constraint PK_ADMINSCENTROS primary key (IDADMINCENTRO),
   constraint FK_ADMINSCE_RELATIONS_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR),
   constraint FK_ADMINSCE_RELATIONS_CENTRO foreign key (ID_CENTRO)
      references CENTRO (ID_CENTRO)
)
go

/*==============================================================*/
/* Table: AREASDEATUACAO                                        */
/*==============================================================*/
create table AREASDEATUACAO (
   ID_AREA              int                  not null,
   IMAGEMAREA           image                null,
   LINGUAGEM            text                 not null,
   NOME                 text                 not null,
   constraint PK_AREASDEATUACAO primary key (ID_AREA)
)
go

/*==============================================================*/
/* Table: ALBUNSMOMENTOS                                        */
/*==============================================================*/
create table ALBUNSMOMENTOS (
   ID_ALBUM             int                  not null,
   ID_AREA              int                  not null,
   ID_UTILIZADOR        int                  not null,
   ID_CENTRO            int                  not null,
   NOME                 text                 not null,
   IMAGEM               image                null,
   DATA_CRIACAO         datetime             null,
   LOCALIZACAO          text                 null,
   VISIBILIDADE         int                  null,
   constraint PK_ALBUNSMOMENTOS primary key (ID_ALBUM),
   constraint FK_ALBUNSMO_ALBUNS_DA_AREASDEA foreign key (ID_AREA)
      references AREASDEATUACAO (ID_AREA),
   constraint FK_ALBUNSMO_U_CRIA_AL_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR),
   constraint FK_ALBUNSMO_ALBUNS_CE_CENTRO foreign key (ID_CENTRO)
      references CENTRO (ID_CENTRO)
)
go

/*==============================================================*/
/* Table: SUB_AREA_ATUACAO                                      */
/*==============================================================*/
create table SUB_AREA_ATUACAO (
   ID_SUBAREA           int                  not null,
   ID_AREA              int                  not null,
   IMAGEMSUBAREA        image                null,
   LINGUAGEM            text                 not null,
   NOME                 text                 not null,
   constraint PK_SUB_AREA_ATUACAO primary key (ID_SUBAREA),
   constraint FK_SUB_AREA_SUBAREA_A_AREASDEA foreign key (ID_AREA)
      references AREASDEATUACAO (ID_AREA)
)
go

/*==============================================================*/
/* Table: EVENTOS                                               */
/*==============================================================*/
create table EVENTOS (
   ID_EVENTO            int                  not null,
   ID_SUBAREA           int                  not null,
   ID_UTILIZADOR        int                  not null,
   ID_CENTRO            int                  not null,
   ID_AREA              int                  not null,
   UTI_ID_UTILIZADOR    int                  not null,
   NOME                 text                 not null,
   DATA                 datetime             not null,
   LOCALIZACAO          text                 not null,
   TELEFONE             int                  null,
   DESCRICAO            text                 null,
   PRECO                numeric              not null,
   REVISTO              bit                  null,
   constraint PK_EVENTOS primary key (ID_EVENTO),
   constraint FK_EVENTOS_EVENTOS_P_SUB_AREA foreign key (ID_SUBAREA)
      references SUB_AREA_ATUACAO (ID_SUBAREA),
   constraint FK_EVENTOS_ADMIN_REV_UTILIZAD foreign key (UTI_ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR),
   constraint FK_EVENTOS_EVENTOS_C_CENTRO foreign key (ID_CENTRO)
      references CENTRO (ID_CENTRO),
   constraint FK_EVENTOS_AREA_EVEN_AREASDEA foreign key (ID_AREA)
      references AREASDEATUACAO (ID_AREA),
   constraint FK_EVENTOS_RELATIONS_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: ALBUNS_EVENTOS                                        */
/*==============================================================*/
create table ALBUNS_EVENTOS (
   ID_ALBUMEVENTO       int                  not null,
   ID_EVENTO            int                  not null,
   ID_UTILIZADOR        int                  null,
   NOME                 text                 not null,
   IMAGEM               image                null,
   DATA_CRIACAO         datetime             null,
   LOCALIZACAO          text                 null,
   VISIBILIDADE         int                  null,
   constraint PK_ALBUNS_EVENTOS primary key (ID_ALBUMEVENTO),
   constraint FK_ALBUNS_E_EVENTOS_A_EVENTOS foreign key (ID_EVENTO)
      references EVENTOS (ID_EVENTO),
   constraint FK_ALBUNS_E_U_CRIA_AL_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: CONTEUDO                                              */
/*==============================================================*/
create table CONTEUDO (
   ID_CONTEUDO          int                  not null,
   ID_CENTRO            int                  not null,
   ID_SUBAREA           int                  not null,
   ID_UTILIZADOR        int                  not null,
   UTI_ID_UTILIZADOR    int                  not null,
   ID_AREA              int                  not null,
   NOMECONTEUDO         text                 not null,
   MORADA               text                 not null,
   HORARIO              text                 not null,
   TELEFONE             int                  not null,
   WEBSITE              text                 null,
   ACESSIBILIDADE       text                 null,
   REVISTO              bit                  null,
   constraint PK_CONTEUDO primary key (ID_CONTEUDO),
   constraint FK_CONTEUDO_CONTEM_SUB_AREA foreign key (ID_SUBAREA)
      references SUB_AREA_ATUACAO (ID_SUBAREA),
   constraint FK_CONTEUDO_CRIACAO_C_UTILIZAD foreign key (UTI_ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR),
   constraint FK_CONTEUDO_CONTEUDO__CENTRO foreign key (ID_CENTRO)
      references CENTRO (ID_CENTRO),
   constraint FK_CONTEUDO_ADMIN_REV_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR),
   constraint FK_CONTEUDO_AREA_CONT_AREASDEA foreign key (ID_AREA)
      references AREASDEATUACAO (ID_AREA)
)
go

/*==============================================================*/
/* Table: AVALIACOES                                            */
/*==============================================================*/
create table AVALIACOES (
   ID_AVALIACAO         int                  not null,
   ID_CONTEUDO          int                  not null,
   ID_UTILIZADOR        int                  not null,
   AVALIACAOGERAL       numeric              null,
   AVALIACAOPRECO       numeric              null,
   DATAAVALIACAO        datetime             null,
   constraint PK_AVALIACOES primary key (ID_AVALIACAO),
   constraint FK_AVALIACO_AVALIACAO_CONTEUDO foreign key (ID_CONTEUDO)
      references CONTEUDO (ID_CONTEUDO),
   constraint FK_AVALIACO_REALIZAM_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: DOCUMENTOS                                            */
/*==============================================================*/
create table DOCUMENTOS (
   ID_DOCUMENTO         int                  not null,
   ID_SUBAREA           int                  not null,
   ID_UTILIZADOR        int                  not null,
   DESCRICAO            text                 null,
   TIPO                 text                 not null,
   CAMINHO_URL          text                 not null,
   DATACRIACAO          datetime             null,
   constraint PK_DOCUMENTOS primary key (ID_DOCUMENTO),
   constraint FK_DOCUMENT_SUBAREA_C_SUB_AREA foreign key (ID_SUBAREA)
      references SUB_AREA_ATUACAO (ID_SUBAREA),
   constraint FK_DOCUMENT_ADMIN_ADI_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: FAVORITOS                                             */
/*==============================================================*/
create table FAVORITOS (
   IDFAVORITO           int                  not null,
   ID_CENTRO            int                  not null,
   ID_CONTEUDO          int                  not null,
   ID_UTILIZADOR        int                  not null,
   DATAFAVORITO         datetime             null,
   constraint PK_FAVORITOS primary key (IDFAVORITO),
   constraint FK_FAVORITO_RELATIONS_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR),
   constraint FK_FAVORITO_RELATIONS_CONTEUDO foreign key (ID_CONTEUDO)
      references CONTEUDO (ID_CONTEUDO),
   constraint FK_FAVORITO_RELATIONS_CENTRO foreign key (ID_CENTRO)
      references CENTRO (ID_CENTRO)
)
go

/*==============================================================*/
/* Table: FOTOGRAFIAS                                           */
/*==============================================================*/
create table FOTOGRAFIAS (
   ID_FOTO              int                  not null,
   ID_UTILIZADOR        int                  not null,
   ID_ALBUM             int                  not null,
   DESCRICAO            text                 null,
   LOCALIZACAO          text                 null,
   DATA_CRIACAO         datetime             null,
   IMAGEM               image                null,
   VISIBILIDADE         int                  null,
   constraint PK_FOTOGRAFIAS primary key (ID_FOTO),
   constraint FK_FOTOGRAF_FOTOS_ALB_ALBUNSMO foreign key (ID_ALBUM)
      references ALBUNSMOMENTOS (ID_ALBUM),
   constraint FK_FOTOGRAF_U_ADD_FOT_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: FOTOGRAFIAS_EVENTOS                                   */
/*==============================================================*/
create table FOTOGRAFIAS_EVENTOS (
   ID_FOTO2             int                  not null,
   ID_ALBUMEVENTO       int                  not null,
   ID_UTILIZADOR        int                  not null,
   DESCRICAO            text                 null,
   LOCALIZACAO          text                 null,
   DATA_CRIACAO         datetime             null,
   IMAGEM               image                null,
   VISIBILIDADE         int                  null,
   constraint PK_FOTOGRAFIAS_EVENTOS primary key (ID_FOTO2),
   constraint FK_FOTOGRAF_RELATIONS_ALBUNS_E foreign key (ID_ALBUMEVENTO)
      references ALBUNS_EVENTOS (ID_ALBUMEVENTO),
   constraint FK_FOTOGRAF_RELATIONS_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: GRUPOS                                                */
/*==============================================================*/
create table GRUPOS (
   ID_GRUPO             int                  not null,
   ID_UTILIZADOR        int                  not null,
   ID_SUBAREA           int                  not null,
   ID_AREA              int                  not null,
   NOME                 text                 not null,
   NMAXIMOMEMBROS       int                  null,
   IMAGEM               image                null,
   DATA_CRIACAO         datetime             null,
   constraint PK_GRUPOS primary key (ID_GRUPO),
   constraint FK_GRUPOS_GRUPO_SUB_SUB_AREA foreign key (ID_SUBAREA)
      references SUB_AREA_ATUACAO (ID_SUBAREA),
   constraint FK_GRUPOS_GRUPO_ARE_AREASDEA foreign key (ID_AREA)
      references AREASDEATUACAO (ID_AREA),
   constraint FK_GRUPOS_RELATIONS_UTILIZAD foreign key (ID_UTILIZADOR)
      references UTILIZADORES (ID_UTILIZADOR)
)
go

/*==============================================================*/
/* Table: INSCRICOES_EVENTOS                                    */
/*==============================================================*/
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

/*==============================================================*/
/* Table: INSCRICOES_GRUPOS                                     */
/*==============================================================*/
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

