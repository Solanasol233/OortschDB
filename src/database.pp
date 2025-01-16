
unit database;
interface

{
  Automatically converted by H2Pas 1.0.0 from database.h
  The following command line parameters were used:
    -d
    database.h
}

{$linklib libdatabase.a}

{$ifdef WINDOWS}
{$linklib libmsvcrt.a}
//{$linklib libmingw32.a}
//{$linklib libmingwex.a}
{$linklib libgcc.a}
{$endif}

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


{$ifndef DATABASE}
{$define DATABASE}  

  const
    DB_STRING_SIZE = 10;    

  type
    DB_TYPE = (DB_TYPE_STRING := 0,DB_TYPE_BOOLEAN := 1,
      DB_TYPE_INTEGER := 2);

    DB_COLUMN = record
        _type : DB_TYPE;
        content : pointer;
      end;
  {TODO: switch void* in structs to right pointer to struct }
  {DB_COLUMN* }

    DB_TABLE = record
        name : array[0..(DB_STRING_SIZE)-1] of char;
        num_column : dword;
        num_row : dword;
        table : pointer;
      end;
    PDB_TABLE  = ^DB_TABLE;
  {DB_TABLE* }

    DB = record
        name : array[0..(DB_STRING_SIZE)-1] of char;
        num_table : dword;
        database : pointer;
      end;
    PDB  = ^DB;
  { }

    DB_STATE = record
        num_db : dword;
        top : pointer;
      end;

    DB_CONTENT_RET = record
        _type : DB_TYPE;
        content : pointer;
      end;
  {names maximally 10 chars long }

  procedure getName(header:pointer; name: array of char);cdecl;external;

  procedure createDatabase(name:array of char);cdecl;external;

  procedure deleteDatabase(db:PDB);cdecl;external;

  procedure createTable(db:PDB; name:array of char; num_column:dword; num_row:dword; types:array of DB_TYPE);cdecl;external;

  procedure deleteTable(db:PDB; table:PDB_TABLE);cdecl;external;

  function getDB(name:array of char):PDB;cdecl;external;

  function getTable(db:PDB; name:array of char):PDB_TABLE;cdecl;external;

  procedure addColumn(table:PDB_TABLE; _type:DB_TYPE; prev_column:longint);cdecl;external;

  procedure remColumn(table:PDB_TABLE; column:dword);cdecl;external;

  {void addRow(DB_TABLE* table,int prev_row); }
  {void remRow(DB_TABLE* table, unsigned int row); }
  procedure addContent(table:PDB_TABLE; column:dword; row:dword; content:pointer);cdecl;external;

  {void addRowContent(); }
  procedure addColumnContent(table:PDB_TABLE; column:dword; content:pointer);cdecl;external;

  function getContent(table:PDB_TABLE; column:dword; row:dword):DB_CONTENT_RET;cdecl;external;

  function getColumnType(table:PDB_TABLE; column:dword):DB_TYPE;cdecl;external;

  {void* getRowContent(); }
  function getColumnContent(table:PDB_TABLE; column:dword):pointer;cdecl;external;

{$endif}

implementation


end.
