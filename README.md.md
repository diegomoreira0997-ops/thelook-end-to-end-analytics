# 🛍️ TheLook E-commerce: End-to-End Data Pipeline & Analytics

Projeto de portfólio de ponta a ponta utilizando o dataset público do **TheLook E-commerce** hospedado no **Google BigQuery**. O projeto abrange desde a modelagem dimensional e tratamento de qualidade de dados (Engenharia de Dados via SQL) até a análise exploratória de negócios e visualização em Dashboard interativo de BI.

---

## 🛠️ Arquitetura e Tecnologias
* **Armazenamento & Processamento:** Google BigQuery (SQL)
* **Controle de Versão:** Git & GitHub (VS Code)
* **Visualização de Dados (BI):** Power BI / Tableau
* **Linguagem:** SQL (ANSI / BigQuery Dialect)

---

## 📂 Estrutura do Repositório
Os códigos SQL estão organizados de forma modular na pasta `database/`:
* `bloco1.sql`: Criação das tabelas Fato (`FATO_VENDAS`) e Dimensões (`DIM_PRODUTO`, `DIM_CLIENTE`, `DIM_DATA`), incluindo higienização de nulos e strings (`COALESCE`, `TRIM`, `NULLIF`)[cite: 1].
* `bloco2.sql`: Resolução dos desafios de 1 a 15 (usuários, status de pedidos, receitas por categoria e marcas)[cite: 2].
* `bloco3.sql`: Resolução dos desafios de 16 a 25 (evolução mensal de receita, KPIs, estados, clientes órfãos e top produtos)[cite: 3].
* `bloco4.sql`: Pipeline consolidadinho (Script Mestre) para execução de ponta a ponta[cite: 4].

---

## 📊 Business Intelligence & Perguntas de Negócio Respondidas

O dashboard foi estruturado em abas estratégicas para responder às principais perguntas de negócio da diretoria, conectando a engenharia de dados diretamente à tomada de decisão visual.

### 1️⃣ Página 01: Visão Geral de Vendas e Desempenho Temporal
* **Print do Dashboard:** 
  ![Dashboard Visão Geral](images/pagina1_visao_geral.png)
* **Perguntas de Negócio Respondidas:**
  * Qual é a receita total gerada ($10,8 Mi), o volume de clientes (80 Mil), de pedidos (125 Mil) e o ticket médio ($86,49)? *(Respondido via Desafios #2, #6 e #11)*
  * Como a receita se divide por departamento (Men vs Women) e quais são as categorias de vestuário mais rentáveis? *(Respondido via Desafios #8 e #18)*
  * Qual é a tendência de evolução mensal da receita ao longo dos anos? *(Respondido via Desafio #16 e #17)*

### 2️⃣ Página 02: Performance de Produtos, Categorias e Marcas
* **Print do Dashboard:** 
  ![Dashboard Produtos](images/pagina2_produtos.png)
* **Perguntas de Negócio Respondidas:**
  * Quais são os produtos individuais e as marcas que mais geram receita para a plataforma (ex: Diesel, Calvin Klein)? *(Respondido via Desafios #13 e #14)*
  * Qual é o volume total de itens vendidos e o ranqueamento detalhado das categorias por faturamento? *(Respondido via Desafio #12)*
  * Como fica a tabela detalhada de produtos em relação à categoria e marca correspondente? *(Respondido via Desafio #19)*

### 3️⃣ Página 03: Comportamento de Clientes e Geografia
* **Print do Dashboard:** 
  ![Dashboard Clientes](images/pagina3_clientes.png)
* **Perguntas de Negócio Respondidas:**
  * Quais regiões, estados (ex: Guangdong, England, California, São Paulo) e cidades concentram o maior número de clientes e o topo do faturamento? *(Respondido via Desafios #20 e #21)*
  * Como os pedidos se comportam geograficamente de forma detalhada por estado e cidade? *(Respondido via Desafio #21)*
  * Qual é o panorama geral da base de clientes ativos frente aos indicadores globais da empresa? *(Respondido via Desafio #1 e #22)*

---

## ⚠️ Nota de Engenharia & Governança de Dados (Desafios de Renderização CJK)

Durante a exploração da camada geográfica do dataset público do *TheLook E-commerce*, identificou-se uma idiosyncrasia técnica comum em ambientes de grande escala: **metadados e nomes geográficos nativos em caracteres multibyte (CJK - Chinês, Japonês e Coreano)** que sofrem de conflitos de *encoding/collation mismatch* ao serem renderizados por fontes e motores de visualização ocidentais padrão (como verificado nas tabelas detalhadas da aba de geografia).

* **Decisão Técnica (Gestão de Risco):** Em vez de aplicar *hardcodes* ou transformações destrutivas na camada de dados que pudessem comprometer a integridade de métricas geográficas cruzadas, optou-se por preservar a fidedignidade estrutural original do pipeline do BigQuery.
* **Impacto e Garantia:** Os agregados numéricos globais e regionais (**Receita, Volume de Pedidos e Ticket Médio**) mantêm-se matematicamente rigorosos, auditados e perfeitamente íntegros para a tomada de decisão executiva.

---

## 🚀 Como Executar o Projeto
1. Acesse o seu ambiente no **Google BigQuery**.
2. Execute os scripts na ordem numérica presente na pasta `database/` para criar o seu dataset e as tabelas dimensionais tratadas.
3. Conecte a sua ferramenta de BI nas tabelas geradas no BigQuery (`thelook_bi`) para explorar o dashboard interativo.

---
*Desenvolvido por **[Seu Nome]**.*