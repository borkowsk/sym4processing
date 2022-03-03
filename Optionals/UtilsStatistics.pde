//*  Różne proste statystyki dla tablic jednowymiarowych
//*  EN: Various simple statistics for one-dimensional arrays
//*/////////////////////////////////////////////////////////

/// Średnia arytmetyczna z danych typu float
/// https://en.wikipedia.org/wiki/Arithmetic_mean
/// EN: Arithmetic mean of the float data
float meanArithmetic(float data[],int offset,int limit)
{                       
                                  assert(offset<limit);
                                  assert(limit<data.length);
  double sum = 0;
  
  for (int i = offset ; i < limit; i++)
  {
    sum += data[i];     
  }
                                             
  return (float)(sum/(limit-offset)); 
}

/// Średnia arytmetyczna z danych o "podwójnej" precyzji
/// https://en.wikipedia.org/wiki/Arithmetic_mean
/// EN: Arithmetic mean of the "double" precision data
double meanArithmetic(double data[],int offset,int limit)
{                       
                                    assert(offset<limit);
                                    assert(limit<data.length);
  double sum = 0;
  
  for (int i = offset ; i < limit; i++)
  {
    sum += data[i];     
  }
                                             
  return sum/(limit-offset);
}

/// Korelacja Pearsona
/// https://pl.wikipedia.org/wiki/Wsp%C3%B3%C5%82czynnik_korelacji_Pearsona
/// EN: Pearson's correlation
double correlation(float data1[],float data2[],
                   int offset1,int offset2,
                   int limit)
{
  double X_s=0,Y_s=0;
  double summ1=0,summ2=0,summ3=0,corelation=0;
  int i,N=0,start=0,ITMAXP=min(limit,data1.length,data2.length);  

  if(offset1==offset2)
  {
    start=offset1;
    offset1=offset2=0;//Niepotrzebne
  }
  else if(offset1>offset2)
  {
    start=offset2;
    offset2=0;
    offset1-=start;
  }
  else// offset1 < offset2
  {
    start=offset1;
    offset1=0;
    offset2-=start;
  }

  //print(start,offset1,offset2,ITMAXP);
  
  for(i = start; i < ITMAXP; i++)
  {
    X_s+=data1[i+offset1];
    Y_s+=data2[i+offset2];
    N++;
  }
  /*println(" ",N);*/ assert(N==ITMAXP);
  
  X_s/=N;  
  Y_s/=N;  
  
  for(i = start; i < ITMAXP; i++)
  {
    summ1+=(X_s-data1[i+offset1])*(Y_s-data2[i+offset2]);
    summ2+=(X_s-data1[i+offset1])*(X_s-data1[i+offset1]);
    summ3+=(Y_s-data2[i+offset2])*(Y_s-data2[i+offset2]);
  }
     
  if(summ2==0 || summ3==0)
    corelation=-0;//Umownie, bo tak naprawdę nie da się wtedy policzyć
  else
    corelation=summ1/( Math.sqrt(summ2) * Math.sqrt(summ3) );
                                             // assert(fabs(corelation)<=1.01);//+0.01 bo moga byc bledy floating-point
  return corelation;
}

/// Średnia z korelacji za pomocą Z
/// Trzeba zmienić korelacje na Z żeby móc je legalnie dodawać. 
/// Niestety korelacje =1 i =-1 są nietransformowalne więc trochę oszukujemy
/// EN: Mean of the correlation using Z
double meanCorrelations(double data[],int offset,int limit)
{
                                            assert(offset<limit);
                                            assert(limit<data.length);
  double PomCorrelation=0;          
  
  for (int i = offset ; i < limit; i++)
  {
    double pom = data[i];
    if (pom >= 0.999999) pom = 0.999999;
    if (pom <= -0.999999) pom = -0.999999;
    double  Z = 0.5 * Math.log( (1.0 + pom) / (1.0 - pom) ); // robimy transformacje w Z/we do Z transformations
    PomCorrelation += Z; //Sumujemy kolejne Z
  }

  PomCorrelation /= limit - offset; //Uśredniamy Z

  PomCorrelation = ( Math.exp(2 * PomCorrelation) - 1 ) 
                              / 
                   ( Math.exp(2 * PomCorrelation) + 1 ); //I z powrotem zmieniamy w korelacje/And we're changing Z back to correlations
      
  return PomCorrelation;
}

/// Entropia informacyjna z histogramu
/// EN: Informational entropy from the histogram
double entropyFromHist(int[] histogram)
{
  double sum=0; //Ile przypadków. 
                //Double żeby wymusić dokładne dzielenie zmiennoprzecinkowe
  if(sum==0)
    for(int val: histogram)
      sum+=val;
    
  double sumlog=0;
  for(int val: histogram)
  if(val>0)
  {
    double p=val/sum;
    sumlog+=p*log2(p);
  }
  
  return -sumlog; //<>//
}

//*////////////////////////////////////////////////////////////////////////////
//*  2016-2019 (c) Wojciech Tomasz Borkowski
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI
//*////////////////////////////////////////////////////////////////////////////
