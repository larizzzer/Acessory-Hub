USE AcessoryHub;

SELECT Nome, Sobrenome, CONCAT(UCASE(SUBSTRING(Status, 1, 1)), LOWER(SUBSTRING(Status, 2))) AS Status
FROM Funcionarios; -- Coloca a primeira letra maiúscula
