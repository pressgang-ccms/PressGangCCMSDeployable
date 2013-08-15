# Create the initial database schema
# CREATE SCHEMA PressGang;

# Dump the table structure from the live database into the initial database
# mysqldump -uroot -ppassword --no-data Skynet | mysql -ppassword -uroot -A -DPressGang

# The IDs of the database records that will be part of the initial database
SET @PressGangTag = 540;

SET @ContentSpecIDs = '13968';

SET @TagIDs = '4,5,6,268,315,540,598,599';

SET @CategoryIDs = '2,3,4,15,17,22,23,24';

SET @ProjectIDs = '23,10';

SET @StringConstantsIDs = '1,2,3,4,5,6,15,16,17,18,19,20,21,22,23,24,31,32,33,34,35,36,37,38,41,43,10,11,12,13,14,40,42,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61';

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

#DELETE FROM PressGang.TopicSecondOrderData_AUD;

DELETE FROM PressGang.CSNodeToCSNode;

DELETE FROM PressGang.CSNodeToCSNode_AUD;

DELETE FROM PressGang.CSNodeToPropertyTag;

DELETE FROM PressGang.CSNodeToPropertyTag_AUD;

DELETE FROM PressGang.ContentSpec;

DELETE FROM PressGang.ContentSpec_AUD;

DELETE FROM PressGang.ContentSpecNode;

DELETE FROM PressGang.ContentSpecNode_AUD;

DELETE FROM PressGang.ContentSpecToPropertyTag;

DELETE FROM PressGang.ContentSpecToPropertyTag_AUD;

DELETE FROM PressGang.ContentSpecToTag;

DELETE FROM PressGang.ContentSpecToTag_AUD;

DELETE FROM PressGang.TranslatedCSNode;

DELETE FROM PressGang.TranslatedCSNode_AUD;

DELETE FROM PressGang.TranslatedCSNodeString;

DELETE FROM PressGang.TranslatedCSNodeString_AUD;

DELETE FROM PressGang.TranslatedContentSpec;

DELETE FROM PressGang.TranslatedContentSpec_AUD;

DELETE FROM PressGang.File;

DELETE FROM PressGang.File_AUD;

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
    SELECT `UserID`, `UserName`, `Description`
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
    SELECT `UserID`,
    1,
    0,
    `Description`,
    `UserName`
    FROM PressGang.User
);
 
# Insert all topics that have been tagged with @PressGangTag
INSERT INTO PressGang.Topic (TopicID, TopicTitle, TopicText, TopicTimeStamp, TopicXML, TopicLocale, TopicXMLDoctype) 

(

	SELECT TopicID, TopicTitle, TopicText, MAKEDATE(2013, 1), TopicXML, TopicLocale, TopicXMLDoctype

	FROM Skynet.Topic

	WHERE EXISTS (SELECT 1 FROM Skynet.TopicToTag WHERE TagID = @PressGangTag AND Topic.TopicID = TopicToTag.TopicID)

);

 

INSERT INTO PressGang.Topic_AUD (TopicID, REV, REVTYPE, TopicTitle, TopicText, TopicTimeStamp, TopicXML, TopicLocale, TopicXMLDoctype)

(

	SELECT TopicID, 1, 0, TopicTitle, TopicText, MAKEDATE(2013, 1), TopicXML, TopicLocale, TopicXMLDoctype

	FROM PressGang.Topic

);



INSERT INTO PressGang.Tag

(TagID,

TagName,

TagDescription) 

(

    SELECT TagID, TagName, TagDescription

    FROM Skynet.Tag

    WHERE FIND_IN_SET(TagID, @TagIDs)
    
    OR TagID IN (SELECT TagID FROM Skynet.ContentSpecToTag)

);



INSERT INTO PressGang.Tag_AUD

(TagID,

REV,

REVTYPE,

TagDescription,

TagName)

(

    SELECT TagID,

    1,

    0,

    TagDescription,

    TagName

    FROM PressGang.Tag

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

    AND EXISTS (SELECT 1 FROM PressGang.Topic WHERE PressGang.Topic.TopicID = Skynet.TopicToTag.TopicID)

);



INSERT INTO `PressGang`.`TopicToTag_AUD`

(`TopicToTagID`,

`REV`,

`REVTYPE`,

`TagID`,

`TopicID`)
(

    SELECT TopicToTagID, 1, 0, TagID, TopicID

    FROM PressGang.TopicToTag
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

    SELECT CategoryID,

    1,

    0,

    CategoryDescription,

    CategoryName,

    CategorySort,

    MutuallyExclusive

    FROM PressGang.Category

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

    SELECT TagToCategoryID,

    1,

    0,

    Sorting,

    CategoryID,

    TagID

    FROM PressGang.TagToCategory

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

    FROM PressGang.Project

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

    FROM PressGang.TagToProject

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

    FROM PressGang.StringConstants

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

    FROM PressGang.BlobConstants

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

    FROM PressGang.ImageFile

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

    SELECT `LanguageImageID`,

    1,

    0,

    `ImageData`,

    `ImageDataBase64`,

    `Locale`,

    `OriginalFileName`,

    `ThumbnailData`,

    `ImageFileID`

    FROM PressGang.LanguageImage

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

    `PropertyTagCanBeNull`,

    `PropertyTagDescription`,

    `PropertyTagName`,

    `PropertyTagRegex`,

    `PropertyTagIsUnique`

    FROM PressGang.PropertyTag

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

    SELECT `PropertyTagCategoryID`,

    1,

    0,

    `PropertyTagCategoryDescription`,

    `PropertyTagCategoryName`

    FROM PressGang.PropertyTagCategory

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

    SELECT `PropertyTagToPropertyTagCategoryID`,

    1,

    0,

    `Sorting`,

    `PropertyTagID`,

    `PropertyTagCategoryID`

    FROM PressGang.PropertyTagToPropertyTagCategory

);



INSERT INTO `PressGang`.`TopicToPropertyTag`

(`TopicToPropertyTagID`, `TopicID`, `PropertyTagID`, `Value`)

(

    SELECT `TopicToPropertyTagID`, `TopicID`, `PropertyTagID`, `Value`

    FROM Skynet.TopicToPropertyTag

    WHERE EXISTS (SELECT 1 FROM PressGang.Topic WHERE PressGang.Topic.TopicID = Skynet.TopicToPropertyTag.TopicID) 

);



INSERT INTO `PressGang`.`TopicToPropertyTag_AUD`

(`TopicToPropertyTagID`, `REV`, `REVTYPE`, `Value`, `PropertyTagID`, `TopicID`)

(

    SELECT `TopicToPropertyTagID`, 1, 0, `Value`, `PropertyTagID`, `TopicID`

    FROM PressGang.TopicToPropertyTag

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

    `Value`,

    `PropertyTagID`,

    `TagID`

    FROM PressGang.TagToPropertyTag

);

INSERT INTO `PressGang`.`ContentSpec`
(`ContentSpecID`,
`ContentSpecType`,
`LastPublished`,
`LastModified`,
`Locale`,
`GlobalCondition`,
`Errors`,
`FailedSpec`)

(
    SELECT `ContentSpecID`,
        `ContentSpecType`,
        `LastPublished`,
        `LastModified`,
        `Locale`,
        `GlobalCondition`,
        `Errors`,
        `FailedSpec`
    FROM Skynet.ContentSpec
    WHERE FIND_IN_SET(ContentSpecID, @ContentSpecIDs) 
);

INSERT INTO `PressGang`.`ContentSpec_AUD`
(`ContentSpecID`,
`REV`,
`REVTYPE`,
`ContentSpecType`,
`LastPublished`,
`LastModified`,
`Locale`,
`GlobalCondition`,
`Errors`,
`FailedSpec`)

(

   SELECT `ContentSpecID`,

    1,

    0,

    `ContentSpecType`,

    `LastPublished`,

    `LastModified`,
    
    `Locale`,
    
    `GlobalCondition`,
    
    `Errors`,
    
    `FailedSpec`

    FROM PressGang.ContentSpec
);

INSERT INTO `PressGang`.`ContentSpecNode`
(`ContentSpecNodeID`,
`NodeTitle`,
`NodeTargetID`,
`NodeType`,
`NodeCondition`,
`AdditionalText`,
`EntityID`,
`EntityRevision`,
`ContentSpecID`,
`ParentID`,
`NextNodeID`)

(

	SELECT `ContentSpecNodeID`,
		`NodeTitle`,
		`NodeTargetID`,
		`NodeType`,
		`NodeCondition`,
		`AdditionalText`,
		`EntityID`,
		`EntityRevision`,
		`ContentSpecID`,
		`ParentID`,
		`NextNodeID`
	FROM Skynet.ContentSpecNode
	WHERE FIND_IN_SET(ContentSpecID, @ContentSpecIDs)

);

INSERT INTO `PressGang`.`ContentSpecNode_AUD`
(`ContentSpecNodeID`,
`REV`,
`REVTYPE`,
`NodeTitle`,
`NodeTargetID`,
`NodeType`,
`NodeCondition`,
`AdditionalText`,
`EntityID`,
`EntityRevision`,
`ContentSpecID`,
`ParentID`,
`NextNodeID`)

(

	SELECT `ContentSpecNodeID`,
		1,
		0,
		`NodeTitle`,
		`NodeTargetID`,
		`NodeType`,
		`NodeCondition`,
		`AdditionalText`,
		`EntityID`,
		`EntityRevision`,
		`ContentSpecID`,
		`ParentID`,
		`NextNodeID`
	FROM PressGang.ContentSpecNode
);

INSERT INTO `PressGang`.`CSNodeToCSNode`
(`CSNodeToCSNodeID`,
`MainNodeID`,
`RelatedNodeID`,
`RelationshipType`,
`Sort`)

(
	SELECT `CSNodeToCSNodeID`,
		`MainNodeID`,
		`RelatedNodeID`,
		`RelationshipType`,
		`Sort`
	FROM Skynet.CSNodeToCSNode
	WHERE MainNodeID IN (SELECT ContentSpecNodeID FROM PressGang.ContentSpecNode)
	OR RelatedNodeID IN (SELECT ContentSpecNodeID FROM PressGang.ContentSpecNode)
);

INSERT INTO `PressGang`.`CSNodeToCSNode_AUD`
(`CSNodeToCSNodeID`,
`REV`,
`REVTYPE`,
`MainNodeID`,
`RelatedNodeID`,
`RelationshipType`,
`Sort`)

(

	SELECT `CSNodeToCSNodeID`,
		1,
		0,
		`MainNodeID`,
		`RelatedNodeID`,
		`RelationshipType`,
		`Sort`
	FROM PressGang.CSNodeToCSNode
);

INSERT INTO `PressGang`.`CSNodeToPropertyTag`
(`CSNodeToPropertyTagID`,
`CSNodeID`,
`PropertyTagID`,
`Value`)

(
	SELECT `CSNodeToPropertyTagID`,
		`CSNodeID`,
		`PropertyTagID`,
		`Value`
	FROM Skynet.CSNodeToPropertyTag
	WHERE CSNodeID IN (SELECT ContentSpecNodeID FROM PressGang.ContentSpecNode) 
);

INSERT INTO `PressGang`.`CSNodeToPropertyTag_AUD`
(`CSNodeToPropertyTagID`,
`REV`,
`REVTYPE`,
`CSNodeID`,
`PropertyTagID`,
`Value`)

(
	SELECT `CSNodeToPropertyTagID`,
		1,
		0,
		`CSNodeID`,
		`PropertyTagID`,
		`Value`
	FROM PressGang.CSNodeToPropertyTag
);

INSERT INTO `PressGang`.`ContentSpecToPropertyTag`
(`ContentSpecToPropertyTagID`,
`ContentSpecID`,
`PropertyTagID`,
`Value`)

(
	SELECT `ContentSpecToPropertyTagID`,
		`ContentSpecID`,
		`PropertyTagID`,
		`Value`
	FROM Skynet.ContentSpecToPropertyTag
	WHERE ContentSpecID IN (SELECT ContentSpecID FROM PressGang.ContentSpec) 
);

INSERT INTO `PressGang`.`ContentSpecToPropertyTag_AUD`
(`ContentSpecToPropertyTagID`,
`REV`,
`REVTYPE`,
`ContentSpecID`,
`PropertyTagID`,
`Value`)

(
	SELECT `ContentSpecToPropertyTagID`,
		1,
		0,
		`ContentSpecID`,
		`PropertyTagID`,
		`Value`
	FROM PressGang.ContentSpecToPropertyTag
);

INSERT INTO `PressGang`.`ContentSpecToTag`
(`ContentSpecToTagID`,
`ContentSpecID`,
`TagID`,
`BookTag`)

(
	SELECT `ContentSpecToTagID`,
		`ContentSpecID`,
		`TagID`,
		`BookTag`
	FROM Skynet.ContentSpecToTag
	WHERE ContentSpecID IN (SELECT ContentSpecID FROM PressGang.ContentSpec) 
);

INSERT INTO `PressGang`.`ContentSpecToTag_AUD`
(`ContentSpecToTagID`,
`REV`,
`REVTYPE`,
`ContentSpecID`,
`TagID`,
`BookTag`)

(
	SELECT `ContentSpecToTagID`,
		1,
		0,
		`ContentSpecID`,
		`TagID`,
		`BookTag`
	FROM PressGang.ContentSpecToTag
);

#PressGang.TranslatedContentSpec;
#PressGang.TranslatedContentSpec_AUD;
#PressGang.TranslatedCSNode;
#PressGang.TranslatedCSNode_AUD;
#PressGang.TranslatedCSNodeString;
#PressGang.TranslatedCSNodeString_AUD;

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

ALTER TABLE PressGang.REVINFO AUTO_INCREMENT = 100000;

ALTER TABLE PressGang.ContentSpec AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpec_AUD AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpecNode AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpecNode_AUD AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.CSNodeToCSNode AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.CSNodeToCSNode_AUD AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.CSNodeToPropertyTag AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.CSNodeToPropertyTag_AUD AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpecToPropertyTag AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpecToPropertyTag_AUD AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpecToTag AUTO_INCREMENT = 100000;;

ALTER TABLE PressGang.ContentSpecToTag_AUD AUTO_INCREMENT = 100000;;
