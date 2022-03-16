/// Others factories for fabrication of links for a (social) network
//*///////////////////////////////////////////////////////////////////

/// Random link factory creates links with random weights
class randomWeightLinkFactory extends LinkFactory
{
  float min_weight,max_weight;
  int   default_type;
  
  randomWeightLinkFactory(float min_we,float max_we,int def_type)
  { 
    min_weight=min_we;max_weight=max_we;
    default_type=def_type;
  }
  
  Link  makeLink(Node Source,Node Target)
  {
    return new Link(Target,random(min_weight,max_weight),default_type);
  }
  
}//EndOfClass

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
