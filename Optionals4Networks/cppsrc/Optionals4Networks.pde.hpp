/// @file 
/// Minimal program for testing linking of networks optionals. ("Optionals4Networks.pde")
/// @date 2024-10-21 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////////////////////

//declared in local.h: const int    DEBUG_LEVEL=0;        ///< General DEBUG level.
//declared in local.h: const int    NET_DEBUG=1;          ///< DEBUG level for network.
//declared in local.h: const int    LINK_INTENSITY=128;   ///< For network visualisation.
//declared in local.h: const float  MAX_LINK_WEIGHT=1.0;  ///< Also for network visualisation.
//declared in local.h: const int    MASK_BITS=0xffffffff; ///< Redefine, when smaller width is required.

sarray<pVisual2DNodeAsList>  AllNodes;    ///< Nodes have to be visualisable!!!
pAllLinks vFilter;
float defX=1;
float defY=1;

/// Mandatory Processing function called once at the beginning of the every program.
/// @note This is global by default!
void processing_window::setup()
{
  size(500,500);
  
  AllNodes=new array<pVisual2DNodeAsList>(10);
  for(int i=0;i<AllNodes->length;i++)
  {
    AllNodes[i]=new Visual2DNodeAsList(random(width),random(height));
  }
  
  prandomWeightLinkFactory factory=new randomWeightLinkFactory(-1,1,1);
  makeFullNet(AllNodes,factory);
  
  int neighborhood=1;
  //makeRingNet(AllNodes,factory,neighborhood);
  
  int sizeOfFirstCluster=4;
  int numberOfNewLinkPerNode=1;
  bool    reciprocal=true; 
  //makeScaleFree(AllNodes,factory,sizeOfFirstCluster,numberOfNewLinkPerNode,reciprocal); //It works only sometime!
}

/// Mandatory Processing function.
/// @note This is global by default!
void processing_window::draw()
{
  float cellSide=1;
  visualiseLinks2D(AllNodes,vFilter,defX,defY,cellSide,true); //<>//
  //visualiseLinks1D(AllNodes,vfilter,defX,defY,cellSide,true);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 21:30:14 !

