-- =====================================================================
-- PROJETO: THELOOK E-COMMERCE | EXPLORAÇÃO BÁSICA E MÉTRICAS (01 a 15)
-- =====================================================================

-- Desafio #1 — Total de usuários
SELECT COUNT(*) AS total_usuarios
FROM `bigquery-public-data.thelook_ecommerce.users`;

-- Desafio #2 — Total de pedidos
SELECT COUNT(*) AS total_pedidos
FROM `bigquery-public-data.thelook_ecommerce.orders`;

-- Desafio #3 — Período dos dados
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