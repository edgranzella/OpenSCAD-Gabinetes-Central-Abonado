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
wall = 3.0;             // espesor de pared, hacia afuera (mm) - definido por Damian
floor_thickness = 3.0;  // espesor del piso - ASUNCION: igual al espesor de pared,
                        // confirmar con Damian si debe ser distinto
lid_thickness = 3.0;    // espesor de la tapa superior - definido por Damian
box_ext_height = 20.0;  // altura EXTERIOR de la caja (sin contar la tapa) - definido por Damian
clearance_xy = 1.5;     // holgura alrededor de la placa (mm)

// La placa se apoya con la cara de componentes hacia ARRIBA (+Z), sujeta
// por tornillos insertados desde arriba en H1-H4 hacia parantes que
// suben desde el piso del gabinete. La cara inferior de la placa NO
// tiene componentes (es la cara "back"), asi que este hueco es solo
// la altura estructural del parante, no un espacio para alojar partes.
floor_to_board = 3;

// Todo el resto de la altura interior queda disponible ARRIBA de la
// placa, que es donde estan poblados todos los componentes (incluidos
// U3/U5/U6, que son mas altos que el resto pero siguen mirando hacia
// la tapa, no hacia el piso).

// Altura libre disponible arriba de la placa (donde quedan todos los
// componentes, cara hacia la tapa), calculada automaticamente a partir
// de la altura total exterior fijada:
interior_height = box_ext_height - floor_thickness;
board_to_lid = interior_height - floor_to_board - board_thickness;
// Con box_ext_height=20, floor_thickness=3, floor_to_board=3 y
// board_thickness=1.6, board_to_lid queda en 10.4mm libres para
// componentes - CONFIRMAR que alcanza para la altura real de U3/U5/U6
// (module + lo que tengan nesteado debajo de su cuerpo) antes de imprimir.

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

// J1 y J5 (alimentacion): calado rectangular 20mm ancho. Altura pedida
// originalmente 15mm "desde el piso del PCB", pero eso excedia el
// borde superior de la caja (22.6mm > 20mm de box_ext_height) - Damian
// eligio reducir la altura a lo maximo que entra sin agrandar la caja:
// 11mm, dejando ~1.4mm de margen contra el borde superior.
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

// USB-C de U5 (Black Pill): posicion real confirmada contra el visor 3D.
// El footprint real es "Damian_PCB:Black_Pill_STM32F411"; el conector
// USB esta en el punto local (0,-24) de ese footprint. Con la rotacion
// de U5 (90 grados) y la convencion de giro real de KiCad (confirmada
// empiricamente contra la imagen del visor, no la formula que yo tenia
// asumida antes), la posicion cruda de KiCad da (3.3, 44.1) - cerca del
// borde X=0. Como ese borde queda espejado por mx(), el calado real cae
// sobre la PARED DERECHA del gabinete (no la trasera/frontal), a 44.1mm
// a lo largo de esa pared.
conn_usbc_w = 10;
conn_usbc_h = 5; // banda 5-10mm => 5mm de alto
conn_usbc_z = pcb_top_z + 7.5; // punto medio de la banda 5-10mm = 15.1mm
conn_usbc_y = 44.1; // a lo largo de la pared derecha (coordenada Y real, no se espeja)

// LEDs D2 y D3 - calado en la TAPA superior, no en las paredes.
// Coordenadas X crudas de KiCad, ya pasadas por mx().
led_D2 = [mx(3.5), 17.6];
led_D3 = [mx(3.5), 10.16];
led_hole_d = 5.5; // LED THT de 5mm + holgura - AJUSTAR a gusto (diametro real vs. luz difusa)

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

// Dimensiones exteriores totales de la caja (usadas tambien por la tapa)
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
        // Uso un cubo simple (mas directo que rotar un extrude) para el
        // corte, ya que esta pared es perpendicular al eje X.
        translate([
            outer_x - wall - 1, conn_usbc_y + offset_y - conn_usbc_w/2,
            conn_usbc_z - conn_J2_db9[2]/2 - 3 ])

        cube([wall + 2, conn_usbc_w, conn_J2_db9[2]]);
    }
}

// Tapa superior: pieza separada, mismas dimensiones XY exteriores que la
// caja, espesor lid_thickness. Se imprime aparte y se apoya sobre el
// borde superior de las paredes.
module tapa() {
    difference() {
        cube([outer_x, outer_y, lid_thickness]);

        // Calados de los LEDs D2 y D3 (posicion real tomada del PCB)
        translate([led_D2[0] + offset_x, led_D2[1] + offset_y, -1])
            cylinder(h = lid_thickness + 2, d = led_hole_d, $fn = 32);
        translate([led_D3[0] + offset_x, led_D3[1] + offset_y, -1])
            cylinder(h = lid_thickness + 2, d = led_hole_d, $fn = 32);
    }
}

// ---- Ensamblado para visualizar ambas piezas juntas ----
base_gabinete();

translate([0, outer_y + 10, 0])  // corrida al costado solo para visualizar separada
    tapa();

// ============================================================
// PENDIENTE / TODO:
// - Confirmar que el ancho real de la carcasa del DB9 (J2) no supere
//   los 25mm que se tomaron de la separacion entre tornillos.
// - Confirmar diametro de tornillo (screw_d) y ajustar standoff_od
// - Definir sistema de cierre entre caja y tapa (encastre/tornillos/
//   simplemente apoyada) - por ahora la tapa es una placa plana lisa
// - Verificar visualmente en OpenSCAD que el calado de USB-C en la
//   pared derecha quedo bien posicionado (no pude renderizarlo yo
//   mismo, no tengo OpenSCAD instalado en este entorno)
// ============================================================
