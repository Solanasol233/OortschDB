unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, database, unit4;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
var db_name: array[0..9] of char;
    i: integer;
begin
      if Length(Edit1.text) <> 10 then begin
        Edit1.Text := 'Name not right length';
        exit;
      end;
      for i:=0 to 9 do begin
          db_name[i] := Edit1.text[i];
      end;
      if getDB(db_name) = nil then begin
        Edit1.text:= 'Database with this name does not exist';
        exit;
      end;
      deleteDatabase(getDB(db_name));
      form3.hide();
end;

end.

