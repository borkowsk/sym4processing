//* File forcing all "optionales" to be loaded from this folder 
//*///////////////////////////////////////////////////////////////////////

/// mandatory globals
int          FRAMEFREQ=10;        ///< application speed
int          VISFREQ=1;           ///< how often full visualisation is performed
int          debug_level=0; ///< or DEBUG or DEBUG_LEVEL ???

final boolean WINDOW_INVISIBLE=false; ///< used in template draw for swith on window invisibility
final int    LINK_INTENSITY=2;    ///< For network visualisation
final float  MAX_LINK_WEIGHT=1.0; ///< Also for network visualisation
final int    MASKBITS=0xffffffff; ///< Redefine, when smaller width is required

/// Dummy class of Agent neded for makeHistogramOfA()
class Agent { float A; }

/// Dummy setup - some gr. primitives are tested here:
void setup()
{
  size(500,500);
  //setupMenu();//Have error in size of draweable area!
  dashedline(0,0,width,height,3);
  arrow_d(0,100,100,200,5,PI*0.75);
  arrow_d(100,200,200,250,5,PI*0.66);
  arrow_d(200,250,300,0,5,PI*0.9);
  dottedLine(0.0,0.0,300.0,200.0,55);
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
