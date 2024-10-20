/// @file 
/// Minimal program for testing linking of networks optionals. ("Optionals4Networks.pde")
/// @date 2024-10-21 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////////////////////

final int    DEBUG_LEVEL=0;        ///< General DEBUG level.
final int    NET_DEBUG=1;          ///< DEBUG level for network.
final int    LINK_INTENSITY=128;   ///< For network visualisation.
final float  MAX_LINK_WEIGHT=1.0;  ///< Also for network visualisation.
final int    MASK_BITS=0xffffffff; ///< Redefine, when smaller width is required.

Visual2DNodeAsList[]  AllNodes;    ///< Nodes have to be visualisable!!!
AllLinks vFilter;
float defX=1;
float defY=1;

/// Mandatory Processing function called once at the beginning of the every program.
/// @note This is global by default!
void setup()
{
  size(500,500);
  
  AllNodes=new Visual2DNodeAsList[10];
  for(int i=0;i<AllNodes.length;i++)
  {
    AllNodes[i]=new Visual2DNodeAsList(random(width),random(height));
  }
  
  randomWeightLinkFactory factory=new randomWeightLinkFactory(-1,1,1);
  makeFullNet(AllNodes,factory);
  
  int neighborhood=1;
  //makeRingNet(AllNodes,factory,neighborhood);
  
  int sizeOfFirstCluster=4;
  int numberOfNewLinkPerNode=1;
  boolean reciprocal=true; 
  //makeScaleFree(AllNodes,factory,sizeOfFirstCluster,numberOfNewLinkPerNode,reciprocal); //It works only sometime!
}

/// Mandatory Processing function.
/// @note This is global by default!
void draw()
{
  float cellSide=1;
  visualiseLinks2D(AllNodes,vFilter,defX,defY,cellSide,true); //<>//
  //visualiseLinks1D(AllNodes,vfilter,defX,defY,cellSide,true);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
