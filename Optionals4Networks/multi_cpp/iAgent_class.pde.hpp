/// @file
#pragma once
/// @date 2024-10-21 (last modification)                       @author borkowsk
#ifndef HEADER_iAgent_INCLUDED
#define HEADER_iAgent_INCLUDED

/** @brief Any simulation agent */

#include "iNamed_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: iAgent

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iAgent

//interface
class iAgent : public virtual  iNamed, public virtual  iDescribable , public virtual Object{
  public:

  /// Derived methods:
  ///  *  `_interfunc String           getName() =0;`
  ///  *  `_interfunc String              name() =0;`
  ///  *  `_interfunc String    getDescription() =0;`
  ///  *  `_interfunc String       description() =0;`
  virtual  int        getIntAttribute(String attrName ) =0;
  virtual  float    getFloatAttribute(String attrName ) =0;
  virtual  String  getStringAttribute(String attrName ) =0;
  virtual  String      printableState() =0;
} ;//_EofCl

//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_iAgent_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !
