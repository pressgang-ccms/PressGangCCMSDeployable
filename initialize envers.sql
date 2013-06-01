INSERT INTO REVINFO 
VALUES (1, UNIX_TIMESTAMP());

INSERT INTO BlobConstants_AUD
SELECT BlobConstantsID, 1, 0, NULL, ConstantName, ConstantValue
FROM BlobConstants;

INSERT INTO BugzillaBug_AUD
SELECT BugzillaBugID, 1, 0, NULL, BugzillaBugBugzillaID, BugzillaBugOpen, BugzillaBugSummary
FROM BugzillaBug;

INSERT INTO Category_AUD
SELECT CategoryID, 1, 0, NULL, CategoryDescription, CategoryName, CategorySort, MutuallyExclusive
FROM Category;

INSERT INTO FilterCategory_AUD
SELECT FilterCategoryID, 1, 0, NULL, CategoryState, CategoryID, FilterID, ProjectID
FROM FilterCategory;

INSERT INTO FilterField_AUD
SELECT FilterFieldID, 1, 0, NULL, Description, Field, Value, FilterID
FROM FilterField;

INSERT INTO FilterLocale_AUD
SELECT FilterLocaleID, 1, 0, NULL, LocaleName, LocaleState, FilterID
FROM FilterLocale;

INSERT INTO FilterOption_AUD
SELECT FilterOptionID, 1, 0, NULL, FilterOptionName, FilterOptionValue, FilterID
FROM FilterOption;

INSERT INTO FilterTag_AUD
SELECT FilterTagID, 1, 0, NULL, TagState, FilterID, TagID
FROM FilterTag;

INSERT INTO Filter_AUD
SELECT FilterID, 1, 0, NULL, FilterDescription, FilterName
FROM Filter;

INSERT INTO Help_AUD
SELECT HelpID, 1, 0, NULL, HelpText, TableColID
FROM Help;

INSERT INTO ImageFile_AUD
SELECT ImageFileID, 1, 0, NULL, Description
FROM ImageFile;

INSERT INTO IntegerConstants_AUD
SELECT IntegerConstantsID, 1, 0, NULL, ConstantName, ConstantValue
FROM IntegerConstants;

INSERT INTO LanguageImage_AUD
SELECT LanguageImageID, 1, 0, NULL, ImageData, ImageDataBase64, Locale, OriginalFileName, ThumbnailData, ImageFileID
FROM LanguageImage;

INSERT INTO Project_AUD
SELECT ProjectID, 1, 0, NULL, ProjectDescription, ProjectName
FROM Project;

INSERT INTO PropertyTagCategory_AUD
SELECT PropertyTagCategoryID, 1, 0, NULL, PropertyTagCategoryDescription, PropertyTagCategoryName
FROM PropertyTagCategory;

INSERT INTO PropertyTagToPropertyTagCategory_AUD
SELECT PropertyTagToPropertyTagCategoryID, 1, 0, NULL, Sorting, PropertyTagID, PropertyTagCategoryID
FROM PropertyTagToPropertyTagCategory;

INSERT INTO PropertyTag_AUD
SELECT PropertyTagID, 1, 0, NULL, PropertyTagCanBeNull, PropertyTagDescription, PropertyTagIsUnqiue, PropertyTagName, PropertyTagRegex
FROM PropertyTag;

INSERT INTO RelationshipTag_AUD
SELECT RelationshipTagId, 1, 0, NULL, RelationshipTagDescription, RelationshipTagName
FROM RelationshipTag;

INSERT INTO RoleToRoleRelationship_AUD
SELECT RoleToRoleRelationshipID, 1, 0, NULL, Description
FROM RoleToRoleRelationship;

INSERT INTO RoleToRole_AUD
SELECT RoleToRoleID, 1, 0, NULL, PrimaryRole, RelationshipType, SecondaryRole
FROM RoleToRole;

INSERT INTO Role_AUD
SELECT RoleID, 1, 0, NULL, Description, RoleName
FROM Role;

INSERT INTO StringConstants_AUD
SELECT StringConstantsID, 1, 0, NULL, ConstantName, ConstantValue
FROM  StringConstants;

INSERT INTO TagExclusion_AUD
SELECT 1, Tag1ID, Tag2ID, 0, NULL
FROM  TagExclusion;

INSERT INTO TagToCategory_AUD
SELECT TagToCategoryID, 1, 0, NULL, Sorting, CategoryID, TagID
FROM  TagToCategory;

INSERT INTO TagToProject_AUD
SELECT TagToProjectID, 1, 0, NULL, ProjectID, TagID
FROM  TagToProject;

INSERT INTO TagToPropertyTag_AUD
SELECT TagToPropertyTagID, 1, 0, NULL, Value, PropertyTagID, TagID
FROM  TagToPropertyTag;

INSERT INTO TagToTagRelationship_AUD
SELECT TagToTagRelationshipType, 1, 0, NULL, TagToTagRelationshipDescription
FROM  TagToTagRelationship;

INSERT INTO TagToTag_AUD
SELECT TagToTagID, 1, 0, NULL, PrimaryTagID, SecondaryTagID, RelationshipType
FROM  TagToTag;

INSERT INTO Tag_AUD
SELECT TagID, 1, 0, NULL, TagDescription, TagName
FROM Tag;

INSERT INTO TopicSecondOrderData_AUD
SELECT TopicSecondOrderDataID, 1, 0, NULL, TopicHTMLView, TopicXMLErrors
FROM TopicSecondOrderData;

INSERT INTO TopicSourceURL_AUD
SELECT TopicSourceURLID, 1, 0, NULL, Description, SourceURL, Title
FROM TopicSourceURL;

INSERT INTO TopicToBugzillaBug_AUD
SELECT TopicToBugzillaBugID, 1, 0, NULL, BugzillaBugID, TopicID
FROM TopicToBugzillaBug;

INSERT INTO TopicToPropertyTag_AUD
SELECT TopicToPropertyTagID, 1, 0, NULL, Value, PropertyTagID, TopicID
FROM TopicToPropertyTag;

INSERT INTO TopicToTag_AUD
SELECT TopicToTagID, 1, 0, NULL, TagID, TopicID
FROM TopicToTag;

INSERT INTO TopicToTopicSourceURL_AUD
SELECT TopicToTopicSourceURLID, 1, 0, NULL, TopicID, TopicSourceURLID
FROM TopicToTopicSourceURL;

INSERT INTO TopicToTopic_AUD
SELECT TopicToTopicID, 1, 0, NULL, MainTopicID, RelatedTopicID, RelationshipTagID
FROM TopicToTopic;

INSERT INTO Topic_AUD
SELECT TopicID, 1, 0, NULL, TopicLocale, TopicText, TopicTimeStamp, TopicTitle, TopicXML
FROM Topic;

INSERT INTO TranslatedTopicData_AUD
SELECT TranslatedTopicDataID, 1, 0, NULL, TranslatedXML, TranslatedXMLErrors, TranslatedXMLRendered, TranslatedXMLRenderedUpdated, TranslationLocale, TranslationPercentage, TranslatedTopicID
FROM TranslatedTopicData;

INSERT INTO TranslatedTopicString_AUD
SELECT TranslatedTopicStringID, 1, 0, NULL, OriginalString, TranslatedString, TranslatedTopicDataID
FROM TranslatedTopicString;

INSERT INTO TranslatedTopic_AUD
SELECT TranslatedTopicID, 1, 0, NULL, TopicID, TopicRevision
FROM TranslatedTopic;

INSERT INTO UserRole_AUD
SELECT UserRoleID, 1, 0, NULL, RoleNameID, UserNameID
FROM UserRole;

INSERT INTO User_AUD
SELECT UserID, 1, 0, NULL, Description, UserName
FROM User;


