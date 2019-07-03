//Różne sposoby liczenia odległości +-Euclidesa
//////////////////////////////////////////////////////////////

float distance(float X1,float X2,float Y1,float Y2)
//Często potrzebne w takich programach - domyslny Euklidesowy
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

float distanceEucl(float X1,float X2,float Y1,float Y2)
//Często potrzebne w takich programach
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

double distanceEucl(double X1,double X2,double Y1,double Y2)
//Często potrzebne w takich programach
{
  double dX=X2-X1;
  double dY=Y2-Y1;

  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

float distanceTorus(float X1,float X2,float Y1,float Y2,float Xdd,float Ydd)
// Xdd i Ydd to obwody torusa
{ //println("float torus dist");
  float dX=abs(X2-X1);
  float dY=abs(Y2-Y1);
  if(dX > (Xdd/2) ) dX=Xdd-dX;
  if(dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}

double distanceTorus(double X1,double X2,double Y1,double Y2,double Xdd,double Ydd)
// Xdd i Ydd to obwody torusa
{ //println("double torus dist");
  double dX=Math.abs(X2-X1);
  double dY=Math.abs(Y2-Y1);
  if( dX > (Xdd/2) ) dX=Xdd-dX;
  if( dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

double distanceTorusInt(int X1,int X2,int Y1,int Y2,int Xdd,int Ydd)
// Xdd i Ydd to obwody torusa
{ //println("int torus dist");
  int dX=abs(X2-X1);
  int dY=abs(Y2-Y1);
  if( dX > (Xdd/2) ) dX=Xdd-dX;
  if( dY > (Ydd/2) ) dY=Ydd-dY;
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}

/*
double distance(double X1,double X2,double Y1,double Y2)
//Domyslnie Euklidesowy, z uwzględnieniem długości okna
//ale dlaczego nie szerokości?
{
  double dX=X2-X1;
  double dY=Y2-Y1;

  if(dX>(length/2)) dX=length-dX;
  if(dY>(length/2)) dY=length-dY;
  
  if(dX!=0 || dY!=0)
    return Math.sqrt(dX*dX+dY*dY);
  else
    return 0;
}
*/

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
