/// @file "aPair.pde"
/// @brief `Pair` is one of the very COMMONLY used and usable TEMPLATE.
/// @date 2023.03.07 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

// USE /*_interfunc*/ &  /*_forcebody*/ for interchangeable function 
// if you need translate the code into C++ (--> Processing2C )

/// Simple version of Pair template useable for returning a pair of values.

/*_OnlyProcessingBlockBegin*/
/// @NOTE: Java template are currently not supported in Processing2C!
public 
class Pair<A,B> {
    public final A a;
    public final B b;

    public Pair(A a, B b) 
    {
        this.a = a;
        this.b = b;
    }
} //_EndOfClass

/*_OnlyProcessingBlockEnd*/

/*_OnlyCppBlockBegin

  template<class A,class B>
  class 
  Pair
  {
    public:
      A a;
      B b;

    Pair(A a, B b) 
    {
        this->a = a;
        this->b = b;
    }
  };
  
 _OnlyCppBlockEnd*/

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
//*/////////////////////////////////////////////////////////////////////////////
