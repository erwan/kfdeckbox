
//For a normal deck [37]; for 2 decks [37, 37], etc
compartiments = [37];
//Thickness of the walls
wall = 2; // [3, 4, 5, 6, 7, 8]
//Wether you want a window or not (0 for no, 1 for yes)
window = 1; // [0, 1] 

// First line of text (deck name)
text1 = "Sir \"Green\" Svenson";
// Second line of text (optional)
text2 = "";
//The size of this text (adjust according to the deck name length)
textsize = 4.5;
//Check if you double sleeve the cards
doubleSleeved = false;

cardW = 67.5;
cardH = 93.4;
//Card thickness. (standard dragon shield MTG sleeve with card)
cardT = doubleSleeved ? 0.71 : 0.61;

// Adjust the window showing the house logos
windowPosition = 20;

flexibleClips = true;

deckbox(compartiments, wall, window == 1, true, text1, size1, text2, size2);

module window() {
    // left house
    translate([(cardW + wall * 2) / 2 - 20, -1, windowPosition + 4])
      rotate([-90, 0, 0])
        cylinder(h = wall * 2, d = 20);
    
    // middle house
    translate([(cardW + wall * 2) / 2, -1, windowPosition]) rotate([-90, 0, 0]) cylinder(h = wall * 2, d = 20);
    
        // right house
    translate([(cardW + wall * 2) / 2 + 20, -1, windowPosition + 4]) rotate([-90, 0, 0]) cylinder(h = wall * 2, d = 20);
}


module deckbox(
  compartiments = [60],
  wall = 4,
  window = true,
  lid = true,
  text1 = "",
  size1 = 7,
  text2 = "",
  size2 = 5){
  // HANDS OFF!!!
  tolerance = 1;
  nComps = len(compartiments);
  $fn = 72;
  sizes = compartiments * cardT;
  totalDepth = sum(sizes) + wall * nComps + wall + tolerance * nComps;
  innerDepth = totalDepth - wall * 2;

  echo("=============================");
  echo(str("                TOTAL DEPTH: ", totalDepth, "mm          "));
  echo("=============================");


  difference(){
    union(){
      translate([wall, wall, 0])
      minkowski(){
        cube([cardW, innerDepth, cardH + wall - 1]);
        cylinder(r = wall, h = 1);
      }

      if(lid){
        difference(){
          translate([wall, wall, wall + cardH])
          minkowski(){
            cube([cardW, innerDepth, wall - 1]);
            cylinder(r = wall, h = 1);
          }

          difference(){
            translate([wall, -1, wall + cardH])
            cube([cardW, totalDepth + 2, wall * 1 + 1]);

            translate([wall * 0.83, wall / 2, cardH + wall * 1.5])
            sphere(r = wall / 3);

            translate([cardW + wall * 1.17, wall / 2, cardH + wall * 1.5])
            sphere(r = wall / 3);

          }

          translate([wall / 2, wall, wall + cardH])
          rotate([0, 27, 0])
          cube([wall, totalDepth + 2, wall * 2]);


          translate([cardW + wall * 1.5, totalDepth + wall, wall + cardH])
          rotate([0, 27, 180])
          cube([wall, totalDepth, wall * 2]);
        }
      }
    }
    translate([cardW / 2 + wall, -1, cardH + wall])
    rotate([-90, 0, 0])
    cylinder(h = totalDepth + 2, d = 20);

    for(i = [0 : (nComps - 1)]){
      translate([wall, sum(sizes, 0, i) + (i * wall) + wall + i * tolerance, wall])
      cube([cardW, sizes[i] + tolerance, cardH + 1]);
    }

    // Keyforge logo
    translate([(cardW + wall * 2) / 2 - 25, 1, 55])
       resize([50, 2, 25])
     rotate([90, 0, 0])
       linear_extrude(height = 2)
         import (file = "keyforge.dxf");

    if(window){
        window();
    }    
}

  if(lid){
    margin = 0.2;
    translate([cardW + wall * 2 + 5, 0, 0])
    //translate([wall / 2 + 0.25, 0, cardH + wall]) //  <-- Lid in place. Don't print this way
    difference(){
      translate([wall / 2, wall, 0])
      minkowski(){
        cube([cardW - margin, innerDepth, wall - 1 - margin]);
        cylinder(r = wall, h = 1);
      }

      cube([wall / 2, wall, wall]);

      translate([wall * 0.5, wall / 2, wall / 2])
      sphere(r = wall / 3);

      translate([-wall - 0.4, 0, 0])
      rotate([0, 27, 0])
      cube([wall, totalDepth, wall * 2]);

      translate([cardW + wall / 2 - margin, 0, 0])
      cube([wall / 2, wall, wall]);

      translate([cardW + wall * 0.5 - margin, wall / 2, wall / 2])
      sphere(r = wall / 3);

      translate([cardW + wall * 2 + 0.4 - margin, totalDepth, 0])
      rotate([0, 27, 180])
      cube([wall, totalDepth, wall * 2]);

     if (text2 == "") {
         // Deck name is 1 line
         translate([(cardW + wall - margin) / 2, (totalDepth) / 2, wall - 1])
      linear_extrude(height = 1.3){
        text(text1, halign = "center", valign = "center", size = textsize, font="Arial:style=Bold");
      }

     } else {
        // Deck name is 2 lines
      translate([(cardW + wall - margin) / 2, (totalDepth) / 2+5, wall - 1])
      linear_extrude(height = 1.3){
        text(text1, halign = "center", valign = "center", size = textsize, font="Arial:style=Bold");
      }

      translate([(cardW + wall - margin) / 2, (totalDepth) / 2 - textsize, wall - 1])
      linear_extrude(height = 1.3){
        text(text2, halign = "center", valign = "center", size = textsize, font="Arial:style=Bold");
      }
      }
        
      if(flexibleClips){
          translate([wall, 0, 0])
          cube([1, 8, wall + 1]);
          
          translate([cardW - margin - 1, 0, 0])
          cube([1, 8, wall + 1]);
      }
    
    }
  }
}

function sum(array, from = 0, to = 2000000000) = (from < to  && from < len(array) ? array[from] + sum(array, from + 1, to) : 0);
