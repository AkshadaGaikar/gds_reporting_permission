view: Daily_Transaction_Monthly_Rollup_Main {
  sql_table_name: `@{GCP_PROJECT}.@{REPORTING_DATASET}.DAILY_TRANS_MTHLY_ROLLUP` ;;

  dimension: AIRPP_ID {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.AIRPP_ID ;;
  }
  dimension: POS_ID {
    type: string
    hidden: yes
    sql: ${TABLE}.POS_ID ;;
  }


  dimension: CARRIER_ID {
    type: string
    hidden: yes
    sql: ${TABLE}.CARRIER_ID ;;
  }
  dimension: GDS_ID {
    type: string
    hidden: yes
    sql: ${TABLE}.GDS_ID ;;
  }

  dimension: Class_Of_Service {
    label: "Class of Service"
    view_label: "Segment Characteristics - Mthly"
    type: string
    sql: ${TABLE}.BOOKING_CLASS_CODE ;;
  }
  dimension: BOOKING_DATE {
    type: date
    hidden: yes
    sql: ${TABLE}.BOOKING_DATE ;;
  }

  dimension: Transaction_Date_YYYYMM {
    type: date
    label: "Transaction Date- YYYYMM"
    view_label: "Date : Transaction Dates Montly"
    sql:concat(extract(year from ${TABLE}.BOOKING_DATE), lpad(cast(extract(month from ${TABLE}.BOOKING_DATE) as string),2,'0'),  lpad(cast(extract(day from ${TABLE}.BOOKING_DATE) as string),2,'0'));;

  }

  # dimension: Departure_Date {
  #   type: date
  #   label: "Departure Date"
  #   view_label: "Date : Departure Dates"
  #   sql: ${TABLE}.DEPARTURE_DATE ;;
  # }

  parameter: Booking_Date_Quarter_Year {
    type: unquoted
    label: "Duration Filter"
    view_label: "Monthly Transaction"
    default_value: "Year_Month"

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
    view_label: "Monthly Transaction"
    label_from_parameter:Booking_Date_Quarter_Year
    sql:
      {%if Booking_Date_Quarter_Year._parameter_value=="Booking_Date"%}
      Cast(${TABLE}.BOOKING_DATE as date)

      {% elsif Booking_Date_Quarter_Year._parameter_value=="Year_Month"%}
      concat(extract(year from BOOKING_DATE),concat('-',case when length(cast(extract(month from BOOKING_DATE) as string))=1 then concat('0',cast(extract(month from BOOKING_DATE) as string)) else cast(extract(month from BOOKING_DATE) as string) end))

      {% elsif Booking_Date_Quarter_Year._parameter_value=="Month"%}
      case when length(cast(extract(month from BOOKING_DATE) as string))=1 then concat('0',cast(extract(month from BOOKING_DATE) as string)) else cast(extract(month from BOOKING_DATE) as string) end

      {% elsif Booking_Date_Quarter_Year._parameter_value=="Year_Quarter"%}
      concat(extract(Year from BOOKING_DATE), concat('-Q', cast(format_date('%Q',BOOKING_DATE) as string)))

      {% elsif Booking_Date_Quarter_Year._parameter_value=="Year"%}
      extract(year from BOOKING_DATE)
      {% else %}
      NULL
      {% endif %}
      ;;
  }
  #---------

  dimension: Transaction_Date {
    type: date
    label: "Transaction Date"
    view_label: "Monthly Transaction"
    sql: Cast(${TABLE}.BOOKING_DATE as Timestamp) ;;
  }
  #----------------------

  dimension: bookings_passenger_count {
    type: string
    hidden: yes
    sql: ${TABLE}.BOOKINGS_PASSENGER_COUNT ;;
  }
  dimension: cancels_passenger_count {
    type: string
    hidden: yes
    sql: ${TABLE}.CANCELS_PASSENGER_COUNT ;;
  }

#---------------------------

  parameter: MeasureFilter {
    type: unquoted
    label: "Measure Filter"
    view_label: "Monthly Transaction"
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
    view_label: "Monthly Transaction"
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
  #--------
  measure: Record_count {
    type: count
    label: "Record Count"
    view_label: "Measure"
    drill_fields: []
  }
  measure: Booking {
    type: sum
    view_label: "Measure"
    sql: ${bookings_passenger_count} ;;
  }

  measure: Cancel {
    type: sum
    view_label: "Measure"
    sql: ${cancels_passenger_count} ;;
  }

  measure: Net_Booking {
    type: sum
    view_label: "Measure"
    sql: ${bookings_passenger_count}-${cancels_passenger_count} ;;
  }


}
