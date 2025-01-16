unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, database;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;
  state: DB_STATE; cvar;external;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
var db_name: array[0..9] of char;
    i, n: integer;
begin
      if Length(Edit1.text) <> 10 then begin
        Edit1.Text := 'Name not right length';
        exit;
      end;
      for i:=0 to 9 do begin
          db_name[i] := Edit1.text[i+1];
      end;
      if getDB(db_name) <> nil then begin
          Edit1.Text := 'Database with this name already exists';
          exit;
      end;
      createDatabase(db_name);
      form2.hide();

end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

end.

