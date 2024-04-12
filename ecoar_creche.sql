-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 12/04/2024 às 06:03
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
-- Banco de dados: `ecoar_creche`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `criancas`
--

CREATE TABLE `criancas` (
  `ID_Crianca` int(11) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Data_de_Nascimento` date DEFAULT NULL,
  `Endereco` varchar(255) DEFAULT NULL,
  `ID_Turma` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `criancas`
--

INSERT INTO `criancas` (`ID_Crianca`, `Nome`, `Data_de_Nascimento`, `Endereco`, `ID_Turma`) VALUES
(1, 'Pedro Oliveira', '2019-05-10', 'Rua A, 123', 1),
(2, 'Julia Costa', '2018-08-15', 'Rua B, 456', 2),
(3, 'Lucas Mendes', '2020-02-20', 'Rua C, 789', 3);

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionarios`
--

CREATE TABLE `funcionarios` (
  `ID_Funcionario` int(11) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Cargo` varchar(100) DEFAULT NULL,
  `ID_Turma` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionarios`
--

INSERT INTO `funcionarios` (`ID_Funcionario`, `Nome`, `Cargo`, `ID_Turma`) VALUES
(1, 'Maria Silva', 'Professora', 1),
(2, 'João Santos', 'Auxiliar', 2),
(3, 'Ana Oliveira', 'Pedagoga', 3);

-- --------------------------------------------------------

--
-- Estrutura para tabela `turmas`
--

CREATE TABLE `turmas` (
  `ID_Turma` int(11) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Sala` varchar(50) DEFAULT NULL,
  `Horario` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `turmas`
--

INSERT INTO `turmas` (`ID_Turma`, `Nome`, `Sala`, `Horario`) VALUES
(1, 'Maternal', 'Sala 1', '08:00:00'),
(2, 'Jardim I', 'Sala 2', '08:30:00'),
(3, 'Jardim II', 'Sala 3', '09:00:00');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `criancas`
--
ALTER TABLE `criancas`
  ADD PRIMARY KEY (`ID_Crianca`),
  ADD KEY `fk_Criancas_Turmas` (`ID_Turma`);

--
-- Índices de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD PRIMARY KEY (`ID_Funcionario`),
  ADD KEY `fk_Funcionarios_Turmas` (`ID_Turma`);

--
-- Índices de tabela `turmas`
--
ALTER TABLE `turmas`
  ADD PRIMARY KEY (`ID_Turma`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `criancas`
--
ALTER TABLE `criancas`
  MODIFY `ID_Crianca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  MODIFY `ID_Funcionario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `turmas`
--
ALTER TABLE `turmas`
  MODIFY `ID_Turma` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `criancas`
--
ALTER TABLE `criancas`
  ADD CONSTRAINT `fk_Criancas_Turmas` FOREIGN KEY (`ID_Turma`) REFERENCES `turmas` (`ID_Turma`);

--
-- Restrições para tabelas `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD CONSTRAINT `fk_Funcionarios_Turmas` FOREIGN KEY (`ID_Turma`) REFERENCES `turmas` (`ID_Turma`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
