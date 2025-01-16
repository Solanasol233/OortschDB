unit Unit4;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, database;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;
  c_type: DB_TYPE;
implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin
   c_type:=DB_TYPE_STRING;
   form4.hide();
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
   c_type:=DB_TYPE_BOOLEAN;
   form4.hide();
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
    c_type:=DB_TYPE_INTEGER;
    form4.hide();
end;

end.

