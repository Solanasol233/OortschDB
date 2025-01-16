unit Unit10;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, database;

type

  { TForm10 }

  TForm10 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
     db_name: array[0..9] of char;
     table_name: array[0..9] of char;
  public

  end;

var
  Form10: TForm10;

implementation

{$R *.lfm}

{ TForm10 }

procedure TForm10.FormCreate(Sender: TObject);
begin
  groupbox1.hide();
end;

procedure TForm10.Button1Click(Sender: TObject);
var
    i: integer;
         tableptr: PDB_TABLE;
     begin
       groupbox1.hide();
           //Wenn der Name der Datanbank nicht genau 10 Zeichen lang ist,
           //wird die Prozedur verlassen
           if Length(Edit1.text) <> 10 then begin
             Edit1.Text := 'Name not right length';
             exit;
           end;
           //Wenn der Name der Tabelle nicht genau 10 Zeichen lang ist,
           //wird die Prozedur verlassen
           if Length(Edit2.text) <> 10 then begin
              Edit2.text := 'Name not rigth length';
              exit;
           end;
           //Eingelesener Name der Tabelle und der der Datenbank
           //aus Edit2 und Edit1 wird in table_name-Array und db_name-Array
           //kopiert
           for i:=0 to 9 do begin
               form10.db_name[i] := Edit1.text[i+1];
               form10.table_name[i] := Edit2.text[i+1];
           end;
           //Wenn der DB-Pointer "ins nichts" zeigt (vergleichbar mit null in C),
           //wird die Prozedur verlassen
           if getDB(form10.db_name) = nil then begin
             Edit1.text:= 'Database with this name does not exist';
             exit;
           end;
           //Wenn der Table-Pointer "ins nichts" zeigt (vergleichbar mit null in C),
           //wird die Prozedur verlassen
           if getTable(getDB(form10.db_name), form10.table_name) = nil then begin
             Edit2.text:= 'Table with this name does not exist';
             exit;
           end;
           //Table-Pointer wird als Variable gespeichert
  tableptr:=getTable(getDB(form10.db_name), form10.table_name);
  //Wenn keine Spalten existieren, existiert auch kein Inhalt
  if tableptr^.num_column = 0 then begin
    Edit2.text:='Table has no column';
    exit;
  end;
  //Wenn keine Zeilen existieren, existiert auch kein Inhalt
  if tableptr^.num_row = 0 then begin
    Edit2.text:='Table has no row';
    exit;
  end;
  //Wenn nur eine Zeile exiistiert, kann nur eine Zeile ausgewählt werden
  if tableptr^.num_row = 1 then begin
    spinedit1.enabled:=false;
  end;
  //Wenn nur eine Spalte exiistiert, kann nur eine Spalte ausgewählt werden
  if tableptr^.num_column = 1 then begin
    spinedit2.enabled:=false;
  end;
  //Grenzen der Auswahl werden festgelegt
  spinedit1.maxvalue:=-1+tableptr^.num_row;
  spinedit1.minvalue:=0;
  spinedit1.maxvalue:=-1+tableptr^.num_column;
  spinedit1.minvalue:=0;
  //GroupBox zum auswählen der Zeile und Spalte wird sichtbar gemacht
  groupbox1.show();
end;

procedure TForm10.Button2Click(Sender: TObject);
var
         tableptr:PDB_TABLE;
         intc : integer;
         boolc : boolean;
         stringc: array[0..9] of char;
         type_c: DB_TYPE;
begin
     //Table-Pointer wird als Variable gespeichert
     tableptr:=getTable(getDB(form10.db_name), form10.table_name);
     //Default bzw. 'leer'-werte für Typen von Zellen werden festgelegt
     intc:= 0;
     boolc:=false;
     stringc:='          ';

     //Datentyp der ausgewählten Zelle wird in einer Variable gespeichert
      type_c:=getcolumntype(tableptr, spinedit2.value);
      //Je nach Datentyp wird der 'leer'-Wert in die Zelle geschrieben
      if type_c = DB_TYPE_STRING then addcontent(tableptr, spinedit2.value, spinedit1.value, @stringc)
      else if type_c = DB_TYPE_INTEGER then addcontent(tableptr, spinedit2.value, spinedit1.value, @boolc)
      else if type_c = DB_TYPE_BOOLEAN then addcontent(tableptr, spinedit2.value, spinedit1.value, @intc);
     //Default-einstellungen
     spinedit1.enabled:=true;
     spinedit2.enabled:=true;
     groupbox1.hide();
     //Schließen Form10
     form10.hide();
end;

end.

