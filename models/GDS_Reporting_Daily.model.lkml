#connection: "midt_cert_connect"
#connection: "midt_prod_connect"
connection: "@{CONNECTION_NAME}"
# include all the views


datagroup: GDS_reporting_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: GDS_reporting_default_datagroup
# include: "/LookML_Dashboard/Daily_Transaction/*.dashboard.lookml"
# include: "/LookML_Dashboard/Daily_Transaction_Monthly_Rollup_Report/*.dashboard.lookml"
# include: "/LookML_Dashboard/Trailing_12_Month_Reports/*.dashboard.lookml"
# include: "/LookML_Dashboard/Monthly_Segment_Reports/*.dashboard.lookml"
# include: "/LookML_Dashboard/Monthly_O&D_Reports/*.dashboard.lookml"
# include: "/LookML_Dashboard/Other_Reports/*.dashboard.lookml"

include: "/Views/Daily_Views/**/*.view"
explore: Daily_Transction {
  sql_always_where:  ${GDS_TYPE_CODE}='00' and ${outlet_iata_code}<> '3163760' ;;

  join: GDS {
    type: left_outer
    sql_on: ${Daily_Transction.gdsCode_GdsTypeCode_daily}=${GDS.GDS_Type_Code_Key} ;;
    #sql_where: ${GDS.GDS_TYPE_CODE}='00' ;;
    relationship: many_to_one
  }

  join: Carrier {
    type: left_outer
    sql_on: ${Daily_Transction.carrier_code}=${Carrier.CARRIER_CODE} ;;
    relationship: many_to_one
  }
}
