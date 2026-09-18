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

// ---------- PARAMETROS DE LA PLACA ----------
// Fuente: Gerber Files V1 (ver nota arriba).
board_x = 90.3;           // ancho de la placa (mm) - ACTUALIZADO 2026-09-17 (era 92.0), igual que base_V1.scad
board_y = 85.0;          // alto de la placa (mm)
board_thickness = 1.6;   // espesor del PCB (mm)

// ---------- PARAMETROS DEL GABINETE ----------
wall = 3.0;              // espesor de pared, hacia afuera (mm)
floor_thickness = 3.0;   // espesor del TECHO de esta pieza (misma constante
                         // que "floor_thickness" en base_V1.scad, reutilizada
                         // aca para la plancha solida del otro extremo)
clearance_xy = 1.5;      // holgura alrededor de la placa (mm)
floor_to_board = 3;      // igual que en base_V1.scad (altura de las torretas)

// AJUSTE 2026-09-18 (instruccion final de Damian): la ALTURA TOTAL
// EXTERIOR de esta pieza debe ser exactamente 25mm (antes el
// requisito era que la altura LIBRE interna llegara a 25mm, lo que
// daba una altura exterior de 28mm - ese criterio queda reemplazado
// por este). Con floor_thickness=3mm de techo, la altura libre
// interna resultante ahora es 25-3 = 22mm (antes 25mm).
box_ext_height = 25.0;   // altura EXTERIOR de la cubierta (antes 28.0, y 20.0 en base_0A)
// Verificacion: altura libre resultante = box_ext_height - floor_thickness
altura_libre_verificacion = box_ext_height - floor_thickness; // = 22.0mm

// Verificacion de que ninguna ranura/ventana choca con el techo (que
// ahora arranca en Z=22mm en vez de Z=25mm): la ranura/ventana mas
// alta es USB-C (top_z=17.11mm) y J4 (tope=conn_J4_sma_z+slot_h/2=
// 17.6mm) - ambas quedan con margen (22-17.6=4.4mm minimo) antes de
// tocar el techo. J1J5 (16.5mm) y J2 (14.6mm) tienen aun mas margen.
// No hace falta cambiar ningun calado.

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
// COORDENADAS FINALES (2026-09-17, dadas directamente por Damian):
// D2 = (3.5, 64.86), D3 = (3.5, 72.3). Estos valores de Y son
// DISTINTOS de los que se habian verificado antes contra el
// .kicad_pcb (17.6 / 10.16) - Damian los dio como definitivos para
// este archivo, se usan tal cual sin cuestionar el origen del cambio.
led_D2 = [mx(3.5), 64.86];
led_D3 = [mx(3.5), 72.3];
led_hole_d = 6.0; // LED 5mm + 0.5mm de holgura por lado (igual que tapa_0B.scad)

// ---------- CONECTORES ----------
// Posiciones X/Y: identicas a las verificadas en base_0B.scad contra
// Modulo_SIMA7670SA.kicad_pcb (definitivo) - NO se espejan (ver
// encabezado). Lo que cambia respecto a base_0B son las alturas Z
// (recalculadas desde pcb_top_z_from_rim) y la forma de la ventana:
// "U invertida" abierta hasta Z=0 para J1/J5/J2/USB-C, ventana
// cerrada tradicional para J4.

// --- J1 + J5 (borne de alimentacion + jack DC barrel, UNA SOLA ranura
// continua, pared Y=85 = "lado izquierdo") ---
// ACTUALIZADO 2026-09-18 (coordenadas reales y definitivas dadas por
// Damian): la ranura abarca exactamente X=9mm a X=32mm sobre la pared
// Y=85mm (reemplaza los dos rectangulos separados que tenia antes,
// uno por conector - ahora J1 y J5 comparten una unica ranura "U
// invertida" continua).
conn_J1J5_slot_x1 = 9;
conn_J1J5_slot_x2 = 32;
conn_J1J5_slot_w = conn_J1J5_slot_x2 - conn_J1J5_slot_x1;                 // = 23mm
conn_J1J5_slot_center_x = (conn_J1J5_slot_x1 + conn_J1J5_slot_x2) / 2;    // = 20.5mm
// Altura Z: se mantienen los calculos previos (sin cambios) para cada
// conector - J1 = pcb_top_z_from_rim + 11.4(cuerpo real, sin pin) +
// 0.5(holgura) = 16.5mm; J5 = pcb_top_z_from_rim + 11(cuerpo real) +
// 0.5(holgura) = 16.1mm. Como ahora es UNA sola ranura para los dos,
// se usa la mas alta de las dos (J1, 16.5mm) para que ambos conectores
// queden cubiertos.
conn_J1_top_z = pcb_top_z_from_rim + 11.4 + 0.5; // = 16.5mm
conn_J5_top_z = pcb_top_z_from_rim + 11 + 0.5;   // = 16.1mm
conn_J1J5_slot_top_z = max(conn_J1_top_z, conn_J5_top_z); // = 16.5mm

// --- J2 (DB9 hembra 90 grados, pared Y=0 = "lado derecho") ---
// ACTUALIZADO 2026-09-18 (coordenadas reales y definitivas dadas por
// Damian): la ranura abarca exactamente X=9mm a X=42mm sobre la pared
// Y=0mm (reemplaza el ancho calculado por holgura que tenia antes).
conn_J2_slot_x1 = 9;
conn_J2_slot_x2 = 42;
conn_J2_w = conn_J2_slot_x2 - conn_J2_slot_x1;              // = 33mm
conn_J2_x_center = (conn_J2_slot_x1 + conn_J2_slot_x2) / 2; // = 25.5mm
// NOTA: el alto de calado J2 (10mm) NO viene de una holgura de 0.5mm
// sobre un dato de datasheet limpio - es el valor heredado (carcasa
// real ~8.36mm + margen ya generoso). Se usa tal cual como techo de
// la ranura abierta - SIN CAMBIOS (altura Z ya calculada, se mantiene).
conn_J2_h = 10;
conn_J2_top_z = pcb_top_z_from_rim + conn_J2_h; // = 14.6mm

// --- USB-C de U5 (Black Pill), pared X=0 ("lado frontal", junto a los LEDs) ---
// ACTUALIZADO 2026-09-18 (coordenadas reales y definitivas dadas por
// Damian): la ranura abarca exactamente Y=35mm a Y=42mm sobre la
// pared X=0mm (reemplaza el ancho generico ~10mm que tenia antes).
conn_usbc_slot_y1 = 37;
conn_usbc_slot_y2 = 53;
conn_usbc_w = conn_usbc_slot_y2 - conn_usbc_slot_y1;                 // = 7mm
conn_usbc_y = (conn_usbc_slot_y1 + conn_usbc_slot_y2) / 2;           // = 38.5mm
//
// ALTURA CORREGIDA (2026-09-17, "va mas arriba" - Damian): el valor
// anterior (8.6mm) no tenia en cuenta que la Black Pill (U5) va
// montada sobre un ZOCALO/header, no pegada al PCB principal. El
// propio footprint del U5 en el .kicad_pcb lo dice en su descripcion:
// "default socketed model has height of 8.51mm" - o sea que la
// placa de la Black Pill queda 8.51mm por encima del PCB principal,
// y el conector USB-C esta soldado sobre ESA placa (no sobre la
// principal). Por eso la ranura tiene que llegar mucho mas arriba:
conn_usbc_socket_h = 8.51; // elevacion del zocalo de U5 (dato real del descr del footprint)
conn_usbc_h_body = 3.5;    // alto del propio conector USB-C sobre su placa - SIN VERIFICAR (sin datasheet)
conn_usbc_top_z = pcb_top_z_from_rim + conn_usbc_socket_h + conn_usbc_h_body + 0.5; // = 17.11mm

// --- J4 (SMA, Samtec SMA-J-P-X-RA-TH1), pared Y=0 = "lado derecho" ---
// CORREGIDO 2026-09-17: pasa de la pared Y=85 a la pared Y=0.
// UNICA excepcion: ventana CERRADA tradicional (no ranura abierta),
// segun instruccion explicita de Damian.
conn_J4_x_kicad = 70.680;             // verificado contra Gerber Files V1 (identico a la rev. anterior)
conn_J4_slot_w = 8;    // Ø7.00mm real (buja roscada) + 0.5mm/lado, ver base_0B
// Alto AUMENTADO 2026-09-17 (pedido de Damian): 10 -> 15mm. Sigue sin
// estar atado a una cota limpia del datasheet Samtec (el plano trae
// varias cotas apiladas para las vistas de un conector acodado, no
// se pudo determinar con confianza cual usar) - este valor es una
// decision directa de Damian, no una holgura calculada.
conn_J4_slot_h = 15;
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
        // Pared Y=85 ("lado izquierdo"): J1+J5, UNA sola ranura continua
        // X=9 a X=32mm (coordenadas reales y definitivas, 2026-09-18).
        translate([mx(conn_J1J5_slot_center_x) + offset_x - conn_J1J5_slot_w/2, outer_y - wall - 1, 0])
            cube([conn_J1J5_slot_w, wall + 2, conn_J1J5_slot_top_z]);

        // Pared Y=0 ("lado derecho"): J2, ranura X=9 a X=42mm
        // (coordenadas reales y definitivas, 2026-09-18)
        translate([mx(conn_J2_x_center) + offset_x - conn_J2_w/2, -1, 0])
            cube([conn_J2_w, wall + 2, conn_J2_top_z]);

        // Pared X=0 ("lado frontal", junto a los LEDs): USB-C
        // (ranura abierta). CORREGIDO v1: antes en la pared X=outer_x.
        translate([-1, conn_usbc_y + offset_y - conn_usbc_w/2, 0])
            cube([wall + 2, conn_usbc_w, conn_usbc_top_z]);

        // ---- Ventana cerrada tradicional: J4 (unica excepcion) ----
        // Pared Y=0 ("lado derecho") - CORREGIDO 2026-09-17: paso de
        // la pared Y=85.
        translate([mx(conn_J4_x_kicad) + offset_x, -1, conn_J4_sma_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            capsula_2d(conn_J4_slot_w, conn_J4_slot_h);
    }
}

tapa_v1();
orejitas_tapa_v1();
