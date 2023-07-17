view: Daily_Transction {
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.DAILY_TRANSACTION_AGG`;;

  dimension: true_airpp_dir_airp_pair {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.TRUE_AIRPP_DIR_AIRP_PAIR ;;
  }
  dimension: IATA_POS_GDS_Code_Key {
    type: string
    hidden: yes
    sql: concat(${TABLE}.OUTLET_IATA_CODE,'|',${TABLE}.POS_CODE,'|',${TABLE}.GDS_CODE) ;;
  }
  dimension: gdsCode_GdsTypeCode_daily {
    type: string
    hidden: yes
    sql: concat(${TABLE}.GDS_CODE,'|',${TABLE}.GDS_TYPE_CODE) ;;
  }
  dimension: GDS_TYPE_CODE {
    type: string
    hidden: yes
    sql: ${TABLE}.GDS_TYPE_CODE ;;
  }
  dimension: Booking_Carrier_Class_Code{
    type: string
    hidden: yes
    sql: concat(${TABLE}.CARRIER_CODE ,'|',${TABLE}.BOOKING_CLASS_CODE);;
  }
  dimension: AIRPP_DIR_AIRP_PAIR {
    type: string
    hidden: yes
    sql: ${TABLE}.AIRPP_DIR_AIRP_PAIR ;;
  }
  dimension: BOOKING_DATE {
    type: date
    hidden: yes
    sql: ${TABLE}.BOOKING_DATE ;;
  }


  dimension: dominant_carrier_code {
    type: string
    hidden: yes
    sql: ${TABLE}.DOMINANT_CARRIER_CODE ;;
  }

  dimension: carrier_code {
    type: string
    label: "Carrier Code"
    view_label: "Carrier"
    sql: ${TABLE}.CARRIER_CODE ;;
  }


  dimension: booking_class_code {
    type: string
    label: "Class of Service"
    view_label: "Segment Characteristics"
    sql: ${TABLE}.BOOKING_CLASS_CODE ;;
  }


  dimension: booking_status_code {
    type: string
    label: "Segment Status Code"
    view_label: "Segment Characteristics"
    sql: ${TABLE}.BOOKING_STATUS_CODE ;;
  }


  dimension: country_code {
    type: string
    label: "Country Code"
    view_label: "Point of Sale"
    sql: ${TABLE}.COUNTRY_CODE ;;
  }
  #dimension_group: booking {
  # type: time
  #label: "Transaction Date - CONSTANT"
  # timeframes: [
  #    raw,
  #    date,
  #    week,
  #    month,
  #    quarter,
  #   year
  #  ]
  #  convert_tz: no
  #  datatype: date
  # sql: ${TABLE}.BOOKING_DATE ;;
  #}




#Departure Date
  #dimension_group: departure {
  #  type: time
  #  timeframes: [
  #    raw,
  #    date,
  #    week,
  #    month,
  #   quarter,
  #   year
  # ]
  # convert_tz: no
  # datatype: date
  #  sql: ${TABLE}.DEPARTURE_DATE ;;
  #}
  dimension: gds_code {
    type: string
    label: "GDS Code"
    view_label: "GDS"
    sql: ${TABLE}.GDS_CODE ;;
  }
  dimension: outlet_iata_code {
    type: string
    label: "ARC  Code"
    view_label: "Point of Sale"
    #sql: ${TABLE}.OUTLET_IATA_CODE;;
    sql: CASE WHEN NOT REGEXP_CONTAINS(${TABLE}.OUTLET_IATA_CODE, r"\.|\?|\*|\#|\+|\(|\)|\{|\}|\[|\]|\;|\<|\>|\~|\!|\@|\$|\%|\^|\&|\-|\ |\:|\`") then ${TABLE}.OUTLET_IATA_CODE END;;

  }

  dimension: pos_code {
    type: string
    label: "Point of Sale Code"
    view_label: "Point of Sale"
    #sql: ${TABLE}.POS_CODE;;
    sql: CASE WHEN NOT REGEXP_CONTAINS(${TABLE}.POS_CODE, r"\.|\?|\*|\#|\+|\(|\)|\{|\}|\[|\]|\;|\<|\>|\~|\!|\@|\$|\%|\^|\&|\-|\ |\:|\`") then ${TABLE}.POS_CODE END;;
  }

  dimension: previous_segment_status {
    type: string
    label: "Previous Segment Status Code"
    view_label: "Segment Characteristics"
    sql: ${TABLE}.PREVIOUS_SEGMENT_STATUS ;;
  }
  dimension: Transaction_Date_YYYYMMDD{
    type: string
    label: "Transaction Date -YYYYMMDD"
    view_label: "Date : Transaction Dates"
    sql:  concat(extract(year from ${TABLE}.BOOKING_DATE), lpad(cast(extract(month from ${TABLE}.BOOKING_DATE) as string),2,'0'),  lpad(cast(extract(day from ${TABLE}.BOOKING_DATE) as string),2,'0'));;
  }

  dimension: Departure_Date {
    type: date
    label: "Departure Date"
    view_label: "Date : Departure Dates"
    #sql: ${TABLE}.DEPARTURE_DATE ;;
    sql: Cast(${TABLE}.DEPARTURE_DATE as Timestamp) ;;
  }
  #-------
  parameter: Departure_Date_Quarter_Year {
    type: unquoted
    group_label: "Multi Dimension Filter"
    label: "Duration Filter(Departure Date)"
    view_label: "Daily Transaction"
    default_value: "Year_Quarter"
    allowed_value: {
      label: "Departure Date"
      value: "Departure_Date"
    }
    allowed_value: {
      label: "Departure Year Month"
      value: "Year_Month"
    }
    allowed_value: {
      label: "Booking Month"
      value: "Month"
    }
    allowed_value: {
      label: "Departure Year Quarter"
      value: "Year_Quarter"
    }
    allowed_value: {
      label: "Departure Year"
      value: "Year"
    }
  }
  dimension: Departure_Duration {
    type: string
    group_label: "Multi Dimension"
    view_label: "Daily Transaction"
    label_from_parameter:Departure_Date_Quarter_Year
    sql:
      {%if Departure_Date_Quarter_Year._parameter_value=="Departure_Date"%}
      Cast(${TABLE}.DEPARTURE_DATE as date)

      {% elsif Departure_Date_Quarter_Year._parameter_value=="Year_Month"%}
      concat(extract(year from DEPARTURE_DATE),concat('-',case when length(cast(extract(month from DEPARTURE_DATE) as string))=1 then concat('0',cast(extract(month from DEPARTURE_DATE) as string)) else cast(extract(month from DEPARTURE_DATE) as string) end))

      {% elsif Departure_Date_Quarter_Year._parameter_value=="Month"%}
      case when length(cast(extract(month from DEPARTURE_DATE) as string))=1 then concat('0',cast(extract(month from DEPARTURE_DATE) as string)) else cast(extract(month from DEPARTURE_DATE) as string) end

      {% elsif Departure_Date_Quarter_Year._parameter_value=="Year_Quarter"%}
      concat(extract(Year from DEPARTURE_DATE), concat('-Q', cast(format_date('%Q',DEPARTURE_DATE) as string)))

      {% elsif Departure_Date_Quarter_Year._parameter_value=="Year"%}
      extract(year from DEPARTURE_DATE)
      {% else %}
      NULL
      {% endif %}
      ;;
  }




  #------
  parameter: Booking_Date_Quarter_Year {
    type: unquoted
    group_label: "Multi Dimension Filter"
    label: "Duration Filter"
    view_label: "Daily Transaction"
    default_value: "Year_Quarter"
    allowed_value: {
      label: "Booking Date"
      value: "Booking_Date"
    }
    allowed_value: {
      label: "Booking Year Month"
      value: "Year_Month"
    }
    allowed_value: {
      label: "Booking Month"
      value: "Month"
    }
    allowed_value: {
      label: "Booking Year Quarter"
      value: "Year_Quarter"
    }
    allowed_value: {
      label: "Booking Year"
      value: "Year"
    }
  }
  dimension: Duration {
    type: string
    group_label: "Multi Dimension"
    view_label: "Daily Transaction"
    label_from_parameter:Booking_Date_Quarter_Year
    sql:
      {%if Booking_Date_Quarter_Year._parameter_value=="Booking_Date"%}
      Cast(${TABLE}.BOOKING_DATE as date)
      {% elsif Booking_Date_Quarter_Year._parameter_value=="Year_Month"%}
      concat(BOOKING_YEAR,concat('-',case when length(cast(BOOKING_MONTH as string))=1 then concat('0',cast(BOOKING_MONTH as string)) else cast(BOOKING_MONTH as string) end))
      {% elsif Booking_Date_Quarter_Year._parameter_value=="Month"%}
      case when length(cast(BOOKING_MONTH as string))=1 then concat('0',cast(BOOKING_MONTH as string)) else cast(BOOKING_MONTH as string) end
      {% elsif Booking_Date_Quarter_Year._parameter_value=="Year_Quarter"%}
      concat(${TABLE}.BOOKING_YEAR, concat('-Q', cast(format_date('%Q',${TABLE}.BOOKING_DATE) as string)))
      {% elsif Booking_Date_Quarter_Year._parameter_value=="Year"%}
      ${TABLE}.BOOKING_YEAR
      {% else %}
      NULL
      {% endif %}
      ;;
  }
  #---------------------------


  parameter: DimentioneFilter {
    type: unquoted
    group_label: "Multi Dimension Filter"
    label: "Dimension Filter GDS ,ARC , Country or Carrier"
    view_label: "Daily Transaction"
    default_value: "GDS_Name"
    allowed_value: {
      label: "GDS Name"
      value: "GDS_NAME"
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
      label: "Carrier Code"
      value: "Carrier_Code"
    }
    allowed_value: {
      label: "Booking Date"
      value: "Booking_Date"
    }
  }
  dimension: Other_Dimention {
    type: string
    label: "Dimension GDS ,ARC , Country or Carrier"
    group_label: "Multi Dimension"
    view_label: "Daily Transaction"
    label_from_parameter:DimentioneFilter
    sql:
      {%if DimentioneFilter._parameter_value=="GDS_NAME"%}
      ${gds_code}
      {% elsif DimentioneFilter._parameter_value=="ARC_Name"%}
      ${outlet_iata_code}
      {% elsif DimentioneFilter._parameter_value=="Country_Code"%}
      ${country_code}
      {% elsif DimentioneFilter._parameter_value=="Carrier_Code"%}
      ${carrier_code}
      {% else %}
      NULL
      {% endif %}
      ;;
  }

#----------

  parameter: DimentioneFilterCountryorGDS {
    type: unquoted
    group_label: "Multi Dimension Filter"
    label: "Dimension Filter Country or GDS"
    view_label: "Daily Transaction"
    default_value: "Country_Code"
    allowed_value: {
      label: "GDS Name"
      value: "GDS_NAME"
    }
    allowed_value: {
      label: "Country Code"
      value: "Country_Code"
    }
  }
  dimension: Other_Dimention_CountryorGDS {
    type: string
    label: "Dimension Country or GDS"
    group_label: "Multi Dimension"
    view_label: "Daily Transaction"
    label_from_parameter:DimentioneFilterCountryorGDS
    sql:
      {%if DimentioneFilterCountryorGDS._parameter_value=="GDS_NAME"%}
      ${gds_code}
      {% elsif DimentioneFilterCountryorGDS._parameter_value=="Country_Code"%}
      ${country_code}
      {% else %}
      NULL
      {% endif %}
      ;;
  }


#---------------------------

  parameter: MeasureFilter {
    type: unquoted
    label: "Measure Filter"
    view_label: "Daily Transaction"
    default_value: "Net_Booking"
    allowed_value: {
      label: "Net Booking"
      value: "Net_Booking"
    }
    allowed_value: {
      label: "Booking"
      value: "Booking"
    }
    allowed_value: {
      label: "Cancel"
      value: "Cancel"
    }
  }
  measure: Other_Measure {
    type: sum
    label:"Measure Booking/Cancel/NetBooking"
    view_label: "Daily Transaction"
    label_from_parameter:MeasureFilter
    sql:
      {%if MeasureFilter._parameter_value=="Net_Booking"%}
      ${bookings_passenger_count}-${cancels_passenger_count}
      {% elsif MeasureFilter._parameter_value=="Booking"%}
      ${bookings_passenger_count}
      {% elsif MeasureFilter._parameter_value=="Cancel"%}
      ${cancels_passenger_count}
      {% else %}
      NULL
      {% endif %}
      ;;
  }

  #-----------------------

  dimension: bookings_passenger_count {
    type: number
    hidden: yes
    sql: ${TABLE}.BOOKINGS_PASSENGER_COUNT ;;
  }

  dimension: cancels_passenger_count {
    type: number
    hidden: yes
    sql: ${TABLE}.CANCELS_PASSENGER_COUNT ;;
  }
  measure: count {
    type: count
    label: "Record Count"
    view_label: "Measure"
    drill_fields: []
  }

  measure: Booking {
    type: sum
    label: "Booking"
    view_label: "Measure"
    sql: ${bookings_passenger_count} ;;
  }

  measure: Cancel {
    type: sum
    label: "Cancel"
    view_label: "Measure"
    sql: ${cancels_passenger_count} ;;
  }

  measure: Net_Booking {
    type: sum
    label: "Net Booking"
    view_label: "Measure"
    sql: ${bookings_passenger_count}-${cancels_passenger_count} ;;
  }


}
