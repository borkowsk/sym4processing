/// @file
/// @note Automatically made from _aNetInterfaces.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
/// @date 2024-10-21 19:06:46 (translation)
//
#include "processing_consts.hpp"
#include "processing_templates.hpp"
#include "processing_library.hpp"
#include "processing_window.hpp"
#ifndef _NO_INLINE
#include "processing_inlines.hpp" //...is optional.
#endif // _NO_INLINE
#include "processing_string.hpp"  //Processing::String class
using namespace Processing;
#include "local.h" //???.
#include <iostream>
//================================================================

/// @file 
/// @brief Network Only Interfaces ("aNetInterfaces.pde")
/// @date 2024-09-03 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

/// @details
///   INTERFACES:
///   ===========
///   - `interface iLink`
///   - `interface iNode`
///

/**
* @brief Network connection/link interface.
*/
#include "iLink_class.pde.hpp"

/**
* @brief Interface for any filter for links.
*/
#include "iLinkFilter_class.pde.hpp"

/**
* @brief Network node interface.
*        "Conn" below is a shortage from Connection.
* @note Somewhere may uses class Link not interface iLink because of efficiency!
*/
#include "iNode_class.pde.hpp"

/**
* @brief Visualisable network node.
*/
#include "iVisNode_class.pde.hpp"

/**
* @brief Visualisable network connection.
*/
#include "iVisLink_class.pde.hpp"

/**
* @brief Any factory producing links.
*/
#include "iLinkFactory_class.pde.hpp"

//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS INTERFACES
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

