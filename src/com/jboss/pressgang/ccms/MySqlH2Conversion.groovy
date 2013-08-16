package com.jboss.pressgang.ccms
/**
 * @author kamiller@redhat.com (Katie Miller)
 */
class MySqlH2Conversion {
    def static indexId = 0
    def final static tableOrder = ['DATABASECHANGELOGLOCK', 'DATABASECHANGELOG', 'REVINFO', 'File', 'File_AUD', 'StringConstants', 'StringConstants_AUD', 'BlobConstants', 'BlobConstants_AUD',
            'ImageFile', 'ImageFile_AUD', 'LanguageImage', 'LanguageImage_AUD', 'Topic', 'Topic_AUD', 'Tag', 'Tag_AUD', 'Category', 'Category_AUD', 'PropertyTag', 'PropertyTag_AUD', 'PropertyTagCategory',
            'PropertyTagCategory_AUD', 'Project', 'Project_AUD', 'User', 'User_AUD', 'ContentSpec', 'ContentSpec_AUD', 'ContentSpecNode', 'ContentSpecNode_AUD', 'TranslatedContentSpec', 'TranslatedContentSpec_AUD',
            'TopicToTag', 'TopicToTag_AUD', 'PropertyTagToPropertyTagCategory', 'PropertyTagToPropertyTagCategory_AUD', 'TopicToPropertyTag', 'TopicToPropertyTag_AUD', 'TagToPropertyTag', 'TagToPropertyTag_AUD',
            'TagToCategory', 'TagToCategory_AUD', 'TagToProject', 'TagToProject_AUD', 'CSNodeToCSNode', 'CSNodeToCSNode_AUD', 'CSNodeToPropertyTag', 'CSNodeToPropertyTag_AUD', 'ContentSpecToPropertyTag',
            'ContentSpecToPropertyTag_AUD', 'ContentSpecToTag', 'ContentSpecToTag_AUD', 'TranslatedCSNode', 'TranslatedCSNode_AUD', 'TranslatedCSNodeString', 'TranslatedCSNodeString_AUD', 'TopicSecondOrderData',
            'TopicSecondOrderData_AUD'];

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
                def newLine = process(line)
                processingTable ? updateTableMap(tableMap, tableName, newLine) : tempFile.append(newLine + "\n")
            }
            if (!processingTable && !isComment(line)) lastLineEmpty = line.isEmpty()
            return
        }
        if (!tableMap.isEmpty()) {
            def sortedTables = tableMap.sort { a, b -> tableOrder.indexOf(a.key) <=> tableOrder.indexOf(b.key) }
            for (String table : sortedTables.keySet()) {
                resultFile.append(tableMap.get(table) + "\n\n")
            }
        }
        resultFile.append(tempFile.getBytes())
        tempFile.delete()
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

    def static process(line) {
        changeBitRepresentation(convertHexNumbers(changeSingleQuoteEscaping(line)))
    }

    def static changeSingleQuoteEscaping(line) {
        line.replaceAll(~"\\\\\\'", "''") //TODO deal with special case in Regex strings
    }

    def static convertHexNumbers(line) {
        line.replaceAll(~"0x([A-Fa-f0-9]+)", { match, num -> "'$num'" })
    }

    def static changeBitRepresentation(line) {
        line.replaceAll(~"b'0'", "0")
    }

    def static removeKeyRanges(line) {
        //TODO
    }

    def static removeCharacterSets(line) {
        //TODO
    }

    def static removeIndexes(line) {
        //TODO remove indexes on BLOBS, CLOBS and TEXT fields
    }

    def static ensureIndexNamesUnique(line) {
        //TODO
    }

    //TODO reorder data imports to avoid referential integrity errors
}
