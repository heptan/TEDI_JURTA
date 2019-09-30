unit f_SzervezetKeres_Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AlapSzures_Unit, Data.DB,
  Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, AlapFuggveny, VDComboBox, Alap, Vcl.WinXCtrls;

type
  Tf_SzervezetKeres = class(TAlapSzures)
    le_szervezet: TLabeledEdit;
    le_adoszam: TLabeledEdit;
    DBGrid1: TDBGrid;
    LISTAds: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    le_jurtanev: TLabeledEdit;
    le_jurtaado: TLabeledEdit;
    BitBtn2: TBitBtn;
    procedure bb_keresClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SZURESAfterScroll(DataSet: TDataSet);
    procedure dbg_listaDblClick(Sender: TObject);
    procedure bb_ujClick(Sender: TObject);
    procedure bb_kilepClick(Sender: TObject);
    procedure dbg_listaCellClick(Column: TColumn);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_SzervezetKeres: Tf_SzervezetKeres;

implementation

{$R *.dfm}

uses f_SzervezetAdat_Unit, AlapAdat;

procedure Tf_SzervezetKeres.bb_keresClick(Sender: TObject);
begin
  With SZURES do
  begin
    Active:=False;
    SQL.Text:=
      'Select a.*, '+
      '  (Select x.szervezet_tipus_nev From szervezet_tipus x Where x.szervezet_tipus_id=a.szervezet_tipus_id) as tipus, '+
      '  (Select x.szervezet_forma_nev From szervezet_forma x Where x.szervezet_forma_id=a.szervezet_forma_id) as forma, '+
      '  (Select TOP 1 x.eleres_nev From eleres x, szervezet_eleres y Where x.eleres_id=y.eleres_id and y.szervezet_id=a.szervezet_id and x.eleres_tipus_id=8) as cim, '+
      '  (Select TOP 1 x.eleres_nev From eleres x, szervezet_eleres y Where x.eleres_id=y.eleres_id and y.szervezet_id=a.szervezet_id and x.eleres_tipus_id=9) as emil '+
      'From szervezet a Where a.szervezet_id>-1 ';
    If le_szervezet.Text<>'' Then
       SQL.Add('and a.szervezet_nev like '+IDCHAR+'%'+StringReplace(le_szervezet.Text,' ','%',[rfReplaceAll])+'%'+IDCHAR+' ');
    If le_adoszam.Text<>'' Then
       SQL.Add('and a.adoszam like '+IDCHAR+le_adoszam.Text+'%'+IDCHAR+' ');
    SQL.Add('Order By szervezet_nev');
  end;
  With LISTA do
  begin
    Active:=False;
    SQL.Text:=
      'Select a.* '+
      'From JurtaTV_teszt.dbo.Nberlok a Where a.aktiv=1 ';
    If le_jurtanev.Text<>'' Then
       SQL.Add('and a.nev like '+IDCHAR+'%'+StringReplace(le_jurtanev.Text,' ','%',[rfReplaceAll])+'%'+IDCHAR+' ');
    If le_jurtaado.Text<>'' Then
       SQL.Add('and a.adoszam like '+IDCHAR+le_jurtaado.Text+'%'+IDCHAR+' ');
    SQL.Add('Order By nev');
  end;
  inherited;
  LISTA.Active:=True;
end;

procedure Tf_SzervezetKeres.bb_kilepClick(Sender: TObject);
begin
  inherited;
  If SZURES.Active Then
  begin
    SZER_NEV:=SZURES.FieldByName('szervezet_nev').AsString;
    SZER_ID:=SZURES.FieldByName('szervezet_id').AsString;
  end
  else
  begin
    SZER_NEV:='';
    SZER_ID:='';
  end;
end;

procedure Tf_SzervezetKeres.bb_ujClick(Sender: TObject);
begin
  inherited;
  HIVO:=2;
//  AblakNyit(Tf_SzervezetAdat, TForm(f_SzervezetAdat));
  HIVO:=0;
  FrissitesTeljes(SZURES,SZER_ID,'szervezet_id');
  le_szervezet.Text:=SZER_NEV;
  bb_keresClick(Self);
end;

procedure Tf_SzervezetKeres.BitBtn1Click(Sender: TObject);
var s: String;
begin
  inherited;
  if LISTA.FieldByName('tipus').AsString='Személy' then s:='42' else s:='';

  Modositas('szervezet',[
    'adoszam='+LISTA.FieldByName('adoszam').AsString,
    'cegjegyzekszam='+LISTA.FieldByName('cegjegyzekszam').AsString,
    'jurta_kod='+LISTA.FieldByName('kod').AsString,
    'szervezet_tipus_id='+s
  ],'szervezet_id='+SZER_ID);
end;

procedure Tf_SzervezetKeres.BitBtn2Click(Sender: TObject);
begin
  inherited;
  le_jurtanev.Text:=le_szervezet.Text;
  le_jurtaado.Text:=le_adoszam.Text;
end;

procedure Tf_SzervezetKeres.dbg_listaCellClick(Column: TColumn);
begin
  inherited;
  If (SZER_ID<>'') and (SZURES.State<>dsInactive) Then
  begin
    HIVO:=1;
    AblakNyit(Tf_SzervezetAdat,TForm(f_SzervezetAdat));
    le_szervezet.Text:=SZER_NEV;
    FrissitesTeljes(SZURES,SZER_ID,'szervezet_id');
  end;
end;

procedure Tf_SzervezetKeres.dbg_listaDblClick(Sender: TObject);
begin
  inherited;
//  If (SZER_ID<>'') and (SZURES.State<>dsInactive) Then
//  begin
//    HIVO:=1;
////    AblakNyit(Tf_SzervezetAdat,TForm(f_SzervezetAdat));
//    le_szervezet.Text:=SZER_NEV;
//    FrissitesTeljes(SZURES,SZER_ID,'szervezet_id');
//    inherited;
//  end;
end;

procedure Tf_SzervezetKeres.FormShow(Sender: TObject);
begin
  inherited;
  SZER_NEV:='';
  SZER_ID:='';
end;

procedure Tf_SzervezetKeres.SZURESAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SZER_EMIL:=SZURES.FieldByName('emil').AsString;
  SZER_CIM:=SZURES.FieldByName('cim').AsString;
  SZER_NEV:=SZURES.FieldByName('szervezet_nev').AsString;
  SZER_ID:=SZURES.FieldByName('szervezet_id').AsString;
end;

end.
