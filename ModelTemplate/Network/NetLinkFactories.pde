// Diferent fabrication of links for a (social) network
///////////////////////////////////////////////////////////

class basicLinkFactory extends LinkFactory
// Simplest link factory creates identical links except for the targets
// It also serves as an example of designing factories.
{
  float default_weight;
  int   default_type;
  
  basicLinkFactory(float def_weight,int def_type){ default_weight=def_weight;default_type=def_type;}
  
  Link  makeLink(Node Source,Node Target)
  {
    return new Link(Target,default_weight,default_type);
  }
  
}

class randomWeightLinkFactory extends LinkFactory
// Random link factory creates links with random weights
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
  
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
