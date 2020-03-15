//STAŁE
final float FLOAT_MAX=3.40282347E+38;

//Do określania znaku liczby
int sign(int val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

int sign(float val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

int sign(double val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

//Do powiększania nie więcej niż do pewnej wartości progowej
float upToTresh(float val,float incr,float tresh)
{
    val+=incr;
    return val<tresh?val:tresh;
}

//Która z trzech wartości jest największa? 
int whichIsMax(float v0,float v1,float v2)
{
  if(v0 > v1 && v0 > v2) return 0;
  else if( v1 > v0 && v1 > v2) return 1;
  else if( v2 > v0 && v2 > v1) return 2;
  else return -1;//żaden nie jest dominujący
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
