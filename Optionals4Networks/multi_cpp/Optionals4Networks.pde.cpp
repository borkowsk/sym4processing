/// @file
/// @note Automatically made from _Optionals4Networks.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
/// @date 2024-10-21 19:06:46 (translation)
//
#include "processing_consts.hpp"
#include "processing_templates.hpp"
#include "processing_library.hpp"
#include "processing_window.hpp"
#ifndef _NO_INLINE
#include "processing_inlines.hpp" //...is optional.
#endif // _NO_INLINE
using namespace Processing;
#include "local.h" //???.
#include <iostream>
//================================================================

/// @file 
/// @brief Minimal program for testing linking of networks optionals ("Optionals4Networks.pde")
/// @date 2024.04.08 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////////////////////

static int   DEBUG_LEVEL=0;       ///< General DEBUG level.
static int   NET_DEBUG=1;         ///< DEBUG level for network.
//declared in local.h: const int    LINK_INTENSITY=128;  ///< For network visualisation.
//declared in local.h: const float  MAX_LINK_WEIGHT=1.0; ///< Also for network visualisation.
//declared in local.h: const int    MASKBITS=0xffffffff; ///< Redefine, when smaller width is required.

sarray<pVisual2DNodeAsList>  AllNodes;   ///< Nodes have to be visualisable!!!
pAllLinks vfilter;
float defX=1;
float defY=1;

/// Mandatory Processing function called once at the begining of the every program.
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
  float cellside=1;
  visualiseLinks2D(AllNodes,vfilter,defX,defY,cellside,true); //<>//
  //visualiseLinks1D(AllNodes,vfilter,defX,defY,cellside,true);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

const char* Processing::_PROGRAMNAME="Optionals4Networks";
