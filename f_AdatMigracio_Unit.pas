unit f_AdatMigracio_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AlapSzures_Unit, Data.DB,
  Data.Win.ADODB, Vcl.WinXCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls, Alap, Alapfuggveny;

type
  Tf_AdatMigracio = class(TAlapSzures)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    m: TMemo;
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_AdatMigracio: Tf_AdatMigracio;

implementation

{$R *.dfm}

uses AlapAdat;

procedure Tf_AdatMigracio.BitBtn2Click(Sender: TObject);
begin
  inherited;
  SZURES.Active:=False;
  SZURES.SQL.Text:=
    'Select b.SZERVEZET_ID, b.JURTA_KOD, b.SZERVEZET_NEV, a.* '+
    'From JurtaTV_teszt.dbo.Nberlok a left join TIR_teszt.dbo.SZERVEZET b on '+
    'a.ADOSZAM=b.ADOSZAM Where a.AKTIV=1 Order By b.SZERVEZET_ID ';
  SZURES.Active:=True;
  SZURES.First;
  while not SZURES.Eof do
  begin
    //Nincs a TIR-ben
    if SZURES.FieldByName('SZERVEZET_ID').AsString='' then
    begin
      m.Lines.Add(
      'Insert Into SZERVEZET Values(Null,Null,'+
      IDCHAR+SZURES.FieldByName('NEV').AsString+IDCHAR+',Null,Null,'+
      IDCHAR+SZURES.FieldByName('ADOSZAM').AsString+IDCHAR+','+
      IDCHAR+SZURES.FieldByName('CEGJEGYZEKSZAM').AsString+IDCHAR+','+
      IDCHAR+SZURES.FieldByName('BANKSZAMLA').AsString+IDCHAR+',Null,'+
      IDCHAR+'21001231'+IDCHAR+','+
      IDCHAR+SZURES.FieldByName('KOD').AsString+IDCHAR+','+
      IDCHAR+SZURES.FieldByName('KEPVISELO').AsString+IDCHAR+')');
//      SZER_ID:=Beszuras('SZERVEZET',[
//        'szervezet_nev='+SZURES.FieldByName('NEV').AsString,
//        'adoszam='+SZURES.FieldByName('ADOSZAM').AsString,
//        'cegjegyzekszam='+SZURES.FieldByName('CEGJEGYZEKSZAM').AsString,
//        'bankszamlaszam='+SZURES.FieldByName('BANKSZAMLA').AsString,
//        'szervezet_vege='+MAXDAT,
//        'jurta_kod='+SZURES.FieldByName('KOD').AsString
//        ]);
      LISTA.SQL.Text:='Select szervezet_id From szervezet Where jurta_kod='+SZURES.FieldByName('KOD').AsString;
      LISTA.Active:=True;
      if LISTA.FieldByName('szervezet_id').AsString<>'' then
      begin
        if SZURES.FieldByName('TELEFON').AsString<>'' then

      end;
    end;
    SZURES.Next;
  end;
end;

end.
