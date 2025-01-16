unit Unit9;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, database;

type

  { TForm9 }

  TForm9 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    db_name: array[0..9] of char;
     table_name: array[0..9] of char;
  public

  end;

var
  Form9: TForm9;

implementation

{$R *.lfm}

{ TForm9 }
//Remove Column
procedure TForm9.Button1Click(Sender: TObject);
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
               form9.db_name[i] := Edit1.text[i+1];
               form9.table_name[i] := Edit2.text[i+1];
           end;
           //Wenn der DB-Pointer "ins nichts" zeigt (vergleichbar mit null in C),
           //wird die Prozedur verlassen
           if getDB(form9.db_name) = nil then begin
             Edit1.text:= 'Database with this name does not exist';
             exit;
           end;
           //Wenn der Table-Pointer "ins nichts" zeigt (vergleichbar mit null in C),
           //wird die Prozedur verlassen
           if getTable(getDB(form9.db_name), form9.table_name) = nil then begin
             Edit2.text:= 'Table with this name does not exist';
             exit;
           end;
           //Table-Pointer wird als Variable gespeichert
           tableptr:=getTable(getDB(form9.db_name), form9.table_name);
           //Wenn keine Spalte existiert, kann keine Spalte gelöscht werden
           if tableptr^.num_column = 0 then begin
             Edit2.text:='Table has no column';
             exit;
            end;
           //Wenn nur eine Spalte existiert, kann nur eine Spalte gelöscht werden
           //=> auswahl wird auf eine SPalte begrenzt
            if tableptr^.num_column = 1 then begin
              spinedit1.enabled:=false;
            end;
            //Grenzen der SPalten-Positions-Auswahl wird gesetzt
            //ab -1 (an erster stelle)
            spinedit1.maxvalue:=-1+tableptr^.num_column;
            spinedit1.minvalue:=0;
            //Choose Column GroupBox wird angezeigt
            groupbox1.show();
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
  //Spalte wird gelöscht
  remColumn(getTable(getDB(form9.db_name), form9.table_name), spinedit1.value);
  //auf default zurücksetzen
  groupbox1.hide();
  spinedit1.enabled:=true;
  //Form9 wird geschlossen
  form9.hide();
end;

//Default: GroupBox1 unsichtbar
procedure TForm9.FormCreate(Sender: TObject);
begin
  groupbox1.hide();
end;


end.

