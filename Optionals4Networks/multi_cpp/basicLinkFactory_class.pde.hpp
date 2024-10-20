/// @file
#pragma once
/// @date 2024-10-21 (last modification)
#ifndef HEADER_basicLinkFactory_INCLUDED
#define HEADER_basicLinkFactory_INCLUDED

/**
* @brief Simplest link factory creates identical links except for the targets.
* @note It also serves as an example of designing factories.
*/

#include "LinkFactory_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: basicLinkFactory

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:basicLinkFactory

class basicLinkFactory : public  LinkFactory , public virtual Object{
  public:

  float default_weight;
  int   default_type;
  
  basicLinkFactory(float def_weight,int def_type){ default_weight=def_weight;default_type=def_type;}
  
  pLink  makeLink(pNode Source,pNode Target)
  {
    return new Link(Target,default_weight,default_type);
  }
} ; //_EndOfClass_


//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_basicLinkFactory_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

