# 🚀 Event-Driven Data Processing Pipeline on AWS

This project demonstrates a fully automated, event-driven data processing pipeline built on AWS. The system ingests event data, stores it in Amazon S3, processes it daily with AWS Lambda, and generates automated summary reports via Amazon SES — all deployed using Terraform and automated using GitHub Actions CI/CD.

---

## 📌 Features

* 🧩 Modular architecture using S3, Lambda, EventBridge, and SES
* ⏱️ EventBridge-triggered daily report generation
* 📊 Automatic summary report creation and email delivery
* 🔐 Secure execution using IAM roles & policies
* 🛠 Infrastructure provisioned using Terraform (IaC)
* 🤖 Automated deployment with GitHub Actions CI/CD
* 🔍 Monitoring and logging with CloudWatch Logs

---

## 🗂 Project Structure

```
event-driven-pipeline/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
│
├── lambda_ingest/
│   └── index.py      # Lambda to store incoming events to S3
│
├── lambda_report/
│   └── index.py      # Lambda to process events and email reports
│
└── .github/workflows/
    └── ci-cd.yml     # GitHub Actions workflow for auto-deploy
```

---

## ⚙️ How It Works

### 1️⃣ Data Ingestion

* Triggered manually or via API
* Lambda function stores raw events in:
  `s3://event-data-bucket/`

### 2️⃣ Daily Reporting

* Triggered by EventBridge every 24 hours
* Lambda processes events from the last day
* Summary stored in:
  `s3://event-report-bucket/`
* Report emailed automatically via Amazon SES

---

## 🚀 Setup & Deployment

### 1. Clone Repository

```
git clone https://github.com/your-username/event-driven-pipeline.git
cd event-driven-pipeline
```

### 2. Configure AWS Credentials

```
aws configure
```

### 3. Initialize Terraform

```
cd terraform
terraform init
```

### 4. Deploy Infrastructure

```
terraform apply
```

### 5. Test Lambda Ingestion

```
aws lambda invoke \
  --function-name lambda_ingest \
  --payload '{"user_id": "101", "action": "signup"}' \
  response.json
```

---

## 🔁 CI/CD with GitHub Actions

* Push to `main` branch triggers automated pipeline
* Both Lambda functions are zipped and deployed automatically
* Keeps AWS Lambda code in sync with GitHub repository

---

## 📧 Output Example (Email)

**Subject:** Daily Report - 2025-07-27

* Events processed: 54
* Unique users: 12
* Most common action: "purchase"

---

## 🔍 Monitoring & Logging

* CloudWatch Logs enabled for both Lambda functions
* Structured logging for error handling
* Easy troubleshooting via logs and automated alerts

---

## 📘 Documentation

* 📄 Research Report
* 🏗️ Architecture Diagram & Justification

---

## 👨‍💻 Author

**ShivShankar Gawali**
LinkedIn | GitHub

---

## 🏁 License

This project is for educational and demonstration purposes only.
