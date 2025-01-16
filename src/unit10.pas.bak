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
           if Length(Edit1.text) <> 10 then begin
             Edit1.Text := 'Name not right length';
             exit;
           end;
           if Length(Edit2.text) <> 10 then begin
              Edit2.text := 'Name not rigth length';
              exit;
           end;
           for i:=0 to 9 do begin
               form10.db_name[i] := Edit1.text[i+1];
               form10.table_name[i] := Edit2.text[i+1];
           end;
           if getDB(form10.db_name) = nil then begin
             Edit1.text:= 'Database with this name does not exist';
             exit;
           end;
           if getTable(getDB(form10.db_name), form10.table_name) = nil then begin
             Edit2.text:= 'Table with this name does not exist';
             exit;
           end;
  tableptr:=getTable(getDB(form10.db_name), form10.table_name);
  if tableptr^.num_column = 0 then begin
    Edit2.text:='Table has no column';
    exit;
  end;
  if tableptr^.num_row = 0 then begin
    Edit2.text:='Table has no row';
    exit;
  end;
  if tableptr^.num_row = 1 then begin
    spinedit1.enabled:=false;
  end;
  if tableptr^.num_column = 1 then begin
    spinedit2.enabled:=false;
  end;
  spinedit1.maxvalue:=-1+tableptr^.num_row;
  spinedit1.minvalue:=0;
  spinedit1.maxvalue:=-1+tableptr^.num_column;
  spinedit1.minvalue:=0;
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
     tableptr:=getTable(getDB(form10.db_name), form10.table_name);
     intc:= 0;
     boolc:=false;
     stringc:='          ';

      type_c:=getcolumntype(tableptr, spinedit2.value);

      if type_c = DB_TYPE_STRING then addcontent(tableptr, spinedit2.value, spinedit1.value, @stringc)
      else if type_c = DB_TYPE_INTEGER then addcontent(tableptr, spinedit2.value, spinedit1.value, @boolc)
      else if type_c = DB_TYPE_BOOLEAN then addcontent(tableptr, spinedit2.value, spinedit1.value, @intc);

     spinedit1.enabled:=true;
     spinedit2.enabled:=false;
     groupbox1.hide();
     form10.hide();
end;

end.

