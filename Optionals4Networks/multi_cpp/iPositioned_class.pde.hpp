/// @file
#pragma once
/// @date 2024-10-21 (last modification)                       @author borkowsk
#ifndef HEADER_iPositioned_INCLUDED
#define HEADER_iPositioned_INCLUDED

/** @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping. */

#include "iFloatPoint3D_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: iPositioned

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iPositioned

//interface
class iPositioned : public virtual  iFloatPoint3D , public virtual Object{
  public:
              
  virtual  float       posX() =0;
  virtual  float       posY() =0;
  virtual  float       posZ() =0;
} ;//_EofCl iPositioned

//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_iPositioned_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !
