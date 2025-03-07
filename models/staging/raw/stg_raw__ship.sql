with 

source as (

    select * from {{ source('raw', 'ship') }}

),

renamed as (

    select
        orders_id,
        shipping_fee,
        shipping_fee_1,
        logcost,
        CAST(ship_cost AS INT64) AS ship_cost

      from source

  )

  select * from renamed
