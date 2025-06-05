-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS HospitalRecepcao;
USE HospitalRecepcao;

-- Se a tabela já existir, ela será excluída e recriada
DROP TABLE IF EXISTS Convenios;

-- Criação da tabela Convenios
CREATE TABLE Convenios (
    idConvenio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cobertura VARCHAR(255),
    telefone VARCHAR(20),
    email VARCHAR(100)
);


-- Tabela de especialidades médicas
CREATE TABLE Especialidades (
    idEspecialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Tabela de médicos
CREATE TABLE Medicos (
    idMedico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crm VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    idEspecialidade INT,
    FOREIGN KEY (idEspecialidade) REFERENCES Especialidades(idEspecialidade) 
    ON DELETE SET NULL -- Caso uma especialidade seja deletada, o médico fica com idEspecialidade NULL
);

-- Tabela de pacientes
CREATE TABLE Pacientes (
    idPaciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    rg VARCHAR(20),
    dataNascimento DATE,
    sexo ENUM('Masculino', 'Feminino', 'Outro') NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco TEXT,
    idConvenio INT,
    numeroCarteirinha VARCHAR(50),
    validadeCarteirinha DATE,
    FOREIGN KEY (idConvenio) REFERENCES Convenios(idConvenio)
    ON DELETE SET NULL -- Caso um convênio seja deletado, o paciente fica com idConvenio NULL
);

-- Tabela de recepcionistas
CREATE TABLE Recepcionistas (
    idRecepcionista INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100),
    dataContratacao DATE
);

-- Tabela de agendamentos
CREATE TABLE Agendamentos (
    idAgendamento INT AUTO_INCREMENT PRIMARY KEY,
    idPaciente INT,
    idMedico INT,
    dataHora DATETIME,
    status ENUM('Agendado', 'Cancelado', 'Finalizado') DEFAULT 'Agendado',
    observacoes TEXT,
    FOREIGN KEY (idPaciente) REFERENCES Pacientes(idPaciente),
    FOREIGN KEY (idMedico) REFERENCES Medicos(idMedico)
);

-- Tabela de atendimentos
CREATE TABLE Atendimentos (
    idAtendimento INT AUTO_INCREMENT PRIMARY KEY,
    idAgendamento INT,
    idRecepcionista INT,
    dataHoraEntrada DATETIME,
    dataHoraSaida DATETIME,
    sintomas TEXT,
    diagnostico TEXT,
    prescricao TEXT,
    encaminhamento TEXT,
    FOREIGN KEY (idAgendamento) REFERENCES Agendamentos(idAgendamento),
    FOREIGN KEY (idRecepcionista) REFERENCES Recepcionistas(idRecepcionista)
);

-- Tabela de exames
CREATE TABLE Exames (
    idExame INT AUTO_INCREMENT PRIMARY KEY,
    idAtendimento INT,
    nome VARCHAR(100),
    resultado TEXT,
    dataExame DATE,
    FOREIGN KEY (idAtendimento) REFERENCES Atendimentos(idAtendimento)
);

-- Tabela de prontuário
CREATE TABLE Prontuario (
    idProntuario INT AUTO_INCREMENT PRIMARY KEY,
    idPaciente INT,
    idAtendimento INT,
    anotacoes TEXT,
    dataRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idPaciente) REFERENCES Pacientes(idPaciente),
    FOREIGN KEY (idAtendimento) REFERENCES Atendimentos(idAtendimento)
);

-- Tabela de usuários (login do sistema)
CREATE TABLE Usuarios (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nomeUsuario VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('Admin', 'Recepcionista', 'Medico') NOT NULL
);

-- Dados mockados para testes

-- Inserir convênios
INSERT INTO Convenios (nome, cobertura, telefone, email) VALUES
('Unimed', 'Consultas, Exames, Cirurgias', '11-99999-1111', 'contato@unimed.com'),
('Amil', 'Consultas e Exames', '11-98888-2222', 'suporte@amil.com');

-- Inserir especialidades
INSERT INTO Especialidades (nome, descricao) VALUES
('Cardiologia', 'Tratamento do coração'),
('Ortopedia', 'Tratamento do sistema locomotor'),
('Pediatria', 'Atendimento de crianças');

-- Inserir médicos
INSERT INTO Medicos (nome, crm, telefone, email, idEspecialidade) VALUES
('Dr. João Silva', 'CRM123456', '11-91111-0001', 'joao@hospital.com', 1),
('Dra. Ana Costa', 'CRM234567', '11-92222-0002', 'ana@hospital.com', 2),
('Dr. Pedro Alves', 'CRM345678', '11-93333-0003', 'pedro@hospital.com', 3);

-- Inserir pacientes
INSERT INTO Pacientes (nome, cpf, rg, dataNascimento, sexo, telefone, email, endereco, idConvenio, numeroCarteirinha, validadeCarteirinha) VALUES
('Maria Souza', '123.456.789-00', 'MG123456', '1985-03-10', 'Feminino', '11-90000-1234', 'maria@email.com', 'Rua das Flores, 123', 1, 'UNI12345', '2026-12-31'),
('Carlos Lima', '987.654.321-00', 'SP987654', '1990-06-21', 'Masculino', '11-91111-5678', 'carlos@email.com', 'Av. Brasil, 456', 2, 'AMIL54321', '2025-06-30');

-- Inserir recepcionistas
INSERT INTO Recepcionistas (nome, cpf, telefone, email, dataContratacao) VALUES
('Luciana Melo', '321.654.987-00', '11-95555-9999', 'luciana@hospital.com', '2020-01-10');

-- Inserir agendamentos
INSERT INTO Agendamentos (idPaciente, idMedico, dataHora, status, observacoes) VALUES
(1, 1, '2025-06-01 09:00:00', 'Agendado', 'Consulta de rotina'),
(2, 2, '2025-06-01 10:30:00', 'Agendado', 'Dor no joelho');

-- Inserir atendimentos
INSERT INTO Atendimentos (idAgendamento, idRecepcionista, dataHoraEntrada, dataHoraSaida, sintomas, diagnostico, prescricao, encaminhamento) VALUES
(1, 1, '2025-06-01 08:50:00', '2025-06-01 09:30:00', 'Dor no peito', 'Arritmia leve', 'Betabloqueador', 'Eletrocardiograma'),
(2, 1, '2025-06-01 10:20:00', '2025-06-01 11:00:00', 'Dor no joelho direito', 'Inflamação articular', 'Anti-inflamatório', 'Raio-X');

-- Inserir exames
INSERT INTO Exames (idAtendimento, nome, resultado, dataExame) VALUES
(1, 'Eletrocardiograma', 'Presença de arritmia leve', '2025-06-01'),
(2, 'Raio-X do Joelho', 'Sem fraturas, mas inflamação visível', '2025-06-01');

-- Inserir prontuário
INSERT INTO Prontuario (idPaciente, idAtendimento, anotacoes) VALUES
(1, 1, 'Paciente deve evitar esforço físico. Retorno em 30 dias.'),
(2, 2, 'Reposo de 5 dias. Compressa de gelo e anti-inflamatório.');

-- Inserir usuários do sistema
INSERT INTO Usuarios (nomeUsuario, senha, tipo) VALUES
('admin', 'admin123', 'Admin');
