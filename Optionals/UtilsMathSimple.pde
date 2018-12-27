//Do łatwego i CZYTELNEGO podnoszenia do kwadratu
int sqr(int a)
{
  return a*a;
}

float sqr(float a)
{
  return a*a;
}

double sqr(double a)
{
  return a*a;
}

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
