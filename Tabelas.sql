CREATE DATABASE AcessoryHub;

USE AcessoryHub;

CREATE TABLE Lojas(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Dono VARCHAR(100) NOT NULL,
    Endereco VARCHAR(200) NOT NULL UNIQUE,
    Telefone VARCHAR(16) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Estado VARCHAR(20) NOT NULL,
    Cidade VARCHAR(50) NOT NULL,
    Cnpj VARCHAR(20) NOT NULL UNIQUE,
    Data_Abertura DATE NOT NULL,
    Status VARCHAR(10) NOT NULL
);

CREATE TABLE Funcionarios(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Id_Loja INT,
    Nome VARCHAR(20) NOT NULL,
    Sobrenome VARCHAR(20) NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Email VARCHAR(25) NOT NULL UNIQUE,
    Percentual_Comissao DECIMAL (5,2) NOT NULL,
    Data_Inicio DATE NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Ativo',
    Data_Demissao DATE DEFAULT NULL
);

CREATE TABLE Produtos(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Id_Lojas INT,
    Nome_Produto VARCHAR(100) NOT NULL,
    Tipo_Acessorio VARCHAR(50) NOT NULL,
    Preco DECIMAL(5,2) NOT NULL,
    Descricao TEXT,
    Qtde_Estoque INT NOT NULL,
    Data_Cadastro DATE NOT NULL,
    Marca VARCHAR(25),
    Categoria VARCHAR(50) NOT NULL,
    Ativo VARCHAR(20) NOT NULL DEFAULT 'Ativo'
);

CREATE TABLE Pedidos(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    Id_Funcionarios INT,
    Data_Pedido DATE NOT NULL,
    Valor_Total DECIMAL(8,2) NOT NULL,
    Status_Pedido VARCHAR(20) NOT NULL DEFAULT 'Não Realizado',
    Forma_Pagamento VARCHAR(30) NOT NULL DEFAULT 'Dinheiro',
    Tipo_Venda VARCHAR(20) NOT NULL DEFAULT 'Presencial',
    Observacao TEXT,
    Desconto DECIMAL(5,2),
    FOREIGN KEY (Id_Funcionarios) REFERENCES Funcionarios(Id)
);

CREATE TABLE Itens_do_Pedido(
	Id_Produto INT,
    Id_Pedido INT,
    Quantidade INT NOT NULL,
    Desconto_Item DECIMAL(5,2),
    Obeservacao_Item TEXT,
    Subtotal DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (Id_Produto) REFERENCES Produtos(Id),
    FOREIGN KEY (Id_Pedido) REFERENCES Pedidos(Id)
);

DROP TABLE Funcionarios;
DROP TABLE Produtos;

ALTER TABLE Lojas ADD Nome_Loja VARCHAR(100) NOT NULL AFTER Id;
ALTER TABLE Funcionarios ADD CONSTRAINT Id_Loja FOREIGN KEY (Id_Loja) REFERENCES Lojas(Id);
ALTER TABLE Produtos ADD CONSTRAINT Id_Lojas FOREIGN KEY (Id_Lojas) REFERENCES Lojas(Id);
ALTER TABLE Funcionarios MODIFY Email VARCHAR(100) NOT NULL;
ALTER TABLE Funcionarios ADD CONSTRAINT Funcionarios_Email UNIQUE (Email);

ALTER TABLE Funcionarios DROP INDEX Email;
ALTER TABLE Funcionarios DROP INDEX Email_2; -- Nesses alter tables alteraram o index para redefinir o UNIQUE que não estava funcionando no ALTER TABLE acima
ALTER TABLE Funcionarios DROP INDEX Email_3;

SHOW INDEX FROM Funcionarios;

SELECT * FROM Lojas;
SELECT * FROM Funcionarios;
SELECT * FROM Produtos;
SELECT * FROM Pedidos;
SELECT * FROM Itens_do_Pedido;