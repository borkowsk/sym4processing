/// Different filters of links and other link tools for a (social) network.
/// @date 2024-10-21 (last modification)
//*///////////////////////////////////////////////////////////////////////////////

/// @details
///   Available filters: 
///   ------------------
///   AllLinks, AndFilter, OrFilter, TypeFilter,
///   LowPassFilter,   HighPassFilter,
///   AbsLowPassFilter, AbsHighPassFilter,
///   TypeAndAbsHighPassFilter (special type for efficient visualisation).

/**
* @brief Simplest link filtering class which accepts all links.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:AllLinks

class AllLinks : public  LinkFilter , public virtual Object{
  public:
  bool    meetsTheAssumptions(piLink l) {
	 return true;
	}
} ; //_EndOfClass



const pAllLinks allLinks=new AllLinks();  // Such type of filter is used very frequently, but such kind of definition does not work with Processing2C++

//_extern const pAllLinks allLinks; ///< Wymuszenie globalnej deklaracji zapowiadającej w Processing2C++

/**
* @brief Special type of filter for efficient visualisation.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:TypeAndAbsHighPassFilter

class TypeAndAbsHighPassFilter  : public  LinkFilter , public virtual Object{
  public:
  int   lType;
  float threshold;
  TypeAndAbsHighPassFilter(){ lType=-1;threshold=0;}
  TypeAndAbsHighPassFilter(int t,float tres) {
	 lType=t;threshold=tres;
	}
  pTypeAndAbsHighPassFilter reset(int t,float tres) {
	 lType=t;threshold=tres;
	return  this;
	}
  bool    meetsTheAssumptions(piLink l) {
	 return l->getTypeMarker()==lType && std::abs(l->getWeight())>threshold;
	}
} ; //_EndOfClass


/**
* @brief `AND` on two filters assembling class.
*        A class for logically joining two filters with the `AND` operator.
*/

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


/**
* @brief `OR` on two filters assembly class.
*        A class for logically joining two filters with the OR operator.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:OrFilter

class OrFilter : public  LinkFilter , public virtual Object{
  public:
   pLinkFilter a;
   pLinkFilter b;
   OrFilter(pLinkFilter aa,pLinkFilter bb){a=aa;b=bb;}
   bool    meetsTheAssumptions(piLink l) 
   { 
     return a->meetsTheAssumptions(l) || b->meetsTheAssumptions(l);
   }
} ; //_EndOfClass


/**
* @brief Type of link filter.
*        Class which filters links of specific "color"/"type".
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:TypeFilter

class TypeFilter : public  LinkFilter , public virtual Object{
  public:
  int ltype;
  TypeFilter(int t) {
	 ltype=t;
	}
  bool    meetsTheAssumptions(piLink l) {
	 return l->getTypeMarker()==ltype;
	}
} ; //_EndOfClass


/**
* @brief Low Pass Filter.
*        Class which filters links with lower weights.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:LowPassFilter

class LowPassFilter : public  LinkFilter , public virtual Object{
  public:
  float threshold;
  LowPassFilter(float tres) {
	 threshold=tres;
	}
  bool    meetsTheAssumptions(pLink l) {
	 return l->weight<threshold;
	}
} ; //_EndOfClass


/**
* @brief High Pass Filter.
*        Class which filters links with higher weights.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:HighPassFilter

class HighPassFilter : public  LinkFilter , public virtual Object{
  public:
  float threshold;
  HighPassFilter(float tres) {
	 threshold=tres;
	}
  bool    meetsTheAssumptions(piLink l) {
	 return l->getWeight()>threshold;
	}
} ; //_EndOfClass


/**
* @brief Absolute Low Pass Filter.
*        lowPassFilter filtering links with lower absolute value of weight.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:AbsLowPassFilter

class AbsLowPassFilter : public  LinkFilter , public virtual Object{
  public:
  float threshold;
  AbsLowPassFilter(float tres) {
	 threshold=std::abs(tres);
	}
  bool    meetsTheAssumptions(piLink l) {
	 return std::abs(l->getWeight())<threshold;
	}
} ; //_EndOfClass


/**
* @brief Absolute High Pass Filter.
*        highPassFilter filtering links with higher absolute value of weight.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:AbsHighPassFilter

class AbsHighPassFilter : public  LinkFilter , public virtual Object{
  public:
  float threshold;
  AbsHighPassFilter(float tres) {
	 threshold=std::abs(tres);
	}
  bool    meetsTheAssumptions(piLink l) {
	 return std::abs(l->getWeight())>threshold;
	}
} ; //_EndOfClass


//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 21:30:14 !

