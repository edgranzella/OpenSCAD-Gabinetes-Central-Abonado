// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - BASE
// Pieza separada: solo la base (paredes + piso + parantes de
// montaje + calados de conectores laterales). La tapa esta en
// el archivo gabinete_ModemEYSE4G_tapa_6.scad
// Sistema de coordenadas: origen en la esquina inferior
// izquierda de la placa (0,0), igual que se referencia en
// la conversacion de diseno.
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 90.3;         // ancho de la placa (mm)
board_y = 85.0;         // alto de la placa (mm)
board_thickness = 1.6;  // espesor del PCB (mm)

// ---------- PARAMETROS DEL GABINETE ----------
wall = 3.0;             // espesor de pared, hacia afuera (mm) - definido por Damian
floor_thickness = 3.0;  // espesor del piso - ASUNCION: igual al espesor de pared,
                        // confirmar con Damian si debe ser distinto
box_ext_height = 20.0;  // altura EXTERIOR de la caja (sin contar la tapa) - definido por Damian
clearance_xy = 1.5;     // holgura alrededor de la placa (mm)

// La placa se apoya con la cara de componentes hacia ARRIBA (+Z), sujeta
// por tornillos insertados desde arriba en H1-H4 hacia parantes que
// suben desde el piso del gabinete. La cara inferior de la placa NO
// tiene componentes (es la cara "back"), asi que este hueco es solo
// la altura estructural del parante, no un espacio para alojar partes.
floor_to_board = 3;

// Referencia de altura "piso del PCB" (superficie superior, donde
// asientan los componentes) usada para todos los calados de conectores,
// tal como la definio Damian: piso del gabinete (Z=0) + pared (3mm)
// + teton (floor_to_board) + espesor de PCB (1.6mm).
pcb_top_z = floor_thickness + floor_to_board + board_thickness; // = 7.6mm

// ---------- ESPEJADO EN X ----------
// La placa se coloca con la cara de componentes hacia arriba (+Z),
// pero al hacerlo, el eje X queda invertido respecto a como KiCad
// lo guarda en el archivo (que siempre referencia la vista desde
// arriba mirando el F.Cu tal cual se dibuja en el editor). Por eso
// TODAS las coordenadas X de conectores/holes/LEDs se espejan con
// esta funcion antes de usarse. Las coordenadas "_kicad" que siguen
// abajo son las crudas, tal cual figuran en el .kicad_pcb - no las
// toques a mano, se recalculan solas via mirror_x().
mirror_x = true;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- MOUNTING HOLES ----------
// Coordenadas crudas de KiCad (relativas a 0,0 de la placa):
// H1: esquina inferior izquierda, H2: superior izquierda,
// H3: superior derecha, H4: inferior derecha
mount_holes_kicad = [
    [4.0, 81.0],   // H1
    [4.1, 4.1],    // H2
    [86.2, 4.1],   // H3
    [86.3, 80.9]   // H4
];
mount_holes = [ for (p = mount_holes_kicad) [mx(p[0]), p[1]] ];
mount_hole_d = 4.0;     // diametro del taladro NPTH (confirmado en drill file)
standoff_od = 8.0;      // diametro externo del standoff/boss - AJUSTAR a gusto
screw_d = 3.0;          // diametro de tornillo autorroscante - CONFIRMAR con Damian

// ---------- CONECTORES ----------
// Coordenadas X crudas de KiCad, ya pasadas por mx() abajo.
// Cada conector tiene su propia altura de calado en Z, medida desde
// pcb_top_z segun lo definido con Damian.

// J1 y J5 (alimentacion): calado rectangular 20mm ancho, 11mm alto
// (reducido desde 15mm para entrar en la caja de 20mm).
conn_J1J5_w = 20;
conn_J1J5_h = 11;
conn_J1J5_z = pcb_top_z + conn_J1J5_h/2; // = 13.1mm

conn_J1_terminal = [mx(23.7), conn_J1J5_w, conn_J1J5_h]; // pared trasera (y=0)
conn_J5_barrel   = [mx(14.9), conn_J1J5_w, conn_J1J5_h]; // pared trasera (y=0)

// J4 (SMA): agujero circular de 8mm de diametro, centrado a 7.5mm
// sobre el piso del PCB (dato dado por Damian).
conn_J4_sma_d = 8;
conn_J4_sma_x = mx(70.7);           // pared frontal (y=board_y)
conn_J4_sma_z = pcb_top_z + 7.5;    // = 15.1mm

// J2 (DB9 hembra a 90 grados): calado rectangular. Arranca a 2.5mm
// sobre el piso del PCB y sube 8.4mm (el maximo que entra sin agrandar
// la caja, confirmado por Damian). Ancho tomado de la separacion entre
// tornillos propios del conector (25mm) - ASUNCION, confirmar que el
// ancho real de la carcasa no sea mayor a eso.
conn_J2_w = 25;
conn_J2_h = 8.4;
conn_J2_z_start = pcb_top_z + 2.5;
conn_J2_z = conn_J2_z_start + conn_J2_h/2; // = 14.3mm
conn_J2_db9 = [mx(31.0), conn_J2_w, conn_J2_h]; // pared frontal (y=board_y)

// USB-C de U5 (Black Pill): pared derecha, a 44.1mm a lo largo del eje Y.
// OJO: tal como esta este bloque (igual al archivo subido), el calado
// real en el modulo mas abajo usa conn_J2_db9[2] (8.4mm, la altura de
// J2) en vez de conn_J1J5_h (11mm) - quedo pendiente de esa correccion,
// que se discutio en el mensaje anterior y todavia no se aplico aca.
conn_usbc_w = 10;
conn_usbc_h = 5; // valor sin usar actualmente por el bug mencionado arriba
conn_usbc_z = pcb_top_z + 7.5;
conn_usbc_y = 44.1; // a lo largo de la pared derecha (coordenada Y real, no se espeja)

// J3 (U.FL) es interno, no necesita corte en el gabinete.

// ============================================================
// MODULOS
// ============================================================

module mounting_boss(h) {
    difference() {
        cylinder(h = h, d = standoff_od, $fn = 32);
        cylinder(h = h + 1, d = screw_d, $fn = 32);
    }
}

// Dimensiones exteriores totales de la caja
outer_x = board_x + 2 * (wall + clearance_xy);
outer_y = board_y + 2 * (wall + clearance_xy);
offset_x = wall + clearance_xy; // offset del (0,0) de la placa dentro de la caja
offset_y = wall + clearance_xy;

module base_gabinete() {
    difference() {
        union() {
            // Cascaron exterior (piso + paredes), altura EXTERIOR fija = box_ext_height
            difference() {
                cube([outer_x, outer_y, box_ext_height]);
                translate([wall, wall, floor_thickness])
                    cube([outer_x - 2*wall, outer_y - 2*wall,
                          box_ext_height - floor_thickness + 1]);
            }
            // Bosses de montaje, en coordenadas reales de H1-H4
            for (p = mount_holes) {
                translate([p[0] + offset_x, p[1] + offset_y, floor_thickness])
                    mounting_boss(floor_to_board);
            }
        }

        // ---- Calados laterales ----
        // Pared trasera (y=0): J1 y J5
        translate([conn_J1_terminal[0] + offset_x, -1, conn_J1J5_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            square([conn_J1_terminal[1], conn_J1_terminal[2]], center = true);

        translate([conn_J5_barrel[0] + offset_x, -1, conn_J1J5_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            square([conn_J5_barrel[1], conn_J5_barrel[2]], center = true);

        // Pared frontal (y=outer_y): J2 y J4
        translate([conn_J2_db9[0] + offset_x, outer_y - wall - 1, conn_J2_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            square([conn_J2_db9[1], conn_J2_db9[2]], center = true);

        translate([conn_J4_sma_x + offset_x, outer_y - wall - 1, conn_J4_sma_z])
            rotate([-90,0,0])
            cylinder(h = wall + 2, d = conn_J4_sma_d, $fn = 48);

        // USB-C de U5: pared derecha (x = outer_x), a lo largo del eje Y.
        translate([
            outer_x - wall - 1, conn_usbc_y + offset_y - conn_usbc_w/2,
            conn_usbc_z - conn_J2_db9[2]/2 - 3 ])
        cube([wall + 2, conn_usbc_w, conn_J2_db9[2]]);
    }
}

base_gabinete();
