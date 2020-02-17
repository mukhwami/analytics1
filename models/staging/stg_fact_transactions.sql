with source as(
    select * from "azadwh"."Aza_ods_Version1"."fact_transactions"
)
select * from source
