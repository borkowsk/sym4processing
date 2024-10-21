/// Others factories for fabrication of links for a (social) network. ("uNLinkFilters.pde")
/// @date 2024-10-21 (last modification)
//*///////////////////////////////////////////////////////////////////////////////////////////////

/**
* @brief Random link factory.
*        It creates links with random weights.
*/
class randomWeightLinkFactory : public virtual iLinkFactory , public virtual Object{
  public:
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
  pLink  makeLink(piNode Source,piNode Target)
  {
    return new Link((Node)Target,random(min_weight,max_weight),default_type);
  }
  
  /// @brief Special factory product - self link.
  pLink  makeSelfLink(piNode Self)
  {
    return new Link((Node)Self,random(min_weight,max_weight),default_type);
  }
  
} ; //_EndOfClass


//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 21:30:14 !

