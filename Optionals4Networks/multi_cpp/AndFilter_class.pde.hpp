/// @file
#pragma once
/// @date 2024-10-21 (last modification)
#ifndef HEADER_AndFilter_INCLUDED
#define HEADER_AndFilter_INCLUDED

/**
* @brief `AND` on two filters assembling class.
*        A class for logically joining two filters with the `AND` operator.
*/

#include "LinkFilter_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: AndFilter

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:AndFilter

class AndFilter : public  LinkFilter , public virtual Object{
  public:

   pLinkFilter a;
   pLinkFilter b;
   AndFilter(pLinkFilter aa,pLinkFilter bb){a=aa;b=bb;}
   bool    meetsTheAssumptions(piLink l) 
   { 
     return a->meetsTheAssumptions(l) && b->meetsTheAssumptions(l);
   }
} ; //_EndOfClass


//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_AndFilter_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

