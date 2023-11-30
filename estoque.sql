-- Criando e usando o nosso bd
CREATE DATABASE controleEstoque;
USE controleEstoque;

-- Criando o user
CREATE USER 'user_estoque'@'localhost' IDENTIFIED BY 'Augusto@17';
GRANT ALL PRIVILEGES ON controleEstoque.* TO 'user_estoque'@'localhost';

-- Criando as tabelas que achei necessário
CREATE TABLE produtos(
id_produto int primary key auto_increment,
nome_produto varchar(45),
descricao text,
preco_unitario decimal(10,2)
); 

CREATE TABLE entradas(
id_entrada int primary key auto_increment,
id_produto int,
quantidade int,
data_entrada date,
foreign key(id_produto) references produtos(id_produto)
);

CREATE TABLE saidas(
id_saida int primary key auto_increment,
id_produto int,
quantidade int,
data_saida date,
foreign key(id_produto) references produtos(id_produto)
);

CREATE TABLE estoque(
id_produto int,
quantidade int,
foreign key(id_produto) references produtos(id_produto)
);

CREATE TABLE estornos(
id_estorno int primary key auto_increment,
id_produto int,
quantidade int,
foreign key(id_produto) references produtos(id_produto)
);

-- Realizando os insert
INSERT INTO produtos (nome_produto, descricao, preco_unitario) VALUES ('Palha Italiana','Sabor: Morango', 6),
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

INSERT INTO entradas (id_produto, quantidade, data_entrada) VALUES (1, 10, '2023-11-10'),
(2, 10, '2023-11-12'),
(3, 10, '2023-11-13'),
(4, 10, '2023-11-14'),
(5, 10, '2023-11-24'),
(1, 1, '2023-11-10'),
(8, 15, '2023-11-17'),
(9, 17, '2023-11-18'),
(2, 10, '2023-11-19'),
(3, 10, '2023-11-22'),
(4, 10, '2023-11-19'),
(7, 10, '2023-11-19'),
(10, 1, '2023-11-10'),
(7, 15, '2023-11-17'),
(6, 17, '2023-11-23');

INSERT INTO saidas (id_produto, quantidade, data_saida) VALUES (1, 5, '2023-11-20'),
(2, 6, '2023-11-20'),
(3, 6, '2023-11-20'),
(4, 0, '2023-11-20'),
(5, 2, '2023-11-20'),
(1, 6, '2023-11-21'),
(2, 4, '2023-11-21'),
(3, 3, '2023-11-21');

-- Insere na estoque
INSERT INTO estoque (id_produto, quantidade)
SELECT p.id_produto, (COALESCE(SUM(entradas.quantidade), 0) - COALESCE(SUM(saidas.quantidade), 0)) AS quantidade
FROM produtos p
LEFT JOIN entradas ON p.id_produto = entradas.id_produto
LEFT JOIN saidas ON p.id_produto = saidas.id_produto
GROUP BY p.id_produto;

-- Insere na tabela estornos
INSERT INTO estornos (id_produto, quantidade)
SELECT id_produto, quantidade
FROM estoque
WHERE id_produto = 1;

-- Remove da tabela estoque
DELETE FROM estoque WHERE id_produto = 1;

-- Trocando valores do nosso estoque
UPDATE controleestoque.estoque SET quantidade = 100 WHERE id_produto = 7;
UPDATE controleestoque.estoque SET quantidade = -5 WHERE id_produto = 8;

-- Selecionando todos os produtos em estoque
SELECT id_produto, quantidade FROM controleestoque.estoque WHERE quantidade > 0; 

-- Entradas de um determinado periodo 
SELECT id_produto, quantidade, data_entrada FROM controleestoque.entradas WHERE data_entrada BETWEEN '2023/11/12' and '2023/11/20';

-- Saidas de um produto especifico
SELECT id_produto, quantidade as saldo FROM controleestoque.saidas WHERE id_produto = 1;

-- Calculando o saldo de um produto
SELECT id_produto, quantidade as saldo FROM controleestoque.saidas;

-- Saldo abaixo
SELECT id_produto, quantidade as saldo FROM controleestoque.estoque WHERE quantidade <= 10;

-- Selecionando todos os estornos
SELECT * FROM estornos;

-- Dropando a tabela
DROP DATABASE controleEstoque;