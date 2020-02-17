with source as(
    select * from "azadwh"."Aza_ods_Version1"."dim_currency"
)
select * from source
