/// @file
#pragma once
/// @date 2024-10-21 (last modification)
#ifndef HEADER_Link_INCLUDED
#define HEADER_Link_INCLUDED

/**
* @brief Real link implementation->This class is available for user modifications.
*/

#include "iLink_class.pde.hpp"
#include "iVisLink_class.pde.hpp"
#include "Comparable_class.pde.hpp"

#include "Colorable_class.pde.hpp"
//Base class is now:
#define _superclass _

/// @note Automatically extracted definition of `class`: Link

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:Link

class Link : public  Colorable, public virtual iLink,iVisLink,Comparable<pLink> , public virtual Object{
  public:

  pNode  target;  //!< targetet node.
  float weight;  //!< importance/trust
  int   ltype;   //!< "color"
  
  //... add something, if you need in derived classes.
  
  /// Constructor.
  Link(pNode targ,float we,int ty){ target=targ;weight=we;ltype=ty;}
  
  /// Text formated data from the object.
  String fullInfo(String fieldSeparator)
  {
    return String("W:")+weight+fieldSeparator+String("Tp:")+ltype+fieldSeparator+String("->")+target;
  }
  
  /// For sorting->Much weighted link should be at the begining of the array!
  /// Compares this object with the specified object for order.
  int  compareTo(pLink o) 
  {
     if(o==this || o->weight==weight) return 0;
     else
     if(o->weight>weight) return 1;
     else return -1;
  }
  
  /// For visualisation and mapping.  
  String    name(){ return target->name(); }
  String getName(){ return target->name(); }
  
  /// Read only access to `weight`.
  float getWeight() {
	 return weight;
	}
  
  /// Provide target node
  piNode getTarget() {
	 return target;
	}

  /// Provide target casted on visualisable node.
  piVisNode  getVisTarget() {
	 return (iVisNode)target;
	}
  
  void  setTarget(piNode tar) {
	 target=(Node)(tar); 
	}
  
  /// 
  int   getTypeMarker() {
	 return ltype; 
	}
  
  /// How object should be collored.
  color     defColor()
  {
     switch ( ltype )
     {
     case 0: if(weight<=0) return color(0,-weight*255,0);else return color(weight*255,0,weight*255);
     case 1: if(weight<=0) return color(-weight*255,0,0);else return color(0,weight*255,weight*255);
     case 2: if(weight<=0) return color(0,0,-weight*255);else return color(weight*255,weight*255,0);
     default: //Wszystkie inne 
             if(weight>=0) return color(128,0,weight*255);else return color(-weight*255,-weight*255,128);
     }   
  }
  
  /// Setting `stroke` for this object. 
  /// @param Intensity - used for alpha channel.
  void applyStroke(float Intensity)
  {  //float   MAX_LINK_WEIGHT=2;   ///Use maximal strokeWidth for links
     strokeWeight(std::abs(weight)*MAX_LINK_WEIGHT);
     switch ( ltype )
     {
     case 0: if(weight<=0) stroke(0,-weight*255,0,Intensity);else stroke(weight*255,0,weight*255,Intensity);break;
     case 1: if(weight<=0) stroke(-weight*255,0,0,Intensity);else stroke(0,weight*255,weight*255,Intensity);break;
     case 2: if(weight<=0) stroke(0,0,-weight*255,Intensity);else stroke(weight*255,weight*255,0,Intensity);break;
     default: //Wszystkie inne 
             if(weight>=0) stroke(128,0,weight*255,Intensity);else stroke(-weight*255,-weight*255,128,Intensity);
             break;
     }
  }
  
  /// @note Use maximal `strokeWidth()` for links. 
  /// @todo Zerowe znikają w grafice SVG!
  void applyStroke(float weight,float MaxIntensity)
  {  //float   MAX_LINK_WEIGHT=2;   
     strokeWeight(1+std::abs(weight)*MAX_LINK_WEIGHT); 
     switch ( ltype )
     {
     case 0: if(weight<=0) stroke(0,-weight*255,0,MaxIntensity);else stroke(weight*255,0,weight*255,MaxIntensity);break;
     case 1: if(weight<=0) stroke(-weight*255,0,0,MaxIntensity);else stroke(0,weight*255,weight*255,MaxIntensity);break;
     case 2: if(weight<=0) stroke(0,0,-weight*255,MaxIntensity);else stroke(weight*255,weight*255,0,MaxIntensity);break;
     default: //Wszystkie inne 
             if(weight>=0) stroke(128,0,weight*255,MaxIntensity);else stroke(-weight*255,-weight*255,128,MaxIntensity);
             break;
     }
  }
} ; //_EndOfClass_


//Undefining any base class preprocessor definition: _
#undef _superclass

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_Link_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !
