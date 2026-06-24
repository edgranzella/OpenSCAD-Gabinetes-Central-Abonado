// =======================================
// Caja externa (ajustada a medidas internas dadas)
// =======================================

// hueco interior deseado (para encajar la caja interna)
largo_interno = 196.5;
ancho_interno = 93.5;
alto_interno  = 70;

pared = 3;
base  = 5;

// dimensiones externas calculadas automáticamente
largo = largo_interno + 2*pared; // 202.2
ancho = ancho_interno + 2*pared; // 99.2
alto  = alto_interno + base;      // 70.5

ranura_largo = 120;
ranura_alto  = 30;

// Nueva ranura en la base
ranura_base_largo = 82;
ranura_base_ancho = 54;
ranura_base_espesor = 5;

altura_pared_derecha = 20;

module caja_sin_tapa_centrada(l, a, h, pared, base) {
  difference() {
    // Caja exterior centrada
    translate([-l/2, -a/2, 0])
    cube([l, a, h]);

    // Hueco interior (ajustado: base de 5 mm, paredes de 3 mm)
    translate([-l/2 + pared, -a/2 + pared, base])
    cube([l - 2*pared, a - 2*pared, h]);

    // Ranura lado delantero
    translate([-37, -a/2 - 0.1, h - ranura_alto])
    cube([ranura_largo, pared + 0.2, ranura_alto]);

    // Ranura lado trasero
    translate([-37, a/2 - pared - 0.1, h - ranura_alto])
    cube([ranura_largo, pared + 0.2, ranura_alto]);

    // Ranura en la base (centrada en X=-32.5)
    translate([-39 - ranura_base_largo/2, -ranura_base_ancho/2, -0.1])
    cube([ranura_base_largo, ranura_base_ancho, ranura_base_espesor + 0.2]);

    // Eliminar pared lateral derecha
    translate([l/2 - pared - 0.1, -a/2 - 0.1, -0.1])
    cube([pared + 0.2, a + 0.2, h-altura_pared_derecha]);
    }
}

// Llamada principal
caja_sin_tapa_centrada(largo, ancho, alto, pared, base);
