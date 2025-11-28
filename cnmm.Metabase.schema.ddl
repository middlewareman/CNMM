PRINT N'Start creating Metabase schema...';

CREATE TABLE MetaAdm
(
    Property    varchar(30)   NOT NULL
        CONSTRAINT PK_MetaAdm PRIMARY KEY CLUSTERED,
    Value       varchar(20)   NOT NULL,
    Description varchar(200),
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

CREATE TABLE MetabaseInfo
(
    Model        varchar(20) NOT NULL
        CONSTRAINT PK_MetabaseInfo PRIMARY KEY CLUSTERED,
    ModelVersion varchar(10) NOT NULL,
    DatabaseRole varchar(20) NOT NULL
);

CREATE TABLE SpecialCharacter
(
    CharacterType  varchar(8)    NOT NULL
        CONSTRAINT PK_SpecialCharacter PRIMARY KEY CLUSTERED,
    PresCharacter  varchar(20)   NOT NULL,
    AggregPossible char          NOT NULL,
    DataCellPres   char          NOT NULL,
    DataCellFilled char,
    PresText       varchar(200),
    UserId         varchar(20)   NOT NULL,
    LogDate        smalldatetime NOT NULL
);

CREATE TABLE TimeScale
(
    TimeScale     varchar(20)   NOT NULL
        CONSTRAINT PK_TimeScale PRIMARY KEY CLUSTERED,
    PresText      varchar(80)   NOT NULL,
    TimeScalePres char,
    Regular       char          NOT NULL,
    TimeUnit      char          NOT NULL,
    Frequency     smallint,
    StoreFormat   varchar(20)   NOT NULL,
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

CREATE TABLE TextCatalog
(
    TextCatalogNo int           NOT NULL
        CONSTRAINT PK_TextCatalog PRIMARY KEY CLUSTERED,
    TextType      varchar(30)   NOT NULL,
    PresText      varchar(100)  NOT NULL,
    Description   varchar(200),
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

CREATE TABLE DataStorage
(
    ProductCode  varchar(20)   NOT NULL
        CONSTRAINT PK_DataStorage PRIMARY KEY CLUSTERED,
    ServerName   varchar(200)  NOT NULL,
    DatabaseName varchar(80)   NOT NULL,
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

CREATE TABLE Organization
(
    OrganizationCode varchar(20)   NOT NULL
        CONSTRAINT PK_Organization PRIMARY KEY CLUSTERED,
    OrganizationName varchar(60)   NOT NULL,
    Department       varchar(60),
    Unit             varchar(60),
    WebAddress       varchar(100),
    MetaId           varchar(100),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

CREATE TABLE Person
(
    PersonCode       varchar(20)   NOT NULL
        CONSTRAINT PK_Person PRIMARY KEY CLUSTERED,
    OrganizationCode varchar(20)   NOT NULL
        CONSTRAINT FK_Person_Organization REFERENCES Organization (OrganizationCode),
    Forename         varchar(50),
    Surname          varchar(50)   NOT NULL,
    PhonePrefix      varchar(4)    NOT NULL,
    PhoneNo          varchar(20)   NOT NULL,
    FaxNo            varchar(20),
    Email            varchar(80),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

CREATE TABLE MainTable
(
    MainTable        varchar(20)   NOT NULL
        CONSTRAINT PK_MainTable PRIMARY KEY CLUSTERED,
    TableStatus      char          NOT NULL,
    PresText         varchar(250)  NOT NULL
        CONSTRAINT UQ_MainTable_Prestext UNIQUE NONCLUSTERED,
    PresTextS        varchar(150),
    ContentsVariable varchar(80),
    TableId          varchar(20)   NOT NULL,
    PresCategory     char          NOT NULL,
    FirstPublished   smalldatetime,
    SpecCharExists   char          NOT NULL,
    SubjectCode      varchar(20)   NOT NULL,
    MetaId           varchar(100),
    ProductCode      varchar(20)   NOT NULL
        CONSTRAINT FK_MainTable_DataStorage REFERENCES DataStorage (ProductCode)
            ON DELETE CASCADE,
    TimeScale        varchar(20)   NOT NULL
        CONSTRAINT FK_MainTable_TimeScale REFERENCES TimeScale (TimeScale)
            ON DELETE CASCADE,
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL
);

CREATE TABLE MenuSelection
(
    Menu         varchar(80)   NOT NULL,
    Selection    varchar(80)   NOT NULL,
    PresText     varchar(100),
    PresTextS    varchar(20),
    Description  varchar(200),
    LevelNo      char          NOT NULL,
    SortCode     varchar(20),
    Presentation char          NOT NULL,
    MetaId       varchar(100),
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL,
    CONSTRAINT PK_MenuSelection
        PRIMARY KEY CLUSTERED (Menu ASC, Selection ASC)
);

CREATE TABLE Link
(
    LinkId       int           NOT NULL
        CONSTRAINT PK_Link PRIMARY KEY CLUSTERED,
    Link         varchar(250)  NOT NULL,
    LinkType     varchar(10),
    LinkFormat   char,
    LinkText     varchar(250)  NOT NULL,
    PresCategory char          NOT NULL,
    LinkPres     char,
    SortCode     varchar(20),
    Description  varchar(200),
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

CREATE TABLE LinkMenuSelection
(
    Menu      varchar(80)   NOT NULL,
    Selection varchar(80)   NOT NULL,
    LinkId    int           NOT NULL
        CONSTRAINT FK_LinkMenuSelection_Link REFERENCES Link (LinkId),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_LinkMenuSelection
        PRIMARY KEY CLUSTERED (Menu ASC, Selection ASC, LinkId ASC),
    CONSTRAINT FK_LinkMenuSelection_MenuSelection
        FOREIGN KEY (Menu, Selection) REFERENCES MenuSelection (Menu, Selection)
);

CREATE TABLE SecondaryLanguage
(
    MainTable            varchar(20) NOT NULL
        CONSTRAINT FK_SecondaryLanguage_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    Language             varchar(20) NOT NULL,
    CompletelyTranslated char,
    Published            char,
    UserId               varchar(20),
    LogDate              smalldatetime,
    CONSTRAINT PK_SecondaryLanguage
        PRIMARY KEY CLUSTERED (MainTable ASC, Language ASC)
);

CREATE TABLE MainTablePerson
(
    MainTable  varchar(20)   NOT NULL
        CONSTRAINT FK_MainTablePerson__MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    PersonCode varchar(20)   NOT NULL
        CONSTRAINT FK_MainTablePerson_Person REFERENCES Person (PersonCode),
    RolePerson char          NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_MainTablePerson
        PRIMARY KEY CLUSTERED (MainTable ASC, PersonCode ASC, RolePerson ASC)
);

CREATE TABLE ColumnCode
(
    MetaTable  varchar(30)   NOT NULL,
    ColumnName varchar(30)   NOT NULL,
    Code       varchar(10)   NOT NULL,
    PresText   varchar(80)   NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_ColumnCode
        PRIMARY KEY CLUSTERED (MetaTable ASC, ColumnName ASC, Code ASC)
);

CREATE TABLE Contents
(
    MainTable        varchar(20)   NOT NULL
        CONSTRAINT FK_Contents_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    Contents         varchar(20)   NOT NULL,
    PresText         varchar(250)  NOT NULL,
    PresTextS        varchar(80),
    PresCode         varchar(20)   NOT NULL,
    Copyright        char          NOT NULL,
    StatAuthority    varchar(20)   NOT NULL
        CONSTRAINT FK_Contents_Organization_2 REFERENCES Organization (OrganizationCode),
    Producer         varchar(20)   NOT NULL
        CONSTRAINT FK_Contents_Organization REFERENCES Organization (OrganizationCode),
    LastUpdated      smalldatetime,
    Published        smalldatetime,
    Unit             varchar(60)   NOT NULL,
    PresDecimals     smallint      NOT NULL
        CONSTRAINT Contents_PresDecimals CHECK ([PresDecimals] >= 0 AND [PresDecimals] <= 6),
    PresCellsZero    char          NOT NULL,
    PresMissingLine  varchar(8),
    AggregPossible   char          NOT NULL,
    RefPeriod        varchar(80),
    StockFA          char          NOT NULL,
    BasePeriod       varchar(20),
    CFPrices         char,
    DayAdj           char          NOT NULL,
    SeasAdj          char          NOT NULL,
    FootnoteContents char          NOT NULL,
    FootnoteVariable char          NOT NULL,
    FootnoteValue    char          NOT NULL,
    FootnoteTime     char          NOT NULL,
    StoreColumnNo    smallint      NOT NULL,
    StoreFormat      char          NOT NULL,
    StoreNoChar      smallint      NOT NULL,
    StoreDecimals    smallint      NOT NULL,
    MetaId           varchar(100),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL,
    CONSTRAINT PK_Contents
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC)
);

CREATE TABLE ContentsTime
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    TimePeriod varchar(20)   NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_ContentsTime
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC, TimePeriod ASC),
    CONSTRAINT FK_ContentsTime_Contents
        FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
            ON DELETE CASCADE
);

CREATE TABLE SubTable
(
    MainTable  varchar(20)   NOT NULL
        CONSTRAINT FK_SubTable_Table REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    SubTable   varchar(20)   NOT NULL,
    PresText   varchar(250)  NOT NULL
        CONSTRAINT UQ_Subtable_Prestext UNIQUE NONCLUSTERED,
    CleanTable char          NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_SubTable
        PRIMARY KEY CLUSTERED (MainTable ASC, SubTable ASC)
);

CREATE TABLE Variable
(
    Variable varchar(30) NOT NULL
        CONSTRAINT PK_Variable PRIMARY KEY CLUSTERED,
    PresText     varchar(80)   NOT NULL,
    VariableInfo varchar(200),
    MetaId       varchar(100),
    Footnote     char          NOT NULL,
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

CREATE TABLE ValuePool
(
    ValuePool varchar(40) NOT NULL
        CONSTRAINT PK_ValuePool PRIMARY KEY CLUSTERED,
    ValuePoolAlias  varchar(20),
    PresText        varchar(80),
    Description     varchar(200)  NOT NULL,
    ValueTextExists char          NOT NULL,
    ValuePres       char          NOT NULL,
    MetaId          varchar(100),
    UserId          varchar(20)   NOT NULL,
    LogDate         smalldatetime NOT NULL
);

CREATE TABLE ValueSet
(
    ValueSet       varchar(30)   NOT NULL
        CONSTRAINT PK_ValueSet PRIMARY KEY CLUSTERED,
    PresText       varchar(80),
    Description    varchar(200)  NOT NULL,
    Elimination    varchar(20)   NOT NULL,
    ValuePool varchar(40) NOT NULL
        CONSTRAINT FK_ValueSet_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    ValuePres      char          NOT NULL,
    GeoAreaNo      smallint,
    MetaId         varchar(100),
    SortCodeExists char          NOT NULL,
    Footnote       char          NOT NULL,
    UserId         varchar(20)   NOT NULL,
    LogDate        smalldatetime NOT NULL
);

CREATE TABLE Value
(
    ValuePool varchar(40) NOT NULL
        CONSTRAINT FK_Value_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    ValueCode  varchar(20)   NOT NULL,
    SortCode   varchar(20)   NOT NULL,
    Unit       varchar(30),
    ValueTextS varchar(250),
    ValueTextL varchar(1100),
    MetaId     varchar(100),
    Footnote   char          NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_Value
        PRIMARY KEY CLUSTERED (ValuePool ASC, ValueCode ASC)
);

CREATE TABLE VSValue
(
    ValueSet  varchar(30)   NOT NULL
        CONSTRAINT FK_VSValue_ValueSet REFERENCES ValueSet (ValueSet),
    ValuePool varchar(40) NOT NULL,
    ValueCode varchar(20)   NOT NULL,
    SortCode  varchar(20),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_VSValue
        PRIMARY KEY CLUSTERED (ValueSet ASC, ValuePool ASC, ValueCode ASC),
    CONSTRAINT FK_VSValue_Value
        FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
            ON DELETE CASCADE
);

CREATE TABLE Grouping
(
    Grouping    varchar(30)   NOT NULL
        CONSTRAINT PK_Grouping PRIMARY KEY CLUSTERED,
    ValuePool varchar(40) NOT NULL
        CONSTRAINT FK_Grouping_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    PresText    varchar(100)  NOT NULL,
    Hierarchy   char          NOT NULL,
    SortCode    varchar(20),
    GroupPres   char          NOT NULL,
    Description varchar(200),
    MetaId      varchar(100),
    UserId      varchar(20)   NOT NULL,
    LogDate     smalldatetime NOT NULL
);

CREATE TABLE GroupingLevel
(
    Grouping  varchar(30)   NOT NULL
        CONSTRAINT FK_GroupingLevel_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    LevelNo   numeric(2)    NOT NULL,
    LevelText varchar(250),
    GeoAreaNo numeric(2),
    UserId    varchar(20)   NOT NULL,
    LogDate   smalldatetime NOT NULL,
    CONSTRAINT PK_GroupingLevel
        PRIMARY KEY CLUSTERED (Grouping ASC, LevelNo ASC)
);

CREATE TABLE ValueGroup
(
    Grouping   varchar(30)   NOT NULL,
    GroupCode  varchar(20)   NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    ValuePool varchar(40) NOT NULL,
    GroupLevel numeric(2)    NOT NULL,
    ValueLevel numeric(2)    NOT NULL,
    SortCode   varchar(20),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_ValueGroup
        PRIMARY KEY CLUSTERED (Grouping ASC, GroupCode ASC, ValueCode ASC),
    CONSTRAINT FK_ValueGroup_Value
        FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
            ON DELETE CASCADE,
    CONSTRAINT FK_ValueGroup_Grouping
        FOREIGN KEY (Grouping) REFERENCES Grouping (Grouping)
);

CREATE TABLE ValueSetGrouping
(
    ValueSet varchar(30)   NOT NULL
        CONSTRAINT FK_ValueSetGrouping_ValueSet REFERENCES ValueSet (ValueSet),
    Grouping varchar(30)   NOT NULL
        CONSTRAINT FK_ValueSetGrouping_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    UserId   varchar(20)   NOT NULL,
    LogDate  smalldatetime NOT NULL,
    CONSTRAINT PK_ValueSetGrouping
        PRIMARY KEY CLUSTERED (ValueSet ASC, Grouping ASC)
);

CREATE TABLE SubTableVariable
(
    MainTable     varchar(20)   NOT NULL,
    SubTable      varchar(20)   NOT NULL,
    Variable varchar(30) NOT NULL
        CONSTRAINT FK_SubTableVariable_Variable REFERENCES Variable (Variable),
    ValueSet      varchar(30)
        CONSTRAINT FK_SubTableVariable_ValueSet REFERENCES ValueSet (ValueSet),
    VariableType  char          NOT NULL,
    StoreColumnNo smallint      NOT NULL,
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL,
    CONSTRAINT PK_SubTableVariable
        PRIMARY KEY CLUSTERED (MainTable ASC, SubTable ASC, Variable ASC),
    CONSTRAINT FK_SubTableVariable_SubTable
        FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable)
            ON DELETE CASCADE
);

CREATE TABLE Attribute
(
    MainTable       varchar(20)   NOT NULL
        CONSTRAINT FK_Attribute_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    Attribute       varchar(20)   NOT NULL,
    AttributeColumn varchar(41)   NOT NULL,
    PresText        varchar(25),
    SequenceNo      smallint      NOT NULL,
    Description     varchar(200),
    ValueSet        varchar(30)
        CONSTRAINT FK_Attribute_ValueSet REFERENCES ValueSet (ValueSet),
    ColumnLength    smallint      NOT NULL,
    UserId          varchar(20)   NOT NULL,
    LogDate         smalldatetime NOT NULL,
    CONSTRAINT PK_Attribute
        PRIMARY KEY CLUSTERED (MainTable ASC, Attribute ASC)
);

CREATE TABLE MainTableVariableHierarchy
(
    MainTable       varchar(20)   NOT NULL
        CONSTRAINT FK_MainTableVariableHierarchy_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    Variable varchar(30) NOT NULL
        CONSTRAINT FK_MainTableVariableHierarchy_Variable REFERENCES Variable (Variable),
    Grouping        varchar(30)   NOT NULL
        CONSTRAINT FK_MainTableVariableHierarchy_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    ShowLevels      numeric(2),
    AllLevelsStored char          NOT NULL,
    UserId          varchar(20)   NOT NULL,
    LogDate         smalldatetime NOT NULL,
    CONSTRAINT PK_MainTableVariableHierarchy
        PRIMARY KEY CLUSTERED (MainTable ASC, Variable ASC, Grouping ASC)
);

CREATE TABLE Footnote
(
    FootnoteNo    numeric(6)    NOT NULL
        CONSTRAINT PK_Footnote PRIMARY KEY CLUSTERED,
    FootnoteType  char          NOT NULL,
    ShowFootnote  char          NOT NULL,
    MandOpt       char          NOT NULL,
    FootnoteText  varchar(max)  NOT NULL,
    PresCharacter varchar(20),
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

CREATE TABLE FootnoteContents
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteContents_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteContents
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteContents_Contents
        FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteContTime
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    TimePeriod varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteContTime_Footnote REFERENCES Footnote (FootnoteNo),
    Cellnote   char          NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteContTime
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC, TimePeriod ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteContTime_ContentsTime
        FOREIGN KEY (MainTable, Contents, TimePeriod) REFERENCES ContentsTime (MainTable, Contents, TimePeriod)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteContValue
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    Variable varchar(30) NOT NULL
        CONSTRAINT FK_FootnoteContValue_Variable REFERENCES Variable (Variable),
    ValuePool varchar(40) NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteContValue REFERENCES Footnote (FootnoteNo),
    Cellnote   char          NOT NULL,
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteContValue
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC, Variable ASC, ValuePool ASC, ValueCode ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteContValue_Contents
        FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteContVbl
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    Variable varchar(30) NOT NULL
        CONSTRAINT FK_FootnoteContVbl_Variable REFERENCES Variable (Variable),
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteContVbl_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteContVbl
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC, Variable ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteContVbl_Contents
        FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteGrouping
(
    Grouping   varchar(30)   NOT NULL
        CONSTRAINT FK_FootnoteGrouping_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteGrouping_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FotnotGruppering
        PRIMARY KEY CLUSTERED (Grouping ASC, FootnoteNo ASC)
);

CREATE TABLE FootnoteMainTable
(
    MainTable  varchar(20)   NOT NULL
        CONSTRAINT FK_FootnoteMainTable_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteMainTable_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteMainTable
        PRIMARY KEY CLUSTERED (MainTable ASC, FootnoteNo ASC)
);

CREATE TABLE FootnoteMaintTime
(
    MainTable  varchar(20)   NOT NULL,
    Contents   varchar(20)   NOT NULL,
    TimePeriod varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteMaintTime_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteMaintTime
        PRIMARY KEY CLUSTERED (MainTable ASC, TimePeriod ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteMaintTime_ContentsTime
        FOREIGN KEY (MainTable, Contents, TimePeriod) REFERENCES ContentsTime (MainTable, Contents, TimePeriod)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteMaintValue
(
    MainTable  varchar(20)   NOT NULL
        CONSTRAINT FK_FootnoteMaintValue_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    Variable varchar(30) NOT NULL
        CONSTRAINT FK_FootnoteMaintValue_Variable REFERENCES Variable (Variable),
    ValuePool varchar(40) NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteMaintValue_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteMaintValue
        PRIMARY KEY CLUSTERED (MainTable ASC, Variable ASC, ValuePool ASC, ValueCode ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteMaintValue_Value
        FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteMenuSel
(
    Menu       varchar(80)   NOT NULL,
    Selection  varchar(80)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteMenuSel_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteMenuSel
        PRIMARY KEY CLUSTERED (Menu ASC, Selection ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteMenuSel_MenuSelection
        FOREIGN KEY (Menu, Selection) REFERENCES MenuSelection (Menu, Selection)
);

CREATE TABLE FootnoteSubTable
(
    MainTable  varchar(20)   NOT NULL,
    SubTable   varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteSubTable_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteSubTable
        PRIMARY KEY CLUSTERED (MainTable ASC, SubTable ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteSubTable_SubTable
        FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteValue
(
    ValuePool varchar(40) NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteValue_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteValue
        PRIMARY KEY CLUSTERED (ValuePool ASC, ValueCode ASC, FootnoteNo ASC),
    CONSTRAINT FK_FootnoteValue_Value
        FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
            ON DELETE CASCADE
);

CREATE TABLE FootnoteValueSetValue
(
    ValuePool varchar(40) NOT NULL,
    ValueSet   varchar(30)   NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteValuSet_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteValuset
        PRIMARY KEY CLUSTERED (ValuePool ASC, ValueSet ASC, ValueCode ASC, FootnoteNo ASC)
);

CREATE TABLE FootnoteVariable
(
    Variable varchar(30) NOT NULL
        CONSTRAINT FK_FootnoteVariable_Variable REFERENCES Variable (Variable),
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteVariable_Footnote REFERENCES Footnote (FootnoteNo),
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_FootnoteVariable
        PRIMARY KEY CLUSTERED (Variable ASC, FootnoteNo ASC)
);

GO

PRINT N'Done creating Metabase schema.';