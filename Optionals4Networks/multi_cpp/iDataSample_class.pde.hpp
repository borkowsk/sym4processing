/// @file
#pragma once
/// @date 2024-10-21 (last modification)                       @author borkowsk
#ifndef HEADER_iDataSample_INCLUDED
#define HEADER_iDataSample_INCLUDED

/** @brief Interface of a linear sample of data with min...max statics and set of options. */

#include "iFloatValuesIndexedContainer_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: iDataSample

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iDataSample

//interface
class iDataSample : public virtual  iFloatValuesIndexedContainer, public virtual  iFloatConsiderer, public virtual  iFloatRange, public virtual  iOptionsSet , public virtual Object{
  public:

  ///   *  `_interfunc void      consider(float value) =0;` -- It takes another value and updates range if needed.
  virtual  int        whereMin() =0; //!< ADDED
  virtual  int        whereMax() =0; //!< ADDED
} ;//_EofCl

//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_iDataSample_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !
