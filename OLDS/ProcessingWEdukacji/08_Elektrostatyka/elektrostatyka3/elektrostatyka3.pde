// Pole elektrostatyczne   v 1.3c
// Tylko wartości.
///////////////////////////////////////////
//PI - https://processing.org/reference/PI.html
double Q=1; //Ładunek
double Eps0=8.854187817E-12;// F/m  https://pl.wikipedia.org/wiki/Przenikalno%C5%9B%C4%87_elektryczna
double Eps0b=1/(36*PI)*1E-9;
double Scale=0.001;//Ile metrów ma jeden pixel obrazu

size(550,500);
int x=(width-50)/2; //Położenie hor
int y=height/2; //Położenie vert

//Wizializacja natężenia pola
double Cns=(1.0/(4*PI*Eps0));
double Min=Cns*(Q/(2*(x*Scale)*(x*Scale))); //Min wartość nateżenia
double Max=Cns*(Q/(1*Scale*Scale));//... i maksymalna

for(int i=0;i<width-50;i++)
 for(int j=0;j<height;j++)
 {
   if(i==x && j==y) continue;
   double rx=(i-x)*Scale;// odleglość horyzontana w [m]
   double ry=(j-y)*Scale;// odległość wertykalna w [m]
   //double r=Math.sqrt(rx*rx+ry*ry);//Odległość euklidesa   
   //double E=Cns*(Q/(r*r));//Natężenie ze wzoru
   double E=Cns*(Q/(rx*rx+ry*ry));
   //print(rx," ",ry," ",r," ->",E,"->");
   
   double D=(E-Min)/(Max-Min);//Jaka to część maksymalnego możliwego natężenia na tej wizualizacji
   
   stroke((float)Math.pow(D,1/8.0)*255,0,(float)D*255);
   point(i,j);
   //print(D,' ');
 }


//Wizualizacja skali
double Step=1.0/height;
for(int k=0;k<height;k++)
{
   double D=k*Step;
   stroke((float)Math.pow(D,1/8.0)*255,0,(float)D*255);
   line(width-40,k,width,k);
}

/*
noStroke();
fill(255,255,0,64);
ellipse(x,y,5,5);
*/
println("Min=",Min," Max=",Max," Contrast: 1:",Max/Min);