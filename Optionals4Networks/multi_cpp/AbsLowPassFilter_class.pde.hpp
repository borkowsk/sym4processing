/// @file
#pragma once
/// @date 2024-10-21 (last modification)
#ifndef HEADER_AbsLowPassFilter_INCLUDED
#define HEADER_AbsLowPassFilter_INCLUDED

/**
* @brief Absolute Low Pass Filter.
*        lowPassFilter filtering links with lower absolute value of weight.
*/

#include "LinkFilter_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: AbsLowPassFilter

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:AbsLowPassFilter

class AbsLowPassFilter : public  LinkFilter , public virtual Object{
  public:

  float treshold;
  AbsLowPassFilter(float tres) {
	 treshold=std::abs(tres);
	}
  bool    meetsTheAssumptions(piLink l) {
	 return std::abs(l->getWeight())<treshold;
	}
} ; //_EndOfClass


//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_AbsLowPassFilter_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

