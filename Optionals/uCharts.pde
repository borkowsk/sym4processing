/// @file uCharts.pde
/// Functions & classes useable for making charts.
/// @date 2023.03.04 (Last modification)
//*///////////////////////////////////////////////////////////////////////////

//final float INF_NOT_EXIST=Float.MAX_VALUE;///< needed somewhere

/// A class that implements only the interface having a proper object name.
class NamedData implements iNamed
{
  String myName;
  NamedData(String Name){ myName=Name; }
  String name() {return myName;}
}//EndOfClass

/// Class of a NAMED range of real (float) numbers.
class Range extends NamedData
{
  float min=+Float.MAX_VALUE; //!< Current minimal value
  float max=-Float.MAX_VALUE; //!< Current maximal value
  
  /// Constructor need only a name
  Range(String Name){ super(Name); }
  
  /// Adding a value to a range can make it wider. 
  void addValue(float value) 
  {
    if(value==INF_NOT_EXIST) return;
    
    if(max<value)
    {
      max=value;
    }
    
    if(min>value)
    {
      min=value;
    }
  }
}//EndOfClass

/// This class represents a NAMED series of real (float) numbers.
/// Should it also be a descendant of the Range? 
/// ... Or at least implements the same interface? TODO?
class Sample  extends NamedData
{
  FloatList data=null;
  
  // For statistics
  int    count=0;               //!< How much data has been entered (not counting INF_NOT_EXIST)
  float   min=+Float.MAX_VALUE; //!< Current minimal value
  int   whmin=-1;               //!< Position of the current minimal value
  float   max=-Float.MAX_VALUE; //!< Current maximal value
  int   whmax=-1;               //!< Position of the current maximal value
  double   sum=0;               //!< The current sum of values 
  
  /// Constructor need only a name.
  Sample(String Name) { super(Name); data=new FloatList(); }
  
  /// Adding values to a series immediately updates the base stats.
  void addValue(float value)
  {        
    data.append(value);
    
    if(value==INF_NOT_EXIST) return; //Nothing to do.
    
    sum+=value;
    count++; //Real value, not empty one!
    
    if(max<value)
    {
      max=value;
      whmax=data.size()-1; //print("^");
    }
    if(min>value)
    {
      min=value;
      whmin=data.size()-1; //print("v");
    }
  }
  
  /// It provides number of recorded values.
  /// Together with empty entries equal to INF_NOT_EXIST!
  int  numOfElements() { return data.size(); }
  
  /// Ready to start collecting data again.
  void reset()
  {
    data.clear();
    min=-Float.MAX_VALUE;
    whmin=-1;
    max=-Float.MAX_VALUE;
    whmax=-1;
    sum=0;  
    count=0;
  }
  
  /// Secured reading of the minimum.
  float getMin()
  {
    if(count>0) return min;
    else return INF_NOT_EXIST;
  }
  
  /// Secured reading of the maximum.
  float getMax()
  {
    if(count>0) return max;
    else return INF_NOT_EXIST;
  }
  
  /// Secured reading of the the mean.
  float getMean()
  {
    if(count>0) return (float)(sum/count);
    else return INF_NOT_EXIST;
  }
  
  /// Secured reading of the standard deviation.
  float getStdDev()
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
                                  assert N==count;
    return (float)(kwadraty/N);
  }
}//EndOfClass

/// This class represens a named histogram of frequencies. 
class Frequencies extends NamedData
{
  private int[]   buckets=null;
  float   sizeOfbucket=0; //(Max-Min)/N;
  float   lowerb=+Float.MAX_VALUE;
  float   upperb=-Float.MAX_VALUE;
  int     outsideLow=0;
  int     outsideHig=0;
  int     inside=0;
  int     higherBucket=0;
  int     higherBucketIndex=-1;

  /// Constructor needs more than a name.
  Frequencies(int numberOfBuckets,float lowerBound, float upperBound,String Name)
  {
    super(Name);
    buckets=new int[numberOfBuckets];
    lowerb=lowerBound;
    upperb=upperBound;
    sizeOfbucket=(upperBound-lowerBound)/numberOfBuckets;
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
  
  /// Adding the real value updates the corresponding bucket.
  void addValue(float value)
  {
    if(value==INF_NOT_EXIST) return;
    
    if(value<lowerb)
      {outsideLow++;return;}
    
    if(value>upperb) 
      {outsideHig++;return;}    
    
    int index=(int)((value-lowerb)/sizeOfbucket);
         
    buckets[index]++;
    
    if(higherBucket<buckets[index])
      {higherBucket=buckets[index];higherBucketIndex=index;}
    
    inside++;
  }
}//EndOfClass

/// Visualizes the axes of the coordinate system.
void viewAxis(int startX,int startY,int width,int height)
{
  line(startX,startY,startX+width,startY);
  line(startX+width-5,startY-5,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+5,startY-height+5,startX,startY-height);
  line(startX-5,startY-height+5,startX,startY-height);
}

/// Visualizes a box around the area.
void viewFrame(float startX,float startY,int width,int height)
{
  line(startX,startY,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+width,startY,startX+width,startY-height);
  line(startX,startY-height,startX+width,startY-height);
}

/// Draws tics along the vertical axis.
void viewTicsV(int startX,int startY,int width,int height,float space)
{
  for(int y=startY;y>startY-height;y-=space)
     line(startX,y,startX+width,y);
}

/// Draws tics along the horizontal axis.
void viewTicsH(float startX,float startY,float width,float height,float space)
{
  for(int x=int(startX);x<startX+width;x+=space)
     line(x,startY,x,startY-height);
}

/// Visualizes the limits of the vertical scale.
/// NOTE: We're not drawing dashes here yet (tics)
void viewScaleV(Range MinMax,int startX,int startY,int width,int height)//,boolean logaritm)
{
   //float min=(logaritm?(float)Math.log10(MinMax.min+1):MinMax.min);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   //float max=(logaritm?(float)Math.log10(MinMax.max+1):MinMax.max);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   textAlign(LEFT,TOP);
   text(""+MinMax.min,startX+width,startY);
   text(""+MinMax.max,startX+width,startY-height);
}

/// Visualization of data series as a series of points or a continuous line.
void viewAsPoints(Sample data,      //!< Data source. The object containing the data to be visualized
                  int startD,       //!< Data starting point, or end-to-end number if negative
                  float startX,     //!< The horizontal starting point of the display area 
                  float startY,     //!< The vertical starting point of the display area 
                  int width,        //!< The width of the display area
                  int height,       //!< Height of the display area
                  boolean logaritm, //!< Should the data be transformed by logarith?
                  Range commMinMax, //!< Optionally common Range for multiple series or null
                  boolean connect   //!< Should data points be combined into a single line?
                  )
{
  float min,max;
  if(commMinMax!=null)
  {
    min=(logaritm?(float)Math.log10(commMinMax.min+1):commMinMax.min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    max=(logaritm?(float)Math.log10(commMinMax.max+1):commMinMax.max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność    
  }
  else
  {
    min=(logaritm?(float)Math.log10(data.min+1):data.min); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    max=(logaritm?(float)Math.log10(data.max+1):data.max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  }
  
  int     N=data.numOfElements();                          assert startD<N-1;
  if(startD<0)
  {
      startD=-startD;  //Ujemne było tylko umownie!!!
      startD=N-startD; //Ileś od końca
  }
  if(startD<0) //Nadal ujemne!?
  {
      startD=0; //Czyli zabrakło danych!
                //print("?");
  }
  float wid=float(width)/(N-startD);  //println(width,N,startD,wid,min,max);
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
      val=map((float)Math.log10(val+1),min,max,0,height);    
    else 
      val=map(val,min,max,0,height);
    
    float x=(t-startD)*wid;
    if(connect && oldy!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldy,startX+x,startY-val);//println(wid,x-wid,oldy,x,val);
    }
    else
    {
                                                          //println(startX+x,startY-val);
      line(startX+x+2,startY-val,startX+x-1,startY-val); 
      line(startX+x,startY-val+2,startX+x,startY-val-1); 
    }
    
    if(connect) oldy=val;
    
    if(t==data.whmax || t==data.whmin)
    {
      textAlign(LEFT,TOP);
      text(""+data.data.get(t),startX+x,startY-val);
    }
  }
}

/// Bar visualization of a histogram or something similar.
float viewAsColumns(Frequencies hist, //!< Data source. The object containing the data to be visualized
                    float startX,     //!< The horizontal starting point of the display area 
                    float startY,     //!< The vertical starting point of the display area 
                    int width,        //!< The width of the display area
                    int height,       //!< The height of the display area
                    boolean logaritm  //!< Should the data be transformed by logarith?
                    )
{
  float max=(logaritm?(float)Math.log10(hist.higherBucket+1):hist.higherBucket);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  int wid=width/hist.buckets.length; //println(width,wid);
  if(wid<1) wid=1;
  
  for(int i=0;i<hist.buckets.length;i++)
  {
    float hei;
    if(logaritm)
      hei=map((float)Math.log10(hist.buckets[i]+1),0,max,0,height);    
    else 
      hei=map(hist.buckets[i],0,max,0,height);
    
    rect(startX+i*wid,startY,wid,-hei);
  }
  
  textAlign(LEFT,BOTTOM);
  text(""+max+(logaritm?"<="+hist.higherBucket+" @ "+hist.higherBucketIndex:" @ "+hist.higherBucketIndex),startX,startY-height);
  
  //Real width of histogram
  float realwidth=(hist.buckets.length)*wid;//println(realwidth);noLoop();
  return realwidth;
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////
