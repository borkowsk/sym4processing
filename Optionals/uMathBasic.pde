/// Math basics
//*/////////////////

/// Some of my older programs show the constant FLOAT_MAX, while MAX_FLOAT is currently available.
final float FLOAT_MAX=MAX_FLOAT; //3.40282347E+38;

/// Function for determining the sign of a integer number.
int sign(int val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for determining the sign of a float number.
int sign(float val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for determining the sign of a double number.
int sign(double val)
{
  if(val>0) return 1;
  else if(val==0) return 0;
  else return -1;
}

/// Function for increasing no more than up to a certain threshold value
float upToTresh(float val,float incr,float tresh)
{
    val+=incr;
    return val<tresh?val:tresh;
}

/// Function to find which of the three values is the largest?
int whichIsMax(float v0,float v1,float v2)
{
  if(v0 > v1 && v0 > v2) return 0;
  else if( v1 > v0 && v1 > v2) return 1;
  else if( v2 > v0 && v2 > v1) return 2;
  else return -1;//żaden nie jest dominujący
}

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
