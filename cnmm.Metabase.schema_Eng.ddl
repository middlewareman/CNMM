PRINT N'Start creating Metabase _Eng schema...';

CREATE TABLE SpecialCharacter_Eng
(
    CharacterType varchar(8)    NOT NULL
        CONSTRAINT PK_SpecialCharacter_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_SpecialCharacter_Eng_SpecialCharacter REFERENCES SpecialCharacter (CharacterType)
            ON DELETE CASCADE,
    PresCharacter varchar(20)   NOT NULL,
    PresText      varchar(200),
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

CREATE TABLE TimeScale_Eng
(
    TimeScale varchar(20)   NOT NULL
        CONSTRAINT PK_TimeScale_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_TimeScale_Eng_TimeScale REFERENCES TimeScale (TimeScale)
            ON DELETE CASCADE,
    PresText  varchar(80)   NOT NULL,
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

CREATE TABLE TextCatalog_Eng
(
    TextCatalogNo int           NOT NULL
        CONSTRAINT PK_TextCatalog_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_TextCatalog_Eng_TextCatalog REFERENCES TextCatalog (TextCatalogNo)
            ON DELETE CASCADE,
    TextType      varchar(30)   NOT NULL,
    PresText      varchar(100)  NOT NULL,
    Description   varchar(200),
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

CREATE TABLE Organization_Eng
(
    OrganizationCode varchar(20)   NOT NULL
        CONSTRAINT PK_Organization_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_Organization_Eng_Organization REFERENCES Organization (OrganizationCode)
            ON DELETE CASCADE,
    OrganizationName varchar(60)   NOT NULL,
    Department       varchar(60),
    Unit             varchar(60),
    WebAddress       varchar(100),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

CREATE TABLE MenuSelection_Eng
(
    Menu         varchar(80)   NOT NULL,
    Selection    varchar(80)   NOT NULL,
    PresText     varchar(100),
    PresTextS    varchar(20),
    Description  varchar(200),
    SortCode     varchar(20),
    Presentation char          NOT NULL,
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL,
    CONSTRAINT PK_MenuSelection_Eng
        PRIMARY KEY CLUSTERED (Menu ASC, Selection ASC),
    CONSTRAINT FK_MenuSelection_Eng_MenuSelection
        FOREIGN KEY (Menu, Selection) REFERENCES MenuSelection (Menu, Selection)
            ON DELETE CASCADE
);

CREATE TABLE Link_Eng
(
    LinkId      int           NOT NULL
        CONSTRAINT PK_Link_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_Link_Eng_Link REFERENCES Link (LinkId)
            ON DELETE CASCADE,
    Link        varchar(250)  NOT NULL,
    LinkText    varchar(250)  NOT NULL,
    SortCode    varchar(20),
    Description varchar(200),
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

CREATE TABLE MainTable_Eng
(
    MainTable        varchar(20)   NOT NULL
        CONSTRAINT PK_MainTable_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_MainTable_Eng_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    PresText         varchar(250)
        CONSTRAINT UK_MainTable_Eng UNIQUE NONCLUSTERED,
    PresTextS        varchar(150),
    ContentsVariable varchar(80),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

CREATE TABLE ColumnCode_Eng
(
    MetaTable  varchar(30)   NOT NULL,
    ColumnName varchar(30)   NOT NULL,
    Code       varchar(10)   NOT NULL,
    CodeEng    varchar(10)   NOT NULL,
    PresText   varchar(80)   NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_ColumnCode_Eng
        PRIMARY KEY CLUSTERED (MetaTable ASC, ColumnName ASC, Code ASC),
    CONSTRAINT FK_ColumnCode_Eng_ColumnCode
        FOREIGN KEY (MetaTable, ColumnName, Code) REFERENCES ColumnCode (MetaTable, ColumnName, Code)
            ON DELETE CASCADE
);

CREATE TABLE Contents_Eng
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    PresText   varchar(250)  NOT NULL,
    PresTextS  varchar(80),
    Unit       varchar(60),
    RefPeriod  varchar(80),
    BasePeriod varchar(20),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_Contents_Eng
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC),
    CONSTRAINT FK_Contents_Eng_Contents
        FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
            ON DELETE CASCADE
);

CREATE TABLE SubTable_Eng
(
    MainTable varchar(20)   NOT NULL,
    SubTable  varchar(20)   NOT NULL,
    PresText  varchar(250)
        CONSTRAINT UK_SubTable_Eng UNIQUE NONCLUSTERED,
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_SubTable_Eng
        PRIMARY KEY CLUSTERED (MainTable ASC, SubTable ASC),
    CONSTRAINT FK_SubTable_Eng_SubTable
        FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable)
            ON DELETE CASCADE
);

CREATE TABLE Variable_Eng
(
    Variable varchar(30) NOT NULL
        CONSTRAINT PK_Variable_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_Variable_Eng_Variable REFERENCES Variable (Variable)
            ON DELETE CASCADE,
    PresText varchar(100) NOT NULL,
    UserId   varchar(20)   NOT NULL,
    LogDate  smalldatetime NOT NULL
);

CREATE TABLE ValuePool_Eng
(
    ValuePool varchar(40) NOT NULL
        CONSTRAINT PK_ValuePool_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_ValuePool_Eng_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    ValuePoolAlias varchar(30),
    PresText varchar(100),
    UserId         varchar(20)   NOT NULL,
    LogDate        smalldatetime NOT NULL
);

CREATE TABLE ValueSet_Eng
(
    ValueSet varchar(40) NOT NULL
        CONSTRAINT PK_ValueSet_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_ValueSet_Eng_ValueSet REFERENCES ValueSet (ValueSet)
            ON DELETE CASCADE,
    PresText varchar(100),
    Description varchar(200)  NOT NULL,
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

CREATE TABLE Value_Eng
(
    ValuePool varchar(40) NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    SortCode   varchar(20)   NOT NULL,
    Unit       varchar(30),
    ValueTextS varchar(250),
    ValueTextL varchar(1100),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_Value_Eng
        PRIMARY KEY CLUSTERED (ValuePool ASC, ValueCode ASC),
    CONSTRAINT FK_Value_Eng_Value
        FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
            ON DELETE CASCADE
);

CREATE TABLE VSValue_Eng
(
    ValueSet varchar(40) NOT NULL,
    ValuePool varchar(40) NOT NULL,
    ValueCode varchar(20)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_VSValue_Eng
        PRIMARY KEY CLUSTERED (ValueSet ASC, ValuePool ASC, ValueCode ASC),
    CONSTRAINT FK_VSValue_Eng_VSValue
        FOREIGN KEY (ValueSet, ValuePool, ValueCode) REFERENCES VSValue (ValueSet, ValuePool, ValueCode)
            ON DELETE CASCADE
);

CREATE TABLE Grouping_Eng
(
    Grouping  varchar(30)   NOT NULL
        CONSTRAINT PK_Grouping_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_Grouping_Eng_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    ValuePool varchar(40) NOT NULL,
    PresText  varchar(80)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL
);

CREATE TABLE GroupingLevel_Eng
(
    Grouping  varchar(30)   NOT NULL,
    Level     numeric(2)    NOT NULL,
    LevelText varchar(250),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_GroupingLevel_Eng
        PRIMARY KEY CLUSTERED (Grouping ASC, Level ASC),
    CONSTRAINT FK_GroupingLevel_Eng_GroupingLevel
        FOREIGN KEY (Grouping, Level) REFERENCES GroupingLevel (Grouping, LevelNo)
            ON DELETE CASCADE
);

CREATE TABLE ValueGroup_Eng
(
    Grouping  varchar(30)   NOT NULL,
    GroupCode varchar(20)   NOT NULL,
    ValueCode varchar(20)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_ValueGroup_Eng
        PRIMARY KEY CLUSTERED (Grouping ASC, GroupCode ASC, ValueCode ASC),
    CONSTRAINT FK_ValueGroup_Eng_ValueGroup
        FOREIGN KEY (Grouping, GroupCode, ValueCode) REFERENCES ValueGroup (Grouping, GroupCode, ValueCode)
            ON DELETE CASCADE
);

CREATE TABLE Attribute_Eng
(
    MainTable   varchar(20)   NOT NULL,
    Attribute   varchar(20)   NOT NULL,
    Description varchar(200),
    PresText    varchar(20),
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL,
    CONSTRAINT PK_Attribute_Eng
        PRIMARY KEY CLUSTERED (MainTable ASC, Attribute ASC),
    CONSTRAINT FK_Attribute_Eng_Attribute
        FOREIGN KEY (MainTable, Attribute) REFERENCES Attribute (MainTable, Attribute)
            ON DELETE CASCADE
);

CREATE TABLE Footnote_Eng
(
    FootnoteNo   numeric(6)    NOT NULL
        CONSTRAINT PK_Footnote_Eng PRIMARY KEY CLUSTERED
        CONSTRAINT FK_Footnote_Eng_Footnote REFERENCES Footnote (FootnoteNo)
            ON DELETE CASCADE,
    FootnoteText varchar(max)  NOT NULL,
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

GO

PRINT N'Done creating Metabase _Eng schema.';