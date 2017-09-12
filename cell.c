extern char state[];
extern void resume(int index);
extern WorldLength;
extern WorldWidth;
#include <stdio.h>

int myCellNextState(int myCell){
  if(state[myCell]=='9') 
	  return '9';
  else 
	  return state[myCell]+1;   
}

int sumAndCalcNewState(int n1,int n2,int n3,int n4,int n5,int n6,int n7,int n8, int myCell){
  int valN1=state[n1+2];
  int valN2=state[n2+2];
  int valN3=state[n3+2];
  int valN4=state[n4+2];
  int valN5=state[n5+2];
  int valN6=state[n6+2];
  int valN7=state[n7+2];
  int valN8=state[n8+2];
 int sum= valN1+valN2+valN3+valN4+valN5+valN6+valN7+valN8;
 myCell+=2;
 int count=checkMyStatus(valN1,valN2,valN3,valN4,valN5,valN6,valN7,valN8);
 checkThings1(sum, myCell, state[myCell]);


 if(state[myCell]!='0'){
     if(count==2 || count==3)
         return myCellNextState(myCell);
     else
         return  '0';
		
 }
 else if(state[myCell]=='0')
	{
     if(count==3)
         return myCellNextState(myCell);
     else
         return  '0';
		
	}
 }

int checkMyStatus(int n1, int n2, int n3, int n4, int n5, int n6,int n7, int n8  ){
int count=0;
if(n1>'0')
	count++;
if(n2>'0')
	count++;
if(n3>'0')
	count++;
if(n4>'0')
	count++;
if(n5>'0')
	count++;
if(n6>'0')
	count++;
if(n7>'0')
	count++;
if(n8>'0')
	count++;

return count;

}
int normalRange(int myCell, int myWidth, int myLength){
	
 int n1 = myCell - myWidth -1;
 int n2 = myCell - myWidth;
 int n3 = myCell - myWidth +1;
 
 int n4 = myCell - 1;
 int n5 = myCell + 1;

 int n6 = myCell + myWidth -1;
 int n7 = myCell + myWidth;
 int n8 = myCell + myWidth +1;
 return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);
}

int topYRange(int myCell,int myWidth,int myLength){
 int n1 = myCell + (myWidth*myLength)-1;
 int n2 = myCell + (myWidth*myLength);
 int n3 = myCell + (myWidth*myLength)+1;
 
 int n4 = myCell - 1;
 int n5 = myCell + 1;

 int n6 = myCell+ myWidth -1;
 int n7 = myCell + myWidth;
 int n8 = myCell + myWidth +1;
return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);	
}

int lowYRange(int myCell,int myWidth,int myLength){
 int n1 = myCell - myWidth -1;
 int n2 = myCell - myWidth;
 int n3 = myCell - myWidth +1;
 
 int n4 = myCell - 1;
 int n5 = myCell + 1;

 int n6 = myCell - (myWidth*myLength) -1;
 int n7 = myCell - (myWidth*myLength);
 int n8 = myCell - (myWidth*myLength) +1;
return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);	
	
}

int topXRange(int myCell,int myWidth,int myLength){
 int n1 = myCell - myWidth -1;
 int n2 = myCell - myWidth;
 int n3 = myCell - myWidth - WorldWidth + 1;
 
 int n4 = myCell - 1;
 int n5 = myCell - WorldWidth + 1;

 int n6 = myCell + myWidth -1;
 int n7 = myCell + myWidth;
 int n8 = myCell + myWidth - WorldWidth + 1;
return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);	
}


int lowXRange(int myCell,int myWidth,int myLength){
	
 int n1 = myCell - myWidth + WorldWidth -1;
 int n2 = myCell - myWidth;
 int n3 = myCell - myWidth +1;
 
 int n4 = myCell + WorldWidth -1;
 int n5 = myCell + 1;

 int n6 = myCell + myWidth + WorldWidth -1;
 int n7 = myCell + myWidth;
 int n8 = myCell + myWidth +1;
return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);			
}

int topLeftCorner(int myCell,int myWidth,int myLength){
 int n1 = (WorldWidth * WorldLength) -1 ;
 int n2 = (WorldWidth * WorldLength) - WorldWidth;
 int n3 = (WorldWidth * WorldLength) - WorldWidth +1 ;
 
 int n4 = myCell + WorldWidth-1;
 int n5 = myCell + 1;

 int n6 = myCell + myWidth + WorldWidth-1;
 int n7 = myCell + myWidth;
 int n8 = myCell + myWidth +1;
return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);	
}

int topRightCorner(int myCell,int myWidth,int myLength){	
 int n1 = (WorldWidth * WorldLength)-2 ;
 int n2 = (WorldWidth * WorldLength)-1;
 int n3 = (WorldWidth * WorldLength)- WorldWidth;
 
 int n4 = myCell - 1;
 int n5 = myCell - WorldWidth +  1;

 int n6 = myCell + myWidth -1;
 int n7 = myCell + myWidth;
 int n8 = myCell + myWidth  - WorldWidth +1;
return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);		
}

int lowLeftCorner(int myCell,int myWidth,int myLength){
 int n1 = myCell - myWidth + WorldWidth-1; ;
 int n2 = myCell - myWidth;
 int n3 = myCell - myWidth +1;
 
 int n4 = myCell +WorldWidth-1;
 int n5 = myCell +  1;

 int n6 = WorldWidth -1;
 int n7 = myCell -(WorldWidth*myLength) -1;
 int n8 = myCell -(WorldWidth*myLength);
 return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);	
}

int lowRightCorner(int myCell,int myWidth,int myLength){
 int n1 = myCell - myWidth -1; ;
 int n2 = myCell - myWidth;
 int n3 = myCell - myWidth - WorldWidth +1;
 
 int n4 = myCell - WorldWidth +1;
 int n5 = myCell -  1;

 int n6 = WorldWidth -2;
 int n7 = WorldWidth -1;
 int n8 = 0;
 return sumAndCalcNewState(n1,n2,n3,n4,n5,n6,n7,n8,myCell);	
}


int step1(int x, int y,int myCell, int myWidth,int myLength){
	
        if(x%WorldWidth!=WorldWidth-1 && x%WorldWidth!=0 && y%WorldLength!=WorldLength-1 && y%WorldLength!=0)
            return normalRange(myCell,myWidth,myLength);
        else if( y%WorldLength==0 && x%WorldWidth!=WorldWidth-1 && x%WorldWidth!=0 )
               return topYRange(myCell,myWidth,myLength);
              else if( y%WorldLength==WorldLength-1 && x%WorldWidth!=WorldWidth-1 && x%WorldWidth!=0)
                    return  lowYRange(myCell,myWidth,myLength);
                  else if( x%WorldWidth==WorldWidth-1 && y%WorldLength!=WorldLength-1 && y%WorldLength!=0 )
                       return topXRange(myCell,myWidth,myLength);
                      else if( x%WorldWidth==0 && y%WorldLength!=WorldLength-1 && y%WorldLength!=0)
                             return lowXRange(myCell,myWidth,myLength);
                          else if(x%WorldWidth==0 && y%WorldLength==0)
                                return  topLeftCorner(myCell,myWidth,myLength);
                              else if(x%WorldWidth==WorldWidth-1 && y%WorldLength==0)
                                   return topRightCorner(myCell,myWidth,myLength);
                                    else if(x%WorldWidth==0 && y%WorldLength==WorldLength-1)
                                        return  lowLeftCorner(myCell,myWidth,myLength);
                                          else if(x%WorldWidth==WorldWidth-1 && y%WorldLength==WorldLength-1)
                                              return  lowRightCorner(myCell,myWidth,myLength);
}


int cell(int x, int y){
        checkThings3(state[0],state[1],state[2],state[3],state[4], state[5],state[6],state[7],state[8]);
        int myCell=0;                     
        int myWidth= WorldWidth;
        int myLength= WorldLength-1;
        myCell= myWidth*y + x;         /*get to the lines before the cell's line , and add x to it*/
 
       return step1(x,y,myCell,myWidth,myLength);
  
}
void checkThings3(int n1 ,int n2 ,int n3,int n4, int n5, int n6, int n7, int n8){};
