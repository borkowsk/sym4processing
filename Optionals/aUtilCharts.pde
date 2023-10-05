/** @file "uCharts.pde" 
 *  @brief ....
 *  @defgroup ChartUtils Functions & classes for chart making 
 *  @date 2023.10.05 (last modification)                        @author borkowsk 
 *  @details 
 *     It needs "uUtilCData.pde" & "uFigures.pde"
 *  @{
 */ ////////////////////////////////////////////////////////////////////////////

/// @brief Mapping float value into color interface.
interface iColorMapper 
{
  /*_interfunc*/ color map(float value) /*_forcebody*/; 
} //_endOfClass iColorMapper

// Masks for Sample options
static final int CONNECT_MASK=0x1;  ///< ???
static final int LOGARITM_MASK=0x2; ///< TODO name! LOGARIT-H-M!
static final int PERCENT_MASK=0x4;  ///< ???
static final int TEXT_MASK=0x8;     ///< ???

/// @brief Function for drawing axis.
/// @details Visualizes the axes of the coordinate system.
void viewAxis(int startX,int startY,int width,int height)                       ///< @NOTE GLOBAL
{ 
  line(startX,startY,startX+width,startY);
  line(startX+width-5,startY-5,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+5,startY-height+5,startX,startY-height);
  line(startX-5,startY-height+5,startX,startY-height);
}

/// @brief Function for drawing empty frame.
/// @details Visualizes a box around the area.
void viewFrame(float startX,float startY,int width,int height)                  ///< @NOTE GLOBAL
{ 
  line(startX,startY,startX+width,startY);
  line(startX,startY,startX,startY-height);
  line(startX+width,startY,startX+width,startY-height);
  line(startX,startY-height,startX+width,startY-height);
}

/// @brief   Draws tics along the vertical axis.
/// @details Function for drawing tics on Y axis.
void viewTicsV(int startX,int startY,int width,int height,float space)          ///< @NOTE GLOBAL
{ 
  for(int y=startY;y>startY-height;y-=space)
     line(startX,y,startX+width,y);
}

/// @brief Draws tics along the horizontal axis.
/// @details Function for drawing tics on X axis.
void viewTicsH(float startX,float startY,float width,float height,float space)  ///< @NOTE GLOBAL
{
  for(int x=int(startX);x<startX+width;x+=space)
     line(x,startY,x,startY-height);
}

/// @brief Visualizes the limits of the vertical scale.
/// @note We're not drawing dashes here yet (tics)
/// @details Function for drawing scale on Y axis.
void viewScaleV(Range MinMax,int startX,int startY,int width,int height)        ///< @NOTE GLOBAL
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
 @param  data : Źródło danych
 @param  startD : Punkt startowy wyświetlania, albo liczba od końca, gdy ujemna
 @param  startX,
 @param  startY,
 @param  width,
 @param  height,
 @param  logarithm,
 @param  commMinMax,
 @param  connect : czy łączyć punkty w łamaną
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
  
  int     N=data.numOfElements();                                               assert startD<N-1;

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
  float wid=float(width) / (N-startD);    //println(width,N,startD,wid,min,max);
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
  PL:param int startD  : Punkt startowy wyświetlania, albo liczba od końca - gdy ujemna
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
  
  int     N=data.numOfElements();                                               assert startD<N-1;
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
  @note  Wartość jest drukowana tekstowo jeśli ustawiona jest opcja TEXT_MASK
  @param Sample data : Źródło danych
  @param int startD  : Punkt startowy wyświetlania, albo liczba od końca  - gdy ujemna
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
    
    if( data.isOption(TEXT_MASK) ) text(t,startX+x,startY);
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
  float realwidth=(hist.buckets.length)*wid; //println(realwidth);noLoop(); 
                                             ///@todo name! "realWidth"
  return realwidth;
}

//******************************************************************************
/// See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI"
/// See: "https://github.com/borkowsk/sym4processing"
//* USEFUL COMMON CODES - HANDY FUNCTIONS & CLASSES
/// @}
//******************************************************************************        
