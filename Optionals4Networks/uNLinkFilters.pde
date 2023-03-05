/// Different filters of links and other link tools for a (social) network
//*/////////////////////////////////////////////////////////////////////////
/// Available filters: 
///   AllLinks, AndFilter, OrFilter, TypeFilter,
///   LowPassFilter,   HighPassFilter,
///   AbsLowPassFilter, AbsHighPassFilter
///   TypeAndAbsHighPassFilter - special type for efficient visualisation

/// Simplest link filtering class which accepts all links
class AllLinks extends LinkFilter
{
  boolean meetsTheAssumptions(iLink l) { return true;}
}//EndOfClass

final AllLinks allLinks=new AllLinks();  ///< Such type of filter is used very frequently

/// Special type of filter for efficient visualisation
class TypeAndAbsHighPassFilter  extends LinkFilter
{
  int ltype;
  float treshold;
  TypeAndAbsHighPassFilter(){ ltype=-1;treshold=0;}
  TypeAndAbsHighPassFilter(int t,float tres) { ltype=t;treshold=tres;}
  TypeAndAbsHighPassFilter reset(int t,float tres) { ltype=t;treshold=tres;return this;}
  boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype && abs(l.getWeight())>treshold;}
}//EndOfClass

/// AND two filters assembly class.
/// A class for logically joining two filters with the AND operator.
class AndFilter extends LinkFilter
{
   LinkFilter a;
   LinkFilter b;
   AndFilter(LinkFilter aa,LinkFilter bb){a=aa;b=bb;}
   boolean meetsTheAssumptions(iLink l) 
   { 
     return a.meetsTheAssumptions(l) && b.meetsTheAssumptions(l);
   }
}//EndOfClass

/// OR two filters assembly class.
/// A class for logically joining two filters with the OR operator.
class OrFilter extends LinkFilter
{
   LinkFilter a;
   LinkFilter b;
   OrFilter(LinkFilter aa,LinkFilter bb){a=aa;b=bb;}
   boolean meetsTheAssumptions(iLink l) 
   { 
     return a.meetsTheAssumptions(l) || b.meetsTheAssumptions(l);
   }
}//EndOfClass

/// Type of link filter.
/// Class which filters links of specific "color"/"type"
class TypeFilter extends LinkFilter
{
  int ltype;
  TypeFilter(int t) { ltype=t;}
  boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype;}
}//EndOfClass

/// Low Pass Filter.
/// Class which filters links with lower weights
class LowPassFilter extends LinkFilter
{
  float treshold;
  LowPassFilter(float tres) { treshold=tres;}
  boolean meetsTheAssumptions(Link l) { return l.weight<treshold;}
}//EndOfClass

/// High Pass Filter.
/// Class which filters links with higher weights
class HighPassFilter extends LinkFilter
{
  float treshold;
  HighPassFilter(float tres) { treshold=tres;}
  boolean meetsTheAssumptions(iLink l) { return l.getWeight()>treshold;}
}//EndOfClass

/// Absolute Low Pass Filter.
/// lowPassFilter filtering links with lower absolute value of weight
class AbsLowPassFilter extends LinkFilter
{
  float treshold;
  AbsLowPassFilter(float tres) { treshold=abs(tres);}
  boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())<treshold;}
}//EndOfClass

/// Absolute High Pass Filter.
/// highPassFilter filtering links with higher absolute value of weight
class AbsHighPassFilter extends LinkFilter
{
  float treshold;
  AbsHighPassFilter(float tres) { treshold=abs(tres);}
  boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())>treshold;}
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
