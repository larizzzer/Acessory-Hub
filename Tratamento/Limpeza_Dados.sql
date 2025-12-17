USE AcessoryHub;

SELECT Nome, Sobrenome, CONCAT(UCASE(SUBSTRING(Status, 1, 1)), LOWER(SUBSTRING(Status, 2))) AS Status
FROM Funcionarios; -- Verificando se funciona para a primeira letra ficar maiúscula e o restante minúsculo

CREATE VIEW VW_Funcionarios_Padronizados AS
SELECT Id,
	   Id_Loja AS Loja,
	   Nome, 
	   Sobrenome,
       CONCAT(UCASE(SUBSTRING(Status, 1, 1)), LOWER(SUBSTRING(Status, 2))) AS Status -- Coloca a primeira letra maiúscula
FROM Funcionarios;

SELECT * FROM VW_Funcionarios_Padronizados
ORDER BY Nome; -- Verifica se a view foi criada corretamente e ordena por ordem alfabética

DROP VIEW VW_Funcionarios_Padronizados; -- Apaga a view caso queira adcionar mais alguma coluna
