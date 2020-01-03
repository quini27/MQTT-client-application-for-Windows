//Eclipse sketch
// Program to test a MQTT broker as controller and server of an IoT project,
//where an IoT board and a Delphi based application exchange information using
//a MQTT communication protocol.
//Copyright: Fernando Pazos
//December 2019

#include <ESP8266WiFi.h> // Importa a Biblioteca ESP8266WiFi
#include <PubSubClient.h> // Importa a Biblioteca PubSubClient

//defines the id mqtt and topics to publish and subscribe
#define TOPICO_SUBSCRIBE "MessFromClient71"     //topic MQTT to listen
#define TOPICO_PUBLISH   "TopicIoTboard71"    //topic MQTT to send information to the broker. There will be used other topics to publish information


#define ID_MQTT  "MQTTtest1965"     //id mqtt (session identification)

//WIFI
const char* SSID = "Helena";  //"Helena ";       //variable que almacena el nombre de la red wifi a la que el nodemcu se va a conectar
const char* password = "DaniyFercenoura04";     //"cenoura04"; //variable que almacena la seña de la red wifi donde el nodemcu se va a conectar

// MQTT
const char* BROKER_MQTT = "test.mosquitto.org"; //"broker.hivemq.com";  //"iot.eclipse.com"; //"mqtt.fluux.io"; //"test.mosca.io"; //"broker.mqttdashboard.com"; //URL do broker MQTT que se deseja utilizar
int BROKER_PORT = 1883; // Port of the Broker MQTT


//GPIO of the builtin button and the builtin led
#define LED_BUILTIN 2
#define BUTTON_BUILTIN 0
 
//Variáveis e objetos globais
WiFiClient ESPcliente; // Cria o objeto cliente
PubSubClient MQTT(ESPcliente); // Instancia o Cliente MQTT passando o objeto cliente

String request;   //subscriber request


//prototypes
//Function called every time when an information is received
void mqtt_callback(char* topic, byte* payload, unsigned int length);
//function to reconnect the board to the broker when connection is lost
void reconnectMQTT() ;

// put your setup code here, to run once:
void setup() {
  //states the input and output pins
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(BUTTON_BUILTIN,INPUT);
  //digitalWrite(LED_BUILTIN,HIGH);

  //inicializate serial communication
  Serial.begin(115200);
  delay(50);

  //manda al monitor serie el nombre de la red a la cual se conectará
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(SSID);
  // Connect to the WiFi net
  WiFi.begin(SSID, password);


  // Waits for the WiFi connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected"); 
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP()); // Prints the local IP of the local net where the board is connected

   // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");

  //inicializate the MQTT borker  parameters
  //broker address, port and states the callback function (function called wtih an incoming message from the broker)
  MQTT.setServer(BROKER_MQTT, BROKER_PORT);   //informa qual broker e porta deve ser conectado
  MQTT.setCallback(mqtt_callback);            //atribui função de callback (função chamada quando qualquer informação de um dos tópicos subescritos chega)
}




//Function: callback 
//        This function is called every time the information from one of the subscribed topics is arriving
//Parameters: none
//Returns: none
void mqtt_callback(char* topic, byte* payload, unsigned int length) 
{
    Serial.print("Message arrived [");
    Serial.print(topic);
    Serial.print("]: ");
    //String msg;
    //obtem a string do payload recebido
    for(int i = 0; i < length; i++) 
    {
       char c = (char)payload[i];
       request += c;
    }
    Serial.println(request);
}

//Function: reconnectMQTT
//  Reconnect the board with the MQTT broker, if it is not connected yet or if connection fails
//  Subscribes to the topic MessFromClient71
//Parameters: none
//Returns: none

void reconnectMQTT() 
{
    while (!MQTT.connected()) 
    {
        Serial.print(" Trying to connect to the broker MQTT: ");
        Serial.println(BROKER_MQTT);
        if (MQTT.connect(ID_MQTT)) 
        {
            Serial.println("Succesfully connected to broker MQTT!");
            MQTT.publish("TopicIoTboard71","IoT board connected to broker");
            MQTT.subscribe("MessFromClient71"); 
        } 
        else
        {
            Serial.print("Connection lost ");
            Serial.println(MQTT.state());
            Serial.println("Traying again in 2s");
            delay(2000);
        }
    }
}

//char messerver[10];

void loop() {
  // put your main code here, to run repeatedly:
      if (!MQTT.connected()) 
        reconnectMQTT(); //if there is no connection with the broker, it is redone

    // request discrimination
    if (request.indexOf("/LED=ON") != -1)  {
       digitalWrite(LED_BUILTIN, LOW); // Si el pedido es LED=ON, enciende el LED
       MQTT.publish("Estado/Led", "led is on"); //e informa ao subscriber
       Serial.println("Message published in the topic Estado/Led: led is on");
       request='/0';
    }
    if (request.indexOf("/LED=OFF") != -1)  {
       digitalWrite(LED_BUILTIN, HIGH); // Si el pedido es LED=ON, enciende el LED
       MQTT.publish("Estado/Led", "led is off"); //e informa ao subscriber
       Serial.println("Message published in the topic Estado/Led: led is off");
       request='/0';
    }
    if (request.indexOf("/STATEBUTTON") != -1){
       int estado = digitalRead(BUTTON_BUILTIN);               //reads the button state
       if (estado) {
           MQTT.publish("Estado/Botao", "button unpressed");
           Serial.println("Message published in the topic Estado/Botao: button  unpressed");}            //y lo envia al subscriber
       else {
           MQTT.publish("Estado/Botao", "button pressed");
           Serial.println("Message published in the topic Estado/Botao: button pressed");}
       request='/0';
    }
    if (Serial.available()>0){                                    //publishes to subscribers a string written on the serial monitor
       String messerver=Serial.readString();
       char strmess[messerver.length()+1];
       messerver.toCharArray(strmess,messerver.length()+1);     //converts the string into an array of char
       MQTT.publish("TopicIoTboard71",strmess);
       Serial.println("Message published in the topic TopicIoTboard71: "+messerver);}
    //delay(1000);
    

    //keep-alive communication with broker MQTT
    MQTT.loop();
}
