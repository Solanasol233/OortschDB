unit Unit7;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, database;

type

  { TForm7 }

  TForm7 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form7: TForm7;

implementation

{$R *.lfm}

{ TForm7 }

procedure TForm7.Button1Click(Sender: TObject);
   var db_name: array[0..9] of char;
       table_name: array[0..9] of char;
       i: integer;
   begin
         if Length(Edit1.text) <> 10 then begin
           Edit1.Text := 'Name not right length';
           exit;
         end;
         if Length(Edit2.text) <> 10 then begin
            Edit2.text := 'Name not rigth length';
            exit;
         end;
         for i:=0 to 9 do begin
             db_name[i] := Edit1.text[i+1];
             table_name[i] := Edit2.text[i+1];
         end;
         if getDB(db_name) = nil then begin
           Edit1.text:= 'Database with this name does not exist';
           exit;
         end;
         if getTable(getDB(db_name), table_name) = nil then begin
           Edit2.text:= 'Table with this name does not exist';
           exit;
         end;
   deleteTable(getDB(db_name), getTable(getDB(db_name), table_name));
   form7.hide();
end;

end.

