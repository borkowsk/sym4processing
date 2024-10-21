/// A sample of making a histogram from an example agent with `.A` field. ("uStatOfAgents.pde")
/// @details It would be difficult to generalize to any field.
///          Easier you can just rename the field as needed.
/// @date 2024-10-21 (Last modification)
/// @note This file shoud be COPIED into the project directory and modified when needed.
///*//////////////////////////////////////////////////////////////////////////////////////////////////
//* PL: Szablon wykonania histogramu z przykładowego pola `.A` agenta 
//* PL: Trudno by to było uogólnić na dowolne pola nie wprowadzając SZABLONU!
//* PL: Łatwiej po prostu zmieniać nazwę pola w razie potrzeby.
//*///////////////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Statistic tools and functions
/// @{
//*////////////////////////////////////////

/// @brief Version for a two-dimensional array of agents.
/// @param Ags - Two-dimensional "world" of agents - a two-dimensional array.
/// @param N   - Number of buckets in the histogram.
/// @param Min - Possibility to give the minimum known from other calculations.
/// @param Max - Possibility to give the maximum known from other calculations.
/// @param Counter - [out] How many values counted in this statistic.
/// @param CMin    - [out] MIN calculated - for reference.
/// @param CMax    - [out] MAX calculated - for reference.
int[] makeHistogramOfA(Agent[][] Ags,int N,double Min,double Max,DummyInt Counter,DummyDouble CMin,DummyDouble CMax) ///< GLOBAL
{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX) //Jesli trzeba określić Min i Max
  {
    for(Agent[] Ar: Ags)
      for(Agent  Ag: Ar )
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
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
      for(Agent  Ag: Ar)
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min 
        || val>Max) continue; //IGNORE THIS VALUE!
        
        int index=(int)((val-Min)/Basket);
        
        if(index==N)
            index=N-1;
        
        Hist[index]++;
        
        Count++;
      }
      
  Counter.val=Count;
  
  return Hist;
}

/// @brief Version for a two-dimensional array of agents.
/// @param Ags - One-dimensional "world" of agents - a simple array.
/// @param N   - Number of buckets in the histogram.
/// @param Min - Possibility to give the minimum known from other calculations.
/// @param Max - Possibility to give the maximum known from other calculations.
/// @param Counter - [out] How many values counted in this statistic.
/// @param CMin    - [out] MIN calculated - for reference.
/// @param CMax    - [out] MAX calculated - for reference.
int[] makeHistogramOfA(Agent[] Ags,int N,double Min,double Max,DummyInt Counter,DummyDouble CMin,DummyDouble CMax)  ///< GLOBAL
{
  CMin.val=FLOAT_MAX;
  CMax.val=-FLOAT_MAX;
  if(Min==FLOAT_MAX || Max==-FLOAT_MAX) //Jesli trzeba określić Min i Max
  {
      for(Agent  Ag: Ags )
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
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
  
      for(Agent  Ag: Ags)
      {
        double val=Ag.A; //Example of getting value - REPLACE WITH YOUR OWN CODE
        
        if(val<Min 
        || val>Max) continue; //IGNORE THIS!
        
        int index=(int)((val-Min)/Basket);
        
        if(index==N)
            index=N-1;
        
        Hist[index]++;
        
        Count++;
      }
      
  Counter.val=Count;
  
  return Hist;
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////
