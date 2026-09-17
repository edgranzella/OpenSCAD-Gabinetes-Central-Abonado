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

// ---------- PARAMETROS DE LA PLACA ----------
// Fuente: Gerber Files V1 (ver nota arriba). board = 90.30 x 85.00mm.
board_x = 90.3;         // ancho de la placa (mm) - ACTUALIZADO 2026-09-17 (era 92.0)
board_y = 85.0;         // alto de la placa (mm)

// ---------- PARAMETROS DEL GABINETE ----------
wall = 3.0;             // espesor de pared, hacia afuera (mm) - solo se usa aca
                        // para calcular outer_x/outer_y (este plato no tiene
                        // paredes propias, son parte de tapa_V1.scad)
floor_thickness = 3.0;  // espesor de este plato (antes "lid_thickness" en tapa_7)
clearance_xy = 1.5;     // holgura alrededor de la placa (mm)

// La placa se apoya con la cara de componentes hacia ARRIBA (+Z), sujeta
// por tornillos insertados desde arriba en H1-H4 hacia parantes que
// suben desde este plato. La cara inferior de la placa NO tiene
// componentes, asi que este hueco es solo la altura estructural del
// parante, no un espacio para alojar partes.
floor_to_board = 3;

// ---------- ESPEJADO EN X ----------
// Igual que en base_0B.scad: la placa va con los componentes hacia
// arriba, en su orientacion natural, coincidiendo con la vista
// superior estandar de KiCad - no corresponde espejar.
mirror_x = false;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- MOUNTING HOLES (torretas de sujecion del PCB) ----------
// Coordenadas crudas de KiCad (relativas al origen 0,0 de la placa),
// verificadas dato por dato contra Gerber Files V1/Modulo_SIMA7670SA.kicad_pcb
// el 2026-09-17. H1: esquina inferior izquierda, H2: superior
// izquierda, H3: superior derecha, H4: inferior derecha.
mount_hole_H1_x = 4.000;
mount_hole_H1_y = 81.000;
mount_hole_H2_x = 4.100;
mount_hole_H2_y = 4.100;
mount_hole_H3_x = 86.200;  // ACTUALIZADO 2026-09-17 (era 87.6, valor del PCB definitivo)
mount_hole_H3_y = 4.100;   // ACTUALIZADO 2026-09-17 (era 4.3)
mount_hole_H4_x = 86.300;  // ACTUALIZADO 2026-09-17 (era 87.7)
mount_hole_H4_y = 80.900;  // ACTUALIZADO 2026-09-17 (era 80.6)

mount_holes_kicad = [
    [mount_hole_H1_x, mount_hole_H1_y],   // H1
    [mount_hole_H2_x, mount_hole_H2_y],   // H2
    [mount_hole_H3_x, mount_hole_H3_y],   // H3
    [mount_hole_H4_x, mount_hole_H4_y]    // H4
];
mount_holes = [ for (p = mount_holes_kicad) [mx(p[0]), p[1]] ];
mount_hole_d = 4.0;     // diametro del taladro NPTH del PCB (referencia, no impulsa geometria)
standoff_od = 8.0;      // diametro externo del standoff/boss
screw_d = 3.0;          // diametro de tornillo autorroscante para sujetar el PCB

// ============================================================
// MODULOS
// ============================================================

// Torreta de montaje del PCB: copiado tal cual de base_0A/0B.scad.
module mounting_boss(h) {
    difference() {
        cylinder(h = h, d = standoff_od, $fn = 32);
        cylinder(h = h + 1, d = screw_d, $fn = 32);
    }
}

// Dimensiones exteriores totales del plato (deben coincidir con las
// de gabinete_ModemEYSE4G_tapa_V1.scad para que ensamble bien)
outer_x = board_x + 2 * (wall + clearance_xy);
outer_y = board_y + 2 * (wall + clearance_xy);
offset_x = wall + clearance_xy; // offset del (0,0) de la placa dentro del plato
offset_y = wall + clearance_xy;

// ---------- OREJITAS DE SUJECION TAPA-BASE ----------
// Identicas a tapa_7.scad: solo agujero pasante (sin roscar). El
// tornillo se inserta desde ABAJO de este plato, atraviesa esta
// orejita libremente, y rosca hacia arriba en el poste alto y macizo
// del archivo tapa_V1.scad (ahi si tiene agujero piloto autorroscante).
ear_clearance_d = 4.3;   // agujero pasante (holgura sobre tornillo de 5/32")
ear_d = 14;               // diametro de la orejita
ear_reach = 3;             // igual que en tapa_V1.scad

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

// Plato inferior: plancha plana con las torretas de montaje del PCB.
// Sin LEDs (ver punto a) del encabezado) y sin paredes (las paredes
// estan en tapa_V1.scad).
module base_v1() {
    union() {
        cube([outer_x, outer_y, floor_thickness]);
        // Torretas de montaje, en coordenadas reales de H1-H4
        for (p = mount_holes) {
            translate([p[0] + offset_x, p[1] + offset_y, floor_thickness])
                mounting_boss(floor_to_board);
        }
    }
}

base_v1();
orejitas_plate();
