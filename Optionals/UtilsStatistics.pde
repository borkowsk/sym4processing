//Entropia
double entropyFromHist(int[] hist,int Counter)
{
  double sum=Counter; //Ile przypadków. Double żeby wymusić dokladne dzielenie zmiennoprzecinkowe
  if(sum==0)
    for(int val: hist)
      sum+=val;
    
  double sumlog=0;
  for(int val: hist)
  if(val>0)
  {
    double p=val/sum;
    sumlog+=p*log2(p);
  }
  
  return -sumlog; //<>//
}

int[] makeHistogramOfA(Agent[][] Ags,int N,double Min,double Max,DummyInt Coin,DummyDouble CMin,DummyDouble CMax)//MIN i MAX obliczone - do wglądu
{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX)//Jesli trzeba określić Min i Max
  {
    for(Agent[] Ar: Ags)
      for(Agent   Ag: Ar)
      {
        double val=Ag.A; 
        if(val<Min) Min=val;
        if(val>Max) Max=val;  
      }
    CMin.val=Min;
    CMax.val=Max;
  }
  
  int[] Hist=new int[N];
  
  int Count=0;
  double Basket=(Max-Min)/N;
  //println("Basket width: "+Basket+" MinMax: "+Min+"-"+Max);
   for(Agent[] Ar: Ags)
      for(Agent   Ag: Ar)
      {
        double val=Ag.A; 
        if(val<Min 
        || val>Max) continue; //IGNORE THIS!
        
        int index=(int)((val-Min)/Basket);
        if(index==N)
            index=N-1;
        Hist[index]++;
        Count++;
      }
  Coin.val=Count;
  return Hist;
}

//**************************************************************************
//  2016-2017 (c) Wojciech Tomasz Borkowski  http://borkowski.iss.uw.edu.pl
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI
//**************************************************************************
