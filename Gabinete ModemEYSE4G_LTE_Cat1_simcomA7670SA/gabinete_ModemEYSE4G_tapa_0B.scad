// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - TAPA (v0B)
// Pieza separada: solo la tapa superior, con los calados de
// los LEDs D2/D3. La base esta en el archivo
// gabinete_ModemEYSE4G_base_0B.scad
// Mismo sistema de coordenadas y mismos parametros de placa
// que la base, para que las dimensiones exteriores coincidan.
//
// Cambios v7 -> v0B: alineada con gabinete_ModemEYSE4G_base_0B.scad.
//
// 1) board_x actualizado 90.3 -> 92.0mm (igual que en la base 0B,
//    tomado del PCB definitivo). Esto es lo que realmente movia las
//    "torres"/orejitas de sujecion de las esquinas: al depender de
//    outer_x = board_x + 2*(wall+clearance_xy), con el board_x viejo
//    (90.3) las 4 orejitas de la tapa quedaban en outer_x=99.3mm,
//    mientras que en la base 0B outer_x=101.0mm - un desfase de
//    1.7mm que hacia que NO coincidieran los agujeros al ensamblar.
//    Con board_x=92.0 en ambos archivos, outer_x=101.0mm en los dos
//    y las orejitas quedan exactamente alineadas.
//
// 2) mirror_x corregido de true a false, igual que en la base 0B
//    (aclaracion de Damian: la placa va con los componentes hacia
//    arriba, en su orientacion natural, coincidiendo con la vista
//    superior estandar de KiCad - no corresponde espejar). Esto
//    solo afecta los calados de LED D2/D3, no a las orejitas.
//
// 3) Nota sobre inversion Y / volteo de la tapa: la tapa y la base
//    comparten el MISMO origen (0,0) y el mismo sistema de
//    coordenadas XY - no se aplica ninguna inversion adicional de
//    eje X o Y por el hecho de que la tapa se coloque "boca abajo"
//    sobre la base. Motivo: el modulo tapa() es una simple placa
//    plana (cube[outer_x, outer_y, lid_thickness]) con agujeros
//    pasantes (orejitas y LEDs) que van derecho a traves del
//    espesor en Z - son simetricos en Z, asi que no importa cual
//    cara mire hacia arriba o hacia abajo al ensamblar: la
//    proyeccion en XY es identica desde cualquiera de las dos caras.
//    Ademas, las 4 orejitas de las esquinas (ear_centers) son
//    simetricas respecto al centro del rectangulo outer_x x outer_y,
//    asi que aunque se invirtiera un eje, el conjunto de las 4
//    posiciones cae en las mismas coordenadas (solo cambiaria cual
//    orejita fisica corresponde a cual esquina, no su ubicacion).
//    Por lo tanto, alcanza con que outer_x/outer_y (y por ende
//    board_x/board_y/wall/clearance_xy) sean identicos entre tapa y
//    base para que las torres de sujecion calcen perfectamente.
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 92.0;         // ancho de la placa (mm) - ACTUALIZADO v0B: igual que
                        // en base_0B.scad (PCB definitivo, 90.3 -> 92.0mm)
board_y = 85.0;         // alto de la placa (mm) - sin cambios respecto a v7

// ---------- PARAMETROS DEL GABINETE ----------
wall = 3.0;             // espesor de pared, hacia afuera (mm) - definido por Damian
lid_thickness = 3.0;    // espesor de la tapa superior - definido por Damian
clearance_xy = 1.5;     // holgura alrededor de la placa (mm)

// ---------- ESPEJADO EN X ----------
// La placa va montada con la cara de componentes hacia arriba (+Z),
// en su orientacion natural de diseno: coincide DIRECTAMENTE con la
// vista superior estandar de KiCad, sin necesidad de espejar.
// CORRECCION v0B: mirror_x estaba en true en tapa_7 (mismo supuesto
// erroneo que en base_0A). Se corrige a false, igual que en base_0B.
mirror_x = false;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- LEDS (calado en la tapa) ----------
// Coordenadas X crudas de KiCad, ya pasadas por mx() (ahora identidad).
// Verificadas v0B contra Modulo_SIMA7670SA.kicad_pcb (definitivo):
//   D2 absoluto (118.36,78.26) -> relativo (3.50,17.60): coincide exacto.
//   D3 absoluto (118.36,70.82) -> relativo (3.50,10.16): coincide exacto.
// Sin cambios de posicion.
led_D2 = [mx(3.5), 17.6];
led_D3 = [mx(3.5), 10.16];
// LED THT de 5mm de diametro + 0.5mm de holgura por lado = 6.0mm.
// ACTUALIZADO v0B: antes 5.5mm (0.25mm/lado), se alinea con el
// criterio de holgura de 0.5mm/lado usado en el resto del gabinete.
led_hole_d = 6.0;

// ============================================================
// MODULO
// ============================================================

// Dimensiones exteriores totales de la caja (deben coincidir con las
// de gabinete_ModemEYSE4G_base_0B.scad para que la tapa calce bien)
outer_x = board_x + 2 * (wall + clearance_xy);
outer_y = board_y + 2 * (wall + clearance_xy);
offset_x = wall + clearance_xy; // offset del (0,0) de la placa dentro de la caja
offset_y = wall + clearance_xy;

// ---------- OREJITAS DE SUJECION TAPA-BASE ----------
// Mismos centros que en gabinete_ModemEYSE4G_base_0B.scad - deben
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
