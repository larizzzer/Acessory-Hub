USE AcessoryHub;

-- RELATÓRIOS GERENCIAIS POR CADA LOJA

-- Relatórios da Shine Acessórios
-- Sempre considerando os pedidos realizados
SELECT 
      l.Nome_Loja AS Loja,
      COUNT(p.Id) AS 'Total de pedidos',
      ROUND(SUM(p.Valor_Total), 2) AS 'Faturamento Total',
      ROUND(AVG(p.Valor_Total), 2) AS 'Ticket médio'
FROM Lojas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Shine Acessórios'
GROUP BY l.Nome_Loja;

-- Total de vendas por funcionário
SELECT 
      l.Nome_Loja AS Loja,
      f.Nome AS 'Funcionário',
      COUNT(p.Id) AS 'Total de pedidos',
      ROUND(SUM(p.Valor_Total), 2) AS 'Total vendido',
      ROUND(AVG(p.Valor_Total), 2) AS 'Ticket médio'
FROM Funcionarios f INNER JOIN Lojas l ON f.Id_Loja = l.Id
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Shine Acessórios'
GROUP BY l.Nome_Loja, f.Nome;

-- Produtos com maior impacto nas vendas
SELECT 
    l.Nome_Loja AS Loja,
    pr.Nome_Produto AS Produto,
    SUM(ip.Quantidade) AS 'Quantidade vendida',
    ROUND(SUM(ip.Subtotal), 2) AS Faturamento_Total
FROM Itens_do_Pedido ip INNER JOIN Produtos pr ON ip.Id_Produto = pr.Id
INNER JOIN Pedidos p ON ip.Id_Pedido = p.Id INNER JOIN Funcionarios f ON p.Id_Funcionarios = f.Id
INNER JOIN Lojas l ON f.Id_Loja = l.Id
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Shine Acessórios'
GROUP BY l.Nome_Loja, pr.Nome_Produto
ORDER BY Faturamento_Total DESC;

-- Relatórios da Urban Style Bijus
-- Sempre considerando os pedidos realizados

SELECT 
      l.Nome_Loja AS Loja,
      COUNT(p.Id) AS 'Total de pedidos',
      ROUND(SUM(p.Valor_Total), 2) AS 'Faturamento Total',
      ROUND(AVG(p.Valor_Total), 2) AS 'Ticket médio'
FROM Lojas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Urban Style Bijus'
GROUP BY l.Nome_Loja;

-- Total de vendas por funcionário
SELECT 
      l.Nome_Loja AS Loja,
      f.Nome AS 'Funcionário',
      COUNT(p.Id) AS 'Total de pedidos',
      ROUND(SUM(p.Valor_Total), 2) AS 'Total vendido',
      ROUND(AVG(p.Valor_Total), 2) AS 'Ticket médio'
FROM Funcionarios f INNER JOIN Lojas l ON f.Id_Loja = l.Id
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Urban Style Bijus'
GROUP BY l.Nome_Loja, f.Nome;

-- Produtos com maior impacto nas vendas
SELECT 
    l.Nome_Loja AS Loja,
    pr.Nome_Produto AS Produto,
    SUM(ip.Quantidade) AS 'Quantidade vendida',
    ROUND(SUM(ip.Subtotal), 2) AS Faturamento_Total
FROM Itens_do_Pedido ip INNER JOIN Produtos pr ON ip.Id_Produto = pr.Id
INNER JOIN Pedidos p ON ip.Id_Pedido = p.Id INNER JOIN Funcionarios f ON p.Id_Funcionarios = f.Id
INNER JOIN Lojas l ON f.Id_Loja = l.Id
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Urban Style Bijus'
GROUP BY l.Nome_Loja, pr.Nome_Produto
ORDER BY Faturamento_Total DESC;

-- Relatórios da Essence Biju
-- Sempre considerando os pedidos realizados

SELECT 
      l.Nome_Loja AS Loja,
      COUNT(p.Id) AS 'Total de pedidos',
      ROUND(SUM(p.Valor_Total), 2) AS 'Faturamento Total',
      ROUND(AVG(p.Valor_Total), 2) AS 'Ticket médio'
FROM Lojas l INNER JOIN Funcionarios f ON l.Id = f.Id_Loja
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Essence Biju'
GROUP BY l.Nome_Loja;

-- Total de vendas por funcionário
SELECT 
      l.Nome_Loja AS Loja,
      f.Nome AS 'Funcionário',
      COUNT(p.Id) AS 'Total de pedidos',
      ROUND(SUM(p.Valor_Total), 2) AS 'Total vendido',
      ROUND(AVG(p.Valor_Total), 2) AS 'Ticket médio'
FROM Funcionarios f INNER JOIN Lojas l ON f.Id_Loja = l.Id
INNER JOIN Pedidos p ON f.Id = p.Id_Funcionarios
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Essence Biju'
GROUP BY l.Nome_Loja, f.Nome;

-- Produtos com maior impacto nas vendas
SELECT 
    l.Nome_Loja AS Loja,
    pr.Nome_Produto AS Produto,
    SUM(ip.Quantidade) AS 'Quantidade vendida',
    ROUND(SUM(ip.Subtotal), 2) AS Faturamento_Total
FROM Itens_do_Pedido ip INNER JOIN Produtos pr ON ip.Id_Produto = pr.Id
INNER JOIN Pedidos p ON ip.Id_Pedido = p.Id INNER JOIN Funcionarios f ON p.Id_Funcionarios = f.Id
INNER JOIN Lojas l ON f.Id_Loja = l.Id
WHERE p.Status_Pedido = 'Realizado' AND l.Nome_Loja = 'Essence Biju'
GROUP BY l.Nome_Loja, pr.Nome_Produto
ORDER BY Faturamento_Total DESC;


-- RELATÓRIOS GLOBAIS (VISÃO CONSOLIDADA DE TODAS AS LOJAS)

-- Impacto dos descontos
SELECT 
      ROUND(SUM(IFNULL(p.Desconto, 0)), 2) AS 'Total de Descontos',
      ROUND(AVG(IFNULL(p.Desconto, 0)), 2) AS 'Média de Desconto Por Pedido'
FROM Pedidos p
WHERE p.Status_Pedido = 'Realizado';

-- Vendas por dia da semana
SET lc_time_names = 'pt_BR';
SELECT 
      DAYNAME(p.Data_Pedido) AS Dia_da_semana,
      COUNT(p.Id) AS Total_Pedidos,
      ROUND(SUM(p.Valor_Total), 2) AS Faturamento
FROM Pedidos p
WHERE p.Status_Pedido = 'Realizado'
GROUP BY DAYNAME(p.Data_Pedido)
ORDER BY Dia_da_semana ASC;