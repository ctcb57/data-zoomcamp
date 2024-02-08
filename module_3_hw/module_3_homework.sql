-- setup
-- create external table for gcs path
create or replace external table `alien-sol-412801.ny_taxi.external_green_tripdata` 
options (
  format = 'PARQUET', 
  uris = ['gs://mage-zoomcamp-charles-clark-1/nyc_green_taxi_data/2022/green_tripdata*.parquet']
);

-- non-partitioned table
create or replace table `ny_taxi.green_tripdata_non_partitioned` as 
select * from `ny_taxi.external_green_tripdata`;

-- Question 1
-- 840402
select count(*)
from `ny_taxi.green_tripdata_partitioned`;

-- Question 2
-- 0MB
select count(distinct PULocationID)
from `ny_taxi.external_green_tripdata`;

-- 6.41 MB
select count(distinct PULocationID)
from `ny_taxi.green_tripdata_non_partitioned`;

-- Question 3
-- 1622
select count(*)
from `ny_taxi.green_tripdata_non_partitioned`
where fare_amount = 0;

-- Question 4
create or replace table `ny_taxi.green_tripdata_partitioned_clustered_hw`
partition by date(lpep_pickup_datetime)
cluster by PULocationID as 
select * from `ny_taxi.external_green_tripdata`;

-- Question 5
-- 12.82 MB
select distinct PULocationID
from `ny_taxi.green_tripdata_non_partitioned`
where lpep_pickup_datetime between '2022-06-01' and '2022-06-30';

-- 1.12 MB
select distinct PULocationID
from `ny_taxi.green_tripdata_partitioned_clustered_hw`
where lpep_pickup_datetime between '2022-06-01' and '2022-06-30';