// Functions & classes for chart making
///////////////////////////////////////////////////////////////////////////////////////////

class Sample
// For representing series of numbers
{
  FloatList[] data=null;
  float   min=-Float.MAX_VALUE;
  float   max=-Float.MAX_VALUE;
  float   sum=-Float.MAX_VALUE;
}

class Frequencies
// For representimg frequencies 
{
  private int[]   buckets=null;
  float   sizeOfbucket=0;//(Max-Min)/N;
  float   lowerb=-Float.MAX_VALUE;
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
  
  int  numOfBuckets() { return buckets.length;}
  
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

float viewAsColumns(Frequencies histogram,int startX,int startY,int width,int height)
{
  float max=histogram.higherBucket;
  int wid=width/histogram.buckets.length;
  if(wid<1) wid=1;
  
  for(int i=0;i<histogram.buckets.length;i++)
  {
    float hei=map(histogram.buckets[i],0,max,0,height);
    rect(startX+i*wid,startY,wid,-hei);
  }
  
  textAlign(LEFT,TOP);
  text(""+max,startX,startY-height);
  //Real width of histogram
  float realwidth=(histogram.buckets.length)*wid;//println(realwidth);
  return realwidth;
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
