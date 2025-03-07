with 

source as (

    select * from {{ source('raw', 'product') }}

),

renamed as (

    select
        products_id,
        CAST(purchse_price as FLOAT64) as purchase_price

    from source

)

select * from renamed
name: product
         identifier: raw_gz_product
         description: produst of Greenweez
         columns:
           - name: products_id
             description: Primary key
           - name: purchase_price
             description: the purchase price of the product
