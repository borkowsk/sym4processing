//Randomisations
float randomGaussPareto(int Dist)// when Dist is negative, it is Pareto, when positive, it is Gauss like
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

//XOR SHIFT random generator - flat distribution
//http://www.javamex.com/tutorials/random_numbers/xorshift.shtml#.WT6NEzekKXI
long xl=123456789L;
double mianownik=(double)9223372036854775807L; //9,223,372,036,854,775,807 <--- max long 

double RandomXorShift() 
{
  xl ^= (xl << 21);
  xl ^= (xl >>> 35);
  xl ^= (xl << 4);
  return (Math.abs(xl)/mianownik);
}

//Pareto distribution from flat distribution
//https://math.stackexchange.com/questions/1777367/how-to-generate-a-random-number-from-a-pareto-distribution
/*
double a = 41.4104*(1-0.01); //Kształt- im większe tym ostrzej skośny rozkład
double b =  6.82053374;      //Skalowanie - im większe tym większy zakres. 
			     // Wartość 6.n dobrana do zakresu 0..1
double limit = 1;            //Akceptujemy tylko wartości od 0 do limit. 
			     // Większe powodują ponowne losowanie
  
double RandomPareto()
{
  double rndval;
  do 
  { 
   rndval = ??? ;//random(0,1)?;//MyRandom2();//drand48() ?
   //rndval = 1-rndval;//PO CO?
   double inv_fun_denom = Math.pow(1-rndval , 1/a);
   rndval = (b/inv_fun_denom)-b; //adding the -b did the trick
  }while(rndval>limit);//Akceptujemy tylko wartości od 0 do limit
  return rndval;
}
*/

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
