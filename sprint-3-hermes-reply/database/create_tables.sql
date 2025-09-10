-- Criar database
CREATE DATABASE IF NOT EXISTS monitoramento_industrial
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;
USE monitoramento_industrial;

-- Tabela de Sensores
CREATE TABLE IF NOT EXISTS sensores (
  id_sensor       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome            VARCHAR(50)  NOT NULL,
  tipo            VARCHAR(30)  NOT NULL,
  localizacao     VARCHAR(100),
  data_instalacao DATE,
  status          ENUM('ativo','inativo','manutencao') NOT NULL DEFAULT 'ativo',
  modelo          VARCHAR(50),
  INDEX idx_sensores_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Leituras
CREATE TABLE IF NOT EXISTS leituras (
  id_leitura      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_sensor       INT UNSIGNED NOT NULL,
  `timestamp`     DATETIME     NOT NULL,
  valor           DECIMAL(10,2) NOT NULL,
  unidade         VARCHAR(20)  NOT NULL,
  qualidade_sinal TINYINT UNSIGNED,
  CONSTRAINT fk_leituras_sensor
    FOREIGN KEY (id_sensor) REFERENCES sensores(id_sensor)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_leituras_sensor_ts UNIQUE (id_sensor, `timestamp`),
  CONSTRAINT chk_leituras_valor CHECK (valor >= 0),
  CONSTRAINT chk_leituras_sinal CHECK (qualidade_sinal IS NULL OR qualidade_sinal <= 100),
  INDEX idx_leituras_sensor (id_sensor),
  INDEX idx_leituras_ts (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Alertas
CREATE TABLE IF NOT EXISTS alertas (
  id_alerta    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_leitura   INT UNSIGNED NOT NULL,
  tipo_alerta  VARCHAR(50) NOT NULL,
  nivel        ENUM('baixo','medio','alto','critico') NOT NULL,
  mensagem     TEXT,
  data_alerta  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolvido    BOOLEAN  NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_alertas_leitura
    FOREIGN KEY (id_leitura) REFERENCES leituras(id_leitura)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_alertas_leitura (id_leitura),
  INDEX idx_alertas_data (data_alerta),
  INDEX idx_alertas_resolvido (resolvido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Limites Operacionais
CREATE TABLE IF NOT EXISTS limites_operacionais (
  id_limite    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_sensor    INT UNSIGNED NOT NULL,
  parametro    VARCHAR(50) NOT NULL,
  valor_min    DECIMAL(10,2),
  valor_max    DECIMAL(10,2),
  ativo        BOOLEAN NOT NULL DEFAULT TRUE,
  data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_limites_sensor
    FOREIGN KEY (id_sensor) REFERENCES sensores(id_sensor)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_limite_por_parametro UNIQUE (id_sensor, parametro),
  CONSTRAINT chk_limites_intervalo CHECK (
    valor_min IS NULL OR valor_max IS NULL OR valor_min <= valor_max
  ),
  INDEX idx_limites_sensor (id_sensor)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Manutenções
CREATE TABLE IF NOT EXISTS manutencoes (
  id_manutencao   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_sensor       INT UNSIGNED NULL,
  data_manutencao DATETIME NOT NULL,
  tipo            VARCHAR(50),
  descricao       TEXT,
  responsavel     VARCHAR(100),
  custo           DECIMAL(10,2),
  CONSTRAINT fk_manutencoes_sensor
    FOREIGN KEY (id_sensor) REFERENCES sensores(id_sensor)
    ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX idx_manutencoes_sensor (id_sensor),
  INDEX idx_manutencoes_data (data_manutencao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dados iniciais dos sensores
INSERT INTO sensores (nome, tipo, localizacao, data_instalacao, status, modelo) VALUES
  ('DHT22_Temp', 'Temperatura',  'Sala de Produção A', '2024-01-15', 'ativo', 'DHT22'),
  ('DHT22_Umid', 'Umidade',      'Sala de Produção A', '2024-01-15', 'ativo', 'DHT22'),
  ('LDR_01',     'Luminosidade', 'Sala de Produção A', '2024-01-15', 'ativo', 'LDR5528');