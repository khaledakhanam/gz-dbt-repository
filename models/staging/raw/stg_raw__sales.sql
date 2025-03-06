with 

source as (

    select * from {{ source('raw', 'sales') }}

),

renamed as (

    select
        date_date,
        orders_id,
        pdt_id as products_id,
        revenue,
        quantity

    from source

)

select * from renamed

Solution
 
🎯 Instructions
The challenge will be considered complete when you submit the URL of the document you have been working on. Make sure that the URL is in share mode and accessible by the teacher.
If there is no submission option on the exercise, click on the “I’m done” button.

Context
Expand me!
🎯 Generate your First Data Models
It’s time to create your first data model!

1. Generate a Data Model for sales
For greater clarity, you can delete the example directory inside the models folder.

Go back to the schema.yml file. You can use the button generate model from instantiate your first staging model for sales.

💡 Hint

Solution

Save your result and check the lineage. It should look similiar to:

Screenshot of dbt lineage. raw.sales is on the left with an arrow going to stg_raw__sales

Click on Preview to check your result:

Screenshot of dbt cloud IDE preview button

Transform the data to perform some basic cleaning operations in the second CTE from lines 10 to 19 in the SQL script:

Rename the column pdt_id to products_id
2. Generate One Model per Source
Generate the same for the two other sources so that your lineage looks to the following image:

Screenshot of dbt lineage between source and staging. Three lineages: raw.product to stg_raw__product, raw.sales to stg_raw__sales, raw.ship to stg_raw__ship

💡 You can click on your schema.ymland then lineage to view all the models at the same time.

Perform the necessary transformations to clean your table columns:

For product:
Rename purchse_price as purchase_price AND cast to a FLOAT64 data type

Solution
  -- stg_raw__product.sql

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
❗ If students don’t cast to FLOAT64 - they use INT64 or BIGINT - their DBT models will work fine, but they will get errors reading data from BigQuery. This has to do with how BigQuery processes certain operations.


For ship:
Check the difference between shipping_feeand shipping_fee_1. Try and use a WHERE clause and and the <> comparison operator in the BigQuery console. You should keep only one of the columns
Cast ship_cost to an appropriate data type

Solution
For ship transformations, check the difference between shipping_fee and shipping_fee_1 using this query in BigQuery:

  SELECT
      *
  FROM `data-analytics-bootcamp-363212.gz_raw_data.raw_gz_ship`
  WHERE shipping_fee <> shipping_fee_1
It returns no row. This means we have the exact same data in the two columns. You can remove shipping_fee_1 from the query in DBT.

  -- stg_raw__ship.sql

  with

  source as (

      select * from {{ source('raw', 'ship') }}

  ),

  renamed as (

      select
          orders_id,
          shipping_fee,
          logcost,
          CAST(ship_cost AS INT64) AS ship_cost

      from source

  )

  select * from renamed

Check your code is error free with the checker in the bottom right corner of your DBT Cloud IDE:

Code checker visual. Green circle with the text: Ready

Commit and sync your changes.

3. Create your Models in BigQuery
So far, nothing has been created on BigQuery. Let’s change that!

You may have noticed some buttons on the bottom panel of your DBT Cloud IDE when you have a model open. Here is a summary of them:

DBT commands with summary. Preview: preview a models results inside dbt. Compile: copy the ocde to run it on BigQuery. Build: build the data in BigQuery.

If you click build, it is the same as typing out dbt build --select <model_name> in your command bar at the bottom of the screen and pressing enter. <model_name> is the name of your open SQL file, without the .sql on the end.

💡 If you want to run all of your models and tests, type out dbt build in the command bar at the bottom of your screen and press enter.

Use the dbt build command to:

Test all your sources - we have no test written so far
Test all your models - we have no test written so far
Create all your models - as views by default
If you execute dbt build in the command line, you should get something similar to the following output. Feel free to click on one and investigate the details.

Screenshot of dbt build output. Three staging models are listed with a green tick beside each of them.

❗ If you haven’t deleted the example directory inside models, the command dbt build will also run these models and create tables/views in BigQuery.

Check that the views are created on BigQuery. If something has gone wrong, you can safely delete the dbt_<your_name> dataset in BigQuery and dbt build again.


Solution
Screenshot of solution


4. Adding Source Documentation
Add a description about the schema (dataset), every tables, and every columns, so that you can later generate documentation automatically from the schema.yml file.

💡 Hint
Here is an example for hte first column of raw_gz_sales

 # schema.yml

 version: 2

 sources:
   - name: raw
     schema: gz_raw_data
     tables:
       - name: sales
         identifier: raw_gz_sales
         description: sales of Greenweez / we have on row per product_id found in each orders_id
         columns:
           - name: date_date
             description: date of purchase
Make sure you fill out the rest!


Solution
 # schema.yml

 version: 2

 sources:
   - name: raw
     schema: gz_raw_data
     tables:
       - name: sales
         identifier: raw_gz_sales
         description: sales of Greenweez / we have on row per product_id found in each orders_id
         columns:
           - name: date_date
             description: date of purchase
           - name: orders_id
             description: foreign key to ship
           - name: pdt_id
             description: foreign key to product
           - name: revenue
             description: the amount paid by the customer to purchase the product. revenue = quantity * selling_price
           - name: quanitity
             description: the quantity of products purchased for a given order

       - name: product
         identifier: raw_gz_product
         description: produst of Greenweez
         columns:
           - name: products_id
             description: Primary key
           - name: purchase_price
             description: the purchase price of the product

       - name: ship
         identifier: raw_gz_ship
         description: shipping data for Greenweez orders
         columns:
           - name: orders_id
             description: Primary key
           - name: shipping_fee
             description: the price the customer pays for shipping
           - name: log_cost
             description: the cost of preparing the parcel in the distribution centre/warehouse
           - name: ship_cost
             description: shipping cost paid by Greenweez to the carrier/logistics provider