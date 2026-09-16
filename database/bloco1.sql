-- =====================================================================
-- PROJETO: THELOOK E-COMMERCE | CRIAÇÃO E TRATAMENTO DAS TABELAS
-- =====================================================================

-- 1. Tabela Fato de Vendas
CREATE OR REPLACE TABLE `thelook_bi.FATO_VENDAS` AS
SELECT 
    oi.id AS order_item_id,
    oi.order_id,
    oi.product_id,
    o.user_id,
    oi.created_at,
    DATE(oi.created_at) AS sale_date,
    oi.sale_price
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
INNER JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON oi.order_id = o.order_id;


-- 2. Dimensão Produto
CREATE OR REPLACE TABLE `thelook_bi.DIM_PRODUTO` AS
SELECT
    id AS product_id,
    name AS product_name,
    category,
    brand,
    department,
    retail_price,
    cost,
    sku
FROM `bigquery-public-data.thelook_ecommerce.products`;


-- 3. Dimensão Cliente (Com tratamento de nulos, vazios e strings)
CREATE OR REPLACE TABLE `thelook_bi.DIM_CLIENTE` AS
SELECT 
    id AS user_id,
    COALESCE(NULLIF(TRIM(first_name), ''), 'Não Informado') AS first_name,
    COALESCE(NULLIF(TRIM(last_name), ''), 'Não Informado') AS last_name,
    COALESCE(NULLIF(TRIM(gender), ''), 'Não Informado') AS gender,
    age,
    COALESCE(NULLIF(TRIM(city), ''), 'Não Informada') AS city,
    COALESCE(NULLIF(TRIM(state), ''), 'Não Informado') AS state,
    COALESCE(NULLIF(TRIM(country), ''), 'Não Informado') AS country
FROM `bigquery-public-data.thelook_ecommerce.users`;


-- 4. Dimensão Calendário
CREATE OR REPLACE TABLE `thelook_bi.DIM_DATA` AS
SELECT
  data AS date,
  EXTRACT(YEAR FROM data) AS ano,
  EXTRACT(QUARTER FROM data) AS trimestre,
  EXTRACT(MONTH FROM data) AS mes_numero,
  FORMAT_DATE('%B', data) AS mes_nome,
  FORMAT_DATE('%Y-%m', data) AS ano_mes,
  EXTRACT(DAY FROM data) AS dia
FROM UNNEST(
  GENERATE_DATE_ARRAY(
    (SELECT MIN(DATE(created_at)) FROM `thelook_bi.FATO_VENDAS`),
    (SELECT MAX(DATE(created_at)) FROM `thelook_bi.FATO_VENDAS`)
  )
) AS data;