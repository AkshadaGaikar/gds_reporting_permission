project_name: "GDS_Reporting"

# # Use local_dependency: To enable referencing of another project
# # on this instance with include: statements
#
# local_dependency: {
#   project: "name_of_other_project"
# }

constant: CONNECTION_NAME {
  value: "midt_prod_connect" #connection name in looker
  export: override_required
}

constant: GCP_PROJECT {
  value: "sab-prod-gbs-pltf-svcs-5826"
  export: override_required
}

constant: REPORTING_DATASET {
  value: "MIDT_CONSUMPTION"
  export: override_required
}
