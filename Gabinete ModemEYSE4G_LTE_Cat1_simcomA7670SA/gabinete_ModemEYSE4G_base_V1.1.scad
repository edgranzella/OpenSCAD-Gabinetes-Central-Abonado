// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - BASE V1
// (REESTRUCTURACION: inversion de componentes)
//
// Origen de este archivo: gabinete_ModemEYSE4G_tapa_7.scad (la tapa
// plana original). En el nuevo esquema de 2 piezas, este archivo pasa
// a ser la pieza INFERIOR (plato plano con parantes de sujecion del
// PCB) y la cubierta con paredes (antes la "base") pasa al archivo
// gabinete_ModemEYSE4G_tapa_V1.scad, ver ese archivo para el detalle
// de la inversion.
//
// Cambios respecto a tapa_7.scad:
//   a) Se eliminaron por completo los calados de LED D2/D3 (ya no
//      corresponden aca: los LEDs ahora se ven a traves de la
//      cubierta, tapa_V1.scad).
//   b) Se agregaron los parantes/torretas de montaje (postes con
//      agujero autorroscante) copiados del modulo mounting_boss() de
//      gabinete_ModemEYSE4G_base_0A.scad.
//
// CAMBIO DE FUENTE DE DATOS (2026-09-17, decision explicita de
// Damian): este archivo usa la revision "Gerber Files V1" del PCB
// (GPRS_SIM_A7670SA_kicad/Gerber Files V1/Modulo_SIMA7670SA.kicad_pcb,
// placa 90.30 x 85.00mm), NO la revision "definitiva" de 92.0mm usada
// anteriormente. Las coordenadas H1-H4 de abajo fueron verificadas
// dato por dato contra ESE archivo (origen = esquina del gr_rect de
// Edge.Cuts, 114.86,60.66) y coinciden exacto con la tabla que aporto
// Damian. board_x paso de 92.0 a 90.30mm.
//   c) Las orejitas de sujecion tapa-base (agujero pasante simple,
//      sin roscar) se mantienen TAL CUAL estaban en tapa_7.scad -
//      siguen siendo la parte "delgada" del par de piezas, y el
//      tornillo se inserta desde abajo de esta pieza, roscando hacia
//      arriba en el poste alto del archivo tapa_V1.scad.
// ============================================================

// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - BASE V1 RECORTADA
// (AJUSTE: Reducción de bordes y reubicación automática de orejitas)
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 90.3;         // ancho de la placa (mm) - Gerber Files V1
board_y = 85.0;         // alto de la placa (mm)

// ---------- PARAMETROS DEL GABINETE ----------
floor_thickness = 3.0;  // espesor de este plato (mm)
floor_to_board = 3;     // altura estructural del parante (mm)

// ---------- ESPEJADO EN X ----------
mirror_x = false;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- MOUNTING HOLES (torretas de sujecion del PCB) ----------
mount_hole_H1_x = 4.000;
mount_hole_H1_y = 81.000;
mount_hole_H2_x = 4.100;
mount_hole_H2_y = 4.100;
mount_hole_H3_x = 86.200;  
mount_hole_H3_y = 4.100;   
mount_hole_H4_x = 86.300;  
mount_hole_H4_y = 80.900;  

mount_holes_kicad = [
    [mount_hole_H1_x, mount_hole_H1_y],   // H1
    [mount_hole_H2_x, mount_hole_H2_y],   // H2
    [mount_hole_H3_x, mount_hole_H3_y],   // H3
    [mount_hole_H4_x, mount_hole_H4_y]    // H4
];

// Mantenemos la inversión del eje Y corregida anteriormente
mount_holes = [ for (p = mount_holes_kicad) [mx(p[0]), board_y - p[1]] ];

standoff_od = 8.0;      // diametro externo del standoff/boss
screw_d = 3.0;          // diametro de tornillo autorroscante para el PCB

// ============================================================
// MODULOS
// ============================================================

// Torreta de montaje del PCB
module mounting_boss(h) {
    difference() {
        cylinder(h = h, d = standoff_od, $fn = 32);
        translate([0, 0, -0.5])
            cylinder(h = h + 1, d = screw_d, $fn = 32);
    }
}

// ---------- NUEVAS DIMENSIONES RECORTADAS ----------
// Se elimina el exceso periférico de pared (wall) y holguras viejas.
// Se ajusta a un margen mínimo al ras de la placa.
clearance_corte = 0.5; 

outer_x = board_x + 2 * clearance_corte; // Nuevo ancho reducido
outer_y = board_y + 2 * clearance_corte; // Nuevo alto reducido
offset_x = clearance_corte; 
offset_y = clearance_corte;

// ---------- OREJITAS DE SUJECION TAPA-BASE (REUBICADAS) ----------
ear_clearance_d = 4.3;   // agujero pasante para tornillo
ear_d = 14;               // diametro de la orejita
ear_reach = 3;            // distancia de extensión desde la esquina

// Los centros ahora se calculan dinámicamente con las nuevas outer_x y outer_y recortadas
ear_centers = [
    [-ear_reach, -ear_reach],
    [outer_x + ear_reach, -ear_reach],
    [-ear_reach, outer_y + ear_reach],
    [outer_x + ear_reach, outer_y + ear_reach]
];

module orejita_plate(p) {
    difference() {
        translate([p[0], p[1], 0])
            cylinder(h = floor_thickness, d = ear_d, $fn = 48);
        translate([p[0], p[1], -1])
            cylinder(h = floor_thickness + 2, d = ear_clearance_d, $fn = 32);
    }
}

module orejitas_plate() {
    for (p = ear_centers) orejita_plate(p);
}

// Plato inferior recortado con orejitas en su nueva posición
module base_v1_recortada() {
    union() {
        cube([outer_x, outer_y, floor_thickness]);
        
        // Torretas de montaje
        for (p = mount_holes) {
            translate([p[0] + offset_x, p[1] + offset_y, floor_thickness])
                mounting_boss(floor_to_board);
        }
    }
}

// Ejecución del diseño corregido
base_v1_recortada();
orejitas_plate();
