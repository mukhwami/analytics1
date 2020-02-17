with source as (
    select channel_code,
        channel_name
     from "azadwh"."Aza_ods_Version1"."dim_channel"  
)
select * from source