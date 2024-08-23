/** @file 
 *  @brief .... ("uUtilCData.pde")
 *  @date 2024-08-23 (last modification)                       @author borkowsk
 *  @details 
 *      It needs "aInterfaces.pde", "uMDistances.pde"
 *  @defgroup Data collection classes for statistics & chart making 
 *  @{
 */ ////////////////////////////////////////////////////////////////////////////
 
// @brief "NO DATA" marker. Needed somewhere else.
float INF_NOT_EXIST=Float.MAX_VALUE;                                            ///< @note Global!
int   INVALID_INDEX=-1;                                                         ///< @note Global!

/// @brief Bool switch.
/// Usable as a flag or switch of visualisation modes.
class ViewSwitch implements iFlag 
{
  boolean _val; //!< current value.

  /// @brief Sole constructor
  ViewSwitch(boolean isEnabled){ _val=isEnabled; }

  /// @brief Change the value to the opposite.
  void toggle() { _val=!_val; }
  
  /*_interfunc*/ void set(boolean isEnabled){ _val=isEnabled; }
  /*_interfunc*/ boolean isEnabled(){ return _val; }
  
} //_endOfClass ViewSwitch

class NonameRange implements iFloatRange
{
  float minimum=+Float.MAX_VALUE; //!< Current minimal value
  float maximum=-Float.MAX_VALUE; //!< Current maximal value
  
  /// @brief Constructor which needs the initial `Min..Max` range.
  NonameRange(float Min,float Max) {             assert(Min<=Max);
    this.minimum=Min; this.maximum=Max; 
  }
  
  // REQUIRED BY INTERFACE:
  //*//////////////////////
  float getMin() { return minimum; }
  float getMax() { return maximum; }
  
  void consider(float value) 
  {
    if(value==INF_NOT_EXIST) return;
    
    if(maximum<value)
    {
      maximum=value;
    }
    
    if(minimum>value)
    {
      minimum=value;
    }
  }
} //_endOfClass NonameRange

/// @brief Simplest implementation for `iValueInRange` interface.
class ValueInRange extends NonameRange implements iFloatRangeWithValue {
  
  float value=INF_NOT_EXIST;
  
   /// @brief Constructor which needs the initial `Min..Max` range.
  ValueInRange(int iniVal,float iniMin,float iniMax) { super/*NamedData*/(iniMin,iniMax); this.value=iniVal;}
  
  float get() { return value; }
  
} //_endOfClass

/// @brief Base class for data sources.
/// @details 
///      A class that implements only the interface having a proper object name.
///
class NamedData implements iNamed 
{
  String nameOfMine; //!< current name.
  
  NamedData(String iniName){ nameOfMine=iniName;}
  
  String    name() { return nameOfMine; }
  String getName() { return nameOfMine; }
  
} //_endOfClass NamedData

/// @brief More extended base class for data sources.
class Range extends NamedData implements iFloatRange {
  
  float Min=+Float.MAX_VALUE; //!< Current minimal value
  float Max=-Float.MAX_VALUE; //!< Current maximal value
  
  /// @brief Constructor which needs only a name
  /// @note  For pr2c 'super' must be in the same line with constructor name!
  Range(String iniName) { super/*NamedData*/(iniName); }
  
  /// @brief Constructor which needs the uniq name and the initial `Min..Max` range.
  /// @note  For pr2c 'super' must be in the same line with constructor name!
  Range(String iniName,float iniMin,float iniMax) { super/*NamedData*/(iniName); this.Min=iniMin; this.Max=iniMax;}
  
  // REQUIRED BY INTERFACE:
  //*//////////////////////
  float getMin() { return Min; }
  float getMax() { return Max; }
  
  void consider(float value) 
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

/// @brief Named implementation for `iValueInRange` interface.
class NamedValueInRange extends Range implements iFloatRangeWithValue {
  
  float Val=INF_NOT_EXIST;
  
   /// @brief Constructor which needs the initial `Min..Max` range.
  NamedValueInRange(int iniVal,String iniName,float iniMin,float iniMax) { super/*Range*/(iniName,iniMin,iniMax); this.Val=iniVal;}
  
  float get() { return Val; }
  
} //_endOfClass

/// @brief Class for representing series of numbers.
/// @details
///   This class represents a NAMED series of real (float) numbers.
class Sample  extends NamedData implements iFlag,iFloatRange,iDataSample,iBasicStatistics,iColor
{
  FloatList  _data=null;        //!< list of data values.
  int        options=0;         //!< Word 32b free to use
  
  color    _color=color(0,0,0); //!< color, if need be same in different graphs
  iFlag  _enabled=null;         //!< Enabling flag.
      
  // For statistics
  int    count=0;               //!< How much data has been entered (not counting INF_NOT_EXIST)
  
  float   Min=+Float.MAX_VALUE; //!< Current minimal value
  float   Max=-Float.MAX_VALUE; //!< Current maximal value
  int   whMin=-1;               //!< Position of the current minimal value
  int   whMax=-1;               //!< Position of the current maximal value
  double   sum=0;               //!< The current sum of values 
  
  /// @brief A constructor with just a name.
  /// @note  For pr2c `super` must be in the same line with constructor name! (@todo still?)
  Sample(String iniName) { super/*NamedData*/(iniName);
    _enabled=new ViewSwitch(true);
    _data=new FloatList();
    _enabled=new ViewSwitch(true);
  }
  
  /// @brief Three-parameter constructor.
  /// @param   `Name` is the name of the data series
  /// @param   `defColor` is the display color
  /// @param   `defEnabled` is a reference to the display flag on which the visibility of the series depends.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String iniName,color defColor,iFlag defEnabled) { super/*NamedData*/(iniName);
    _data=new FloatList();
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
    _data=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
    options=iOptions;
  }
  
  void reset() //!< Data wiped, so ready to collect it again!
  {
    if(_data!=null) _data.clear();
    Min=Float.MAX_VALUE;
    whMin=-1;
    Max=-Float.MAX_VALUE;
    whMax=-1;
    sum=0;  
    count=0;
  }
 
  /// @brief Checks if it is active.
  boolean isEnabled() {
    if(_enabled==null) return true; // No flag, so "enabled" by default.
    return _enabled.isEnabled();
  }
 
  boolean isOption(int mask) { //!< They will check the options according to masks.
    return (options & mask)==mask;
  }
 
  void   setColor(color fullColor) { //!< Change color
    _color=fullColor;
  }
 
  color   getColor() { //!< Gives color.
    return _color;
  }
  
  int  numOfElements() {  //!< Series length. Together with empty cells, i.e. == INF_NOT_EXIST
     return _data.size();
  }
  
  int  size() { //!< Series length. Together with empty cells, i.e. == INF_NOT_EXIST
     return _data.size(); 
  }
  
  float getElementAt(int index) { return _data.get(index); }
  
  float get(int index) { return _data.get(index); }
  
  void addToElement(int index,float whatToAdd) { _data.add(index,whatToAdd); }
  
  void multiplicateElement(int index,float multiplier) //@todo RENAME multiplyElement()
  {
    _data.mult(index,multiplier);
  }
  
  void divideElement(int index,float divider) { _data.div(index,divider); }
    
  /// @brief Shortening the series to `longOfRemained` the last elements.
  void remain(int longOfRemained)   
  {
    if(longOfRemained>=_data.size())
          return; //Nothing to do!
                                   //println(name(),data.size(),longOfremained);
    FloatList oldData=_data;
    _data=null; //We cut it off
    reset();
    _data=new FloatList(longOfRemained*2); //Initial capacity?
                                //@todo RENAME println(name(),oldData.size(),longOfRemained);
    int i=oldData.size()-longOfRemained;
    int end=oldData.size();
    for(;i<end;i++)
      consider(oldData.get(i));
  }
  
  float getLast() { //!< The last value of the series.
    if(_data.size()>0)
      return _data.get(_data.size()-1);
    else
      return INF_NOT_EXIST;
  }
  
  float getMin() { //!< Access to the current minimum.
    if(count>0) return Min;
    else return INF_NOT_EXIST;
  }
  
  int        whereMin() {
    if(count>0) return whMin;
    else return INVALID_INDEX;
  }
  
  int        whereMax() {
    if(count>0) return whMax;
    else return INVALID_INDEX;
  }
  
  float getMax() { //!< Access to the current maximum.
    if(count>0) return Max;
    else return INF_NOT_EXIST;
  }
  
  float getMean() { //!< Access to the current average.
    if(count>0) return (float)(sum/count);
    else return INF_NOT_EXIST;
  }
  
  float getHarmMean() { //!< Current harmonic mean
  
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double odwroty=0; // @todo RENAME reciprocals... Sum of reciprocals!
    
    for(float val:_data)
    if(val!=INF_NOT_EXIST && val!=0)
    {
      odwroty+=1.0/((double)val);
      N++;
    }
    
    if(odwroty==0) return INF_NOT_EXIST;
    else return (float)(N/odwroty);
  }
  
  float getQuadMean() { //!< Current mean square
  
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double kwadraty=0; // @todo RENAME sum of squares
    
    for(float val:_data)
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
  float getPowMean(float power) { //!< @param 'power' is the given averaging power.

    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double powers=0;
    
    for(float val:_data)
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
  
  /// @brief Standard deviation.
  float getStdDev() {
    
    if(count==0) return INF_NOT_EXIST;
    
    int    N=0;
    double kwadraty=0; // @todo RENAME sum of squares
    double mean=getMean();
    
    for(float val:_data)
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
  float getMedian() {
    
    if(count==0) return INF_NOT_EXIST;
    
    FloatList copied=new FloatList();             
    int    N=0;
    float val=INF_NOT_EXIST;
    
    for(int i=0;i<_data.size();i++)
    if((val=_data.get(i))!=INF_NOT_EXIST)
    {
      N++;
      copied.append(val);
    }

    if(N==0) return INF_NOT_EXIST;                                              assert N<=_data.size();
    
    copied.sort();
    return copied.get(copied.size() / 2);
  }
  
  /// @brief It calculates "Gini coefficient".
  /// @details Difference algorithm from "https://en.wikipedia.org/wiki/Gini_coefficient"
  /// @note It requires copying to the table because there may be missing values in the list.
  float getGiniCoefficient() {
    
    // Creating temporary data
    int maxN=_data.size();

    double[] locData=new double[maxN];
    int N=0;
    for(float val:_data)
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
  
  /// @brief It appends value at the end of the series.
  void consider(float value) {
    
    _data.append(value);
    
    if(value==INF_NOT_EXIST) return; // Nothing more to do
    
    sum+=value;
    count++; /// @internal Only real value, not empty!
    
    if(Max<value)
    {
      Max=value;
      whMax=_data.size()-1; //print("^");
    }
    if(Min>value)
    {
      Min=value;
      whMin=_data.size()-1; //print("v");
    }
  }
  
  /// @brief Replacing the most recently added value with another one.
  void replaceLastValue(float value) {
    
    sum-=_data.get(_data.size()-1);     //<>//

    _data.set(_data.size()-1,value);
    
    if(value==INF_NOT_EXIST) {count--;return;} // Nothing more to do
    else sum+=value;
    
    if(Max<value)
    {
      Max=value;
      whMax=_data.size()-1; //print("^");
    }
    if(Min>value)
    {
      Min=value;
      whMin=_data.size()-1; //print("v");
    }
  }
  
  /// @brief Replacing the value under the index with another one.
  void replaceAt(int index,float value) {
    
    sum-=_data.get(index);
    _data.set(index,value);
    
    if(value==INF_NOT_EXIST) {count--;return;} // Nothing more to do
    else sum+=value;
    
    if(Max<value) {
      Max=value;
      whMax=_data.size()-1; //print("^");
    }
    
    if(Min>value) {
      Min=value;
      whMin=_data.size()-1; //print("v");
    }
  }
  
} //_endOfClass Sample

/** @brief Class for returning pair of indexes */
class Int2 implements iIntPair {
  int first,second;
  Int2(int ini1,int ini2) { first=ini1;second=ini2;}
  int get1() { return first; }
  int get2() { return second; }
} //_endOfClass Int2

//class Summator1D implements iDataSample {}

/** @brief ... */
class Summator2D extends NamedData implements i2DDataSample {
  
  int         _R=0;
  int         _C=0;
  float       _min=Float.MAX_VALUE;
  int         _whMinR=-1;
  int         _whMinC=-1;
  float       _max=-Float.MAX_VALUE;
  int         _whMaxR=-1;
  int         _whMaxC=-1;
  
  float[][]      data=null;
  
  /** @brief SOLE CONSTRUCTOR */
  Summator2D(String iniName,int iniRows,int iniColumns) { super/*NamedData*/(iniName);
    _R=iniRows; _C=iniColumns;
    data=new float[_R][_C];
  }
  
  /** @brief Data only reset */
  void reset() {
    _min=+MAX_FLOAT; _whMinR=-1; _whMinC=-1;
    _max=-MAX_FLOAT; _whMaxR=-1; _whMaxC=-1;
    for(float[]/*_ref*/ row:data)
      for(float/*_ref*/ val:row){
          val=0;
      }
  }
  
  /// It takes another triplet and updates results.
  void          consider(int indexR,int indexC,float value) 
  {
    float current=(data[indexR][indexC]+=value);
    if(current<_min){
      _min=current; _whMinR=indexR; _whMinC=indexC;
    }
    if(current>_max){
      _max=current; _whMaxR=indexR; _whMaxC=indexC;
    }
  }
  
  ///  It replaces value denoted by another triplet and updates results.
  void          replaceAt(int indexR,int indexC,float value)
  {
    float current=(data[indexR][indexC]=value);
    if(current<_min){
      _min=current; _whMinR=indexR; _whMinC=indexC;
    }
    if(current>_max){
      _max=current; _whMaxR=indexR; _whMaxC=indexC;
    }
  }
    
  int               size() { return _R*_C; }
  int      numOfElements() { return _R*_C; }
  iIntPair      whereMin() { return new Int2(_whMinR,_whMinC); }
  iIntPair      whereMax() { return new Int2(_whMaxR,_whMaxC); }
  float           getMin() { return _min; }
  float           getMax() { return _max; }
  
  void          consider(float value) { /* DOES NOTHING */ }  

  void         replaceAt(int index,float val)   { replaceAt(index/_C,index%_C,val); }
  float              get(int indexR,int indexC) { return data[indexR][indexC]; }
  float              get(int index)             { return get(index/_C,index%_C); }
  float     getElementAt(int indexR,int indexC) { return data[indexR][indexC]; }
  float     getElementAt(int index)             { return get(index/_C,index%_C); }

} //_endOfClass Summator2D

/// @brief   Class for representing frequencies.
/// @details This class represents a named histogram of frequencies.
class Frequencies extends NamedData implements iFlag,iDataSample,iColor
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
  
  color   _color=color(0); 
  iFlag   _enabled=null;
  int      options=0;         //!< Word 32b free to use
    
  /// @brief   Constructor, which needs more than a name.
  /// @details For pr2c 'super' must be in the same line with constructor name!
  Frequencies(int numberOfBuckets,float lowerBound, float upperBound,String Name) { super/*NamedData*/(Name);
    buckets=new int[numberOfBuckets];
    lowerBuck=lowerBound;
    upperBuck=upperBound;
    sizeOfBucket=(upperBound-lowerBound) / numberOfBuckets;
  }
  
  /// @brief   Constructor, which needs more than a name.
  /// @details For pr2c 'super' must be in the same line with constructor name!
  Frequencies(int numberOfBuckets,float lowerBound, float upperBound,String Name,color defColor) { super/*NamedData*/(Name);
    buckets=new int[numberOfBuckets];
    lowerBuck=lowerBound;
    upperBuck=upperBound;
    sizeOfBucket=(upperBound-lowerBound) / numberOfBuckets;
    _color=defColor;
  }
      
  /// @brief Ready to start collecting data again.
  void reset()
  {
    for(int i=0;i<buckets.length;i++)
            buckets[i]=0;
    outsideLow=0;
    outsideHig=0;
    inside=0;
    higherBucketIndex=-1;    
    higherBucket=0;
  }
    
  /// @brief It tekes the real value & updates the corresponding bucket.
  void consider(float value)
  {
    if(value==INF_NOT_EXIST) return;
    
    if(value<lowerBuck)
      {outsideLow++;return;}
    
    if(value>upperBuck) 
      {outsideHig++;return;}    
    
    int index=(int)((value-lowerBuck) / sizeOfBucket);
    
    if(index<buckets.length) {
        buckets[index]++;
    
        if(higherBucket<buckets[index])
          {higherBucket=buckets[index];higherBucketIndex=index;}
        
        inside++;
    } else {
      outsideHig++; println("Frequencies:",index,"is out of bound, for value=",value);
    }

  }
  
  /// @brief Checks if it is active.
  boolean isEnabled() {
    if(_enabled==null) return true; // No flag, so "enabled" by default.
    return _enabled.isEnabled();
  }
  
  void   setColor(color fullColor) { //!< Change color
    _color=fullColor;
  }
 
  color   getColor() { //!< Gives color.
    return _color;
  }
  
  /// @brief It consider whole series of data!
  /// @param src points to series of values, and is not remembered!
  void consider(iDataSample/*_ref*/ src)
  {
    for(int i=0;i<src.size();i++) {
        consider(src.get(i)); //print(src.get(i),';');
    }
    //println();
  }
  
  // REQUIRED BY INTERFACES:
  //*///////////////////////
  int  numOfElements() { return buckets.length;}   //!< @note In this case, the items are histogram buckets.
  int           size() { return buckets.length;}   //!< @note In this case, the items are histogram buckets.
  float getElementAt(int index) { if(0<=index && index<buckets.length ) return buckets[index]; else return INF_NOT_EXIST; }
  float          get(int index) { if(0<=index && index<buckets.length ) return buckets[index]; else return INF_NOT_EXIST; }
  void     replaceAt(int index,float value) { /* DO NOTHING! */ }
  float       getMin() { return 0; }
  float       getMax() { return higherBucket; }
  int       whereMin() { return INVALID_INDEX; }
  int       whereMax() { return higherBucketIndex; }
  
  boolean isOption(int mask) //!< They will check the options according to masks.
  {
    return (options & mask)==mask;
  }
  
} //_endOfClass Frequencies

//******************************************************************************
/// See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI"
/// See: "https://github.com/borkowsk/sym4processing"
//* USEFUL COMMON CODES - HANDY FUNCTIONS & CLASSES
/// @}
//******************************************************************************        
