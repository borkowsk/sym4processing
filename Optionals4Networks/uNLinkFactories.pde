/// @file uNLinkFilters.pde
/// @date 2023.03.04 (Last modification)
/// @brief Others factories for fabrication of links for a (social) network
//*/////////////////////////////////////////////////////////////////////////////

/// Random link factory.
/// It creates links with random weights.
class randomWeightLinkFactory implements iLinkFactory
{
  float min_weight,max_weight;
  int   default_type;
  
  /// Constructor for setting up requirements.
  randomWeightLinkFactory(float min_we,float max_we,int def_type)
  { 
    min_weight=min_we;max_weight=max_we;
    default_type=def_type;
  }
  
  /// Real factory job.
  Link  makeLink(iNode Source,iNode Target)
  {
    return new Link((Node)Target,random(min_weight,max_weight),default_type);
  }
  
  Link  makeSelfLink(iNode Self)
  {
    return new Link((Node)Self,random(min_weight,max_weight),default_type);
  }
  
}//EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
