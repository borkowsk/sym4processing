/** 
 *   @file "uCharts.pde"
 *   @defgroup ChartUtils Functions & classes for chart making 
 *   @date 2023.04.11 (Last modification)
 *   @author borkowsk 
 *  @{
 */ ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//NO DATA marker.
final float INF_NOT_EXIST=Float.MAX_VALUE; ///< needed somewhere

/// @brief Mapping float value into color interface.
interface iColorMapper 
{
  /*_interfunc*/ color map(float value) /*_forcebody*/; 
} //_endOfClass iColorMapper

// Masks for Sample options
static final int CONNECT_MASK=0x1;  ///< ???
static final int LOGARITM_MASK=0x2; ///< TODO name! LOGARIT-H-M!
static final int PERCENT_MASK=0x4;  ///< ???

/// @brief Visualisable switch.
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
/// @details A class that implements only the interface having a proper object name.
class NamedData implements iNamed 
{
  String _myName; //!< current name.
  
  NamedData(String Name){ _myName=Name;}
  
  String name() {return _myName;}
} //_endOfClass NamedData

/// More extended base class for data sources.
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
  int        options=0;         //!< Słowo 32b do dowolnego wykorzystania w implementacji
  
  color    _color=color(0,0,0); //!< color, if need be same in different graphs
  iFlag  _enabled=null;         //!< Enabling flag.
      
  // For statistics
  int    count=0;               //!< How much data has been entered (not counting INF_NOT_EXIST)
  float   Min=+Float.MAX_VALUE; //!< Current minimal value
  int   whMin=-1;               //!< Position of the current minimal value
  float   Max=-Float.MAX_VALUE; //!< Current maximal value
  int   whMax=-1;               //!< Position of the current maximal value
  double   sum=0;               //!< The current sum of values 
  
  /// Konstruktor z samą nazwą.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name) { super/*NamedData*/(Name);
    _enabled=new ViewSwitch(true);
    data=new FloatList();
  }
  
  /// Konstruktor trójparametrowy.
  /// @p   Name - nazwa 
  /// @p   defColor - kolorem wyświetlania
  /// @p   defEnabled - referencją do flagi wyświetlania, od której zależy seria.
  //*  For pr2c 'super' must be in the same line with constructor name!
  Sample(String Name,color defColor,iFlag defEnabled) {  super/*NamedData*/(Name);
    data=new FloatList();
    _color=defColor;
    _enabled=defEnabled;
  }
  
  /// Konstruktor wieloparametrowy.
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
  
  void remain(int longOfremained) //!< Skrócenie serii do 'longOfremained' ostatnich elementów. TODO name! longOfRemained
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
  
  /// Aktualna średnia o arbitralne potędze. 
  /// Może być zarówno ułamek jak i większa liczba niż 2, np. 1/3 albo 3.
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
  /// więc może być bardzo kosztowne obliczeniowo.
  float getMedian()
  {
    if(count==0) return INF_NOT_EXIST; //<>//
    
    FloatList copied=new FloatList();             
    int    N=0;
    float val=INF_NOT_EXIST;
    
    for(int i=0;i<data.size();i++)
    if((val=data.get(i))!=INF_NOT_EXIST)
    {
      N++;
      copied.append(val);
    }

    if(N==0) return INF_NOT_EXIST;          assert N<=data.size();
    
    copied.sort();
    return copied.get(copied.size() / 2);
  }
  
  void addValue(float value) //!< Dodanie wartości na koniec serii.
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
  
  void replaceLastValue(float value) //!< podmiana ostatnio dodanej wartości na inną.
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
    
  /// In this case, the items are histogram buckets.
  int  numOfElements() { return buckets.length;}
  
  /// Ready to start collecting data again.
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
    
  /// It ads the real value  & updates the corresponding bucket.  
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

/// @brief Function for drawing axis.
/// @details Visualizes the axes of the coordinate system.
void viewAxis(int startX,int startY,int width,int height) ///< @NOTE GLOBAL
{ 
  line(startX,startY,startX+width,startY);
  line(startX+width-5,startY-5,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+5,startY-height+5,startX,startY-height);
  line(startX-5,startY-height+5,startX,startY-height);
}

/// @brief Function for drawing empty frame.
/// @details Visualizes a box around the area.
void viewFrame(float startX,float startY,int width,int height) ///< @NOTE GLOBAL
{ 
  line(startX,startY,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+width,startY,startX+width,startY-height);
  line(startX,startY-height,startX+width,startY-height);
}

/// @brief   Draws tics along the vertical axis.
/// @details Function for drawing tics on Y axis.
void viewTicsV(int startX,int startY,int width,int height,float space) ///< @NOTE GLOBAL
{ 
  for(int y=startY;y>startY-height;y-=space)
     line(startX,y,startX+width,y);
}

/// @brief Draws tics along the horizontal axis.
/// @details Function for drawing tics on X axis.
void viewTicsH(float startX,float startY,float width,float height,float space)
{
  for(int x=int(startX);x<startX+width;x+=space)
     line(x,startY,x,startY-height);
}

/// @brief Visualizes the limits of the vertical scale.
/// @note We're not drawing dashes here yet (tics)
/// @details Function for drawing scale on Y axis.
void viewScaleV(Range MinMax,int startX,int startY,int width,int height) ///< @NOTE GLOBAL
{ 
   //,boolean logarithm) //Na razie tu nie rysujemy kresek (tics)
   //float Min=(logarithm?(float)Math.log10(MinMax.min+1):MinMax.min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   //float Max=(logarithm?(float)Math.log10(MinMax.max+1):MinMax.max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   textAlign(LEFT,TOP);
   text(""+MinMax.Min,startX+width,startY);
   text(""+MinMax.Max,startX+width,startY-height);
}

/// Function drawing zero arrow, if visible.
void viewZeroArrow(Range MinMax,int startX,int startY,int width,int height,int lenght) ///< @NOTE GLOBAL
{
   if(MinMax.Min < 0 && 0<=MinMax.Max)
   {
     float val=map(0,MinMax.Min,MinMax.Max,0,height);
     textAlign(LEFT,TOP);
     text("0",startX+width,startY-val);             //stroke(0);//debug
     arrow(startX,startY-val,startX+width+lenght,startY-val);
   }
}

/** Funkcja wizualizująca serię danych jako punkty albo jako linię łamaną
 @param  Sample data : Źródło danych
 @param  int   startD : Punkt startowy wyświetlania, albo liczba od końca, gdy wartość ujemna
 @param  float startX,
 @param  float startY,
 @param  int width,
 @param  int height,
 @param  boolean logarithm,
 @param  Range commMinMax,
 @param  boolean connect : czy łączyć punkty w łamaną
*/
void viewAsPoints(Sample data,int startD,float startX,float startY,int width,int height,Range commMinMax,boolean connect,boolean percent) ///<  @NOTE GLOBAL. Musi być w jednej lini dla C++
{
  boolean logarithm=data.isOption(LOGARITM_MASK);
  float Min;
  float Max;

  if(commMinMax!=null)
  {
    if(percent) //Jak percent to już nie logarytm!
    {
      Min=commMinMax.Min;Max=commMinMax.Max;
    }
    else
    {
      Min=(logarithm?(float)Math.log10(commMinMax.Min+1):commMinMax.Min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
      Max=(logarithm?(float)Math.log10(commMinMax.Max+1):commMinMax.Max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    }
  }
  else
  {
    if(percent) //Jak percent to już nie logarytm!
    {
      Min=data.Min*100.0f;Max=data.Max*100.0f;
    }
    else
    {
      Min=(logarithm?(float)Math.log10(data.Min+1):data.Min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
      Max=(logarithm?(float)Math.log10(data.Max+1):data.Max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    }
  }
  
  int     N=data.numOfElements();                                                                     assert startD<N-1;

  if(startD<0)
  {
      startD=-startD; //Ujemne było tylko umownie!!!
      startD=N-startD; //Ileś od końca
  }
  if(startD<0) //Nadal ujemne!?
  {
      startD=0; //Czyli zabrakło danych
      //print("?");
  }
  float wid=float(width) / (N-startD);  //println(width,N,startD,wid,min,max);
  float oldy=-Float.MIN_VALUE;
  
  for(int t=startD;t<N;t++)
  {
    float val=data.data.get(t);
    
    if(val==INF_NOT_EXIST) 
    {
      oldy=-Float.MIN_VALUE;
      continue;
    }
    
    if(percent)
      val=map(val*100.0f,Min,Max,0,height);
    else if(logarithm)
      val=map((float)Math.log10(val+1),Min,Max,0,height);    
    else 
      val=map(val,Min,Max,0,height);
    
    float x=(t-startD)*wid;
    if(connect && oldy!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldy,startX+x,startY-val); //println(wid,x-wid,oldy,x,val);
    }
    else
    {
                                                          //println(startX+x,startY-val);
      line(startX+x+2,startY-val,startX+x-1,startY-val); 
      line(startX+x,startY-val+2,startX+x,startY-val-1); 
    }
    
    if(connect) oldy=val;
    
    if(t==data.whMax || t==data.whMin)
    {
      textAlign(LEFT,TOP);
      String etyk="";
      if(percent)
         etyk+=nf(data.data.get(t)*100.0,0,2)+"%";
      else
         etyk+=nf(data.data.get(t));
      text(etyk,startX+x,startY-val);
    }
  }
}

/**
  @brief Visualization of data series as a series of points or a continuous line.
  @param Sample data - Data source. The object containing the data to be visualized
  @param int startD - Data starting point, or end-to-end number if negative
  @param float startX - The horizontal starting point of the display area 
  @param float startY - The vertical starting point of the display area 
  @param int width - The width of the display area
  @param int height - Height of the display area
  @param boolean logaritm - Should the data be transformed by logarith?
  @param Range commMinMax - Optionally common Range for multiple series or null
  @param boolean connect - Should data points be combined into a single line?
  PL Funkcja wizualizująca serię danych jako punkty albo jako linię łamaną                
  PL:param Sample data : Źródło danych
  PL:param int startD  : Punkt startowy wyświetlania, albo liczba od końca  - gdy wartość ujemna
  PL:param float startX,float startY,int width,int height : Położenie i rozmiar
  PL:param boolean logaritm : CZY LOGARYTMOWAĆ DANE?
  PL:param Range commMinMax : ZADANY ZAKRES y
  PL:param boolean connect  : Czy łączyć punkty linią?
*/
void viewAsPoints(Sample data,int startD,float startX,float startY,int width,int height,boolean logaritm,Range commMinMax,boolean connect) /// @NOTE GLOBAL
{
  float Min;
  float Max;
  if(commMinMax!=null)
  {
    Min=(logaritm?(float)Math.log10(commMinMax.Min+1):commMinMax.Min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    Max=(logaritm?(float)Math.log10(commMinMax.Max+1):commMinMax.Max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność    
  }
  else
  {
    Min=(logaritm?(float)Math.log10(data.Min+1):data.Min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    Max=(logaritm?(float)Math.log10(data.Max+1):data.Max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  }
  
  int     N=data.numOfElements();                                                                     assert startD<N-1;
  if(startD<0)
  {
      startD=-startD; //Ujemne było tylko umownie!!!
      startD=N-startD; //Ileś od końca
  }
  if(startD<0) //Nadal ujemne!?
  {
      startD=0; //Czyli zabrakło danych
      //print("?");
  }
  float wid=float(width) / (N-startD);  //println(width,N,startD,wid,min,max);
  float oldy=-Float.MIN_VALUE;
  
  for(int t=startD;t<N;t++)
  {
    float val=data.data.get(t);
    if(val==INF_NOT_EXIST) 
    {
      oldy=-Float.MIN_VALUE;
      continue;
    }
    
    if(logaritm)
      val=map((float)Math.log10(val+1),Min,Max,0,height);    
    else 
      val=map(val,Min,Max,0,height);
    
    float x=(t-startD)*wid;
    if(connect && oldy!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldy,startX+x,startY-val); //println(wid,x-wid,oldy,x,val);
    }
    else
    {
                                                          //println(startX+x,startY-val);
      line(startX+x+2,startY-val,startX+x-1,startY-val); 
      line(startX+x,startY-val+2,startX+x,startY-val-1); 
    }
    
    if(connect) oldy=val;
    
    if(t==data.whMax || t==data.whMin)
    {
      textAlign(LEFT,TOP);
      text(""+data.data.get(t),startX+x,startY-val);
    }
  }
}

/** Funkcja wizualizująca serię danych jako pionowe linie w różnych kolorach
  @param Sample data : Źródło danych
  @param int startD  : Punkt startowy wyświetlania, albo liczba od końca  - gdy wartość ujemna
  @param float startX,float startY,int width,int height : Położenie i rozmiar
  @param iColorMapper mapper : mapowanie zdarzeń na kolory
*/
void viewAsVerticals(Sample data,int startD,float startX,float startY,int width,int height,iColorMapper mapper) ///< @NOTE GLOBAL. For C++ translation MUST be in one line!
{
  int     N=data.numOfElements();                                                                     assert startD<N-1;
  if(startD<0)
  {
      startD=-startD; //Ujemne było tylko umownie!!!
      startD=N-startD; //Ileś od końca
  }
  if(startD<0) //Nadal ujemne!?
  {
      startD=0; //Czyli zabrakło danych
      //print("?");
  }
  
  float wid=float(width) / (N-startD);  //println(width,N,startD,wid,min,max);
  
  for(int t=startD;t<N;t++)
  {
    float val=data.data.get(t);
    if(val==INF_NOT_EXIST) 
    {
      continue;
    }
    
    if(mapper!=null)
    {
      color cc=mapper.map(val);
      stroke(cc);
    }
    
    float x=(t-startD)*wid; //println(startX+x,startY-val);
    line(startX+x,startY,startX+x,startY-height);
    text(t,startX+x,startY);
  }
}

/// @brief Bar visualization of a histogram or something similar.
//* Funkcja wizualizująca serię danych jako kolumny w jednym kolorze. 
/// @details Głównie do wizualizacji frekwencji.
/// @param Frequencies hist - Data source. The object containing the data to be visualized
/// @param float startX - The horizontal starting point of the display area 
/// @param float startY - The vertical starting point of the display area 
/// @param int width - The width of the display area
/// @param int height - The height of the display area
/// @param boolean logaritm - Should the data be transformed by logarith?
float viewAsColumns(Frequencies hist,float startX,float startY,int width,int height,boolean logarithm) ///< RYSOWANIE HISTOGRAMU.
{
  float Max=(logarithm?(float)Math.log10(hist.higherBucket+1):hist.higherBucket); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  int wid=width/hist.buckets.length; //println(width,wid);
  if(wid<1) wid=1;
  
  for(int i=0;i<hist.buckets.length;i++)
  {
    float hei;
    if(logarithm)
      hei=map((float)Math.log10(hist.buckets[i]+1),0,Max,0,height);    
    else 
      hei=map(hist.buckets[i],0,Max,0,height);
    
    rect(startX+i*wid,startY,wid,-hei);
  }
  
  textAlign(LEFT,BOTTOM);
  text(""+Max
         +(logarithm ?
           "<=" +hist.higherBucket+
           " @ "+hist.higherBucketIndex :
           " @ "+hist.higherBucketIndex),startX,startY-height);
  //Real width of histogram
  float realwidth=(hist.buckets.length)*wid; //println(realwidth);noLoop(); TODO name! realWidth
  return realwidth;
}

//**********************************************************************************************************************
//* See "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - USEFUL COMMON CODES
//* See "https://github.com/borkowsk/RTSI_public"
///@} ******************************************************************************************************************
