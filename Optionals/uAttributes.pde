/// Interfejsy do atrybucji obiektów w symulacji.
/// @date 2024-10-20 (last modified)
//*//////////////////////////////////////////////

/// @defgroup Interproces communication tools
/// @{
//*//////////////////////////////////////////

/// Interface which forces getters and setters for string named attributes.
/// @details This interface is a common ground for registering objects under different names and changing the values
///          they have inside from the "interpretation" level, e.g. at the request of network communication.
/// @note This could probably be done with JAVA's built-in inception, but C++ doesn't have it.
///       Moreover, this mechanism allows you to use different attribute names than variable/field names.
interface iAttributable {
  /// It reads a particular attribute. @returns attribute value or NaN if something went wrong.
  /*_interfunc*/ double   getAttribute(String name) /*_forcebody*/;
  /// It sets a particular attribute. @returns previous attribute value or NaN if something went wrong.
  /*_interfunc*/ double   setAttribute(String name,double value) /*_forcebody*/;
} //_EofCl

/// Interface for managing object attributes. 
/// @details It allows you to register objects that satisfy the `iAttributable` interface, 
///          retrieve them by name, and also read and change the values of their named attributes.
interface iAttributeManager extends iAttributable {
  /// It reads a level separator. Typically it may be ".","/" or "::".
  /*_interfunc*/ String   getAttrSeparator() /*_forcebody*/;
  /// It sets a level separator, if possible.
  /*_interfunc*/ boolean  setAttrSeparator(String newSep) /*_forcebody*/;
  /// The function registers objects that provide attributes.
  /*_interfunc*/ boolean  register(String name,iAttributable object) /*_forcebody*/;
  /// Provides access to registered attributables.
  /*_interfunc*/ iAttributable get(String name);
} //_EofCl

/// Simplest implementation of `iAttributeManager` base on HashMap;
class SimpleAttributeManager implements iAttributeManager
{
  HashMap<String,iAttributable> objects=new HashMap<String,iAttributable>(); //!< Kontener implementacyjny.
  
  String                      separator=".";
  String[]                      retPair=new String[2]; //!< Do przekazywania rezultatów `_splitNameFromPath`
  
  /// Default constructor.
  SimpleAttributeManager() {}
  
  /// Other separator constructor.
  SimpleAttributeManager(String iSeparator) { separator=iSeparator; }
  
  /// It reads a level separator. Typically it may be ".","/" or "::".
  String   getAttrSeparator() 
  {
    return separator;
  }
  
  /// It sets a level separator, if possible.
  /// @details Here it is only important for last separator!
  ///          e.g. for separator "/" and name "aaa/bbb/ccc" the "ccc" will be treated as an attribute name.
  ///          And for separator "." and name "aaa/bbb.ccc" also "ccc" will be treated as an attribute name.
  ///          But for separator "." and name "aaa.bbb/ccc" the "bbb/ccc" will be treated as an attribute name.
  boolean  setAttrSeparator(String newSep)
  {
    separator=newSep;
    return true;
  }
  
  /// The function registers objects that provide attributes.
  boolean  register(String name,iAttributable object)
  { // BETTER USE: putIfAbsent(K key, V value) --> If the specified key is not already associated with a value (or is mapped to null) associates it with the given value and returns null, else returns the current value.
    // https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html
    if(objects.containsKey(name)) return false; // There already is such a name!
    objects.put(name,object);
    return true;
  }
  
  /// Provides access to registered attributables.
  iAttributable get(String name)
  {
    return objects.get(name);
  }
  
  /// Helper function to split a string into path and attribute name and put it into `retpair`. 
  /// @note This won't work in multithreaded conditions!!!
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
  double   getAttribute(String name)
  {
    if(_splitNameFromPath(name)){
      iAttributable object=objects.get( retPair[0] );
      return object.getAttribute( retPair[1] );
    }
    else return NaN;
  }

  /// It sets a particular attribute. @returns previous attribute value.
  double   setAttribute(String name,double value)
  {
    if(_splitNameFromPath(name)){
      iAttributable object=objects.get( retPair[0] );
      return object.setAttribute( retPair[1] , value );
    }
    else return NaN;
  }
  
} //_EofCl


//*////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*////////////////////////////////////////////////////////////////////////////
