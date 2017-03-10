unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Grids, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Spiel_Menu: TMenuItem;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure setSize(numx: integer; numy: integer);
    procedure startNewGame();
    procedure open_field(x, y : integer);
    function getNumMines(x, y: integer): integer;
    procedure check();
  public
    { public declarations }
  private
    num_x, num_y, field_size: integer;
    field: array of array of integer;
  end;

var
  Form1: TForm1;

  MinePercent: real = 0.16;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  setSize(10, 10);
  randomize();
  startNewGame();
  field_size:=StringGrid1.DefaultColWidth;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Form2.ShowModal;
  if (Form2.NewWidth <> 0) and (Form2.NewHeight <> 0) then
  begin
    setSize(Form2.NewWidth, Form2.NewHeight);
  end;
  if (Form2.MinePercent <> 0) then
  begin
    MinePercent := Form2.MinePercent;
  end;
  startnewgame();
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  startNewGame();
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  if (field[aCol][aRow] and 2 = 2) then
  begin
    StringGrid1.Canvas.brush.Color:=clCream;
    StringGrid1.Canvas.FillRect(aRect);
    if (field[acol][arow] and 1 = 1) then
    begin
      StringGrid1.Canvas.TextOut(acol * field_size + 7, arow * field_size + 4, '#');
    end
    else if (field[acol][arow] and 4 = 4) then
    begin
      StringGrid1.Canvas.TextOut(acol * field_size + 7, arow * field_size + 4, '?');
    end
    else if (field[acol][arow] SHR 8 > 0) then
    begin
      StringGrid1.Canvas.TextOut(acol * field_size + 7, arow * field_size + 4, inttostr(field[acol][arow] SHR 8));
    end;
    exit;
  end;
  StringGrid1.Canvas.fillRect(aRect);
end;

procedure TForm1.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    open_field(x div field_size, y div field_size);
    field[x div field_size][y div field_size] := field[x div field_size][y div field_size] or 2;
  end
  else if (button = mbRight) then
  begin
    open_field(x div field_size, y div field_size);
    if (field[x div field_size][y div field_size] and 2 <> 2) then
    begin
      field[x div field_size][y div field_size] := field[x div field_size][y div field_size] or 4;
    end;
  end;
  check();
end;

procedure TForm1.setSize(numx: integer; numy: integer);
begin
  width:= numx * StringGrid1.defaultColWidth;
  height:= numy * StringGrid1.defaultRowHeight + 20;
  StringGrid1.width := numx * StringGrid1.defaultColWidth;
  StringGrid1.height := numy * StringGrid1.defaultRowHeight;
  StringGrid1.ColCount := numx;
  StringGrid1.RowCount := numy;
  num_x := numx;
  num_y := numy;
end;

procedure TForm1.startNewGame();
var i,j,num_mines, count: integer;
begin
  setLength(field, 0, 0);
  setLength(field, num_x, num_y);

  // clear filed
  for i:=0 to num_x - 1 do
  begin
    for j:=0 to num_y -1 do
    begin
      field[i][j] := 0;
    end;
  end;

  // distribute mines
  num_mines := 0;
  count := 0;
  while num_mines < (num_x * num_y * minePercent) do
  begin
    if (random(101) < (100 * minePercent)) and (field[count mod num_x][count div num_y] <> 1) then
    begin
      num_mines := num_mines + 1;
      field[count mod num_x][count div num_y] := 1;
    end;

    count := count + 1;
    if count > num_x * num_y then
    begin
      count := 0;
    end;
  end;

  for i:=0 to num_x - 1 do
  begin
    for j:=0 to num_y - 1 do
    begin
      StringGrid1.cells[i, j] := '';
      Field[i][j] := Field[i][j] or (getNumMines(i, j) SHL 8);
    end;
  end;
end;

procedure TForm1.open_field(x,y: integer);
begin
  if (x < 0) or (x >= num_x) then
  begin
    exit;
  end;
  if (y < 0) or (y >= num_y) then
  begin
    exit;
  end;
  if (field[x][y] and 2) = 2 then
  begin
    exit;
  end;

  if (field[x][y] SHR 8 > 0) then
  begin
    field[x][y] := field[x][y] or 2;
    exit;
  end;

  field[x][y] := field[x][y] or 2;

  open_field(x - 1, y - 1);
  open_field(x, y - 1);
  open_field(x + 1, y - 1);
  open_field(x - 1, y);
  open_field(x + 1, y);
  open_field(x - 1, y + 1);
  open_field(x, y + 1);
  open_field(x + 1, y + 1);
end;

function TForm1.getNumMines(x,y:integer):integer;
var i,j,k:integer;
begin
  k := 0;
  for i:= x - 1 to x + 1 do
  begin
    for j := y - 1 to y + 1 do
    begin
      if (i >= 0) and (i < num_x) then
      begin
        if (j >= 0) and (j < num_y) then
        begin
          if (field[i][j] and 1) = 1 then
          begin
            k := k + 1;
          end;
        end;
      end;
    end;
  end;
  getNumMines:= k;
end;

procedure TForm1.check();
var i,j,reply:integer;
begin
  for i:=0 to num_x - 1 do
  begin
    for j:= 0 to num_y - 1 do
    begin
      if (field[i][j] and 1 = 1) and (field[i][j] and 2 = 2) then
      begin
        for i:=0 to
        reply := Application.MessageBox('Verloren!' + sLineBreak + 'Neues Spiel?', 'Verloren!', $4 or $30);
        if reply = 6 then
        begin
          startnewgame();
          StringGrid1.Repaint();
        end;
        exit;
      end;
    end;
  end;
end;

end.

