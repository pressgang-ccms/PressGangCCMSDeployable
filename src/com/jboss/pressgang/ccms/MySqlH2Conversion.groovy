package com.jboss.pressgang.ccms
/**
 * @author kamiller@redhat.com (Katie Miller)
 */
class MySqlH2Conversion {
    def static indexId = 0
    def static indexes = []
    def static notIndexable = [] as Set
    def final static tableOrder = [
    	'DATABASECHANGELOGLOCK', 
    	'DATABASECHANGELOG', 
    	'REVINFO', 
    	'BugzillaBug', 
    	'BugzillaBug_AUD', 
    	'IntegerConstants', 
    	'IntegerConstants_AUD',
    	'RelationshipTag',
    	'RelationshipTag_AUD',
    	'Role',
    	'RoleToRole',
    	'RoleToRoleRelationship',
    	'RoleToRoleRelationship_AUD',
    	'RoleToRole_AUD',
    	'Role_AUD',
    	'File',
    	'File_AUD',
    	'LanguageFile',
    	'LanguageFile_AUD',
    	'StringConstants',
    	'StringConstants_AUD',
    	'BlobConstants',
    	'BlobConstants_AUD',
    	'ImageFile',
    	'ImageFile_AUD',
    	'LanguageImage',
    	'LanguageImage_AUD',
    	'Topic',
    	'Topic_AUD',
    	'Tag',
    	'Tag_AUD',
    	'Category',
    	'Category_AUD',
    	'PropertyTag',
    	'PropertyTag_AUD',
    	'PropertyTagCategory',
			'PropertyTagCategory_AUD', 
			'Project', 
			'Project_AUD', 
			'User', 
			'User_AUD', 
			'ContentSpec', 
			'ContentSpec_AUD', 
			'ContentSpecNode', 
			'ContentSpecNode_AUD', 
			'TranslatedContentSpec', 
			'TranslatedContentSpec_AUD',
			'TopicToTag', 
			'TopicToTag_AUD', 
			'PropertyTagToPropertyTagCategory', 
			'PropertyTagToPropertyTagCategory_AUD', 
			'TopicToPropertyTag', 
			'TopicToPropertyTag_AUD', 
			'TagToPropertyTag', 
			'TagToPropertyTag_AUD',
			'TagToCategory', 
			'TagToCategory_AUD', 
			'TagToProject', 
			'TagToProject_AUD', 
			'CSNodeToCSNode', 
			'CSNodeToCSNode_AUD', 
			'CSNodeToPropertyTag', 
			'CSNodeToPropertyTag_AUD', 
			'ContentSpecToPropertyTag',
			'ContentSpecToPropertyTag_AUD', 
			'ContentSpecToTag', 
			'ContentSpecToTag_AUD', 
			'TranslatedCSNode', 
			'TranslatedCSNode_AUD', 
			'TranslatedCSNodeString', 
			'TranslatedCSNodeString_AUD', 
			'TopicSecondOrderData',
			'TopicSecondOrderData_AUD', 
			'Filter', 
			'Filter_AUD', 
			'FilterCategory', 
			'FilterCategory_AUD', 
			'FilterField', 
			'FilterField_AUD', 
			'FilterLocale', 
			'FilterLocale_AUD', 
			'FilterOption', 
			'FilterOption_AUD', 
			'FilterTag', 
			'FilterTag_AUD', 
			'TagExclusion', 
			'TagExclusion_AUD', 
			'TagToTag', 
			'TagToTagRelationship', 
			'TagToTagRelationship_AUD', 
			'TagToTag_AUD', 
			'TopicSourceURL', 
			'TopicSourceURL_AUD', 
			'TopicToBugzillaBug', 
			'TopicToBugzillaBug_AUD', 
			'TopicToTopic', 
			'TopicToTopicSecondOrderData', 
			'TopicToTopicSourceURL', 
			'TopicToTopicSourceURL_AUD', 
			'TopicToTopic_AUD', 
			'TranslatedTopic', 
			'TranslatedTopicData', 
			'TranslatedTopicData_AUD', 
			'TranslatedTopicString', 
			'TranslatedTopicString_AUD', 
			'TranslatedTopic_AUD', 
			'UserRole', 
			'UserRole_AUD'];

    static void main(String[] args) {
        if (args.size() < 1 || args[0] == null) {
            println("Error: please supply filepath of SQL file to process")
            System.exit(1);
        }
        def (inputFile, resultFile, tempFile) = [args[0], new File("result.sql"), new File("temp.sql")]
        resultFile.createNewFile()
        tempFile.createNewFile()
        def tableMap = [:]
        def processingTable = false
        def lastLineEmpty = false
        def tableName = ""

        new File(inputFile).eachLine { line ->
            if (processingTable && isTableEnd(line)) {
                processingTable = false
            } else if (isComment(line)) {
                // Do nothing
            } else if (line.isEmpty() && !processingTable) {
                if (!lastLineEmpty) tempFile.append("\n")
            } else if (!getTableName(line).isEmpty()) {
                processingTable = true;
                tableName = getTableName(line)
                tableMap.put(tableName, line + "\n")
            } else {
                def newLine = process(line, processingTable)
                processingTable ? updateTableMap(tableMap, tableName, newLine) : tempFile.append(newLine + "\n")
            }
            if (!processingTable && !isComment(line)) lastLineEmpty = line.isEmpty()
            return
        }
        if (!tableMap.isEmpty()) {
            def sortedTables = tableMap.sort { a, b -> getIndex(tableOrder, a.key) <=> getIndex(tableOrder, b.key) }
            for (String table : sortedTables.keySet()) {
                resultFile.append(tableMap.get(table) + "\n\n")
            }
        }
        resultFile.append(tempFile.getBytes())
        tempFile.delete()
    }

    def static getIndex(list, key) {
        list.indexOf(key) == -1 ? list.size() : list.indexOf(key)
    }

    def static getTableName(String line) {
        def tableName = line.find(~"CREATE TABLE \\\"([A-Za-z_]+)\\\"", { match, name -> return name })
        tableName ?: ""
    }

    def static isTableEnd(line) {
        line.matches(~"\\/\\*!40101 SET character_set_client \\= \\@saved_cs_client \\*\\/;")
    }

    def static updateTableMap(map, name, line) {
        map.put(name, map.get(name) + line + "\n")
    }

    def static isComment(line) {
        line.startsWith("--") || line.startsWith("/*")
    }

    def static process(String line, boolean processingTable) {
        def result = changeBitRepresentation(convertHexNumbers(changeSingleQuoteEscaping(line)))
        processingTable ? processIndexes(removeCharacterSets(removeKeyRanges(result))) : result
    }

    def static changeSingleQuoteEscaping(String line) {
        line.replaceAll(~"\\\\\\'", "''")
    }

    def static convertHexNumbers(String line) {
        line.replaceAll(~"0x([A-Fa-f0-9]+)", { match, num -> "'$num'" })
    }

    def static changeBitRepresentation(String line) {
        line.replaceAll(~"b'0'", "0")
    }

    def static removeKeyRanges(String line) {
        (line ==~ /\s*(UNIQUE )?(KEY|INDEX).*\((("\w+"(\([0-9]+\))?,?)+)\).*/) ? line.replaceAll(/\([0-9]+\)/, "") : line
    }

    def static removeCharacterSets(String line) {
        line.replaceFirst(/ CHARACTER SET \w+\b/, "")
    }

    def static processIndexes(String line) {
        // Add to nonIndexable list if type is a blob or text field
        def blobTextPattern = ~/\s*"(\w+)" (blob|tinyblob|mediumblob|longblob|text|tinytext|mediumtext|longtext)\b.*/
        if (line.matches(blobTextPattern)) {
            notIndexable.add(line.find(blobTextPattern) { match, name, type -> name })
            return line
        }
        def indexPattern = ~/\s*(UNIQUE )?(KEY|INDEX) "(\w+)" \((("\w+",?)+)\).*/
        if (line ==~ indexPattern) {
            // Remove line if index is for a blob or text field
            def keyFields = []
            def keyFieldsString = line.find(indexPattern) { match, unique, index, name, fields, field -> return fields }
            keyFields.addAll(keyFieldsString.split(','))
            keyFields = keyFields.collectAll { keyField -> keyField.substring(1, keyField.length() - 1) }
            for (String keyField : keyFields) {
                if (notIndexable.contains(keyField)) return ""
            }
            // Ensure index name is unique within the database
            def thisIndex = line.find(indexPattern) { match, unique, index, name, fields, field -> return name }
            def newIndex = thisIndex
            while (indexes.contains(newIndex)) {
                newIndex = thisIndex + indexId++
            }
            if (! newIndex.equals(thisIndex)) {
                line = line.replaceFirst(thisIndex, newIndex)
            }
            indexes.add(newIndex)
        }
        line
    }

    //TODO reorder data imports to avoid referential integrity errors
}
