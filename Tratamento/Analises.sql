USE AcessoryHub;

-- Qual foi o faturamento total por loja em um determinado período?
SELECT * FROM VW_Lojas_Padronizadas;
SELECT * FROM Lojas;
SELECT * FROM Pedidos;
SELECT * FROM VW_Padronizacao_Pedidos;
SELECT * FROM VW_Funcionarios_Padronizados;
SELECT * FROM Funcionarios;

SELECT l.Loja AS Loja,
	   f.Nome AS Nome,
       CONCAT(UCASE(SUBSTRING(Status_Pedido, 1, 1)), LOWER(SUBSTRING(Status_Pedido, 2))) AS Status,
       AVG(p.Valor_Total) AS Venda
FROM VW_Lojas_Padronizadas l JOIN Funcionarios f 
ON l.Id = f.Id_Loja JOIN Pedidos p ON f.Id = p.Id
GROUP BY l.Loja;