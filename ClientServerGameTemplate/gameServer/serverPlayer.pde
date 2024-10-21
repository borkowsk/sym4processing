/// Representation of server side Player.
/// @date 2024-10-21 (last modification)
//*//////////////////////////////////////

/// May have different base than generic Player used on Client side.
class Player extends ActiveGameObject
{
  float  score=0;  //!< Result.
  Client netLink;  //!< Network connection to client application.
  
  int    indexInGameWorld=-1;//!< Index/shortcut to game board array/container.

  ///constructor.
  Player(Client iniClient,String iniName,float iniX,float iniY,float iniZ,float iniRadius){ super(iniName,iniX,iniY,iniZ,iniRadius);
    netLink=iniClient;
  }
  
  /// Interface for changing the state of the game object 
  /// over the network (mostly).
  /// @return: true if field is found
  /*_interfunc*/ boolean  setState(String field,String val)
  {
    if(field.charAt(0)=='s' && field.charAt(1)=='c')//sc-ore
    {
       score=Float.parseFloat(val);
       return true;
    }
    return super.setState(field,val);
  }
  
  /// The function creates a message block from those object 
  /// state elements that have change flags. (for network streaming)
  /// @return: Ready to send list of all changes made on object (based on flags)
  /*_interfunc*/ String sayState()
  {
     String msg=super.sayState();
     if((flags & Masks.SCORE )!=0) 
        msg+=sayOptAndInfos(OpCd.STA,name,"sc",nf(score));
     return msg;
  }  
  
  /// It can make string info about object. 
  /// 'level' is level of details, when 0 means "name only".  
  /*_interfunc*/ String info(int level)
  {
    String ret=super.info(level);
    if((level & Masks.SCORE)!=0)
      ret+=";"+score;
    return ret;
  }
  
} //EndOfClass Player
