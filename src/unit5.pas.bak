unit Unit5;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  database, unit4;

type

  { TForm5 }

  TForm5 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Column: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Row: TSpinEdit;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form5: TForm5;

implementation

{$R *.lfm}

{ TForm5 }
//Erstellen einer Tabelle
procedure TForm5.Button1Click(Sender: TObject);
var db_name: array[0..9] of char;
    table_name: array[0..9] of char;
    i: integer;
    types: array of DB_TYPE;
begin
      //Wenn der Name der Datenbank nicht genau 10 Zeichen lang ist,
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
      //aus Edit2 und Edit1 wird in db_name-Array und table_name-Array kopiert
      for i:=0 to 9 do begin
          db_name[i] := Edit1.text[i+1];
          table_name[i] := Edit2.text[i+1];
      end;
      //Wenn der DB-Pointer "ins nichts" zeigt (vergleichbar mit null in C),
      //wird die Prozedur verlassen
      if getDB(db_name) = nil then begin
        Edit1.text:= 'Database with this name does not exist';
        exit;
      end;
      //Wenn bereits ein Pointer zu einem Table mit dem selben Namen
      //existiert, wird die Prozedur verlassen
      if getTable(getDB(db_name), table_name) <> nil then begin
        Edit2.text:= 'Table with this name already exists';
        exit;
      end;
      //Größe des dynamisches Arrays types wird auf die Anzahl der
      //Spalten angepasst
      setlength(types, column.value);
      //Es öffnet sich für jede Spalte ein Fenster zum Auswählen des
      //Datentyps der Spalte
      for i:=0 to column.value -1 do begin
          form4.show();
          form4.Caption:= 'Select Type for Column ' + inttostr(i);
          while form4.visible do begin
                Application.ProcessMessages;
          end;
          types[i] := c_type;
          //TODO: output error if no type was selected
      end;
      //Wenn Prozedur bis jetzt nicht verlassen wurde, wird eine
      //neue Tabelle erstellt und die Form5 verlassen
      createTable(getDB(db_name), table_name, column.value, row.value, types);
      form5.hide();
end;

end.

