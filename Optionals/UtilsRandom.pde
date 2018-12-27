//Randomisations
float randomGaussPareto(int Dist)// when Dist is negative, it is Pareto, when positive, it is Gauss
{
  if(Dist>0)
  {
    float s=0;
    for(int i=0;i<Dist;i++)
      s+=random(0,1);
    return s/Dist;  
  }
  else
  {
    float s=1;
    for(int i=Dist;i<0;i++)
       s*=random(0,1);
    return s;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
