unit AnalyzerU;

interface

uses
  SysUtils, StdCtrls, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls;

type
  TAForm = class(TForm)
    LabelHeading: TLabel;
    OpenDialog1: TOpenDialog;
    ButtonOpen: TButton;
    PageControl1: TPageControl;
    SheetParsed: TTabSheet;
    SheetRaw: TTabSheet;
    ListRAW: TListBox;
    SheetAbout: TTabSheet;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    EditPwdEncM: TEdit;
    Label3: TLabel;
    EditPwdM: TEdit;
    Label4: TLabel;
    LabelPwdAsk: TLabel;
    GroupBox2: TGroupBox;
    EditUUID: TEdit;
    EditMAC: TEdit;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    MemoOEM: TMemo;
    LabelContinent: TLabel;
    GroupBox4: TGroupBox;
    EditName: TEdit;
    Label6: TLabel;
    EditRev: TEdit;
    Edit4char: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    EditSerial: TEdit;
    Label9: TLabel;
    EditDateMan: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    MemoAbout: TMemo;
    LabelCountry: TLabel;
    EditPwdEncU: TEdit;
    EditPwdU: TEdit;
    LabelPwdSetM: TLabel;
    LabelPwdSetU: TLabel;
    SheetSMBus: TTabSheet;
    GroupBox5: TGroupBox;
    ButtonPCIScan: TButton;
    LabelStatus: TLabel;
    GroupSMBus: TGroupBox;
    ButtonSMBScan: TButton;
    ButtonSMBRead: TButton;
    LabelSMBStatus: TLabel;
    LabelSMBScan: TLabel;
    Label13: TLabel;
    ComboSMB: TComboBox;
    ButtonSaveDump: TButton;
    SaveDialog1: TSaveDialog;
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonPCIScanClick(Sender: TObject);
    procedure ButtonSMBReadClick(Sender: TObject);
    procedure ButtonSMBScanClick(Sender: TObject);
    procedure ButtonSaveDumpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AForm: TAForm;

implementation

uses SMBus, ZLPortIO;

var
  MyPCI: PCI_Info;
  raw: array[0..255] of byte;

{$R *.dfm}

procedure ShowRAW(x: array of byte);
var i: integer;
    tmph, tmpb: string;
begin
  tmph := '';
  tmpb := '';
  AForm.ListRAW.Clear;
  for i:=0 to 255 do begin
    tmph := tmph + ' ' + IntToHex(x[i], 2);
    if (x[i] IN [$20..$FF]) then tmpb := tmpb + Chr(x[i]) else tmpb := tmpb + '.';
    if ((i+1) MOD 16 = 0) then begin
      AForm.ListRAW.Items.Add(Trim(tmph)+' '+Trim(tmpb));
      tmph := '';
      tmpb := '';
    end;
  end;
end;

procedure EDL(o: TLabel; state: boolean);
// Enable/Disable Label
begin
  if state then begin
    o.Enabled := true;
    o.Font.Style := [fsBold];
    o.Font.Color := clGreen;
  end else begin
    o.Enabled := false;
    o.Font.Style := [];
    o.Font.Color := clBlack;
  end;
end;

function GetText(x: array of byte; pf, pt: integer): string;
var i: integer;
begin
  Result := '';
  for i:=pf to pt do if (x[i]>0) then Result := Result + Chr(x[i]) else Break;
end;

function GetHex(x: array of byte; pf, pt: integer; sep: boolean = true): string;
var i: integer;
begin
  Result := '';
  for i:=pf to pt do if sep then Result := Result + ' ' + IntToHex(x[i],2) else Result := Result + IntToHex(x[i],2);
  Result := Trim(Result);
end;

procedure CheckPwd(x: array of byte);
var i: integer;
    tmph: string;
    isset: boolean;
begin
  // Machine password
  isset := false;
  tmph := '';
  for i:=$00 to $06 do begin
    if (x[i]>0) then isset := true;
    tmph := tmph + ' ' + IntToHex(x[i], 2);
  end;
  AForm.EditPwdEncM.Text := Trim(tmph);
  AForm.EditPwdEncM.Enabled := isset;
  EDL(AForm.LabelPwdSetM, isset);

  if isset then begin
    tmph := '';
    for i:=$00 to $06 do begin
      tmph := tmph + Chr((x[i] DIV 2));
    end;
    AForm.EditPwdM.Text := tmph;
  end else AForm.EditPwdM.Text := '.......';
  AForm.EditPwdM.Enabled := isset;

  // User password
  isset := false;
  tmph := '';
  for i:=$07 to $0d do begin
    if (x[i]>0) then isset := true;
    tmph := tmph + ' ' + IntToHex(x[i], 2);
  end;
  AForm.EditPwdEncU.Text := Trim(tmph);
  AForm.EditPwdEncU.Enabled := isset;
  EDL(AForm.LabelPwdSetU, isset);

  if isset then begin
    tmph := '';
    for i:=$07 to $0d do begin
      tmph := tmph + Chr((x[i] DIV 2));
    end;
    AForm.EditPwdU.Text := tmph;
  end else AForm.EditPwdU.Text := '.......';
  AForm.EditPwdU.Enabled := isset;

  if (x[$0f]=$4E) OR (x[$0f]=$FF) then EDL(AForm.LabelPwdAsk, true) else EDL(AForm.LabelPwdAsk, false);
end;

procedure CheckUUID(x: array of byte);
var i: integer;
    tu, tm: string;
begin
  tu := GetHex(x, $10, $1f, false);
  tm := GetHex(x, $1a, $1f);
  tu := Copy(tu,1,8)+'-'+Copy(tu,9,4)+'-'+Copy(tu,13,4)+'-'+Copy(tu,17,4)+'-'+Copy(tu,21,12);
  for i:=1 to Length(tm) do if tm[i]=' ' then tm[i]:=':';
  AForm.EditUUID.Text := tu;
  AForm.EditMAC.Text := tm;
end;

procedure CheckOEM(x: array of byte);
var toem: string;
begin
  toem := GetText(x, $20, $2f);
  AForm.MemoOEM.Text := toem;
  toem := Copy(toem,1,2);
  if (toem = 'EU') then AForm.LabelContinent.Caption := 'Europe'
    else if (toem = 'UC') then AForm.LabelContinent.Caption := 'North America'
    else if (toem = 'JP') then AForm.LabelContinent.Caption := 'Japan'
    else AForm.LabelContinent.Caption := '---';
end;

procedure CheckMachine(x: array of byte);
var i: integer;
    mn, cc: string;
    isin: boolean;
begin
  mn := GetText(x, $80, $9f);
  AForm.EditName.Text := mn;
  AForm.EditRev.Text := GetText(x, $a0, $a9);
  AForm.Edit4char.Text := GetText(x, $aa, $ad);
  AForm.EditSerial.Text := GetText(x, $c0, $df);
  AForm.EditDateMan.Text := GetText(x, $e0, $f2);

  cc := '';
  isin := false;
  for i:=1 to Length(mn) do begin
    if (mn[i]=')') then break;
    if isin then cc := cc + mn[i];
    if (mn[i]='(') then isin := true;
  end;
  if (cc = 'FR') then AForm.LabelCountry.Caption := 'France'
    else if (cc = 'GB') then AForm.LabelCountry.Caption := 'Great Britain'
    else if (cc = 'DE') then AForm.LabelCountry.Caption := 'Germany'
    else if (cc = 'UC') then AForm.LabelCountry.Caption := 'United States of America'
    else if (cc = 'J') then AForm.LabelCountry.Caption := 'Japan'
    else AForm.LabelCountry.Caption := '---';
end;

procedure DoAnalysis(d: array of byte);
begin
  CheckPwd(d);
  CheckUUID(d);
  CheckOEM(d);
  CheckMachine(d);
end;

procedure TAForm.ButtonOpenClick(Sender: TObject);
var f: file of byte;
    d: array[0..255] of byte;
    i: integer;
begin
  if OpenDialog1.Execute then begin
    AssignFile(f, OpenDialog1.FileName);
    Reset(f);
    for i:=0 to 255 do begin
      Read(f,d[i]);
      raw[i] := d[i];
    end;
    CloseFile(f);
    ShowRAW(d);
    DoAnalysis(d);
    AForm.PageControl1.ActivePageIndex := 0;
  end;
end;

procedure EnableGroup(grp: TGroupBox; new: boolean);
var i: integer;
begin
  for i:=0 to grp.ControlCount-1 do grp.Controls[i].Enabled := new;
  grp.Enabled := new;
end;

procedure TAForm.ButtonPCIScanClick(Sender: TObject);
begin
  if ZlIOStarted then begin
    Screen.Cursor := crHourGlass;
    MyPCI := Scan_PCI(Application, AForm.LabelStatus);
    Screen.Cursor := crDefault;
    if (MyPCI.SMB_Address <> 0) AND (MyPCI.Vendor_Name <> '') then begin
      AForm.LabelStatus.Caption := 'SMBus-Controller: '+MyPCI.Vendor_Name+' '+MyPCI.Device_Name+' Rev '+IntToStr(MyPCI.Rev)+' at addr 0x'+IntToHex(MyPCI.SMB_Address,4);
      EnableGroup(AForm.GroupSMBus, true);
    end;
  end else ShowMessage('The driver ZLPORTIO.SYS could not be loaded. The program won''t be able to read out SMBus under Windows NT/2000/XP! Make sure, the file is in path or in the program directory.');
end;

function PowerInt(base, exp: integer): Int64;
begin
  if (exp = 0) then Result := 1 else begin
    Result := base;
    while (exp>1) do begin
      Result := Result * base;
      Dec(exp);
    end;
  end;
end;

function HexToInt(x: string): int64;
const hexset = '0123456789abcdef';
var i, p: integer;
begin
  Result := 0;
  if Length(x)<=8 then begin
    x := LowerCase(x);
    i := Pos('0x', x);
    if (i>0) then Delete(x, 1, i+1);
    for i:=1 to Length(x) do begin
      p := Pos(x[i], hexset)-1;
      if (p>0) then Result := Result + p*PowerInt(16, Length(x)-i);
    end;
  end;
end;

procedure TAForm.ButtonSMBReadClick(Sender: TObject);
var i: integer;
    dev: word;
    d: TSMBData;
begin
  dev := HexToInt(AForm.ComboSMB.Text);
  Screen.Cursor := crHourGlass;
  for i:=0 to 255 do begin
    AForm.LabelSMBStatus.Caption := 'Now reading offset 0x'+IntToHex(i,2)+' ...';
    Application.ProcessMessages;
    d[i] := smbGetReg(MyPCI.SMB_Address, i, dev);
    raw[i] := d[i];
  end;
  Screen.Cursor := crDefault;
  ShowRAW(d);
  if dev=$57 then begin
    DoAnalysis(d);
    AForm.PageControl1.ActivePageIndex := 0;
  end else begin
    AForm.PageControl1.ActivePageIndex := 1;
  end;
end;

procedure TAForm.ButtonSMBScanClick(Sender: TObject);
begin
  AForm.LabelSMBScan.Caption := 'Not yet functioning';
end;

procedure TAForm.ButtonSaveDumpClick(Sender: TObject);
var f: file of byte;
    i: integer;
begin
  if SaveDialog1.Execute then begin
    AssignFile(f, SaveDialog1.FileName);
    Rewrite(f);
    for i:=0 to 255 do Write(f,raw[i]);
    CloseFile(f);
  end;
end;

procedure TAForm.FormShow(Sender: TObject);
var i: integer;
begin
  for i:=0 to 255 do raw[i] := 0;
end;

end.
