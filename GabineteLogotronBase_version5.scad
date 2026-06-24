// =======================================
// Caja sin tapa ni pared lateral derecha
// =======================================

largo_interno = 190;   // mm
ancho_interno = 87;    // mm
alto_interno  = 20;    // mm

pared = 3;             // espesor paredes laterales
base_espesor = 5;      // espesor base

// Dimensiones externas calculadas
largo = largo_interno + 2*pared;       // 196 mm
ancho = ancho_interno + 2*pared;       // 93 mm
alto  = alto_interno + base_espesor;   // 25 mm

ranura_largo = 120;
ranura_alto = 20;

module caja_sin_tapa_y_lado_derecho(l, a, h, t, base_t) {

difference() {

    // Caja exterior completa
    translate([-l/2, -a/2, 0])
        cube([l, a, h]);

    // Hueco interior
    translate([-l/2 + t, -a/2 + t, base_t])
        cube([l - 2*t, a - 2*t, h - base_t]);

    // Ranura frontal
    translate([-40, -a/2 - 0.1, h - ranura_alto])
        cube([ranura_largo, t + 0.2, ranura_alto]);

    // Ranura trasera
    translate([-40, a/2 - t - 0.1, h - ranura_alto])
        cube([ranura_largo, t + 0.2, ranura_alto]);

    // Eliminar tapa superior
    translate([-l/2 - 0.1, -a/2 - 0.1, h - t])
        cube([l + 0.2, a + 0.2, t + 0.2]);

    // Eliminar pared lateral derecha
    translate([l/2 - t - 0.1, -a/2 - 0.1, -0.1])
        cube([t + 0.2, a + 0.2, h]);
}
        
}
// Llamada principal
caja_sin_tapa_y_lado_derecho(largo, ancho, alto, pared, base_espesor);

