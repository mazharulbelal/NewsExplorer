# 📰 NewsExplorer iOS App

NewsExplorer is a lightweight iOS application built using **UIKit (programmatic UI)** that fetches and displays news articles from a public News API. The app focuses on **clean architecture, scalability, and maintainability**, following **MVVM-C** with **Combine** for reactive data binding.

---

## 📱 Features

* Fetch and display the latest news articles
* Search news articles
* Custom image loading & caching (no third-party frameworks)
* Shimmer loading effect for smooth UX
* ViewState-driven UI updates for predictable state handling
* Centralized error handling
* Reusable alert manager
* Programmatic UIKit UI

---

## 🧱 Project Structure

```
NewsExplorer
│
├── Application
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
│
├── Configuration
│   └── AppEnvironment.swift
│
├── Networking
│   ├── APIClient.swift
│   ├── Endpoint.swift
│   └── NetworkError.swift
│
├── Models
│   ├── Article.swift
│   └── NewsResponseDTO.swift
│
├── Presentation
│   └── NewsList
│       ├── NewsListCoordinator.swift
│       ├── NewsListViewController.swift
│       ├── NewsListViewModel.swift
│       └── NewsCell.swift
│
├── Helper
│   ├── ImageLoader.swift
│   ├── SearchController.swift
│   └── Shimmer.swift
```

---

## 🏗 Architecture

The app follows **MVVM-C (Model–View–ViewModel–Coordinator)**:

* **Model:** Handles data models and API responses
* **View:** UIKit view controllers and table view cells
* **ViewModel:** Business logic and data transformation using Combine
* **Coordinator:** Manages navigation and app flow

### Why MVVM-C?

* Clear separation of concerns
* Scalable navigation
* Improved testability
* Cleaner, more maintainable view controllers

---

## 🔁 Reactive Programming (Combine)

The app uses **Combine** for:

* API request handling
* State binding between ViewModel and ViewController
* Error propagation and UI updates

### View State Management

```swift
enum ViewState<Value> {
    case idle
    case loading
    case loaded(Value)
    case empty
    case error(String)
}
```

This ensures predictable UI behavior across **loading, empty, success, and error states**.

---

## 🌐 Networking Layer

The networking layer is **completely separated** and reusable.

### API Client Protocol

```swift
protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>
}
```

### Benefits

* Supports dependency injection
* Easy to mock for unit testing
* Clean separation from UI layer

---

## 🖼 Image Loading & Caching

* Custom `ImageLoader` implementation
* In-memory caching
* Prevents redundant network calls
* Smooth scrolling performance

---

## ⚠️ Error Handling

* Centralized error manager
* Graceful error handling for API failures
* User-friendly error messages via reusable alert manager

---

## 🧰 Technical Stack

| Area             | Technology                    |
| ---------------- | ----------------------------- |
| Language         | Swift                         |
| UI               | UIKit (Programmatic)          |
| Architecture     | MVVM-C                        |
| Reactive         | Combine                       |
| Networking       | URLSession                    |
| Image Caching    | Custom (No 3rd-party library) |
| State Management | ViewState Enum                |
| Error Handling   | Centralized Error Manager     |

---

## ⏳ Development Time

⏱ **3–4 hours**

> With a full working day, further improvements would include:
>
> * Unit testing for ViewModel & Networking
> * Better separation of concerns
> * Offline caching support
> * Improved search performance
> * Accessibility enhancements

---

## 🚀 How to Run

1. Clone the repository:

   ```bash
   git clone https://github.com/mazharulbelal/NewsExplorer.git
   ```
2. Open `NewsExplorer.xcodeproj`
3. Add your **News API key** in `AppEnvironment.swift`
4. Run on an iPhone simulator or device

❗❗❗ Note: Currently, the API key is kept in AppEnvironment.swift for simplicity.
For production or public repositories, store API keys in a secure location, such as environment variables or a secure plist.

---

## 👨‍💻 Author

**Md Mazharul Islam (Belal)**
iOS Engineer

🌐 Portfolio: [http://mazharulbelal.github.io](http://mazharulbelal.github.io)


---
