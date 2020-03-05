{{
  config(
    materialized='table'
  )
}}

with trx as (

    select * from {{ ref('stg_trx') }}

)
select * from trx