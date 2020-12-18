// Pole elektrostatyczne   v 1.2b
// Tylko wartości.
///////////////////////////////////////////
//PI - https://processing.org/reference/PI.html

int x=200; //Położenie hor
int y=200; //Położenie vert
double Q=1; //Ładunek
double Eps0=8.854187817E-12;// F/m  https://pl.wikipedia.org/wiki/Przenikalno%C5%9B%C4%87_elektryczna
double Eps0b=1/(36*PI)*1E-9;
double Scale=0.0001;//Ile metrów ma jeden pixel obrazu

size(450,400);
//Wizializacja natężenia pola
double Min=(1.0/(4*PI*Eps0))*(Q/(2*(x*Scale)*(x*Scale))); //Min wartość nateżenia
double Max=(1.0/(4*PI*Eps0))*(Q/(1*Scale*Scale));//... i maksymalna

for(int i=0;i<width-50;i++)
 for(int j=0;j<height;j++)
 {
   if(i==x && j==y) continue;
   double rx=(i-x)*Scale;// odleglość horyzontana w [m]
   double ry=(j-y)*Scale;// odległość wertykalna w [m]
   double r=Math.sqrt(rx*rx+ry*ry);//Odległość euklidesa   
   double E=(1.0/(4*PI*Eps0))*(Q/(r*r));//Natężenie ze wzoru
   //print(rx," ",ry," ",r," ->",E);
   
   float Ve=(float)Math.log(E);//logarytm naturalny
   float V10=(float)Math.log10(E);//logarytm dziesiętny
   //print(" ",Ve," ");
   stroke(0,Ve*3,V10*3);
   point(i,j);
   //println("->",D*255,' ');
 }
 
//Wizualizacja skali
double Step=Max/height;
for(int k=0;k<height;k++)
{
   double D=k*Step;
   float Ve=(float)Math.log(D);//logarytm naturalny
   float V10=(float)Math.log10(D);//logarytm dziesiętny
   stroke(0,Ve*3,V10*3);
   line(width-40,k,width,k);
}
 
/*
noStroke();
fill(255,255,0,64);
ellipse(x,y,5,5);
*/
println("Min=",Min," Max=",Max," Contrast: 1:",Max/Min);