/// Others factories for fabrication of links for a (social) network. ("uNLinkFilters.pde")
/// @date 2024-11-22 (last modification)
//*///////////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Complex Networks support
/// @{
//*/////////////////////////////////////
/**
* @brief Random link factory.
*        It creates links with random weights.
*/
class randomWeightLinkFactory implements iLinkFactory
{
  float min_weight,max_weight;
  int   default_type;
  
  /// @brief Constructor for setting up requirements.
  randomWeightLinkFactory(float min_we,float max_we,int def_type)
  { 
    min_weight=min_we;max_weight=max_we;
    default_type=def_type;
  }
  
  /// @brief Real factory product: "to `Target` link".
  /// @param `Source` is ignored here, but is required by interface for other usage.
  /// @param `Target` - mandatory! 
  Link  makeLink(iNode Source,iNode Target)
  {
    return new Link((Node)Target,random(min_weight,max_weight),default_type);
  }
  
  /// @brief Special factory product - self link.
  Link  makeSelfLink(iNode Self)
  {
    return new Link((Node)Self,random(min_weight,max_weight),default_type);
  }
  
} //EndOfClass randomWeightLinkFactory

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
/// @}
//*////////////////////////////////////////////////////////////////////////////
