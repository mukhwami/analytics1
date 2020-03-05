with source as(
    select * from "azadwh"."dep_aza"."transactions"
)
select * from source