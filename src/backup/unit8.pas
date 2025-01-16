unit Unit8;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, database, unit4;

type

  { TForm8 }

  TForm8 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
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
  Form8: TForm8;

implementation

{$R *.lfm}

{ TForm8 }

procedure TForm8.Button1Click(Sender: TObject);
begin
  form4.show();
  form4.Caption:= 'Select Type for Column ' + inttostr(1+spinedit1.value);
  while form4.visible do begin
                Application.ProcessMessages;
  end;
  addColumn(getTable(getDB(form8.db_name), form8.table_name), c_type, spinedit1.value);
  groupbox1.hide();
  spinedit1.enabled:=true;
  form8.hide();
end;

procedure TForm8.Button2Click(Sender: TObject);
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
               form8.db_name[i] := Edit1.text[i+1];
               form8.table_name[i] := Edit2.text[i+1];
           end;
           if getDB(form8.db_name) = nil then begin
             Edit1.text:= 'Database with this name does not exist';
             exit;
           end;
           if getTable(getDB(form8.db_name), form8.table_name) = nil then begin
             Edit2.text:= 'Table with this name does not exist';
             exit;
           end;
  tableptr:=getTable(getDB(form8.db_name), form8.table_name);
  if tableptr^.num_column = 0 then begin
     spinedit1.Enabled:=false;
     spinedit1.Value:=-1;
  end;
  spinedit1.maxvalue:=-1+tableptr^.num_column;
  spinedit1.minvalue:=-1;
  groupbox1.show();
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
   groupbox1.hide();
end;
end.

