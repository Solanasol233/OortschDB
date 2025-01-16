unit Unit6;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin,
  ExtCtrls, database;

type

  { TForm6 }

  TForm6 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Row: TSpinEdit;
    Column: TSpinEdit;
    SpinEdit1: TSpinEdit;
    ToggleBox1: TToggleBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private

  public

  end;

var
  Form6: TForm6;
  dbName, tableName: array[0..9] of char;
  DB_PNTR: ^DB;
  TBL_PNTR: ^DB_Table;
  choosenRow, choosenColumn: integer;
  columnType: DB_TYPE;
implementation

{$R *.lfm}

{ TForm6 }

procedure TForm6.FormCreate(Sender: TObject);
begin
  GroupBox1.Hide;
  GroupBox2.Hide;
end;

procedure TForm6.ToggleBox1Change(Sender: TObject);
begin
  if Togglebox1.checked then
     Togglebox1.caption := 'True'
  else Togglebox1.caption := 'False';
end;


//DB
procedure TForm6.Button1Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to 9 do
  begin
    dbName[i] := Edit1.Text[i+1];
  end;
  if Length(Edit1.text) <> 10 then begin
        Edit1.Text := 'Name not right length';
        exit;
      end;
  DB_PNTR := getDB(dbName);

  if DB_PNTR = nil then begin
        Edit1.text:= 'Database with this name does not exist';
        exit;
      end;
end;


//Table
procedure TForm6.Button4Click(Sender: TObject);
var
  i:integer;
begin
     for i:=0 to 9 do
     begin
       tableName[i] := Edit3.Text[i+1];
     end;

     if Length(Edit3.text) <> 10 then begin
        Edit3.Text := 'Name not right length';
        exit;
      end;

     TBL_PNTR := getTable(DB_PNTR, tableName);

     if TBL_PNTR = nil then
     begin
           Edit3.Text:= 'Table with this name does not exist';
           exit;
     end;

     column.MaxValue:= TBL_PNTR^.num_column - 1;
     row.MaxValue := TBL_PNTR^.num_row - 1;

     GroupBox1.Show;
end;

procedure TForm6.Button5Click(Sender: TObject);
begin
  GroupBox1.hide;
  GroupBox2.hide;
  Form6.hide;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  choosenRow:= row.value;
  choosenColumn := column.value;
  Edit2.hide;
  SpinEdit1.hide;
  ToggleBox1.hide;

  columnType:= getColumnType(TBL_PNTR, choosenColumn);

  Case columnType of
  DB_TYPE_INTEGER : begin
     Label5.Caption:= 'Integer';
     SpinEdit1.show
  end;
  DB_TYPE_STRING : begin
     Label5.Caption := 'String';
     Edit2.Show;
  end;
  DB_TYPE_BOOLEAN : begin
     Label5.Caption:= 'Boolean';
     ToggleBox1.show;
     end;
  end;

  GroupBox2.Show;
end;

procedure TForm6.Button3Click(Sender: TObject);
var
  intContPntr, i: integer;
  strContPntr: array[0..9] of char;
  bolContPntr: Boolean;
begin
  Case columnType of
  DB_TYPE_INTEGER : begin
     intContPntr := Spinedit1.value;
     addContent(TBL_PNTR, choosenColumn, choosenRow, @intContPntr);
     exit
  end;
  DB_TYPE_STRING : begin
     for i := 0 to 9 do
     begin
        strContPntr[i] := Edit2.Text[i+1];
     end;
     if Length(Edit2.text) <> 10 then begin
        Edit2.Text := 'Name not right length';
        exit;
      end;
     addContent(TBL_PNTR, choosenColumn, choosenRow, @strContPntr);
     exit
  end;
  DB_TYPE_BOOLEAN : begin
     if ToggleBox1.checked then
        bolContPntr := True
     else
       bolContPntr := False;
     addContent(TBL_PNTR, choosenColumn, choosenRow, @bolContPntr);
     exit
  end;

  end;
  addContent(nil, column.Value, row.Value, nil);
end;

end.

