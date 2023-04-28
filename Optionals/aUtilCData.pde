/** 
 *   @file "uUtilCData.pde"
 *   @defgroup Data collection classes for statistics & chart making 
 *   @date 2023.04.28 (Last modification)
 *   @author borkowsk 
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

  /// Zmiana wartości na przeciwna.
  void toggle() { _val=!_val; }
  
  /*_interfunc*/ void set(boolean isEnabled){ _val=isEnabled; }
  /*_interfunc*/ boolean isEnabled(){ return _val; }
} //_endOfClass ViewSwitch

/// @brief Base class for data sources.
/// @details 
///      A class that implements only the interface having a proper object name.
class NamedData implements iNamed 
{
  String _myName; //!< current name.
  
  NamedData(String Name){ _myName=Name;}
  
  String name() {return _myName;}
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
/// @todo 
///   Should it also be a descendant of the Range? 
///   ... Or at least implements the same interface? TODO?
class Sample  extends NamedData 
{
  FloatList  data=null;         //!< lista wartości danych.
  int        options=0;         //!< Słowo 32b do dowolnego wykorzystania 
  
  color    _color=color(0,0,0); //!< color, if need be same in different graphs
  iFlag  _enabled=null;         //!< Enabling flag.
      
  // For statistics
  int    count=0;               //!< How much data has been entered (not counting INF_NOT_EXIST)
  float   Min=+Float.MAX_VALUE; //!< Current minimal value
  int   whMin=-1;               //!< Position of the current minimal value
  float   Max=-Float.MAX_VALUE; //!< Current maximal value
  int   whMax=-1;               //!< Position of the current maximal value
  double   sum=0;               //!< The current sum of values 
  
  /// @brief Konstruktor z samą nazwą.
  //*  For pr2c `super` must be in the same line with constructor name!
  Sample(String Name) { super/*NamedData*/(Name);
    _enabled=new ViewSwitch(true);
    data=new FloatList();
  }
  
  /// @brief Konstruktor trójparametrowy.
  /// @p   Name - nazwa 
  /// @p   defColor - kolorem wyświetlania
  /// @p   defEnabled - referencją do flagi wyświetlania, od której zależy seria.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name,color defColor,iFlag defEnabled) { super/*NamedData*/(Name);
    data=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
  }
  
  /// @brief Konstruktor wieloparametrowy.
  /// @p   Name - nazwa 
  /// @p   defColor - kolorem wyświetlania
  /// @p   defEnabled - referencją do flagi wyświetlania, od której zależy seria.
  /// @p   iOptions - opcje o różnych znaczeniach.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name,color defColor,iFlag defEnabled,int iOptions) { super/*NamedData*/(Name);
    data=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
    options=iOptions;
  }
 
  color   getColor() //!< Daje kolor.
  {
    return _color;
  }
  
  boolean isEnabled() //!<Sprawdza czy aktywny.
  {
    return _enabled.isEnabled();
  }
 
  boolean isOption(int mask) //!< Sprawdzą opcje wg. maski.
  {
    return (options & mask)!=0;
  }
  
  int  numOfElements() //!< Długość serii. Razem z pustymi, czyli też == INF_NOT_EXIST
  { 
     return data.size(); 
  }
  
  float getLast() //!< Ostatnia wartość serii.
  {
    if(data.size()>0)
      return data.get(data.size()-1);
    else
      return INF_NOT_EXIST;
  }
  
  void reset() //!< Czyszczenie z danych.
  {
    if(data!=null) data.clear();
    Min=Float.MAX_VALUE;
    whMin=-1;
    Max=-Float.MAX_VALUE;
    whMax=-1;
    sum=0;  
    count=0;
  }
  
  /// @brief Skrócenie serii do 'longOfremained' ostatnich elementów. 
  /// @todo name! `longOfRemained`
  void remain(int longOfremained)   
  {
    if(longOfremained>=data.size())
          return; //Nothing to do!
                                   //println(name(),data.size(),longOfremained);
    FloatList olddata=data; //TODO name! oldData
    data=null; //Odcinamy
    reset();
    data=new FloatList(longOfremained*2); //Initial capacity?
                                //println(name(),olddata.size(),longOfremained);
    int i=olddata.size()-longOfremained;
    int end=olddata.size();
    for(;i<end;i++)
      addValue(olddata.get(i));
  }
  
  float getMin() //!< Dostęp do aktualnego minimum.
  {
    if(count>0) return Min;
    else return INF_NOT_EXIST;
  }
  
  float getMax()  //!< Dostęp do aktualnego maximum.
  {
    if(count>0) return Max;
    else return INF_NOT_EXIST;
  }
  
  float getMean()  //!< Dostęp do aktualnej średniej.
  {
    if(count>0) return (float)(sum/count);
    else return INF_NOT_EXIST;
  }
  
  float getHarmMean() //!< aktualna średnia harmoniczna
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double odwroty=0;
    
    for(float val:data)
    if(val!=INF_NOT_EXIST && val!=0)
    {
      odwroty+=1.0/((double)val);
      N++;
    }
    
    if(odwroty==0) return INF_NOT_EXIST;
    else return (float)(N/odwroty);
  }
  
  float getQuadMean() //!< aktualna średnia kwadratowa
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double kwadraty=0;
    
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
  
  /// @brief Aktualna średnia o arbitralne potędze. 
  /// @note  Może być zarówno ułamek jak i większa liczba niż 2, np. 1/3 albo 3.
  float getPowMean(float power) //!< 'power' to zadana potęga uśredniania.
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double potegi=0; //TODO name! powers
    
    for(float val:data)
    if(val!=INF_NOT_EXIST)
    {
      potegi+=Math.pow(val,power);
      N++;
    }
    
    if(N==0) return INF_NOT_EXIST;
    double ret=potegi/N;
    
    if(ret==0) return INF_NOT_EXIST;
    double ex=1/power;
    ret=Math.pow(ret,ex);
    
    return (float)ret; 
  }
  
  float getStdDev() //!< Odchylenie standardowe.
  {
    if(count==0) return INF_NOT_EXIST;
    int    N=0;
    double kwadraty=0;
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
  
  /// @brief Liczy medianę z całej serii danych. 
  /// @note  Wymaga przekopiowania i posortowania,
  ///        więc może być bardzo kosztowne obliczeniowo.
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
  
  /// @brief Dodanie wartości na koniec serii.
  void addValue(float value) 
  {        
    data.append(value);
    
    if(value==INF_NOT_EXIST) return; //Nic więcej do zrobienia
    
    sum+=value;
    count++; //Realna wartość, a nie pusta!
    
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
  
  /// @brief podmiana ostatnio dodanej wartości na inną.
  void replaceLastValue(float value) 
  {
    data.set(data.size()-1,value);
  }
  
} //_endOfClass Sample

/// @brief   Class for representing frequencies.
/// @details This class represens a named histogram of frequencies. 
class Frequencies extends NamedData 
{
  int[]   buckets=null; //!< tablica koszyków histogramu.
  float   sizeOfbucket=0; //(Max-Min) / N; TODO name sizeOfBucket
  
  float   lowerb=+Float.MAX_VALUE; // TODO name?
  float   upperb=-Float.MAX_VALUE; // TODO name?
  int     outsideLow=0;
  int     outsideHig=0;
  int     inside=0;

  int     higherBucket=0;
  int     higherBucketIndex=-1;
  
  /// @brief   Constructor, which needs more than a name.
  /// @details For pr2c 'super' must be in the same line with constructor name!
  Frequencies(int numberOfBuckets,float lowerBound, float upperBound,String Name) { super/*NamedData*/(Name);
    buckets=new int[numberOfBuckets];
    lowerb=lowerBound;
    upperb=upperBound;
    sizeOfbucket=(upperBound-lowerBound) / numberOfBuckets;
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
    
    if(value<lowerb)
      {outsideLow++;return;}
    
    if(value>upperb) 
      {outsideHig++;return;}    
    
    int index=(int)((value-lowerb) / sizeOfbucket);
         
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

