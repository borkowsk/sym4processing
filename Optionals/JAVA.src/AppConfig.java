/////////////////////////////////////////////////////////////////
// IMPORTANT: In the Processing PDE this class needs to be stored
// in its own tab and named "AppConfig.java"
/////////////////////////////////////////////////////////////////
 
import java.util.*;
import javax.xml.bind.annotation.*;
 
// this annoation marks the AppConfig class to be able to act as
// an XML root element. The name parameter is only needed since
// our XML element name is different from the class name:
// <config> vs. AppConfig
 
@XmlRootElement(name="config")
public class AppConfig {
 
  // now we simply annotate the different variables
  // depending if they are XML elements/nodes or node attributes
  // the mapping to the actual data type is done automatically
  @XmlAttribute(name="version")
    float versionID;
 
  // here we also specify default values, which are used
  // if there's no matching data for this variable in the XML
  @XmlElement
    String title="Window title";
 
  @XmlElement
    String message="Hello World!";
  
  @XmlElement
    String textcolor="0";
    
  @XmlElement
    int textsize=32;
 
  @XmlElement
    int width=0;
 
  @XmlElement
    int height=0;
 
//  @XmlElement 
//    boolean fullscreen=true;
   
  @XmlElement
    String bg="ffffff";
    
  @XmlElement
    String target="111111";

  @XmlElement    
    String outfile="";
    
  @XmlElement   
    int maxtime=0;
    
  @XmlElement    
    int rate=0;
  
  @XmlElement  
    String breakchars="";
    
  @XmlElement  
    boolean breakmouse=true;  
 
  // one of the best things in JAXB is the ability to map entire
  // class hierarchies and collections of data
  // in this case each <url> element will be added to this list
  // the actual MyURL class is defined in its own tab in the Processing PDE
  @XmlElement(name="url")
    List<MyURL> urls=new ArrayList<MyURL>();
}

