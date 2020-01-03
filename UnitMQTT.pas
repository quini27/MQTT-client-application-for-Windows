(*****************************************************************************)
{    Project MQTT broker test
    VCL Application to test a connection with a MQTT Broker
    There must be chosen a free MQTT broker, as
    "test.mosquitto.org"; //"broker.hivemq.com";  //"iot.eclipse.com";
    //"mqtt.fluux.io"; //"test.mosca.io"; //"broker.mqttdashboard.com";,
    and the port is the open MQTT port 1883
    To test this application the sketch test_eclipse.ino must be previously stored on the IoT board.
    The topics that the IoT board publishes are Estado/Led, Estado/Botao and TopicIoTboard71,
    and its subscribes to the topic MessFromClient71.
    According to the message sent from this application, the IoT board put on/off the led, returns the button state,
    and prints the request on the serial monitor.  }
    //      Copyright: Fernando Pazos
    //      december 2019
(*****************************************************************************)

unit UnitMQTT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TMS.MQTT.Global, Vcl.StdCtrls,
  TMS.MQTT.Client, Vcl.ExtCtrls, Vcl.Menus;

type
  TFormMQTT = class(TForm)
    TMSMQTTClient1: TTMSMQTTClient;
    MemoLog: TMemo;
    Edit1: TEdit;
    SendBtn: TButton;
    ConnectBtn: TButton;
    LedSha2: TShape;
    LabelConn: TLabel;
    LedShape: TShape;
    DisconnectBtn: TButton;
    LabelBroker: TLabel;
    Label1: TLabel;
    BrokerBoxName: TComboBox;
    procedure MemoLogChange(Sender: TObject);
    procedure SendBtnClick(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure TMSMQTTClient1ConnectedStatusChanged(ASender: TObject;
      const AConnected: Boolean; AStatus: TTMSMQTTConnectionStatus);
    procedure TMSMQTTClient1PublishReceived(ASender: TObject; APacketID: Word;
      ATopic: string; APayload: TArray<System.Byte>);
    procedure DisconnectBtnClick(Sender: TObject);
    procedure BrokerBoxNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMQTT: TFormMQTT;

implementation

{$R *.dfm}

//event executed when a broker URL is selected from the list box
procedure TFormMQTT.BrokerBoxNameChange(Sender: TObject);
begin
    TMSMQTTClient1.BrokerHostName:=BrokerBoxName.Text;
end;

//Event executed when the Connect button is pressed
procedure TFormMQTT.ConnectBtnClick(Sender: TObject);
begin
    TMSMQTTClient1.Connect();
end;

//Event executed when the disconnect button os pressed
procedure TFormMQTT.DisconnectBtnClick(Sender: TObject);
begin
    TMSMQTTClient1.Disconnect();
end;

//EVENT executed when MemoLog is on change to scroll the memoLog until the last row
procedure TFormMQTT.MemoLogChange(Sender: TObject);
begin
  SendMessage(MemoLog.Handle, EM_LINESCROLL, 0,MemoLog.Lines.Count);
end;

//Event executed when the Send button os pressed
procedure TFormMQTT.SendBtnClick(Sender: TObject);
begin
  if Edit1.Text<>'' then
     begin
        TMSMQTTClient1.Publish('MessFromClient71',Edit1.Text);
        Edit1.Text:='';
     end;
end;

//Event executed when the Connection state changes
//It toggles the connect and disconnect enabled status, and put on/off the drawn led
//prints on the memo log window the connection status.
//when connected, subscribes to the topics Estado/Led, Estado/Botao and TopicIoTboard71
procedure TFormMQTT.TMSMQTTClient1ConnectedStatusChanged(ASender: TObject;
  const AConnected: Boolean; AStatus: TTMSMQTTConnectionStatus);
begin
    if (AConnected) then
      begin
        ConnectBtn.Enabled:=False;
        BrokerBoxName.Enabled:=False;
        SendBtn.Enabled:=True;
        DisconnectBtn.Enabled:=True;
        TMSMQTTClient1.Subscribe('Estado/Led');
        TMSMQTTClient1.Subscribe('Estado/Botao');
        TMSMQTTClient1.Subscribe('TopicIoTboard71');
        LedShape.Brush.Color:=clRed;
        MemoLog.Lines.Add('Client connected to server '+TMSMQTTClient1.BrokerHostName+' at '+FormatDateTime('hh:nn:ss', Now));
      end
      else
      begin
        ConnectBtn.Enabled:=True;
        BrokerBoxName.Enabled:=True;
        SendBtn.Enabled:=False;
        DisconnectBtn.Enabled:=False;
        LedShape.Brush.Color:=clMaroon;
        MemoLog.Lines.Add('Client disconnected from server '+TMSMQTTClient1.BrokerHostName+' at '+FormatDateTime('hh:nn:ss', Now));
        case AStatus of
          csNotConnected: MemoLog.Lines.Add('Client not connected');
          //csConnectionRejected_InvalidProtocolVersion: ;
          //csConnectionRejected_InvalidIdentifier: ;
          csConnectionRejected_ServerUnavailable: MemoLog.Lines.Add('Server Unavailable');
          //csConnectionRejected_InvalidCredentials: ;
          csConnectionRejected_ClientNotAuthorized: MemoLog.Lines.Add('Client not authorized');
          csConnectionLost: MemoLog.Lines.Add('Connection lost');
          //csConnecting: ;
          //csReconnecting: ;
          //csConnected: ;
        end;
      end;

end;


//Event executed when a message is received from the publisher (IoT board)
//It prints the received message on the Memo Log window
procedure TFormMQTT.TMSMQTTClient1PublishReceived(ASender: TObject;
  APacketID: Word; ATopic: string; APayload: TArray<System.Byte>);
  var msg:string;
begin
  msg := TEncoding.UTF8.GetString(APayload);
  MemoLog.Lines.Add('Message received from the publisher ['+ATopic+']: '+msg);
end;

end.
