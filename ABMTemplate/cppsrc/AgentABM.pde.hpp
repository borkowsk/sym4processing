/// @file 
/// @brief Agent is a one of two central class of each ABM model.
//*        ABM: DUMMY OF AGENT
//  @date 2024-10-20 (last modification)
//*////////////////////////////////////////////////////////////////

/// Agent class->Agent is a one of two central class of each ABM model.
class Agent: public virtual Object{
  public:
  float dummy; //!< Dummy field->Only for demonstration.
  //... PLACE FOR YOUR CODE
  
  /// Constructor of the Agent.
  Agent()
  {
    dummy=0; //random(0.1);
    //... PLACE FOR YOUR CODE
  }
} ; //_EndOfClass


//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr->eu/)
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-20 19:45:02 !

