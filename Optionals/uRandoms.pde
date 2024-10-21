/// unctions that improve the use of pseudo-random numbers. ("uRandoms.pde")
/// @date 2024-10-21 (Last modification)
///*////////////////////////////////////////////////////////////////////////////////

/// @defgroup More simulation resources
/// @{
//*////////////////////////////////////

/// Function generates pseudo random number with non-flat distribution.
/// When @p Dist is negative, it is Pareto-like, 
/// when is positive, it is Gaussian-like
float randomGaussPareto(int Dist)  ///< @note GLOBAL
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

// XOR SHIFT RANDOM:
//*/////////////////

static long     xorShiftRandSeed=123456789L;                   ///< seed for xorshift randomizer
final double xorShiftDenominator=(double)9223372036854775807L; ///< denominator for xorshift randomizer (why double?)
//final  long   denominator=9223372036854775807L;              /// 9,223,372,036,854,775,807 <--- max long 

/// Function which generates "xorshift" random value.
/// XOR SHIFT random number generator with flat distribution
/// Apart from the function, it also needs a variable for storing the grain 
/// and a constant for storing the denominator.
/// See: http://www.javamex.com/tutorials/random_numbers/xorshift.shtml#.WT6NEzekKXI
double RandomXorShift()   ///< @note GLOBAL
{
  xorShiftRandSeed ^= (xorShiftRandSeed << 21);
  xorShiftRandSeed ^= (xorShiftRandSeed >>> 35);
  xorShiftRandSeed ^= (xorShiftRandSeed << 4);
  return (Math.abs(xorShiftRandSeed)/xorShiftDenominator);//Is the result of abs() automatically promoted to double? Looks like...
}

/// @Function RandomPareto().
/// It generates pareto distribution from flat distribution
/// See: https://math.stackexchange.com/questions/1777367/how-to-generate-a-random-number-from-a-pareto-distribution
/// Not tested!!! TODO!
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

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////
