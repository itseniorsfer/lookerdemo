connection: "mi_conexion_base_datos"

include: "/views/*.view.lkml"

# Explore principal para el análisis operativo de ventas y rentabilidad
explore: ventas {
  label: "Ventas y Operaciones"
  description: "Análisis de tickets de venta, productos vendidos y margen de ganancia"

  join: productos {
    type: left_outer
    sql_on: ${ventas.producto_id} = ${productos.id} ;;
    relationship: many_to_one
  }

  join: proveedores {
    type: left_outer
    sql_on: ${productos.proveedor_id} = ${proveedores.id} ;;
    relationship: many_to_one
  }
}

# Explore para control de stock y reabastecimiento
explore: inventario {
  label: "Control de Inventario"
  description: "Monitoreo de stock actual, niveles mínimos y alertas de reabastecimiento"

  join: productos {
    type: left_outer
    sql_on: ${inventario.producto_id} = ${productos.id} ;;
    relationship: many_to_one
  }

  join: proveedores {
    type: left_outer
    sql_on: ${productos.proveedor_id} = ${proveedores.id} ;;
    relationship: many_to_one
  }
}