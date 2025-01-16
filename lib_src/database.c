/*Einbinden von externen Header-Dateien*/
#include "../include/database.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


STATE state = {0};	/*State-Struct in dem alle Pointer zu den Datenbank-Headern gespeichert wird*/

/*Speichergr��e eines bestimmten Datentyps bekommen*/
size_t getSize(DB_TYPE type) {
	switch (type) {
	case DB_TYPE_STRING:	/*Gr��e eines Strings*/
		return DB_STRING_SIZE;
	case DB_TYPE_BOOLEAN:	/*Gr��e eines Booleans*/
		return sizeof(bool);
	case DB_TYPE_INTEGER:	/*Gr��e eines Integers*/
		return sizeof(int);
	}
}

/*Namen einer Datenbank in deren Header einbinden*/
void getName(void *header, char name[DB_STRING_SIZE]) {
	memcpy(name, ((DB*)header)->name, DB_STRING_SIZE);	/*Daten werden in den Speicher des DB-Headers geschrieben*/
}

/*Erstelle eine leere Datenbank*/
void createDatabase(char name[DB_STRING_SIZE]) {
	if (state.num_db == 0) {
		state.top = malloc(sizeof(DB));	/*Wenn keine Datenbank vorhanden ist, normale Speicherzuweisung f�r Header*/
	} else {
		state.top = realloc(state.top, sizeof(DB) * (state.num_db + 1));	/*Wenn mindestens eine Datenbank existiert,
																			wird Speicher erweitert*/
	}

	DB* db_ptr = (DB*)state.top + state.num_db;	/*Berechne Speicheradresse f�r Speicherort von neuerstekktem DB-Header*/
	state.num_db++;	/*Anzahl der Datenbanken wird erh�ht*/

	memset(db_ptr, 0, sizeof(DB));	/*Datenbank wird mit 'Nullen' gef�llt*/

	memcpy(db_ptr->name, name, DB_STRING_SIZE);	/*Datenbank wird in DB-Header kopiert*/
}

/*L�schen einer Datenbank*/
void deleteDatabase(DB* db) {
	if (db == 0) {return;}	/*Wenn keine Datenbank existiert, kann auch keine gel�scht werden
								--> kein Löschen einer Datenbank*/

	for (int i = 0; i<state.num_db; i++) {
		deleteTable(db, (DB_TABLE*)db->database + i);
	}

	if (state.num_db == 1) {		/*Wenn nur eine Datenbank existiert, wird der Speicher
									der einzigen Datenbank (state.top) freigegeben*/
		free(state.top);
		state.top=0;
	} else {
		memmove(db, db + 1, sizeof(DB) * (state.num_db - ((int)db - (int)state.top) / sizeof(DB) + 1));	/*Wenn mehr als eine Datenbank existiert 
																										werden alle Datenbanken, die 'danach' kommen
																										im Speicher nach 'vorne' geschoben*/
		state.top = realloc(state.top, sizeof(DB) * (state.num_db - 1));	/*Datenbank-Header-Speicher wird neu berechnet*/
	}

	state.num_db--;	/*Anzahl der Datenbanken wird um 1 reduziert*/
}

/*Erstellen eines Tables*/
void createTable(DB* db, char name[DB_STRING_SIZE], unsigned int num_column, unsigned int num_row, DB_TYPE types[0]) {
	if (db==0) {return;}	/*Wenn keine Datenbank existiert, kann auch kein Table darin erstellt werden*/

	if (db->num_table == 0) {
		db->database = malloc(sizeof(DB_TABLE));	/*Wenn der erste Table erstellt wird, wird Speicherplatz f�r den Table-Pointer belegt*/
	} else {
		db->database = realloc(db->database, sizeof(DB_TABLE) * (db->num_table + 1));	/*Wenn schon ein Table-Pointer existiert, wird der 
																						Speicher f�t die Table angepasst, um einen neuen 
																						Table zu erstellen*/
	}

	DB_TABLE* table_ptr = (DB_TABLE*)db->database + db->num_table;	/*Neuer Table-Pointer wird zum DB-Header hinzugef�gt*/
	db->num_table++;	/*Anzahl der Table im DB-Header wird um 1 erh�ht*/

	table_ptr->num_row = num_row;

	memset(table_ptr, 0, sizeof(DB_TABLE));	/*Table wird mit 'Nullen' gef�llt*/

	table_ptr->num_row = num_row;	/*anzahl der Zeilen wird im Table-Header gespeichert*/
	memcpy(table_ptr->name, name, DB_STRING_SIZE);	/*Tablename wird in Table-Header gespeichert*/

	for (int i = 0; i < num_column; i++) {
		addColumn(table_ptr, types[i], i-1);	/*num_column Spalten werden erstellt*/
	}
}

/*Löschen eines Tables*/
void deleteTable(DB* db, DB_TABLE* table) {
	if (table==0 || db == 0) {return;}	/*Wenn kein Table existiert, kann keiner gel�scht werden*/

	for (int i = 0; i<table->num_column; i++) {
		remColumn(table, i);			/*Alle Spalten werden gel�scht*/
	}

	if (db->num_table == 1) {
		free(db->database);		/*Wenn nur ein Table existiert und dieser gel�scht wird, 
								wird der Speicherplatz vom Table-Header freigegeben*/
		db->database=0;
	} else {
		/*Wenn mehr als ein Table existiert, werden alle Table, die nach dem gel�schten Table kommen im Speicher nach 'vorn'
		geschoben*/
		memmove(table, table + 1, sizeof(DB_TABLE) * (db->num_table - ((int)table - (int)db->database) / sizeof(DB_TABLE) + 1));
		db->database = realloc(db->database, sizeof(DB_TABLE) * (db->num_table - 1));	/*Speicherplatz f�r die Table wird neu berechnet*/
	}

	db->num_table--;	/*Anzahl der Table wird um 1 reduziert*/
}

/*DB-Header-Pointer bekommen, um damit arbeiten zu k�nnen*/
DB* getDB(char name[DB_STRING_SIZE]) {
	for (int i = 0; i < state.num_db; i++) {	/*Sucht unter allen Datenbanken die mit dem angegebenen Namen*/
		DB* db_ptr = (DB*)state.top + i;	
		if (memcmp(db_ptr->name, name, DB_STRING_SIZE) == 0) {return db_ptr;}	/*Wenn die Datenbank gefunden
																				wurde, returnt es den Pointer
																				zu diesem DB-Header*/
	}
	return 0;
}

/*Table-Header-Pointer bekommen, um damit arbeiten zu k�nnen*/
DB_TABLE* getTable(DB* db, char name[DB_STRING_SIZE]) {
	for (int i = 0; i < db->num_table; i++) {	/*Sucht unter allen Tablen den mit dem angegebenen Namen*/
		DB_TABLE* table_ptr = (DB_TABLE*)db->database + i;
		if (memcmp(table_ptr->name, name, DB_STRING_SIZE) == 0) {return table_ptr;}	/*Wenn der Table gefunden
																					wurde, returnt es den Pointer
																					zu diesem Table-Header*/
	}
	return 0;
}

/*Spalte zum Table hinzuf�gen*/
void addColumn(DB_TABLE* table, DB_TYPE type, int prev_column) {
	if (table==0) {return;}	/*Wenn kein Table existiert, kann auch keine Spalte darin erstellt werden*/

	if (table->num_column == 0) {
		table->table = malloc(sizeof(DB_COLUMN));	/*Wenn noch keine SPalte existiert, wird Speicherplatz
													f�r den Column-Header belegt*/
	} else {
		table->table = realloc(table->table, sizeof(DB_COLUMN) * (table->num_column + 1));	/*Wenn schon ein 
																							Column-Header existiert,
																							wird der Speicherplatz
																							angepasst*/
	}

	DB_COLUMN* column = (DB_COLUMN*)table->table + (prev_column + 1);	/*Column-Pointer wird im Column-Header gespeichert*/
	table->num_column++;	/*Anzahl der Columns wird erh�ht*/

	memmove(column + 1, column, sizeof(DB_COLUMN) * (table->num_column - (prev_column + 2))); //does this work?	/**/

	column->type = type;	/*Column-Type wird zugewiesen*/
	column->content = malloc(getSize(type) * table->num_row);	/*Speicher f�r Content wird reserviert*/
	memset(column->content, 0, getSize(type) * table->num_row);
}

/*L�schen einer Spalte*/
void remColumn(DB_TABLE* table, unsigned int column) {
	if (table==0) {return;}	/*Wenn kein Table existiert kann keine Spalte darin gel�scht werden*/

	//TODO: add safety checks, like checking if row to delete actually exists

	DB_COLUMN* column_struct = (DB_COLUMN*)table->table + column;
	free(column_struct->content);	/*Speicherplatz des Column-Contents wird freigegeben*/

	if (table->num_column == 1) {	/*Wenn nur eine Spalte existiert, wird der Speicherplatz des Pointers zu den Spalten freigegeben*/
		free(table->table);
		table->table=0;
	} else {
		/*Wenn mehr als eine Spalte existiert, werden alle Spalten, die nach der gel�schten Spalte kommen im Speicher nach 'vorn'
		geschoben*/
		memmove(column_struct, column_struct + 1, sizeof(DB_COLUMN) * (table->num_column - (++column)));
		table->table = realloc(table->table, sizeof(DB_COLUMN) * (table->num_column - 1));	/*Speicherplatz f�r die Spalten wird neu
																							berechnet*/
	}

	table->num_column--;	/*Anzahl der Spalten wird um 1 verringert*/
}

//void addRow(DB_TABLE* table,int prev_row) {}
//void remRow(DB_TABLE* table, unsigned int row) {}

/*Inhalt zu einer bestimmten Zelle hinzuf�gen*/
void addContent(DB_TABLE* table, unsigned int column, unsigned int row, void *content) {
	if (table==0) {return;}	/*Wenn kein Table existiert, kann auch kein Inhalt hinzugef�gt werden*/

	DB_COLUMN* column_struct = (DB_COLUMN*)table->table + column;	/*Richtige Spalte wird ausgew�hlt*/
	void* db_content_ptr = ((void *)column_struct->content) + (getSize(column_struct->type) * row);	/*Richtige Reihe wird ausgew�hlt*/
	memcpy(db_content_ptr, content, getSize(column_struct->type));	/*Inhalt wird an die Richtige Position gespeichert*/
}

/*Kompletten Inhalt einer Spalte auf einmal einf�gen*/
void addColumnContent(DB_TABLE* table, unsigned int column, void *content) {
	if (table==0) {return;}	/*Wenn kein Table existiert, kann auch kein Inhalt hinzugef�gt werden*/

	DB_COLUMN* column_struct = (DB_COLUMN*)table->table + column;	/*Richtige Spalte wird ausgew�hlt*/
	memcpy(column_struct->content, content, table->num_row * getSize(column_struct->type));	/*Content wird in die Spalte gespeichert*/
}

/*Inhalt aus einer bestimmten Zelle bekommen*/
DB_CONTENT_RET getContent(DB_TABLE* table, unsigned int column, unsigned int row) {
	//check if table is valid

	DB_CONTENT_RET content;	/*Inhalt-Return-Struct deklarieren*/

	DB_COLUMN* column_struct = (DB_COLUMN*)table->table + column;	/*Richtige Spalte wird ausgew�hlt*/
	void* db_content_ptr = ((void *)column_struct->content) + (getSize(column_struct->type) * row);	/*Richtige Reihe wird ausgew�hlt und
																									in Inhalt-Pointer gespeichert*/

	content.type = column_struct->type;	/*Type des Inhalts wird ausgew�hlt*/
	content.content = db_content_ptr;	/*tats�chlicher Inhalt wird im Return-Struct gespeichert*/

	return content;	/*Inhalt wird zur�ckgegeben*/
}

/*Type einer bestimmten Spalte bekommen*/
DB_TYPE getColumnType(DB_TABLE* table, unsigned int column) {
	//check if table is valid

	DB_COLUMN* column_struct = (DB_COLUMN*)table->table + column;	/*Richtige Spalte ausw�hlen*/

	return column_struct->type;	/*Type der Spalte wird zer�ckgegeben*/
}

/*Inhalt einer ganzen Spalte bekommen*/
void* getColumnContent(DB_TABLE* table, unsigned int column) {
	if (table==0) {return 0;}	/*Wenn kein Table existiert, kann es keinen Inhalt einer Spalte geben*/

	DB_COLUMN* column_struct = (DB_COLUMN*)table->table + column;	/*Richtige Spalte wird ausgew�hlt*/
	return column_struct->content;	/*Pointer zum Inhalt der Spalte wird zur�ckgegeben*/
}
