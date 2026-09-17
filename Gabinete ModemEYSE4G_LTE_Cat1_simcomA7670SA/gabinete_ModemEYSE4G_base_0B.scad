// ============================================================
// Gabinete - ModemEYSE4G_LTE_Cat1_simA7670SA - BASE (v0B)
// Pieza separada: solo la base (paredes + piso + parantes de
// montaje + calados de conectores laterales). La tapa esta en
// el archivo gabinete_ModemEYSE4G_tapa_6.scad
// Sistema de coordenadas: origen en la esquina inferior
// izquierda de la placa (0,0), igual que se referencia en
// la conversacion de diseno.
//
// Cambios respecto a base_9: el ancho de la ranura de J4 (SMA)
// paso de 6mm a 7mm (alto sin cambios, 10mm).
//
// Cambios v0A -> v0B: actualizados los parantes de montaje
// (H1-H4) y el ancho de placa (board_x) con los datos del PCB
// "definitivo": Modulo_SIMA7670SA.kicad_pcb en
// GPRS_SIM_A7670SA_kicad/Modulo_SIMA7670SA/ (leido 2026-09-16).
// La placa crecio de 90.3mm a 92.0mm de ancho (se agrego material
// del lado derecho, X mayor); por eso H3 y H4 se movieron y H1/H2
// quedaron identicos. Ver seccion "MOUNTING HOLES" mas abajo para
// el detalle punto por punto. Los calados de conectores (J1/J2/J4/
// J5/USB-C) NO fueron re-verificados contra este PCB nuevo en este
// cambio - quedan con los valores de 0A, revisar aparte si el
// ancho de placa mayor los afecta.
//
// CORRECCION v0B (aclaracion de Damian): la placa va montada con
// los componentes mirando hacia ARRIBA (+Z), en su orientacion
// natural de diseno - es decir, coincide directamente con la vista
// superior estandar de KiCad (F.Cu tal cual se ve en el editor).
// Por lo tanto NO corresponde espejar en X. mirror_x se puso en
// false (antes estaba en true por error, asumiendo que habia que
// compensar un volteo boca abajo que en realidad no existe). Ver
// seccion "ESPEJADO EN X" mas abajo.
//
// Verificacion v0B - 1ra pasada (solo posiciones, contra el
// .kicad_pcb): se contrastaron LEDs D2/D3 y conectores J1/J5/J2/J4/
// U5(USB-C) contra las posiciones reales de Modulo_SIMA7670SA.kicad_pcb
// (definitivo). Resultado: D2, D3, J5, J2, J4, USB-C ya estaban
// correctos (diferencia <= 0.05mm). J1 estaba MAL, desfasado 5.0mm en
// X (23.7 -> 28.70mm, un paso de pitch completo) - corregido.
//
// Verificacion v0B - 2da pasada (tamanos de calado, con datasheets
// reales que aporto Damian: Phoenix 1935161, Same Sky PJ-002A,
// Linkman DB9, Samtec SMA-J-P-X-RA-TH1, plano "MiniF4x1Cx_V31 Board
// Shape"): se recalcularon los calados a partir de las dimensiones
// fisicas reales de cada conector + 0.5mm de holgura por lado.
// Resultado:
//   - J1: calado 20x11mm -> 11x12.4mm (cuerpo real Phoenix: ancho
//     10mm, alto sin pin de soldadura 11.4mm).
//   - J5: calado 20x11mm -> 10x12mm (cuerpo real Same Sky PJ-002A,
//     vista frontal de la carcasa: 9x11mm).
//   - J2: ancho 30mm -> 31.8mm. El datasheet Linkman (fila "09") da
//     30.81mm de ancho total de brida con jackscrews - el valor viejo
//     (30mm) quedaba por DEBAJO del cuerpo real, es decir sin holgura
//     real (posible interferencia). Alto (10mm) ya sobraba frente al
//     cuerpo real (8.36mm) - sin cambios.
//   - J4: ancho de ranura 7mm -> 8mm. El datasheet Samtec da Ø7.00mm
//     de buja/tuerca roscada - iguales al ancho viejo, o sea CERO
//     holgura real. Alto (10mm) se dejo SIN VERIFICAR: el plano trae
//     varias cotas de altura apiladas para las vistas de un conector
//     acodado y no se pudo determinar con confianza cual corresponde
//     al alto real que debe atravesar la pared - revisar con Damian.
//   - USB-C (U5): confirmado con doble chequeo (anchor + geometria de
//     courtyard del footprint) que 44.1mm ya era exacto - sin cambios.
//   - LEDs D2/D3: posiciones ya exactas, sin cambios. Diametro de
//     calado 5.5mm -> 6.0mm (5mm LED + 0.5mm de holgura por lado, ver
//     tapa_0B.scad).
// ============================================================

// ---------- PARAMETROS DE LA PLACA ----------
board_x = 92.0;         // ancho de la placa (mm) - ACTUALIZADO v0B: la placa
                        // "definitiva" crecio de 90.3 a 92.0mm (creci fue
                        // por el lado derecho / X mayor en KiCad)
board_y = 85.0;         // alto de la placa (mm) - sin cambios respecto a 0A
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
// La placa va montada con la cara de componentes hacia arriba (+Z),
// en su orientacion natural de diseno: esto coincide DIRECTAMENTE
// con la vista superior estandar de KiCad (F.Cu tal cual se dibuja
// en el editor), sin necesidad de voltearla boca abajo. Por lo tanto
// NO hace falta espejar en X - las coordenadas crudas de KiCad se
// usan tal cual.
// CORRECCION v0B: mirror_x estaba en true en el archivo 0A (asumia
// que habia que compensar un volteo de la placa que en realidad no
// aplica). Aclaracion de Damian: mantener la orientacion natural
// mirando hacia arriba, sin espejo.
// Las coordenadas "_kicad" que siguen abajo son las crudas, tal cual
// figuran en el .kicad_pcb - no las toques a mano, pasan por mx()
// antes de usarse (que ahora es identidad, mx(x) = x).
mirror_x = false;
function mx(x) = mirror_x ? (board_x - x) : x;

// ---------- MOUNTING HOLES ----------
// Coordenadas crudas de KiCad (relativas al origen 0,0 de la placa,
// que es la esquina del gr_rect de Edge.Cuts en el .kicad_pcb).
//
// ACTUALIZADO v0B desde Modulo_SIMA7670SA.kicad_pcb (PCB "definitivo",
// carpeta GPRS_SIM_A7670SA_kicad/Modulo_SIMA7670SA/), leido 2026-09-16.
// Se verifico por uuid de footprint que son los mismos 4 taladros que
// en 0A (ningun agujero nuevo/eliminado), solo H3 y H4 cambiaron de
// posicion:
//   H1: sin cambios      (4.0, 81.0) -> (4.0, 81.0)
//   H2: sin cambios      (4.1, 4.1)  -> (4.1, 4.1)
//   H3: se movio         (86.2, 4.1) -> (87.6, 4.3)   [+1.4 X, +0.2 Y]
//   H4: se movio         (86.3, 80.9) -> (87.7, 80.6) [+1.4 X, -0.3 Y]
// (H1: esquina inferior izquierda, H2: superior izquierda,
//  H3: superior derecha, H4: inferior derecha)
mount_hole_H1_x = 4.0;
mount_hole_H1_y = 81.0;
mount_hole_H2_x = 4.1;
mount_hole_H2_y = 4.1;
mount_hole_H3_x = 87.6;
mount_hole_H3_y = 4.3;
mount_hole_H4_x = 87.7;
mount_hole_H4_y = 80.6;

mount_holes_kicad = [
    [mount_hole_H1_x, mount_hole_H1_y],   // H1
    [mount_hole_H2_x, mount_hole_H2_y],   // H2
    [mount_hole_H3_x, mount_hole_H3_y],   // H3
    [mount_hole_H4_x, mount_hole_H4_y]    // H4
];
// Con mirror_x = false, mx() es identidad: los parantes quedan en las
// mismas coordenadas crudas de KiCad (mas el offset_x/offset_y de
// holgura, aplicado despues en base_gabinete()).
mount_holes = [ for (p = mount_holes_kicad) [mx(p[0]), p[1]] ];
mount_hole_d = 4.0;     // diametro del taladro NPTH (confirmado en drill file del
                        // PCB definitivo - sin cambios respecto a 0A)
standoff_od = 8.0;      // diametro externo del standoff/boss - AJUSTAR a gusto
screw_d = 3.0;          // diametro de tornillo autorroscante - CONFIRMAR con Damian

// ---------- CONECTORES ----------
// Coordenadas X crudas de KiCad, ya pasadas por mx() abajo.
// Cada conector tiene su propia altura de calado en Z, medida desde
// pcb_top_z segun lo definido con Damian.
//
// NOTA v0B: estos valores NO fueron re-verificados contra el PCB
// definitivo (Modulo_SIMA7670SA.kicad_pcb en .../Modulo_SIMA7670SA/).
// Ademas, con la correccion de mirror_x = false, mx() ya no espeja
// (es identidad) - estas posiciones dejaron de correrse por el
// mirror, pero siguen siendo las coordenadas crudas de 0A, no las
// del PCB definitivo. Revisar contra el PCB definitivo antes de
// fabricar.

// J1 y J5 (alimentacion): calados rectangulares en la pared trasera
// (y=0). Alturas por conector, ver debajo. Se separan del antiguo
// conn_J1J5_h compartido: J1 y J5 son conectores fisicamente
// distintos (borne vs. barrel jack) con cuerpos de distinta altura,
// ahora con datos de datasheet respaldando cada uno (verificado
// v0B con los datasheets de Phoenix Contact 1935161 y Same Sky
// PJ-002A que aporto Damian).

// J1 (borne de alimentacion, Terminal Block Phoenix PT-1,5/2-5,0-H,
// part 1935161): dimensiones REALES del datasheet Phoenix (pag. 3):
// Width[w]=10mm (ancho, a lo largo de la fila de pines - cruzado y
// confirmado con el courtyard del footprint en KiCad: 11mm - 0.5mm*2
// de margen automatico = 10mm), Height sin pin de soldadura = 11.4mm
// (alto real sobre la placa, Z). Calado = cuerpo + 0.5mm de holgura
// por lado en cada dimension.
conn_J1_w = 10 + 2*0.5;   // = 11mm
conn_J1_h = 11.4 + 2*0.5; // = 12.4mm
conn_J1_z = pcb_top_z + conn_J1_h/2;
// Posicion X: verificada contra Modulo_SIMA7670SA.kicad_pcb (definitivo).
// J1 absoluto = (143.56, 65.16) -> relativo a origen de placa
// (114.86, 60.66) = (28.70, 4.50). CORREGIDO v0B: el valor anterior
// (23.7) estaba mal, desfasado 5.0mm en X (un paso de pitch completo
// del terminal de 5mm).
conn_J1_x_kicad = 28.7;
conn_J1_terminal = [mx(conn_J1_x_kicad), conn_J1_w, conn_J1_h]; // pared trasera (y=0)

// J5 (jack DC barrel, Same Sky/CUI PJ-002A - el .kicad_pcb referencia
// el footprint generico "PJ-102AH" pero el datasheet real que aporto
// Damian es el PJ-002A): dimensiones REALES del datasheet (pag. 2,
// vista frontal de la carcasa): ancho 9.00mm x alto 11.00mm (incluye
// el cuerpo completo del jack, que al ser montaje PCB en angulo recto
// -no panel-mount- necesita pasar entero por la pared, no solo el
// cuello del conector). Calado = cuerpo + 0.5mm de holgura por lado.
conn_J5_w = 9 + 2*0.5;    // = 10mm
conn_J5_h = 11 + 2*0.5;   // = 12mm
conn_J5_z = pcb_top_z + conn_J5_h/2;
// Posicion X verificada: real relativo = 14.91mm (absoluto
// 129.771,71.106 menos origen 114.86,60.66), coincide con el valor
// ya existente (14.9), sin cambios.
conn_J5_barrel = [mx(14.9), conn_J5_w, conn_J5_h]; // pared trasera (y=0)

// J4 (SMA, Samtec SMA-J-P-X-RA-TH1): ranura tipo capsula (rectangulo
// con extremos redondeados). Centro en Z igualado al criterio de
// J1/J5 (13.1mm) para que entre con margen dentro de la caja de 20mm.
//
// AJUSTE v0B: el datasheet de Samtec (sma-j-p-x-ra-th1-mkt.pdf) da el
// diametro de la buja/tuerca roscada del conector como Ø7.00mm (REF).
// Como este conector es montaje PCB en angulo recto (no panel-mount:
// no tiene una brida separada que se apoye afuera de la pared), el
// cuerpo completo -incluida esa buja de Ø7.00mm- tiene que atravesar
// la pared. Con el ancho anterior (7mm, igual al diametro real) la
// holgura era CERO - directamente no iba a entrar. Se amplia a 8mm
// (7mm + 0.5mm de holgura por lado) para cumplir el criterio de
// holgura del resto del gabinete.
conn_J4_slot_w = 8;   // ancho de la ranura (CORREGIDO v0B: antes 7mm, sin holgura real)
// NOTA v0B: el alto de la ranura (10mm) NO se toco. El plano de
// Samtec trae varias cotas de altura apiladas (13.80/15.10/11.60mm
// entre otras) para las distintas vistas de un conector acodado, y no
// pude determinar con confianza cual de ellas corresponde al alto
// real que debe atravesar la pared sin arriesgar un valor incorrecto.
// Revisar visualmente con Damian contra el dibujo antes de imprimir
// (el valor actual, 10mm, viene de su dibujo de referencia previo,
// no de este datasheet).
conn_J4_slot_h = 10;  // alto de la ranura (capsula vertical) - SIN VERIFICAR contra datasheet
// Posicion verificada v0B contra el PCB definitivo: real relativo =
// 70.68mm (absoluto 185.54,141.3 menos origen 114.86,60.66), coincide
// con el valor existente (70.7), sin cambios.
conn_J4_sma_x = mx(70.7);           // pared frontal (y=board_y)
// Altura Z de referencia: se mantiene el mismo valor de diseno
// original (13.1mm = pcb_top_z + 11/2), usado como criterio de
// alineacion visual con J1/J5 desde el archivo original - el 11mm
// aca es solo esa referencia historica, no el alto real de J4 (que
// sigue siendo conn_J4_slot_h = 10mm). CORREGIDO v0B: el valor
// anterior citaba la variable conn_J1J5_z, que ya no existe porque
// J1 y J5 pasaron a tener alturas propias (conn_J1_h/conn_J5_h);
// esto dejaba una referencia rota. Se reemplaza por el numero fijo
// que esa variable representaba, sin cambiar el resultado.
conn_J4_sma_z = pcb_top_z + 11/2;   // = 13.1mm

// J2 (DB9 hembra a 90 grados): calado rectangular. Arranca justo a la
// altura del piso del PCB (pcb_top_z) y sube conn_J2_h.
// (Revision pedida por Damian sobre base_8: antes arrancaba a 2.5mm
// sobre el piso del PCB con 8.4mm de alto y 25mm de ancho).
//
// AJUSTE v0B: datasheet Linkman "DB9 hembra 90 PCB" (tabla por
// cantidad de posiciones, fila "09"): ancho total de la brida con
// las orejas de los tornillos jackscrew = 30.81mm (columna C). Es
// montaje PCB en angulo recto (sin brida que se apoye afuera de la
// pared), asi que el cuerpo completo -orejas incluidas- atraviesa la
// pared. El ancho anterior (30mm) quedaba 0.81mm por debajo del
// cuerpo real, es decir CASI SIN holgura (y potencialmente
// interferencia). Se amplia a 31.8mm (30.81 + 0.5mm por lado,
// redondeado). Alto: el cuerpo/carcasa metalica mide 8.36mm (vista
// frontal del mismo datasheet) - el valor existente (10mm) ya lo
// cubre con margen de sobra, sin cambios.
conn_J2_w = 30.81 + 2*0.5; // = 31.81mm, redondeado a 31.8mm (CORREGIDO v0B: antes 30mm)
conn_J2_h = 10;
conn_J2_z_start = pcb_top_z;                // = 7.6mm
conn_J2_z = conn_J2_z_start + conn_J2_h/2;  // = 12.6mm
// Posicion verificada v0B contra el PCB definitivo: real relativo =
// 30.96mm (absoluto 145.82,137.49 menos origen 114.86,60.66), coincide
// con el valor existente (31.0), sin cambios.
conn_J2_db9 = [mx(31.0), conn_J2_w, conn_J2_h]; // pared frontal (y=board_y)

// USB-C de U5 (Black Pill): pared derecha, a 44.1mm a lo largo del eje Y.
// OJO: tal como esta este bloque (igual al archivo subido), el calado
// real en el modulo mas abajo usa conn_J2_db9[2] (8.4mm, la altura de
// J2) en vez de conn_J1J5_h (11mm) - quedo pendiente de esa correccion,
// que se discutio en el mensaje anterior y todavia no se aplico aca.
conn_usbc_w = 10;
conn_usbc_h = 5; // valor sin usar actualmente por el bug mencionado arriba
conn_usbc_z = pcb_top_z + 7.5;
// Posicion verificada v0B con doble chequeo (no solo el anchor del
// footprint, sino el offset real del conector dentro de el):
// 1) footprint U5 absoluto (142.18,104.76) -> relativo = 44.10mm en Y.
// 2) El courtyard del footprint U5 en el .kicad_pcb trae una muesca
//    local (fp_poly en F.CrtYd) centrada en X_local=0 que sobresale
//    del contorno principal de la placa - es el hueco del propio
//    USB-C del modulo "MiniF4x1Cx" (Black Pill), consistente con el
//    plano "MiniF4x1Cx_V31 Board Shape.pdf" que aporto Damian (placa
//    52.81 x 20.78mm, USB-C centrado en el lado corto). Con la
//    rotacion de 90 grados de U5, ese centro local (X_local=0)
//    mapea a un offset CERO en el eje Y global (mx no aplica en Y) -
//    es decir, el USB-C queda exactamente en el Y del anchor, sin
//    corrimiento adicional. Confirma matematicamente que 44.1mm ya
//    era el valor correcto. Sin cambios.
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

// Forma "capsula" (estadio): rectangulo con extremos semicirculares,
// orientada verticalmente (alto > ancho). Usada para la ranura de J4.
module capsula_2d(w, h) {
    hull() {
        translate([0, (h - w) / 2]) circle(d = w, $fn = 48);
        translate([0, -(h - w) / 2]) circle(d = w, $fn = 48);
    }
}

// Dimensiones exteriores totales de la caja
outer_x = board_x + 2 * (wall + clearance_xy);
outer_y = board_y + 2 * (wall + clearance_xy);
offset_x = wall + clearance_xy; // offset del (0,0) de la placa dentro de la caja
offset_y = wall + clearance_xy;

// ---------- OREJITAS DE SUJECION TAPA-BASE ----------
// 4 orejitas externas al contorno de la placa, una en cada vertice de
// la caja, para unir tapa y base con tornillo de 5/32" (3.97mm).
// Posicionadas por fuera del rectangulo exterior (no chocan con los
// parantes H1-H4, que estan del lado de adentro).
ear_screw_d = 3.97;      // 5/32" en mm
ear_pilot_d = 3.4;       // agujero piloto en la base para autorroscante
ear_clearance_d = 4.3;   // agujero pasante en la tapa (holgura sobre el tornillo)
ear_d = 14;              // diametro de la orejita
ear_reach = 3;           // cuanto se corre el centro de la orejita mas alla
                          // del vertice de la caja (mantiene solape con la
                          // pared para que quede bien pegada, no solo tangente)
ear_pilot_depth = 8;      // profundidad del agujero piloto en la base

// Centros de las 4 orejitas (vertices de la caja, corridos hacia afuera)
ear_centers = [
    [-ear_reach, -ear_reach],
    [outer_x + ear_reach, -ear_reach],
    [-ear_reach, outer_y + ear_reach],
    [outer_x + ear_reach, outer_y + ear_reach]
];

module orejita_base(p) {
    difference() {
        // La orejita abarca toda la altura de la caja, pegada a la
        // esquina para quedar bien unida estructuralmente
        translate([p[0], p[1], 0])
            cylinder(h = box_ext_height, d = ear_d, $fn = 48);
        // Agujero piloto autorroscante, entrando desde arriba
        translate([p[0], p[1], box_ext_height - ear_pilot_depth])
            cylinder(h = ear_pilot_depth + 1, d = ear_pilot_d, $fn = 32);
    }
}

module orejitas_base() {
    for (p = ear_centers) orejita_base(p);
}

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
        translate([conn_J1_terminal[0] + offset_x, -1, conn_J1_z])
            rotate([-90,0,0])
            linear_extrude(height = wall + 2)
            square([conn_J1_terminal[1], conn_J1_terminal[2]], center = true);

        translate([conn_J5_barrel[0] + offset_x, -1, conn_J5_z])
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
            linear_extrude(height = wall + 2)
            capsula_2d(conn_J4_slot_w, conn_J4_slot_h);

        // USB-C de U5: pared derecha (x = outer_x), a lo largo del eje Y.
        translate([
            outer_x - wall - 1, conn_usbc_y + offset_y - conn_usbc_w/2,
            conn_usbc_z - conn_J2_db9[2]/2 - 3 ])
        cube([wall + 2, conn_usbc_w, conn_J2_db9[2]]);
    }
}

base_gabinete();
orejitas_base();
