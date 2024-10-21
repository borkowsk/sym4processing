/// @file
/// @brief This file forcing all "optionales" to be loaded from this folder ( "Optionals.pde" )
/// @details It could be threated as EXAMPLE for using some of this optional features.
/// @date 2024-10-21 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////////////////////


// Mandatory globals required for some of the optionals modules:
//*/////////////////////////////////////////////////////////////

int          RANDSEED=0;          ///< For initialisation of pseudo-random.
                                  ///< numbers generator.
                                  
int          FRAMEFREQ=10;        ///< application speed.
int          VISFREQ=1;           ///< how often full visualisation is performed.

int          DEBUG_LEVEL=0;       ///< or DEBUG or DEBUG_LEVEL ???

final int    LINK_INTENSITY=2;    ///< For network visualisation.
final float  MAX_LINK_WEIGHT=1.0; ///< Also for network visualisation.
final int    MASKBITS=0xffffffff; ///< Redefine, when smaller width is required.

final boolean WINDOW_INVISIBLE=false; ///< used in template draw for swith on 
                                      ///< window invisibility.

/// Dummy class of Agent needed atleast for `makeHistogramOfA()`
class Agent implements iAttributable
{ 
  float X,Y;
  float A;  //!< example value of Agent 
  
  Agent(float iX,float iY,float iA) { X=iX;Y=iY;A=iA; }
  
  /// It reads a particular attribute. @return attribute value.
  /*_interfunc*/ double   getAttribute(String name) 
  {
      if(name.equals("A")) return A;
      else return NaN;
  }
  
  /// It sets a particular attribute. @return previous attribute value.
  /*_interfunc*/ double   setAttribute(String name,double value) 
  {
    if(name.equals("A")){
      double old=A;
      A=(float)(value);
      return old;
    }
    else return NaN;
  }
}

/// Demonstration class for ranges data.
class ValuesInRanges implements iFloatRangesWithValueContainer,iRangesDataSample 
{
  ArrayList<ValueInRange> ranges=new ArrayList<ValueInRange>();
  ValuesInRanges() {}
  ValuesInRanges add(ValueInRange next) { ranges.add(ranges.size(),next);return this; }
  // REQUIRED BY INTERFACE:
  //*//////////////////////
  void                          reset() { ranges.clear(); }
  int                   numOfElements() { return ranges.size(); }
  int                            size() { return ranges.size(); }
  void                       consider(iFloatRangeWithValue what) { ranges.add( ranges.size(),(ValueInRange)(what) ); }
  void                      replaceAt(int index,iFloatRangeWithValue what) { ranges.set(index, (ValueInRange)(what) ); }
  iFloatRangeWithValue   getElementAt(int index) { return (iFloatRangeWithValue)(ranges.get(index));}
  iFloatRangeWithValue            get(int index) { return (iFloatRangeWithValue)(ranges.get(index));}
  int                        whereMin() { return 0; }  // NOT IMPORTANT IN THIS EXAMPLE
  int                        whereMax() { return  ranges.size()-1; } // ------||-------
} //_EndOfClass

ValuesInRanges rdata=new ValuesInRanges();

/// Demostration class implementing user incarnation of `iColorMapper`.
class DiscreteMapper implements iColorMapper
{
  int intensity=128;
  
  void  setMinValue(float value) {/* It does nothing. */}
  void  setMaxValue(float value) {/* It does nothing. */}
  
  color map(float val) {
    switch(int(val)){
      case -3:return color(0,128,255,intensity); // BŁĘKITNY
      case -2:return color(0,0,255,intensity);   // NIEBIESKI
      case -1:return color(255,0,255,intensity); // FILOLETOWY
      case  0:return color(255,0,0,intensity);   // CZERWONY
      case +1:return color(255,255,0,intensity); // ŻÓŁTY
      case +2:return color(0,255,0,intensity);   // ZIELONY
      case +3:return color(0,255,128,intensity); // TURKUSOWY
      default: if(val<0) return color(0,intensity);
               else  return color(255,intensity);  
  }}
  
} //_EndOfClass
 
DiscreteMapper mapper=new DiscreteMapper();
SimpleAttributeManager objectAttributes=new SimpleAttributeManager();


/// Dummy setup - Usage of some modules are demonstrated here.
void setup()
{
  size(500,500);
  
  objectAttributes.registerObject("agentA",new Agent(10,10,-1));
  objectAttributes.registerObject("agentB",new Agent(10,10,-1));
  
  rdata.add( new ValueInRange( -1,-5.0,-1.7) )
       .add( new ValueInRange( 0,-2.0,-1.5) )
       .add( new ValueInRange( 1,-1.0,+1.0) )
       .add( new ValueInRange( 2,-0.5,+0.5) )
       .add( new ValueInRange( 3,+1.5,+2.0) );
  //setupMenu(); //Made error in hight of draweable area!
  dashedline(0,0,width,height,3);
  arrow_d(0,100,100,200,5,PI*0.75);
  arrow_d(100,200,200,250,5,PI*0.66);
  arrow_d(200,250,300,0,5,PI*0.9);
  dottedLine(0.0,0.0,300.0,200.0,55);
  
  viewAsRanges(rdata,-3,+3,
               0.0,height/2,width,height/2,false,mapper); ///< @NOTE GLOBAL.
               
  objectAttributes.setAttribute("agentA.A", random(-3,3) );         
  objectAttributes.setAttribute("agentB.A", random(-3,3) );  
  println("agentA.A=",objectAttributes.getAttribute("agentA.A"));
  println("agentB.A=",objectAttributes.getAttribute("agentB.A"));
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////
