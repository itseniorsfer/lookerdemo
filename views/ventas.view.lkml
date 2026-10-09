view: ventas {
  sql_table_name: `mi_proyecto.tienda.ventas_detalle` ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: ticket_id {
    type: string
    sql: ${TABLE}.ticket_id ;;
  }

  dimension: producto_id {
    type: string
    hidden: yes
    sql: ${TABLE}.producto_id ;;
  }

  dimension_group: fecha_venta {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.fecha_venta ;;
  }

  dimension: cantidad {
    type: number
    sql: ${TABLE}.cantidad ;;
  }

  dimension: precio_unitario {
    type: number
    sql: ${TABLE}.precio_unitario ;;
    value_format: "$#,##0.00"
  }

  dimension: descuento {
    type: number
    sql: COALESCE(${TABLE}.descuento, 0) ;;
    value_format: "$#,##0.00"
  }

  # Dimensiones Calculadas
  dimension: monto_bruto {
    type: number
    sql: ${cantidad} *${precio_unitario} ;;
    value_format: "$#,##0.00"
  }

  dimension: monto_neto {
    type: number
    sql: ${monto_bruto} -${descuento} ;;
    value_format: "$#,##0.00"
  }

  dimension: costo_total {
    type: number
    sql: ${cantidad} *${productos.costo_compra} ;;
    value_format: "$#,##0.00"
  }

  dimension: ganancia_bruta {
    type: number
    sql: ${monto_neto} -${costo_total} ;;
    value_format: "$#,##0.00"
  }

  # Métricas / Measures
  measure: total_ventas {
    type: sum
    sql: ${monto_neto} ;;
    value_format: "$#,##0.00"
  }

  measure: total_articulos_vendidos {
    type: sum
    sql: ${cantidad} ;;
  }

  measure: total_ganancia {
    type: sum
    sql: ${ganancia_bruta} ;;
    value_format: "$#,##0.00"
  }

  measure: margen_ganancia_pct {
    type: number
    label: "Margen de Ganancia (%)"
    sql: 1.0 * ${total_ganancia} / NULLIF(${total_ventas}, 0) ;;
    value_format: "0.0%"
  }

  measure: cantidad_tickets {
    type: count_distinct
    sql: ${ticket_id} ;;
  }

  measure: ticket_promedio {
    type: number
    sql: 1.0 * ${total_ventas} / NULLIF(${cantidad_tickets}, 0) ;;
    value_format: "$#,##0.00"
  }
}