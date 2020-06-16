#define NF 4
#define NB 10

//BUTTONS
////Momentary button vars
int bp[NB] = { 2,3,4,5,6,7,8,9,10,11}; //arduino input pin numbers
boolean bg[NB] = {true,true,true,true,true,true,true,true,true,true};
//Toggle button vars
int btv[NB] = {0,0,0,0,0,0,0,0,0,0};
int btamt[NB] = {1,1,1,1,1,1,1,1,1,1};;   
boolean btg[NB] = {true,true,true,true,true,true,true,true,true,true};

//FSRS
int fsr[NF] = {A0,A1,A2,A3}; //pin number
int fsrv[NF]; //value
int fsrthresh[NF] = {50,50,50,50}; //Threshold so it doesnt print if lower than this value
boolean fsrpeakgate[NF] = {true,true,true,true}; //Peak Gate
int fsrpv[NF] = {0,0,0,0}; //Peak Value
int fsrcont[NF] ;//


void setup() {
  Serial.begin(9600);
  for (int i = 0; i < NB; i++) pinMode(bp[i], INPUT_PULLUP);
}

void loop() {

  //FSRS
  for (int i = 0; i < NF; i++) {
    //Continuous Data
    fsrv[i] = analogRead(fsr[i]); //read analog pin connected to fsr
    //Peak Detection
    if (fsrv[i] > fsrthresh[i]) {
      Serial.print( "fsr" + String(i) + ":");
      Serial.println(fsrv[i]);
      if (fsrv[i] > fsrpv[i]) { //if its still going up
        fsrpv[i] = fsrv[i];
      }
      else { //if its going down 
        if (fsrpeakgate[i]) { //if gate is open
      Serial.print( "fsp" + String(i) + ":");
          Serial.println(fsrpv[i]); //this is our peak
          fsrpeakgate[i] = false; //closes gate
        }
      }
    }
    else { //is below threshold
      if (!fsrpeakgate[i]) {
        fsrpeakgate[i] = true;
        fsrpv[i] = 0;
      }
    }
  }
  
    //BUTTONS
  for (int i = 0; i < NB; i++) {

    if ( digitalRead(bp[i]) == LOW) { //button pushed

      //momentary
      if (bg[i]) {
        bg[i] = false;
        Serial.print("b");
        Serial.print(String(i));
        Serial.print(":");
       // Serial.print( "b" + String(i) + ":");
        Serial.println(1);
      }
    }
    else { //button released

      //momentary
      if (!bg[i]) {
        bg[i] = true;
        Serial.print( "b" + String(i) + ":");
        Serial.println(0);
      }


    }

  }
  delay(30);
}
