PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;
int x=0, y=0;//stone's position
int soilSize=80;
final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;
float soldierSize=80;
float playerSize=80;
float cabbageSize=80;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;
int[] bkx= new int [24];
int [] bkx2= new int [24];
float[] cabbageX= new float [24];
float[] soldierX= new float [24];

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[]  cabbageY, soldierY;
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;



void setup() {
   for(int i=0; i<bkx.length;i++){
 bkx[i]=floor(random(8 ));
   }
   for(int s=0; s<bkx2.length;s++){
 bkx2[s]=floor(random(8 ));
   }
   for(int i=0; i<bkx.length;i++){
 cabbageX[i]=floor(random(8 ));
   }
   for(int i=0; i<bkx.length;i++){
 soldierX[i]=floor(random(8 )); 
   }
   
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	groundhogIdle = loadImage("img/groundhogIdle.png");
	groundhogLeft = loadImage("img/groundhogLeft.png");
	groundhogRight = loadImage("img/groundhogRight.png");
	groundhogDown = loadImage("img/groundhogDown.png");
	life = loadImage("img/life.png");
	soldier = loadImage("img/soldier.png");
	cabbage = loadImage("img/cabbage.png");

	soilEmpty = loadImage("img/soils/soilEmpty.png");

	// Load soil images used in assign3 if you don't plan to finish requirement #6
	soil0 = loadImage("img/soil0.png");
	soil1 = loadImage("img/soil1.png");
	soil2 = loadImage("img/soil2.png");
	soil3 = loadImage("img/soil3.png");
	soil4 = loadImage("img/soil4.png");
	soil5 = loadImage("img/soil5.png");
stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");

//soldier
  soldierX[0] =-160;
  
  soldierSize = 80;
  soldierSpeed = 3;//soldier

	// Load PImage[][] soils
	soils = new PImage[6][5];
	for(int i = 0; i < soils.length; i++){
		for(int j = 0; j < soils[i].length; j++){
			soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
		}
	}

	// Load PImage[][] stones
	stones = new PImage[2][5];
	for(int i = 0; i < stones.length; i++){
		for(int j = 0; j < stones[i].length; j++){
			stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
		}
	}

	// Initialize player
	playerX = PLAYER_INIT_X;
	playerY = PLAYER_INIT_Y;
	playerCol = (int) (playerX / SOIL_SIZE);
	playerRow = (int) (playerY / SOIL_SIZE);
	playerMoveTimer = 0;
	playerHealth = 2;

	// Initialize soilHealth
	soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
	for(int i = 0; i < soilHealth.length; i++){
		for (int j = 0; j < soilHealth[i].length; j++) {
			 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
			soilHealth[i][j] = 15;

		}
	}



	// Initialize soidiers and their position

	// Initialize cabbages and their position

}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}

		break;

		case GAME_RUN: // In-Game
		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil

		for(int i = 0; i < soilHealth.length; i++){
			for (int j = 0; j < soilHealth[i].length; j++) {

				// Change this part to show soil and stone images based on soilHealth value
				// NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
				int areaIndex = floor(j / 4);
				image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
				
			}
		}

  for (int i=0;i<23;i++){
image(soilEmpty,bkx[i]*80,(i+1)*80); 
soilHealth[bkx[i]][i+1]=0;
}
  for (int s=0;s<23;s++){
image(soilEmpty,bkx2[s]*80,(s+1)*80); 
soilHealth[bkx2[s]][s+1]=0;
}




        //stone 1-8
        
        y=0;
        x=0;
        for (int p=0; p<8; p++) {
          x = p*soilSize;
          image(stone1, x, y);
          y +=soilSize;
          soilHealth[p][p] =30;
        }
        
        
        //stone 9-16
        pushMatrix();
        translate(0, soilSize*8);
        y=0;
        x = soilSize;
        for (int i=0; i<4; i++) {//no.9.12.13.16
          for (int n=0; n<4; n++) {
            x = (i+1)*soilSize;
            y = n*soilSize;
            if (i>1) {
              x = (i+3)*soilSize;
             
            }
            if (n>=1) {
              y = (n+2)*soilSize;
             
            }
            if (n>=3) {
              y = (n+4)*soilSize;
              
            }
            image(stone1, x, y);
            soilHealth[x/soilSize][8+y/soilSize] = 30;
            soilHealth[y/soilSize][8+x/soilSize] = 30;
            
            
          }
        }
        for (int i=0; i<4; i++) {//no.10.11.14.15
          for (int n=0; n<4; n++) {
            x = i*soilSize;
            y = (n+1)*soilSize;
            if (i>0) {
              x = (i+2)*soilSize;
            }
            if (i==3) {
              x = (i+4)*soilSize;
            }
            if (n>=2) {
              y = (n+3)*soilSize;
            }
            image(stone1, x, y);
            
          }
        }
        popMatrix();
    
        //stone 17-24
        pushMatrix();
        translate(-soilSize*6, soilSize*16);
        y=0;
        x=0;
        for (int n=0; n<5; n++) {
          pushMatrix();
          translate(n*soilSize*3, 0);
          for (int i=7; i>-1; i--) {
            int x1, x2;
            x1 = soilSize*i;
            image(stone1, x1, y);
            x2 = soilSize*(i+1);
            image(stone1, x2, y);
            image(stone2, x2, y);
            y += soilSize;
           
           soilHealth[i][y/soilSize+15] = 30;
           soilHealth[i][y/soilSize+12] = 30;
           soilHealth[i][y/soilSize+9] = 30;
           soilHealth[7][23] = 45;
           
           for (int p=1; p<8; p++) {
           soilHealth[p][24-p] = 45;} 
           for (int t=4; t<8; t++) {
           soilHealth[t][27-t] = 45;}
           for (int ty=0; ty<6; ty++) {
           soilHealth[ty][21-ty] =45;}
           for (int tp=0; tp<3; tp++) {
           soilHealth[tp][18-tp] = 45;}
           
          }
          
          y=0;
           
          popMatrix();
        }
        popMatrix();
          //playerHealth (size: 50*43) game change; gap=20pixel
    if (playerHealth >= 5) playerHealth = 5;
    for (int i=0; i<playerHealth; i++) {
      image(life, 10+i*70, -150);
     
    }
    if (playerHealth == 0) {
      gameState = GAME_OVER;
    }
    
   
        
        for (int i=0;i<23;i++){
image(soilEmpty,bkx[i]*80,(i+1)*80); 
soilHealth[bkx[i]][i+1]=0;
}
  for (int s=0;s<23;s++){
image(soilEmpty,bkx2[s]*80,(s+1)*80); 
soilHealth[bkx2[s]][s+1]=0;
}

for (int Y=0;Y<23;Y+=4){
   soldierX[Y] += soldierSpeed;//soldier Walking Speed
   if (soldierX[Y] > 640) {
          soldierX[Y] = -80;
          soldierX[Y] += soldierSpeed;
        }
 image(soldier, soldierX[Y], Y*80);
       
       

}

		// Cabbages
 /*for (int i=0;i<23;i+=4){
image(cabbage,cabbageX[i]*80,i*80); 

}*/
		// > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!

		// Groundhog

		PImage groundhogDisplay = groundhogIdle;

		// If player is not moving, we have to decide what player has to do next
		if(playerMoveTimer == 0){

			// HINT:
			// You can use playerCol and playerRow to get which soil player is currently on

			// Check if "player is NOT at the bottom AND the soil under the player is empty"
			// > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
			// > Else then determine player's action based on input state

			if(leftState){

				groundhogDisplay = groundhogLeft;

				// Check left boundary
				if(playerCol > 0){

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the left"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)

					playerMoveDirection = LEFT;
					playerMoveTimer = playerMoveDuration;

				}

			}else if(rightState){

				groundhogDisplay = groundhogRight;

				// Check right boundary
				if(playerCol < SOIL_COL_COUNT - 1){

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the right"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)

					playerMoveDirection = RIGHT;
					playerMoveTimer = playerMoveDuration;

				}

			}else if(downState){

				groundhogDisplay = groundhogDown;

				// Check bottom boundary

				// HINT:
				// We have already checked "player is NOT at the bottom AND the soil under the player is empty",
				// and since we can only get here when the above statement is false,
				// we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
				if(playerRow < SOIL_ROW_COUNT - 1){

					// > If so, dig it and decrease its health

					// For requirement #3:
					// Note that player never needs to move down as it will always fall automatically,
					// so the following 2 lines can be removed once you finish requirement #3

					playerMoveDirection = DOWN;
					playerMoveTimer = playerMoveDuration;


				}
			}

		}

		// If player is now moving?
		// (Separated if-else so player can actually move as soon as an action starts)
		// (I don't think you have to change any of these)

		if(playerMoveTimer > 0){

			playerMoveTimer --;
			switch(playerMoveDirection){

				case LEFT:
				groundhogDisplay = groundhogLeft;
				if(playerMoveTimer == 0){
					playerCol--;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
				}
				break;

				case RIGHT:
				groundhogDisplay = groundhogRight;
				if(playerMoveTimer == 0){
					playerCol++;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
				}
				break;

				case DOWN:
				groundhogDisplay = groundhogDown;
				if(playerMoveTimer == 0){
					playerRow++;
					playerY = SOIL_SIZE * playerRow;
				}else{
					playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
				}
				break;
			}

		}

		image(groundhogDisplay, playerX, playerY);
  
        //hog touch soldier
         for (int i=0;i<23;i+=4){
           float cabbageY=i*80;


for (int Y=0;Y<23;Y+=4){
  image(cabbage,cabbageX[i]*80,cabbageY); 
   if (soldierX[Y] > 640) {
          soldierX[Y] = -80;
          {
            
            if (playerX < soldierX[X]+soldierSize &&//new
          playerX+playerSize > soldierX[X] &&
          playerY < soldierX[Y]+soldierSize &&
          playerY+playerSize > soldierX[Y])
        {
          playerHealth-=1;
          playerX=320.0;
          playerY=80.0;
          groundhogDisplay = groundhogDown;
        
        
       
        
          }}}}}

		// Soldiers
		// > Remember to stop player's moving! (reset playerMoveTimer)
		// > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
		// > Remember to reset the soil under player's original position!

		// Demo mode: Show the value of soilHealth on each soil
		// (DO NOT CHANGE THE CODE HERE!)

		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// Health UI

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;

				// Initialize player
				playerX = PLAYER_INIT_X;
				playerY = PLAYER_INIT_Y;
				playerCol = (int) (playerX / SOIL_SIZE);
				playerRow = (int) (playerY / SOIL_SIZE);
				playerMoveTimer = 0;
				playerHealth = 2;

				// Initialize soilHealth
				soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
				for(int i = 0; i < soilHealth.length; i++){
					for (int j = 0; j < soilHealth[i].length; j++) {
						 // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
						soilHealth[i][j] = 15; 
					}
				}

				// Initialize soidiers and their position

				// Initialize cabbages and their position
				
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = true;
			break;
			case RIGHT:
			rightState = true;
			break;
			case DOWN:
			downState = true;
			break;
		}
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = false;
			break;
			case RIGHT:
			rightState = false;
			break;
			case DOWN:
			downState = false;
			break;
		}
	}
}
