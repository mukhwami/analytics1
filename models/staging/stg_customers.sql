with source as(
    select * from "azadwh"."Aza_ods_Version1"."dim_client"
)
select * from source
