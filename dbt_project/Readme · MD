# 🇮🇪 Irish Property Price Register — Data Pipeline

An end-to-end ELT pipeline built on the Irish Property Price Register (PPR) open dataset, demonstrating production-style data engineering practices using Python, dbt, PostgreSQL, and Metabase — fully containerised with Docker.

![Dashboard](docs/dashboard.png)

---

## 🏗️ Architecture

```
data.gov.ie (PPR CSV)
        │
        ▼
🐍 Python Ingestion (pandas + SQLAlchemy)
        │
        ▼
🗄️ PostgreSQL — Bronze Layer (raw data)
        │
        ▼
⚙️ dbt — Silver Layer (cleaned + typed)
        │
        ▼
🏆 dbt — Gold Layer (analytics marts)
        │
        ▼
📊 Metabase Dashboards
```

---

## 📊 Dashboard

Three charts built on 550,000+ real Irish property transactions:

- **Annual Sales Volume Ireland** — transaction volume trend 2010–2027
- **Dublin Price Trend 2010–2024** — median price growth from €260k to €480k+
- **Median Price by County** — price comparison across all 26 Irish counties

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Python (pandas, SQLAlchemy) | Data ingestion from CSV |
| PostgreSQL 15 | Data warehouse (Dockerised) |
| dbt Core 1.7.4 | Data transformation (Bronze → Silver → Gold) |
| Metabase | BI dashboards (Dockerised) |
| Docker Compose | Local orchestration |
| Git / GitHub | Version control |

---

## 📁 Project Structure

```
irish-ppr-pipeline/
├── data/
│   └── raw/                  ← downloaded PPR CSV (git-ignored)
├── ingestion/
│   ├── ingest_ppr.py         ← Python ingestion script
│   └── requirements.txt
├── dbt_project/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── sources.yml
│   │   │   └── stg_ppr_sales.sql      ← Silver layer
│   │   └── marts/
│   │       ├── mart_county_yearly.sql ← Gold layer
│   │       ├── mart_monthly_volume.sql
│   │       └── mart_property_type.sql
│   └── dbt_project.yml
├── docs/
│   └── dashboard.png
├── docker-compose.yml
├── .env.example
└── README.md
```

---

## 📋 dbt Models

| Layer | Model | Description |
|-------|-------|-------------|
| 🥈 Silver | `stg_ppr_sales` | Cleaned, type-cast transactions — date parsing, price normalisation, county standardisation |
| 🥇 Gold | `mart_county_yearly` | Median and average sale price per county per year |
| 🥇 Gold | `mart_monthly_volume` | Monthly transaction volumes and total value |
| 🥇 Gold | `mart_property_type` | Sales breakdown by property type and year |

---

## 🚀 How to Run Locally

### Prerequisites
- Python 3.11+
- Docker Desktop
- Git

### Steps

**1. Clone the repo**
```bash
git clone https://github.com/YOUR_USERNAME/irish-ppr-pipeline.git
cd irish-ppr-pipeline
```

**2. Create and activate virtual environment**
```bash
python -m venv venv
venv\Scripts\activate.bat        # Windows
source venv/bin/activate         # Mac/Linux
```

**3. Install Python dependencies**
```bash
pip install -r ingestion/requirements.txt
```

**4. Set up environment variables**
```bash
copy .env.example .env           # Windows
cp .env.example .env             # Mac/Linux
```

**5. Start PostgreSQL and Metabase**
```bash
docker compose up -d
```

**6. Download PPR data**

Go to [propertypriceregister.ie](https://www.propertypriceregister.ie) and download the full dataset as CSV. Save it to `data/raw/ppr_all.csv`.

**7. Run the ingestion script**
```bash
python ingestion/ingest_ppr.py
```

**8. Run dbt transformations**
```bash
cd dbt_project
dbt run
dbt test
```

**9. Open Metabase**

Go to [http://localhost:3000](http://localhost:3000) and connect to PostgreSQL using the credentials in your `.env` file.

---

## 🔍 Key Insights

- Dublin median property prices rose from ~€260k (2011) to ~€480k (2026)
- Market volume peaked around 2017–2024 at 60,000+ transactions per year
- Kildare and Wicklow are the most expensive counties outside Dublin
- Leitrim and Longford consistently have the lowest median prices nationally

---

## 📈 Data Quality

dbt tests are run on every pipeline execution:

- `not_null` tests on price and county fields
- Bronze → Silver filtering removes zero/null prices and outliers above €50M
- Source freshness tracked via dbt source definitions

Run tests with:
```bash
dbt test
```

---

## 🌐 Data Source

- **Dataset:** Irish Property Price Register
- **Publisher:** Property Services Regulatory Authority (PSRA)
- **URL:** [propertypriceregister.ie](https://www.propertypriceregister.ie)
- **Licence:** Public Sector Information (PSI) Licence
- **Coverage:** All residential property sales in Ireland from 2010 to present

---

## 👤 Author

Built as part of an Irish Data Engineering portfolio targeting €45k–€60k roles in Ireland.

- MSc Business Analytics — University of Galway (NUIG)
- Skills: Python · SQL · dbt · PostgreSQL · Docker · Data Modelling

---

## 📄 Licence

MIT
