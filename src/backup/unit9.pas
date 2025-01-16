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

procedure TForm9.Button1Click(Sender: TObject);
var
    i: integer;
         tableptr: PDB_TABLE;
     begin
       groupbox1.hide();
           if Length(Edit1.text) <> 10 then begin
             Edit1.Text := 'Name not right length';
             exit;
           end;
           if Length(Edit2.text) <> 10 then begin
              Edit2.text := 'Name not rigth length';
              exit;
           end;
           for i:=0 to 9 do begin
               form9.db_name[i] := Edit1.text[i+1];
               form9.table_name[i] := Edit2.text[i+1];
           end;
           if getDB(form9.db_name) = nil then begin
             Edit1.text:= 'Database with this name does not exist';
             exit;
           end;
           if getTable(getDB(form9.db_name), form9.table_name) = nil then begin
             Edit2.text:= 'Table with this name does not exist';
             exit;
           end;
  tableptr:=getTable(getDB(form9.db_name), form9.table_name);
  if tableptr^.num_column = 0 then begin
    Edit2.text:='Table has no column';
    exit;
  end;
  if tableptr^.num_column = 1 then begin
    spinedit1.enabled:=false;
  end;
  spinedit1.maxvalue:=-1+tableptr^.num_column;
  spinedit1.minvalue:=0;
  groupbox1.show();
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
     remColumn(getTable(getDB(form9.db_name), form9.table_name), spinedit1.value);
  groupbox1.hide();
  spinedit1.enabled:=true;
  form9.hide();
end;

procedure TForm9.FormCreate(Sender: TObject);
begin
  groupbox1.hide();
end;


end.

