/// @file
/// @note Automatically made from _aInterfaces.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
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

/// Common INTERFACES like `iNamed`, iDescribable, iColorable, iPositioned. ("aInterfaces.pde")
/// @date 2024-10-20 (last modification)                       @author borkowsk
/// @note General interfaces for "optional" modules could be typically just linked from "Optionals/"
//*/////////////////////////////////////////////////////////////////////////////////////////////////

//* USE virtual  &  =0 for interchangeable function 
//* if you need translate the code into C++ (--> Processing2C )

/// @defgroup Generally usable interfaces
/// @{
//*//////////////////////////////////////
  
/** @brief Interface forces getter for single int. */
#include "iIntValue_class.pde.hpp"
  
/** @brief Interface forces getter for single float. */
#include "iFloatValue_class.pde.hpp"

#include "iIntPair_class.pde.hpp"

#include "iFloatPair_class.pde.hpp"

/** @brief Interface forces getters for X & Y ... */
#include "iFloatPoint2D_class.pde.hpp"

/** @brief Interface forces getter for Z and also what is derived from base class. */
#include "iFloatPoint3D_class.pde.hpp"

/** @brief Interface forces getters for T ("time") and also what is derived from base class. */
#include "iFloatPoint4D_class.pde.hpp"

/** @brief Interface for any true referable class usable as a flag or switch.
*   @details Neither the type `Boolean` nor `boolean` can
*            in Processing and JAVA be passed by reference!
*            Hence the need for user types that can work like this->  */
#include "iFlag_class.pde.hpp"

/** @brief interface to set of flag identified by binary masks */
#include "iOptionsSet_class.pde.hpp"

/** @brief It forces name of an object available as `String` (planty of usage). */
#include "iNamed_class.pde.hpp"

/** @brief Any object which have description as (maybe) long, multi line string. */
#include "iDescribable_class.pde.hpp"

/** @brief Any object which can go back to initial state without additional parameters */
#include "iResetable_class.pde.hpp"

/** @brief Any simulation agent */
#include "iAgent_class.pde.hpp"

/** @brief Model time measuring interface */
#include "iModelTimer_class.pde.hpp"

// VISUALISATION INTERFACES:
//*//////////////////////////

/** @brief Forcing remembering full color inside object. */
#include "iColor_class.pde.hpp"

/** @brief Forcing `applyFill` & `applyStroke` methods for visualisation. */
#include "iColorable_class.pde.hpp"

/** @brief Mapping float value into color. */
#include "iColorMapper_class.pde.hpp"

/** @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping. */ 
#include "iPositioned_class.pde.hpp"

// SPECIFICLY FOR MATH INTERFACES:
//*///////////////////////////////

//const float INF_NOT_EXIST=FLT_MAX;  ///< Missing value marker

/** @brief A function of one value in the form of a class - a functor. */
#include "iFloatFunction1D_class.pde.hpp"

/** @brief A function of two values in the form of a class - a functor. */
#include "iFloatFunction2D_class.pde.hpp"

/** @brief Interface of any class witch can take a float value for any processing. */
#include "iFloatConsiderer_class.pde.hpp"

/** @brief Interface of any class witch can take a float value connected with int label for any processing. */
#include "iIndexedFloatConsiderer_class.pde.hpp"

/** @brief Interface of any class witch can take a float value connected with int label for any processing. */
#include "i2IndexedFloatConsiderer_class.pde.hpp"

/** @brief Any range spanned from `Min` to `Max`. */
#include "iFloatRange_class.pde.hpp"

/** @brief Ane range with associated value, e->g->MARKED RANGE. */
#include "iFloatRangeWithValue_class.pde.hpp"

/** @brief Any linear (indexed) container of floats. */  
#include "iFloatValuesIndexedContainer_class.pde.hpp"

/** @brief Any recangular (2*int indexed) container of floats. */  
#include "iFloatValues2IndexedContainer_class.pde.hpp"

/** @brief Interface of a linear sample of data with min...max statics and set of options. */
#include "iDataSample_class.pde.hpp"

/** @brief Interface of 2D sample of data (ex. 2D histogram data, map of simulation cells etc... ). */
#include "i2DDataSample_class.pde.hpp"

/** @brief Interface for any linear (indexed) container of Range(s). */
#include "iFloatRangesWithValueContainer_class.pde.hpp"

/** @brief Interface of any class witch can take a `rangeWithValue` for any processing */
#include "iRangeWithValueConsiderer_class.pde.hpp"

/** @brief Interface for sample of ranges data. */
#include "iRangesDataSample_class.pde.hpp"

/** Statistics of raw data samples. */
#include "iBasicStatistics_class.pde.hpp"

/** Statistics for counters data sets. */
#include "iFreqStatistics_class.pde.hpp"

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www->researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*/////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

