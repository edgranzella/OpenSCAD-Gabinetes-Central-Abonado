// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - TAPA
// Pieza separada: solo la tapa superior, con los calados de
// los LEDs D2/D3. La base esta en el archivo
// gabinete_ModemEYSE4G_base_6.scad
// Mismo sistema de coordenadas y mismos parametros de placa
// que la base, para que las dimensiones exteriores coincidan.
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 90.3;         // ancho de la placa (mm)
board_y = 85.0;         // alto de la placa (mm)

// ---------- PARAMETROS DEL GABINETE ----------
wall = 3.0;             // espesor de pared, hacia afuera (mm) - definido por Damian
lid_thickness = 3.0;    // espesor de la tapa superior - definido por Damian
clearance_xy = 1.5;     // holgura alrededor de la placa (mm)

// ---------- ESPEJADO EN X ----------
// Mismo criterio que en la base: las coordenadas X de los LEDs se
// espejan porque la placa se monta con la cara de componentes hacia
// arriba, invirtiendo el eje X respecto a como lo guarda KiCad.
mirror_x = true;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- LEDS (calado en la tapa) ----------
// Coordenadas X crudas de KiCad, ya pasadas por mx().
led_D2 = [mx(3.5), 17.6];
led_D3 = [mx(3.5), 10.16];
led_hole_d = 5.5; // LED THT de 5mm + holgura - AJUSTAR a gusto (diametro real vs. luz difusa)

// ============================================================
// MODULO
// ============================================================

// Dimensiones exteriores totales de la caja (deben coincidir con las
// de gabinete_ModemEYSE4G_base_6.scad para que la tapa calce bien)
outer_x = board_x + 2 * (wall + clearance_xy);
outer_y = board_y + 2 * (wall + clearance_xy);
offset_x = wall + clearance_xy; // offset del (0,0) de la placa dentro de la caja
offset_y = wall + clearance_xy;

// ---------- OREJITAS DE SUJECION TAPA-BASE ----------
// Mismos centros que en gabinete_ModemEYSE4G_base_6.scad - deben
// coincidir exactamente para que los agujeros calcen con los de la base.
ear_clearance_d = 4.3;   // agujero pasante en la tapa (holgura sobre tornillo de 5/32")
ear_d = 14;               // diametro de la orejita
ear_reach = 3;            // mismo valor que en la base

ear_centers = [
    [-ear_reach, -ear_reach],
    [outer_x + ear_reach, -ear_reach],
    [-ear_reach, outer_y + ear_reach],
    [outer_x + ear_reach, outer_y + ear_reach]
];

module orejita_tapa(p) {
    difference() {
        translate([p[0], p[1], 0])
            cylinder(h = lid_thickness, d = ear_d, $fn = 48);
        translate([p[0], p[1], -1])
            cylinder(h = lid_thickness + 2, d = ear_clearance_d, $fn = 32);
    }
}

module orejitas_tapa() {
    for (p = ear_centers) orejita_tapa(p);
}

// Tapa superior: mismas dimensiones XY exteriores que la caja,
// espesor lid_thickness. Se imprime aparte y se apoya sobre el
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

tapa();
orejitas_tapa();
