object AForm: TAForm
  Left = 192
  Top = 107
  Width = 517
  Height = 407
  Caption = 'SONY VAIO 0x57 Analyzer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelHeading: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 29
    Caption = 'SONY VAIO 0x57 Analyzer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = True
  end
  object ButtonOpen: TButton
    Left = 368
    Top = 8
    Width = 129
    Height = 25
    Caption = 'Open dump...'
    TabOrder = 0
    OnClick = ButtonOpenClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 48
    Width = 497
    Height = 329
    ActivePage = SheetAbout
    TabOrder = 1
    object SheetParsed: TTabSheet
      Caption = 'Parsed info'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 0
        Width = 417
        Height = 89
        Caption = 'Password'
        TabOrder = 0
        object Label3: TLabel
          Left = 9
          Top = 28
          Width = 79
          Height = 13
          Caption = 'Encrypted bytes:'
        end
        object Label4: TLabel
          Left = 37
          Top = 51
          Width = 49
          Height = 13
          Caption = 'Password:'
        end
        object LabelPwdAsk: TLabel
          Left = 8
          Top = 72
          Width = 401
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = 'Ask for password at startup'
          Enabled = False
        end
        object LabelPwdSetM: TLabel
          Left = 88
          Top = 11
          Width = 153
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = 'Machine password'
          Enabled = False
        end
        object LabelPwdSetU: TLabel
          Left = 256
          Top = 11
          Width = 153
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = 'User password'
          Enabled = False
        end
        object EditPwdEncM: TEdit
          Left = 88
          Top = 24
          Width = 153
          Height = 22
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Text = '00 00 00 00 00 00 00'
        end
        object EditPwdM: TEdit
          Left = 88
          Top = 48
          Width = 57
          Height = 22
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Text = '.......'
        end
        object EditPwdEncU: TEdit
          Left = 256
          Top = 24
          Width = 153
          Height = 22
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          Text = '00 00 00 00 00 00 00'
        end
        object EditPwdU: TEdit
          Left = 256
          Top = 48
          Width = 57
          Height = 22
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          Text = '.......'
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 96
        Width = 281
        Height = 65
        Caption = 'UUID'
        TabOrder = 1
        object Label5: TLabel
          Left = 9
          Top = 44
          Width = 69
          Height = 13
          Caption = 'Ethernet MAC:'
        end
        object EditUUID: TEdit
          Left = 8
          Top = 16
          Width = 265
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Text = '........-....-....-....-............'
        end
        object EditMAC: TEdit
          Left = 80
          Top = 40
          Width = 129
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Text = '00:00:00:00:00:00'
        end
      end
      object GroupBox3: TGroupBox
        Left = 304
        Top = 96
        Width = 137
        Height = 65
        Caption = 'OEM Info'
        TabOrder = 2
        object LabelContinent: TLabel
          Left = 8
          Top = 40
          Width = 121
          Height = 13
          Alignment = taCenter
          AutoSize = False
          Caption = '---'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object MemoOEM: TMemo
          Left = 8
          Top = 16
          Width = 121
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          Lines.Strings = (
            '................')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 168
        Width = 337
        Height = 121
        Caption = 'Machine'
        TabOrder = 3
        object Label6: TLabel
          Left = 8
          Top = 24
          Width = 73
          Height = 13
          Caption = 'Machine name:'
        end
        object Label7: TLabel
          Left = 248
          Top = 24
          Width = 44
          Height = 13
          Caption = 'Revision:'
        end
        object Label8: TLabel
          Left = 229
          Top = 93
          Width = 56
          Height = 13
          Caption = 'Code: PCG-'
        end
        object Label9: TLabel
          Left = 10
          Top = 68
          Width = 67
          Height = 13
          Caption = 'Serial number:'
        end
        object Label10: TLabel
          Left = 9
          Top = 91
          Width = 73
          Height = 13
          Caption = 'Date of manuf.:'
        end
        object LabelCountry: TLabel
          Left = 84
          Top = 24
          Width = 157
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '---'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditName: TEdit
          Left = 8
          Top = 40
          Width = 233
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          Text = '................................'
        end
        object EditRev: TEdit
          Left = 248
          Top = 40
          Width = 81
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
          Text = '..........'
        end
        object Edit4char: TEdit
          Left = 288
          Top = 88
          Width = 41
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          Text = '....'
        end
        object EditSerial: TEdit
          Left = 88
          Top = 64
          Width = 241
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
          Text = '00000000-0000000................'
        end
        object EditDateMan: TEdit
          Left = 88
          Top = 88
          Width = 137
          Height = 22
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 4
          Text = '..................'
        end
      end
    end
    object SheetRaw: TTabSheet
      Caption = 'RAW view'
      ImageIndex = 1
      object ListRAW: TListBox
        Left = 0
        Top = 4
        Width = 489
        Height = 241
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
      end
      object ButtonSaveDump: TButton
        Left = 192
        Top = 248
        Width = 89
        Height = 25
        Caption = 'Save dump...'
        TabOrder = 1
        OnClick = ButtonSaveDumpClick
      end
    end
    object SheetSMBus: TTabSheet
      Caption = 'SMBus'
      ImageIndex = 3
      object GroupBox5: TGroupBox
        Left = 0
        Top = 0
        Width = 489
        Height = 41
        Caption = 'PCI Information / SMBus Controller'
        TabOrder = 0
        object LabelStatus: TLabel
          Left = 48
          Top = 18
          Width = 433
          Height = 13
          AutoSize = False
          Caption = 'Push button to scan PCI bus for SMBus controller.'
        end
        object ButtonPCIScan: TButton
          Left = 8
          Top = 16
          Width = 33
          Height = 17
          Caption = 'Scan'
          TabOrder = 0
          OnClick = ButtonPCIScanClick
        end
      end
      object GroupSMBus: TGroupBox
        Left = 0
        Top = 56
        Width = 489
        Height = 129
        Caption = 'SMBus'
        TabOrder = 1
        object LabelSMBStatus: TLabel
          Left = 88
          Top = 48
          Width = 393
          Height = 13
          AutoSize = False
          Caption = 'Push button to read selected SMBus device.'
          Enabled = False
        end
        object LabelSMBScan: TLabel
          Left = 165
          Top = 20
          Width = 316
          Height = 13
          AutoSize = False
          Caption = 'Push button to scan SMBus for devices.'
          Enabled = False
        end
        object Label13: TLabel
          Left = 10
          Top = 19
          Width = 37
          Height = 13
          Caption = 'Device:'
          Enabled = False
        end
        object ButtonSMBScan: TButton
          Left = 116
          Top = 16
          Width = 45
          Height = 21
          Caption = 'Scan'
          Enabled = False
          TabOrder = 0
          OnClick = ButtonSMBScanClick
        end
        object ButtonSMBRead: TButton
          Left = 8
          Top = 40
          Width = 75
          Height = 25
          Caption = 'Read'
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = ButtonSMBReadClick
        end
        object ComboSMB: TComboBox
          Left = 56
          Top = 16
          Width = 57
          Height = 21
          Enabled = False
          ItemHeight = 13
          TabOrder = 2
          Text = '0x57'
          Items.Strings = (
            '0x57')
        end
      end
    end
    object SheetAbout: TTabSheet
      Caption = 'About'
      ImageIndex = 2
      object Label2: TLabel
        Left = 56
        Top = 248
        Width = 377
        Height = 41
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'A BIG *THANKS* goes to Jean Delvare for his collected infos abou' +
          't the SONY VAIO EEPROM.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label11: TLabel
        Left = 80
        Top = 280
        Width = 327
        Height = 13
        Caption = 
          'check out http://www.ensicaen.ismra.fr/~delvare/ for his homepag' +
          'e.'
      end
      object Label12: TLabel
        Left = 88
        Top = 224
        Width = 312
        Height = 13
        Caption = 'This program was written by Markus Birth <mbirth@webwriters.de>'
        Enabled = False
      end
      object MemoAbout: TMemo
        Left = 88
        Top = 8
        Width = 313
        Height = 209
        Color = clMenu
        Ctl3D = False
        Lines.Strings = (
          'This program was written after playing around with a SONY '
          'VAIO notebook trying to find out the Power On Password.'
          ''
          'After spending lots of hours searching the internet and trying '
          'different tricks, I found Jean Delvare'#39's homepage[1] with infos '
          'about the format of the data stored in the security eeprom. '
          'Jean also wrote the eeprom-module[2] for lm-sensors[3] for '
          'Linux. He mentioned that the eeprom is easily accessible via '
          'the SMBus interface.'
          ''
          'Since I didn'#39't want to hassle around with reading out the '
          'SMBus, I - again - searched the internet and read that there '
          'should be a utilty called GETSMBUS.EXE to read out SMBus '
          'components included in the DOS-version of HWiNFO[4].'
          ''
          'I downloaded the package, put the GETSMBUS.EXE onto a '
          'FAT32-partition, booted from an old Win98-CD (press F5 at '
          'CD-ROM-Support-Selection!) and ran GETSMBUS.EXE. It '
          'created the 4 files SMBUS34.DAT, SMBUS54.DAT, SMBUS'
          '57.DAT and SMBUS69.DAT. From Jean'#39's homepage I knew '
          'the address of the security eeprom was 0x57 - so the file '
          'SMBUS57.DAT was the one.'
          ''
          'You can use this program to parse the file and extract the '
          
            'interesting information. Also the password is decrypted, just in' +
            ' '
          'case you forgot your machine password.'
          ''
          '2004-03-31: added support for reading out the SMBus directly '
          'from Windows. Make sure the file ZLPORTIO.SYS is in this '
          'program'#39's directory or in the search path.'
          ''
          'Have fun!'
          ''
          ''
          '[1] http://www.ensicaen.ismra.fr/~delvare/'
          '[2] http://www.ensicaen.ismra.fr/~delvare/vaio/'
          '[3] http://www.lm-sensors.nu'
          '[4] http://www.hwinfo.com')
        ParentCtl3D = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Sony 0x57 dump|SMBUS57.DAT|Other dumps (*.DAT)|*.DAT|All files (' +
      '*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Left = 336
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Filter = 
      'Sony 0x57 dump|SMBUS57.DAT|Other dumps (*.DAT)|*.DAT|All files (' +
      '*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 288
    Top = 8
  end
end
