USE AcessoryHub;

SELECT * FROM VW_Lojas_Padronizadas;
SELECT * FROM Lojas;
SELECT * FROM Pedidos;
SELECT * FROM VW_Padronizacao_Pedidos;
SELECT * FROM VW_Funcionarios_Padronizados;
SELECT * FROM Funcionarios;

-- VENDAS E DESEMPENHO
-- Qual foi o faturamento total por loja em um determinado período?
SELECT 
      l.Loja AS Loja,
      f.Nome AS Nome,
      CONCAT(UCASE(SUBSTRING(p.Status_Pedido, 1, 1)), LOWER(SUBSTRING(p.Status_Pedido, 2))) AS Status,
      ROUND(AVG(p.Valor_Total), 2) AS "Média de Venda"
FROM VW_Lojas_Padronizadas l JOIN Funcionarios f ON l.Id = f.Id_Loja
JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = "Realizado"
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

-- 

