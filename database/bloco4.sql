-- =====================================================================
-- PROJETO: THELOOK E-COMMERCE | SCRIPT MESTRE COMPLETO (SQL & BIGQUERY)
-- =====================================================================


-- =====================================================================
-- PARTE 01: CRIAÇÃO DE TABELAS (DIMENSÕES E FATO)
-- =====================================================================

-- 1.1 Tabela Fato de Vendas
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


-- 1.2 Dimensão Produto
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


-- 1.3 Dimensão Cliente (Com tratamento de nulos e strings)
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


-- 1.4 Dimensão Calendário
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



-- =====================================================================
-- PARTE 02: AS 25 PERGUNTAS DE ANÁLISE EXPLORATÓRIA E NEGÓCIO
-- =====================================================================

-- Desafio #1 — Total de usuários
SELECT COUNT(*) AS total_usuarios
FROM `bigquery-public-data.thelook_ecommerce.users`;

-- Desafio #2 — Total de pedidos
SELECT COUNT(*) AS total_pedidos
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- Desafio #3 — Período dos dados (Primeiro e último pedido)
SELECT 
  MIN(created_at) AS data_primeiro_pedido,
  MAX(created_at) AS data_ultimo_pedido
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- Desafio #4 — Pedidos por status
SELECT
  status,
  COUNT(status) AS quantidade_pedidos
FROM `bigquery-public-data.thelook_ecommerce.orders`
GROUP BY 1;

-- Desafio #5 — Percentual por status
WITH status_pedidos AS (
    SELECT
        o.status,
        COUNT(status) AS quantidade_pedidos
    FROM `bigquery-public-data.thelook_ecommerce.orders` AS o
    GROUP BY 1
),
total_pedidos AS (
    SELECT COUNT(*) AS total_pedidos
    FROM `bigquery-public-data.thelook_ecommerce.orders` AS o
)
SELECT
    s.status,
    s.quantidade_pedidos,
    s.quantidade_pedidos / t.total_pedidos * 100 AS percentual
FROM status_pedidos AS s
CROSS JOIN total_pedidos AS t;

-- Desafio #6 — Receita total
SELECT SUM(sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items`;

-- Desafio #7 — Valor médio por item vendido
SELECT AVG(sale_price) AS media_por_item
FROM `bigquery-public-data.thelook_ecommerce.order_items`;

-- Desafio #8 — Receita por categoria
SELECT 
  p.category,
  SUM(o.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items` o
INNER JOIN bigquery-public-data.thelook_ecommerce.products p
  ON o.product_id = p.id
GROUP BY 1;

-- Desafio #9 — Clientes e quantidade de pedidos
SELECT 
  u.first_name,
  u.last_name,
  COUNT(o.order_id) AS qtde_de_pedidos 
FROM bigquery-public-data.thelook_ecommerce.users u
INNER JOIN bigquery-public-data.thelook_ecommerce.orders o
  ON u.id = o.user_id
GROUP BY 1, 2;

-- Desafio #10 — Receita por cliente
SELECT
  u.first_name,
  u.last_name,
  SUM(oi.sale_price) AS receita_por_cliente
FROM `bigquery-public-data.thelook_ecommerce.users` u
INNER JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON u.id = o.user_id
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON oi.order_id = o.order_id
GROUP BY 1, 2;

-- Desafio #11 — Ticket médio por cliente
SELECT
  u.first_name,
  u.last_name,
  COUNT(DISTINCT o.order_id) AS quantidade_pedidos,
  SUM(oi.sale_price) AS receita_total,
  SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) AS ticket_medio
FROM `bigquery-public-data.thelook_ecommerce.users` u
INNER JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON u.id = o.user_id
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON oi.order_id = o.order_id
GROUP BY 1, 2;

-- Desafio #12 — Categorias mais rentáveis
SELECT 
  p.category,
  COUNT(o.product_id) AS qtde_produtos_vendidos,
  SUM(o.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items` o
INNER JOIN bigquery-public-data.thelook_ecommerce.products p
  ON o.product_id = p.id
GROUP BY 1;

-- Desafio #13 — Produtos mais vendidos
SELECT 
  p.category AS categoria_produto,
  p.name AS nome_produto,
  COUNT(o.product_id) AS qtde_produtos_vendidos,
  SUM(o.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items` o
INNER JOIN bigquery-public-data.thelook_ecommerce.products p
  ON o.product_id = p.id
GROUP BY 1, 2;

-- Desafio #14 — Top marcas por receita
SELECT
  p.brand,
  COUNT(o.product_id) AS qtde_produtos_vendidos,
  SUM(o.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items` o
INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON o.product_id = p.id
GROUP BY 1;

-- Desafio #15 — Receita por status do pedido
SELECT
  o.status,
  COUNT(DISTINCT o.order_id) AS qtd_pedidos,
  SUM(oi.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.orders` o
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON oi.order_id = o.order_id
GROUP BY 1;

-- Desafio #16 — Receita por mês
SELECT
  DATE_TRUNC(DATE(o.created_at), MONTH) AS mes,
  SUM(oi.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.orders` o
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON o.order_id = oi.order_id
GROUP BY 1;

-- Desafio #17 — KPIs mensais (Receita, Pedidos e Ticket Médio)
SELECT
  DATE_TRUNC(DATE(o.created_at), MONTH) AS mes,
  SUM(oi.sale_price) AS receita_total,
  COUNT(DISTINCT o.order_id) AS quantidade_pedidos,
  SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) AS ticket_medio
FROM `bigquery-public-data.thelook_ecommerce.orders` o
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON o.order_id = oi.order_id
GROUP BY 1;

-- Desafio #18 — Receita por departamento
SELECT
  p.department AS departamento,
  COUNT(oi.product_id) AS quantidade_itens_vendidos,
  SUM(oi.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY 1;

-- Desafio #19 — Receita por marca e categoria
SELECT
  p.category AS categorias, 
  p.brand AS marcas,
  SUM(oi.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY 1, 2;

-- Desafio #20 — Clientes por estado
SELECT
  state,
  COUNT(id) AS qtd_clientes
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY 1;

-- Desafio #21 — Receita por estado
SELECT 
  u.state AS estado, 
  SUM(oi.sale_price) AS receita_total,
  COUNT(DISTINCT o.order_id) AS quantidade_pedidos
FROM bigquery-public-data.thelook_ecommerce.users u
INNER JOIN bigquery-public-data.thelook_ecommerce.orders o
  ON u.id = o.user_id
INNER JOIN bigquery-public-data.thelook_ecommerce.order_items oi
  ON o.order_id = oi.order_id
GROUP BY 1;

-- Desafio #22 — Clientes sem pedidos
SELECT 
  u.id AS id_cliente,
  u.first_name,
  u.last_name,
  COUNT(o.order_id) AS quantidade_pedidos
FROM `bigquery-public-data.thelook_ecommerce.users` u
LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON u.id = o.user_id
GROUP BY 1, 2, 3
HAVING COUNT(o.order_id) = 0;

-- Desafio #23 — Produtos nunca vendidos
SELECT 
  p.name AS produto,
  p.category AS categoria,
  COUNT(oi.order_id) AS quantidade_vendida
FROM `bigquery-public-data.thelook_ecommerce.products` p
LEFT JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON p.id = oi.product_id
GROUP BY 1, 2
HAVING quantidade_vendida = 0;

-- Desafio #24 — Top 10 produtos por receita
SELECT
  p.name AS produto,
  p.category AS categoria,
  SUM(oi.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.products` p
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON p.id = oi.product_id
GROUP BY 1, 2
ORDER BY receita_total DESC
LIMIT 10;

-- Desafio #25 — Análise sintética final por categoria
SELECT 
  p.category AS categoria,
  SUM(oi.sale_price) AS receita_total,
  COUNT(DISTINCT o.order_id) AS quantidade_pedidos,
  SUM(oi.sale_price) / COUNT(DISTINCT o.order_id) AS ticket_medio
FROM `bigquery-public-data.thelook_ecommerce.orders` o
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON o.order_id = oi.order_id
INNER JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY 1
ORDER BY receita_total DESC;