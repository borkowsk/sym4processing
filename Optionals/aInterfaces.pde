/// @file "aInterfaces.pde" 
/// @brief Common INTERFACES like iNamed, iDescribable, iColorable, iPositioned 
/// @date 2023.10.05 (last modification)                       @author borkowsk
/// @details ...
//*/////////////////////////////////////////////////////////////////////////////

//* USE /*_interfunc*/ &  /*_forcebody*/ for interchangeable function 
//* if you need translate the code into C++ (--> Processing2C )


// Generally useable interfaces:
//*//////////////////////////////

/**
* @brief Interface for any true referable class usable as a flag or switch.
* @details Ani typ `Boolean`, ani tym bardziej `boolean` nie może
*          w Processingu i JAVA'ie być przekazywany przez referencje!
*          Stąd potrzebne są typy użytkownika, które mogą tak działać.
*/
interface iFlag 
{
  /*_interfunc*/ boolean isEnabled() /*_forcebody*/;
} //_EndOfClass

/**
* @brief Forcing name of an object available as `String` (planty of usage).
*/
interface iNamed 
{
  /*_interfunc*/ String    name() /*_forcebody*/;
} //_EndOfClass

/**
* @brief Any object which have description as (maybe) long, multi line string.
*/
interface iDescribable { 
  /*_interfunc*/ String Description() /*_forcebody*/;
} //_EndOfClass

interface iAgent {
} //_EndOfClass


/// VISUALISATION INTERFACES:
//*//////////////////////////

/**
* @brief Forcing `setFill` & `setStroke` methods for visualisation
*/
interface iColorable {
  /*_interfunc*/ void setFill(float intensity) /*_forcebody*/;
  /*_interfunc*/ void setStroke(float intensity) /*_forcebody*/;
} //_EndOfClass

/**
* @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping 
*/ 
interface iPositioned {              
  /*_interfunc*/ float    posX() /*_forcebody*/;
  /*_interfunc*/ float    posY() /*_forcebody*/;
  /*_interfunc*/ float    posZ() /*_forcebody*/;
} //_EndOfClass


/// MATH INTERFACES:
//*/////////////////

//final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/**
* @brief A function of two values in the form of a class - a functor
*/
interface Function2D {
  /*_interfunc*/ float calculate(float X,float Y) /*_forcbody*/;
  /*_interfunc*/ float getMin() /*_forcebody*/; //MIN_RANGE_VALUE?
  /*_interfunc*/ float getMax() /*_forcebody*/; //Always must be different!
} //EndOfClass

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
//*/////////////////////////////////////////////////////////////////////////////
