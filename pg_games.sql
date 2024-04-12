-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 12/04/2024 às 06:02
-- Versão do servidor: 10.4.28-MariaDB
-- Versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `pg_games`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int(10) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(11) NOT NULL,
  `endereco` varchar(100) NOT NULL,
  `logradouro` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cliente`
--

INSERT INTO `cliente` (`id_cliente`, `nome`, `cpf`, `endereco`, `logradouro`) VALUES
(1, 'João Silva', '12345678901', 'Rua A, 123', 'Casa'),
(2, 'Maria Santos', '98765432109', 'Avenida B, 456', 'Apartamento'),
(3, 'Carlos Oliveira', '45612378965', 'Rua C, 789', 'Sobrado'),
(4, 'Ana Souza', '78945612302', 'Travessa D, 321', 'Casa'),
(5, 'Pedro Almeida', '32165498703', 'Avenida E, 654', 'Apartamento');

-- --------------------------------------------------------

--
-- Estrutura para tabela `estoque`
--

CREATE TABLE `estoque` (
  `id_produto` int(255) NOT NULL,
  `quantidade` int(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `itens_venda`
--

CREATE TABLE `itens_venda` (
  `id_venda` int(10) NOT NULL,
  `id_produto` int(255) NOT NULL,
  `id_vendedor` int(100) NOT NULL,
  `id_cliente` int(10) NOT NULL,
  `quantidade` int(10) NOT NULL,
  `valor_carrinho` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `itens_venda`
--
DELIMITER $$
CREATE TRIGGER `diminuir_estoque_after_insert` AFTER INSERT ON `itens_venda` FOR EACH ROW BEGIN
    DECLARE estoque_atual INT;
    
    -- Obter a quantidade atual em estoque do produto vendido
    SELECT quantidade INTO estoque_atual
    FROM estoque
    WHERE id_produto = NEW.id_produto;
    
    -- Diminuir a quantidade vendida do estoque
    UPDATE estoque
    SET quantidade = quantidade - NEW.quantidade
    WHERE id_produto = NEW.id_produto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `id_produto` int(255) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `quantidade` int(255) NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `categoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `recibo`
--

CREATE TABLE `recibo` (
  `id_recibo` int(10) NOT NULL,
  `id_venda` int(10) NOT NULL,
  `id_vendedor` int(100) NOT NULL,
  `id_cliente` int(10) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `data_emissao` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendedor`
--

CREATE TABLE `vendedor` (
  `id_vendedor` int(100) NOT NULL,
  `nome` varchar(250) NOT NULL,
  `cpf` varchar(11) NOT NULL,
  `endereco` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendedor`
--

INSERT INTO `vendedor` (`id_vendedor`, `nome`, `cpf`, `endereco`) VALUES
(1, 'José Oliveira', '01234567890', 'Rua X, 789'),
(2, 'Fernanda Santos', '98765432109', 'Avenida Y, 456'),
(3, 'Marcos Souza', '45678901234', 'Travessa Z, 123'),
(4, 'Carla Silva', '98701234567', 'Rua W, 345'),
(5, 'Luiz Almeida', '65432109870', 'Avenida V, 234');

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `view_vendas`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `view_vendas` (
`id_venda` int(10)
,`id_produto` int(255)
,`nome_produto` varchar(150)
,`id_cliente` int(10)
,`nome_cliente` varchar(100)
,`quantidade` int(10)
,`valor_carrinho` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estrutura para view `view_vendas`
--
DROP TABLE IF EXISTS `view_vendas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_vendas`  AS SELECT `iv`.`id_venda` AS `id_venda`, `iv`.`id_produto` AS `id_produto`, `p`.`nome` AS `nome_produto`, `iv`.`id_cliente` AS `id_cliente`, `c`.`nome` AS `nome_cliente`, `iv`.`quantidade` AS `quantidade`, `iv`.`valor_carrinho` AS `valor_carrinho` FROM ((`itens_venda` `iv` join `produto` `p` on(`iv`.`id_produto` = `p`.`id_produto`)) join `cliente` `c` on(`iv`.`id_cliente` = `c`.`id_cliente`)) ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Índices de tabela `estoque`
--
ALTER TABLE `estoque`
  ADD PRIMARY KEY (`quantidade`),
  ADD KEY `fk_estoque_produtos_id` (`id_produto`);

--
-- Índices de tabela `itens_venda`
--
ALTER TABLE `itens_venda`
  ADD PRIMARY KEY (`id_venda`),
  ADD KEY `fk_itens_venda_produto` (`id_produto`),
  ADD KEY `fk_itens_venda_vendedor` (`id_vendedor`),
  ADD KEY `fk_itens_venda_estoque` (`quantidade`),
  ADD KEY `fk_itens_venda_cliente` (`id_cliente`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id_produto`),
  ADD KEY `fk_produto_estoque` (`quantidade`);

--
-- Índices de tabela `recibo`
--
ALTER TABLE `recibo`
  ADD PRIMARY KEY (`id_recibo`),
  ADD KEY `fk_recibo_venda` (`id_venda`),
  ADD KEY `fk_recibo_vendedor` (`id_vendedor`),
  ADD KEY `fk_recibo_cliente` (`id_cliente`);

--
-- Índices de tabela `vendedor`
--
ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`id_vendedor`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_cliente` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `itens_venda`
--
ALTER TABLE `itens_venda`
  MODIFY `id_venda` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id_produto` int(255) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `recibo`
--
ALTER TABLE `recibo`
  MODIFY `id_recibo` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `vendedor`
--
ALTER TABLE `vendedor`
  MODIFY `id_vendedor` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `estoque`
--
ALTER TABLE `estoque`
  ADD CONSTRAINT `fk_estoque_produtos_id` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `itens_venda`
--
ALTER TABLE `itens_venda`
  ADD CONSTRAINT `fk_itens_venda_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `fk_itens_venda_estoque` FOREIGN KEY (`quantidade`) REFERENCES `estoque` (`quantidade`),
  ADD CONSTRAINT `fk_itens_venda_produto` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  ADD CONSTRAINT `fk_itens_venda_vendedor` FOREIGN KEY (`id_vendedor`) REFERENCES `vendedor` (`id_vendedor`);

--
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `fk_produto_estoque` FOREIGN KEY (`id_produto`) REFERENCES `estoque` (`id_produto`);

--
-- Restrições para tabelas `recibo`
--
ALTER TABLE `recibo`
  ADD CONSTRAINT `fk_recibo_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `fk_recibo_venda` FOREIGN KEY (`id_venda`) REFERENCES `itens_venda` (`id_venda`),
  ADD CONSTRAINT `fk_recibo_vendedor` FOREIGN KEY (`id_vendedor`) REFERENCES `vendedor` (`id_vendedor`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
