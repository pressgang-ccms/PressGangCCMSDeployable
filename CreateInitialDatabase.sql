# Create the initial database schema
# CREATE SCHEMA PressGang;

# Dump the table structure from the live database into the initial database
# mysqldump -uroot --no-data Skynet | mysql -uroot -A -DPressGang

# The IDs of the database records that will be part of the initial database
SET @PressGangTag = 540;

SET @TopicIDs = '14591,14591,14591,12510,12683,12559,12560,12587,12588,12589,12592,12556,12558,13434,13581,13582,13583,13663,13664,13664,13742,13743,13744,13598,13600,13584,13585,13585,13587,13588,13589,13590,13591,13592,13593,13594,13595,13596,13653,13654';	

SET @TagIDs = '4,5,6,268,315,540,598,599';

SET @CategoryIDs = '2,3,4,15,17,22,23,24';

SET @ProjectIDs = '23,10';

SET @StringConstantsIDs = '1,2,3,4,5,6,16,17,18,19,20,21,22,23,24,31,32,33,34,35,36,37,38,41,43,10,11,12,13,14,40,42,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61';

SET @BlobConstantsIDs = '1,2,3,4,5,9';

SET @UserIDs = '89';


# Clean up the initial database
DELETE FROM PressGang.Topic;

DELETE FROM PressGang.Topic_AUD;

DELETE FROM PressGang.Tag;

DELETE FROM PressGang.Tag_AUD;

DELETE FROM PressGang.TopicToTag;

DELETE FROM PressGang.TopicToTag_AUD;

DELETE FROM PressGang.Category;

DELETE FROM PressGang.Category_AUD;

DELETE FROM PressGang.PropertyTag;

DELETE FROM PressGang.PropertyTag_AUD;

DELETE FROM PressGang.PropertyTagCategory;

DELETE FROM PressGang.PropertyTagCategory_AUD;

DELETE FROM PressGang.PropertyTagToPropertyTagCategory;

DELETE FROM PressGang.PropertyTagToPropertyTagCategory_AUD;

DELETE FROM PressGang.TopicToPropertyTag;

DELETE FROM PressGang.TopicToPropertyTag_AUD;

DELETE FROM PressGang.TagToPropertyTag;

DELETE FROM PressGang.TagToPropertyTag_AUD;

DELETE FROM PressGang.TagToCategory;

DELETE FROM PressGang.TagToCategory_AUD;

DELETE FROM PressGang.Project;

DELETE FROM PressGang.Project_AUD;

DELETE FROM PressGang.TagToProject;

DELETE FROM PressGang.TagToProject_AUD;

DELETE FROM PressGang.StringConstants;

DELETE FROM PressGang.StringConstants_AUD;

DELETE FROM PressGang.BlobConstants;

DELETE FROM PressGang.BlobConstants_AUD;

DELETE FROM PressGang.ImageFile;

DELETE FROM PressGang.ImageFile_AUD;

DELETE FROM PressGang.LanguageImage;

DELETE FROM PressGang.LanguageImage_AUD;

DELETE FROM PressGang.User;

DELETE FROM PressGang.User_AUD;

DELETE FROM PressGang.TopicSecondOrderData;

DELETE FROM PressGang.TopicSecondOrderData_AUD;

DELETE FROM PressGang.REVINFO;

DELETE FROM PressGang.DATABASECHANGELOG;

DELETE FROM PressGang.DATABASECHANGELOGLOCK;


# Copy the contents of the live database
INSERT INTO `PressGang`.`DATABASECHANGELOG`

(`ID`,

`AUTHOR`,

`FILENAME`,

`DATEEXECUTED`,

`ORDEREXECUTED`,

`EXECTYPE`,

`MD5SUM`,

`DESCRIPTION`,

`COMMENTS`,

`TAG`,

`LIQUIBASE`)

(

    SELECT `ID`,

    `AUTHOR`,

    `FILENAME`,

    `DATEEXECUTED`,

    `ORDEREXECUTED`,

    `EXECTYPE`,

    `MD5SUM`,

    `DESCRIPTION`,

    `COMMENTS`,

    `TAG`,

    `LIQUIBASE`

    FROM Skynet.DATABASECHANGELOG

);




INSERT INTO `PressGang`.`DATABASECHANGELOGLOCK`

(`ID`,

`LOCKED`,

`LOCKGRANTED`,

`LOCKEDBY`)

(

    SELECT `ID`,

    `LOCKED`,

    `LOCKGRANTED`,

    `LOCKEDBY`

    FROM Skynet.DATABASECHANGELOGLOCK

);



INSERT INTO PressGang.REVINFO

(REV,

REVTSTMP,

Flag,

Message,

UserName)

VALUES

(

1,

1357081200000,	# 1/1/2013 00:00:00 GMT

2,				# Major change

"Initial Topic Creation",

89				# Unknown User

);

INSERT INTO `PressGang`.`User`
(`UserID`,
`UserName`,
`Description`)
(
    SELECT 
    `UserID`,
    `UserName`,
    `Description`
    FROM Skynet.User
    WHERE FIND_IN_SET(UserID, @UserIDs)
);

INSERT INTO `PressGang`.`User_AUD`
(`UserID`,
`REV`,
`REVTYPE`,
`Description`,
`UserName`)
(
    SELECT 
    `UserID`,
    1,
    0,
    `UserName`,
    `Description`
    FROM Skynet.User
    WHERE FIND_IN_SET(UserID, @UserIDs)
);
 

INSERT INTO PressGang.Topic (TopicID, TopicTitle, TopicText, TopicTimeStamp, TopicXML, TopicLocale, TopicXMLDoctype) 

(

	SELECT TopicID, TopicTitle, TopicText, MAKEDATE(2013, 1), TopicXML, TopicLocale, TopicXMLDoctype

	FROM Skynet.Topic

	WHERE FIND_IN_SET(TopicID, @TopicIDs)
    
    OR EXISTS (SELECT 1 FROM Skynet.TopicToTag WHERE TagID = @PressGangTag AND Topic.TopicID = TopicToTag.TopicID)

);

 

INSERT INTO PressGang.Topic_AUD (TopicID, REV, REVTYPE, TopicTitle, TopicText, TopicTimeStamp, TopicXML, TopicLocale, TopicXMLDoctype)

(

	SELECT TopicID, 1, 0, TopicTitle, TopicText, MAKEDATE(2013, 1), TopicXML, TopicLocale, TopicXMLDoctype

	FROM Skynet.Topic

	WHERE FIND_IN_SET(TopicID, @TopicIDs)

    OR EXISTS (SELECT 1 FROM Skynet.TopicToTag WHERE TagID = @PressGangTag AND Topic.TopicID = TopicToTag.TopicID)

);



INSERT INTO PressGang.Tag

(TagID,

TagName,

TagDescription) 

(

    SELECT TagID, TagName, TagDescription

    FROM Skynet.Tag

    WHERE FIND_IN_SET(TagID, @TagIDs)

);



INSERT INTO PressGang.Tag_AUD

(TagID,

REV,

REVTYPE,

TagDescription,

TagName)

(

    SELECT TagID, 1, 0, TagName, TagDescription

    FROM Skynet.Tag

    WHERE FIND_IN_SET(TagID, @TagIDs)

);



INSERT INTO `PressGang`.`TopicToTag`

(`TopicToTagID`,

`TopicID`,

`TagID`)

(

    SELECT TopicToTagID, TopicID, TagID

    FROM Skynet.TopicToTag

    WHERE (FIND_IN_SET(TagID, @TagIDs)

    OR TagID = @PressGangTag)

    AND FIND_IN_SET(TopicID, @TopicIDs)

);



INSERT INTO `PressGang`.`TopicToTag_AUD`

(`TopicToTagID`,

`REV`,

`REVTYPE`,

`TagID`,

`TopicID`)



(

    SELECT TopicToTagID, 1, 0, TopicID, TagID

    FROM Skynet.TopicToTag

    WHERE (FIND_IN_SET(TagID, @TagIDs)

    OR TagID = @PressGangTag)

    AND FIND_IN_SET(TopicID, @TopicIDs)

);

INSERT INTO PressGang.Category

(CategoryID,

CategoryName,

CategoryDescription,

CategorySort,

MutuallyExclusive)

(

    SELECT CategoryID, CategoryName, CategoryDescription, CategorySort, MutuallyExclusive

    FROM Skynet.Category

    WHERE FIND_IN_SET(CategoryID, @CategoryIDs)

);

INSERT INTO PressGang.Category_AUD

(CategoryID,

REV,

REVTYPE,

CategoryDescription,

CategoryName,

CategorySort,

MutuallyExclusive)

(

    SELECT CategoryID, 1, 0, CategoryName, CategoryDescription, CategorySort, MutuallyExclusive

    FROM Skynet.Category

    WHERE FIND_IN_SET(CategoryID, @CategoryIDs)

);

INSERT INTO PressGang.TagToCategory

(TagToCategoryID,

TagID,

CategoryID,

Sorting)

(

    SELECT TagToCategoryID, TagID, CategoryID, Sorting

    FROM Skynet.TagToCategory

    WHERE FIND_IN_SET(TagID, @TagIDs)

    AND FIND_IN_SET(CategoryID, @CategoryIDs)

);

INSERT INTO PressGang.TagToCategory_AUD

(TagToCategoryID,

REV,

REVTYPE,

Sorting,

CategoryID,

TagID)

(

    SELECT TagToCategoryID, 1, 0, TagID, CategoryID, Sorting

    FROM Skynet.TagToCategory

    WHERE FIND_IN_SET(TagID, @TagIDs)

    AND FIND_IN_SET(CategoryID, @CategoryIDs)

);

INSERT INTO PressGang.Project

(ProjectID,

ProjectName,

ProjectDescription)

(

    SELECT ProjectID, ProjectName, ProjectDescription

    FROM Skynet.Project

    WHERE FIND_IN_SET(ProjectID, @ProjectIDs)

);

INSERT INTO PressGang.Project_AUD

(ProjectID,

REV,

REVTYPE,

ProjectName,

ProjectDescription)

(

    SELECT ProjectID, 1, 0, ProjectName, ProjectDescription

    FROM Skynet.Project

    WHERE FIND_IN_SET(ProjectID, @ProjectIDs)

);

INSERT INTO PressGang.TagToProject

(TagToProjectID,

ProjectID,

TagID)

(

    SELECT TagToProjectID, ProjectID, TagID

    FROM Skynet.TagToProject

    WHERE FIND_IN_SET(ProjectID, @ProjectIDs)

    AND FIND_IN_SET(TagID, @TagIDs)

);

INSERT INTO PressGang.TagToProject_AUD

(TagToProjectID,

REV,

REVTYPE,

ProjectID,

TagID)

(

    SELECT TagToProjectID, 1, 0, ProjectID, TagID

    FROM Skynet.TagToProject

    WHERE FIND_IN_SET(ProjectID, @ProjectIDs)

    AND FIND_IN_SET(TagID, @TagIDs)

);



INSERT INTO PressGang.StringConstants

(StringConstantsID,

ConstantName,

ConstantValue)

(

    SELECT StringConstantsID, ConstantName, ConstantValue

    FROM Skynet.StringConstants

    WHERE FIND_IN_SET(StringConstantsID, @StringConstantsIDs)

);



INSERT INTO PressGang.StringConstants_AUD

(StringConstantsID,

REV,

REVTYPE,

ConstantName,

ConstantValue)

(

    SELECT StringConstantsID, 1, 0, ConstantName, ConstantValue

    FROM Skynet.StringConstants

    WHERE FIND_IN_SET(StringConstantsID, @StringConstantsIDs)

);



INSERT INTO PressGang.BlobConstants

(BlobConstantsID, ConstantName, ConstantValue)

(

    SELECT BlobConstantsID, ConstantName, ConstantValue

    FROM Skynet.BlobConstants

    WHERE FIND_IN_SET(BlobConstantsID, @BlobConstantsIDs)

);



INSERT INTO PressGang.BlobConstants_AUD

(BlobConstantsID, REV, REVTYPE, ConstantName, ConstantValue)

(

    SELECT BlobConstantsID, 1, 0, ConstantName, ConstantValue

    FROM Skynet.BlobConstants

    WHERE FIND_IN_SET(BlobConstantsID, @BlobConstantsIDs)

);



INSERT INTO PressGang.ImageFile

(ImageFileID, Description)

(

    SELECT ImageFileID, Description

    FROM Skynet.ImageFile

    WHERE EXISTS (SELECT * FROM PressGang.Topic WHERE TopicXML LIKE CONCAT('%images/', ImageFileID, '.png%'))

);



INSERT INTO PressGang.ImageFile_AUD

(ImageFileID,

REV,

REVTYPE,

Description)

(

    SELECT ImageFileID, 1, 0, Description

    FROM Skynet.ImageFile

    WHERE EXISTS (SELECT * FROM PressGang.Topic WHERE TopicXML LIKE CONCAT('%images/', ImageFileID, '.png%'))

);



INSERT INTO PressGang.LanguageImage

(LanguageImageID,

ImageFileID,

ThumbnailData,

ImageDataBase64,

Locale,

OriginalFileName,

ImageData)

(

    SELECT `LanguageImageID`, `ImageFileID`, `ThumbnailData`, `ImageDataBase64`, `Locale`, `OriginalFileName`, `ImageData`

    FROM Skynet.LanguageImage

    WHERE ImageFileID IN (SELECT ImageFileID FROM PressGang.ImageFile)

);



INSERT INTO PressGang.LanguageImage_AUD

(`LanguageImageID`,

`REV`,

`REVTYPE`,

`ImageData`,

`ImageDataBase64`,

`Locale`,

`OriginalFileName`,

`ThumbnailData`,

`ImageFileID`)

(

    SELECT `LanguageImageID`, 1, 0, `ImageFileID`, `ThumbnailData`, `ImageDataBase64`, `Locale`, `OriginalFileName`, `ImageData`

    FROM Skynet.LanguageImage

    WHERE ImageFileID IN (SELECT ImageFileID FROM PressGang.ImageFile)

);



INSERT INTO `PressGang`.`PropertyTag`

(`PropertyTagID`,

`PropertyTagName`,

`PropertyTagDescription`,

`PropertyTagRegex`,

`PropertyTagCanBeNull`,

`PropertyTagIsUnique`)

(

    SELECT `PropertyTagID`,

    `PropertyTagName`,

    `PropertyTagDescription`,

    `PropertyTagRegex`,

    `PropertyTagCanBeNull`,

    `PropertyTagIsUnique`

    FROM Skynet.PropertyTag

);



INSERT INTO `PressGang`.`PropertyTag_AUD`

(`PropertyTagID`,

`REV`,

`REVTYPE`,

`PropertyTagCanBeNull`,

`PropertyTagDescription`,

`PropertyTagName`,

`PropertyTagRegex`,

`PropertyTagIsUnique`)

(

    SELECT `PropertyTagID`,

    1, 

    0,

    `PropertyTagName`,

    `PropertyTagDescription`,

    `PropertyTagRegex`,

    `PropertyTagCanBeNull`,

    `PropertyTagIsUnique`

    FROM Skynet.PropertyTag

);



INSERT INTO `PressGang`.`PropertyTagCategory`

(`PropertyTagCategoryID`,

`PropertyTagCategoryName`,

`PropertyTagCategoryDescription`)

(

    SELECT 

    `PropertyTagCategoryID`,

    `PropertyTagCategoryName`,

    `PropertyTagCategoryDescription`

    FROM Skynet.PropertyTagCategory

);



INSERT INTO `PressGang`.`PropertyTagCategory_AUD`

(`PropertyTagCategoryID`,

`REV`,

`REVTYPE`,

`PropertyTagCategoryDescription`,

`PropertyTagCategoryName`)

(

    SELECT 

    `PropertyTagCategoryID`,

    1,

    0,

    `PropertyTagCategoryName`,

    `PropertyTagCategoryDescription`

    FROM Skynet.PropertyTagCategory

);



INSERT INTO `PressGang`.`PropertyTagToPropertyTagCategory`

(`PropertyTagToPropertyTagCategoryID`,

`PropertyTagID`,

`PropertyTagCategoryID`,

`Sorting`)

(

    SELECT 

    `PropertyTagToPropertyTagCategoryID`,

    `PropertyTagID`,

    `PropertyTagCategoryID`,

    `Sorting`

    FROM Skynet.PropertyTagToPropertyTagCategory

);



INSERT INTO `PressGang`.`PropertyTagToPropertyTagCategory_AUD`

(`PropertyTagToPropertyTagCategoryID`,

`REV`,

`REVTYPE`,

`Sorting`,

`PropertyTagID`,

`PropertyTagCategoryID`)

(

    SELECT 

    `PropertyTagToPropertyTagCategoryID`,

    1,

    0,

    `PropertyTagID`,

    `PropertyTagCategoryID`,

    `Sorting`

    FROM Skynet.PropertyTagToPropertyTagCategory

);



INSERT INTO `PressGang`.`TopicToPropertyTag`

(`TopicToPropertyTagID`,

`TopicID`,

`PropertyTagID`,

`Value`)

(

    SELECT 

    `TopicToPropertyTagID`,

    `TopicID`,

    `PropertyTagID`,

    `Value`

    FROM Skynet.TopicToPropertyTag

    WHERE FIND_IN_SET(TopicID, @TopicIDs) 

);



INSERT INTO `PressGang`.`TopicToPropertyTag_AUD`

(`TopicToPropertyTagID`,

`REV`,

`REVTYPE`,

`Value`,

`PropertyTagID`,

`TopicID`)

(

    SELECT 

    `TopicToPropertyTagID`,

    1,

    0,

    `TopicID`,

    `PropertyTagID`,

    `Value`

    FROM Skynet.TopicToPropertyTag

    WHERE FIND_IN_SET(TopicID, @TopicIDs) 

);



INSERT INTO `PressGang`.`TagToPropertyTag`

(`TagToPropertyTagID`,

`TagID`,

`PropertyTagID`,

`Value`)

(

    SELECT `TagToPropertyTagID`,

    `TagID`,

    `PropertyTagID`,

    `Value`

    FROM Skynet.TagToPropertyTag

    WHERE FIND_IN_SET(TagID, @TagIDs) 

);



INSERT INTO `PressGang`.`TagToPropertyTag_AUD`

(`TagToPropertyTagID`,

`REV`,

`REVTYPE`,

`Value`,

`PropertyTagID`,

`TagID`)

(

    SELECT `TagToPropertyTagID`,

    1,

    0,

    `TagID`,    

    `PropertyTagID`,

    `Value`

    FROM Skynet.TagToPropertyTag

    WHERE FIND_IN_SET(TagID, @TagIDs)

);

# Any new records start at 100000
ALTER TABLE PressGang.PropertyTagCategory AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.PropertyTag AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.BlobConstants AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.StringConstants AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.Category AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.Project AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.ImageFile AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.LanguageImage AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.Topic AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.Tag AUTO_INCREMENT = 100000;
