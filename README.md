# iOS Store App with TCA

A modern iOS store application built with SwiftUI and The Composable Architecture (TCA).

## Features

- User authentication with demo credentials
- Product browsing and search
- Shopping cart functionality
- Network connectivity monitoring
- Offline support with data caching
- Clean architecture with TCA

## Technology Stack

- SwiftUI
- The Composable Architecture (TCA)
- Swift Concurrency (async/await)
- SwiftData for local storage
- Network monitoring
- Unit testing with Swift Testing

## Architecture

The app follows TCA principles with:
- `LoginFeature` - Handles user authentication
- `StoreFeature` - Manages product display and cart
- `SplashFeature` - Manages SplashScreen
- Dependency injection for services
- Checking Network accesability
- Comprehensive unit tests

## Demo Credentials

- Username: `mor_2314`
- Password: `83r5^_`

## 📊 Метрики разработки с AI

| Метрика | Что заполнить |
|---------|---------------|
| ⏳ **Сколько бы заняло времени без AI (в часах)** | 30 часов (самостоятельное изучение TCA, SwiftData, написание архитектуры с нуля, debugging Equatable issues) |
| 🕐 **Фактическое время с AI (в часах)** | 24 часов (от концепции до готового приложения с тестами) |
| 🧠 **Время работы именно с AI (в часах)** | 10 часов (консультации по архитектуре, генерация кода, решение проблем) |
| 🤖 **Использованные AI-помощники** | Claude-4.0-Sonnet (основной архитект), Raycast AI (быстрые справки), Xcode suggestions |
| 💬 **Топ-3 успешных промпта** | **"Создай TCA reducer для login с async effects"** → Идеальная структура с dependencies<br/>**"Напиши тесты в стиле официальных примеров TCA"** → Правильный паттерн тестирования<br/>**"Объясни почему TestStore требует Equatable и как это исправить"** → Полное понимание проблемы |
| 🍂 **1-2 неудачных промпта** | **"Сделай mock для всех сервисов"** → Переусложненное решение, не подходящее для TCA<br/>**"Исправь все ошибки компиляции"** → Слишком общий запрос без контекста |
| 🧠 **Рефлексия** | 🚀 AI превратил изучение TCA из недель в дни<br/>🎯 Лучше всего AI справляется с советами и шаблонной генерацией<br/>⚡ Скорость разработки выросла не сильно. В основном помогает с шаблонным кодом<br/>📚 Получил глубокое понимание современного iOS development |

## 🤖 AI Interaction History

### 📋 Использованные промпты по этапам разработки

#### **🏗️ Архитектура и планирование**
- Создай архитектуру для iOS Store приложения используя TCA (The Composable Architecture)
- Вот мой Reducer для экрана StoreView [код] - напиши мне парочку unit тестов 4-5
- Объясни как правильно структурировать SwiftUI приложение с TCA для магазина

#### **🔧 Разработка компонентов**
- Создай LoginFeature reducer с поддержкой async/await для авторизации
- Добавь поддержку мониторинга сети и offline режима в мой reducer
- Как правильно организовать зависимости в TCA для API сервиса и NetworkMonitor?

#### **🧪 Тестирование**
- Напиши unit тесты для LoginFeature используя официальный стиль TCA
- Мой State должен быть Equatable - сделай его Equatable для TCA тестов
- Реализуй мне метод static func == для Action enum чтобы сделать его Equatable

### 🎯 Наиболее эффективные промпты

**🏆 Лучшие результаты:**
- Конкретные технические вопросы с примерами кода
- Запросы на объяснение official patterns и best practices  
- Поэтапные инструкции для сложных задач

**⚠️ Менее эффективные:**
- Слишком общие вопросы без контекста
- Просьбы "исправить все ошибки" без деталей
- Запросы на создание большого объема кода без спецификаций

### 🔄 Итеративный процесс

1. **Первоначальный запрос** → Общая архитектура
2. **Уточнения** → Детализация компонентов  
3. **Проблемы** → Точечные исправления
4. **Тестирование** → Покрытие тестами
5. **Полировка** → Финальные улучшения

### 📈 Результативность AI-помощи

- **Архитектурные решения**: 95% - AI отлично справился с TCA паттернами
- **Генерация кода**: 85% - требовались минимальные правки
- **Решение ошибок**: 90% - быстрое выявление причин и решений
- **Тестирование**: 80% - нужно было несколько итераций для правильного стиля
- **Документация**: 95% - высокое качество технической документации

### 🎓 Обучающий эффект

AI не просто решал задачи, но и:
- Объяснял концепции TCA и современного iOS development
- Показывал best practices через примеры кода
- Помогал понять сложные архитектурные паттерны
- Ускорил изучение новых технологий в 3-4 раза

## Demo
https://github.com/user-attachments/assets/e0dab402-cca6-481f-8a4c-f4303e40b613



