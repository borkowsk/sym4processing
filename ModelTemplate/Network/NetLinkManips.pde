// Diferent filters of links and other link tols for a (social) network
///////////////////////////////////////////////////////////////////////////////////////////

class AllLinks extends LinkFilter
// Simplest link filtering class which accepts all links
{
  boolean meetsTheAssumptions(Link l) { return true;}
}

AllLinks allLinks=new AllLinks();//Used very frequently

class LowPassFilter extends LinkFilter
// lowPassFilter filtering class which accepts all links
{
  float treshold;
  LowPassFilter(float tres) { treshold=tres;}
  boolean meetsTheAssumptions(Link l) { return l.weight<treshold;}
}

class HighPassFilter extends LinkFilter
// lowPassFilter filtering class which accepts all links
{
  float treshold;
  HighPassFilter(float tres) { treshold=tres;}
  boolean meetsTheAssumptions(Link l) { return l.weight>treshold;}
}

class AbsLowPassFilter extends LinkFilter
// lowPassFilter filtering class which accepts all links
{
  float treshold;
  AbsLowPassFilter(float tres) { treshold=abs(tres);}
  boolean meetsTheAssumptions(Link l) { return abs(l.weight)<treshold;}
}

class AbsHighPassFilter extends LinkFilter
// lowPassFilter filtering class which accepts all links
{
  float treshold;
  AbsHighPassFilter(float tres) { treshold=abs(tres);}
  boolean meetsTheAssumptions(Link l) { return abs(l.weight)>treshold;}
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
