view: GDS {
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.GDS_DIM`  ;;
  dimension: GDS_Type_Code_Key {
    type: string
    primary_key: yes
    hidden: yes
    sql: Concat(${TABLE}.GDS_CODE,'|',${TABLE}.GDS_TYPE_CODE);;
  }
  dimension: GDS_TYPE_CODE {
    type: string
    hidden: yes
    sql: ${TABLE}.GDS_TYPE_CODE ;;
  }
  dimension: GDS_Name {
    type: string
    label: "GDS Name"
    view_label: "GDS"
    sql: ${TABLE}.GDS_NAME ;;
  }
}
