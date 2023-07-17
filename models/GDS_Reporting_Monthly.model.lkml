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


include: "/Views/Monthly_Rollup_Views/**/*.view"
explore: Daily_Transaction_Monthly_Rollup{
  from: Daily_Transaction_Monthly_Rollup_Main
  tags: ["Monthly Rollup Data","MIDT Monthly Rollup"]

  join: point_of_sale_mthly {
    type: left_outer
    sql_on: ${Daily_Transaction_Monthly_Rollup.POS_ID}=${point_of_sale_mthly.POS_ID} ;;
    sql_where: ${point_of_sale_mthly.CLIENT_ID}=2 and ${point_of_sale_mthly.OUTLET_IATA_CODE}<> '3163760';;
    relationship: many_to_one
  }
}
