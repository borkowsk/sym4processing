//*//////////////////////////////////////////////////////////////////////////////
/// COMMON INTERFACES
/// See: "https://github.com/borkowsk/RTSI_public"
//*//////////////////////////////////////////////////////////////////////////////
/// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
/// if you need translate the code into C++ (--> Processing2C )



///
/// Generally useable interfaces:
///
//*//////////////////////////////

/// Forcing name available as String (planty of usage)
interface iNamed {
  /*_interfunc*/ String    name() /*_forcbody*/;
}//EndOfClass

/// Any object which have description as (potentially) long, multi line string
interface iDescribable { 
  /*_interfunc*/ String Description() /*_forcbody*/;
}//EndOfClass

///
/// MATH INTERFACES:
///
//*////////////////////////////////////////////////////////////////////////////

final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/// A function of two values in the form of a class - a functor
interface Function2D {
  /*_interfunc*/ float calculate(float X,float Y)/*_forcbody*/;
  /*_interfunc*/ float getMin()/*_forcbody*/;//MIN_RANGE_VALUE?
  /*_interfunc*/ float getMax()/*_forcbody*/;//Always must be different!
}//EndOfClass

///
/// VISUALISATION INTERFACES:
///
//*///////////////////////////

/// Forcing setFill & setStroke methods for visualisation
interface iColorable {
  /*_interfunc*/ void setFill(float intensity)/*_forcbody*/;
  /*_interfunc*/ void setStroke(float intensity)/*_forcbody*/;
}//EndOfClass

/// Forcing posX() & posY() & posZ() methods for visualisation and mapping  
interface iPositioned {              
  /*_interfunc*/ float    posX()/*_forcbody*/;
  /*_interfunc*/ float    posY()/*_forcbody*/;
  /*_interfunc*/ float    posZ()/*_forcbody*/;
}//EndOfClass

// NETWORK INTERFACES:
/////////////////////////////////////////////////////////////////////////////////

/// Network connection/link interface
/// Is iLink interface really needed?
interface iLink { 
  /*_interfunc*/ float getWeight()/*_forcbody*/;
}//EndOfClass

/// Network node interface
/// "Conn" below is a shortage from Connection.
interface iNode { 
  //using class Link not interface iLink because of efficiency!
  /*_interfunc*/ int     addConn(Link   l)/*_forcbody*/;
  /*_interfunc*/ int     delConn(Link   l)/*_forcbody*/;
  /*_interfunc*/ int     numOfConn()      /*_forcbody*/;
  /*_interfunc*/ Link    getConn(int    i)/*_forcbody*/;
  /*_interfunc*/ Link    getConn(Node   n)/*_forcbody*/;
  /*_interfunc*/ Link    getConn(String k)/*_forcbody*/;
  /*_interfunc*/ Link[]  getConns(LinkFilter f)/*_forcbody*/;
}//EndOfClass

/// Visualisable network node
interface iVisNode extends iNode,iNamed,iColorable,iPositioned {
}//EndOfClass

/// Visualisable network connection
interface  iVisLink extends iLink,iNamed,iColorable {
  /*_interfunc*/ color     defColor()/*_forcebody*/;
}//EndOfClass

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///  Last modification 2022.03.16
///  @a "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - USEFULL COMMON INTERFACES
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
