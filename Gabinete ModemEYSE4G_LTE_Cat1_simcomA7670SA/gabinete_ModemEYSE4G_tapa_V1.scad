// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - TAPA/CUBIERTA V1
// (REESTRUCTURACION: inversion de componentes)
//
// Origen de este archivo: gabinete_ModemEYSE4G_base_0A.scad (la base
// con paredes). En el nuevo esquema de 2 piezas, esta pieza va
// COLOCADA ENCIMA, BOCA ABAJO, como una cubierta tipo "taza invertida":
// el piso original de base_0A pasa a ser el TECHO de esta pieza, y las
// paredes cuelgan HACIA ABAJO desde ese techo hasta un borde/reborde
// abierto que apoya sobre gabinete_ModemEYSE4G_base_V1.scad (el plato
// plano con las torretas del PCB).
//
// === LOGICA DE LA INVERSION (leer antes de revisar los calados) ===
// NO se aplica ningun rotate()/mirror() al modulo de base_0A tal cual
// estaba escrito. En cambio, esta pieza se AUTORIA DE NUEVO ya en su
// orientacion final de uso (techo arriba, paredes colgando, borde
// abierto en Z=0), reutilizando los mismos parametros/formas de
// base_0A pero con la cavidad tallada en el sentido opuesto de Z.
//
// Por que esto NO requiere espejar X ni Y (solo Z):
// Fisicamente, dar vuelta una pieza real "boca abajo" siempre implica
// rotarla 180 grados alrededor de un eje horizontal - lo cual espeja
// simultaneamente Z Y uno de los dos ejes horizontales (X o Y, segun
// el eje de giro elegido). Pero aca no estamos rotando un objeto ya
// impreso: estamos generando la geometria DIRECTAMENTE en su
// orientacion de ensamblaje final. Como el plato base_V1.scad usa las
// mismas coordenadas X,Y (sin espejar) para sus torretas, esta pieza
// tiene que usar EXACTAMENTE esas mismas X,Y para que las paredes y
// ventanas queden alineadas con los conectores reales del PCB montado
// sobre esas torretas - espejar X o Y aca las desalinearia. Lo UNICO
// que cambia es la referencia de altura (Z): antes se medida "desde
// el piso hacia arriba" (pcb_top_z, con Z=0 en el piso de base_0A);
// aca se mide "desde el borde/reborde hacia arriba" (pcb_top_z_from_rim,
// con Z=0 en el borde que apoya sobre base_V1.scad). Ver mas abajo.
//
// AVISO PARA REVISION: Damian senalo este punto como clave. Esta es
// la interpretacion de ingenieria aplicada - revisar antes de imprimir.
//
// Cambios respecto a base_0A.scad:
//   a) box_ext_height aumentado para garantizar >= 25mm de altura
//      libre interna para el PCB + componentes (ver calculo abajo).
//   b) Se agregaron los calados de LED D2/D3 (ahora se ven a traves
//      del techo de esta pieza).
//   c) y d) Se recalcularon las ventanas de conectores. J1, J5, J2 y
//      el USB-C de U5 son ranuras "U invertida" ABIERTAS hacia abajo
//      (llegan hasta Z=0, el borde) para que la cubierta pueda bajar
//      verticalmente sobre los conectores ya montados sin chocar. J4
//      (SMA) es una ventana cerrada tradicional (flotando en la
//      pared), con holgura de 0.5mm por lado en base a su datasheet.
//   d) NO se tocaron los calados J1/J5/J2 en el archivo base_0B/base_V1
//      - esos calados ya no existen ahi, todos los conectores ahora
//      se calan aca, en la cubierta.
//
// CORRECCION v1 (2da pasada, reportada por Damian): dos errores reales
// de ubicacion, detectados al revisar de nuevo la rotacion de los
// footprints en el .kicad_pcb:
//
//   1) LEDs D2/D3: estaban calados como agujeros VERTICALES a traves
//      del techo (como si el LED mirara hacia arriba). Pero D2 y D3
//      tienen rotacion -90 grados en el .kicad_pcb (footprint "LED,
//      diameter 5.0mm"), es decir son LEDs de pata doblada que
//      apuntan de COSTADO, no hacia arriba - y ademas estan a solo
//      3.5mm del borde X=0 de la placa (carne de gallina: eso es
//      literalmente al ras del borde). Se corrige: ahora son agujeros
//      HORIZONTALES en la pared X=0 (la pared "izquierda"), no en el
//      techo.
//   2) USB-C de U5: estaba calado en la pared X=outer_x (derecha).
//      Damian confirmo que el USB-C va del MISMO lado que los LEDs
//      (pared X=0, izquierda). Se corrige: se mueve el calado a la
//      pared X=0, usando el mismo conn_usbc_y=44.1 ya verificado
//      antes (ese valor no depende de en que pared se corte, solo
//      indica la posicion a lo largo de la pared).
//      NOTA: se habia intentado re-derivar la posicion X del USB-C
//      proyectando la muesca del courtyard del footprint U5 a traves
//      de su rotacion de 90 grados - pero esa derivacion depende del
//      signo de la formula de rotacion (ambiguo sin poder render-ear
//      el footprint) y de que el courtyard generico de "Raspberry Pi
//      Pico" represente fielmente el USB-C de la Black Pill (no es
//      100% seguro que lo haga). Por eso NO se uso ese resultado -
//      se aplico directamente la instruccion de Damian (mismo lado
//      que los LEDs) en vez de una derivacion propia poco confiable.
//
//   J1, J5 (pared Y=0) y J2, J4 (pared Y=board_y) NO se movieron: su
//   cercania real a esas paredes (4.5-10mm para J1/J5, 4-8mm para
//   J2/J4, tomada directo del .kicad_pcb) ya los ubica correctamente
//   ahi, agrupados con LEDs+USB-C en la esquina X=0/Y=0 ("lado
//   izquierdo") y separados de esa esquina en la pared Y=board_y
//   ("lado derecho"), consistente con lo que describio Damian.
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 92.0;          // ancho de la placa (mm) - igual que base_V1.scad
board_y = 85.0;          // alto de la placa (mm)
board_thickness = 1.6;   // espesor del PCB (mm)

// ---------- PARAMETROS DEL GABINETE ----------
wall = 3.0;              // espesor de pared, hacia afuera (mm)
floor_thickness = 3.0;   // espesor del TECHO de esta pieza (misma constante
                         // que "floor_thickness" en base_V1.scad, reutilizada
                         // aca para la plancha solida del otro extremo)
clearance_xy = 1.5;      // holgura alrededor de la placa (mm)
floor_to_board = 3;      // igual que en base_V1.scad (altura de las torretas)

// AJUSTE v1 (punto a del encabezado): altura interior libre minima
// requerida por Damian = 25mm, medida desde la superficie superior
// de base_V1.scad (donde apoya el PCB elevado por las torretas) hasta
// el techo de esta cubierta. Esa altura libre = box_ext_height -
// floor_thickness (el techo "se come" floor_thickness mm de la altura
// total). Para llegar a 25mm exactos: box_ext_height = 25 + 3 = 28mm.
box_ext_height = 28.0;   // altura EXTERIOR de la cubierta (antes 20.0 en base_0A)
// Verificacion: altura libre resultante = box_ext_height - floor_thickness
altura_libre_verificacion = box_ext_height - floor_thickness; // = 25.0mm >= 25mm requerido

// Referencia de altura "piso del PCB" MEDIDA DESDE EL BORDE (Z=0) de
// esta pieza - reemplaza al "pcb_top_z" de base_0A (que se medía desde
// SU piso, Z=0 alla). Aca Z=0 es el borde/reborde que apoya sobre
// base_V1.scad, cuya superficie superior (donde estan las torretas)
// ya esta al ras de ese borde. Por eso esta referencia NO incluye
// floor_thickness (ese espesor pertenece a base_V1.scad, es una pieza
// distinta): pcb_top_z_from_rim = floor_to_board + board_thickness.
pcb_top_z_from_rim = floor_to_board + board_thickness; // = 4.6mm

// ---------- ESPEJADO EN X ----------
// Igual criterio que en base_V1.scad/base_0B.scad: sin espejo en X.
// Ver el bloque "LOGICA DE LA INVERSION" en el encabezado para el
// analisis completo de por que X e Y no se tocan aca.
mirror_x = false;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- LEDS (calado vertical en el TECHO de la tapa) ----------
// CORREGIDO v1 (2da vuelta, aclaracion de Damian): los LEDs D2/D3
// estan soldados cerca del borde frontal (X=0) de la placa, pero SE
// VEN DESDE ARRIBA - el agujero va vertical, atravesando el techo de
// esta pieza (tapa_V1), en la posicion real (X,Y) del LED. NO es un
// agujero horizontal en la pared X=0 (eso fue un intento de correccion
// anterior, equivocado - revertido aca).
// Coordenadas verificadas contra el PCB definitivo (D2 absoluto
// 118.36,78.26 / D3 absoluto 118.36,70.82), sin espejar.
led_D2 = [mx(3.5), 17.6];
led_D3 = [mx(3.5), 10.16];
led_hole_d = 6.0; // LED 5mm + 0.5mm de holgura por lado (igual que tapa_0B.scad)

// ---------- CONECTORES ----------
// Posiciones X/Y: identicas a las verificadas en base_0B.scad contra
// Modulo_SIMA7670SA.kicad_pcb (definitivo) - NO se espejan (ver
// encabezado). Lo que cambia respecto a base_0B son las alturas Z
// (recalculadas desde pcb_top_z_from_rim) y la forma de la ventana:
// "U invertida" abierta hasta Z=0 para J1/J5/J2/USB-C, ventana
// cerrada tradicional para J4.

// --- J1 (borne de alimentacion, Phoenix PT-1,5/2-5,0-H, pared y=0) ---
conn_J1_x_kicad = 28.7;               // verificado v0B, sin cambios
conn_J1_w = 10 + 2*0.5;               // = 11mm (cuerpo real 10mm + 0.5mm/lado)
// Alto real sin pin de soldadura (datasheet Phoenix) = 11.4mm. En una
// ranura abierta hacia abajo, la holgura de 0.5mm solo hace falta en
// el borde SUPERIOR (el inferior queda abierto sin limite).
conn_J1_top_z = pcb_top_z_from_rim + 11.4 + 0.5; // = 16.5mm

// --- J5 (jack DC barrel, Same Sky PJ-002A, pared y=0) ---
conn_J5_x_kicad = 14.9;               // verificado v0B, sin cambios
conn_J5_w = 9 + 2*0.5;                // = 10mm (cuerpo real 9mm + 0.5mm/lado)
conn_J5_top_z = pcb_top_z_from_rim + 11 + 0.5;   // = 16.1mm (cuerpo real 11mm alto)

// --- J2 (DB9 hembra 90 grados, pared y=board_y) ---
conn_J2_x_kicad = 31.0;               // verificado v0B, sin cambios
conn_J2_w = 30.81 + 2*0.5;            // = 31.81mm (CORREGIDO v0B: brida con jackscrews)
// NOTA: el alto de calado J2 (10mm) NO viene de una holgura de 0.5mm
// sobre un dato de datasheet limpio - es el valor heredado (carcasa
// real ~8.36mm + margen ya generoso). Se usa tal cual como techo de
// la ranura abierta.
conn_J2_h = 10;
conn_J2_top_z = pcb_top_z_from_rim + conn_J2_h; // = 14.6mm

// --- USB-C de U5 (Black Pill), pared X=0 ("lado izquierdo", junto a los LEDs) ---
// CORREGIDO v1: iba en la pared X=outer_x (derecha) - Damian confirmo
// que va del MISMO LADO que los LEDs (pared X=0). Se mantiene el
// mismo valor de posicion (44.1mm, verificado antes como la Y del
// anchor del footprint U5) reinterpretado ahora como posicion a lo
// largo de la pared X=0 en vez de X=outer_x.
conn_usbc_y = 44.1;
// DIMENSIONES: NO SE PUDO VERIFICAR CONTRA UN DATASHEET REAL DEL
// CONECTOR USB-C (el PDF "MiniF4x1Cx_V31 Board Shape" solo trae el
// contorno de la placa Black Pill, no las cotas mecanicas del propio
// conector USB-C). Se usa un valor generico de referencia para un
// receptaculo USB-C THT/SMD tipico (~9mm ancho, ~3.5mm alto de
// carcasa) + 0.5mm de holgura. REVISAR con datasheet real del
// conector antes de imprimir - marcado como pendiente.
conn_usbc_w = 9 + 2*0.5;              // = 10mm (SIN VERIFICAR)
conn_usbc_h_body = 3.5;               // SIN VERIFICAR
conn_usbc_top_z = pcb_top_z_from_rim + conn_usbc_h_body + 0.5; // = 8.6mm (SIN VERIFICAR)

// --- J4 (SMA, Samtec SMA-J-P-X-RA-TH1), pared y=board_y ---
// UNICA excepcion: ventana CERRADA tradicional (no ranura abierta),
// segun instruccion explicita de Damian.
conn_J4_x_kicad = 70.7;               // verificado v0B, sin cambios
conn_J4_slot_w = 8;    // Ø7.00mm real (buja roscada) + 0.5mm/lado, ver base_0B
// Alto SIN VERIFICAR contra datasheet (igual que en base_0B: el plano
// Samtec trae varias cotas apiladas para las vistas de un conector
// acodado, no se pudo determinar con confianza cual usar) - se
// mantiene el valor heredado de disenio (10mm).
conn_J4_slot_h = 10;   // SIN VERIFICAR
// Centro Z: mismo criterio historico de alineacion con J1/J5 que
// tenia base_0B (alla: pcb_top_z + 11/2 = 13.1mm medido desde SU
// Z=0/piso). Re-expresado aca desde pcb_top_z_from_rim:
conn_J4_sma_z = pcb_top_z_from_rim + 11/2; // = 10.1mm

// ============================================================
// MODULOS
// ============================================================

// Forma "capsula" (estadio), igual que en base_0A/0B.scad. Usada solo
// para la ventana cerrada de J4.
module capsula_2d(w, h) {
    hull() {
        translate([0, (h - w) / 2]) circle(d = w, $fn = 48);
        translate([0, -(h - w) / 2]) circle(d = w, $fn = 48);
    }
}

// Dimensiones exteriores totales (deben coincidir con base_V1.scad)
outer_x = board_x + 2 * (wall + clearance_xy);
outer_y = board_y + 2 * (wall + clearance_xy);
offset_x = wall + clearance_xy;
offset_y = wall + clearance_xy;

// ---------- OREJITAS DE SUJECION TAPA-BASE ----------
// Postes ALTOS (toda la altura de esta pieza), con agujero piloto
// autorroscante - copiado de base_0A.scad, pero con el piloto
// INVERTIDO: entra desde Z=0 (el borde, que apoya sobre base_V1.scad
// y su agujero pasante) hacia ARRIBA, en vez de desde Z=box_ext_height
// hacia abajo como en base_0A. Motivo: aca el tornillo se inserta
// desde ABAJO de todo el conjunto (a traves de base_V1.scad) y rosca
// hacia arriba en este poste - direccion opuesta a la del diseno
// original porque las piezas intercambiaron su rol.
ear_pilot_d = 3.4;
ear_d = 14;
ear_reach = 3;
ear_pilot_depth = 8;

ear_centers = [
    [-ear_reach, -ear_reach],
    [outer_x + ear_reach, -ear_reach],
    [-ear_reach, outer_y + ear_reach],
    [outer_x + ear_reach, outer_y + ear_reach]
];

module orejita_tapa_v1(p) {
    difference() {
        translate([p[0], p[1], 0])
            cylinder(h = box_ext_height, d = ear_d, $fn = 48);
        // Piloto entrando desde Z=0 (el borde) hacia arriba - INVERTIDO
        // respecto a base_0A (alla entraba desde el tope hacia abajo).
        translate([p[0], p[1], -1])
            cylinder(h = ear_pilot_depth + 1, d = ear_pilot_d, $fn = 32);
    }
}

module orejitas_tapa_v1() {
    for (p = ear_centers) orejita_tapa_v1(p);
}

module tapa_v1() {
    difference() {
        // Cascaron: solido completo, con la cavidad tallada ABIERTA
        // HACIA ABAJO (Z=0, el borde) en vez de hacia arriba como en
        // base_0A. El techo (espesor floor_thickness) queda arriba,
        // de box_ext_height-floor_thickness a box_ext_height.
        difference() {
            cube([outer_x, outer_y, box_ext_height]);
            translate([wall, wall, -1])
                cube([outer_x - 2*wall, outer_y - 2*wall,
                      box_ext_height - floor_thickness + 1]);
        }

        // ---- Calados de LED (agujero vertical, a traves del techo) ----
        // CORREGIDO v1 (2da vuelta): se ven desde arriba - cilindro
        // vertical (eje Z) atravesando el techo, en la posicion X,Y
        // real de cada LED.
        translate([led_D2[0] + offset_x, led_D2[1] + offset_y, box_ext_height - floor_thickness - 1])
            cylinder(h = floor_thickness + 2, d = led_hole_d, $fn = 32);
        translate([led_D3[0] + offset_x, led_D3[1] + offset_y, box_ext_height - floor_thickness - 1])
            cylinder(h = floor_thickness + 2, d = led_hole_d, $fn = 32);

        // ---- Ranuras "U invertida" (abiertas hasta Z=0) ----
        // Pared trasera (y=0): J1 y J5
        translate([mx(conn_J1_x_kicad) + offset_x - conn_J1_w/2, -1, 0])
            cube([conn_J1_w, wall + 2, conn_J1_top_z]);

        translate([mx(conn_J5_x_kicad) + offset_x - conn_J5_w/2, -1, 0])
            cube([conn_J5_w, wall + 2, conn_J5_top_z]);

        // Pared frontal (y=outer_y): J2 (ranura abierta)
        translate([mx(conn_J2_x_kicad) + offset_x - conn_J2_w/2, outer_y - wall - 1, 0])
            cube([conn_J2_w, wall + 2, conn_J2_top_z]);

        // Pared X=0 ("lado izquierdo", junto a los LEDs): USB-C
        // (ranura abierta). CORREGIDO v1: antes en la pared X=outer_x.
        translate([-1, conn_usbc_y + offset_y - conn_usbc_w/2, 0])
            cube([wall + 2, conn_usbc_w, conn_usbc_top_z]);

        // ---- Ventana cerrada tradicional: J4 (unica excepcion) ----
        translate([mx(conn_J4_x_kicad) + offset_x, outer_y - wall - 1, conn_J4_sma_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            capsula_2d(conn_J4_slot_w, conn_J4_slot_h);
    }
}

tapa_v1();
orejitas_tapa_v1();
