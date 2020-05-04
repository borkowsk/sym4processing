// Generally useable interfaces
///////////////////////////////////////////////////////////////////////////////////////////

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

interface named //Any object which have name as printable String
{
  String getName();
}

interface describable //Any object which have description as (potentially) long, multi line string
{
  String getDescription();
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
///////////////////////////////////////////////////////////////////////////////////////////
