double distance(double X1,double X2,double Y1,double Y2)
//Czêsto potrzebne w takich programach
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

float distance(float X1,float X2,float Y1,float Y2)
//Czêsto potrzebne w takich programach
{
  float dX=X2-X1;
  float dY=Y2-Y1;
  if(dX!=0 || dY!=0)
    return sqrt(dX*dX+dY*dY);
  else
    return 0;
}


///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
