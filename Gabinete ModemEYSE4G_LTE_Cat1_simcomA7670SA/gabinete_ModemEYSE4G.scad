// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA
// Base generada a partir de las coordenadas reales del PCB
// (Modulo_SIMA7670SA.kicad_pcb)
// Sistema de coordenadas: origen en la esquina inferior
// izquierda de la placa (0,0), igual que se referencia en
// la conversacion de diseno.
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 90.3;         // ancho de la placa (mm)
board_y = 85.0;         // alto de la placa (mm)
board_thickness = 1.6;  // espesor del PCB (mm)

// ---------- PARAMETROS DEL GABINETE ----------
wall = 2.0;             // espesor de pared (mm) - ajustar segun impresora/proceso
clearance_xy = 1.5;     // holgura alrededor de la placa (mm)
floor_to_board = 6;     // altura libre debajo de la placa (para U3/U5/U6 que van sobre zocalo)
board_to_lid = 15;      // altura libre arriba de la placa (para conectores, LEDs, etc.)

// ---------- MOUNTING HOLES (posiciones reales, relativas a 0,0 de la placa) ----------
// H1: esquina inferior izquierda, H2: superior izquierda,
// H3: superior derecha, H4: inferior derecha
mount_holes = [
    [4.0, 81.0],   // H1
    [4.1, 4.1],    // H2
    [86.2, 4.1],   // H3
    [86.3, 80.9]   // H4
];
mount_hole_d = 4.0;     // diametro del taladro NPTH (confirmado en drill file)
standoff_od = 8.0;      // diametro externo del standoff/boss - AJUSTAR a gusto
screw_d = 3.0;          // diametro de tornillo autorroscante - CONFIRMAR con Damian

// ---------- CONECTORES (posiciones reales, relativas a 0,0 de la placa) ----------
// Cada uno con su rotacion tal cual figura en el PCB.
// Dimensiones de corte son PLACEHOLDER - ajustar con el
// datasheet real de cada conector antes de imprimir.

conn_J1_terminal = [23.7, 4.5, 180];   // borde superior - terminal +12V
conn_J5_barrel   = [14.9, 10.5, 180];  // borde superior - jack DC
conn_J2_db9      = [31.0, 76.8, 0];    // borde inferior - DB9
conn_J4_sma      = [70.7, 80.6, 90];   // borde inferior - SMA antena
// J3 (U.FL) es interno, no necesita corte en el gabinete.
// USB-C de U5: PENDIENTE - la rotacion actual del footprint
// no apunta a ningun borde (ver conversacion). Definir antes
// de agregar el corte correspondiente.

// ============================================================
// MODULOS
// ============================================================

module mounting_boss(h) {
    difference() {
        cylinder(h = h, d = standoff_od, $fn = 32);
        cylinder(h = h + 1, d = screw_d, $fn = 32);
    }
}

module base_gabinete() {
    outer_x = board_x + 2 * (wall + clearance_xy);
    outer_y = board_y + 2 * (wall + clearance_xy);
    total_h = floor_to_board + board_thickness + board_to_lid;

    difference() {
        // Cascaron exterior
        cube([outer_x, outer_y, total_h]);

        // Cavidad interior
        translate([wall, wall, wall])
            cube([outer_x - 2*wall, outer_y - 2*wall, total_h]);
    }

    // Bosses de montaje, posicionados segun coordenadas reales
    // (offset por el borde + holgura del gabinete)
    offset_x = wall + clearance_xy;
    offset_y = wall + clearance_xy;
    for (p = mount_holes) {
        translate([p[0] + offset_x, p[1] + offset_y, wall])
            mounting_boss(floor_to_board - wall);
    }
}

base_gabinete();

// ============================================================
// PENDIENTE / TODO:
// - Definir corte de USB-C de U5 una vez resuelta su rotacion
// - Ajustar dimensiones reales de cada conector (J1, J2, J4, J5)
//   con su datasheet antes de cortar las ventanas en las paredes
// - Confirmar diametro de tornillo (screw_d) y ajustar standoff_od
// - Agregar tapa (lid) por separado
// ============================================================
