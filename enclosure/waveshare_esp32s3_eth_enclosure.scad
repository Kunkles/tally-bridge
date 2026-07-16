// =====================================================================
// Waveshare ESP32-S3-ETH two-piece printable enclosure
// + PC817 optocoupler module  + round Ethernet-style panel module
// + honeycomb vents  + M3 brass heat-set inserts
// Native OpenSCAD only. Units = millimeters.
// =====================================================================

// ---------------------------------------------------------------------
// 1. GLOBAL PARAMETERS
// ---------------------------------------------------------------------

// ----- render / display -----
render_part      = "both";   // "base", "lid", or "both"
show_placeholders = true;    // visual modules only, never part of print
$fn = 48;

// ----- enclosure shell -----
wall          = 2.4;
floor_th      = 2.4;
lid_th        = 2.4;
corner_r      = 4;
lid_clearance = 0.35;
wire_clearance = 8;

lip_h    = 4;     // lid locating-lip depth
lip_wall = 1.6;   // lid locating-lip thickness

// ----- ESP32-S3-ETH board (STL-derived footprint) -----
esp32_len            = 72.8; // PCB length per Waveshare drawing (RJ45 overhangs ~2.8 mm more)
esp32_w              = 21;
esp32_h              = 18;    // adjustable, excludes PoE module
esp32_pcb_thickness  = 1.6;

include_poe_clearance = false;
poe_clearance_h       = 24.5;  // only used if include_poe_clearance

// ----- internal cavity -----
// Length defaults to hug the board so the front connector edge (USB-C + RJ45,
// both on the same end) sits near the front wall. Set flush_fit_length
// = false to use the 92 mm starting dimension instead.
// USB-C *and* RJ45 are BOTH on the front board end (stacked) -- only the front
// edge must sit near its wall; the rear end is the free GPIO-header side.
flush_fit_length    = true;
internal_len_manual = 92;
esp32_front_clear   = 0.5;   // front wall inner face -> board connector edge
esp32_rear_clear    = 4.0;   // GPIO-header end -> rear wall (wiring clearance)
internal_len = flush_fit_length
    ? (esp32_front_clear + esp32_len + esp32_rear_clear)
    : internal_len_manual;

// Width raised from the 72 mm start to 80 mm so the 29 mm-deep panel
// module body + board + PC817 + wire clearance all fit side by side.
internal_w = 80;
internal_h = 36;

// ----- derived outer shell -----
outer_len = internal_len + 2*wall;
outer_w   = internal_w   + 2*wall;
base_h    = floor_th + internal_h;   // open-top base height

// ----- ESP32 placement & standoffs -----
esp32_standoff_h = 5;
esp32_standoff_d = 6;
// Board mounting holes measured at 1.66 mm -- far too small for screws into
// printed pilots. Standoffs carry short locating PINS instead; the board is
// registered by the pins and captured by the RJ45/USB-C wall openings.
esp32_hole_d = 1.66;                    // actual board hole (reference)
esp32_pin_d  = esp32_hole_d - 0.16;     // 1.5 -- slip fit, tune after test print
esp32_pin_h  = 2.4;                     // proud of the 1.6 mm PCB by ~0.8 mm

esp32_x = wall + esp32_front_clear;     // board min-X (USB-C edge near front)
esp32_y = wall + 35;                    // board min-Y (clears panel body + wiring)
esp32_z = floor_th + esp32_standoff_h;  // PCB underside Z

// Mounting-hole pattern per the official Waveshare dimension drawing
// (ESP32-S3-ETH-details-size.jpg): pairs are NOT symmetric. The rear pair
// sits right at the rear corners, and the two pairs differ in width spacing.
// front/rear = distance of each pair from the FRONT (Ethernet) PCB edge.
esp32_hole_dx_front = 17.78;                // front pair width spacing (c-t-c)
esp32_hole_dx_rear  = 18.25;                // rear pair width spacing (c-t-c)
esp32_hole_front    = 17.07;                // = 72.8 - 54.15 - 1.58
esp32_hole_rear     = esp32_len - 1.58;     // 71.22 -- at the rear corners

// ----- connector stack: BOTH on the FRONT short wall (per case-mini.stl) -----
// The ESP32-S3-ETH carries USB-C + RJ45 on the SAME board end, stacked: RJ45
// low, USB-C ~2.7 mm above it. Opening centres are referenced to the PCB top
// surface so they track standoff height. Sizes/heights measured from the STL.
connector_setback = 0.3;     // tune board fore/aft after test fit

// Vertical stack on the front wall (top -> bottom): RJ45, PCB, USB-C.
// RJ45 sits on TOP of the PCB; USB-C is on the BOTTOM face (hangs below it).
pcb_top_z    = esp32_z + esp32_pcb_thickness; // top surface of the PCB
pcb_bottom_z = esp32_z;                        // bottom surface of the PCB
rj45_center_above_pcb = 6.9;   // RJ45 opening centre above PCB top
usbc_center_below_pcb = 1.6;   // USB-C opening centre below PCB bottom

// USB-C opening (LOWER -- on the underside of the board)
usb_c_cutout_w         = 9.5;   // along board width (Y)
usb_c_cutout_h         = 3.2;   // vertical (Z)
usb_c_cutout_clearance = 0.4;
usb_c_cutout_x_offset  = 0;     // lateral nudge along wall (Y)
usb_c_cutout_z         = pcb_bottom_z - usbc_center_below_pcb;
usb_c_relief_w         = 14;
usb_c_relief_h         = 4.5;
usb_c_relief_enabled   = true;
usb_c_relief_depth     = 1.2;

// RJ45 opening (UPPER -- onboard Ethernet jack, SAME wall, above the board)
rj45_cutout_w         = 16.2;
rj45_cutout_h         = 12.6;
rj45_cutout_clearance = 0.6;
rj45_cutout_x_offset  = 0;
rj45_cutout_z         = pcb_top_z + rj45_center_above_pcb;
rj45_relief_w         = 20;
rj45_relief_h         = 13.8;
rj45_relief_enabled   = true;
rj45_relief_depth     = 1.5;

// ----- PC817 optocoupler module -----
pc817_len             = 40;
pc817_w               = 15;
pc817_pcb_thickness   = 1.6;
pc817_component_h     = 12;
pc817_mount_hole_d    = 3.0;
pc817_standoff_h      = 4;
pc817_standoff_d      = 6;
pc817_standoff_hole_d = 2.6;
pc817_x = wall + (internal_len - pc817_len)/2;   // centered along length
pc817_y = wall + internal_w - pc817_w - 2;       // along the right long wall
pc817_z = floor_th + pc817_standoff_h;

// The real bestep PC817 board carries its two mounting holes on a DIAGONAL,
// offset toward opposite long edges -- NOT on the centerline. Each entry is
// [along board length, across board width] measured from the (pc817_x,pc817_y)
// corner. Render with show_placeholders=true: the standoffs must appear
// directly under the holes punched in the board. MEASURE YOUR BOARD and tune.
pc817_hole1 = [14, 11];   // upper hole, toward one long edge
pc817_hole2 = [26, 4];    // lower hole, toward the other long edge

// ----- round Ethernet-style panel module (separate from onboard RJ45) -----
panel_module_enabled = true;
panel_side = "left";   // "left", "right", "front", or "back"

panel_cutout_d       = 24;
panel_screw_hole_d   = 3.4;
panel_screw_spacing_x = 19;
panel_screw_spacing_y = 23.5;   // vertical pitch per right-hand factory drawing

panel_face_w      = 26;
panel_face_h      = 32;
panel_inner_rect_w = 14.4;
panel_inner_rect_h = 16.2;

panel_depth_total = 31.5;
panel_body_depth  = 29;
panel_body_h      = 23.4;

panel_face_th      = 3;
panel_side_ref_total = 9.1;
panel_rear_ref_th  = 4.7;
panel_rear_block_h = 12;

panel_pos_along = (panel_side=="left" || panel_side=="right")
    ? wall + internal_len*0.62      // X position when on a long wall
    : wall + internal_w*0.5;        // Y position when on a short wall
panel_z = floor_th + internal_h*0.5;

// Screw pattern as seen FROM OUTSIDE the wall: [horizontal, vertical] offset
// from the bore centre, with right = + and up = +. Diagonal pair at 19 mm
// horizontal x 23.5 mm vertical. Swap the signs on a row to flip the diagonal.
panel_screw_holes = [
    [ panel_screw_spacing_x/2,  panel_screw_spacing_y/2],   // upper-right (outside view)
    [-panel_screw_spacing_x/2, -panel_screw_spacing_y/2]    // lower-left  (outside view)
];

// ----- M3 brass heat-set inserts (Ruthex M3 x 5.7) -----
insert_len        = 5.7;
insert_outer_d    = 4.6;
insert_hole_d     = 4.0;
insert_hole_depth = 5.8;
insert_min_wall   = 1.6;

boss_d     = 8;
boss_inset = boss_d/2 - 1.5;   // pull bosses into corners so they fuse to walls

screw_clear_d        = 3.2;
screw_head_d         = 6.2;
screw_head_depth     = 1.5;
screw_head_recess_enabled = true;

// ----- honeycomb vents -----
honeycomb_enabled      = true;
honeycomb_lid_enabled  = true;
honeycomb_side_enabled = true;   // applied only to the right long wall (no panel/connectors)
honeycomb_radius  = 3;
honeycomb_spacing = 8;
honeycomb_margin  = 10;

// ---------------------------------------------------------------------
// Derived placement vectors
// ---------------------------------------------------------------------
boss_positions = [
    [wall + boss_inset,             wall + boss_inset],
    [outer_len - wall - boss_inset, wall + boss_inset],
    [wall + boss_inset,             outer_w - wall - boss_inset],
    [outer_len - wall - boss_inset, outer_w - wall - boss_inset]
];

esp32_standoff_positions = [
    [esp32_x + esp32_hole_front, esp32_y + esp32_w/2 - esp32_hole_dx_front/2],
    [esp32_x + esp32_hole_front, esp32_y + esp32_w/2 + esp32_hole_dx_front/2],
    [esp32_x + esp32_hole_rear,  esp32_y + esp32_w/2 - esp32_hole_dx_rear/2],
    [esp32_x + esp32_hole_rear,  esp32_y + esp32_w/2 + esp32_hole_dx_rear/2]
];

pc817_standoff_positions = [
    [pc817_x + pc817_hole1[0], pc817_y + pc817_hole1[1]],
    [pc817_x + pc817_hole2[0], pc817_y + pc817_hole2[1]]
];

// ---------------------------------------------------------------------
// 2. UTILITY MODULES
// ---------------------------------------------------------------------

module rounded_rect_2d(w, h, r){
    offset(r=r) square([w - 2*r, h - 2*r], center=true);
}

module rounded_box(size, r){
    // centered in XY, extruded 0..size[2]
    linear_extrude(height=size[2]) rounded_rect_2d(size[0], size[1], r);
}

module heatset_insert_hole(d, depth){
    cylinder(d=d, h=depth);
}

module screw_boss(pos, boss_d, boss_h, hole_d, hole_depth){
    translate(pos)
        difference(){
            cylinder(d=boss_d, h=boss_h);
            translate([0, 0, boss_h - hole_depth])
                heatset_insert_hole(hole_d, hole_depth + 0.1);
        }
}

module mounting_standoff(pos, standoff_d, standoff_h, hole_d){
    translate(pos)
        difference(){
            cylinder(d=standoff_d, h=standoff_h);
            translate([0, 0, 1]) cylinder(d=hole_d, h=standoff_h);  // pilot, leaves 1 mm base
        }
}

module pin_standoff(pos, standoff_d, standoff_h, pin_d, pin_h){
    // solid standoff with a locating pin on top -- for boards whose mounting
    // holes are too small for screws into printed pilots
    translate(pos){
        cylinder(d=standoff_d, h=standoff_h);
        translate([0, 0, standoff_h]) cylinder(d=pin_d, h=pin_h, $fn=24);
    }
}

module honeycomb_panel_2d(width, height, radius, spacing, margin){
    dx = spacing;
    dy = spacing * 0.86602540;          // sqrt(3)/2
    nx = floor((width  - 2*margin) / dx) + 1;
    ny = floor((height - 2*margin) / dy) + 1;
    intersection(){
        square([width - 2*margin, height - 2*margin], center=true);
        union(){
            for(j = [-ny : ny])
                for(i = [-nx : nx]){
                    xo = (j % 2 == 0) ? 0 : dx/2;
                    translate([i*dx + xo, j*dy])
                        rotate(30) circle(r=radius, $fn=6);   // true hexagon
                }
        }
    }
}

module honeycomb_cut_lid(){
    if(honeycomb_enabled && honeycomb_lid_enabled)
        translate([outer_len/2, outer_w/2, base_h - 0.1])
            linear_extrude(height=lid_th + 0.2)
                honeycomb_panel_2d(internal_len, internal_w,
                                   honeycomb_radius, honeycomb_spacing, honeycomb_margin);
}

module honeycomb_cut_side(){
    // right long wall only (free of panel and connectors)
    if(honeycomb_enabled && honeycomb_side_enabled)
        translate([outer_len/2, outer_w + 1, floor_th + internal_h/2])
            rotate([90, 0, 0])
                linear_extrude(height=wall + 2)
                    honeycomb_panel_2d(internal_len, internal_h,
                                       honeycomb_radius, honeycomb_spacing, honeycomb_margin);
}

module usb_c_cutout(){
    cy = esp32_y + esp32_w/2 + usb_c_cutout_x_offset;
    cz = usb_c_cutout_z;
    w  = usb_c_cutout_w + 2*usb_c_cutout_clearance;
    h  = usb_c_cutout_h + 2*usb_c_cutout_clearance;
    union(){
        // through the front wall only (X = -1 .. wall+2): direct plug, no tunnel
        translate([-1, cy - w/2, cz - h/2]) cube([wall + 3, w, h]);
        if(usb_c_relief_enabled)
            translate([-0.5, cy - usb_c_relief_w/2, cz - usb_c_relief_h/2])
                cube([usb_c_relief_depth + 0.5, usb_c_relief_w, usb_c_relief_h]);
    }
}

module onboard_rj45_cutout(){
    cy = esp32_y + esp32_w/2 + rj45_cutout_x_offset;
    cz = rj45_cutout_z;
    w  = rj45_cutout_w + 2*rj45_cutout_clearance;
    h  = rj45_cutout_h + 2*rj45_cutout_clearance;
    union(){
        // through the FRONT wall, stacked below USB-C: direct plug, clip clears
        translate([-1, cy - w/2, cz - h/2]) cube([wall + 3, w, h]);
        if(rj45_relief_enabled)
            translate([-0.5, cy - rj45_relief_w/2, cz - rj45_relief_h/2])
                cube([rj45_relief_depth + 0.5, rj45_relief_w, rj45_relief_h]);
    }
}

// places children in a local frame on the selected wall:
//   local +Z = inward normal, local origin = wall outer face
module panel_place(){
    if(panel_side == "left")
        translate([panel_pos_along, 0, panel_z])         rotate([-90, 0, 0]) children();
    else if(panel_side == "right")
        translate([panel_pos_along, outer_w, panel_z])   rotate([90, 0, 0])  children();
    else if(panel_side == "front")
        translate([0, panel_pos_along, panel_z])         rotate([0, 90, 0])  children();
    else if(panel_side == "back")
        translate([outer_len, panel_pos_along, panel_z]) rotate([0, -90, 0]) children();
}

// through-wall hole on the selected wall, positioned by an OUTSIDE-view
// offset: h = horizontal (right +), v = vertical (up +) from the panel centre.
// This keeps the diagonal screw pattern un-mirrored on every wall.
module panel_wall_hole(h, v, dia){
    if(panel_side == "left")
        translate([panel_pos_along - h, -1, panel_z + v]) rotate([-90, 0, 0])
            cylinder(d=dia, h=wall + 2);
    else if(panel_side == "right")
        translate([panel_pos_along + h, outer_w + 1, panel_z + v]) rotate([90, 0, 0])
            cylinder(d=dia, h=wall + 2);
    else if(panel_side == "front")
        translate([-1, panel_pos_along + h, panel_z + v]) rotate([0, 90, 0])
            cylinder(d=dia, h=wall + 2);
    else if(panel_side == "back")
        translate([outer_len + 1, panel_pos_along - h, panel_z + v]) rotate([0, -90, 0])
            cylinder(d=dia, h=wall + 2);
}

module round_panel_module_cutout(){
    if(panel_module_enabled){
        panel_wall_hole(0, 0, panel_cutout_d);                // central bore
        for(s = panel_screw_holes)
            panel_wall_hole(s[0], s[1], panel_screw_hole_d);  // diagonal screws
    }
}

// ---------------------------------------------------------------------
// 3. PLACEHOLDER MODULES (visual only)
// ---------------------------------------------------------------------

module esp32_board_placeholder(){
    cy = esp32_y + esp32_w/2;
    // PCB
    color("#1f7a1f")
        translate([esp32_x, esp32_y, esp32_z]) cube([esp32_len, esp32_w, esp32_pcb_thickness]);
    // generic components blob (kept clear of the front connector zone)
    color("#333333")
        translate([esp32_x + 20, esp32_y + 3, esp32_z + esp32_pcb_thickness])
            cube([esp32_len - 40, esp32_w - 6, 4]);
    // GPIO header along the rear (free) end
    color("#222222")
        translate([esp32_x + esp32_len - 8, esp32_y + 1, esp32_z + esp32_pcb_thickness])
            cube([6, esp32_w - 2, 6]);
    // USB-C (LOWER of the front stack): on the board underside, hangs below the
    // PCB and overhangs the front edge so its face reaches the front wall opening.
    color("#bbbbbb")
        translate([esp32_x - 2, cy - usb_c_cutout_w/2, usb_c_cutout_z - usb_c_cutout_h/2])
            cube([6, usb_c_cutout_w, usb_c_cutout_h]);
    if(include_poe_clearance)
        %translate([esp32_x + 10, esp32_y, esp32_z + esp32_pcb_thickness])
            cube([40, esp32_w, poe_clearance_h]);
}

module onboard_rj45_placeholder(){
    cy = esp32_y + esp32_w/2;
    // onboard RJ45 jack (LOWER of the front stack): sits on the PCB at the front
    // board end, body projecting back into the enclosure.
    color("#9a9a9a")
        translate([esp32_x - 2, cy - rj45_cutout_w/2, rj45_cutout_z - rj45_cutout_h/2])
            cube([16, rj45_cutout_w, rj45_cutout_h]);
}

module pc817_module_placeholder(){
    // PCB with its real (diagonal) mounting holes punched -> the base standoffs
    // should sit directly under these when show_placeholders = true.
    color("#2b5fa8")
        difference(){
            translate([pc817_x, pc817_y, pc817_z - 0.01])
                cube([pc817_len, pc817_w, pc817_pcb_thickness + 0.02]);
            for(p = pc817_standoff_positions)
                translate([p[0], p[1], pc817_z - 1])
                    cylinder(d=pc817_mount_hole_d, h=pc817_pcb_thickness + 2);
        }
    color("#111111")
        translate([pc817_x + 6, pc817_y + 2, pc817_z + pc817_pcb_thickness])
            cube([12, pc817_w - 4, pc817_component_h]);
    // screw-terminal block at one end
    color("#1f6f1f")
        translate([pc817_x + pc817_len - 9, pc817_y + 1, pc817_z + pc817_pcb_thickness])
            cube([8, pc817_w - 2, 9]);
}

module round_panel_module_placeholder(){
    if(panel_module_enabled)
        panel_place(){
            // front plate (outside the wall)
            color("#777777")
                translate([0, 0, -panel_face_th])
                    linear_extrude(height=panel_face_th)
                        offset(r=2) square([panel_face_w - 4, panel_face_h - 4], center=true);
            // body projecting into the enclosure
            color("#555555") cylinder(d=panel_cutout_d - 0.6, h=panel_body_depth);
            // rear block
            color("#555555")
                translate([0, 0, panel_body_depth - 2])
                    cylinder(d=panel_cutout_d - 4, h=2);
        }
}

module placeholders(){
    esp32_board_placeholder();
    onboard_rj45_placeholder();
    pc817_module_placeholder();
    round_panel_module_placeholder();
    // approximate wire-clearance zone off the PC817 terminals (preview only)
    %translate([pc817_x + pc817_len, pc817_y - 1, floor_th])
        cube([wire_clearance, pc817_w + 2, 14]);
}

// ---------------------------------------------------------------------
// 4. MAIN PRINTABLE MODULES
// ---------------------------------------------------------------------

module enclosure_base(){
    difference(){
        // outer shell
        translate([outer_len/2, outer_w/2, 0])
            rounded_box([outer_len, outer_w, base_h], corner_r);
        // hollow interior (open top)
        translate([outer_len/2, outer_w/2, floor_th])
            rounded_box([internal_len, internal_w, internal_h + 10], max(0.8, corner_r - wall));
        // direct-access connector cutouts
        usb_c_cutout();
        onboard_rj45_cutout();
        // round panel module opening + its screw holes
        round_panel_module_cutout();
        // optional side vents
        honeycomb_cut_side();
    }
    // internal solids added AFTER the cavity so they are not carved away
    for(p = boss_positions)
        screw_boss([p[0], p[1], floor_th], boss_d, internal_h, insert_hole_d, insert_hole_depth);
    for(p = esp32_standoff_positions)
        pin_standoff([p[0], p[1], floor_th], esp32_standoff_d, esp32_standoff_h, esp32_pin_d, esp32_pin_h);
    for(p = pc817_standoff_positions)
        mounting_standoff([p[0], p[1], floor_th], pc817_standoff_d, pc817_standoff_h, pc817_standoff_hole_d);
}

module lid_lip(){
    difference(){
        translate([outer_len/2, outer_w/2, base_h - lip_h])
            linear_extrude(height=lip_h)
                difference(){
                    rounded_rect_2d(internal_len - 2*lid_clearance,
                                    internal_w   - 2*lid_clearance,
                                    max(0.6, corner_r - wall));
                    rounded_rect_2d(internal_len - 2*lid_clearance - 2*lip_wall,
                                    internal_w   - 2*lid_clearance - 2*lip_wall,
                                    max(0.4, corner_r - wall - lip_wall));
                }
        // notch the lip clear of the corner bosses
        for(p = boss_positions)
            translate([p[0], p[1], base_h - lip_h - 0.5])
                cylinder(d=boss_d + 2*lid_clearance + 1.0, h=lip_h + 1);
    }
}

module enclosure_lid(){
    difference(){
        union(){
            translate([outer_len/2, outer_w/2, base_h])
                rounded_box([outer_len, outer_w, lid_th], corner_r);
            lid_lip();
        }
        // M3 screw clearance holes + optional head recesses
        for(p = boss_positions){
            translate([p[0], p[1], base_h - 0.5]) cylinder(d=screw_clear_d, h=lid_th + 1);
            if(screw_head_recess_enabled)
                translate([p[0], p[1], base_h + lid_th - screw_head_depth])
                    cylinder(d=screw_head_d, h=screw_head_depth + 0.5);
        }
        // honeycomb vent pattern
        honeycomb_cut_lid();
    }
}

// ---------------------------------------------------------------------
// 5. RENDER SELECTOR
// ---------------------------------------------------------------------
if(render_part == "base"){
    enclosure_base();
    if(show_placeholders) placeholders();
}
else if(render_part == "lid"){
    enclosure_lid();
}
else if(render_part == "both"){
    enclosure_base();
    if(show_placeholders) placeholders();
    translate([outer_len + 20, 0, 0]) enclosure_lid();
}
