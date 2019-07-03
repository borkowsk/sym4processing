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
