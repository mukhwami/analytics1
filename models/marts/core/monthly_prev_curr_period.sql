{{
  config(
    materialized='table'
  )
}}

with dates as (

    select * from {{ ref('stg_date') }}

),
transactions as (

    select * from {{ ref('stg_fact_transactions') }}

),
transactions_transform as(
    select  
        *
    from(
        select
            month_no::int,
            client_id
        from
        (select
            distinct client_id
        from {{ ref('stg_fact_transactions') }}
        where "left"(tran_date::text,6)::int>=201901
        and "left"(tran_date::text,6)::int <=101912 
        ) as q2
        cross join
        (
            select  
                distinct "left"(date_dim_id::text,6)::int as month_no
            from dates
            where "left"(date_dim_id::text,6)::int>=201901
            and "left"(date_dim_id::text,6)::int <=101912 
        ) as q3
        ) as q4
        left join        
        (select 
            client_id,
            "left"(tran_date::text,6)::int as month_no,
            COALESCE(sum(volume),0) as volume,
            COALESCE(sum(revenue),0) as revenue
        from transactions
        where "left"(tran_date::text,6)::int>=201901
        and "left"(tran_date::text,6)::int <=101912 
        group by 1,2
        ) as q5
        using(client_id,month_no)
),
lag_transform as(
    select 
        client_id,
        month_no,
        volume,
        COALESCE(lag(volume) over (partition by client_id order by month_no asc),0) lag_volume,
        revenue,
        COALESCE(lag(revenue) over (partition by client_id order by month_no asc),0) lag_revenue
    from transactions_transform
),
aggregate_transform as(
    -- (
    select 
        month_no,
        client_id, 
        COALESCE(sum(volume),0) as current_volume,
        COALESCE(sum(lag_volume),0) as previous_volume, 
        COALESCE(sum(revenue),0) as current_revenue,
        COALESCE(sum(lag_revenue),0) as previous_revenue
    from lag_transform
    group by 1,2
)
select * from aggregate_transform