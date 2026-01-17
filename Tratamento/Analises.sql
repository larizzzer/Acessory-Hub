USE AcessoryHub;

SELECT * FROM VW_Lojas_Padronizadas;
SELECT * FROM Lojas;
SELECT * FROM Pedidos;
SELECT * FROM VW_Padronizacao_Pedidos;
SELECT * FROM VW_Funcionarios_Padronizados;
SELECT * FROM Funcionarios;
SELECT * FROM Itens_do_Pedido;

-- VENDAS E DESEMPENHO
-- Qual foi o faturamento total por loja em um determinado período?
SELECT 
      l.Loja AS Loja,
      f.Nome AS Nome,
      ROUND(SUM(p.Valor_Total), 2) AS "Faturamento Total"
FROM VW_Lojas_Padronizadas l JOIN Funcionarios f ON l.Id = f.Id_Loja
JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = "Realizado" AND p.Data_Pedido BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY l.Loja, f.Nome, p.Status_Pedido;

-- Qual funcionário vendeu mais em valor total em cada loja
SELECT vendas.Loja,
	   vendas.Funcionario,
       vendas.Vendas
FROM (
	SELECT l.Loja AS Loja,
           f.Nome AS Funcionario,
           SUM(p.Valor_Total) AS Vendas
    FROM VW_Lojas_Padronizadas l JOIN Funcionarios f ON l.Id = f.Id_Loja  -- Soma o valor vendido por funcionário de cada loja
    JOIN Pedidos p ON f.Id = p.Id_Funcionarios 
    WHERE p.Status_Pedido = 'Realizado'
    GROUP BY l.Loja, f.Nome
) vendas
JOIN (
    SELECT Loja,
           MAX(Vendas) AS Maior_Venda
    FROM (
        SELECT l.Loja AS Loja,
               f.Nome AS Funcionario,
               SUM(p.Valor_Total) AS Vendas
        FROM VW_Lojas_Padronizadas l JOIN Funcionarios f ON l.Id = f.Id_Loja -- Identifica em cada loja qual foi o maior valor de vendas
        JOIN Pedidos p ON f.Id = p.Id_Funcionarios
        WHERE p.Status_Pedido = 'Realizado'
        GROUP BY l.Loja, f.Nome
    ) totais
    GROUP BY Loja
) maximos ON vendas.Loja = maximos.Loja AND vendas.Vendas = maximos.Maior_Venda; -- Retorna somente quem atingiu esse maior valor

-- Qual o valor médio por pedido
SELECT 
    ROUND(AVG((i.Subtotal - IFNULL(i.Desconto_Item,0))), 2) AS 'Valor Médio'
FROM Itens_do_Pedido i
JOIN Pedidos p ON i.Id_Pedido = p.Id
WHERE p.Status_Pedido = 'Realizado';

-- Quais dias da semana concentram mais vendas?
SET lc_time_names = 'pt_BR'; -- Faz essa query primeiro para traduzir os dias em inglês para português
SELECT 
	  DAYNAME(p.Data_Pedido) AS 'Dia da semana',
      COUNT(p.Id) AS 'Quantidade de pedidos',
      SUM(p.Valor_Total) AS Total_Vendas
FROM Pedidos p
WHERE p.Status_Pedido = 'Realizado'
GROUP BY DAYNAME(p.Data_Pedido)
ORDER BY Total_Vendas DESC;

-- FUNCIONÁRIOS
-- Qual é o desempenho médio de vendas por funcionário?
SELECT 
      l.Loja AS Loja,
      f.Nome AS Nome,
      ROUND(AVG(p.Valor_Total), 2) AS "Média de Vendas"
FROM VW_Lojas_Padronizadas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = "Realizado"
GROUP BY l.Loja, f.Nome, p.Status_Pedido;

-- Existem funcionários inativos que possuem pedidos associados?
SELECT 
      f.Nome AS Nome,
      f.Status AS Status,
      COUNT(p.Id) AS 'Quantidade de pedidos'
FROM VW_Funcionarios_Padronizados f JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE f.Status = 'Inativo'
GROUP BY f.Nome, f.Status;

-- Qual percentual das vendas totais de cada funcionário dentro de suas lojas?
SELECT 
      l.Loja AS Loja,
      f.Nome AS Nome,
      SUM(p.Valor_Total) AS 'Total por funcionário',
	  ROUND(SUM(p.Valor_Total) / SUM(SUM(p.Valor_Total)) OVER (PARTITION BY l.Loja) * 100, 2) AS 'Percentual de participação' -- Calcula a participação percentual de cada funcionário
FROM VW_Lojas_Padronizadas l JOIN Funcionarios f ON l.Id = f.Id_Loja
JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado'
GROUP BY l.Loja, f.Nome;

-- PRODUTOS
-- Quais produtos são os mais vendidos em quantidade?
SELECT 
      pr.Nome_Produto,
      SUM(i.Quantidade) AS Total_Vendido
FROM Itens_do_Pedido i JOIN Produtos pr ON i.Id_Produto = pr.Id
GROUP BY pr.Nome_Produto
ORDER BY Total_Vendido DESC;

-- Quais os 5 produtos que geram mais faturamento?
SELECT 
      pr.Nome_Produto AS 'Nome do produto',
      SUM(i.Subtotal - IFNULL(i.Desconto_Item,0)) AS Faturamento
FROM Itens_do_Pedido i INNER JOIN Produtos pr ON i.Id_Produto = pr.Id
GROUP BY pr.Nome_Produto
ORDER BY Faturamento DESC
LIMIT 5;

-- Existem 3 produtos que vendem pouco, mas com alto valor agregado?
SELECT 
      pr.Nome_Produto AS 'Nome do produto',
      SUM(i.Quantidade) AS Quantidade_Vendida,
      SUM(i.Subtotal) AS Faturamento
FROM Itens_do_Pedido i JOIN Produtos pr ON i.Id_Produto = pr.Id
GROUP BY pr.Nome_Produto HAVING Quantidade_Vendida < 3 -- Indica a quantidade vendida de cada item
ORDER BY Faturamento DESC
LIMIT 3;

-- DESCONTOS
-- Qual o impacto dos descontos no faturamento total?
SELECT 
	  SUM(i.Desconto_Item) AS 'Total dos descontos',
      SUM(i.Subtotal) AS 'Valor bruto',
      SUM(i.Subtotal - IFNULL(i.Desconto_Item,0)) AS 'Valor líquido'
FROM Itens_do_Pedido i;

-- Quais produtos receberam mais desconto?
SELECT 
    pr.Nome_Produto AS Produto,
    COUNT(ip.Id_Pedido) AS 'Total das vendas com desconto', -- Identifica os produtos com mais desconto
    ROUND(SUM(IFNULL(ip.Desconto_Item, 0)), 2) AS Total_Desconto_Concedido, -- Trata valores nulos
    ROUND(AVG(IFNULL(ip.Desconto_Item, 0)), 2) AS 'Media de desconto por venda'
FROM Itens_do_Pedido ip INNER JOIN Produtos pr ON ip.Id_Produto = pr.Id
INNER JOIN Pedidos p ON ip.Id_Pedido = p.Id 
WHERE IFNULL(ip.Desconto_Item, 0) > 0 AND p.Status_Pedido = 'Realizado' -- Considera apenas as vendas realizadas
GROUP BY pr.Nome_Produto
ORDER BY Total_Desconto_Concedido DESC;

-- Existe algum funcionário que concedeu mais desconto que os outros?
SELECT 
      f.Nome AS Funcionario,
      l.Nome_Loja AS Loja,
      ROUND(SUM(IFNULL(p.Desconto, 0)), 2) AS Total_Desconto_Concedido,
      COUNT(p.Id) AS Total_Pedidos,
      ROUND(SUM(IFNULL(p.Desconto, 0)) / COUNT(p.Id), 2) AS Media_Desconto_Por_Pedido
FROM Funcionarios f INNER JOIN Lojas l ON f.Id_Loja = l.Id
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado'
GROUP BY f.Nome, l.Nome_Loja
ORDER BY Total_Desconto_Concedido DESC;

-- VISÃO GERENCIAL
-- Quais lojas tem o melhor desempenho em vendas?
SELECT 
      l.Loja AS Loja,
      SUM(p.Valor_Total) AS Total_Vendas
FROM VW_Lojas_Padronizadas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado'
GROUP BY l.Loja
ORDER BY Total_Vendas DESC;

-- Existe alguma diferença significativa entre as lojas na média de vendas?
SELECT 
      l.Loja AS Loja,
      ROUND(AVG(p.Valor_Total),2) AS 'Média de vendas'
FROM VW_Lojas_Padronizadas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado'
GROUP BY l.Loja;

-- Qual a taxa de pedidos com desconto por loja?
SELECT 
      l.Loja AS Loja,
      COUNT(CASE WHEN p.Desconto > 0 THEN 1 END) / COUNT(p.Id) * 100 AS 'Taxa de desconto'
FROM VW_Lojas_Padronizadas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
GROUP BY l.Loja;


