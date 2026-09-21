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
//   a) box_ext_height ajustado (ver historial mas abajo, ultimo valor:
//      25mm de altura EXTERIOR total, instruccion final de Damian).
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
//   1) LEDs D2/D3: se habia intentado calarlos como agujero HORIZONTAL
//      en la pared X=0 (por su rotacion -90 en el .kicad_pcb) - esto
//      se REVIRTIO despues (ver mas abajo): Damian aclaro que se ven
//      desde ARRIBA, van como agujero VERTICAL en el techo.
//   2) USB-C de U5: estaba calado en la pared X=outer_x. Damian
//      confirmo que el USB-C va del MISMO lado que los LEDs (pared
//      X=0, "lado frontal"). Se corrige: se mueve el calado a la
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
//   ahi.
//
// TERMINOLOGIA Y UBICACION DEFINITIVA (2026-09-17, version final dada
// por Damian - pisa cualquier lectura anterior de fotos/renders):
//   Frontal = X=0 (LEDs D2/D3 + USB-C)
//   Izquierdo = Y=85 (J1 + J5) - CORREGIDO: antes J2/J4
//   Derecho = Y=0 (J2 + J4) - CORREGIDO: antes J1/J5
//   Trasero = X=90.3 (vacio)
// LEDs: coordenadas finales dadas directamente por Damian, D2=(3.5,
// 64.86), D3=(3.5,72.3) - distintas de las que se habian verificado
// contra el .kicad_pcb (17.6/10.16).
//
// CAMBIO DE FUENTE DE DATOS (2026-09-17, decision explicita de
// Damian): de aca en mas se usa la revision "Gerber Files V1" del PCB
// (GPRS_SIM_A7670SA_kicad/Gerber Files V1/Modulo_SIMA7670SA.kicad_pcb,
// placa 90.30 x 85.00mm), NO la revision "definitiva" de 92.0mm usada
// hasta el paso anterior. Damian aporto una tabla de coordenadas ya
// verificada dato por dato contra ese archivo:
//   J1 (23.726,4.446)  J2 (30.960,76.830)  J3/U.FL (70.685,74.395)
//   J4 (70.680,80.640) J5 (14.911,10.446)  D2 (3.500,17.600)
//   D3 (3.500,10.160)  H1-H4 (ver base_V1.scad)
// El unico cambio real de posicion relevante para este archivo es J1
// (antes 28.7mm en X, ahora 23.726mm - la revision "Gerber V1" tiene
// el borne de alimentacion en otro lugar que la revision "definitiva").
// J5, J2, J4, D2, D3 dan practicamente identicos entre ambas
// revisiones del PCB. J3/U.FL es un conector interno (antena), NO
// necesita calado en el gabinete - se deja documentado, sin cutout.
// board_x paso de 92.0 a 90.30mm (afecta outer_x y el ancho de la
// pared X=0/X=outer_x, pero NO reposiciona J1/J5/J2/J4 porque estan
// todos referenciados por su propia coordenada, no por board_x).
// ============================================================


// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - TAPA/CUBIERTA V1.7
// (RESTAURACIÓN: Ventana cerrada tradicional para J4 hasta Z=15mm máx)
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 90.3;           // ancho de la placa (mm) - Gerber Files V1
board_y = 85.0;          // alto de la placa (mm)
board_thickness = 1.6;   // espesor del PCB (mm)

// ---------- PARAMETROS DEL GABINETE RECORTADO ----------
wall = 3.0;              // espesor de las paredes que bajan del techo (mm)
floor_thickness = 3.0;   // espesor del TECHO de esta pieza (mm)
floor_to_board = 3;      // altura de las torretas de soporte en la base (mm)

// ---------- ALTURA FIJA DEL GABINETE (EJE Z) ----------
altura_interior_tapa = 20.0 + board_thickness + floor_to_board; // = 24.6mm
box_ext_height = altura_interior_tapa + floor_thickness;       // = 27.6mm

// ---------- MARGENES DE CORTE (Identicos a la Base) ----------
clearance_corte = 0.5; 
outer_x = board_x + 2 * clearance_corte; // = 91.3mm
outer_y = board_y + 2 * clearance_corte; // = 86.0mm
offset_x = clearance_corte; 
offset_y = clearance_corte;

// ---------- LEDS (calado vertical en el TECHO) ----------
mirror_x = false;
function mx(x) = mirror_x ? (board_x - x) : x;

led_D2 = [mx(3.5), 64.86];
led_D3 = [mx(3.5), 72.3];
led_hole_d = 6.0; 

// ---------- DIMENSIONES DE VENTANAS ----------

// 1. USB-C (Pared X = 0, Lado Frontal) -> Rango: 32mm < Y < 47mm ; 0 < Z < 21mm
conn_usbc_y1 = 32.0;
conn_usbc_y2 = 47.0;
conn_usbc_w = conn_usbc_y2 - conn_usbc_y1; 
conn_usbc_center_y = (conn_usbc_y1 + conn_usbc_y2) / 2;
conn_usbc_top_z = 21.0;

// 2. DB9 J2 (Pared Y = 0, Lado Derecho) -> Rango: 10mm < X < 42mm ; 0 < Z < 20mm
conn_J2_x1 = 10.0;
conn_J2_x2 = 42.0;
conn_J2_w = conn_J2_x2 - conn_J2_x1; 
conn_J2_center_x = (conn_J2_x1 + conn_J2_x2) / 2;
conn_J2_top_z = 20.0;

// 3. Alimentación J1/J5 (Pared Y = outer_y, Lado Izquierdo) -> Rango: 8mm < X < 32mm ; 0 < Z < 18mm
conn_J1J5_x1 = 8.0;
conn_J1J5_x2 = 32.0;
conn_J1J5_w = conn_J1J5_x2 - conn_J1J5_x1; 
conn_J1J5_center_x = (conn_J1J5_x1 + conn_J1J5_x2) / 2;
conn_J1J5_top_z = 18.0;

// 4. Antena J4 VENTANA CERRADA TRADICIONAL (Pared Y = 0, Lado Derecho) -> Rango: 67mm < X < 73mm
conn_J4_x1 = 67.0;
conn_J4_x2 = 73.0;
conn_J4_w = conn_J4_x2 - conn_J4_x1; // Ancho nominal = 6mm
conn_J4_center_x = (conn_J4_x1 + conn_J4_x2) / 2;
conn_J4_top_z = 15.0; // Altura máxima al arco superior

// Altura total del cuerpo de la cápsula para la ventana cerrada original (J4 original medía 15mm de alto)
conn_J4_slot_h = 15.0; 
// Ajuste matemático de Z: Centro = Altura máxima (15) - Radio superior (conn_J4_w/2 = 3)
conn_J4_sma_z = conn_J4_top_z - (conn_J4_w / 2); // = 12.0mm

// ============================================================
// MODULOS
// ============================================================

// Módulo cápsula 2D restaurado para la ventana cerrada original de J4
module capsula_2d(w, h) {
    hull() {
        translate([0, (h - w) / 2]) circle(d = w, $fn = 48);
        translate([0, -(h - w) / 2]) circle(d = w, $fn = 48);
    }
}

// ---------- OREJITAS DE SUJECION TAPA-BASE ----------
ear_pilot_d = 3.4;
ear_d = 14;
ear_reach = 3;
ear_pilot_depth = 12; 

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
        translate([p[0], p[1], -1])
            cylinder(h = ear_pilot_depth + 1, d = ear_pilot_d, $fn = 32);
    }
}

module orejitas_tapa_v1() {
    for (p = ear_centers) orejita_tapa_v1(p);
}

// Estructura principal de la Cubierta tipo "Taza Invertida"
module tapa_v1_recortada() {
    difference() {
        // Bloque exterior sólido e interior vaciado
        difference() {
            cube([outer_x, outer_y, box_ext_height]);
            translate([wall, wall, -1])
                cube([outer_x - 2*wall, outer_y - 2*wall,
                      box_ext_height - floor_thickness + 1]);
        }

        // ---- Calados de LED (Verticales en el techo) ----
        translate([led_D2[0] + offset_x, led_D2[1] + offset_y, box_ext_height - floor_thickness - 1])
            cylinder(h = floor_thickness + 2, d = led_hole_d, $fn = 32);
        translate([led_D3[0] + offset_x, led_D3[1] + offset_y, box_ext_height - floor_thickness - 1])
            cylinder(h = floor_thickness + 2, d = led_hole_d, $fn = 32);

        // ---- CORTES EN "U INVERTIDA" RECTANGULARES ----

        // 1. Frente (X = 0): Calado USB-C
        translate([-1, conn_usbc_center_y + offset_y - conn_usbc_w/2, 0])
            cube([wall + 2, conn_usbc_w, conn_usbc_top_z]);

        // 2. Derecha (Y = 0): Calado DB9 J2
        translate([mx(conn_J2_center_x) + offset_x - conn_J2_w/2, -1, 0])
            cube([conn_J2_w, wall + 2, conn_J2_top_z]);

        // 3. Izquierda (Y = outer_y): Calado Alimentación J1/J5
        translate([mx(conn_J1J5_center_x) + offset_x - conn_J1J5_w/2, outer_y - wall - 1, 0])
            cube([conn_J1J5_w, wall + 2, conn_J1J5_top_z]);

        // ---- 4. VENTANA CERRADA TRADICIONAL RESTAURADA PARA J4 (SMA) ----
        // Corta de forma flotante en la pared Y=0 usando el módulo capsula_2d original
        translate([mx(conn_J4_center_x) + offset_x, -1, conn_J4_sma_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            capsula_2d(conn_J4_w, conn_J4_slot_h);
    }
}

// Render final
tapa_v1_recortada();
orejitas_tapa_v1();
