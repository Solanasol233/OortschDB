unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ActnList, Menus,database,
  unit2, unit3, unit5, unit6, unit7, unit8, unit9, unit10;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem9: TMenuItem;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  loadTablePntr : ^DB_TABLE;
  DBpntr : ^DB;
  DBName, TBLName: array[0..9] of char;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  //Öffne Form zum Erstellen einer Datenbank
  form2.Show();

end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem14Click(Sender: TObject);
begin
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  //Öffne Form zum Einfügen von Inhalt in eine Zelle
  Form6.show();
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i:integer;
begin


  if Length(Edit2.text) <> 10 then begin
        Edit2.Text := 'Name not right length';
        exit;
      end;

  for i := 0 to 9 do
  begin
    DBName[i] := Edit2.Text[i+1];
  end;

  DBpntr := getDB(DBName);

  if DBpntr = nil then begin
        Edit2.text:= 'Database with this name does not exist';
        exit;
      end;
end;


//Table
procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  colin, rowin: integer;
  CONRET: DB_CONTENT_RET;
  intpntderef: ^integer;
  chrptrderef: ^char;
  strcontent: array[0..9] of char;
  bolpntderef: ^Boolean;
begin
  for i:=0 to 9 do
  begin
    TBLName[i] := Edit1.Text[i+1];
  end;

  if Length(Edit1.text) <> 10 then begin
        Edit1.Text := 'Name not right length';
        exit;
      end;
  loadTablePntr := getTable(DBpntr, TBLName);

  if loadTablePntr = nil then
     begin
           Edit1.Text:= 'Table with this name does not exist';
           exit;
     end;

  StringGrid1.ColCount:= loadTablePntr^.num_column +1;
  StringGrid1.RowCount:= loadTablePntr^.num_row +1;

  for colin:=0 to loadTablePntr^.num_column - 1 do
  begin
    for rowin:= 0 to loadTablePntr^.num_row - 1 do
    begin
      CONRET := getContent(loadTablePntr, colin, rowin);
      Case CONRET._type of
           DB_TYPE_INTEGER : begin
             intpntderef:= CONRET.content;
             StringGrid1.Cells[colin + 1, rowin + 1] := inttostr(intpntderef^);
           end;
           DB_TYPE_STRING : begin
             chrptrderef := CONRET.content;
             for i:= 0 to 9 do
             begin
                strcontent[i] := chrptrderef[i];
             end;
             StringGrid1.Cells[colin + 1, rowin + 1] := strcontent;
           end;
           DB_TYPE_BOOLEAN : begin
             bolpntderef:=CONRET.content;
             if bolpntderef^=false then StringGrid1.Cells[colin + 1, rowin + 1] := 'False'
             else  StringGrid1.Cells[colin + 1, rowin + 1] := 'True';
           end;
  end;
    end;
  end;
end;



procedure TForm1.MenuItem13Click(Sender: TObject);
begin
  //Öffne Form, um Content zu löschen
  form10.show();
end;

procedure TForm1.MenuItem10Click(Sender: TObject);
begin
  //Öffne Form zum löschen von Column
  form9.show();
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  //Öffne Form zum Löschen einer Datenbank
  form3.show();
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
 //Öffne Form zum erstellen eines neuen Tables
 form5.show();
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  //Öffne Form zum löschen eines Tables
  form7.show();
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
  //Neue Spalte erstellen
  form8.show();
end;

end.

