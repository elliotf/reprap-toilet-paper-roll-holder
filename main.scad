resolution = 36;
resolution = 72;

roll_inner = 40;
roll_outer = 130;
roll_len = 125;

retainer_rim_height = 5;
retainer_rim_thickness = 5;
retainer_rim_edge_thickness = 2;
wall_clearance = 10;

tube_support_diam = roll_inner - retainer_rim_height*2;

left = -1;
right = 1;

inside = -1;
outside = 1;

arm_side      = right;
arm_angle     = 20;
arm_thickness = 10;

arm_pos_x = (roll_len/2+arm_thickness/2)*arm_side;
retainer_pos_x = (roll_len/2+retainer_rim_thickness/2)*arm_side*-1;

mount_plate_screw_spacing = 28.5;
mount_plate_screw_diam = 8;
mount_plate_screw_head_diam = 12;
mount_plate_height = 60;
mount_plate_width = mount_plate_screw_spacing+mount_plate_screw_head_diam;
mount_plate_thickness = 10;

mount_plate_pos_z = tube_support_diam/2-mount_plate_height/2;
dist_from_wall = roll_outer/2 + wall_clearance + mount_plate_thickness;

module roll_holder() {
  rotate([0,90,0])
    cylinder(r=tube_support_diam/2,h=roll_len,center=true,$fn=resolution);

  translate([retainer_pos_x,0,0]) {
    rotate([0,90,0])
      hull() {
        cylinder(r=tube_support_diam/2,h=retainer_rim_thickness,center=true,$fn=resolution);
        translate([0,0,(retainer_rim_thickness/2-retainer_rim_edge_thickness/2)*arm_side])
          cylinder(r=roll_inner/2,h=retainer_rim_edge_thickness,center=true,$fn=resolution);
      }
  }

  translate([arm_pos_x,0,0]) {
    support_arm();
  }
}

module support_arm() {
  module body() {
    hull() {
      rotate([0,90,0])
        cylinder(r=tube_support_diam/2,h=arm_thickness,center=true,$fn=resolution);

      translate([0,dist_from_wall,mount_plate_pos_z]) {
        cube([arm_thickness,mount_plate_thickness,mount_plate_height],center=true);
      }
    }

    hull() {
      translate([0,dist_from_wall,mount_plate_pos_z+2]) {
        cube([arm_thickness,mount_plate_thickness,mount_plate_height-4],center=true);
      }

      for(side=[left,right]) {
        translate([mount_plate_screw_spacing/2*side,dist_from_wall,mount_plate_pos_z]) {
            rotate([90,0,0]) rotate([0,0,22.5])
              cylinder(r=mount_plate_screw_head_diam/2+5,h=mount_plate_thickness,center=true);
        }
      }
    }
  }

  module holes() {
    for(side=[left,right]) {
      translate([mount_plate_screw_spacing/2*side,dist_from_wall,mount_plate_pos_z]) rotate([90,0,0]) rotate([0,0,22.5])
        cylinder(r=mount_plate_screw_diam/2,h=mount_plate_thickness+1,center=true,$fn=8);
    }
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  difference() {
    rotate([arm_angle,0,0]) roll_holder();
    translate([0,0,-60]) cube([roll_len*3,dist_from_wall*3,100],center=true);
  }
}

//rotate([-arm_angle,0,0])
  assembly();
