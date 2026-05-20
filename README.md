# 3X-UI + Nginx Reality Infrastructure

Проект по развертыванию защищенного, портируемого реверс-прокси для панели 3X-UI и трафика VLESS+Reality с разделением по SNI на Ubuntu 22.04.

## 🚀 Архитектурная концепция
- **Frontend:** Nginx (порт 443) распределяет трафик на уровне TCP (модуль `stream`) на основе SNI без терминирования TLS для Reality.
- **Backend:** 3X-UI (панель, подписки) + Xray (Reality TCP).
- **DNS:** DuckDNS (поддомены 4-го уровня для разделения привилегий).
- **Парадигма:** Configuration-as-Code (ориентация на полный Docker-стэк).

## 📂 структура репозитория
```
.
├── README.md                       # Главная страница: концепция, быстрый старт, стек
├── docs/                           # Документация проекта (База знаний)
│   ├── 01_requirements.md          # Исходные данные и требования пользователя
│   ├── 02_specification.md         # Наше утвержденное ТЗ и план работ (из прошлого шага)
│   ├── 03_architecture.md          # Описание логики работы (схемы трафика, SNI, Reality)
│   └── 04_security_log.md          # Лог решений по безопасности (UFW, Docker iptables)
│   └── 05_interconnection_log.md   # Журнал взаимодействия с ИИ (материал для ретроспективы)
└── src/                            # Конфигурационные файлы (Configuration-as-Code)
    ├── docker/                     # (Будущее) Docker-compose и Docker-файлы
    └── nginx/                      # (Будущее) Конфиги Nginx (nginx.conf, stream.d/, conf.d/)
```

## 🧭 Навигация по проекту
- План и ТЗ: [docs/02_specification.md](docs/02_specification.md)
- Архитектура потоков данных: [docs/03_architecture.md](docs/03_architecture.md)

## 🔄 Текущий статус
- [x] Сформулированы требования и утверждено ТЗ.
- [ ] Исследование Пункта 1 плана (SNI-Proxying & Reality).

