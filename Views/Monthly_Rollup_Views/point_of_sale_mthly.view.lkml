view: point_of_sale_mthly {
  sql_table_name:  `@{GCP_PROJECT}.@{REPORTING_DATASET}.CLIENT_POS_DIM` ;;

  dimension: POS_ID {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.POS_ID ;;
  }

  dimension: CLIENT_ID {
    type: string
    hidden: yes
    sql: ${TABLE}.CLIENT_ID ;;
  }

  dimension: OUTLET_IATA_CODE {
    type: string
    hidden: yes
    sql: ${TABLE}.OUTLET_IATA_CODE ;;
  }

  dimension: Point_of_Sale_Code {
    type: string
    #sql: ${TABLE}.POS_CODE ;;
    sql: CASE WHEN NOT REGEXP_CONTAINS(${TABLE}.POS_CODE, r"\.|\?|\*|\#|\+|\(|\)|\{|\}|\[|\]|\;|\<|\>|\~|\!|\@|\$|\%|\^|\&|\-|\ |\:|\`") then ${TABLE}.POS_CODE END;;
  }

  dimension: ARC_Code {
    type: string
    #sql: ${TABLE}.OUTLET_IATA_CODE ;;
    sql: CASE WHEN NOT REGEXP_CONTAINS(${TABLE}.OUTLET_IATA_CODE, r"\.|\?|\*|\#|\+|\(|\)|\{|\}|\[|\]|\;|\<|\>|\~|\!|\@|\$|\%|\^|\&|\-|\ |\:|\`") then ${TABLE}.OUTLET_IATA_CODE END;;
  }
  dimension: ARC_Name {
    type: string
    sql: ${TABLE}.OUTLET_NAME ;;
  }
  dimension: City_Name {
    type: string
    sql: ${TABLE}.CITY_NAME ;;
  }
  dimension: Country_Region_Code {
    type: string
    sql: ${TABLE}.CITY_NAME ;;
  }
  dimension: Country_Region_Name {
    type: string
    sql: ${TABLE}.CNTRY_REG_NAME ;;
  }
  dimension: Country_Name {
    type: string
    sql: ${TABLE}.COUNTRY_NAME ;;
  }
  dimension: Region_Name {
    type: string
    sql: ${TABLE}.WORLD_AREA_NAME ;;
  }
  dimension: Outlet_Home_Office_Code {
    type: string
    sql: ${TABLE}.OUTLET_HOME_OFFICE_CODE ;;
  }
  dimension: Pseudo_ARC_Code {
    type: string
    sql: ${TABLE}.OUTLET_CODE_INTERNAL ;;
  }
  dimension: City_Code {
    type: string
    sql: ${TABLE}.CITY_CODE ;;
  }
  dimension: Country_Code {
    type: string
    sql: ${TABLE}.COUNTRY_CODE ;;
  }
  dimension: Region_Code {
    type: string
    sql: ${TABLE}.WORLD_AREA_CODE ;;
  }
#-------
  parameter: DimentioneFilter {
    type: unquoted
    #group_label: "Multi Dimension Filter"
    label: "Dimension Filter ARC Code / Country Code"
    view_label: "Monthly Transaction"
    default_value: "ARC_Code"
    allowed_value: {
      label: "ARC Code"
      value: "ARC_Code"
    }

    allowed_value: {
      label: "ARC Name"
      value: "ARC_Name"
    }

    allowed_value: {
      label: "Country Code"
      value: "Country_Code"
    }
    allowed_value: {
      label: "Point Of Sale"
      value: "Point_Of_Sale"
    }


  }
  dimension: Other_Dimention {
    type: string
    label: "Dimension Filter ARC Code / Country Code filter"
    #group_label: "Multi Dimension"
    view_label: "Monthly Transaction"
    label_from_parameter:DimentioneFilter
    sql:
      {%if DimentioneFilter._parameter_value=="ARC_Code"%}
      ${ARC_Code}
      {% elsif DimentioneFilter._parameter_value=="ARC_Name"%}
      ${ARC_Name}
      {% elsif DimentioneFilter._parameter_value=="Country_Code"%}
      ${Country_Code}
      {% elsif DimentioneFilter._parameter_value=="Point_Of_Sale"%}
      ${Point_of_Sale_Code}
      {% else %}
      NULL
      {% endif %}
      ;;
  }

}
