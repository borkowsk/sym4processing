/** Classes for statistics data representations. ("aUtilCData.pde")
 *  @date 2025-05-09 (last modification)                       @author borkowsk
 *  @note This modules could be typically just linked from "Optionals/"
 *  @details 
 *      It needs "aInterfaces.pde", "uMDistances.pde"
 */
 
/// @defgroup Statistic tools and functions
/// @{
//-////////////////////////////////////////
 
// @brief "NO DATA" marker. Needed somewhere else.
float INF_NOT_EXIST=-Float.MIN_VALUE;                                           ///< @note Global! -1.4E-45
int   INVALID_INDEX=-1;                                                         ///< @note Global!
int   debug_utils=0;                                                            ///< Debug level for UtilCData & UtilCharts etc.

/// Logarithm on base2 needed f.e. to Shannon's entropy calculation from floats.
float log2(float v) ///< GLOBAL
{
  return log(v) / log(2.0); // (v > 0)  
}

/// @brief Bool switch.
/// Usable as a flag or switch of visualisation modes.
class ViewSwitch implements iFlag 
{
  boolean _val; //!< current value.

  /// @brief Sole constructor.
  ViewSwitch(boolean isEnabled){ _val=isEnabled; }

  /// @brief Change the value to the opposite.
  void toggle() { _val=!_val; }
  
  /*_interfunc*/ void set(boolean isEnabled){ _val=isEnabled; }
  /*_interfunc*/ boolean isEnabled(){ return _val; }
  
} //_endOfClass ViewSwitch

/// A float range without any name.
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
  ValueInRange(int iniVal,float iniMin,float iniMax) { super/*NonameRange*/(iniMin,iniMax); this.value=iniVal;}
  
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
class Sample  extends NamedData implements iDataSample, /*_vpi*/ iFloatRange, /*_vpi*/ iBasicStatistics, /*_vpi*/ iColor,/*_vpi*/ iFlag
{
  FloatList dataList=null;         //!< list of data values.
  color       _color=color(0,0,0); //!< color, if need to be same in different graphs
  iFlag     _enabled=null;         //!< Enabling flag.
      
  // For statistics
  int    count=0;                //!< How much data has been entered (not counting INF_NOT_EXIST)
  float    Min=+Float.MAX_VALUE; //!< Current minimal value
  int    whMin=-1;               //!< Position of the current minimal value
  float    Max=-Float.MAX_VALUE; //!< Current maximal value
  int    whMax=-1;               //!< Position of the current maximal value
  double   sum=0;                //!< The current sum of values
  int  options=0;                //!< Word 32b, free to use
   
  /// @brief A constructor with just a name.
  Sample(String iniName) { super/*NamedData*/(iniName);
    dataList=new FloatList();
    _enabled=new ViewSwitch(true);
  }
  
  /// @brief Three-parameter constructor.
  /// @param   `Name` is the name of the data series
  /// @param   `defColor` is the display color
  /// @param   `defEnabled` is a reference to the display flag on which the visibility of the series depends.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String iniName,color defColor,iFlag defEnabled) { super/*NamedData*/(iniName);
    dataList=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
  }
  
  /// @brief Multi-parameter constructor.
  /// @param   `Name` is the name of the data series
  /// @param   `defColor` is the display color
  /// @param   `defEnabled` is a reference to the display flag on which the series depends.
  /// @param   `iOptions` are options with different meanings.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name,color defColor,iFlag defEnabled,int iOptions) { super/*NamedData*/(Name);
    dataList=new FloatList();
    _enabled=defEnabled;
    _color=defColor;
    options=iOptions;
  }
  
  void reset() //!< Data wiped, so ready to collect it again!
  {
    if(dataList!=null) dataList.clear();
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
     return dataList.size();
  }
  
  int  size() { //!< Series length. Together with empty cells, i.e. == INF_NOT_EXIST
     return dataList.size(); 
  }
  
  float getElementAt(int index) { return dataList.get(index); }
  
  float get(int index)
  {  
    int size=dataList.size(); //Ile jest danych?
    
    if(size==0) 
      return INF_NOT_EXIST; //Nie ma wcale!
      
    if(index<0) // Czy odliczamy od końca?
    {
      index=size-index;
      if(index<0) 
          index=0; //Nie ma aż tylu!
    }

    if(index>=size) 
          index=size-1; //Nie ma aż tylu!
          
    return dataList.get(index);
  }
  
  /* void addToElement(int index,float whatToAdd) { _data.add(index,whatToAdd); } */
  
  /// @brief Shortening the series to `longOfReminded` the last elements.
  void remain(int longOfReminded)   
  {
    if(longOfReminded>=dataList.size())
          return; //Nothing to do!
                                   //println(name(),data.size(),longOfReminded); 
    FloatList oldData=dataList;
    dataList=null; //We cut it off
    reset();
    dataList=new FloatList(longOfReminded*2); //Initial capacity?
                                //@todo RENAME println(name(),oldData.size(),longOfReminded);
    int i=oldData.size()-longOfReminded;
    int end=oldData.size();
    for(;i<end;i++)
      consider(oldData.get(i));
  }
  
  float getLast() { //!< The last value of the series.
    if(dataList.size()>0)
      return dataList.get(dataList.size()-1);
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
    double reciprocals=0; // Sum of reciprocals!
    
    for(float val:dataList)
    if(val!=INF_NOT_EXIST && val!=0)
    {
      reciprocals+=1.0/((double)val);
      N++;
    }
    
    if(reciprocals==0) return INF_NOT_EXIST;
    else return (float)(N/reciprocals);
  }
  
  float getQuadMean() { //!< Current mean square
  
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double squares=0; // sum of squares
    
    for(float val:dataList)
    if(val!=INF_NOT_EXIST)
    {
      squares+=sqr(val);
      N++;
    }
    
    if(N==0) return INF_NOT_EXIST;
    double ret=squares/N;
    
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
    
    for(float val:dataList)
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
    double squares=0; // sum of squares
    double mean=getMean();
    
    for(float val:dataList)
    if(val!=INF_NOT_EXIST)
    {
      squares+=sqr(val-mean);
      N++;
    }
    
    if(N==0) return INF_NOT_EXIST;
    else return (float)(squares/N);
  }
  
  /// @brief Calculates the median of the entire data series.
  /// @note  Requires copying and sorting,
  ///        so it can be very computationally expensive.
  float getMedian() {
    
    if(count==0) return INF_NOT_EXIST;
    
    FloatList copied=new FloatList();             
    int    N=0;
    float val=INF_NOT_EXIST;
    
    for(int i=0;i<dataList.size();i++)
    if((val=dataList.get(i))!=INF_NOT_EXIST)
    {
      N++;
      copied.append(val);
    }

    if(N==0) return INF_NOT_EXIST;                                              assert N<=dataList.size();
    
    copied.sort();
    return copied.get(copied.size() / 2);
  }
    
  /// @brief It appends value at the end of the series.
  void consider(float value) {
    
    dataList.append(value);
    
    if(value==INF_NOT_EXIST) return; // Nothing more to do
    
    sum+=value;
    count++; /// @internal Only real value, not empty!
    
    if(Max<value)
    {
      Max=value;
      whMax=dataList.size()-1; //print("^");
    }
    if(Min>value)
    {
      Min=value;
      whMin=dataList.size()-1; //print("v");
    }
  }
  
  /// @brief Replacing the most recently added value with another one.
  void replaceLastValue(float value) {
    
    sum-=dataList.get(dataList.size()-1);    

    dataList.set(dataList.size()-1,value);
    
    if(value==INF_NOT_EXIST) {count--;return;} // Nothing more to do
    else sum+=value;
    
    if(Max<value)
    {
      Max=value;
      whMax=dataList.size()-1; //print("^");
    }
    if(Min>value)
    {
      Min=value;
      whMin=dataList.size()-1; //print("v");
    }
  }
  
  /// @brief Replacing the value under the index with another one.
  void replaceAt(int index,float value) {
    
    sum-=dataList.get(index);
    dataList.set(index,value);
    
    if(value==INF_NOT_EXIST) {count--;return;} // Nothing more to do
    else sum+=value;
    
    if(Max<value) {
      Max=value;
      whMax=dataList.size()-1; //print("^");
    }
    
    if(Min>value) {
      Min=value;
      whMin=dataList.size()-1; //print("v");
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

class AddersSet1D  extends NamedData implements iDataSample {

  int         sizeOfData=0;          //!< number of buckets.
  int         consideredN=0;         //!< number of considered values.
  double      consideredSum=0;       //!< sum of considered values.
  float       _min=Float.MAX_VALUE;
  int         _whMin=-1;
  float       _max=-Float.MAX_VALUE;
  int         _whMax=-1;
  
  float[]     data=null;
  
  /** @brief SOLE CONSTRUCTOR */
  AddersSet1D(String iniName,int iniSize) { super/*NamedData*/(iniName); //Java-owe "super" musi być w tej samej linii co otwierające {
    sizeOfData=iniSize;
    data=new float[sizeOfData];             
    assert(data[0]==0);
  }
  
  /** @brief MinMax reset */
  void resetMinMax() {
    _min=+MAX_FLOAT; _whMin=-1;
    _max=-MAX_FLOAT; _whMax=-1;
  }
  
  /** @brief Data reset */
  void reset() {
    resetMinMax(); //Min-Max may be invalid from now!
    consideredN=0;
    consideredSum=0;
    for(int i=0;i<data.length;i++) //reset data
          data[i]=0;
  }
  
  // OTHERS REQUIRED BY INTERFACES:
  //*//////////////////////////////  
  boolean       isOption(int mask) { return false; } //!< There is no any options for now.
  int               size() { return sizeOfData; }
  int      numOfElements() { return sizeOfData; }
  int           whereMin() { if(_whMin==-1) _calculateMinMax(); return _whMin; }
  int           whereMax() { if(_whMax==-1) _calculateMinMax(); return _whMax; }
  float           getMin() { if(_whMin==-1) _calculateMinMax(); return _min; }
  float           getMax() { if(_whMax==-1) _calculateMinMax(); return _max; }
  
  void          consider(float value) { /* DOES NOTHING */ }  

  float              get(int index)             { return data[index]; }
  float     getElementAt(int index)             { return data[index]; }
  
  /// It takes another triplet and updates results.
  void          consider(int index,float value) 
  {
    float current=(data[index]+=value);
    if(current<_min){
      _min=current; _whMin=index;
    }
    if(current>_max){
      _max=current; _whMax=index;
    }
    consideredN++;
    consideredSum+=value;
  }
  
  ///  It replaces value denoted by another index and updates results.
  void         replaceAt(int index,float value)
  {
    float oldValue=data[index];
    consideredSum-=oldValue;
    data[index]=value;
    consideredSum+=value;
    resetMinMax(); //Min-Max may be invalid from now! :-/
  }
  
  void   multiplyElement(int index,float multiplier) { data[index] *= multiplier; resetMinMax();}
  void     divideElement(int index,float divider)    { data[index] /= divider; resetMinMax(); }
  
  void  _calculateMinMax()
  {
    for(int i=0;i<data.length;i++){
      float current=data[i];
      if(current<_min){
        _min=current; _whMin=i;
      }
      if(current>_max){
        _max=current; _whMax=i;
      }
    }
  }
  
  int nonZeroCells()
  {
    int counter=0;
    for(int i=0;i<data.length;i++)
          if(data[i]!=0)
             counter++;
             
    return counter;         
  }
  
  /// @brief It calculates "Gini coefficient".
  /// @details Difference algorithm from "https://en.wikipedia.org/wiki/Gini_coefficient"
  /// @note It requires copying to the table because there may be missing values in the list.
  float getGiniCoefficient() 
  {  
    // Creating temporary data
    int maxN=data.length;

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
      double SumOfDiffs=0,SumOfVals=0;
      for(int i=0;i<N;i++)
      {
        for(int j=0;j<N;j++)
        {
          SumOfDiffs+=Math.abs(locData[i]-locData[j]);
        }
        SumOfVals+=locData[i];
      }
      
      if((SumOfVals/=N)==0) return INF_NOT_EXIST; // Bo też by było dzielenie przez 0
      
      return (float)(SumOfDiffs/(2*N*N*SumOfVals));
    }
    else 
    return INF_NOT_EXIST;
  }
  
  float getShannonEntropy() 
  {
    int inBuck=size();
    
    FloatList reBuck=new FloatList();
    float sum=0;                          //println(name());
    for(int i=0;i<inBuck;i++)
    {
      float value=get(i);                 //print(i,"]=",value,' ');
      if(value>0){
        sum+=value;
        reBuck.append(value);
      }
    }
                                          //println("");
    if(sum>0) {
      float S=0;                                      
      for(float value:reBuck)
      {
        value/=sum; // Udział w całości czyli prawdopodobieństwo przejścia
        value=value*log2(value);
        S+=value;
      }
      return -S;
    } else                                     
    return INF_NOT_EXIST; //NIE DAŁO SIĘ POLICZYĆ -  fNaN; // może lepiej?
  }
  
} //_endOfClass AddersSet1D

/** @brief ... */
class AddersSet2D extends NamedData implements i2DDataSample {
  int         consideredN=0;         //!< number of considered values.
  double      consideredSum=0;       //!< sum of considered values.
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
  AddersSet2D(String iniName,int iniRows,int iniColumns) { super/*NamedData*/(iniName);
    _R=iniRows; _C=iniColumns;
    data=new float[_R][_C];
  }
  
  /** @brief MinMax reset */
  void resetMinMax() {
    _min=+MAX_FLOAT; _whMinC=-1;_whMinR=-1;
    _max=-MAX_FLOAT; _whMaxC=-1;_whMaxR=-1;
  }
  
  /** @brief Data only reset */
  void reset() {
    resetMinMax();         //Min-Max may be invalid from now!
    consideredN=0;         // clears number of considered values.
    consideredSum=0;       // clears sum of considered values.
    for(int i=0;i<data.length;i++) //reset data
    for(int j=0;j<data[i].length;j++)
          data[i][j]=0;
  }
  
  /// It takes another triplet and updates results.
  void          consider(int indexR,int indexC,float value) 
  {
    float current=(data[indexR][indexC]+=value); //SUMUJE!!!
                                                 //println('[',indexR,',',indexC,"]=",current,';');
    if(current<_min){
      _min=current; _whMinR=indexR; _whMinC=indexC;
    }
    if(current>_max){
      _max=current; _whMaxR=indexR; _whMaxC=indexC;
    }
    
    consideredN++;
    consideredSum+=value;
  }
  
  ///  It replaces value denoted by another triplet and updates results.
  void          replaceAt(int indexR,int indexC,float value)
  {
    float oldValue=data[indexR][indexC];
    consideredSum-=oldValue;
    data[indexR][indexC]=value;
    consideredSum+=value;
    resetMinMax(); //Min-Max may be invalid from now! :-/
  }
    
  // OTHERS REQUIRED BY INTERFACES:
  //*//////////////////////////////  
  boolean       isOption(int mask) { return false; } //!< There is no any options for now.  
  int               size() { return _R*_C; }
  int      numOfElements() { return _R*_C; }
  int              width() { return _C; }
  int            columns() { return _C; }
  int       numOfColumns() { return _C; }
  int             height() { return _R; }
  int               rows() { return _R; }
  int          numOfRows() { return _R; }
  iIntPair      whereMin() { if(_whMinC==-1) _calculateMinMax(); return new Int2(_whMinR,_whMinC); }
  iIntPair      whereMax() { if(_whMaxC==-1) _calculateMinMax(); return new Int2(_whMaxR,_whMaxC); }
  float           getMin() { if(_whMinC==-1) _calculateMinMax(); return _min; }
  float           getMax() { if(_whMaxC==-1) _calculateMinMax(); return _max; }
  
  void          consider(float value) { /* DOES NOTHING */ }

  void         replaceAt(int index,float val)   { replaceAt(index/_C,index%_C,val); }
  
  float              get(int indexR,int indexC) { return data[indexR][indexC]; }
  float              get(int index)             { return get(index/_C,index%_C); }
  float     getElementAt(int index)             { return get(index/_C,index%_C); }
  float     getElementAt(int indexR,int indexC) { return data[indexR][indexC]; }
  

  void  _calculateMinMax()
  {
    for(int r=0;r<_R;r++)
     for(int c=0;c<data.length;c++){
      float current=get(r,c);
      if(current<_min){
        _min=current; _whMinR=r;_whMinC=c;
      }
      if(current>_max){
        _max=current; _whMaxR=r;_whMaxC=c;
      }
    }
  }
  
  int nonZeroCells()
  {
    int counter=0;
    for(int i=0;i<data.length;i++)
      for(int j=0;j<data[i].length;j++)
          if(data[i][j]!=0)
             counter++;
             
    return counter;         
  }

  float getShannonEntropy() 
  {
    int inBuck=size();
    
    FloatList reBuck=new FloatList();
    float sum=0;                          //println(name());
    for(int i=0;i<inBuck;i++)
    {
      float value=get(i);                 //print(i,"]=",value,' ');
      if(value>0){
        sum+=value;
        reBuck.append(value);
      }
    }
                                          //println("");
    if(sum>0) 
    {
      float S=0;                                      
      for(float value:reBuck)
      {
        value/=sum; // Udział w całości czyli prawdopodobieństwo przejścia
        value=value*log2(value);
        S+=value;
      }
      return -S;
    } else return INF_NOT_EXIST; //NIE DAŁO SIĘ POLICZYĆ -  fNaN; // może lepiej?
  }
  
} //_endOfClass AddersSet2D

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
    
  /// @brief It takes the real value & updates the corresponding bucket.
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
      outsideHig++; if(debug_utils>0) println("class `Frequencies`:",index,"is out of bound, for value=",value);
    }

  }
  
  /// @brief Checks if it is active.
  boolean isEnabled() {
    if(_enabled==null) return true; // No flag, so "enabled" by default.
    return _enabled.isEnabled();
  }
    
  /// @brief It considers whole series of data!
  /// @param src points to series of values, and is not remembered!
  void consider(iDataSample src)
  {
    for(int i=0;i<src.size();i++) {
        consider(src.get(i)); //print(src.get(i),';');
    }
    //println();
  }
  
  // OTHERS REQUIRED BY INTERFACES:
  //*//////////////////////////////
  boolean   isOption(int mask) { return (options & mask)==mask; } //!< They will check the options according to masks.    
  int  numOfElements() { return buckets.length;}   //!< @note In this case, the items are histogram buckets.
  int           size() { return buckets.length;}   //!< @note In this case, the items are histogram buckets.
  float getElementAt(int index) { if(0<=index && index<buckets.length ) return buckets[index]; else return INF_NOT_EXIST; }
  float          get(int index) { if(0<=index && index<buckets.length ) return buckets[index]; else return INF_NOT_EXIST; }
  void     replaceAt(int index,float value) { /* DO NOTHING! */ }
  float       getMin() { return 0; }
  float       getMax() { return higherBucket; }
  int       whereMin() { return INVALID_INDEX; }
  int       whereMax() { return higherBucketIndex; }
  /// Change color!
  void      setColor(color fullColor) { _color=fullColor; }
  /// Give color!
  color     getColor() { return _color; }

} //_endOfClass Frequencies

//*/////////////////////////////////////////////////////////////////////////////
/// See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI"
/// See: "https://github.com/borkowsk/sym4processing"
//* USEFUL COMMON CODES - HANDY FUNCTIONS & CLASSES
/// @}
//*/////////////////////////////////////////////////////////////////////////////        
