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

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
