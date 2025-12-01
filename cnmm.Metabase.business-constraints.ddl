-- ============================================================================
-- Business rules (CHECK constraints, indexes, triggers) derived from UML model
-- ============================================================================
GO

-- CHECK constraints: Domains for flag/code columns
ALTER TABLE MainTable
    ADD
        CONSTRAINT CK_MainTable_TableStatus CHECK ([TableStatus] IN ('A', 'P', 'D')),
        CONSTRAINT CK_MainTable_PresCategory CHECK ([PresCategory] IN ('O', 'U', 'T')),
        CONSTRAINT CK_MainTable_SpecChar CHECK ([SpecCharExists] IN ('Y', 'N'));
GO

ALTER TABLE SpecialCharacter
    ADD
        CONSTRAINT CK_SpecialCharacter_AggregPossible CHECK ([AggregPossible] IN ('Y', 'N')),
        CONSTRAINT CK_SpecialCharacter_DataCellPres CHECK ([DataCellPres] IN ('Y', 'N')),
        CONSTRAINT CK_SpecialCharacter_DataCellFilled CHECK ([DataCellFilled] IS NULL OR [DataCellFilled] IN ('Y', 'N'));
GO

ALTER TABLE TimeScale
    ADD
        CONSTRAINT CK_TimeScale_Regular CHECK ([Regular] IN ('Y', 'N')),
        CONSTRAINT CK_TimeScale_TimeUnit CHECK ([TimeUnit] IN ('Y', 'Q', 'M', 'W', 'D', 'H'));
GO

ALTER TABLE SubTable
    ADD
        CONSTRAINT CK_SubTable_CleanTable CHECK ([CleanTable] IN ('Y', 'N'));
GO

ALTER TABLE Variable
    ADD
        CONSTRAINT CK_Variable_Footnote CHECK ([Footnote] IN ('Y', 'N'));
GO

ALTER TABLE ValuePool
    ADD
        CONSTRAINT CK_ValuePool_ValueTextExists CHECK ([ValueTextExists] IN ('L', 'S', 'B', 'N')),
        CONSTRAINT CK_ValuePool_ValuePres CHECK ([ValuePres] IN ('A', 'B', 'C', 'S', 'T'));
GO

ALTER TABLE Value
    ADD
        CONSTRAINT CK_Value_Footnote CHECK ([Footnote] IN ('Y', 'N'));
GO

ALTER TABLE ValueSet
    ADD
        CONSTRAINT CK_ValueSet_Elimination CHECK ([Elimination] IN ('Y', 'N')),
        CONSTRAINT CK_ValueSet_ValuePres CHECK ([ValuePres] IN ('A', 'B', 'C', 'S', 'T', 'V')),
        CONSTRAINT CK_ValueSet_SortCodeExist CHECK ([SortCodeExists] IN ('Y', 'N')),
        CONSTRAINT CK_ValueSet_Footnote CHECK ([Footnote] IN ('B', 'V', 'O', 'N'));
GO

ALTER TABLE Grouping
    ADD
        CONSTRAINT CK_Grouping_Hierarchy CHECK ([Hierarchy] IN ('N', 'B', 'U')),
        CONSTRAINT CK_Grouping_GroupPres CHECK ([GroupPres] IN ('A', 'I', 'B'));
GO

ALTER TABLE ValueGroup
    ADD
        CONSTRAINT CK_ValueGroup_LevelOrder CHECK ([GroupLevel] < [ValueLevel]);
GO

ALTER TABLE MainTablePerson
    ADD
        CONSTRAINT CK_MainTablePerson_Role CHECK ([RolePerson] IN ('P', 'C', 'E', 'Q'));
GO

ALTER TABLE SecondaryLanguage
    ADD
        CONSTRAINT CK_SecondaryLanguage_CT CHECK ([CompletelyTranslated] IS NULL OR [CompletelyTranslated] IN ('Y', 'N')),
        CONSTRAINT CK_SecondaryLanguage_P CHECK ([Published] IS NULL OR [Published] IN ('Y', 'N'));
GO

ALTER TABLE Contents
    ADD
        CONSTRAINT CK_Contents_PresCellsZero CHECK ([PresCellsZero] IN ('Y', 'N', 'C')),
        CONSTRAINT CK_Contents_AggregPossible CHECK ([AggregPossible] IN ('Y', 'N')),
        CONSTRAINT CK_Contents_StockFA CHECK ([StockFA] IN ('S', 'F', 'A')),
        CONSTRAINT CK_Contents_DayAdj CHECK ([DayAdj] IN ('Y', 'N')),
        CONSTRAINT CK_Contents_SeasAdj CHECK ([SeasAdj] IN ('Y', 'N')),
        CONSTRAINT CK_Contents_FootnoteFlags CHECK (
            [FootnoteContents] IN ('Y', 'N') AND [FootnoteVariable] IN ('Y', 'N') AND [FootnoteValue] IN ('Y', 'N') AND
            [FootnoteTime] IN ('Y', 'N')
            ),
        CONSTRAINT CK_Contents_StoreFormat CHECK ([StoreFormat] IN ('F', 'I', 'N', 'C')),
        CONSTRAINT CK_Contents_CFPrices CHECK ([CFPrices] IS NULL OR [CFPrices] IN ('C', 'F'));
GO

ALTER TABLE Footnote
    ADD
        -- UML: FootnoteType ∈ {'1','2','3','4','5','6','7','8','9','A','B','C','Q'}
        CONSTRAINT CK_Footnote_Type CHECK ([FootnoteType] IN
                                           ('1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'Q')),
        -- UML: ShowFootnote ∈ {'B','P','S'} (Both, Presentation, Selection)
        CONSTRAINT CK_Footnote_Show CHECK ([ShowFootnote] IN ('B', 'P', 'S')),
        CONSTRAINT CK_Footnote_MandOpt CHECK ([MandOpt] IN ('M', 'O'));
GO

ALTER TABLE FootnoteContTime
    ADD
        CONSTRAINT CK_FootnoteContTime_Cellnote CHECK ([Cellnote] IN ('Y', 'N'));
GO

ALTER TABLE FootnoteContValue
    ADD
        CONSTRAINT CK_FootnoteContValue_Cellnote CHECK ([Cellnote] IN ('Y', 'N'));
GO

-- SubTableVariable: domain + conditional ValueSet presence
ALTER TABLE SubTableVariable
    ADD
        CONSTRAINT CK_SubTableVariable_Type CHECK ([VariableType] IN ('C', 'T', 'G', 'V')),
        CONSTRAINT CK_SubTableVariable_ValueSetByType CHECK (
            ([VariableType] IN ('C', 'G') AND [ValueSet] IS NOT NULL) OR
            ([VariableType] IN ('T', 'V') AND [ValueSet] IS NULL)
            );
GO

-- Cardinality: At most one time variable (VariableType='T') per (MainTable, SubTable)
CREATE UNIQUE NONCLUSTERED INDEX UQ_SubTableVariable_TimePerSubtable
    ON SubTableVariable (MainTable, SubTable)
    WHERE VariableType = 'T';
GO

-- VSValue: If the owning ValueSet declares SortCodeExists='Y', then VSValue.SortCode must be present
CREATE OR ALTER TRIGGER TR_VSValue_SortCodeRequired
    ON VSValue
    AFTER INSERT, UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
               FROM inserted i
                        JOIN ValueSet vs ON vs.ValueSet = i.ValueSet
               WHERE vs.SortCodeExists = 'Y'
                 AND (i.SortCode IS NULL OR LTRIM(RTRIM(i.SortCode)) = ''))
        BEGIN
            RAISERROR ('VSValue.SortCode is required when ValueSet.SortCodeExists = ''Y''.', 16, 1);
            RETURN;
        END
END
GO

-- ValueSet: Prevent switching SortCodeExists to 'Y' if any existing VSValue in the set lacks SortCode
CREATE OR ALTER TRIGGER TR_ValueSet_SortCodeSwitch
    ON ValueSet
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
               FROM inserted i
               WHERE i.SortCodeExists = 'Y'
                 AND EXISTS (SELECT 1
                             FROM VSValue vsv
                             WHERE vsv.ValueSet = i.ValueSet
                               AND (vsv.SortCode IS NULL OR LTRIM(RTRIM(vsv.SortCode)) = '')))
        BEGIN
            RAISERROR ('Cannot set ValueSet.SortCodeExists = ''Y'' while some VSValue rows lack SortCode.', 16, 1);
            RETURN;
        END
END
GO

-- ValueSetGrouping: Enforce that ValueSet.ValuePool = Grouping.ValuePool
CREATE OR ALTER TRIGGER TR_ValueSetGrouping_ValuePoolMatch
    ON ValueSetGrouping
    AFTER INSERT, UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
               FROM inserted i
                        JOIN ValueSet vs ON vs.ValueSet = i.ValueSet
                        JOIN Grouping g ON g.Grouping = i.Grouping
               WHERE vs.ValuePool <> g.ValuePool)
        BEGIN
            RAISERROR ('ValueSetGrouping violates ValuePool match: ValueSet.ValuePool must equal Grouping.ValuePool.', 16, 1);
            RETURN;
        END
END
GO

-- GeoAreaNo conditional rule via usage (SubTableVariable):
-- If a ValueSet is used by a variable of type G => GeoAreaNo NOT NULL
-- If used by type C => GeoAreaNo must be NULL
CREATE OR ALTER TRIGGER TR_SubTableVariable_GeoAreaNo
    ON SubTableVariable
    AFTER INSERT, UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    -- Only rows with a ValueSet (C/G) are relevant here
    IF EXISTS (SELECT 1
               FROM inserted i
                        JOIN ValueSet vs ON vs.ValueSet = i.ValueSet
               WHERE i.VariableType = 'G'
                 AND vs.GeoAreaNo IS NULL)
        BEGIN
            RAISERROR ('ValueSet.GeoAreaNo must be NOT NULL when used by VariableType = ''G''.', 16, 1);
            RETURN;
        END
    IF EXISTS (SELECT 1
               FROM inserted i
                        JOIN ValueSet vs ON vs.ValueSet = i.ValueSet
               WHERE i.VariableType = 'C'
                 AND vs.GeoAreaNo IS NOT NULL)
        BEGIN
            RAISERROR ('ValueSet.GeoAreaNo must be NULL when used by VariableType = ''C''.', 16, 1);
            RETURN;
        END
END
GO

-- ValueGroup: prevent cycles within a Grouping (parent GroupCode must not be reachable from its child ValueCode)
CREATE OR ALTER TRIGGER TR_ValueGroup_NoCycles
    ON ValueGroup
    AFTER INSERT, UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @hasCycle int = 0;
    ;
    WITH H AS (
        -- Start from the newly inserted/updated edge(s)
        SELECT i.Grouping, i.GroupCode, i.ValueCode
        FROM inserted i
        UNION ALL
        -- Walk downwards: if we can reach back to the original GroupCode, there's a cycle
        SELECT vg.Grouping, H.GroupCode, vg.ValueCode
        FROM ValueGroup vg
                 JOIN H ON H.Grouping = vg.Grouping AND H.ValueCode = vg.GroupCode)
    SELECT TOP (1) @hasCycle = 1
    FROM H
             JOIN inserted i
                  ON H.Grouping = i.Grouping
                      AND H.ValueCode = i.GroupCode;

    IF (@hasCycle = 1)
        BEGIN
            RAISERROR ('Cycle detected in ValueGroup hierarchy for this Grouping.', 16, 1);
            RETURN;
        END
END
GO