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
```
---

## Integração futura

Estrutura preparada para integrar com **Power BI**, **Grafana** ou **Metabase**, permitindo dashboards de:

- **Tendências por sensor**
- **Ocorrências de alertas por período**
- **Análise de manutenção x falhas**

---

### 📊 Dados utilizados

- `data/dados_sensores_largo.csv`: amostras no formato **largo** (colunas por variável).
- `data/dados_sensores_longo.csv`: amostras no formato **longo** (uma linha por leitura/sensor).
- `data/resultados_predicoes.csv`: comparação **real vs. predito** e flag `acertou`.

#### Resumo rápido (amostra atual)
- **Leituras (formato longo):** 1.800 linhas (≈ 600 por sensor)
- **Sensores:** temperatura, umidade, luminosidade
- **Distribuição (`estado_operacional`):** normal » alerta » crítico

> Dados **simulados** de forma controlada para garantir ≥500 leituras por sensor, conforme solicitado no enunciado.

---

### 🤖 Machine Learning (Classificação Multiclasse)

- **Tarefa:** Classificar `estado_operacional` em **normal**, **alerta**, **crítico** a partir de **temperatura**, **umidade** e **luminosidade**.
- **Features:** `temperatura`, `umidade`, `luminosidade` (e derivados simples).
- **Alvo:** `estado_operacional`.
- **Modelo:** `RandomForestClassifier` (scikit-learn).
- **Métricas:** `accuracy`, `classification_report`, `confusion_matrix` + gráficos.

#### Como executar o notebook

*Requer **Python 3.10+**.*

```bash
# 1) (opcional) criar ambiente
python -m venv .venv
source .venv/bin/activate    # Windows: .venv\Scripts\activate

# 2) instalar dependências mínimas
pip install pandas numpy scikit-learn matplotlib seaborn jupyter

# 3) abrir o notebook
jupyter lab  # ou: jupyter notebook

# 4) executar
jupyter nbconvert --to notebook --execute machine_learning/modelo_ml.ipynb
# ou apenas abra e rode manualmente no Jupyter
```
---

### Visualizações

- **Dados/EDA:** `visualizations/analise_sensores.png`
- **Resultados do modelo:** `visualizations/resultados_ml.png`

---

### ✅ Resultados (amostra)

- **Accuracy (teste):** ~**98,7%** (conjunto amostral)
- Matriz de confusão e métricas por classe disponíveis no notebook.
- `data/resultados_predicoes.csv` traz a verificação **real x predito** com a coluna `acertou`.

> A alta acurácia é consistente com dados simulados com limites claros. Em cenário real, recomenda-se **validação cruzada**, tuning de hiperparâmetros e coleta contínua de dados.

---

### ▶️ Apresentação em vídeo
  
**Vídeo:** https://youtu.be/SEU-LINK-NAO-LISTADO
"""

