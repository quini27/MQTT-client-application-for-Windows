object FormMQTT: TFormMQTT
  Left = 0
  Top = 0
  Caption = 'MQTT Broker test'
  ClientHeight = 365
  ClientWidth = 623
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LedSha2: TShape
    Left = 389
    Top = 30
    Width = 22
    Height = 22
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Brush.Color = clGray
    Pen.Color = clGray
    Shape = stCircle
  end
  object LabelConn: TLabel
    Left = 344
    Top = 65
    Width = 101
    Height = 16
    Caption = 'Connection status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LedShape: TShape
    Left = 392
    Top = 33
    Width = 16
    Height = 16
    Brush.Color = clMaroon
    Shape = stCircle
  end
  object LabelBroker: TLabel
    Left = 24
    Top = 16
    Width = 42
    Height = 16
    Caption = 'Broker:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 60
    Height = 16
    Caption = 'Port: 1883'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object MemoLog: TMemo
    Left = 0
    Top = 180
    Width = 623
    Height = 185
    Align = alBottom
    Color = clNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Memo Log')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = MemoLogChange
  end
  object Edit1: TEdit
    Left = 14
    Top = 146
    Width = 489
    Height = 21
    TabOrder = 1
  end
  object SendBtn: TButton
    Left = 509
    Top = 146
    Width = 106
    Height = 21
    Caption = 'Send Message'
    Enabled = False
    TabOrder = 2
    OnClick = SendBtnClick
  end
  object ConnectBtn: TButton
    Left = 16
    Top = 80
    Width = 113
    Height = 49
    Caption = 'Connect'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = ConnectBtnClick
  end
  object DisconnectBtn: TButton
    Left = 127
    Top = 80
    Width = 106
    Height = 49
    Caption = 'Disconnect'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = DisconnectBtnClick
  end
  object BrokerBoxName: TComboBox
    Left = 96
    Top = 15
    Width = 161
    Height = 21
    ItemIndex = 0
    TabOrder = 5
    Text = '/'
    OnChange = BrokerBoxNameChange
    Items.Strings = (
      'test.mosquitto.org'
      'broker.hivemq.com'
      'iot.eclipse.com'
      'mqtt.fluux.io'
      'test.mosca.io'
      'broker.mqttdashboard.com')
  end
  object TMSMQTTClient1: TTMSMQTTClient
    BrokerHostName = 'test.mosquitto.org'
    OnConnectedStatusChanged = TMSMQTTClient1ConnectedStatusChanged
    OnPublishReceived = TMSMQTTClient1PublishReceived
    Version = '1.1.0.2'
    Left = 560
    Top = 40
  end
end
