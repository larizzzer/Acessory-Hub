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
	  ROUND(SUM(p.Valor_Total) /SUM(SUM(p.Valor_Total)) OVER (PARTITION BY l.Loja) * 100, 2 -- Calcula a participação percentual de cada funcionário
		   ) AS 'Percentual de participação'
FROM VW_Lojas_Padronizadas l JOIN Funcionarios f ON l.Id = f.Id_Loja
JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado'
GROUP BY l.Loja, f.Nome;
