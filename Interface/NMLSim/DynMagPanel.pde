class DynMagPanel{
    float x, y, w, h;
    TextBox name, magName, duration, currentMagnetization;
    Button saveButton, newButton, clearButton, cancelButton;
    color panelColor, textColor;
    SimulationPanel sp;
    SubstrateGrid substrateGrid;
    ListContainer dynMagPairs;
    HashMap<String, String> dynMagValues;
    Chart preview;
    boolean isEditing;
    String editingStructure;

    DynMagPanel(float x, float y, float w, float h, SimulationPanel sp){
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.sp = sp;
        textSize(fontSz);
        panelColor = color(45, 80, 22);
        textColor = color(255,255,255);
        isEditing = false;
        
        dynMagValues = new HashMap<String, String>();

        magName = new TextBox("Magnet", 0, 0, w-20);
        magName.setValidationType("String");
        
        name = new TextBox("Name", 0, 0, w-20);
        name.setValidationType("String");
        
        currentMagnetization = new TextBox("Mag. Value", 0, 0, w-20);
        currentMagnetization.setValidationType("Integer");
        
        duration = new TextBox("Duration", 0, 0, w-20);
        duration.setValidationType("Integer");
        
        saveButton = new Button("Save", "Saves the changes made on the magnetization", sprites.smallSaveIconWhite, 0, 0);
        cancelButton = new Button("Cancel", "Cancel the changes made in the current magnetization", sprites.cancelIconWhite, x+w-80, y+h-30);
        newButton = new Button("New", "Adds the configuration as a new magnetization", sprites.smallNewIconWhite, 0, 0);        
        clearButton = new Button("Clear", "Clear ALL texts in the boxes", sprites.smallDeleteIconWhite, 0, 0);
        
        dynMagPairs = new ListContainer("All Magnetizations", 0, 0, w, h);
        dynMagPairs.deleteEnabled = true;
        dynMagPairs.editEnabled = true;
    }
        
    void drawSelf(){
        textSize(fontSz+5);
        fill(panelColor);
        stroke(panelColor);
        rect(x, y, w, h, 0, 15, 0, 0);
        fill(textColor);
        noStroke();
        float aux = textAscent()+textDescent(), auxY;
        String txt = "Dyn Mag Panel";
        auxY = y;
        text(txt, x+(w-textWidth(txt))/2, auxY+aux);
        auxY += aux+10;
        textSize(fontSz);
        aux = textAscent()+textDescent();
        text("Magnetizations", x+10, auxY+aux);
        auxY += aux+5;
        
        magName.updatePosition(x+10, auxY);
        auxY += aux+5;
        name.updatePosition(x+10, auxY);
        auxY += aux+5;
        currentMagnetization.updatePosition(x+10,auxY);
        auxY += aux+5;
        duration.updatePosition(x+10,auxY);
        auxY += aux+5;
        

        if(name.validateText()) {
            if(sp.getEngine().equals("LLG") && dynMagPairs.isIn(name.getText())){
                saveButton.isTransparent = (!validateAllFields());
                saveButton.setPosition(x+w-90,auxY);
                saveButton.drawSelf();
                newButton.isValid = false;
                saveButton.isValid = true;
            } else {
                newButton.isTransparent = (!validateAllFields());
                newButton.setPosition(x+w-30,auxY);
                newButton.drawSelf();
                newButton.isValid = true;
                saveButton.isValid = false;
            }
        } else {
            newButton.isTransparent = (!validateAllFields());
            newButton.setPosition(x+w-30,auxY);
            newButton.drawSelf();
            newButton.isValid = true;
            saveButton.isValid = false;
        }

        if(isEditing){
            saveButton.isTransparent = !(name.validateText() && currentMagnetization.validateText() && duration.validateText());
            saveButton.drawSelf();
            cancelButton.drawSelf();
        }
        if(!isEditing){
            newButton.isTransparent = !validateAllFields();
            newButton.drawSelf();
        }

        clearButton.setPosition(x+w-60,auxY);
        clearButton.drawSelf();
        clearButton.isValid = true;
        clearButton.isTransparent = true;
        auxY += 25;
        
        magName.drawSelf();
        name.drawSelf();
        currentMagnetization.drawSelf();
        duration.drawSelf();
        
        strokeWeight(4);
        stroke(color(255,255,255));
        line(x+10, auxY, x+w-10, auxY);
        auxY += 20;
        noStroke();
        strokeWeight(1);
        
        dynMagPairs.setPositionAndSize(x+10,auxY,w-20,h-(auxY-y)-150);
        dynMagPairs.drawSelf();
        
        auxY += h-(auxY-y)-150 + 5;
        
        strokeWeight(4);
        stroke(color(255,255,255));
        line(x+10, auxY, x+w-10, auxY);
        auxY += 10;
        noStroke();
        strokeWeight(1);
        
        fill(textColor);
        text("Magnetization Preview", x+10, auxY+fontSz);
        auxY += aux+5;

        float spaceLeft = (h-5-(auxY-y));
        preview = new Chart(x+10, auxY, w-20, spaceLeft);
        if(duration.validateText()) {
          if(currentMagnetization.validateText()){
              String [] initData = currentMagnetization.getText().split(",");
              String [] endData = currentMagnetization.getText().split(",");
              preview.addSeires("Magnetization",
                      new float[][]{
                          {0,Float.parseFloat(initData[0])},
                          {Float.parseFloat(duration.getText()),Float.parseFloat(endData[0])}
                          },
                      color(0,0,255));
          }
        }

        preview.drawSelf();
        onMouseOverMethod();
    }

    void setSubstrateGrid(SubstrateGrid sg){
        substrateGrid = sg;
    }

    void setEditing(String structure, String name){
        if(structure.contains(":") || structure.equals("")){
            isEditing = true;
            substrateGrid.isEditingMagnet = false;
            return;
        }
        //type;clockZone;magnetization;fixed;w;h;tc;bc;position;zoneColor;programmedMagnetization
        editingStructure = structure;
        String fields[] = structure.split(";");
        if (fields.length >= 12) {
          loadDynMagPairs(fields[11]);
        } else {
          this.currentMagnetization.setText("");
          this.duration.setText("");
        }
        this.magName.setText(name);
    }
    
    void reset(){
        magName.setText("");
        name.setText("");
        duration.setText("");
        currentMagnetization.setText("");
        dynMagPairs.clearList();
        dynMagValues.clear();
    }
    
    String getEngine(){
        return sp.getEngine();
    }
    
    void onMouseOverMethod(){
        if(isEditing){
            saveButton.onMouseOverMethod();
            cancelButton.onMouseOverMethod();
        }
        saveButton.onMouseOverMethod();
        newButton.onMouseOverMethod();
        clearButton.onMouseOverMethod();
    }
        
    void mouseDraggedMethod(){
      dynMagPairs.mouseDraggedMethod();
    }
    
    void mouseWheelMethod(float value){
      dynMagPairs.mouseDraggedMethod();
    }
    
    boolean validateAllFields(){
        boolean invalid = false | !name.validateText() | !duration.validateText() | !currentMagnetization.validateText();
        return !invalid;
    }

    boolean mousePressedMethod(){
        boolean hit = false;
        if(clearButton.mousePressedMethod()) {
            clearButton.deactivate();
            magName.resetText();
            name.resetText();
            duration.resetText();
            currentMagnetization.resetText();
        }
        if(!isEditing && newButton.mousePressedMethod()){
            newButton.deactivate();
            if(validateAllFields()){
              String value = currentMagnetization.getText() + "#" + duration.getText();
              dynMagValues.put(name.getText(), value);
              if(!dynMagPairs.isIn(name.getText()))
                  dynMagPairs.addItem(name.getText());
              if(this.substrateGrid != null) {
                Magnet currentMag = this.substrateGrid.getMagnet(this.magName.getText());
                if (currentMag != null) {
                  currentMag.addProgMag(currentMagnetization.getText(), duration.getText());
                }
              }
            }
            PopUp pop = new PopUp((width-150)/2,(height-50)/2, 150, 50, "Magnetization added!");
            pop.activate();
            pop.setAsTimer(50);
            popCenter.setPopUp(pop);
            return true;
        }
        if(!isEditing && saveButton.mousePressedMethod()){
            saveButton.deactivate();
            if(validateAllFields()){
                if(this.substrateGrid != null) {
                  Magnet currentMag = this.substrateGrid.getMagnet(this.magName.getText());
                  if (currentMag != null) {
                    currentMag.setProgrammedMagnetization(this.getDynMagValuesToSave());
                  }
                }
            }
            PopUp pop = new PopUp(((width-150)/2)*scaleFactor, ((height-50)/2)*scaleFactor, 150, 50, "Magnetization saved!");
            pop.activate();
            pop.setAsTimer(50);
            popCenter.setPopUp(pop);
            return true;
        }
        if(isEditing && cancelButton.mousePressedMethod()){
            cancelButton.deactivate();
            isEditing = false;
            substrateGrid.unselectMagnets();
            substrateGrid.isEditingMagnet = false;
            reset();
        }
        if(isEditing && saveButton.mousePressedMethod()){
            saveButton.deactivate();
            //type;clockZone;magnetization;fixed;w;h;tc;bc;position;zoneColor;programmedMagnetization
            if(validateAllFields()){
                if(this.substrateGrid != null) {
                  Magnet currentMag = this.substrateGrid.getMagnet(this.magName.getText());
                  if (currentMag != null) {
                    currentMag.setProgrammedMagnetization(this.getDynMagValuesToSave());
                  }
                }
            }
            substrateGrid.editSelectedMagnets(editingStructure, this.name.getText());
            substrateGrid.isEditingMagnet = false;
            isEditing = false;
            
            PopUp pop = new PopUp((width-250)/2, (height-50)/2, 250, 50, "Magnet modifications saved!");
            pop.activate();
            pop.setAsTimer(60);
            popCenter.setPopUp(pop);
        }
        if(dynMagPairs.mousePressedMethod()){
            String auxKey = dynMagPairs.getEditionField();
            name.setText(auxKey);
            if(auxKey != ""){
                String value = dynMagValues.get(auxKey);
                String [] parts = value.split("#");
                currentMagnetization.setText(parts[0]);
                duration.setText(parts[1]);
            }
        }
        hit = hit | name.mousePressedMethod();
        hit = hit | currentMagnetization.mousePressedMethod();
        hit = hit | duration.mousePressedMethod();
        return hit;
    }

    void keyPressedMethod(){
        if(name.keyPressedMethod() && (key == ENTER | key == TAB)){
            currentMagnetization.select();
            return;
        }
        if(currentMagnetization.keyPressedMethod() && (key == ENTER | key == TAB)){
            duration.select();
            return;
        }
        if(duration.keyPressedMethod() && (key == ENTER | key == TAB)){
            if (validateAllFields()) { 
              newButton.isValid = true;
              newButton.isTransparent = false;
            }
            return;
        }
    }

    void loadDynMagPairs(String programmedMagnetization) {
      if (programmedMagnetization == null || programmedMagnetization.length() == 0 || !programmedMagnetization.contains("#")) { return; }
      String pairs[] = programmedMagnetization.split(",");
      Integer i = 0;
      for (String p: pairs) {
        String name = "P" + i;
        dynMagValues.put(name, p);
        if(!dynMagPairs.isIn(name))
            dynMagPairs.addItem(name);
        i += 1;
      }
      String firstPair[] = pairs[0].split("#");
      this.currentMagnetization.setText(firstPair[0]);
      this.duration.setText(firstPair[1]);
    }

    ArrayList<String> getDynMagValuesToSave() {
      ArrayList<String> dynMagValuesToSave = new ArrayList<String>();
      for (String key: dynMagPairs.getItems()) {
        String val = dynMagValues.get(key);
        dynMagValuesToSave.add(val);
      }
      return dynMagValuesToSave;
    }
}
