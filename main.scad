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
tube_support_len = roll_len + 5;

left = -1;
right = 1;

inside = -1;
outside = 1;

arm_side      = left;
arm_side      = right;
arm_angle     = 20;
arm_thickness = 10;

arm_pos_x = (tube_support_len/2+arm_thickness/2)*arm_side;
retainer_pos_x = (tube_support_len/2+retainer_rim_thickness/2)*arm_side*-1;

mount_plate_screw_spacing = 28.5;
mount_plate_screw_diam = 4.75;
mount_plate_screw_head_diam = 8;
mount_plate_screw_area_diam = 24;
mount_plate_screw_area_thickness = 3.5;
mount_plate_height = 60;
mount_plate_width = mount_plate_screw_spacing+mount_plate_screw_area_diam;
mount_plate_thickness = 10;

mount_plate_pos_z = tube_support_diam/2-mount_plate_height/2;
dist_from_wall = roll_outer/2 + wall_clearance + mount_plate_thickness;

module accurate_hole(diam, height, sides=8) {
  r = 1 / cos(180/sides) / 2 * diam;

  cylinder(r=r,h=height,center=true,$fn=sides);
}

module roll_holder() {
  rotate([0,90,0])
    accurate_hole(tube_support_diam,tube_support_len,resolution);

  translate([retainer_pos_x,0,0]) {
    rotate([0,90,0])
      hull() {
        accurate_hole(tube_support_diam,retainer_rim_thickness,resolution);

        translate([0,0,(retainer_rim_thickness/2-retainer_rim_edge_thickness/2)*arm_side])
          accurate_hole(roll_inner,retainer_rim_edge_thickness,resolution);
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
        accurate_hole(tube_support_diam,arm_thickness,resolution);

      translate([0,dist_from_wall,mount_plate_pos_z]) {
        cube([arm_thickness,mount_plate_thickness,mount_plate_height],center=true);
      }
    }

    hull() {
      translate([0,dist_from_wall,mount_plate_pos_z+2.5]) {
        cube([arm_thickness,mount_plate_thickness,mount_plate_height-5],center=true);
      }

      for(side=[left,right]) {
        translate([mount_plate_screw_spacing/2*side,dist_from_wall,mount_plate_pos_z]) {
          rotate([90,0,0]) rotate([0,0,22.5])
            accurate_hole(mount_plate_screw_area_diam,mount_plate_thickness,resolution);
        }
      }
    }
  }

  module holes() {
    for(side=[left,right]) {
      translate([mount_plate_screw_spacing/2*side,dist_from_wall,mount_plate_pos_z]) rotate([-90,0,0]) rotate([0,0,22.5]) {
        accurate_hole(mount_plate_screw_diam,mount_plate_thickness+1,8);

        translate([0,0,-mount_plate_thickness/2])
          accurate_hole(mount_plate_screw_head_diam,(mount_plate_thickness-mount_plate_screw_area_thickness)*2,8);
      }
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
    translate([0,0,-60]) cube([tube_support_len*3,dist_from_wall*3,100],center=true);
  }

  % rotate([0,90,0])
    cylinder(r=roll_outer/2,h=roll_len,center=true,$fn=36);
}

//rotate([-arm_angle,0,0])
  assembly();
