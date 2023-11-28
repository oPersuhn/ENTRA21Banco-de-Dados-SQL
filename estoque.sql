-- O trabalho está na sequencia do que foi pedido no trabalho para facilitar para avaliar

-- Criando o Database 
CREATE DATABASE ControleEstoque;

-- Usando o Databse
USE ControleEstoque;

-- Criando os users,como foi pedido trabalho
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Augusto@17';
-- concedendo permissões ao usuario
GRANT ALL PRIVILEGES ON ControleEstoque.* TO 'admin'@'localhost';

CREATE USER 'comprador'@'localhost' IDENTIFIED BY 'Augusto@17';
CREATE USER 'vendedor'@'localhost' IDENTIFIED BY 'Augusto@17';

-- Criando as tabelas

CREATE TABLE PRODUTOS (
	id_produto int auto_increment primary key,
    nome_produto varchar(60),
    descricao text,
    preco_unitario decimal(10,2)
);

CREATE TABLE ENTRADAS_ESTOQUE(
	id_entrada int auto_increment primary key,
    id_produto int,
    quantidade int,
    data_entrada date,
    foreign key(id_produto) references PRODUTOS(id_produto)
);

CREATE TABLE SAIDAS_ESTOQUE(
	id_saida int auto_increment primary key,
    id_produto int,
    quantidade int, 
    data_saida date,
    foreign key(id_produto) references PRODUTOS(id_produto)
);

CREATE TABLE ESTOQUE_ESTORNOS (
    id_estorno INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    tipo_operacao VARCHAR(15),
    quantidade_estornada INT
);

-- Execute comandos INSERT para adicionar novos produtos, operações de entrada e saída.
-- Neste momento estaremos inserir os dados nas tabelas que criamos 

INSERT INTO PRODUTOS (nome_produto, descricao, preco_unitario) VALUES ('Palha Italiana','Sabor: Morango', 6),
('Palha Italiana','Sabor: Ninho', 6),
('Palha Italiana','Sabor: Café', 6),
('Palha Italiana','Sabor: Coco', 6),
('Palha Italiana','Sabor: Tradicional', 6),
('Palha Italiana','Sabor: Maracuja', 6),
('Palha Italiana','Sabor: Uva', 6),
('Palha Italiana','Sabor: Baunilha', 6),
('Palha Italiana','Sabor: Menta', 6),
('Palha Italiana','Sabor: Limão', 6),
('Palha Italiana','Sabor: Laranja', 6),
('Palha Italiana','Sabor: Melancia', 6);

INSERT INTO ENTRADAS_ESTOQUE (id_produto, quantidade, data_entrada) VALUES (1, 10, '2023-11-19'),
(2, 10, '2023-11-19'),
(3, 10, '2023-11-19'),
(4, 10, '2023-11-19'),
(5, 10, '2023-11-19'),
(1, 1, '2023-11-10'),
(8, 15, '2023-11-17'),
(9, 17, '2023-11-18'),
(2, 10, '2023-11-19'),
(3, 10, '2023-11-19'),
(4, 10, '2023-11-19'),
(7, 10, '2023-11-19'),
(10, 1, '2023-11-10'),
(7, 15, '2023-11-17'),
(6, 17, '2023-11-18');

INSERT INTO SAIDAS_ESTOQUE (id_produto, quantidade, data_saida) VALUES (1, 5, '2023-11-12'),
(2, 6, '2023-11-12'),
(3, 6, '2023-11-15'),
(4, 0, '2023-11-18'),
(5, 2, '2023-11-18'),
(1, 6, '2023-11-20'),
(2, 4, '2023-11-21'),
(3, 3, '2023-11-23');

-- Utilize comandos UPDATE para modificar a quantidade em estoque de um produto.
-- Aqui vamos realizar o update

UPDATE controleestoque.entradas_estoque
SET QUANTIDADE = 10
WHERE id_entrada = 3;

UPDATE controleestoque.entradas_estoque
SET QUANTIDADE = 20
WHERE id_entrada = 4;

UPDATE controleestoque.entradas_estoque
SET QUANTIDADE = 30
WHERE id_entrada = 5;

UPDATE controleestoque.saidas_estoque
SET QUANTIDADE = 10
WHERE id_saida = 3;

UPDATE controleestoque.saidas_estoque
SET QUANTIDADE = 20
WHERE id_saida = 4;

UPDATE controleestoque.saidas_estoque
SET QUANTIDADE = 30
WHERE id_saida = 5;

-- Execute comandos DELETE para remover registros (por exemplo, estornar uma entrada ou saída).
-- realizando o delete
DELETE FROM controleestoque.entradas_estoque
WHERE id_entrada = 9;

DELETE FROM controleestoque.saidas_estoque
WHERE id_saida = 8;

-- Esta parte a seguir foi a melhor forma que encontrei de registrar os estornos
-- Um de entrada e outro de saida
INSERT INTO estoque_estornos (id_produto, tipo_operacao, quantidade_estornada)
SELECT id_produto, 'Entrada', quantidade
FROM controleestoque.entradas_estoque
WHERE id_entrada = 9;

INSERT INTO estoque_estornos (id_produto, tipo_operacao, quantidade_estornada)
SELECT id_produto, 'Saída', quantidade
FROM controleestoque.saidas_estoque
WHERE id_saida = 8;

-- Explore diferentes variações de comandos SELECT:
-- Esse pedido é muito aberto então só coloquei alguns

SELECT * FROM ControleEstoque.produtos WHERE id_produto = 1;

SELECT * FROM controleestoque.saidas_estoque;

SELECT id_produto, SUM(quantidade) AS soma_entradas
FROM controleestoque.entradas_estoque
GROUP by id_produto;

SELECT id_produto, SUM(quantidade) AS soma_saidas
FROM controleestoque.saidas_estoque
GROUP by id_produto;

-- Selecione todos os produtos em estoque.
SELECT 
	tbproduto.id_produto,
    tbproduto.descricao,
    (tbentrada.soma_entradas) - (tbsaida.soma_saidas) as saldo
FROM controleestoque.produtos tbproduto
INNER JOIN (SELECT id_produto, SUM(quantidade) AS soma_entradas
FROM controleestoque.entradas_estoque
GROUP BY id_produto) tbentrada 
ON tbproduto.id_produto = tbentrada.id_produto

INNER JOIN (SELECT id_produto, SUM(quantidade) AS soma_saidas
FROM controleestoque.saidas_estoque
GROUP by id_produto) tbsaida
ON tbproduto.id_produto = tbsaida.id_produto;

-- Liste as operações de entrada em um determinado período
SELECT * FROM controleestoque.entradas_estoque WHERE data_entrada BETWEEN '2023-11-10' AND '2023-11-17';  
SELECT * FROM controleestoque.saidas_estoque WHERE data_saida BETWEEN '2023-11-18' AND '2023-11-23';  

-- Mostre as operações de saída de um produto específico.
SELECT * FROM estoque_estornos WHERE id_produto = 2;

-- Calcule o saldo atual de cada produto.
SELECT 
	tbproduto.id_produto,
    tbproduto.descricao,
    (tbentrada.soma_entradas) - (tbsaida.soma_saidas) as saldo
FROM controleestoque.produtos tbproduto
INNER JOIN (SELECT id_produto, SUM(quantidade) AS soma_entradas
FROM controleestoque.entradas_estoque
GROUP BY id_produto) tbentrada 
ON tbproduto.id_produto = tbentrada.id_produto

INNER JOIN (SELECT id_produto, SUM(quantidade) AS soma_saidas
FROM controleestoque.saidas_estoque
GROUP by id_produto) tbsaida
ON tbproduto.id_produto = tbsaida.id_produto;

-- Identifique produtos com estoque abaixo de um nível mínimo.
SELECT 
	tbproduto.id_produto,
    tbproduto.nome_produto,
	tbentrada.soma_entradas,
	tbsaida.soma_saidas,
    (tbentrada.soma_entradas) - (tbsaida.soma_saidas) as saldo
FROM controleestoque.produtos tbproduto
INNER JOIN (
    SELECT id_produto, SUM(quantidade) AS soma_entradas
    FROM controleestoque.entradas_estoque
    GROUP BY id_produto
) tbentrada ON tbproduto.id_produto = tbentrada.id_produto

INNER JOIN (
    SELECT id_produto, SUM(quantidade) AS soma_saidas
    FROM controleestoque.saidas_estoque
    GROUP BY id_produto
) tbsaida ON tbproduto.id_produto = tbsaida.id_produto
WHERE (tbentrada.soma_entradas - tbsaida.soma_saidas) < 25;

-- Agrupe e conte as operações de estorno realizadas.
SELECT * FROM controleestoque.saidas_estoque;
SELECT * FROM controleestoque.entradas_estoque;

-- Consulta para mostrar todos os estornos realizados
SELECT * FROM estoque_estornos;

-- Dropa o banco de dados
DROP DATABASE ControleEstoque;

