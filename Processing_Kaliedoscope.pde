import themidibus.*;  

PImage photo;
MidiBus myBus;

int[] sample_coords = {30, 0, 150, 10};
int[] grid_size = {3, 3};

void setup() {
  size(640, 480);
  photo = loadImage("flowers.jpg");
  MidiBus.list();
  myBus = new MidiBus(this, "Arturia BeatStepPro", 1);
  calculate_sample_coords();
  //calculate_grid();
}

void calculate_sample_coords() {
}

void calculate_grid() {
}

void controllerChange(int channel, int number, int value) {
  if (number == 10){
    sample_coords[0] = int(map(value, 0, 127, 1, photo.width));
  }
  if (number == 74){
    sample_coords[1] = int(map(value, 0, 127, 1, photo.height));
  }
  if (number == 71){
    sample_coords[2] = int(map(value, 0, 127, 1, photo.width));
  }
  if (number == 76){
    sample_coords[3] = int(map(value, 0, 127, 1, photo.height));
  }
}


public PImage make_img(PImage sampledChunk) {
  PImage img = createImage(sampledChunk.width*2, sampledChunk.height*2, RGB);
  image(sampledChunk,0,0); // top left
  scale(1,-1);//flip on X axis
  image(sampledChunk,0,-sampledChunk.height*2); // bottom left
  scale(-1,-1);// flip back X and flip Y
  image(sampledChunk,-sampledChunk.width*2,0); // top right
  scale(1,-1);
  image(sampledChunk,-sampledChunk.width*2,-sampledChunk.height*2); // top left
  return img;
}

void draw() {
  PImage sampledChunk = photo.get(sample_coords[0], sample_coords[1], sample_coords[2], sample_coords[3]); 

  grid_size[0] = width/sampledChunk.width;
  grid_size[1] = height/sampledChunk.height;
  
  for (int i = 0; i <= grid_size[0]; i++ ) {
    for (int j = 0; j <= grid_size[1]; j++){
    image(sampledChunk, sampledChunk.width*i, sampledChunk.height*j); // bottom right
    scale(-1.0, 1.0);
    image(sampledChunk, -sampledChunk.width*i, sampledChunk.height*j); // bottom left
    scale(-1.0, -1.0);
    image(sampledChunk, sampledChunk.width*i, -sampledChunk.height*j); // top right
    scale(-1.0, 1.0);
    image(sampledChunk, -sampledChunk.width*i, -sampledChunk.height*j); // top left
    }
  }
}
