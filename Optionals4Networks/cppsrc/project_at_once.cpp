/// @file 
/* All sources included in one file. */
/// @date 2024-10-21 (0.22j)
#include "processing_consts.hpp"
#include "processing_templates.hpp"
#include "processing_library.hpp"
#include "processing_window.hpp"
#ifdef _NDEBUG
#include "processing_inlines.hpp" //...is optional.
#endif // _NDEBUG
#include "processing_string.hpp"  //Processing::String class
#include "processing_console.hpp"   //...is optional. Should be deleted when not needed.
#include "processing_alist.hpp" //...is optional. Should be deleted when not needed.
#include "processing_map.hpp"   //...is optional. Should be deleted when not needed.
using namespace Processing;
#include "local.h"
#include <iostream>
//==============================================================================
const char* Processing::_PROGRAMNAME="Optionals4Networks";
#include "aInterfaces.pde.hpp"
#include "aNetInterfaces.pde.hpp"
#include "aNetwork.pde.hpp"
#include "uFigures.pde.hpp"
#include "uGraphix.pde.hpp"
#include "uNetVisual.pde.hpp"
#include "uNLinkFactories.pde.hpp"
#include "uNLinkFilters.pde.hpp"
#include "Optionals4Networks.pde.hpp"
