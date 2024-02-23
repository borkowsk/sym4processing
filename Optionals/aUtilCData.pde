/** @file "uUtilCData.pde"
 *  @defgroup Data collection classes for statistics & chart making 
 *  @date 2024.02.20 (last modification)                       @author borkowsk
 *  @details 
 *      It needs "aInterfaces.pde", "uMDistances.pde"
 *  @{
 */ ////////////////////////////////////////////////////////////////////////////
 
// @brief "NO DATA" marker. Needed somewhere else.
float INF_NOT_EXIST=Float.MAX_VALUE;                                            ///< @note Global!

/// @brief Bool switch.
/// Usable as a flag or switch of visualisation modes.
class ViewSwitch implements iFlag 
{
  boolean _val; //!< current value.

  ViewSwitch(boolean isEnabled){ _val=isEnabled; }

  /// @brief Change the value to the opposite.
  void toggle() { _val=!_val; }
  
  /*_interfunc*/ void set(boolean isEnabled){ _val=isEnabled; }
  /*_interfunc*/ boolean isEnabled(){ return _val; }
} //_endOfClass ViewSwitch

/// @brief Base class for data sources.
/// @details 
///      A class that implements only the interface having a proper object name.
///
class NamedData implements iNamed 
{
  String _myName; //!< current name.
  
  NamedData(String Name){ _myName=Name;}
  
  String name() { return _myName; }
  String getName() { return _myName; }
  
} //_endOfClass NamedData

/// @brief More extended base class for data sources.
class Range extends NamedData 
{
  float Min=+Float.MAX_VALUE; //!< Current minimal value
  float Max=-Float.MAX_VALUE; //!< Current maximal value
  
  /// @brief Sole constructor needs only a name
  /// @note  For pr2c 'super' must be in the same line with constructor name!
  Range(String Name) { super/*NamedData*/(Name); }
  
  void addValue(float value) 
  {
    if(value==INF_NOT_EXIST) return;
    
    if(Max<value)
    {
      Max=value;
    }
    
    if(Min>value)
    {
      Min=value;
    }
  }
  
} //_endOfClass Range


/// @brief Class for representing series of numbers.
/// @details
///   This class represents a NAMED series of real (float) numbers.
/// @todo Should it also be a descendant of the Range?
///   ... Or at least implements the same interface? TODO?
class Sample  extends NamedData 
{
  FloatList  data=null;         //!< list of data values.
  int        options=0;         //!< Word 32b free to use
  
  color    _color=color(0,0,0); //!< color, if need be same in different graphs
  iFlag  _enabled=null;         //!< Enabling flag.
      
  // For statistics
  int    count=0;               //!< How much data has been entered (not counting INF_NOT_EXIST)
  float   Min=+Float.MAX_VALUE; //!< Current minimal value
  int   whMin=-1;               //!< Position of the current minimal value
  float   Max=-Float.MAX_VALUE; //!< Current maximal value
  int   whMax=-1;               //!< Position of the current maximal value
  double   sum=0;               //!< The current sum of values 
  
  /// @brief A constructor with just a name.
  /// @note  For pr2c `super` must be in the same line with constructor name! (@todo still?)
  Sample(String Name) { super/*NamedData*/(Name);
    _enabled=new ViewSwitch(true);
    data=new FloatList();
    _enabled=new ViewSwitch(true);
  }
  
  /// @brief Three-parameter constructor.
  /// @param   `Name` is the name of the data series
  /// @param   `defColor` is the display color
  /// @param   `defEnabled` is a reference to the display flag on which the visibility of the series depends.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name,color defColor,iFlag defEnabled) { super/*NamedData*/(Name);
    data=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
  }
  
  /// @brief Multiparameter constructor.
  /// @param   `Name` is the name of the data series
  /// @param   `defColor` is the display color
  /// @param   `defEnabled` is a reference to the display flag on which the series depends.
  /// @param   `iOptions` are options with different meanings.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name,color defColor,iFlag defEnabled,int iOptions) { super/*NamedData*/(Name);
    data=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
    options=iOptions;
  }
 
  color   getColor() //!< Gives color.
  {
    return _color;
  }
  
  boolean isEnabled() //!< Checks if it is active.
  {
    return _enabled.isEnabled();
  }
 
  boolean isOption(int mask) //!< They will check the options according to masks.
  {
    return (options & mask)!=0;
  }
  
  int  numOfElements() //!< Series length. Together with empty cells, i.e. == INF_NOT_EXIST
  { 
     return data.size(); 
  }
  
  float getLast() //!< The last value of the series.
  {
    if(data.size()>0)
      return data.get(data.size()-1);
    else
      return INF_NOT_EXIST;
  }
  
  float getElementAt(int index)
  {
    return data.get(index);
  }
  
  void addToElement(int index,float whatToAdd)
  {
    data.add(index,whatToAdd);
  }
  
  void multiplicateElement(int index,float multiplier) //@todo RENAME multiplyElement()
  {
    data.mult(index,multiplier);
  }
  
  void divideElement(int index,float divider)
  {
    data.div(index,divider);
  }
  
  void reset() //!< Data wipe.
  {
    if(data!=null) data.clear();
    Min=Float.MAX_VALUE;
    whMin=-1;
    Max=-Float.MAX_VALUE;
    whMax=-1;
    sum=0;  
    count=0;
  }
  
  /// @brief Shortening the series to `longOfRemained` the last elements.
  void remain(int longOfRemained)   
  {
    if(longOfRemained>=data.size())
          return; //Nothing to do!
                                   //println(name(),data.size(),longOfremained);
    FloatList oldData=data;
    data=null; //We cut it off
    reset();
    data=new FloatList(longOfRemained*2); //Initial capacity?
                                //@todo RENAME println(name(),oldData.size(),longOfRemained);
    int i=oldData.size()-longOfRemained;
    int end=oldData.size();
    for(;i<end;i++)
      addValue(oldData.get(i));
  }
  
  float getMin() //!< Access to the current minimum.
  {
    if(count>0) return Min;
    else return INF_NOT_EXIST;
  }
  
  float getMax()  //!< Access to the current maximum.
  {
    if(count>0) return Max;
    else return INF_NOT_EXIST;
  }
  
  float getMean()  //!< Access to the current average.
  {
    if(count>0) return (float)(sum/count);
    else return INF_NOT_EXIST;
  }
  
  float getHarmMean() //!< Current harmonic mean
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double odwroty=0; // @todo RENAME reciprocals... Sum of reciprocals!
    
    for(float val:data)
    if(val!=INF_NOT_EXIST && val!=0)
    {
      odwroty+=1.0/((double)val);
      N++;
    }
    
    if(odwroty==0) return INF_NOT_EXIST;
    else return (float)(N/odwroty);
  }
  
  float getQuadMean() //!< Current mean square
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double kwadraty=0; // @todo RENAME sum of squares
    
    for(float val:data)
    if(val!=INF_NOT_EXIST)
    {
      kwadraty+=sqr(val);
      N++;
    }
    
    if(N==0) return INF_NOT_EXIST;
    double ret=kwadraty/N;
    
    if(ret==0) return INF_NOT_EXIST;
    ret=Math.sqrt(ret);
    
    return (float)ret; 
  }
  
  /// @brief Current average with arbitrary powers.
  /// @note  It can be both a fraction and a number greater than 2, e.g. 1/3 or 3.
  float getPowMean(float power) //!< @param 'power' is the given averaging power.
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double powers=0;
    
    for(float val:data)
    if(val!=INF_NOT_EXIST)
    {
      powers+=Math.pow(val,power);
      N++;
    }
    
    if(N==0) return INF_NOT_EXIST;
    double ret=powers/N;
    
    if(ret==0) return INF_NOT_EXIST;
    double ex=1/power;
    ret=Math.pow(ret,ex);
    
    return (float)ret; 
  }
  
  float getStdDev() //!< Standard deviation.
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double kwadraty=0; // @todo RENAME sum of squares
    double mean=getMean();
    
    for(float val:data)
    if(val!=INF_NOT_EXIST)
    {
      kwadraty+=sqr(val-mean);
      N++;
    }
    
    if(N==0) return INF_NOT_EXIST;
    else return (float)(kwadraty/N);
  }
  
  /// @brief Calculates the median of the entire data series.
  /// @note  Requires copying and sorting,
  ///        so it can be very computationally expensive.
  float getMedian()
  {
    if(count==0) return INF_NOT_EXIST;
    
    FloatList copied=new FloatList();             
    int    N=0;
    float val=INF_NOT_EXIST;
    
    for(int i=0;i<data.size();i++)
    if((val=data.get(i))!=INF_NOT_EXIST)
    {
      N++;
      copied.append(val);
    }

    if(N==0) return INF_NOT_EXIST;                                              assert N<=data.size();
    
    copied.sort();
    return copied.get(copied.size() / 2);
  }
  
  /// @brief It calculates "Gini coefficient".
  /// @details Difference algorithm from "https://en.wikipedia.org/wiki/Gini_coefficient"
  /// @note It requires copying to the table because there may be missing values in the list.
  float getGiniCoefficient()
  {
    // Creating temporary data
    int maxN=data.size();

    double[] locData=new double[maxN];
    int N=0;
    for(float val:data)
        if(val!=INF_NOT_EXIST)
        {
          locData[N]=val;
          N++;
        }
    
    if(N>0)
    {
      double SumOfDifs=0,SumOfVals=0; //@todo rename SumOfDiffs SumOfVars
      for(int i=0;i<N;i++)
      {
        for(int j=0;j<N;j++)
        {
          SumOfDifs+=Math.abs(locData[i]-locData[j]);
        }
        SumOfVals+=locData[i];
      }
      
      if((SumOfVals/=N)==0) return INF_NOT_EXIST; // Bo też by było dzielenie przez 0
      
      return (float)(SumOfDifs/(2*N*N*SumOfVals));
    }
    else 
    return INF_NOT_EXIST;
  }
  
  /// @brief Adding value at the end of the series.
  void addValue(float value) 
  {        
    data.append(value);
    
    if(value==INF_NOT_EXIST) return; // Nothing more to do
    
    sum+=value;
    count++; /// @internal Only real value, not empty!
    
    if(Max<value)
    {
      Max=value;
      whMax=data.size()-1; //print("^");
    }
    if(Min>value)
    {
      Min=value;
      whMin=data.size()-1; //print("v");
    }
  }
  
  /// @brief Replacing the most recently added value with another one.
  void replaceLastValue(float value) 
  {
    data.set(data.size()-1,value);
  }
  
  /// @brief Replacing the value under the index with another one.
  void replaceValue(int index,float value) 
  {
    data.set(index,value);
  }
  
} //_endOfClass Sample

/// @brief   Class for representing frequencies.
/// @details This class represents a named histogram of frequencies.
class Frequencies extends NamedData 
{
  int[]   buckets=null; //!< histogram bin array.
  float   sizeOfBucket=0; //(Max-Min) / N; 
  
  float   lowerBuck=+Float.MAX_VALUE;
  float   upperBuck=-Float.MAX_VALUE;
  
  int     outsideLow=0;
  int     outsideHig=0;
  int     inside=0;

  int     higherBucket=0;
  int     higherBucketIndex=-1;
  
  /// @brief   Constructor, which needs more than a name.
  /// @details For pr2c 'super' must be in the same line with constructor name!
  Frequencies(int numberOfBuckets,float lowerBound, float upperBound,String Name) { super/*NamedData*/(Name);
    buckets=new int[numberOfBuckets];
    lowerBuck=lowerBound;
    upperBuck=upperBound;
    sizeOfBucket=(upperBound-lowerBound) / numberOfBuckets;
  }
    
  /// @brief In this case, the items are histogram buckets.
  int  numOfElements() { return buckets.length;}
  
  /// @brief Ready to start collecting data again.
  void reset()
  {
    for(int i=0;i<buckets.length;i++)
            buckets[i]=0;
    outsideLow=0;
    outsideHig=0;
    inside=0;
    higherBucket=0;
    higherBucketIndex=-1;    
  }
    
  /// @brief It ads the real value  & updates the corresponding bucket.  
  void addValue(float value)
  {
    if(value==INF_NOT_EXIST) return;
    
    if(value<lowerBuck)
      {outsideLow++;return;}
    
    if(value>upperBuck) 
      {outsideHig++;return;}    
    
    int index=(int)((value-lowerBuck) / sizeOfBucket);
         
    buckets[index]++;
    
    if(higherBucket<buckets[index])
      {higherBucket=buckets[index];higherBucketIndex=index;}
    
    inside++;
  }
  
} //_endOfClass Frequencies

//******************************************************************************
/// See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI"
/// See: "https://github.com/borkowsk/sym4processing"
//* USEFUL COMMON CODES - HANDY FUNCTIONS & CLASSES
/// @}
//******************************************************************************        
