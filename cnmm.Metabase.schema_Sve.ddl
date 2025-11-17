PRINT N'Start creating Metabase _Sve schema...';

CREATE TABLE SpecialCharacter_Sve
(
    CharacterType varchar(8)    NOT NULL,
    PresCharacter varchar(20)   NOT NULL,
    PresText      varchar(200),
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

ALTER TABLE SpecialCharacter_Sve
    ADD CONSTRAINT FK_SpecialCharacter_Sve_SpecialCharacter
        FOREIGN KEY (CharacterType) REFERENCES SpecialCharacter (CharacterType);

ALTER TABLE SpecialCharacter_Sve
    ADD CONSTRAINT PK_SpecialCharacter_Sve
        PRIMARY KEY CLUSTERED (CharacterType);

CREATE TABLE TimeScale_Sve
(
    TimeScale varchar(20)   NOT NULL,
    PresText  varchar(80)   NOT NULL,
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

ALTER TABLE TimeScale_Sve
    ADD CONSTRAINT FK_TimeScale_Sve_TimeScale
        FOREIGN KEY (TimeScale) REFERENCES TimeScale (TimeScale);

ALTER TABLE TimeScale_Sve
    ADD CONSTRAINT PK_TimeScale_Sve
        PRIMARY KEY CLUSTERED (TimeScale);

CREATE TABLE TextCatalog_Sve
(
    TextCatalogNo int           NOT NULL,
    TextType      varchar(30)   NOT NULL,
    PresText      varchar(100)  NOT NULL,
    Description   varchar(200),
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

ALTER TABLE TextCatalog_Sve
    ADD CONSTRAINT FK_TextCatalog_Sve_TextCatalog
        FOREIGN KEY (TextCatalogNo) REFERENCES TextCatalog (TextCatalogNo);

ALTER TABLE TextCatalog_Sve
    ADD CONSTRAINT PK_TextCatalog_Sve
        PRIMARY KEY CLUSTERED (TextCatalogNo);

CREATE TABLE Organization_Sve
(
    OrganizationCode varchar(20)   NOT NULL,
    OrganizationName varchar(60)   NOT NULL,
    Department       varchar(60),
    Unit             varchar(60),
    WebAddress       varchar(100),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

ALTER TABLE Organization_Sve
    ADD CONSTRAINT FK_Organization_Sve_Organization
        FOREIGN KEY (OrganizationCode) REFERENCES Organization (OrganizationCode);

ALTER TABLE Organization_Sve
    ADD CONSTRAINT PK_Organization_Sve
        PRIMARY KEY CLUSTERED (OrganizationCode);

CREATE TABLE MenuSelection_Sve
(
    Menu         varchar(80)   NOT NULL,
    Selection    varchar(80)   NOT NULL,
    PresText     varchar(100),
    PresTextS    varchar(20),
    Description  varchar(200),
    SortCode     varchar(20),
    Presentation char(1)       NOT NULL,
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

ALTER TABLE MenuSelection_Sve
    ADD CONSTRAINT FK_MenuSelection_Sve_MenuSelection
        FOREIGN KEY (Menu, Selection) REFERENCES MenuSelection (Menu, Selection);

ALTER TABLE MenuSelection_Sve
    ADD CONSTRAINT PK_MenuSelection_Sve
        PRIMARY KEY CLUSTERED (Menu, Selection);

CREATE TABLE Link_Sve
(
    LinkId      int           NOT NULL,
    Link        varchar(250)  NOT NULL,
    LinkText    varchar(250)  NOT NULL,
    SortCode    varchar(20),
    Description varchar(200),
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

ALTER TABLE Link_Sve
    ADD CONSTRAINT FK_Link_Sve_Link
        FOREIGN KEY (LinkId) REFERENCES Link (LinkId);

ALTER TABLE Link_Sve
    ADD CONSTRAINT PK_Link_Sve
        PRIMARY KEY CLUSTERED (LinkId);

CREATE TABLE MainTable_Sve
(
    MainTable        varchar(20)   NOT NULL,
    PresText         varchar(250),
    PresTextS        varchar(150),
    ContentsVariable varchar(80),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

ALTER TABLE MainTable_Sve
    ADD CONSTRAINT FK_MainTable_Sve_MainTable
        FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable);

ALTER TABLE MainTable_Sve
    ADD CONSTRAINT PK_MainTable_Sve
        PRIMARY KEY CLUSTERED (MainTable);

ALTER TABLE MainTable_Sve
    ADD CONSTRAINT UK_MainTable_Sve UNIQUE (PresText);

CREATE TABLE ColumnCode_Sve
(
    MetaTable  varchar(30)   NOT NULL,
    ColumnName varchar(30)   NOT NULL,
    Code       varchar(10)   NOT NULL,
    CodeEng    varchar(10)   NOT NULL,
    PresText   varchar(80)   NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL
);

ALTER TABLE ColumnCode_Sve
    ADD CONSTRAINT FK_ColumnCode_Sve_ColumnCode
        FOREIGN KEY (MetaTable, ColumnName, Code) REFERENCES ColumnCode (MetaTable, ColumnName, Code);

ALTER TABLE ColumnCode_Sve
    ADD CONSTRAINT PK_ColumnCode_Sve
        PRIMARY KEY CLUSTERED (MetaTable, ColumnName, Code);

CREATE TABLE Contents_Sve
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    PresText   varchar(250)  NOT NULL,
    PresTextS  varchar(80),
    Unit       varchar(60),
    RefPeriod  varchar(80),
    BasePeriod varchar(20),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL
);

ALTER TABLE Contents_Sve
    ADD CONSTRAINT FK_Contents_Sve_Contents
        FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents);

ALTER TABLE Contents_Sve
    ADD CONSTRAINT PK_Contents_Sve
        PRIMARY KEY CLUSTERED (MainTable, Contents);

CREATE TABLE SubTable_Sve
(
    MainTable varchar(20)   NOT NULL,
    SubTable  varchar(20)   NOT NULL,
    PresText  varchar(250),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

ALTER TABLE SubTable_Sve
    ADD CONSTRAINT FK_SubTable_Sve_SubTable
        FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable);

ALTER TABLE SubTable_Sve
    ADD CONSTRAINT PK_SubTable_Sve
        PRIMARY KEY CLUSTERED (MainTable, SubTable);

ALTER TABLE SubTable_Sve
    ADD CONSTRAINT UK_SubTable_Sve UNIQUE (PresText);

CREATE TABLE Variable_Sve
(
    Variable varchar(20)   NOT NULL,
    PresText varchar(80)   NOT NULL,
    UserId   varchar(20)   NOT NULL,
    LogDate  smalldatetime NOT NULL
);

ALTER TABLE Variable_Sve
    ADD CONSTRAINT FK_Variable_Sve_Variable
        FOREIGN KEY (Variable) REFERENCES Variable (Variable);

ALTER TABLE Variable_Sve
    ADD CONSTRAINT PK_Variable_Sve
        PRIMARY KEY CLUSTERED (Variable);

CREATE TABLE ValuePool_Sve
(
    ValuePool      varchar(30)   NOT NULL,
    ValuePoolAlias varchar(30)   NOT NULL,
    PresText       varchar(80),
    UserId         varchar(20)   NOT NULL,
    LogDate        smalldatetime NOT NULL
);

ALTER TABLE ValuePool_Sve
    ADD CONSTRAINT FK_ValuePool_Sve_ValuePool
        FOREIGN KEY (ValuePool) REFERENCES ValuePool (ValuePool);

ALTER TABLE ValuePool_Sve
    ADD CONSTRAINT PK_ValuePool_Sve
        PRIMARY KEY CLUSTERED (ValuePool);

CREATE TABLE ValueSet_Sve
(
    ValueSet    varchar(30)   NOT NULL,
    PresText    varchar(80),
    Description varchar(200)  NOT NULL,
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

ALTER TABLE ValueSet_Sve
    ADD CONSTRAINT FK_ValueSet_Sve_ValueSet
        FOREIGN KEY (ValueSet) REFERENCES ValueSet (ValueSet);

ALTER TABLE ValueSet_Sve
    ADD CONSTRAINT PK_ValueSet_Sve
        PRIMARY KEY CLUSTERED (ValueSet);

CREATE TABLE Value_Sve
(
    ValuePool  varchar(30)   NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    SortCode   varchar(20)   NOT NULL,
    Unit       varchar(30),
    ValueTextS varchar(250),
    ValueTextL varchar(1100),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL
);

ALTER TABLE Value_Sve
    ADD CONSTRAINT FK_Value_Sve_Value
        FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode);

ALTER TABLE Value_Sve
    ADD CONSTRAINT PK_Value_Sve
        PRIMARY KEY CLUSTERED (ValuePool, ValueCode);

CREATE TABLE VSValue_Sve
(
    ValueSet  varchar(30)   NOT NULL,
    ValuePool varchar(30)   NOT NULL,
    ValueCode varchar(20)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

ALTER TABLE VSValue_Sve
    ADD CONSTRAINT FK_VSValue_Sve_VSValue
        FOREIGN KEY (ValueSet, ValuePool, ValueCode) REFERENCES VSValue (ValueSet, ValuePool, ValueCode);

ALTER TABLE VSValue_Sve
    ADD CONSTRAINT PK_VSValue_Sve
        PRIMARY KEY CLUSTERED (ValueSet, ValuePool, ValueCode);

CREATE TABLE Grouping_Sve
(
    Grouping  varchar(30)   NOT NULL,
    ValuePool varchar(20)   NOT NULL,
    PresText  varchar(80)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

ALTER TABLE Grouping_Sve
    ADD CONSTRAINT FK_Grouping_Sve_Grouping
        FOREIGN KEY (Grouping) REFERENCES Grouping (Grouping);

ALTER TABLE Grouping_Sve
    ADD CONSTRAINT PK_Grouping_Sve
        PRIMARY KEY CLUSTERED (Grouping);

CREATE TABLE GroupingLevel_Sve
(
    Grouping  varchar(30)   NOT NULL,
    ValuePool varchar(20)   NOT NULL,
    Level     numeric(2)    NOT NULL,
    LevelText varchar(250),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

ALTER TABLE GroupingLevel_Sve
    ADD CONSTRAINT FK_GroupingLevel_Sve_GroupingLevel
        FOREIGN KEY (Grouping, Level) REFERENCES GroupingLevel (Grouping, LevelNo);

ALTER TABLE GroupingLevel_Sve
    ADD CONSTRAINT PK_GroupingLevel_Sve
        PRIMARY KEY CLUSTERED (Grouping, Level);

CREATE TABLE ValueGroup_Sve
(
    Grouping  varchar(30)   NOT NULL,
    GroupCode varchar(20)   NOT NULL,
    ValueCode varchar(20)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

ALTER TABLE ValueGroup_Sve
    ADD CONSTRAINT FK_ValueGroup_Sve_ValueGroup
        FOREIGN KEY (Grouping, GroupCode, ValueCode) REFERENCES ValueGroup (Grouping, GroupCode, ValueCode);

ALTER TABLE ValueGroup_Sve
    ADD CONSTRAINT PK_ValueGroup_Sve
        PRIMARY KEY CLUSTERED (Grouping, GroupCode, ValueCode);

CREATE TABLE Attribute_Sve
(
    MainTable   varchar(20)   NOT NULL,
    Attribute   varchar(20)   NOT NULL,
    Description varchar(200),
    PresText    varchar(20),
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

ALTER TABLE Attribute_Sve
    ADD CONSTRAINT FK_Attribute_Sve_Attribute
        FOREIGN KEY (MainTable, Attribute) REFERENCES Attribute (MainTable, Attribute);

ALTER TABLE Attribute_Sve
    ADD CONSTRAINT PK_Attribute_Sve
        PRIMARY KEY CLUSTERED (MainTable, Attribute);

CREATE TABLE Footnote_Sve
(
    FootnoteNo   numeric(6)    NOT NULL,
    FootnoteText text          NOT NULL,
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

ALTER TABLE Footnote_Sve
    ADD CONSTRAINT FK_Footnote_Sve_Footnote
        FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo);

ALTER TABLE Footnote_Sve
    ADD CONSTRAINT PK_Footnote_Sve
        PRIMARY KEY CLUSTERED (FootnoteNo);

PRINT N'Done creating Metabase _Sve schema.';