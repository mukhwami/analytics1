with source as(
    select * from "azadwh"."Aza_ods_Version1"."dim_date"
)
select * from source
