int counter;    // カウンタ
PImage[]  tex;  // テクスチャ配列
PVector[] pos;  // パーティクル位置ベクトル
PVector[] vel;  // パーティクル速度ベクトル

final int   NUM_PARTICLES  = 300;  // パーティクル数
final float ACCELERATION = 0.01;  // 加速度

void setup() {
  background(0);
  size(400, 300);
  tex = new PImage[NUM_PARTICLES];
  pos = new PVector[NUM_PARTICLES];
  vel = new PVector[NUM_PARTICLES];
  counter = 0;
  
  // パーティクルのテクスチャを配列に格納
  colorMode(HSB, NUM_PARTICLES, 100, 100);
  for(int i = 0; i < tex.length; i++) {
    tex[i] = getParticleTexture(color(i, 80, 50));
    pos[i] = new PVector(0, height * 2);
    vel[i] = new PVector();
  }
}

void draw() {
  noStroke();
  fill(0, 10);
  
  rect(0, 0, width, height);
  
  // カウンタ更新
  if (++counter >= NUM_PARTICLES) counter = 0;
  
  // ずれ量（初期位置にノイズを加える）
  float noiseAmount = tex[counter].width/4.0;
  
  // 初期位置の設定
  //pos[counter].x = mouseX + random(-noiseAmount, noiseAmount);
  //width/2 + random(-noiseAmount, noiseAmount);
  //pos[counter].y = mouseY + random(-noiseAmount, noiseAmount);
  //height * 9/10 + random(-noiseAmount, noiseAmount);
  if (mousePressed && (mouseButton == LEFT)) {
    pos[counter].x = width/2 + random(-noiseAmount, noiseAmount);
    pos[counter].y = height * 9/10 + random(-noiseAmount, noiseAmount);
  } else {
     pos[counter].x = mouseX;
     pos[counter].y = mouseY;
  };

  
  // 初速度の設定
  vel[counter].x = random(-1, 1);
  vel[counter].y = random(-1, 1);
  
  
  // パーティクルの更新
  for(int i = 0; i < NUM_PARTICLES; i++) {
    if(pos[i].y < height+tex[i].height && pos[i].y>-tex[i].height) {
      // パーティクル描画 加算合成にするのがポイント
      blend(tex[i], 0, 0, 
            tex[i].width, tex[i].height,
            (int)pos[i].x, (int)pos[i].y,
            tex[i].width, tex[i].height, ADD);
    }
    // 位置・速度更新
    pos[i].x += vel[i].x;
    pos[i].y += vel[i].y;
    vel[i].x += random(-0.5, 0.5);
    vel[i].y += random(-0.5, 0.5);
  }
}

// ==============================================
// 指定した色のパーティクル用テクスチャを生成する
// 引数 c : パーティクルの色
// ==============================================
PImage getParticleTexture(color c) {
  // 画像サイズとパーティクルの半径
  final int   IMG_SIZE        = 15;
  final float PARTICLE_RADIUS = 0.5f * IMG_SIZE - 2;
  
  // colorMode(RGB, 255, 255, 255);
  // 画像を作成
  PImage img = createImage(IMG_SIZE, IMG_SIZE, RGB);
  img.loadPixels();
  for(int i = (int)PARTICLE_RADIUS; i > 0; i--) {
    // グラデーション作成
    int a = (int)(0xFF*(float)(PARTICLE_RADIUS-i)/PARTICLE_RADIUS);
    int fg = c;
    int fR = (0x00FF0000 & fg) >>> 16;
    int fG = (0x0000FF00 & fg) >>> 8;
    int fB =  0x000000FF & fg; 
    int rR = (fR * a) >>> 8;
    int rG = (fG * a) >>> 8;
    int rB = (fB * a) >>> 8;
     fg = 0xFF000000 | (rR << 16) | (rG << 8) | rB;
    // パーティクル用テクスチャ作成
    for(int y = 0; y < img.height; y++) {
      for(int x = 0; x < img.width; x++) {
        float yDistance = (y-img.height/2.0)*(y-img.height/2.0);
        float xDistance = (x-img.width/2.0)*(x-img.width/2.0);
        if(yDistance + xDistance <= i*i) {
          img.pixels[y * img.width + x] = fg;
        }
      }
    }
  }
  img.updatePixels();
  img.filter(BLUR);
  return img;
}

