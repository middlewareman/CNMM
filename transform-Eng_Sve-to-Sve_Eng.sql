USE Metabase;
GO

SET NOCOUNT ON;
GO

BEGIN TRAN;

:R cnmm.Metabase.schema_Eng.ddl
:R populate-Sve_Eng-from-Eng_Sve.sql

UPDATE SecondaryLanguage
SET Language = 'en'
WHERE Language = 'sv';

UPDATE MetaAdm
SET Value       = 'SVE',
    Description = 'Swedish'
WHERE Property = 'Language1';

UPDATE MetaAdm
SET Value       = 'ENG',
    Description = 'English'
WHERE Property = 'Language2';

DROP TABLE IF EXISTS Attribute_Sve;
DROP TABLE IF EXISTS ColumnCode_Sve;
DROP TABLE IF EXISTS Contents_Sve;
DROP TABLE IF EXISTS Footnote_Sve;
DROP TABLE IF EXISTS GroupingLevel_Sve;
DROP TABLE IF EXISTS Grouping_Sve;
DROP TABLE IF EXISTS Link_Sve;
DROP TABLE IF EXISTS MainTable_Sve;
DROP TABLE IF EXISTS MenuSelection_Sve;
DROP TABLE IF EXISTS Organization_Sve;
DROP TABLE IF EXISTS SpecialCharacter_Sve;
DROP TABLE IF EXISTS SubTable_Sve;
DROP TABLE IF EXISTS TextCatalog_Sve;
DROP TABLE IF EXISTS TimeScale_Sve;
DROP TABLE IF EXISTS VSValue_Sve;
DROP TABLE IF EXISTS ValueGroup_Sve;
DROP TABLE IF EXISTS ValuePool_Sve;
DROP TABLE IF EXISTS ValueSet_Sve;
DROP TABLE IF EXISTS Value_Sve;
DROP TABLE IF EXISTS Variable_Sve;

COMMIT TRAN;