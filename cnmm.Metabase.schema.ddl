PRINT N'Start creating Metabase schema...';

CREATE TABLE MetaAdm ( 
	Property varchar(30) NOT NULL,
	Value varchar(20) NOT NULL,
	Description varchar(200),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE MetaAdm ADD CONSTRAINT PK_MetaAdm 
	PRIMARY KEY CLUSTERED (Property)
;

CREATE TABLE MetabaseInfo ( 
	Model varchar(20) NOT NULL,
	ModelVersion varchar(10) NOT NULL,
	DatabaseRole varchar(20) NOT NULL
)
;

ALTER TABLE MetabaseInfo ADD CONSTRAINT PK_MetabaseInfo 
	PRIMARY KEY CLUSTERED (Model)
;

CREATE TABLE SpecialCharacter ( 
	CharacterType varchar(8) NOT NULL,
	PresCharacter varchar(20) NOT NULL,
	AggregPossible char(1) NOT NULL,
	DataCellPres char(1) NOT NULL,
	DataCellFilled char(1),
	PresText varchar(200),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE SpecialCharacter ADD CONSTRAINT PK_SpecialCharacter 
	PRIMARY KEY CLUSTERED (CharacterType)
;

CREATE TABLE TimeScale ( 
	TimeScale varchar(20) NOT NULL,
	PresText varchar(80) NOT NULL,
	TimeScalePres char(1),
	Regular char(1) NOT NULL,
	TimeUnit char(1) NOT NULL,
	Frequency smallint,
	StoreFormat varchar(20) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE TimeScale ADD CONSTRAINT PK_TimeScale 
	PRIMARY KEY CLUSTERED (TimeScale)
;

CREATE TABLE TextCatalog ( 
	TextCatalogNo int NOT NULL,
	TextType varchar(30) NOT NULL,
	PresText varchar(100) NOT NULL,
	Description varchar(200),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE TextCatalog ADD CONSTRAINT PK_TextCatalog 
	PRIMARY KEY CLUSTERED (TextCatalogNo)
;

CREATE TABLE DataStorage ( 
	ProductCode varchar(20) NOT NULL,
	ServerName varchar(200) NOT NULL,
	DatabaseName varchar(80) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE DataStorage ADD CONSTRAINT PK_DataStorage 
	PRIMARY KEY CLUSTERED (ProductCode)
;

CREATE TABLE Organization ( 
	OrganizationCode varchar(20) NOT NULL,
	OrganizationName varchar(60) NOT NULL,
	Department varchar(60),
	Unit varchar(60),
	WebAddress varchar(100),
	MetaId varchar(100),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Organization ADD CONSTRAINT PK_Organization 
	PRIMARY KEY CLUSTERED (OrganizationCode)
;

CREATE TABLE Person ( 
	PersonCode varchar(20) NOT NULL,
	OrganizationCode varchar(20) NOT NULL,
	Forename varchar(50),
	Surname varchar(50) NOT NULL,
	PhonePrefix varchar(4) NOT NULL,
	PhoneNo varchar(20) NOT NULL,
	FaxNo varchar(20),
	Email varchar(80),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Person ADD CONSTRAINT FK_Person_Organization 
	FOREIGN KEY (OrganizationCode) REFERENCES Organization (OrganizationCode)
;

ALTER TABLE Person ADD CONSTRAINT PK_Person 
	PRIMARY KEY CLUSTERED (PersonCode)
;

CREATE TABLE MainTable ( 
	MainTable varchar(20) NOT NULL,
	TableStatus char(1) NOT NULL,
	PresText varchar(250) NOT NULL,
	PresTextS varchar(150),
	ContentsVariable varchar(80),
	TableId varchar(20) NOT NULL,
	PresCategory char(1) NOT NULL,
	FirstPublished smalldatetime,
	SpecCharExists char(1) NOT NULL,
	SubjectCode varchar(20) NOT NULL,
	MetaId varchar(100),
	ProductCode varchar(20) NOT NULL,
	TimeScale varchar(20) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE MainTable ADD CONSTRAINT FK_MainTable_DataStorage 
	FOREIGN KEY (ProductCode) REFERENCES DataStorage (ProductCode)
;

ALTER TABLE MainTable ADD CONSTRAINT FK_MainTable_TimeScale 
	FOREIGN KEY (TimeScale) REFERENCES TimeScale (TimeScale)
;

ALTER TABLE MainTable ADD CONSTRAINT PK_MainTable 
	PRIMARY KEY CLUSTERED (MainTable)
;

ALTER TABLE MainTable
	ADD CONSTRAINT UQ_MainTable_Prestext UNIQUE (PresText)
;

CREATE TABLE MenuSelection ( 
	Menu varchar(80) NOT NULL,
	Selection varchar(80) NOT NULL,
	PresText varchar(100),
	PresTextS varchar(20),
	Description varchar(200),
	LevelNo char(1) NOT NULL,
	SortCode varchar(20),
	Presentation char(1) NOT NULL,
	MetaId varchar(100),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE MenuSelection ADD CONSTRAINT PK_MenuSelection 
	PRIMARY KEY CLUSTERED (Menu, Selection)
;

CREATE TABLE Link ( 
	LinkId int NOT NULL,
	Link varchar(250) NOT NULL,
	LinkType varchar(10),
	LinkFormat char(1),
	LinkText varchar(250) NOT NULL,
	PresCategory char(1) NOT NULL,
	LinkPres char(1),
	SortCode varchar(20),
	Description varchar(200),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Link ADD CONSTRAINT PK_Link 
	PRIMARY KEY CLUSTERED (LinkId)
;

CREATE TABLE LinkMenuSelection ( 
	Menu varchar(80) NOT NULL,
	Selection varchar(80) NOT NULL,
	LinkId int NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE LinkMenuSelection ADD CONSTRAINT FK_LinkMenuSelection_Link 
	FOREIGN KEY (LinkId) REFERENCES Link (LinkId)
;

ALTER TABLE LinkMenuSelection ADD CONSTRAINT FK_LinkMenuSelection_MenuSelection 
	FOREIGN KEY (Menu, Selection) REFERENCES MenuSelection (Menu, Selection)
;

ALTER TABLE LinkMenuSelection ADD CONSTRAINT PK_LinkMenuSelection 
	PRIMARY KEY CLUSTERED (Menu, Selection, LinkId)
;

CREATE TABLE SecondaryLanguage ( 
	MainTable varchar(20) NOT NULL,
	Language varchar(20) NOT NULL,
	CompletelyTranslated char(1),
	Published char(1),
	UserId varchar(20),
	LogDate smalldatetime
)
;

ALTER TABLE SecondaryLanguage ADD CONSTRAINT FK_SecondaryLanguage_MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE SecondaryLanguage ADD CONSTRAINT PK_SecondaryLanguage 
	PRIMARY KEY CLUSTERED (MainTable, Language)
;

CREATE TABLE MainTablePerson ( 
	MainTable varchar(20) NOT NULL,
	PersonCode varchar(20) NOT NULL,
	RolePerson char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE MainTablePerson ADD CONSTRAINT FK_MainTablePerson__MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE MainTablePerson ADD CONSTRAINT FK_MainTablePerson_Person 
	FOREIGN KEY (PersonCode) REFERENCES Person (PersonCode)
;

ALTER TABLE MainTablePerson ADD CONSTRAINT PK_MainTablePerson 
	PRIMARY KEY CLUSTERED (MainTable, PersonCode, RolePerson)
;

CREATE TABLE ColumnCode ( 
	MetaTable varchar(30) NOT NULL,
	ColumnName varchar(30) NOT NULL,
	Code varchar(10) NOT NULL,
	PresText varchar(80) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE ColumnCode ADD CONSTRAINT PK_ColumnCode 
	PRIMARY KEY CLUSTERED (MetaTable, ColumnName, Code)
;

CREATE TABLE Contents ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	PresText varchar(250) NOT NULL,
	PresTextS varchar(80),
	PresCode varchar(20) NOT NULL,
	Copyright char(1) NOT NULL,
	StatAuthority varchar(20) NOT NULL,
	Producer varchar(20) NOT NULL,
	LastUpdated smalldatetime,
	Published smalldatetime,
	Unit varchar(60) NOT NULL,
	PresDecimals smallint NOT NULL,
	PresCellsZero char(1) NOT NULL,
	PresMissingLine varchar(8),
	AggregPossible char(1) NOT NULL,
	RefPeriod varchar(80),
	StockFA char(1) NOT NULL,
	BasePeriod varchar(20),
	CFPrices char(1),
	DayAdj char(1) NOT NULL,
	SeasAdj char(1) NOT NULL,
	FootnoteContents char(1) NOT NULL,
	FootnoteVariable char(1) NOT NULL,
	FootnoteValue char(1) NOT NULL,
	FootnoteTime char(1) NOT NULL,
	StoreColumnNo smallint NOT NULL,
	StoreFormat char(1) NOT NULL,
	StoreNoChar smallint NOT NULL,
	StoreDecimals smallint NOT NULL,
	MetaId varchar(100),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Contents ADD CONSTRAINT FK_Contents_MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE Contents ADD CONSTRAINT FK_Contents_Organization 
	FOREIGN KEY (Producer) REFERENCES Organization (OrganizationCode)
;

ALTER TABLE Contents ADD CONSTRAINT FK_Contents_Organization_2 
	FOREIGN KEY (StatAuthority) REFERENCES Organization (OrganizationCode)
;

ALTER TABLE Contents
	ADD CONSTRAINT Contents_PresDecimals CHECK (PresDecimals between 0 and 6)
;

ALTER TABLE Contents ADD CONSTRAINT PK_Contents 
	PRIMARY KEY CLUSTERED (MainTable, Contents)
;

CREATE TABLE ContentsTime ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	TimePeriod varchar(20) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE ContentsTime ADD CONSTRAINT FK_ContentsTime_Contents 
	FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
;

ALTER TABLE ContentsTime ADD CONSTRAINT PK_ContentsTime 
	PRIMARY KEY CLUSTERED (MainTable, Contents, TimePeriod)
;

CREATE TABLE SubTable ( 
	MainTable varchar(20) NOT NULL,
	SubTable varchar(20) NOT NULL,
	PresText varchar(250) NOT NULL,
	CleanTable char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE SubTable ADD CONSTRAINT FK_SubTable_Table 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE SubTable ADD CONSTRAINT PK_SubTable 
	PRIMARY KEY CLUSTERED (MainTable, SubTable)
;

ALTER TABLE SubTable
	ADD CONSTRAINT UQ_Subtable_Prestext UNIQUE (PresText)
;

CREATE TABLE Variable ( 
	Variable varchar(20) NOT NULL,
	PresText varchar(80) NOT NULL,
	VariableInfo varchar(200),
	MetaId varchar(100),
	Footnote char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Variable ADD CONSTRAINT PK_Variable 
	PRIMARY KEY CLUSTERED (Variable)
;

CREATE TABLE ValuePool ( 
	ValuePool varchar(30) NOT NULL,
	ValuePoolAlias varchar(20),
	PresText varchar(80),
	Description varchar(200) NOT NULL,
	ValueTextExists char(1) NOT NULL,
	ValuePres char(1) NOT NULL,
	MetaId varchar(100),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE ValuePool ADD CONSTRAINT PK_ValuePool 
	PRIMARY KEY CLUSTERED (ValuePool)
;

CREATE TABLE ValueSet ( 
	ValueSet varchar(30) NOT NULL,
	PresText varchar(80),
	Description varchar(200) NOT NULL,
	Elimination varchar(20) NOT NULL,
	ValuePool varchar(30) NOT NULL,
	ValuePres char(1) NOT NULL,
	GeoAreaNo smallint,
	MetaId varchar(100),
	SortCodeExists char(1) NOT NULL,
	Footnote char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE ValueSet ADD CONSTRAINT FK_ValueSet_ValuePool 
	FOREIGN KEY (ValuePool) REFERENCES ValuePool (ValuePool)
;

ALTER TABLE ValueSet ADD CONSTRAINT PK_ValueSet 
	PRIMARY KEY CLUSTERED (ValueSet)
;

CREATE TABLE Value ( 
	ValuePool varchar(30) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	SortCode varchar(20) NOT NULL,
	Unit varchar(30),
	ValueTextS varchar(250),
	ValueTextL varchar(1100),
	MetaId varchar(100),
	Footnote char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Value ADD CONSTRAINT FK_Value_ValuePool 
	FOREIGN KEY (ValuePool) REFERENCES ValuePool (ValuePool)
;

ALTER TABLE Value ADD CONSTRAINT PK_Value 
	PRIMARY KEY CLUSTERED (ValuePool, ValueCode)
;

CREATE TABLE VSValue ( 
	ValueSet varchar(30) NOT NULL,
	ValuePool varchar(30) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	SortCode varchar(20),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE VSValue ADD CONSTRAINT FK_VSValue_Value 
	FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
;

ALTER TABLE VSValue ADD CONSTRAINT FK_VSValue_ValueSet 
	FOREIGN KEY (ValueSet) REFERENCES ValueSet (ValueSet)
;

ALTER TABLE VSValue ADD CONSTRAINT PK_VSValue 
	PRIMARY KEY CLUSTERED (ValueSet, ValuePool, ValueCode)
;

CREATE TABLE Grouping ( 
	Grouping varchar(30) NOT NULL,
	ValuePool varchar(30) NOT NULL,
	PresText varchar(100) NOT NULL,
	Hierarchy char(1) NOT NULL,
	SortCode varchar(20),
	GroupPres char(1) NOT NULL,
	Description varchar(200),
	MetaId varchar(100),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Grouping ADD CONSTRAINT FK_Grouping_ValuePool 
	FOREIGN KEY (ValuePool) REFERENCES ValuePool (ValuePool)
;

ALTER TABLE Grouping ADD CONSTRAINT PK_Grouping 
	PRIMARY KEY CLUSTERED (Grouping)
;

CREATE TABLE GroupingLevel ( 
	Grouping varchar(30) NOT NULL,
	LevelNo numeric(2) NOT NULL,
	LevelText varchar(250),
	GeoAreaNo numeric(2),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE GroupingLevel ADD CONSTRAINT FK_GroupingLevel_Grouping 
	FOREIGN KEY (Grouping) REFERENCES Grouping (Grouping)
;

ALTER TABLE GroupingLevel ADD CONSTRAINT PK_GroupingLevel 
	PRIMARY KEY CLUSTERED (Grouping, LevelNo)
;

CREATE TABLE ValueGroup ( 
	Grouping varchar(30) NOT NULL,
	GroupCode varchar(20) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	ValuePool varchar(30) NOT NULL,
	GroupLevel numeric(2) NOT NULL,
	ValueLevel numeric(2) NOT NULL,
	SortCode varchar(20),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE ValueGroup ADD CONSTRAINT FK_ValueGroup_Value 
	FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
;

ALTER TABLE ValueGroup ADD CONSTRAINT PK_ValueGroup 
	PRIMARY KEY CLUSTERED (Grouping, GroupCode, ValueCode)
;

CREATE TABLE ValueSetGrouping ( 
	ValueSet varchar(30) NOT NULL,
	Grouping varchar(30) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE ValueSetGrouping ADD CONSTRAINT FK_ValueSetGrouping_Grouping 
	FOREIGN KEY (Grouping) REFERENCES Grouping (Grouping)
;

ALTER TABLE ValueSetGrouping ADD CONSTRAINT FK_ValueSetGrouping_ValueSet 
	FOREIGN KEY (ValueSet) REFERENCES ValueSet (ValueSet)
;

ALTER TABLE ValueSetGrouping ADD CONSTRAINT PK_ValueSetGrouping 
	PRIMARY KEY CLUSTERED (ValueSet, Grouping)
;

CREATE TABLE SubTableVariable ( 
	MainTable varchar(20) NOT NULL,
	SubTable varchar(20) NOT NULL,
	Variable varchar(20) NOT NULL,
	ValueSet varchar(30),
	VariableType char(1) NOT NULL,
	StoreColumnNo smallint NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE SubTableVariable ADD CONSTRAINT FK_SubTableVariable_SubTable 
	FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable)
;

ALTER TABLE SubTableVariable ADD CONSTRAINT FK_SubTableVariable_ValueSet 
	FOREIGN KEY (ValueSet) REFERENCES ValueSet (ValueSet)
;

ALTER TABLE SubTableVariable ADD CONSTRAINT FK_SubTableVariable_Variable 
	FOREIGN KEY (Variable) REFERENCES Variable (Variable)
;

ALTER TABLE SubTableVariable ADD CONSTRAINT PK_SubTableVariable 
	PRIMARY KEY CLUSTERED (MainTable, SubTable, Variable)
;

CREATE TABLE Attribute ( 
	MainTable varchar(20) NOT NULL,
	Attribute varchar(20) NOT NULL,
	AttributeColumn varchar(41) NOT NULL,
	PresText varchar(25),
	SequenceNo smallint NOT NULL,
	Description varchar(200),
	ValueSet varchar(30),
	ColumnLength smallint NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Attribute ADD CONSTRAINT FK_Attribute_MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE Attribute ADD CONSTRAINT FK_Attribute_ValueSet 
	FOREIGN KEY (ValueSet) REFERENCES ValueSet (ValueSet)
;

ALTER TABLE Attribute ADD CONSTRAINT PK_Attribute 
	PRIMARY KEY CLUSTERED (MainTable, Attribute)
;

CREATE TABLE MainTableVariableHierarchy ( 
	MainTable varchar(20) NOT NULL,
	Variable varchar(20) NOT NULL,
	Grouping varchar(30) NOT NULL,
	ShowLevels numeric(2),
	AllLevelsStored char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE MainTableVariableHierarchy ADD CONSTRAINT FK_MainTableVariableHierarchy_Grouping 
	FOREIGN KEY (Grouping) REFERENCES Grouping (Grouping)
;

ALTER TABLE MainTableVariableHierarchy ADD CONSTRAINT FK_MainTableVariableHierarchy_MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE MainTableVariableHierarchy ADD CONSTRAINT FK_MainTableVariableHierarchy_Variable 
	FOREIGN KEY (Variable) REFERENCES Variable (Variable)
;

ALTER TABLE MainTableVariableHierarchy ADD CONSTRAINT PK_MainTableVariableHierarchy 
	PRIMARY KEY CLUSTERED (MainTable, Variable, Grouping)
;

CREATE TABLE Footnote ( 
	FootnoteNo numeric(6) NOT NULL,
	FootnoteType char(1) NOT NULL,
	ShowFootnote char(1) NOT NULL,
	MandOpt char(1) NOT NULL,
	FootnoteText text NOT NULL,
	PresCharacter varchar(20),
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE Footnote ADD CONSTRAINT PK_Footnote 
	PRIMARY KEY CLUSTERED (FootnoteNo)
;

CREATE TABLE FootnoteContents ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteContents ADD CONSTRAINT FK_FootnoteContents_Contents 
	FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
;

ALTER TABLE FootnoteContents ADD CONSTRAINT FK_FootnoteContents_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteContents ADD CONSTRAINT PK_FootnoteContents 
	PRIMARY KEY CLUSTERED (MainTable, Contents, FootnoteNo)
;

CREATE TABLE FootnoteContTime ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	TimePeriod varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	Cellnote char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteContTime ADD CONSTRAINT FK_FootnoteContTime_ContentsTime 
	FOREIGN KEY (MainTable, Contents, TimePeriod) REFERENCES ContentsTime (MainTable, Contents, TimePeriod)
;

ALTER TABLE FootnoteContTime ADD CONSTRAINT FK_FootnoteContTime_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteContTime ADD CONSTRAINT PK_FootnoteContTime 
	PRIMARY KEY CLUSTERED (MainTable, Contents, TimePeriod, FootnoteNo)
;

CREATE TABLE FootnoteContValue ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	Variable varchar(20) NOT NULL,
	ValuePool varchar(20) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	Cellnote char(1) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteContValue ADD CONSTRAINT FK_FootnoteContValue 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteContValue ADD CONSTRAINT FK_FootnoteContValue_Contents 
	FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
;

ALTER TABLE FootnoteContValue ADD CONSTRAINT FK_FootnoteContValue_Variable 
	FOREIGN KEY (Variable) REFERENCES Variable (Variable)
;

ALTER TABLE FootnoteContValue ADD CONSTRAINT PK_FootnoteContValue 
	PRIMARY KEY CLUSTERED (MainTable, Contents, Variable, ValuePool, ValueCode, FootnoteNo)
;

CREATE TABLE FootnoteContVbl ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	Variable varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteContVbl ADD CONSTRAINT FK_FootnoteContVbl_Contents 
	FOREIGN KEY (MainTable, Contents) REFERENCES Contents (MainTable, Contents)
;

ALTER TABLE FootnoteContVbl ADD CONSTRAINT FK_FootnoteContVbl_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteContVbl ADD CONSTRAINT FK_FootnoteContVbl_Variable 
	FOREIGN KEY (Variable) REFERENCES Variable (Variable)
;

ALTER TABLE FootnoteContVbl ADD CONSTRAINT PK_FootnoteContVbl 
	PRIMARY KEY CLUSTERED (MainTable, Contents, Variable, FootnoteNo)
;

CREATE TABLE FootnoteGrouping ( 
	Grouping varchar(30) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteGrouping ADD CONSTRAINT FK_FootnoteGrouping_Grouping 
	FOREIGN KEY (Grouping) REFERENCES Grouping (Grouping)
;

ALTER TABLE FootnoteGrouping ADD CONSTRAINT FK_FootnoteGrouping_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteGrouping ADD CONSTRAINT PK_FotnotGruppering 
	PRIMARY KEY CLUSTERED (Grouping, FootnoteNo)
;

CREATE TABLE FootnoteMainTable ( 
	MainTable varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteMainTable ADD CONSTRAINT FK_FootnoteMainTable_MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE FootnoteMainTable ADD CONSTRAINT FK_FootnoteMainTable_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteMainTable ADD CONSTRAINT PK_FootnoteMainTable 
	PRIMARY KEY CLUSTERED (MainTable, FootnoteNo)
;

CREATE TABLE FootnoteMaintTime ( 
	MainTable varchar(20) NOT NULL,
	Contents varchar(20) NOT NULL,
	TimePeriod varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteMaintTime ADD CONSTRAINT FK_FootnoteMaintTime_ContentsTime 
	FOREIGN KEY (MainTable, Contents, TimePeriod) REFERENCES ContentsTime (MainTable, Contents, TimePeriod)
;

ALTER TABLE FootnoteMaintTime ADD CONSTRAINT FK_FootnoteMaintTime_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteMaintTime ADD CONSTRAINT PK_FootnoteMaintTime 
	PRIMARY KEY CLUSTERED (MainTable, TimePeriod, FootnoteNo)
;

CREATE TABLE FootnoteMaintValue ( 
	MainTable varchar(20) NOT NULL,
	Variable varchar(20) NOT NULL,
	ValuePool varchar(30) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteMaintValue ADD CONSTRAINT FK_FootnoteMaintValue_Value 
	FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
;

ALTER TABLE FootnoteMaintValue ADD CONSTRAINT FK_FootnoteMaintValue_MainTable 
	FOREIGN KEY (MainTable) REFERENCES MainTable (MainTable)
;

ALTER TABLE FootnoteMaintValue ADD CONSTRAINT FK_FootnoteMaintValue_Variable 
	FOREIGN KEY (Variable) REFERENCES Variable (Variable)
;

ALTER TABLE FootnoteMaintValue ADD CONSTRAINT FK_FootnoteMaintValue_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteMaintValue ADD CONSTRAINT PK_FootnoteMaintValue 
	PRIMARY KEY CLUSTERED (MainTable, Variable, ValuePool, ValueCode, FootnoteNo)
;

CREATE TABLE FootnoteMenuSel ( 
	Menu varchar(80) NOT NULL,
	Selection varchar(80) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteMenuSel ADD CONSTRAINT FK_FootnoteMenuSel_MenuSelection 
	FOREIGN KEY (Menu, Selection) REFERENCES MenuSelection (Menu, Selection)
;

ALTER TABLE FootnoteMenuSel ADD CONSTRAINT FK_FootnoteMenuSel_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteMenuSel ADD CONSTRAINT PK_FootnoteMenuSel 
	PRIMARY KEY CLUSTERED (Menu, Selection, FootnoteNo)
;

CREATE TABLE FootnoteSubTable ( 
	MainTable varchar(20) NOT NULL,
	SubTable varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteSubTable ADD CONSTRAINT FK_FootnoteSubTable_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteSubTable ADD CONSTRAINT FK_FootnoteSubTable_SubTable 
	FOREIGN KEY (MainTable, SubTable) REFERENCES SubTable (MainTable, SubTable)
;

ALTER TABLE FootnoteSubTable ADD CONSTRAINT PK_FootnoteSubTable 
	PRIMARY KEY CLUSTERED (MainTable, SubTable, FootnoteNo)
;

CREATE TABLE FootnoteValue ( 
	ValuePool varchar(30) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteValue ADD CONSTRAINT FK_FootnoteValue_Value 
	FOREIGN KEY (ValuePool, ValueCode) REFERENCES Value (ValuePool, ValueCode)
;

ALTER TABLE FootnoteValue ADD CONSTRAINT FK_FootnoteValue_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteValue ADD CONSTRAINT PK_FootnoteValue 
	PRIMARY KEY CLUSTERED (ValuePool, ValueCode, FootnoteNo)
;

CREATE TABLE FootnoteValueSetValue ( 
	ValuePool varchar(20) NOT NULL,
	ValueSet varchar(30) NOT NULL,
	ValueCode varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteValueSetValue ADD CONSTRAINT FK_FootnoteValuSet_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteValueSetValue ADD CONSTRAINT PK_FootnoteValuset 
	PRIMARY KEY CLUSTERED (ValuePool, ValueSet, ValueCode, FootnoteNo)
;

CREATE TABLE FootnoteVariable ( 
	Variable varchar(20) NOT NULL,
	FootnoteNo numeric(6) NOT NULL,
	UserId varchar(20) NOT NULL,
	LogDate smalldatetime NOT NULL
)
;

ALTER TABLE FootnoteVariable ADD CONSTRAINT FK_FootnoteVariable_Footnote 
	FOREIGN KEY (FootnoteNo) REFERENCES Footnote (FootnoteNo)
;

ALTER TABLE FootnoteVariable ADD CONSTRAINT FK_FootnoteVariable_Variable 
	FOREIGN KEY (Variable) REFERENCES Variable (Variable)
;

ALTER TABLE FootnoteVariable ADD CONSTRAINT PK_FootnoteVariable 
	PRIMARY KEY CLUSTERED (Variable, FootnoteNo)
;

PRINT N'Done creating Metabase schema.';