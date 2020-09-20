/////////////////////////////////////////////////////////////////////////////////
// COMMON INTERFACES AND ABSTRACT CLASSES 
/////////////////////////////////////////////////////////////////////////////////
// /* _interfunc */ from interchangeable function

public class Pair<A,B> 
//Simple version of Pair template useable for returning a pair of values
{
    public final A a;
    public final B b;

    public Pair(A a, B b) 
    {
        this.a = a;
        this.b = b;
    }
};

// Teplates
///////////////////////////////////

// Generally useable interfaces
///////////////////////////////////////////////////////////////////////////////////////////


interface named //ABSOLETE: Any object which have name as printable String
{
  String getName();
}

interface describable //ABSOLETE: Any object which have description as (potentially) long, multi line string
{
  String getDescription();
}

interface iNamed {
  ///INFO: Forcing name available as String (planty of usage)
  /*_interfunc*/ String    name()/*_forcbody*/;
};

interface iDescribable { //Any object which have description as (potentially) long, multi line string
  ///INFO:
  /*_interfunc*/ String Description();
};

// MATH INTERFACES
/////////////////////////////////////////////////////////////////////////////////
final float INF_NOT_EXIST=Float.MAX_VALUE;  ///visible autside this file!

interface Function2D {
  /*_interfunc*/ float calculate(float X,float Y)/*_forcbody*/;
  /*_interfunc*/ float getMin()/*_forcbody*/;//MIN_RANGE_VALUE?
  /*_interfunc*/ float getMax()/*_forcbody*/;//Always must be different!
};

// VISUALISATION INTERFACES:
/////////////////////////////////////////////////////////////////////////////////

interface iColorable {
  ///INFO: Forcing setFill & setStroke methods for visualisation
  /*_interfunc*/ void setFill(float intensity)/*_forcbody*/;
  /*_interfunc*/ void setStroke(float intensity)/*_forcbody*/;
};

interface iPositioned {
  ///INFO: Forcing posX() & posY() & posZ() methods for visualisation and mapping                
  /*_interfunc*/ float    posX()/*_forcbody*/;
  /*_interfunc*/ float    posY()/*_forcbody*/;
  /*_interfunc*/ float    posZ()/*_forcbody*/;
};

// NETWORK INTERFACES:
/////////////////////////////////////////////////////////////////////////////////

interface iLink { 
  ///INFO: Is iLink interface really needed?
  /*_interfunc*/ float getWeight();
};

interface iNode { 
  ///INFO: "Conn" below is a shortage from Connection.
  //using class Link not interface iLink because of efficiency!
  /*_interfunc*/ int     addConn(Link   l);
  /*_interfunc*/ int     delConn(Link   l);
  /*_interfunc*/ int     numOfConn()      ;
  /*_interfunc*/ Link    getConn(int    i);
  /*_interfunc*/ Link    getConn(Node   n);
  /*_interfunc*/ Link    getConn(String k);
  /*_interfunc*/ Link[]  getConns(LinkFilter f);
};

interface iVisNode extends iNode,iNamed,iColorable,iPositioned {
  ///INFO: visualisable network node
};

interface  iVisLink extends iLink,iNamed,iColorable {
  ///INFO: visualisable network connection
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - USEFULL INTERFACES & ABSTRACT CLASSES
////////////////////////////////////////////////////////////////////////////////////////////////////////////
