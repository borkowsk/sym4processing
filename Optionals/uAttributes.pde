/// Interfejsy do czytani i zapisywania nazwanych stringami atrybutów obiektów.
/// @date 2024-11-22 (last modified)
//-////////////////////////////////////////////////////////////////////////////

/// @defgroup Interproces communication tools
/// @{
//-//////////////////////////////////////////

/// Interface which forces getters and setters for string named attributes.
/// @details This interface is a common ground for registering objects under different names and changing the values
///          they have inside from the "interpretation" level, e.g. at the request of network communication.
/// @note This could probably be done with JAVA's built-in inception, but C++ doesn't have it.
///       Moreover, this mechanism allows you to use different attribute names than variable/field names.
interface iReadWriteAttributes {
  /// It reads a particular attribute. @returns attribute value or NaN if something went wrong.
  /*_interfunc*/ double   numAttribute(String name) /*_forcebody*/;
  /// It sets a particular attribute. @returns previous attribute value or NaN if something went wrong.
  /*_interfunc*/ double   numAttribute(String name,double value) /*_forcebody*/;
  /// It reads a particular string attribute. @returns attribute value or `null` if something went wrong.
  /*_interfunc*/ String   strAttribute(String name) /*_forcebody*/;
  /// It sets a particular string attribute. @returns previous attribute value or NaN if something went wrong.
  /*_interfunc*/ String   strAttribute(String name,String value) /*_forcebody*/;
} //_EofCl

/// Interface for managing object attributes. 
/// @details It allows you to register objects that satisfy the `iAttributable` interface, 
///          retrieve them by name, and also read and change the values of their named attributes.
interface iAttributeManager extends iReadWriteAttributes {
  /// It reads a level separator. Typically it may be ".","/" or "::".
  /*_interfunc*/ String   getAttrSeparator() /*_forcebody*/;
  /// It sets a level separator, if possible.
  /*_interfunc*/ boolean  setAttrSeparator(String newSep) /*_forcebody*/;
  /// The function registers objects that provide attributes.
  /*_interfunc*/ boolean  registerObject(String name,iReadWriteAttributes object,boolean flag) /*_forcebody*/;
  /// Provides access to the registered attributable.
  /*_interfunc*/ iReadWriteAttributes get(String name) /*_forcebody*/;
} //_EofCl

/// Simplest implementation of `iAttributeManager` base on HashMap;
class SimpleAttributeManager implements iAttributeManager
{
  HashMap<String,iReadWriteAttributes> objects=new HashMap<String,iReadWriteAttributes>(); //!< Kontener implementacyjny.
  
  String                      separator=".";
  String[]                      retPair=new String[2]; //!< Do przekazywania rezultatów `_splitNameFromPath`
  
  /// Default constructor.
  SimpleAttributeManager() {}
  
  /// Other separator constructor.
  SimpleAttributeManager(String iSeparator) { separator=iSeparator; }
  
  /// It reads a level separator. Typically it may be ".","/" or "::".
  String   getAttrSeparator() /*_override*/
  {
    return separator;
  }
  
  /// It sets a level separator, if possible.
  /// @details Here it is only important for last separator!
  ///          e.g. for separator "/" and name "aaa/bbb/ccc" the "ccc" will be treated as an attribute name.
  ///          And for separator "." and name "aaa/bbb.ccc" also "ccc" will be treated as an attribute name.
  ///          But for separator "." and name "aaa.bbb/ccc" the "bbb/ccc" will be treated as an attribute name.
  boolean  setAttrSeparator(String newSep) /*_override*/
  {
    separator=newSep;
    return true;
  }
  
  /// The function registers objects that provide attributes.
  /// @par path - fully qualified name of object (possible with separators).
  /// @par object - an object that meets the iAttributable interface.
  /// @par force  - Inserts an object even if one already existed under that name.
  boolean  registerObject(String path,iReadWriteAttributes object,boolean force) /*_override*/
  { 
    if(!force && objects.containsKey(path)) return false; // There is already such a name used!
    objects.put(path,object);
    return true;
  }
  
  /// Provides access to the registered attributable.
  iReadWriteAttributes get(String name) /*_override*/
  {
    return objects.get(name);
  }
  
  /// Helper function to split a string into path and attribute name and put it into `retpair`. 
  /// @note This won't work in multithreading conditions!!!
  boolean _splitNameFromPath(String name)
  {
    int sepInd=name.lastIndexOf(separator); // lastIndexOf(String str) --> Returns the index within this string of the last occurrence of the specified substring.
    if(0<=sepInd && sepInd<name.length()){
      retPair[0]=name.substring(0,sepInd);
      retPair[1]=name.substring(sepInd+separator.length()); //println(retPair[0],separator,retPair[1]);
      return true;
    }
    else return false;
  }
  
  /// It reads a particular attribute. @returns attribute value.
  double   numAttribute(String name) /*_override*/
  {
    if(_splitNameFromPath(name)){
      iReadWriteAttributes object=objects.get( retPair[0] );
      return object.numAttribute( retPair[1] );
    }
    else return NaN;
  }

  /// It sets a particular attribute. @returns previous attribute value.
  double   numAttribute(String name,double value) /*_override*/
  {
    if(_splitNameFromPath(name)){
      iReadWriteAttributes object=objects.get( retPair[0] );
      return object.numAttribute( retPair[1] , value );
    }
    else return NaN;
  }
  
  /// It reads a particular string attribute. @returns attribute value or `null` if something went wrong.
  String   strAttribute(String name) /*_override*/
  {
    if(_splitNameFromPath(name)){
      iReadWriteAttributes object=objects.get( retPair[0] );
      return object.strAttribute( retPair[1] );
    }
    else return null;
  }
  
  /// It sets a particular string attribute. @returns previous attribute value or NaN if something went wrong.
  String   strAttribute(String name,String value)  /*_override*/
  {
    if(_splitNameFromPath(name)){
      iReadWriteAttributes object=objects.get( retPair[0] );
      return object.strAttribute( retPair[1] , value );
    }
    else return null;
  }
  
} //_EofCl


//*////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*////////////////////////////////////////////////////////////////////////////
