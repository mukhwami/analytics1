{{
  config(
    materialized='table'
  )
}}

with client as (

    select * from {{ ref('stg_customers') }}

),

dates as (

    select * from {{ ref('stg_date') }}

),

banks as (

    select * from {{ ref('stg_banks') }}

),

corridor as (

    select * from {{ ref('stg_corridor') }}

),

product as (

    select * from {{ ref('stg_product') }}

),

segment as (

    select * from {{ ref('stg_segment') }}

),

transactions as (

    select * from {{ ref('stg_fact_transactions') }}

),

final as(
    SELECT ft.uuid,
    cl.client_name,
    se.segment_name,
    co.corridor_name,
    po.product_name,
    bn.bank_name,
    ft.channel_code,
    dd.date_actual,
    ft.source,
    ft.revenue,
    ft.volume
   FROM transactions ft
     LEFT JOIN client cl ON cl.cleint_id = ft.client_id
     LEFT JOIN dates dd ON dd.date_dim_id = ft.tran_date
     LEFT JOIN segment se ON se.segment_id = cl.segment_id
     LEFT JOIN corridor co ON co.corridor_id = ft.corridor_id
     LEFT JOIN product po ON po.product_id = ft.product_id
     LEFT JOIN banks bn ON bn.bank_code = ft.bank_code
)
select * from final