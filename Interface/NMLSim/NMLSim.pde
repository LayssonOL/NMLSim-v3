import static javax.swing.JOptionPane.*;
import javax.swing.UIManager;
import java.awt.Color;
// import processing.svg.*;


SpriteCenter sprites;
Header h;
PanelMenu pm;
SubstrateGrid sg;
FileHandler fileSys;
SimulationBar sb;
PopUpCenter popCenter;

float fontSz = 14;
float scaleFactor = 1;
int screenX, screenY, screenHeight, screenWidth;
int cellH = 10, cellW = 10;
int bulletXGap = 70, bulletYGap = 170;

boolean ctrlPressed = false, altPressed = false, shiftPressed = false;

void setup(){
    size(1280, 720);
    
    // print("\nDisplay width: " + displayWidth);
    // print("\nDisplay height: " + displayHeight);
    
    sprites = new SpriteCenter();
    //surface.setSize(1280, 720);
    //scaleFactor = 1;
    //sg = new SubstrateGrid(0, 105, 1280, 564, 10, 10, 1000, 5000);
    //sg.setHiddenDimensions(500,300,500,150);
    //sg.setBulletSpacing(60,124);
    //pm = new PanelMenu(0, 670, 300, 500, sg);
    //h = new Header(0, 0, 1280, sg);
    //h.setPanelMenu(pm);
    //fileSys = new FileHandler("", h, pm, sg);
    //sb = new SimulationBar(0, 690, 1280, 30, sg, pm);
    //h.setSimulationBar(sb);
    
    if(displayWidth > 2560) {
      screenHeight = 1440;
      screenWidth = 2560;
      surface.setSize(screenWidth, screenHeight);
      scaleFactor = 1;
      sg = new SubstrateGrid(0, 105, screenWidth, (screenHeight * 0.855), cellW, cellH, screenWidth, screenHeight);
      sg.setHiddenDimensions(500,300,500,150);
      sg.setBulletSpacing(bulletXGap, bulletYGap);
      pm = new PanelMenu(0, (screenHeight * 0.955), (screenWidth * 0.2), (screenHeight * 0.6), sg);
      h = new Header(0, 0, screenWidth, sg);
      h.setPanelMenu(pm);
      fileSys = new FileHandler("", h, pm, sg);
      sb = new SimulationBar(0, (screenHeight * 0.973), screenWidth, 30, sg, pm);
      h.setSimulationBar(sb); 
    //} 
    //else if (displayWidth > 1366) {
    //  surface.setSize(1920, 1080);
    //  scaleFactor = 1;
    //  sg = new SubstrateGrid(0, 105, 1920, 924, 10, 10, 1000, 5000);
    //  sg.setHiddenDimensions(500,300,500,150);
    //  sg.setBulletSpacing(60,120);
    //  pm = new PanelMenu(0, 1000, 300, 500, sg);
    //  h = new Header(0, 0, 1920, sg);
    //  h.setPanelMenu(pm);
    //  fileSys = new FileHandler("", h, pm, sg);
    //  sb = new SimulationBar(0, 1020, 1920, 30, sg, pm);
    //  h.setSimulationBar(sb); 
    } else {
      surface.setSize(1280, 720);
      scaleFactor = 1;
      sg = new SubstrateGrid(0, 105, 1280, 564, 10, 10, 1000, 5000);
      sg.setHiddenDimensions(500,300,500,150);
      sg.setBulletSpacing(60,124);
      pm = new PanelMenu(0, 670, 300, 500, sg);
      h = new Header(0, 0, 1280, sg);
      h.setPanelMenu(pm);
      fileSys = new FileHandler("", h, pm, sg);
      sb = new SimulationBar(0, 690, 1280, 30, sg, pm);
      h.setSimulationBar(sb);
    }
    
    
   
    popCenter = new PopUpCenter();
    UIManager UI=new UIManager();
    UI.put("OptionPane.background", new Color(116, 163, 117));
    UI.put("Panel.background", new Color(116, 163, 117));
    
    print("\nFinish setup!!!");
}

void draw(){
    if(!focused)
        ctrlPressed = altPressed = shiftPressed = false;
    scale(scaleFactor);
    background(255, 153, 85);
    sg.drawSelf();
    pm.drawSelf();
    h.drawSelf();
    sb.drawSelf();
    popCenter.drawSelf();
}

void mousePressed(){
    if(popCenter.isActive())
        return;
    h.mousePressedMethod();
    pm.mousePressedMethod();
    sg.mousePressedMethod();
    sb.mousePressedMethod();
}

void keyPressed(){
    if(key == ESC) key=0;
    if(popCenter.isActive())
        return;
    if(key == CODED && keyCode == CONTROL)
        ctrlPressed = true;
    if(key == CODED && keyCode == ALT)
        altPressed = true;
    if(key == CODED && keyCode == SHIFT)
        shiftPressed = true;
    h.keyPressedMethod();
    pm.keyPressedMethod();
    sb.keyPressedMethod();
}

void keyReleased(){
    if(key == CODED && keyCode == CONTROL)
        ctrlPressed = false;
    if(key == CODED && keyCode == ALT)
        altPressed = false;
    if(key == CODED && keyCode == SHIFT)
        shiftPressed = false;
}

void mouseWheel(MouseEvent e){
    if(popCenter.isActive())
        return;
    float v = e.getCount();
    pm.mouseWheelMethod(v);
    sg.mouseWheelMethod(v);
}

void mouseDragged(){
    if(popCenter.isActive())
        return;
    pm.mouseDraggedMethod();
    sg.mouseDraggedMethod();
}

void saveAs(File selectedPath){
    if(selectedPath == null)
        return;
    String fileBaseName = selectedPath.getAbsolutePath();
    fileSys.setBaseName(fileBaseName);
    fileSys.writeXmlFile(null);
    fileSys.writeStructureFile();
    fileSys.writeConfigFile(null);
    PopUp p = new PopUp(((width-200)/2)*scaleFactor, ((height-100)/2)*scaleFactor, 200, 100, "Changes saved!");
    p.activate();
    p.setAsTimer(20);
    popCenter.setPopUp(p);
    ctrlPressed = altPressed = shiftPressed = false;
}

void saveProject(){
    fileSys.writeXmlFile(null);
    fileSys.writeConfigFile(null);
    fileSys.writeStructureFile();
    PopUp p = new PopUp(((width-200)/2)*scaleFactor, ((height-100)/2)*scaleFactor, 200, 100, "Changes saved!");
    p.activate();
    p.setAsTimer(20);
    popCenter.setPopUp(p);
    ctrlPressed = altPressed = shiftPressed = false;
}

void openProject(File selectedPath){
    if(selectedPath == null)
        return;
    String fileBaseName = selectedPath.getAbsolutePath();
    Path p = Paths.get(fileBaseName + "/structures.str");
    Path svgp = Paths.get(fileBaseName + "/circuit.svg");
    // noLoop();
    // beginRecord(SVG, fileBaseName + "/circuit.svg");
    if(!Files.exists(p)){
        return;
    }
    p = Paths.get(fileBaseName + "/configurations.nmls");
    if(!Files.exists(p)){
        return;
    }
    fileSys.setBaseName(fileBaseName);
    fileSys.readStructureFile();
    fileSys.readConfigFile();
    pm.setProjectLoaded(fileSys.getProjectIsLoaded());
    ctrlPressed = altPressed = shiftPressed = false;
    // endRecord();
}

void importStructures(File selectedPath){
    if(selectedPath == null)
        return;
    Path p = Paths.get(selectedPath.getAbsolutePath() + "/structures.str");
    if(!Files.exists(p)){
        return;
    }
    fileSys.importStructureFile(selectedPath.getAbsolutePath() + "/structures.str");
    ctrlPressed = altPressed = shiftPressed = false;
}

void exportXML(File selectedPath){
    if(selectedPath == null)
        return;
    String filename = selectedPath.getAbsolutePath();
    fileSys.writeXmlFile(filename);
    ctrlPressed = altPressed = shiftPressed = false;
}
