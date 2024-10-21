/// @file
/// @note Automatically made from _uNLinkFilters.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
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

/// @file uNLinkFilters->pde
/// @date 2024.04.08 (last modification)
/// @brief Different filters of links and other link tools for a (social) network
//*///////////////////////////////////////////////////////////////////////////////

/// @details
///   Available filters: 
///   ------------------
///   AllLinks, AndFilter, OrFilter, TypeFilter,
///   LowPassFilter,   HighPassFilter,
///   AbsLowPassFilter, AbsHighPassFilter,
///   TypeAndAbsHighPassFilter (special type for efficient visualisation).

/**
* @brief Simplest link filtering class which accepts all links.
*/
#include "AllLinks_class.pde.hpp"

//declared in local.h: const pAllLinks allLinks=new AllLinks();  ///< Such type of filter is used very frequently.

/**
* @brief Special type of filter for efficient visualisation.
*/
#include "TypeAndAbsHighPassFilter_class.pde.hpp"

/**
* @brief `AND` on two filters assembling class.
*        A class for logically joining two filters with the `AND` operator.
*/
#include "AndFilter_class.pde.hpp"

/**
* @brief `OR` on two filters assembly class.
*        A class for logically joining two filters with the OR operator.
*/
#include "OrFilter_class.pde.hpp"

/**
* @brief Type of link filter.
*        Class which filters links of specific "color"/"type".
*/
#include "TypeFilter_class.pde.hpp"

/**
* @brief Low Pass Filter.
*        Class which filters links with lower weights.
*/
#include "LowPassFilter_class.pde.hpp"

/**
* @brief High Pass Filter.
*        Class which filters links with higher weights.
*/
#include "HighPassFilter_class.pde.hpp"

/**
* @brief Absolute Low Pass Filter.
*        lowPassFilter filtering links with lower absolute value of weight.
*/
#include "AbsLowPassFilter_class.pde.hpp"

/**
* @brief Absolute High Pass Filter.
*        highPassFilter filtering links with higher absolute value of weight.
*/
#include "AbsHighPassFilter_class.pde.hpp"

//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

