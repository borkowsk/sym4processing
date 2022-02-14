//Declaration common for client and server
//Use link script for make symbolic connections to gameServer & gameClient directories
//String  serverIP="127.0.0.1";
String  serverIP="192.168.55.201";
int     servPORT=5204;
String  gameName="gameTemplate";

public enum Opts { NOPE,
                   HELLO,//First message
                   IAM,//I am "name of server/name of client"
                   //FROM SERVER MESSAGES
                   EUC1D,//Euclidean position float(X) "class name of object or name of player"
                   EUC2D,//Euclidean position float(X) float(Y) "class name of object or name of player"
                   EUC3D,//Euclidean position float(X) float(Y) float(H) "class name of object or name of player"
                   POL1D,//Polar position float(Alfa +-180) "class name of object or name of player"
                   POL2D,//Polar position float(Alfa +-180) float(DISTANCE) "class name of object or name of player"
                   POL3D,//Polar position float(Alfa +-180) float(DISTANCE) float(Beta +-180) "class name of object or name of player"
                   //FROM CLIENT MESSAGES
                   TURNL,//Turn left
                   TURNR,//Turn right
                   FORW,//Forward
                   BACK,//Backward
                   MY_ACT,//Player action "name of action"
                   //FINAL - before clossing connection
                   END 
                 };
                   
                   
