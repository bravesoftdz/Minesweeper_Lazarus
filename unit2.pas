unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    NewWidth, NewHeight: integer;
    MinePercent : real;
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button2Click(Sender: TObject);
begin
  NewWidth := 0;
  NewHeight := 0;
  MinePercent := 0.0;
  close;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.Edit1Exit(Sender: TObject);
var t: integer;
begin
  t := 10;
  if Edit1.Text <> '' then
  begin
    t := strtoint(Edit1.text);
    if t < 5 then
    begin
      t := 5;
    end;
    if t > 50 then
    begin
      t := 50;
    end;
  end;
  Edit1.text := IntToStr(t);
  NewWidth := t;
end;

procedure TForm2.Edit2Exit(Sender: TObject);
  var t: integer;
begin
  t := 10;
  if Edit2.Text <> '' then
  begin
    t := strtoint(Edit2.text);
    if t < 5 then
    begin
      t := 5;
    end;
    if t > 50 then
    begin
      t := 50;
    end;
  end;
  Edit2.Text := inttostr(t);
  NewHeight := t;
end;

procedure TForm2.Edit3Exit(Sender: TObject);
  var t: real;
begin
  t := 16;
  if Edit3.Text <> '' then
  begin
    t := strtofloat(Edit3.text);
    if t < 10 then
    begin
      t := 10;
    end;
    if t > 96 then
    begin
      t := 96;
    end;
  end;
  Edit3.text := FloatToStr(t);
  MinePercent := t / 100;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  NewWidth := 10;
  NewHeight := 10;
  MinePercent := 0.16;
end;

end.

