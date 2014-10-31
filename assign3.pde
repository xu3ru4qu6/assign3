int[][] slot;
boolean[][] flagSlot; // use for flag
int bombCount; // 共有幾顆炸彈
int clickCount; // 共點了幾格
int flagCount; // 共插了幾支旗
int nSlot; // 分割 nSlot*nSlot格
int totalSlots; // 總格數
final int SLOT_SIZE = 100; //每格大小

int sideLength; // SLOT_SIZE * nSlot
int ix; // (width - sideLength)/2
int iy; // (height - sideLength)/2

int slotOpened;

// game state
final int GAME_START = 1;
final int GAME_RUN = 2;
final int GAME_WIN = 3;
final int GAME_LOSE = 4;
int gameState;

// slot state for each slot
final int SLOT_OFF = 0;
final int SLOT_SAFE = 1;
final int SLOT_BOMB = 2;
final int SLOT_FLAG = 3;
final int SLOT_FLAG_BOMB = 4;
final int SLOT_DEAD = 5;

PImage bomb, flag, cross ,bg;

void setup(){
  size (640,480);
  textFont(createFont("font/Square_One.ttf", 20));
  bomb=loadImage("data/bomb.png");
  flag=loadImage("data/flag.png");
  cross=loadImage("data/cross.png");
  bg=loadImage("data/bg.png");

  nSlot = 4;
  totalSlots = nSlot * nSlot;
  
  slot = new int[nSlot][nSlot];
  
  sideLength = SLOT_SIZE * nSlot;
  ix = (width - sideLength)/2; // initial x
  iy = (height - sideLength)/2; // initial y
  
  gameState = GAME_START;
}

void draw(){
  switch (gameState){
    case GAME_START:
          background(180);
          image(bg,0,0,640,480);
          textSize(16);
          fill(0);
          text("Choose # of bombs to continue:",10,width/3-24);
          int spacing = width/9;
          for (int i=0; i<9; i++){
            fill(255);
            rect(i*spacing, width/3, spacing, 50);
            fill(0);
            text(i+1, i*spacing, width/3+24);
          }
          // check mouseClicked() to start the game
          break;
    case GAME_RUN:
          //---------------- put you code here ----
          
          break;
    case GAME_WIN:
          textSize(18);
          fill(0);
          text("YOU WIN !!",width/3,30);
          
         for (int col=0; col < nSlot; col++){
            for (int row=0; row < nSlot; row++){
                if( slot[col][row] != SLOT_SAFE )
                  showSlot(col, row, slot[col][row]);
            }
          }
          
          break;
    case GAME_LOSE:
          textSize(18);
          fill(0);
          text("YOU LOSE !!",width/3,30);
          
          for (int col=0; col < nSlot; col++){
            for (int row=0; row < nSlot; row++){
                if( slot[col][row] != SLOT_SAFE )
                  showSlot(col, row, slot[col][row]);
            }
          }
          
          break;
  }
}

int countNeighborBombs(int col,int row){
  // -------------- Requirement B ---------
  
  int count = 0;
  
  for (int i = 0 ; i < nSlot ; i++){
    for (int j = 0 ; j < nSlot ; j++){
      if( i + 1 == col || i - 1 == col || i == col ){
        if( j + 1 == row || j - 1 == row || j == row ){
          if( slot[i][j] == SLOT_BOMB )
            count++;
        }
      }
    }
  }
  
  return count;
}

void setBombs(){
  // initial slot
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
      slot[col][row] = SLOT_OFF;
    }
  }
  
  // -------------- put your code here ---------
  // randomly set bombs
  
  int i = 0;
  
  while( i < bombCount ){
    int col = (int)random(4);
    int row = (int)random(4);
    if( slot[col][row] != SLOT_BOMB ){
      slot[col][row] = SLOT_BOMB;
      i++;
    }
  }
}

void drawEmptySlots(){
  background(180);
  image(bg,0,0,640,480);
  for (int col=0; col < nSlot; col++){
    for (int row=0; row < nSlot; row++){
        showSlot(col, row, SLOT_OFF);
    }
  }
}

void showSlot(int col, int row, int slotState){
  int x = ix + col*SLOT_SIZE;
  int y = iy + row*SLOT_SIZE;
  switch (slotState){
    case SLOT_OFF:
         fill(222,119,15);
         stroke(0);
         rect(x, y, SLOT_SIZE, SLOT_SIZE);
         break;
    case SLOT_BOMB:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE, SLOT_SIZE);
          break;
    case SLOT_SAFE:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          int count = countNeighborBombs(col,row);
          if (count != 0){
            fill(0);
            textSize(SLOT_SIZE*3/5);
            text( count, x+15, y+15+SLOT_SIZE*3/5);
          }
          break;
    case SLOT_FLAG:
          image(flag,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
    case SLOT_FLAG_BOMB:
          fill(255);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(cross,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
    case SLOT_DEAD:
          fill(255,0,0);
          rect(x,y,SLOT_SIZE,SLOT_SIZE);
          image(bomb,x,y,SLOT_SIZE,SLOT_SIZE);
          break;
  }
}

// select num of bombs
void mouseClicked(){
  if ( gameState == GAME_START &&
       mouseY > width/3 && mouseY < width/3+50){
       // select 1~9
       //int num = int(mouseX / (float)width*9) + 1;
       int num = (int)map(mouseX, 0, width, 0, 9) + 1;
       // println (num);
       bombCount = num;
       
       // start the game
       slotOpened = 0;
       clickCount = 0;
       flagCount = 0;
       setBombs();
       drawEmptySlots();
       gameState = GAME_RUN;
  }
}

void mousePressed(){
  if ( gameState == GAME_RUN &&
       mouseX >= ix && mouseX <= ix+sideLength && 
       mouseY >= iy && mouseY <= iy+sideLength){
    
    // --------------- put you code here -------     
    
    int x = ( mouseX - ix ) / SLOT_SIZE;
    int y = ( mouseY - iy ) / SLOT_SIZE;
    
    if (mouseButton == LEFT){ // left click
      if( slot[x][y] == SLOT_BOMB ){
        showSlot(x,y,SLOT_DEAD);
        slot[x][y] = SLOT_DEAD;
        gameState = GAME_LOSE;
      }
      else if( slot[x][y] == SLOT_OFF ){
        showSlot(x,y,SLOT_SAFE);
        slot[x][y] = SLOT_SAFE;
        slotOpened++;
      }
    }
    else if (mouseButton == RIGHT){ // right click
        
      if( slot[x][y] == SLOT_BOMB ){
        if( flagCount < bombCount ){
          showSlot(x,y,SLOT_FLAG);
          slot[x][y] = SLOT_FLAG_BOMB;
          flagCount++;
        }
      }
      else if( slot[x][y] == SLOT_FLAG_BOMB ){
        showSlot(x,y,SLOT_OFF);
        slot[x][y] = SLOT_BOMB; 
        flagCount--;
      }
      else if( slot[x][y] == SLOT_OFF ){
        if( flagCount < bombCount ){
            showSlot(x,y,SLOT_FLAG);
            slot[x][y] = SLOT_FLAG;
            flagCount++;
        }
      }
      else if( slot[x][y] == SLOT_FLAG ){
        showSlot(x,y,SLOT_OFF);
        slot[x][y] = SLOT_OFF;
        flagCount--;
      }
      
      
    }
    if( slotOpened == 16 - bombCount )
      gameState = GAME_WIN;
  }
}

// press enter to start
void keyPressed(){
  if(key==ENTER && (gameState == GAME_WIN || 
                    gameState == GAME_LOSE)){
     gameState = GAME_START;
  }
}
