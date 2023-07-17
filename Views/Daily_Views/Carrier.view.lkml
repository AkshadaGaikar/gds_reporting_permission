view: Carrier {
  #sql_table_name: `MIDT_CONSUMPTION.CARRIER_DIM`  ;;
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.CARRIER_DIM`;;

  dimension: CARRIER_CODE {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.CARRIER_CODE ;;
  }
  dimension: CARRIER_NAME {
    type: string
    label: "Carrier Name"
    view_label: "Carrier"
    sql: ${TABLE}.CARRIER_NAME ;;
  }


}
