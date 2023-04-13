/// @file aInterfaces.pde 
/// Common INTERFACES like iNamed, iDescribable, iColorable, iPositioned & Function2D.
/// @date 2023.03.04 (Last modification)
//*///////////////////////////////////////////////////////////////////////////////////
//* USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
//* if you need translate the code into C++ (--> Processing2C )

//*
//* Generally useable interfaces:
//*//////////////////////////////

/**
 @brief Interface for any true referable class usable as a flag or switch.
 @details Ani typ 'Boolean', ani tym bardziej 'boolean' nie może
 w Processingu i JAVA'ie być przekazywany przez referencje!
 Stąd potrzebne są typy użytkownika, które mogą tak działać.
*/
interface iFlag 
{
  /*_interfunc*/ boolean isEnabled() /*_forcebody*/;
}//EndOfClass

/**
  @brief Forcing name of an object available as String (planty of usage).
*/
interface iNamed 
{
  /*_interfunc*/ String    name() /*_forcebody*/;
}//EndOfClass

/// Any object which have description as (potentially) long, multi line string
interface iDescribable { 
  /*_interfunc*/ String Description() /*_forcbody*/;
}//EndOfClass

//*
/// VISUALISATION INTERFACES:
//*
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

//*
/// MATH INTERFACES:
//*
//*////////////////////////////////////////////////////////////////////////////

//final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/// A function of two values in the form of a class - a functor
interface Function2D {
  /*_interfunc*/ float calculate(float X,float Y)/*_forcbody*/;
  /*_interfunc*/ float getMin()/*_forcbody*/;//MIN_RANGE_VALUE?
  /*_interfunc*/ float getMax()/*_forcbody*/;//Always must be different!
}//EndOfClass

//*/////////////////////////////////////////////////////////////////////////////////////////////
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - USEFULL COMMON INTERFACES
//*  See also: "https://github.com/borkowsk/sym4processing"
//*/////////////////////////////////////////////////////////////////////////////////////////////
