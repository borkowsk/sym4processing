/// @file
#pragma once
/// @date 2024-10-21 (last modification)                       @author borkowsk
#ifndef HEADER_iFloatRangesWithValueContainer_INCLUDED
#define HEADER_iFloatRangesWithValueContainer_INCLUDED

/** @brief Interface for any linear (indexed) container of Range(s). */

#include "iResetable_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: iFloatRangesWithValueContainer

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatRangesWithValueContainer

//interface
class iFloatRangesWithValueContainer : public virtual  iResetable , public virtual Object{
  public:

  virtual  int                  numOfElements() =0; //!< Container size->Together with empty cells, i->e. == INVALID_INDEX.
  virtual  int                           size() =0; //!< Container size->Together with empty cells, i->e. == INVALID_INDEX.
  virtual  piFloatRangeWithValue  getElementAt(int index) =0; //!< Value at particular index->May return nullptr.
  virtual  piFloatRangeWithValue           get(int index) =0; //!< Value at particular index->May return nullptr.
  virtual  void                     replaceAt(int index,piFloatRangeWithValue range) =0;
} ;//_EofCl

//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_iFloatRangesWithValueContainer_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !
