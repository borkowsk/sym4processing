int sqr(int a)
{
  return a*a;
}

float sqr(float a)
{
  return a*a;
}

double sqr(double a)//Do łatwego podnoszenia do kwadratu
{
  return a*a;
}

float upToTresh(float val,float incr,float tresh)
{
    val+=incr;
    return val<tresh?val:tresh;
}
