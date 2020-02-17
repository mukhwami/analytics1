with source as (
    select bank_code,
        bank_name
     from "azadwh"."Aza_ods_Version1"."dim_banks"  
)
select * from source
