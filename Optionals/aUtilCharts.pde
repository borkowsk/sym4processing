/** @file 
 *  @brief .... ("uCharts.pde")
 *  @defgroup ChartUtils Functions & classes for chart making 
 *  @date 2024-08-27 (last modification)                        @author borkowsk
 *  @details 
 *     It needs "uUtilCData.pde" & "uFigures.pde"
 *  @{
 */ ////////////////////////////////////////////////////////////////////////////

// Masks for Sample options:
//*/////////////////////////
static final int CONNECT_MASK=0x1;   ///< ???
static final int LOGARITHM_MASK=0x2; ///< ???
static final int PERCENT_MASK=0x4;   ///< ???
static final int TEXT_MASK=0x8;      ///< ???

/** @brief Function for drawing axis.
*   @details Visualizes the axes of the coordinate system. */
void viewAxis(int startX,int startY,int width,int height)                       ///< @note GLOBAL
{ 
  line(startX,startY,startX+width,startY);
  line(startX+width-5,startY-5,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+5,startY-height+5,startX,startY-height);
  line(startX-5,startY-height+5,startX,startY-height);
}

/** @brief Function for drawing empty frame.
* @details Visualizes a box around the area. */
void viewFrame(float startX,float startY,int width,int height)                  ///< @note GLOBAL
{ 
  line(startX,startY,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+width,startY,startX+width,startY-height);
  line(startX,startY-height,startX+width,startY-height);
}

/** @brief   Draws tics along the vertical axis.
*   @details Function for drawing tics on Y axis. */
void viewTicsV(int startX,int startY,int width,int height,float space)          ///< @note GLOBAL
{ 
  for(int y=startY;y>startY-height;y-=space)
     line(startX,y,startX+width,y);
}

/** @brief Draws tics along the horizontal axis.
* @details Function for drawing tics on X axis  */
void viewTicsH(float startX,float startY,float width,float height,float space)  ///< @note GLOBAL
{
  for(int x=int(startX);x<startX+width;x+=space)
     line(x,startY,x,startY-height);
}

/** @brief Visualizes the limits of the vertical scale.
*   @note We're not drawing dashes here yet (tics)
*   @details Function for drawing scale on Y axis.   */
void viewScaleV(iFloatRange MinMax,int startX,int startY,int width,int height)        ///< @note GLOBAL
{ 
   //,boolean logarithm) //We are not drawing tics here for now
   //float Min=(logarithm?(float)Math.log10(MinMax.min+1):MinMax.min); //+1 doesn't change much visually, but it guarantees computability
   //float Max=(logarithm?(float)Math.log10(MinMax.max+1):MinMax.max); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
   textAlign(LEFT,TOP);
   text(""+MinMax.getMin(),startX+width,startY);
   text(""+MinMax.getMax(),startX+width,startY-height);
}

/// @brief Visualise horisontal asymptotic straight line
void viewHorizontalAsymptote(float val,iFloatRange MinMax,int startX,int startY,int width,int height)        ///< @note GLOBAL
{
   if( MinMax.getMin() <= 0 && 0<=MinMax.getMax() && MinMax.getMin()!=MinMax.getMax() )
   {
     float mval=map(val,MinMax.getMin(),MinMax.getMax(),0,height); //@todo RENAME mval
     textAlign(LEFT,TOP);
     text(val,startX+width,startY-mval);
     line(startX,startY-mval,startX+width,startY-mval);
   }
}

/// @brief Function drawing zero arrow, if visible.
void viewZeroArrow(iFloatRange MinMax,int startX,int startY,int width,int height,int length) ///< @NOTE GLOBAL
{
   if( MinMax.getMin() <= 0 && 0<=MinMax.getMax() && MinMax.getMin()!=MinMax.getMax() )
   {
     float val=map(0,MinMax.getMin(),MinMax.getMax(),0,height);
     textAlign(LEFT,TOP);
     text("0",startX+width,startY-val);             //stroke(0);//debug
     arrow(startX,startY-val,startX+width+length,startY-val);
   }
}

/** @brief A function that visualizes a series of data as points or as a broken line
 @param  data : Data source
 @param  startD : The starting point of the display, or the number from the end if negative
 @param  startX,
 @param  startY,
 @param  width,
 @param  height,
 @param  logarithm,
 @param  commMinMax,
 @param  connect : or connect points into a polyline (true/false)                              */
void viewAsPoints(iDataSample data,int startD,float startX,float startY,int width,int height,iFloatRange commMinMax,boolean connect,boolean percent) ///<  @NOTE GLOBAL. Musi być w jednej lini dla C++
{
  boolean logarithm=data.isOption(LOGARITHM_MASK);
  float Min;
  float Max;

  if(commMinMax!=null)
  {
    if(percent) //Jak percent to już nie logarytm!
    {
      Min=commMinMax.getMin();Max=commMinMax.getMax();
    }
    else
    {
      Min=(logarithm?(float)Math.log10(commMinMax.getMin()+1):commMinMax.getMin()); //+1 doesn't change much visually, but it guarantees computability
      Max=(logarithm?(float)Math.log10(commMinMax.getMax()+1):commMinMax.getMax()); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
    }
  }
  else
  {
    if(percent) //If a percent is no longer a logarithm!
    {
      Min=data.getMin()*100.0f;Max=data.getMax()*100.0f;
    }
    else
    {
      Min=(logarithm?(float)Math.log10(data.getMin()+1):data.getMin()); //+1 doesn't change much visually, but it guarantees computability
      Max=(logarithm?(float)Math.log10(data.getMax()+1):data.getMax()); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
      //println("Range:",Min,"..",Max);
    }
  }
  
  int     N=data.numOfElements();                                               assert startD<N-1;

  if(startD<0)
  {
      startD=-startD;  //It was only conventionally negative!!!
      startD=N-startD; //Somewhere from the end
  }

  if(startD<0) //Still negative!?
  {
      startD=0; //So there was no data                           //print("?");
  }

  float wid=float(width) / (N-startD);    //println(width,N,startD,wid,min,max);
  float oldy=-Float.MIN_VALUE;
  
  for(int t=startD;t<N;t++)
  {
    float val=data.get(t);
    
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
      line (startX+x-wid,startY-oldy,startX+x,startY-val); 
                                                //println(wid,x-wid,oldy,x,val);
    }
    else
    {
                                                 //println(startX+x,startY-val);
      line(startX+x+2,startY-val,startX+x-1,startY-val); 
      line(startX+x,startY-val+2,startX+x,startY-val-1); 
    }
    
    if(connect) oldy=val;
    
    if(t==data.whereMax() || t==data.whereMin())
    {
      textAlign(LEFT,TOP);
      String etyk="";
      if(percent)
         etyk+=nf(data.get(t)*100.0,0,2)+"%";
      else
         etyk+=nf(data.get(t));
      text(etyk,startX+x,startY-val);
    }
  }
}

/**
  @brief Visualization of data series as a series of points or a continuous line.
  @param data - Data source. The object containing the data to be visualized
  @param startD - Data starting point, or end-to-end number if negative
  @param startX - The horizontal starting point of the display area
  @param startY - The vertical starting point of the display area
  @param width - The width of the display area
  @param height - Height of the display area
  @param logarithm - Should the data be transformed by logarithm?
  @param commMinMax - Optionally common `Range` for multiple series or null
  @param connect - Should data points be combined into a single line (true/false)?
*/ /*
  PL: Funkcja wizualizująca serię danych jako punkty albo jako linię łamaną
  PL:param Sample data : Źródło danych
  PL:param int startD  : Punkt startowy wyświetlania, albo liczba od końca - gdy ujemna
  PL:param float startX,float startY,int width,int height : Położenie i rozmiar
  PL:param boolean logaritm : CZY LOGARYTMOWAĆ DANE?
  PL:param Range commMinMax : ZADANY ZAKRES y
  PL:param boolean connect  : Czy łączyć punkty linią?    */
void viewAsPoints(iDataSample data,int startD,float startX,float startY,int width,int height,boolean logarithm,iFloatRange commMinMax,boolean connect) /// @NOTE GLOBAL
{
  float Min,Max;
  
  if(commMinMax!=null)
  {
    Min=(logarithm?(float)Math.log10(commMinMax.getMin()+1):commMinMax.getMin()); //+1 doesn't change much visually, but it guarantees computability
    Max=(logarithm?(float)Math.log10(commMinMax.getMax()+1):commMinMax.getMax()); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność    
  }
  else
  {
    Min=(logarithm?(float)Math.log10(data.getMin()+1):data.getMin()); //+1 doesn't change much visually, but it guarantees computability
    Max=(logarithm?(float)Math.log10(data.getMax()+1):data.getMax()); //+1 wizualnie niewiele zmienia a gwarantuje obliczalność
  }
  
  int     N=data.numOfElements();                                               assert startD<N-1;
  if(startD<0)
  {
      startD=-startD;  //It was only conventionally negative!!!
      startD=N-startD; //Somewhere from the end...
  }

  if(startD<0) //Still negative!?
  {
      startD=0; //So there was no data
      //print("?");
  }

  float wid=float(width) / (N-startD);  //println(width,N,startD,wid,min,max);
  float oldY=-Float.MIN_VALUE;
  
  for(int t=startD;t<N;t++)
  {
    float val=data.get(t);
    if(val==INF_NOT_EXIST) 
    {
      oldY=-Float.MIN_VALUE;
      continue;
    }
    
    if(logarithm)
      val=map((float)Math.log10(val+1),Min,Max,0,height);    
    else 
      val=map(val,Min,Max,0,height);
    
    float x=(t-startD)*wid;
    if(connect && oldY!=-Float.MIN_VALUE)
    {
      line (startX+x-wid,startY-oldY,startX+x,startY-val); //println(wid,x-wid,oldy,x,val);
    }
    else
    {
                                                 //println(startX+x,startY-val);
      line(startX+x+2,startY-val,startX+x-1,startY-val); 
      line(startX+x,startY-val+2,startX+x,startY-val-1); 
    }
    
    if(connect) oldY=val;
    
    if(t==data.whereMax() || t==data.whereMin())
    {
      textAlign(LEFT,TOP);
      text(""+data.get(t),startX+x,startY-val);
    }
  }
}

/** @brief A function that visualizes a series of data as vertical lines in different colors
  @note  The value is printed in text if the TEXT_MASK option is set
  @param data : Data source
  @param startD  : The starting point of the data, or the number from the end - if negative
  @param startX,startY,width,height : Location and size
  @param mapper : mapping values to colors                                                */
void viewAsVerticals(iDataSample data,int startD,float startX,float startY,int width,int height,iColorMapper mapper) ///< @NOTE GLOBAL. For C++ translation MUST be in one line!
{
  int     N=data.numOfElements();                                                             
                                                                                             assert startD<N-1;
  if(startD<0)
  {
      startD=-startD;  //It was only conventionally negative!!!
      startD=N-startD; //Somewhere from the end
  }
  
  if(startD<0) //Still negative!?
  {
      startD=0; //So there was no data
      //print("?");
  }
  
  float wid=float(width) / (N-startD);  //println(width,N,startD,wid,min,max);
  
  for(int t=startD;t<N;t++)
  {
    float val=data.get(t);
    if(val==INF_NOT_EXIST) 
    {
      continue;
    }
    
    if(mapper!=null)
    {
      color cc;
      //if(mapper!=null) ???
      cc=mapper.map(val);
      stroke(cc);
    }
    
    float x=(t-startD)*wid; //println(startX+x,startY-val);
    line(startX+x,startY,startX+x,startY-height);
    
    if( data.isOption(TEXT_MASK) ) text(t,startX+x,startY);
  }
}

/** @brief Range visualisation as boxes or solid bars 
  @param ranges  : Data source
  @param startR,finR  : The range visibility window 
  @param startX,startY,width,height : Screen location and size
  @param mapper : mapping values to colors
  @param solid  : swith beetwen solid bars versus boxes */
void viewAsRanges(iRangesDataSample ranges,float startR,float finR,float startX,float startY,int width,int height,boolean solid,iColorMapper mapper) ///< @NOTE GLOBAL. For C++ translation MUST be in one line!
{
  if(solid) noStroke(); else noFill();
  
  for(int i=0;i<ranges.size();i++)
  {
    iFloatRangeWithValue range=ranges.get(i);
    if(range.getMin()<=finR || range.getMax()>=startR) //Jeśli któryś koniec trafia w okno zainteresowania
    {
      float min=range.getMin(); if(min==INF_NOT_EXIST) min=startR;
      float start=map(min,startR,finR,startX,width);
      
      float max=range.getMax(); if(max==INF_NOT_EXIST) max=finR;
      float   end=map(max,startR,finR,startX,width);
      end=int(end+1); //Zaokrąglenie w gorę
      color c=mapper.map(range.get());
      
      if(solid) { fill(c); } 
      else      { stroke(c); } 
      
      rect(start,startY,end-start,height-1);
      
      //println("\t",range.get(),"\tin\t",nfs(min,0,3),"..\t",nfs(max,0,3),"\t|\t",hex(c),"\tin\t",nfs(start,0,1),"..\t",nfs(end,0,1));
    }
  }
  //println();
}

/// @brief Bar visualization of a histogram or something similar.
//* PL: Funkcja wizualizująca serię danych jako kolumny w jednym kolorze.
/// @details Mainly for visualizing attendance.
/// @param Frequencies hist - Data source. The object containing the data to be visualized
/// @param float startX - The horizontal starting point of the display area 
/// @param float startY - The vertical starting point of the display area 
/// @param int width - The width of the display area
/// @param int height - The height of the display area
/// @param boolean logarithm - Should the data be transformed by logarithm?
/// @returns real width of histogram
float viewAsColumns(Frequencies hist,float startX,float startY,int width,int height,boolean logarithm) ///< DRAWING A HISTOGRAM.
{
  float Max=(logarithm?(float)Math.log10(hist.higherBucket+1):hist.higherBucket); //+1 doesn't change much visually, but it guarantees computability
  int   wid=width/hist.buckets.length; //println(width,wid);
  if(wid<1) wid=1;
  
  fill(hist.getColor());
  
  for(int i=0;i<hist.buckets.length;i++)
  {
    float hei;
    if(logarithm)
      hei=map((float)Math.log10(hist.buckets[i]+1),0,Max,0,height);    
    else 
      hei=map(hist.buckets[i],0,Max,0,height);
    
    rect(startX+i*wid,startY,wid,-hei);
  }
  
  if(hist.outsideHig>0)
  {
    color hfill=hist.getColor();
    float r=red(hfill)*1.5,g=green(hfill)*1.5,b=blue(hfill)*1.5;
    hfill=color( (r<256?r:255) , (g<256?g:255) , (b<256?b:255) , alpha(hfill) );
    fill(hfill);
    
    float hei;
    if(logarithm)
      hei=map((float)Math.log10(hist.outsideHig+1),0,Max,0,height);    
    else 
      hei=map(hist.outsideHig,0,Max,0,height);
    
    rect(startX+hist.buckets.length*wid,startY,wid,-hei);
  }
  
  if(hist.outsideLow>0)
  {
    color hfill=hist.getColor();
    hfill=color( red(hfill)/2, green(hfill)/2 , blue(hfill)/2, alpha(hfill));
    fill(hfill);
    
    float hei;
    if(logarithm)
      hei=map((float)Math.log10(hist.outsideLow+1),0,Max,0,height);    
    else 
      hei=map(hist.outsideLow,0,Max,0,height);
    
    rect(startX-wid,startY,wid,-hei);
  }
  
  fill(hist.getColor());
  textAlign(LEFT,BOTTOM);
  text(hist.getName()+"\n       max:"+Max
         +(logarithm ?
           "<=" +hist.higherBucket+" @ "+hist.higherBucketIndex :
           " @ "+hist.higherBucketIndex),
           startX,startY-height);
  textAlign(LEFT,TOP);         
  text(""+hist.lowerBuck,startX,startY);     
  //textAlign(RIGHT,TOP);         
  text(""+hist.upperBuck,startX+width,startY);   
           
  //Real width of histogram
  float realWidth=(hist.buckets.length)*wid; //println(realwidth);noLoop();                                         
  return realWidth;
}

/// @brief Tiles visualization of a any 2D row & column indexed data.
void viewAsTiles(i2DDataSample data,float startX,float startY,int width,int height) ///< DRAWING TILES 2D HISTOGRAM IN SHADOWS OF GRAY.
{
  float minimum=data.getMin();
  float maximum=data.getMax();
  int   rows=data.rows();
  int   cols=data.columns();
  float celWidth=width/cols;
  float celHeigh=height/rows;
  
  for(int r=0;r<rows;r++)
    for(int c=0;c<cols;c++)
    {
      float value=data.get(r,c);
      
      if(minimum<maximum) {
        value=map(value,minimum,maximum,0,255);
        fill(value);
      } else {
        fill(random(100),0,0);
      }
      
      rect(startX+c*celWidth,startY+r*celHeigh,celWidth,celHeigh);
    }
}

//******************************************************************************
/// See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI"
/// See: "https://github.com/borkowsk/sym4processing"
//* USEFUL COMMON CODES - HANDY FUNCTIONS & CLASSES
/// @}
//******************************************************************************        
