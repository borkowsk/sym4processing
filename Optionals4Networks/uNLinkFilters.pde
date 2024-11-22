/// Different filters of links and other link tools for a (social) network. (uNLinkFilters.pde)
/// @date 2024-11-22 (last modification)
//*////////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Complex Networks support
/// @{
//*/////////////////////////////////////

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
class AllLinks extends LinkFilter
{
  boolean meetsTheAssumptions(iLink l) { return true;}
} //EndOfClass


final AllLinks allLinks=new AllLinks();  // Such type of filter is used very frequently, but such kind of definition does not work with Processing2C++

//_extern final AllLinks allLinks; ///< Wymuszenie globalnej deklaracji zapowiadającej w Processing2C++

/**
* @brief Special type of filter for efficient visualisation.
*/
class TypeAndAbsHighPassFilter  extends LinkFilter
{
  int   lType;
  float threshold;
  TypeAndAbsHighPassFilter(){ lType=-1;threshold=0;}
  TypeAndAbsHighPassFilter(int t,float tres) { lType=t;threshold=tres;}
  TypeAndAbsHighPassFilter reset(int t,float tres) { lType=t;threshold=tres;return this;}
  boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==lType && abs(l.getWeight())>threshold;}
} //EndOfClass

/**
* @brief `AND` on two filters assembling class.
*        A class for logically joining two filters with the `AND` operator.
*/
class AndFilter extends LinkFilter
{
   LinkFilter a;
   LinkFilter b;
   AndFilter(LinkFilter aa,LinkFilter bb){a=aa;b=bb;}
   boolean meetsTheAssumptions(iLink l) 
   { 
     return a.meetsTheAssumptions(l) && b.meetsTheAssumptions(l);
   }
} //EndOfClass

/**
* @brief `OR` on two filters assembly class.
*        A class for logically joining two filters with the OR operator.
*/
class OrFilter extends LinkFilter
{
   LinkFilter a;
   LinkFilter b;
   OrFilter(LinkFilter aa,LinkFilter bb){a=aa;b=bb;}
   boolean meetsTheAssumptions(iLink l) 
   { 
     return a.meetsTheAssumptions(l) || b.meetsTheAssumptions(l);
   }
} //EndOfClass

/**
* @brief Type of link filter.
*        Class which filters links of specific "color"/"type".
*/
class TypeFilter extends LinkFilter
{
  int ltype;
  TypeFilter(int t) { ltype=t;}
  boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype;}
} //EndOfClass

/**
* @brief Low Pass Filter.
*        Class which filters links with lower weights.
*/
class LowPassFilter extends LinkFilter
{
  float threshold;
  LowPassFilter(float tres) { threshold=tres;}
  boolean meetsTheAssumptions(Link l) { return l.weight<threshold;}
} //EndOfClass

/**
* @brief High Pass Filter.
*        Class which filters links with higher weights.
*/
class HighPassFilter extends LinkFilter
{
  float threshold;
  HighPassFilter(float tres) { threshold=tres;}
  boolean meetsTheAssumptions(iLink l) { return l.getWeight()>threshold;}
} //EndOfClass

/**
* @brief Absolute Low Pass Filter.
*        lowPassFilter filtering links with lower absolute value of weight.
*/
class AbsLowPassFilter extends LinkFilter
{
  float threshold;
  AbsLowPassFilter(float tres) { threshold=abs(tres);}
  boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())<threshold;}
} //EndOfClass

/**
* @brief Absolute High Pass Filter.
*        highPassFilter filtering links with higher absolute value of weight.
*/
class AbsHighPassFilter extends LinkFilter
{
  float threshold;
  AbsHighPassFilter(float tres) { threshold=abs(tres);}
  boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())>threshold;}
} //EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*////////////////////////////////////////////////////////////////////////////
