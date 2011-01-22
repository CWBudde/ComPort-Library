object CPortUTestMainForm: TCPortUTestMainForm
  Left = 296
  Top = 308
  Caption = 
    'Unit Test for TComPort Component and CPORTU modifications (W. Po' +
    'stma)'
  ClientHeight = 502
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object TraceMemo: TMemo
    Left = 0
    Top = 41
    Width = 636
    Height = 461
    Align = alClient
    Color = 15659985
    Font.Charset = OEM_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Terminal'
    Font.Style = []
    Lines.Strings = (
      'Insert loopback plug into your serial port,'
      'select the serial port from the combo-box,'
      'and then click Run Test.')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 636
    Height = 41
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 14
      Top = 14
      Width = 44
      Height = 13
      Caption = 'Com Port'
    end
    object LabelResult: TLabel
      Left = 350
      Top = 14
      Width = 99
      Height = 13
      Caption = 'Result: Not Run Yet.'
    end
    object ComComboBox1: TComComboBox
      Left = 64
      Top = 11
      Width = 145
      Height = 21
      ComPort = ComPort1
      ComProperty = cpPort
      Text = 'COM1'
      Style = csDropDownList
      Color = 15659985
      ItemIndex = 0
      TabOrder = 0
    end
    object Button1: TButton
      Left = 215
      Top = 10
      Width = 129
      Height = 25
      Caption = 'Run Test'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    OnAfterOpen = ComPort1AfterOpen
    OnAfterClose = ComPort1AfterClose
    OnBeforeOpen = ComPort1BeforeOpen
    OnBeforeClose = ComPort1BeforeClose
    OnBreak = ComPort1Break
    OnCTSChange = ComPort1CTSChange
    OnDSRChange = ComPort1DSRChange
    OnError = ComPort1Error
    Left = 103
    Top = 168
  end
end
