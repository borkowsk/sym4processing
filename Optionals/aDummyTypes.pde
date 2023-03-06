/// @file aDummyTypes.pde
/// @brief Classes for making an object from a simple types as 
/// `int`, `boolean`, `float` & `double`.
/// @note They are useful, when you need a REFERENCE to a value of such types.
/// @date 2023.03.04 (Last modification)
//*/////////////////////////////////////////////////////////////////////////////
///
/// @details
/// In Processing as hell :-) I can't find how to pass something other than an 
/// object by reference. However, the existing Integer or Float classes are not 
/// suitable for this because they are "final". 
/// They will behave like constants!!!
/// And sometimes such an opportunity for REFERENCE parameter is needed!
//*/////////////////////////////////////////////////////////////////////////////

/// A class for taking an object from a simple logic variable (true-false). 
/// Needed for common configuration values or to pass to functions by reference.
class DummyBool
{ boolean val=false; }

/// A class for taking an object from a simple variable of type `int`. 
/// Needed for common configuration values or to pass to functions by reference.
class DummyInt
{int val=0;}

/// A class for taking an object from a simple variable of type `float`. 
/// Needed for common configuration values or to pass to functions by reference.
class DummyFloat
{ float val=0; }

/// A class for taking an object from a simple variable of type `double`. 
/// Needed for common configuration values or to pass to functions by reference.
class DummyDouble
{ double val=0; }

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////
