/** //<>//
 * Processing Sketch by Josi Whitlock
 * John Conway's Game of Life in Processing
 * May 12, 2022
 */

import javax.swing.JOptionPane;

int gridX; //<>// //<>//
int gridY;
int tickSpeed = 500;
boolean play = true;
Pixel[][] pixels;

void setup() {
  size(600, 600); // cell count * 10
  
  surface.setLocation(displayWidth / 2 - width / 2, displayHeight / 2 - height / 2);

  JOptionPane.showMessageDialog(null, "Controls:\n    Pause/Play: space\n    Toggle Cell State: click");
  gridX = width / 10;
  gridY = height / 10;
  pixels = new Pixel[gridX][gridY];
  for (int l = 0; l < pixels.length; l++) {
    for (int i = 0; i < pixels[l].length; i++) {
      pixels[l][i] = new Pixel(l * 10, i * 10, false);//floor(random(5)) == 1);
    }
  }

  pixels[2][1].alive = true;
  pixels[2][2].alive = true;
  pixels[2][3].alive = true;
}

void draw() {
  background(0);

  for (int i = 0; i < pixels.length; i++) {
    for (int j = 0; j < pixels[i].length; j++) {
      stroke(0);
      fill(0);
      if (pixels[i][j].alive) {
        stroke(255);
        fill(255);
      }
      rect(pixels[i][j].x, pixels[i][j].y, 10, 10);
    }
  }

  for (int i = 1; i < gridX; i++) {
    for (int j = 1; j < gridY; j++) {
      stroke(150);
      line(0, j * 10, width, j * 10);
    }
    line(i * 10, 0, i * 10, height);
  }

  if (play) {
    try {
      Thread.sleep(tickSpeed);
    }
    catch (Exception e) {
      println("Uh oh errorio");
    }
    Pixel[][] pixelsTemp = new Pixel[gridX][gridY];
    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        int localLiving = 0;

        // loop over eight surrounding
        // starting with y
        for (int why = y - 1; why <= y + 1; why++) {
          if (why < 0 || why >= height / 10) continue;

          // loop over three x in y
          for (int ex = x - 1; ex <= x + 1; ex++) {
            if (ex < 0 || ex >= width / 10) continue;
            if (pixels[ex][why] == pixels[x][y]) continue;

            if (pixels[ex][why].alive) {
              localLiving++;
            }
          }
        }

        // meets criteria
        if (pixels[x][y].alive && (localLiving == 2 || localLiving == 3)) pixelsTemp[x][y] = new Pixel(pixels[x][y].x, pixels[x][y].y, true);
        else if (!pixels[x][y].alive && localLiving == 3) pixelsTemp[x][y] = new Pixel(pixels[x][y].x, pixels[x][y].y, true);
        else pixelsTemp[x][y] = new Pixel(pixels[x][y].x, pixels[x][y].y, false);
      }
    }
    pixels = pixelsTemp;
    //println("cycle");
  }
}

void mouseClicked() {
  int x = floor(mouseX / 10);
  int y = floor(mouseY / 10);

  pixels[x][y].alive = !pixels[x][y].alive;
}

void keyPressed() {
  if (key == ' ') play = !play;
}

public class Pixel {
  public int x;
  public int y;
  public boolean alive;

  public Pixel(int _x, int _y, boolean a) {
    x = _x;
    y = _y;
    alive = a;
  }
}
