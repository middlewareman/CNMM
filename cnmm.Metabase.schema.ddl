-- ============================================================================
-- CNMM (Common Nordic Meta Model) 2.3 – Metabase schema (structure + docs)
-- Note: Business rules are ENFORCED in CNMM/cnmm.Metabase.business-constraints.ddl
-- Canonical semantics/domains: docs/CNMM-guide/Rules.md (sections 7–9)
-- ============================================================================
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
    AggregPossible char          NOT NULL, -- {Y,N} aggregation allowed for this special character
    DataCellPres   char          NOT NULL, -- {Y,N} show special character in cells
    DataCellFilled char,                   -- {Y,N} or NULL (unset)
    PresText       varchar(200),
    UserId         varchar(20)   NOT NULL,
    LogDate        smalldatetime NOT NULL
);

CREATE TABLE TimeScale
(
    TimeScale     varchar(20)   NOT NULL
        CONSTRAINT PK_TimeScale PRIMARY KEY CLUSTERED,
    PresText      varchar(80)   NOT NULL, -- Display name (e.g., Year, Quarter)
    TimeScalePres char,                   -- Presentation option (optional)
    Regular       char          NOT NULL, -- {Y=Regular intervals, N=Irregular}
    TimeUnit      char          NOT NULL, -- {Y=Year, Q=Quarter, M=Month, W=Week, D=Day, H=Hour}
    Frequency     smallint,               -- Periods per year (e.g., 1, 4, 12, 52)
    StoreFormat   varchar(20)   NOT NULL, -- Storage pattern, e.g. 'yyyy', 'yyyyQq', 'yyyyMM'
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL
);

CREATE TABLE TextCatalog
(
    TextCatalogNo int           NOT NULL
        CONSTRAINT PK_TextCatalog PRIMARY KEY CLUSTERED,
    TextType      varchar(30)   NOT NULL, -- Category of text (e.g., 'Language', 'Type', 'Map'); GroupingLevel.GeoAreaNo uses 'Map'
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
    TableStatus    char NOT NULL,            -- {A=Active, P=Passive, D=Deleted} Source: UML 2.3; see docs/CNMM-guide/Rules.md §7
    PresText         varchar(250)  NOT NULL
        CONSTRAINT UQ_MainTable_Prestext UNIQUE NONCLUSTERED,
    PresTextS        varchar(150),
    ContentsVariable varchar(80),            -- Recommended default contents code for the table (presentation default)
    TableId          varchar(20)   NOT NULL,
    -- pxwebapi expectation (antagande):
    --   - Used as the URL table id and matched case-insensitively against MenuSelection.Selection
    --     Källa för Selection-join: EXT/PCAxis.Sql/PCAxis.Sql/QueryLib_24/Queries.cs (GetMenuLookupTablesQuery)
    PresCategory   char NOT NULL,            -- {O=Official, U=Unofficial, T=Temporary} Source: UML 2.3; see docs/CNMM-guide/Rules.md §7
    FirstPublished   smalldatetime,
    SpecCharExists char NOT NULL,            -- {Y,N} special characters exist.
    -- PxWeb support: EXT/PCAxis.Sql/PCAxis.Sql/DbConfig/SqlDbConfig_24.cs (MainTable.SpecCharExistsCol) and
    -- EXT/PCAxis.Sql/PCAxis.Sql/Parser_24/PXSqlMeta_24.cs (Meta.SpecCharExists). PxWeb expects X‑suffix columns when 'Y'.
    SubjectCode      varchar(20)   NOT NULL, -- Subject/topic code for the table (used in metadata and clients)
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

-- --------------------------------------------------------------------------
-- MenuSelection chains (pxwebapi behavior)
--   - Forms chains: (Menu, Selection) where Selection either points to another
--     Menu (next node) or is the terminal node pointing to a MainTable.
--   - Terminal rule: The LAST row in the chain must have Selection = MainTable.MainTable
--     (case-insensitive match) and LevelNo = MetaAdm['MenuLevels'] for the table
--     to be visible in pxwebapi menus.
--   - Presentation: {A=Active, P=Passive, N=Not shown}; LevelNo: '1'..'9' (1=top).
--   Sources (PxWeb/PCAxis.Sql): QueryLib_24/Queries.cs → GetMenuLookupTablesQuery (Selection join) and
--   GetMenuLookupFolderQuery (MENULEVELS filter)
CREATE TABLE MenuSelection
(
    Menu         varchar(80)   NOT NULL,
    Selection    varchar(80)   NOT NULL,
    PresText     varchar(100),
    PresTextS    varchar(20),            -- Short presentation text (abbreviation)
    Description  varchar(200),           -- Optional description (tooltip/longer text)
    LevelNo      char          NOT NULL, -- '1'..'9' (1=top)
    SortCode     varchar(20),            -- Presentation sort key; pxwebapi defaults to Text when NULL
    Presentation char          NOT NULL, -- {A=Active, P=Passive, N=Not shown}
    MetaId       varchar(100),           -- External metadata reference (optional)
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
    LinkType     varchar(10),            -- Free-form category for the link (e.g., methodology, dataset, news)
    LinkFormat   char,                   -- {U=URL, M=MainTable} when set
    LinkText     varchar(250)  NOT NULL,
    PresCategory char          NOT NULL, -- {O=Public, I=Internal, P=Private}
    LinkPres     char,                   -- {D=Direct, I=Icon, B=Both} when set
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
    CompletelyTranslated char, -- {Y,N} or NULL
    Published            char, -- {Y,N} or NULL
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
    RolePerson char          NOT NULL, -- {P=Producer, C=Contact, E=Editor, Q=Quality}
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_MainTablePerson
        PRIMARY KEY CLUSTERED (MainTable ASC, PersonCode ASC, RolePerson ASC)
);

CREATE TABLE ColumnCode -- Per-column code lists for selected metadata columns (UI/tooling support)
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
    PresCode         varchar(20)   NOT NULL, -- Short code for the contents (shown in UI/headers)
    Copyright        char          NOT NULL, -- {Y,N}
    StatAuthority    varchar(20)   NOT NULL
        CONSTRAINT FK_Contents_Organization_2 REFERENCES Organization (OrganizationCode),
    Producer         varchar(20)   NOT NULL
        CONSTRAINT FK_Contents_Organization REFERENCES Organization (OrganizationCode),
    LastUpdated      smalldatetime,
    Published        smalldatetime,
    Unit             varchar(60)   NOT NULL,
    PresDecimals     smallint      NOT NULL  -- [0..6]
        CONSTRAINT Contents_PresDecimals CHECK ([PresDecimals] >= 0 AND [PresDecimals] <= 6),
    PresCellsZero    char          NOT NULL, -- {Y,N,C}
    PresMissingLine  varchar(8),             -- Presentation symbol for missing/not-applicable cells (e.g., "..")
    AggregPossible   char          NOT NULL, -- {Y,N}
    RefPeriod        varchar(80),            -- Reference period description (e.g., "Average of calendar year")
    StockFA          char          NOT NULL, -- {S=Stock, F=Flow, A=Average}
    BasePeriod       varchar(20),            -- Base period used for index/price comparisons (e.g., 2015=100)
    CFPrices         char,                   -- {C=current, F=fixed} or NULL
    DayAdj           char          NOT NULL, -- {Y,N}
    SeasAdj          char          NOT NULL, -- {Y,N}
    FootnoteContents char          NOT NULL, -- {Y,N}
    FootnoteVariable char          NOT NULL, -- {Y,N}
    FootnoteValue    char          NOT NULL, -- {Y,N}
    FootnoteTime     char          NOT NULL, -- {Y,N}
    StoreColumnNo    smallint      NOT NULL, -- Physical column number in the data table for this contents value
    StoreFormat      char          NOT NULL, -- {F=float, I=int, N=string, C=code}
    StoreNoChar      smallint      NOT NULL, -- Storage width (characters) for StoreFormat N/C
    StoreDecimals    smallint      NOT NULL, -- Storage decimals for StoreFormat F/I (0 for integers)
    MetaId           varchar(100),
    UserId           varchar(20)   NOT NULL,
    LogDate          smalldatetime NOT NULL,
    CONSTRAINT PK_Contents
        PRIMARY KEY CLUSTERED (MainTable ASC, Contents ASC)
);

CREATE TABLE ContentsTime -- Allowed time periods for a (MainTable, Contents)
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
    CleanTable char          NOT NULL, -- {Y,N} legacy cleanliness flag (classic PC-Axis); pxwebapi does not use it
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_SubTable
        PRIMARY KEY CLUSTERED (MainTable ASC, SubTable ASC)
);

CREATE TABLE Variable
(
    Variable     varchar(30)   NOT NULL
        CONSTRAINT PK_Variable PRIMARY KEY CLUSTERED,
    PresText     varchar(100)  NOT NULL,
    VariableInfo varchar(200),           -- Short variable description (scope/definition, for presentation)
    MetaId       varchar(100),
    Footnote     char          NOT NULL, -- {Y,N}
    UserId       varchar(20)   NOT NULL,
    LogDate      smalldatetime NOT NULL
);

CREATE TABLE ValuePool
(
    ValuePool       varchar(40)   NOT NULL
        CONSTRAINT PK_ValuePool PRIMARY KEY CLUSTERED,
    ValuePoolAlias  varchar(20),            -- Optional alternative id/alias for the pool (legacy/tooling); not used by pxwebapi
    PresText        varchar(100),
    Description     varchar(200)  NOT NULL,
    ValueTextExists char          NOT NULL, -- {L=Long,S=Short,B=Both,N=None}
    ValuePres       char          NOT NULL, -- {A=Code+Short,B=Code+Long,C=Code,S=Short,T=Long}
    MetaId          varchar(100),
    UserId          varchar(20)   NOT NULL,
    LogDate         smalldatetime NOT NULL
);

CREATE TABLE ValueSet
(
    ValueSet       varchar(40)   NOT NULL
        CONSTRAINT PK_ValueSet PRIMARY KEY CLUSTERED,
    PresText       varchar(100),
    Description    varchar(200)  NOT NULL,
    Elimination    varchar(20)   NOT NULL, -- {Y,N} eliminable in default view
    ValuePool      varchar(40)   NOT NULL
        CONSTRAINT FK_ValueSet_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    ValuePres      char          NOT NULL, -- {A,B,C,S,T,V} (V = follow ValuePool.ValuePres)
    GeoAreaNo      smallint,               -- Required when used by VariableType='G'; NULL when 'C'
    MetaId         varchar(100),
    SortCodeExists char          NOT NULL, -- {Y,N}; if 'Y' then VSValue.SortCode required for all members
    Footnote       char          NOT NULL, -- {B=both,V=optional,O=obligatory,N=none}
    UserId         varchar(20)   NOT NULL,
    LogDate        smalldatetime NOT NULL
);

CREATE TABLE Value
(
    ValuePool  varchar(40)   NOT NULL
        CONSTRAINT FK_Value_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    ValueCode  varchar(20)   NOT NULL,
    SortCode   varchar(20)   NOT NULL, -- ordering within a pool (used when ValueSet.SortCodeExists='N')
    Unit       varchar(30),            -- Optional unit override per value (normally NULL)
    ValueTextS varchar(250),           -- Short label (presence/presentation controlled by ValuePool)
    ValueTextL varchar(1100),          -- Long label (presence/presentation controlled by ValuePool)
    MetaId     varchar(100),
    Footnote   char          NOT NULL, -- {Y,N}
    UserId     varchar(20)   NOT NULL,
    LogDate    smalldatetime NOT NULL,
    CONSTRAINT PK_Value
        PRIMARY KEY CLUSTERED (ValuePool ASC, ValueCode ASC)
);

CREATE TABLE VSValue
(
    ValueSet  varchar(40)   NOT NULL
        CONSTRAINT FK_VSValue_ValueSet REFERENCES ValueSet (ValueSet),
    ValuePool varchar(40)   NOT NULL,
    ValueCode varchar(20)   NOT NULL,
    SortCode  varchar(20), -- Required if owning ValueSet.SortCodeExists='Y'
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
    ValuePool   varchar(40)   NOT NULL
        CONSTRAINT FK_Grouping_ValuePool REFERENCES ValuePool (ValuePool)
            ON DELETE CASCADE,
    PresText    varchar(100)  NOT NULL,
    Hierarchy   char          NOT NULL, -- {N=No (flat), B=Balanced, U=Unbalanced}
    SortCode    varchar(20),            -- Optional presentation sort order among groupings
    GroupPres   char          NOT NULL, -- {A=Aggregated, I=Integral (original), B=Both}
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
    LevelNo   numeric(2)    NOT NULL, -- 1=highest; increases with depth. Levels used in ValueGroup must exist here.
    LevelText varchar(250),           -- Optional display name for this level (presentation text)
    GeoAreaNo numeric(2),             -- Map layer id for geographic levels; refers to TextCatalog(TextType='Map'). NULL for non-geo
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
    ValuePool  varchar(40)   NOT NULL, -- Must equal Grouping.ValuePool (business rule; see tests)
    GroupLevel numeric(2)    NOT NULL, -- parent level (shall be < ValueLevel) and must exist as GroupingLevel.LevelNo
    ValueLevel numeric(2)    NOT NULL, -- child level (deeper); must exist as GroupingLevel.LevelNo
    SortCode   varchar(20),            -- Optional presentation order among members within the group
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
    ValueSet varchar(40)   NOT NULL
        CONSTRAINT FK_ValueSetGrouping_ValueSet REFERENCES ValueSet (ValueSet),
    Grouping varchar(30)   NOT NULL
        CONSTRAINT FK_ValueSetGrouping_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    UserId   varchar(20)   NOT NULL,
    LogDate  smalldatetime NOT NULL,
    CONSTRAINT PK_ValueSetGrouping
        PRIMARY KEY CLUSTERED (ValueSet ASC, Grouping ASC)
    -- Business rule: ValueSet.ValuePool must equal Grouping.ValuePool (see constraints DDL)
);

CREATE TABLE SubTableVariable
(
    MainTable     varchar(20)   NOT NULL,
    SubTable      varchar(20)   NOT NULL,
    Variable      varchar(30)   NOT NULL
        CONSTRAINT FK_SubTableVariable_Variable REFERENCES Variable (Variable),
    ValueSet      varchar(40)             -- Required for VariableType in {C,G}; MUST be NULL for {T,V}
        CONSTRAINT FK_SubTableVariable_ValueSet REFERENCES ValueSet (ValueSet),
    VariableType  char          NOT NULL, -- {C=Classification, T=Time, G=Grouping, V=Contents}
    StoreColumnNo smallint      NOT NULL, -- Physical column number in the data table for this variable
    UserId        varchar(20)   NOT NULL,
    LogDate       smalldatetime NOT NULL,
    CONSTRAINT PK_SubTableVariable
        PRIMARY KEY CLUSTERED (MainTable ASC, SubTable ASC, Variable ASC),
    CONSTRAINT FK_SubTableVariable_SubTable
        FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable)
            ON DELETE CASCADE
);

CREATE TABLE Attribute -- Cell/observation attributes configured per MainTable
(
    MainTable       varchar(20)   NOT NULL
        CONSTRAINT FK_Attribute_MainTable REFERENCES MainTable (MainTable)
            ON DELETE CASCADE,
    Attribute       varchar(20)   NOT NULL, -- Attribute id/code (e.g., "Flag", "UnitOverride")
    AttributeColumn varchar(41)   NOT NULL, -- Physical data column holding the attribute value
    PresText        varchar(25),
    SequenceNo      smallint      NOT NULL, -- Presentation order among attributes
    Description     varchar(200),
    ValueSet        varchar(40)             -- Optional codelist restricting allowed attribute values
        CONSTRAINT FK_Attribute_ValueSet REFERENCES ValueSet (ValueSet),
    ColumnLength    smallint      NOT NULL, -- Max length of the attribute column (characters)
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
    Variable        varchar(30)   NOT NULL
        CONSTRAINT FK_MainTableVariableHierarchy_Variable REFERENCES Variable (Variable),
    Grouping        varchar(30)   NOT NULL
        CONSTRAINT FK_MainTableVariableHierarchy_Grouping REFERENCES Grouping (Grouping)
            ON DELETE CASCADE,
    ShowLevels      numeric(2),             -- How many hierarchy levels to show by default (optional)
    AllLevelsStored char          NOT NULL, -- {Y,N}
    UserId          varchar(20)   NOT NULL,
    LogDate         smalldatetime NOT NULL,
    CONSTRAINT PK_MainTableVariableHierarchy
        PRIMARY KEY CLUSTERED (MainTable ASC, Variable ASC, Grouping ASC)
);

CREATE TABLE Footnote
(
    FootnoteNo    numeric(6)    NOT NULL
        CONSTRAINT PK_Footnote PRIMARY KEY CLUSTERED,
    FootnoteType  char          NOT NULL, -- UML: {'1'..'9','A','B','C','Q'} (scope where footnote applies)
    ShowFootnote  char          NOT NULL, -- UML: {B=Both (selection+presentation), P=Presentation, S=Selection}
    MandOpt       char          NOT NULL, -- {M=Mandatory, O=Optional}
    FootnoteText  varchar(max)  NOT NULL,
    PresCharacter varchar(20),            -- Optional presentation symbol/character for this footnote
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
    Cellnote   char          NOT NULL, -- {Y,N}
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
    Variable   varchar(30)   NOT NULL
        CONSTRAINT FK_FootnoteContValue_Variable REFERENCES Variable (Variable),
    ValuePool  varchar(40)   NOT NULL,
    ValueCode  varchar(20)   NOT NULL,
    FootnoteNo numeric(6)    NOT NULL
        CONSTRAINT FK_FootnoteContValue REFERENCES Footnote (FootnoteNo),
    Cellnote   char          NOT NULL, -- {Y,N}
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
    Variable   varchar(30)   NOT NULL
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
    Variable   varchar(30)   NOT NULL
        CONSTRAINT FK_FootnoteMaintValue_Variable REFERENCES Variable (Variable),
    ValuePool  varchar(40)   NOT NULL,
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
    ValuePool  varchar(40)   NOT NULL,
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
    ValuePool  varchar(40)   NOT NULL,
    ValueSet   varchar(40)   NOT NULL,
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
    Variable   varchar(30)   NOT NULL
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