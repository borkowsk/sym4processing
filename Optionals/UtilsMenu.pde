import java.awt.MenuBar;
import java.awt.Menu;
import java.awt.MenuItem;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import processing.awt.PSurfaceAWT;

MenuBar myMenu;//Processig does not see the height of MenuBar added to Window!

void setupMenu() {
  myMenu = new MenuBar();
  
  Menu fileMenu = new Menu("File");
  myMenu.add(fileMenu);
  
  MenuItem closeItem=new MenuItem("Close");
  closeItem.addActionListener(new ActionListener() {
        public void actionPerformed(ActionEvent ev) {
                exit();//Local exit function
            }
          } 
        );
  fileMenu.add(closeItem);
  
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setMenuBar(myMenu);
}
 
