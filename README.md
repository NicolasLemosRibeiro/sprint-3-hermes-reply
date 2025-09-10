# Hermes Reply – Fase 5 (Sprint 3)
## Modelagem de Banco de Dados + ML Básico (Classificação Multiclasse)

Este repositório entrega a Fase 5 do desafio Hermes Reply, cobrindo **modelagem relacional** para dados de sensores industriais e a implementação de um **modelo de Machine Learning** para classificar o `estado_operacional` em **normal**, **alerta** e **crítico**.

---

### 🎯 Objetivos atendidos
- **DER completo** com entidades, atributos, chaves e cardinalidades (imagem exportada).
- **Script SQL** inicial (MySQL/MariaDB) para criação das tabelas principais.
- **Dataset** simulado com leituras por sensor (formato largo e longo).
- **Notebook de ML** (scikit-learn) treinando um classificador multiclasse com visualizações.
- **Gráficos** dos dados e dos resultados do modelo.
- **README** explicando modelagem, ML e resultados.
- **Link do vídeo** de apresentação (até 5 min) — adicione em “Apresentação em vídeo”.

---

## 🧱 Banco de Dados (Relacional)

### Diagrama ER
Visualize o DER em: `database/diagrama_er.png`

### Principais entidades e campos
- **sensores**: `id_sensor (PK)`, `nome`, `tipo`, `localizacao`, `data_instalacao`, `status ('ativo'|'inativo'|'manutencao')`, `modelo`
- **leituras**: `id_leitura (PK)`, `id_sensor (FK)`, `timestamp`, `valor`, `unidade`, `qualidade_sinal`
- **limites_operacionais**: `id_limite (PK)`, `id_sensor (FK)`, `parametro`, `valor_min`, `valor_max`, `ativo`, `data_criacao`
- **alertas**: `id_alerta (PK)`, `id_leitura (FK)`, `nivel`, `mensagem`, `confirmado`, `timestamp_alerta`
- **manutencoes**: `id_manutencao (PK)`, `id_sensor (FK)`, `data_manutencao`, `tipo`, `descricao`, `responsavel`, `custo`

> **Observação:** as FKs usam `ON UPDATE CASCADE` e políticas de `ON DELETE` adequadas (ex.: `SET NULL` para manter histórico). Índices otimizam consultas frequentes (ex.: por `status`, por data, por sensor).

### Script SQL
O script inicial está em `database/create_tables.sql` e foi pensado para **MySQL/MariaDB**.

**Como executar:**
```bash
# 1) crie o schema e as tabelas
mysql -u <usuario> -p < database/create_tables.sql

# 2) (opcional) conecte ao schema
mysql -u <usuario> -p
USE monitoramento_industrial;
SHOW TABLES;
