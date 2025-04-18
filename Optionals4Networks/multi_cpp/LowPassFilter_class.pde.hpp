/// @file
#pragma once
/// @date 2024-10-21 (last modification)
#ifndef HEADER_LowPassFilter_INCLUDED
#define HEADER_LowPassFilter_INCLUDED

/**
* @brief Low Pass Filter.
*        Class which filters links with lower weights.
*/

#include "LinkFilter_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: LowPassFilter

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:LowPassFilter

class LowPassFilter : public  LinkFilter , public virtual Object{
  public:

  float treshold;
  LowPassFilter(float tres) {
	 treshold=tres;
	}
  bool    meetsTheAssumptions(pLink l) {
	 return l->weight<treshold;
	}
} ; //_EndOfClass


//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_LowPassFilter_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

