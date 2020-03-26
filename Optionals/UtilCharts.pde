// Functions & classes for chart making
///////////////////////////////////////////////////////////////////////////////////////////

class Range
{
  float min=+Float.MAX_VALUE;
  float max=-Float.MAX_VALUE;
  
  void addValue(float value)
  {
    if(max<value)
    {
      max=value;
    }
    if(min>value)
    {
      min=value;
    }
  }
}

class Sample
// For representing series of numbers
{
  FloatList data=null;
  float   min=+Float.MAX_VALUE;
  int   whmin=-1;
  float   max=-Float.MAX_VALUE;
  int   whmax=-1;
  float   sum=0;
  
  Sample()
  {
    data=new FloatList();
  }
  
  int  numOfElements() { return data.size();}
  
  void reset()
  {
    data.clear();
    min=-Float.MAX_VALUE;
    whmin=-1;
    max=-Float.MAX_VALUE;
    whmax=-1;
    sum=0;    
  }
  
  void addValue(float value)
  {         
    data.append(value);
    sum+=value;
    
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
  
}

class Frequencies
// For representimg frequencies 
{
  private int[]   buckets=null;
  float   sizeOfbucket=0;//(Max-Min)/N;
  float   lowerb=+Float.MAX_VALUE;
  float   upperb=-Float.MAX_VALUE;
  int     outsideLow=0;
  int     outsideHig=0;
  int     inside=0;
  int     higherBucket=0;
  int     higherBucketIndex=-1;

  Frequencies(int numberOfBuckets,float lowerBound, float upperBound)
  {
    buckets=new int[numberOfBuckets];
    lowerb=lowerBound;
    upperb=upperBound;
    sizeOfbucket=(upperBound-lowerBound)/numberOfBuckets;
  }
  
  int  numOfElements() { return buckets.length;}
  
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
  
  void addValue(float value)
  {
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
}

void viewAxis(int startX,int startY,int width,int height)
{
  line(startX,startY,startX+width,startY);
  line(startX+width-5,startY-5,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+5,startY-height+5,startX,startY-height);
  line(startX-5,startY-height+5,startX,startY-height);
}

void viewFrame(int startX,int startY,int width,int height)
{
  line(startX,startY,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+width,startY,startX+width,startY-height);
  line(startX,startY-height,startX+width,startY-height);
}

void viewTicsV(int startX,int startY,int width,int height,float space)
{
  for(int y=startY;y>startY-height;y-=space)
     line(startX,y,startX+width,y);
}

void viewTicsH(int startX,int startY,int width,int height,float space)
{
  for(int x=startX;x<startX+width;x+=space)
     line(x,startY,x,startY-height);
}

void viewAsPoints(Sample data,int startX,int startY,int width,int height,boolean logaritm,Range commMinMax)
{
  float min,max;
  if(commMinMax!=null)
  {
    min=(logaritm?(float)Math.log10(commMinMax.min+1):commMinMax.min);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    max=(logaritm?(float)Math.log10(commMinMax.max+1):commMinMax.max);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność    
  }
  else
  {
    min=(logaritm?(float)Math.log10(data.min+1):data.min);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    max=(logaritm?(float)Math.log10(data.max+1):data.max);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  }
  int     N=data.numOfElements(); 
  float wid=float(width)/N;  //println(N,min,max,wid);
  
  for(int t=0;t<N;t++)
  {
    float val=data.data.get(t);
    if(logaritm)
      val=map((float)Math.log10(val+1),min,max,0,height);    
    else 
      val=map(val,min,max,0,height);
    
    float x=t*wid;
    point(startX+x,startY-val); //println(startX+x,startY-val);
    
    if(t==data.whmax || t==data.whmin)
    {
      textAlign(LEFT,TOP);
      text(""+data.data.get(t),startX+x,startY-val);
    }
  }
  
}

float viewAsColumns(Frequencies hist,int startX,int startY,int width,int height,boolean logaritm)
{
  float max=(logaritm?(float)Math.log10(hist.higherBucket+1):hist.higherBucket);//+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  int wid=width/hist.buckets.length;
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
  float realwidth=(hist.buckets.length)*wid;//println(realwidth);
  return realwidth;
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
