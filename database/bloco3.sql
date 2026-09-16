-- =====================================================================
-- PROJETO: THELOOK E-COMMERCE | ANÁLISES AVANÇADAS E NEGÓCIO (16 a 25)
-- =====================================================================

-- Desafio #16 — Receita por mês
SELECT
  DATE_TRUNC(DATE(o.created_at), MONTH) AS mes,
  SUM(oi.sale_price) AS receita_total
FROM `bigquery-public-data.thelook_ecommerce.orders` o
INNER JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON o.order_id = oi.order_id
GROUP BY 1;

-- Desafio #17 — KPIs mensais
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

-- Desafio #25 — Análise final da etapa SQL
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