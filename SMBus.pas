unit SMBus;

interface

  uses Forms, StdCtrls, ZLPortIO;

  type
    PCI_Info = record
      Vendor_ID: word;
      Vendor_Name: string;
      Device_ID: word;
      Device_Name: string;
      Rev: byte;
      Bus: byte;
      Dev: byte;
      Fun: byte;
      SMB_Address: word;
    end;
    TSMBData = array[0..255] of byte;

    function Scan_PCI(Application: TApplication; Status: TLabel): PCI_Info;
    function smbGetReg(BaseAddr: word; Reg: byte; Slave: byte): word;
    function smbGetArray(BaseAddr: word; regfrom: byte; Slave: byte; regto: byte): TSMBData;

implementation

uses SysUtils;

const
  RW_WRITE = 0;
  RW_READ = 1;

// function DlPortReadPortUchar(Port: cardinal): cardinal; stdcall; external'dlportio.dll';
// function DlPortReadPortUlong(Port: cardinal): cardinal; stdcall; external'dlportio.dll';
// procedure DlPortWritePortUchar(Port: cardinal; Value: cardinal); stdcall; external'dlportio.dll';
// procedure DlPortWritePortUlong(Port: cardinal; Value: cardinal); stdcall; external'dlportio.dll';

// http://www.tsgroup.it/smbus/index.htm
function Get_PCI_Reg(Bus: cardinal;Dev: cardinal;Fun: cardinal;Reg: cardinal): cardinal;
var
  cc, t: cardinal;
begin
  cc := $80000000;
  cc := cc or ((Bus and $FF) shl 16);//Bus
  cc := cc or ((Dev and $1F) shl 11);//Dev
  cc := cc or ((Fun and $07) shl 8);//func
  cc := cc or ((Reg and $FC));//Reg
  //t := DlPortReadPortUlong($CF8);
  //DlPortWritePortUlong($CF8, cc);
  //Result := DlPortReadPortUlong($CFC);
  //DlPortWritePortUlong($CF8, t);
  t := PortReadL($CF8);
  PortWriteL($CF8, cc);
  Result := PortReadL($CFC);
  PortWriteL($CF8, t);
end;

// http://www.tsgroup.it/smbus/index.htm
function Get_Info(Data: Longword; Bus: cardinal; Dev: cardinal; Fun: cardinal): PCI_Info;
var PCI_Structure: PCI_Info;
begin
  PCI_Structure.Vendor_ID := Data and $FFFF;
  PCI_Structure.Device_ID := (Data shr 16) and $FFFF;
  PCI_Structure.Bus := Bus;
  PCI_Structure.Dev := Dev;
  PCI_Structure.Fun := Fun;
  case Data of
    $71138086:
      begin
        PCI_Structure.SMB_Address := Get_PCI_Reg(Bus, Dev, Fun, $90) and $FFF0;
        PCI_Structure.Rev := Get_PCI_Reg(Bus, Dev, Fun, 8) and $FF;
        PCI_Structure.Vendor_Name := 'Intel®';
        PCI_Structure.Device_Name := '82371AB/EB (PIIX4)';
      end;
    $24138086:
      begin
        PCI_Structure.SMB_Address := Get_PCI_Reg(Bus, Dev, Fun, $20) and $FFF0;
        PCI_Structure.Rev := Get_PCI_Reg(Bus, Dev, Fun, 8) and $FF;
        PCI_Structure.Vendor_Name := 'Intel®';
        PCI_Structure.Device_Name := '82801AA/ICH';
      end;
    $24238086:
      begin
        PCI_Structure.SMB_Address := Get_PCI_Reg(Bus, Dev, Fun, $20) and $FFF0;
        PCI_Structure.Rev := Get_PCI_Reg(Bus, Dev, Fun, 8) and $FF;
        PCI_Structure.Vendor_Name := 'Intel®';
        PCI_Structure.Device_Name := '82801AB/ICH0';
      end;
    $24438086:
      begin
        PCI_Structure.SMB_Address := Get_PCI_Reg(Bus, Dev, Fun, $20) and $FFF0;
        PCI_Structure.Rev := Get_PCI_Reg(Bus, Dev, Fun, 8) and $FF;
        PCI_Structure.Vendor_Name := 'Intel®';
        PCI_Structure.Device_Name := '82801BA/ICH2';
      end;
    $24C38086:
      begin
        PCI_Structure.SMB_Address := Get_PCI_Reg(Bus, Dev, Fun, $20) and $FFF0;
        PCI_Structure.Rev := Get_PCI_Reg(Bus, Dev, Fun, 8) and $FF;
        PCI_Structure.Vendor_Name := 'Intel®';
        PCI_Structure.Device_Name := '82801DB/DBM';
      end;
    $30571106:
      begin
        PCI_Structure.SMB_Address := Get_PCI_Reg(Bus, Dev, Fun, $90) and $FFF0;
        PCI_Structure.Rev := Get_PCI_Reg(Bus, Dev, Fun, 8) and $FF;
        PCI_Structure.Vendor_Name := 'VIA®';
        PCI_Structure.Device_Name := 'VT82C686A/B';
      end;
  else
    PCI_Structure.SMB_Address := 0;
    PCI_Structure.Rev := 0;
    PCI_Structure.Vendor_Name := '';
    PCI_Structure.Device_Name := '';
  end;
  Result := PCI_Structure;
end;

// http://www.tsgroup.it/smbus/index.htm
function Scan_PCI(Application: TApplication; Status: TLabel): PCI_Info;
var Bus, Dev, Fun: integer;
    Info: PCI_Info;
    Data: Longword;
    loopdone: boolean;
begin
  for Bus := 0 to $FF do begin
    Status.Caption := 'Now scanning Bus 0x'+IntToHex(Bus,2)+' ...';
    Application.ProcessMessages;
    for Dev := 0 to $1F do begin
      for Fun := 0 to $07 do begin
        loopdone := false;
        Data := Get_PCI_Reg(Bus, Dev, Fun, 0); {In Data abbiamo il nostro codice di identificazione oppure nulla (0x0 or 0xFFFFFFFF). Da questo punto si salta alla routine di decodifica del CHIP. }
        if (Data <> $FFFFFFFF) and (Data <> 0) then begin
          Info := Get_Info(Data, Bus, Dev, Fun);
          if Info.Vendor_Name <> '' then Break;
        end;
        loopdone := true;
      end;
      if Info.Vendor_Name <> '' then Break;
    end;
    if Info.Vendor_Name <> '' then Break;
  end;
  if (Info.SMB_Address <> 0) AND (Info.Vendor_Name<>'') AND (NOT loopdone) then begin
    Status.Caption := 'SMBus-Controller found at Bus 0x'+IntToHex(Bus,2)+', Dev 0x'+IntToHex(Dev,2);
  end else begin
    Status.Caption := 'No compatible SMBus-Controller found!';
  end;
  Result := Info;
end;



(******************************************************************************
******* SMBus routines follow                                           *******
******************************************************************************)


procedure smbWaitForFree(BaseAddr: word);
var
  Status: byte;
begin
  //Status := DlPortReadPortUchar(BaseAddr);
  Status := PortReadB(BaseAddr);
  while (Status and 1) <> 0 do begin
    Application.ProcessMessages;
    //Status := DlPortReadPortUchar(BaseAddr);
    Status := PortReadB(BaseAddr);
  end;
  if (Status and $1e) <> 0 then begin
    //DlPortWritePortUchar(BaseAddr, Status);
    PortWriteB(BaseAddr, Status);
  end;
end;

procedure smbWaitForEnd(BaseAddr: word);
var
  Status: byte;
begin
  //Status := DlPortReadPortUchar(BaseAddr);
  Status := PortReadB(BaseAddr);
  while (Status and 1) = 1 do begin
    Application.ProcessMessages;
    //Status := DlPortReadPortUchar(BaseAddr);
    Status := PortReadB(BaseAddr);
  end;
end;

function smbCallBus(BaseAddr: word; CMD: byte; Slave: byte; RW: byte): cardinal;
var
  Dump1: word;
begin
  smbWaitForFree(BaseAddr);
//  DlPortWritePortUchar(BaseAddr + 3, CMD);
//  DlPortWritePortUchar(BaseAddr + 4, (Slave shl 1) or RW);
//  DlPortWritePortUchar(BaseAddr + 2, $48);
  PortWriteB(BaseAddr + 3, CMD);
  PortWriteB(BaseAddr + 4, (Slave shl 1) or RW);
  PortWriteB(BaseAddr + 2, $48);
  Sleep(1);
  smbWaitForEnd(BaseAddr);
//  Dump1 := ( DlPortReadPortUchar(BaseAddr + 6) shl 8);
//  Dump1 := Dump1 or DlPortReadPortUchar(BaseAddr + 5);
  Dump1 := ( PortReadB(BaseAddr + 6) shl 8);
  Dump1 := Dump1 or PortReadB(BaseAddr + 5);
  Result := Dump1;
end;

function smbGetReg(BaseAddr: word; Reg: byte; Slave: byte): word;
var
  Data: cardinal;
begin
  smbWaitForFree(BaseAddr);
//  DlPortWritePortUchar(BaseAddr + 5, 0);
//  DlPortWritePortUchar(BaseAddr + 6, 0);
  PortWriteB(BaseAddr + 5, 0);
  PortWriteB(BaseAddr + 6, 0);
  Data := smbCallBus(BaseAddr, Reg, Slave, RW_READ);
  Result := (Data and $ff);
end;

function smbGetArray(BaseAddr: word; regfrom: byte; Slave: byte; regto: byte): TSMBData;
var Data: cardinal;
    i: byte;
begin
  smbWaitForFree(BaseAddr);
  PortWriteB(BaseAddr + 5, 0);
  PortWriteB(BaseAddr + 6, 0);
  for i:=regfrom to regto do begin
    smbWaitForFree(BaseAddr);
    PortWriteB(BaseAddr + 3, i);
    PortWriteB(BaseAddr + 4, (Slave shl 1) or RW_READ);
    PortWriteB(BaseAddr + 2, $48);
    Sleep(1);
    smbWaitForEnd(BaseAddr);
    Data := ( PortReadB(BaseAddr + 6) shl 8);
    Data := Data or PortReadB(BaseAddr + 5);
    Result[i] := Data AND $FF;
  end;
end;

function smbGetAddress(BaseAddr: word): string;
var
  Data: word;
  Cheque: string;
  idx: integer;
begin
  Cheque := '';
  for idx := $20 to $4F do begin
    smbWaitForFree(BaseAddr);
//    DlPortWritePortUchar(BaseAddr + 5, 0);
//    DlPortWritePortUchar(BaseAddr + 6, 0);
    PortWriteB(BaseAddr + 5, 0);
    PortWriteB(BaseAddr + 6, 0);
    Data := smbCallBus(BaseAddr, 0, idx, RW_READ);
    if (Data and $FF) <> 0 then begin
      Cheque := Cheque + IntToHex(idx,2);
    end;
  end;
  Result := Cheque;
end;

begin

end.