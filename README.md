# Context-Aware Multi-Agent AI System (RAG-Based)

![Python](https://img.shields.io/badge/Python-3.10%2B-blue)
![RAG](https://img.shields.io/badge/Retrieval--Augmented--Generation-Enabled-orange)
![AWS Bedrock](https://img.shields.io/badge/AWS-Bedrock-FF9900?logo=amazonaws&logoColor=white)
![LangGraph](https://img.shields.io/badge/LangGraph-Inspired-6C63FF)
![Multi-Agent](https://img.shields.io/badge/Architecture-Multi--Agent-red)

> **Development Status:** 🚧 *Active Development — Not Yet Production Ready*

---

##  Overview

This project is an experimental framework for building **context-aware, retrieval-augmented multi-agent AI systems**. It combines **RAG (Retrieval-Augmented Generation)** with **agent orchestration**, enabling agents to retrieve external knowledge, maintain conversation context, and collaborate on tasks dynamically.

Designed as a bridge between **industrial AI automation workflows** and **research experimentation**, this system aims to support **scalable, modular agent coordination**.

---

##  Core Objectives

- 🧠 *Persistent multi-turn context handling*  
- 📚 *RAG-based external knowledge retrieval*  
- 🤝 *Agent delegation, escalation, and collaboration*  
- 🔌 *Integration with real-world tools & databases*  

> ⚠ **Note:** This is a **functional prototype**. Significant refactoring is planned.

---

## 🛠 Tech Stack (Current / Planned)

| Layer          | Technology |
|----------------|------------|
| LLM Backbone   | AWS Bedrock (Claude / Titan) |
| Agent Logic    | LangGraph-style orchestration (custom engine) |
| Retrieval      | SQL-based RAG (Vector Store TBD) |
| Database       | MySQL / PostgreSQL |
| Interface      | CLI (Web API planned) |

---

## 🗂 Architecture Status

| Component        | Description                            | Status       |
|------------------|----------------------------------------|--------------|
| 🕹 Orchestration  | Core agent coordination                | In progress  |
| 📎 Retrieval      | RAG-based context injection            | Prototype    |
| 🗄 Tooling Layer  | MySQL and business operations          | Experimental |
| 💬 Interface      | Basic CLI                              | Prototype    |

---

## 🚀 Quick Start

```bash
git clone https://github.com/moisf56/Context-Aware-Multi-Agent-AI-System-RAG-based-
cd Context-Aware-Multi-Agent-AI-System-RAG-based-
pip install -r reqs.txt
python multi_agent_sys.py
