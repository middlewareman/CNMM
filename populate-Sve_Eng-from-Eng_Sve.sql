-- Assume already cnmm.Metabase.schema_Eng.ddl
SET NOCOUNT ON;
GO

INSERT INTO SpecialCharacter_Eng (CharacterType, PresCharacter, PresText, UserId, LogDate)
SELECT CharacterType, PresCharacter, PresText, UserId, LogDate
FROM SpecialCharacter;

UPDATE m
SET m.PresCharacter = s.PresCharacter,
    m.PresText      = s.PresText
FROM SpecialCharacter m
         INNER JOIN SpecialCharacter_Sve s ON m.CharacterType = s.CharacterType;

---

INSERT INTO TimeScale_Eng (TimeScale, PresText, UserId, LogDate)
SELECT TimeScale, PresText, UserId, LogDate
FROM TimeScale;

UPDATE m
SET m.PresText = s.PresText
FROM TimeScale m
         INNER JOIN TimeScale_Sve s ON m.TimeScale = s.TimeScale;
---

INSERT INTO TextCatalog_Eng (TextCatalogNo, TextType, PresText, Description, UserId, LogDate)
SELECT TextCatalogNo, TextType, PresText, Description, UserId, LogDate
FROM TextCatalog;

UPDATE m
SET m.TextType    = s.TextType,
    m.PresText    = s.PresText,
    m.Description = s.Description
FROM TextCatalog m
         INNER JOIN TextCatalog_Sve s ON m.TextCatalogNo = s.TextCatalogNo;

---

INSERT INTO Organization_Eng (OrganizationCode, OrganizationName, Department, Unit, WebAddress, UserId, LogDate)
SELECT OrganizationCode, OrganizationName, Department, Unit, WebAddress, UserId, LogDate
FROM Organization;

UPDATE m
SET m.OrganizationName = s.OrganizationName,
    m.Department       = s.Department,
    m.Unit             = s.Unit,
    m.WebAddress       = s.WebAddress
FROM Organization m
         INNER JOIN Organization_Sve s ON m.OrganizationCode = s.OrganizationCode;

---

INSERT INTO MenuSelection_Eng (Menu, Selection, PresText, PresTextS, Description, SortCode, Presentation, UserId,
                               LogDate)
SELECT Menu,
       Selection,
       PresText,
       PresTextS,
       Description,
       SortCode,
       Presentation,
       UserId,
       LogDate
FROM MenuSelection;

UPDATE m
SET m.PresText     = s.PresText,
    m.PresTextS    = s.PresTextS,
    m.Description  = s.Description,
    m.SortCode     = s.SortCode,
    m.Presentation = s.Presentation
FROM MenuSelection m
         INNER JOIN MenuSelection_Sve s ON m.Menu = s.Menu AND m.Selection = s.Selection;

---

INSERT INTO Link_Eng (LinkId, Link, LinkText, SortCode, Description, UserId, LogDate)
SELECT LinkId, Link, LinkText, SortCode, Description, UserId, LogDate
FROM Link;

UPDATE m
SET m.Link        = s.Link,
    m.LinkText    = s.LinkText,
    m.SortCode    = s.SortCode,
    m.Description = s.Description
FROM Link m
         INNER JOIN Link_Sve s ON m.LinkId = s.LinkId;

---

INSERT INTO MainTable_Eng (MainTable, PresText, PresTextS, ContentsVariable, UserId, LogDate)
SELECT MainTable, PresText, PresTextS, ContentsVariable, UserId, LogDate
FROM MainTable;

UPDATE m
SET m.PresText         = s.PresText,
    m.PresTextS        = s.PresTextS,
    m.ContentsVariable = s.ContentsVariable
FROM MainTable m
         INNER JOIN MainTable_Sve s ON m.MainTable = s.MainTable;

---

INSERT INTO ColumnCode_Eng (MetaTable, ColumnName, Code, CodeEng, PresText, UserId, LogDate)
SELECT MetaTable, ColumnName, Code, Code, PresText, UserId, LogDate -- NOTE CodeEng = Code
FROM ColumnCode;

UPDATE m
SET m.PresText = s.PresText
FROM ColumnCode m
         INNER JOIN ColumnCode_Sve s ON m.MetaTable = s.MetaTable AND m.ColumnName = s.ColumnName AND m.Code = s.Code;

---

INSERT INTO Contents_Eng (MainTable, Contents, PresText, PresTextS, Unit, RefPeriod, BasePeriod, UserId, LogDate)
SELECT MainTable,
       Contents,
       PresText,
       PresTextS,
       Unit,
       RefPeriod,
       BasePeriod,
       UserId,
       LogDate
FROM Contents;

UPDATE m
SET m.PresText   = s.PresText,
    m.PresTextS  = s.PresTextS,
    m.Unit       = s.Unit,
    m.RefPeriod  = s.RefPeriod,
    m.BasePeriod = s.BasePeriod
FROM Contents m
         INNER JOIN Contents_Sve s ON m.MainTable = s.MainTable AND m.Contents = s.Contents;

---

INSERT INTO SubTable_Eng (MainTable, SubTable, PresText, UserId, LogDate)
SELECT MainTable, SubTable, PresText, UserId, LogDate
FROM SubTable;

UPDATE m
SET m.PresText = s.PresText
FROM SubTable m
         INNER JOIN SubTable_Sve s ON m.MainTable = s.MainTable AND m.SubTable = s.SubTable;

---

INSERT INTO Variable_Eng (Variable, PresText, UserId, LogDate)
SELECT Variable, PresText, UserId, LogDate
FROM Variable;

UPDATE m
SET m.PresText = s.PresText
FROM Variable m
         INNER JOIN Variable_Sve s ON m.Variable = s.Variable;

---

INSERT INTO ValuePool_Eng (ValuePool, ValuePoolAlias, PresText, UserId, LogDate)
SELECT ValuePool, ValuePoolAlias, PresText, UserId, LogDate
FROM ValuePool;

UPDATE m
SET m.ValuePoolAlias = s.ValuePoolAlias,
    m.PresText       = s.PresText
FROM ValuePool m
         INNER JOIN ValuePool_Sve s ON m.ValuePool = s.ValuePool;

---

INSERT INTO ValueSet_Eng (ValueSet, PresText, Description, UserId, LogDate)
SELECT ValueSet, PresText, Description, UserId, LogDate
FROM ValueSet;

UPDATE m
SET m.PresText    = s.PresText,
    m.Description = s.Description
FROM ValueSet m
         INNER JOIN ValueSet_Sve s ON m.ValueSet = s.ValueSet;

---

INSERT INTO Value_Eng (ValuePool, ValueCode, SortCode, Unit, ValueTextS, ValueTextL, UserId, LogDate)
SELECT ValuePool,
       ValueCode,
       SortCode,
       Unit,
       ValueTextS,
       ValueTextL,
       UserId,
       LogDate
FROM Value;

UPDATE m
SET m.SortCode   = s.SortCode,
    m.Unit       = s.Unit,
    m.ValueTextS = s.ValueTextS,
    m.ValueTextL = s.ValueTextL
FROM Value m
         INNER JOIN Value_Sve s ON m.ValuePool = s.ValuePool AND m.ValueCode = s.ValueCode;

---

INSERT INTO VSValue_Eng (ValueSet, ValuePool, ValueCode, SortCode, UserId, LogDate)
SELECT ValueSet, ValuePool, ValueCode, SortCode, UserId, LogDate
FROM VSValue;

UPDATE m
SET m.SortCode = s.SortCode
FROM VSValue m
         INNER JOIN VSValue_Sve s
                    ON m.ValueSet = s.ValueSet AND m.ValuePool = s.ValuePool AND m.ValueCode = s.ValueCode;

---

INSERT INTO Grouping_Eng (Grouping, ValuePool, PresText, SortCode, UserId, LogDate)
SELECT Grouping, ValuePool, PresText, SortCode, UserId, LogDate
FROM Grouping;

UPDATE m
SET m.ValuePool = s.ValuePool,
    m.PresText  = s.PresText,
    m.SortCode  = s.SortCode
FROM Grouping m
         INNER JOIN Grouping_Sve s ON m.Grouping = s.Grouping;

---

INSERT INTO GroupingLevel_Eng (Grouping, Level, LevelText, UserId, LogDate)
SELECT Grouping,
       LevelNo,
       LevelText,
       UserId,
       LogDate -- NOTE GroupingLevel.LevelNo <-> GroupingLevel_Eng.Level
FROM GroupingLevel;

UPDATE m
SET m.LevelText = s.LevelText
FROM GroupingLevel m
         INNER JOIN GroupingLevel_Sve s ON m.Grouping = s.Grouping AND m.LevelNo = s.Level;

---

INSERT INTO ValueGroup_Eng (Grouping, GroupCode, ValueCode, SortCode, UserId, LogDate)
SELECT Grouping, GroupCode, ValueCode, SortCode, UserId, LogDate
FROM ValueGroup;

UPDATE m
SET m.SortCode = s.SortCode
FROM ValueGroup m
         INNER JOIN ValueGroup_Sve s
                    ON m.Grouping = s.Grouping AND m.GroupCode = s.GroupCode AND m.ValueCode = s.ValueCode;

---

INSERT INTO Attribute_Eng (MainTable, Attribute, Description, PresText, UserId, LogDate)
SELECT MainTable, Attribute, Description, PresText, UserId, LogDate
FROM Attribute;

UPDATE m
SET m.Description = s.Description,
    m.PresText    = s.PresText
FROM Attribute m
         INNER JOIN Attribute_Sve s ON m.MainTable = s.MainTable AND m.Attribute = s.Attribute;

---

INSERT INTO Footnote_Eng (FootnoteNo, FootnoteText, UserId, LogDate)
SELECT FootnoteNo, FootnoteText, UserId, LogDate
FROM Footnote;

UPDATE m
SET m.FootnoteText = s.FootnoteText
FROM Footnote m
         INNER JOIN Footnote_Sve s ON m.FootnoteNo = s.FootnoteNo;
