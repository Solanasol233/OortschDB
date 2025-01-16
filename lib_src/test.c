#include "../include/database.h"
#include <stdio.h>
#include <stdbool.h> 

int main(int argc, char *argv[]) {
	createDatabase("Database 1");
	DB_TYPE type[1] = {DB_TYPE_INTEGER};
	createTable(getDB("Database 1"), "Table Test", 1, 2, type);
	addColumn(getTable(getDB("Database 1"), "Table Test"), DB_TYPE_BOOLEAN, -1);

	int test_i = 696969;
	bool test_b = true;

	addContent(getTable(getDB("Database 1"), "Table Test"), 1, 0, &test_i);
	addContent(getTable(getDB("Database 1"), "Table Test"), 0, 0, &test_b);

	DB_TABLE* table = getTable(getDB("Database 1"), "Table Test");
	DB* db = getDB("Database 1");

	DB_CONTENT_RET content = {0};

	content = getContent(getTable(getDB("Database 1"), "Table Test"), 1, 0);

	int output_i = *(int*)content.content;

	printf("%d\n", output_i);

	content = getContent(getTable(getDB("Database 1"), "Table Test"), 0, 0);

	bool output_b = *(bool*)content.content;

	printf("%d\n", output_b);

	remColumn(table, 1);
	deleteTable(getDB("Database 1"), table);
	deleteDatabase(getDB("Database 1"));

	//TODO: add more tests

	printf("End END end ente gut alles gut\n");

	return 0;
}