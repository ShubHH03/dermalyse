# Dermalyse - AI-Powered Skin Disease Detection App

Dermalyse is a mobile application built with Flutter that leverages a powerful machine learning model to analyze images of skin conditions. Users can upload or capture a photo, and the app provides an analysis with the top three most probable skin diseases.

---

## 📱 App Screenshots

| Home Screen                                                                 | Analysis Result                                                              |
| --------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| ![Screenshot 1](https://via.placeholder.com/300x600.png?text=Upload+Screen) | ![Screenshot 2](https://via.placeholder.com/300x600.png?text=Results+Screen) |

---

## ✨ Key Features

- **Image Upload & Capture**: Easily select an image from your gallery or capture a new one with your camera.
- **AI-Powered Analysis**: Submits the image to a custom backend API for processing with a deep learning model.
- **Instant Results**: Displays the top 3 most likely skin conditions with their respective confidence scores.
- **Cross-Platform**: Built with Flutter for a seamless experience on both Android and iOS.
- **Simple & Intuitive UI**: A clean and user-friendly interface for easy navigation.

---

## 🛠️ System Architecture

The Dermalyse system consists of two main components:

1.  **Flutter Mobile App**: The user-facing application responsible for capturing images and displaying results.
2.  **Flask Backend API**: A Python-based server that hosts the machine learning model, receives image data, performs the prediction, and returns the results.

---

## 🚀 Getting Started with the Flutter App

Follow these instructions to get a local copy of the Dermalyse Flutter app up and running.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- An editor like VS Code or Android Studio
- A running instance of the [DermalyseAPI](https://github.com/jiten0709/DermalyseAPI) (see backend setup below).

### Installation & Setup

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/jiten0709/DermalyseApp.git
    cd DermalyseApp
    ```

2.  **Install dependencies:**

    ```sh
    flutter pub get
    ```

3.  **Configure the API Endpoint:**
    In the project, locate the configuration file () and update the `API_BASE_URL` to point to your running backend server.

    ```dart
    // Path: lib/constants.dart
    const String apiBaseUrl = "http://127.0.0.1:5001"; // Or your ngrok URL
    ```

4.  **Run the application:**
    ```sh
    flutter run
    ```

---

## ⚙️ Backend API Setup

The Flutter app requires the [DermalyseAPI](https://github.com/jiten0709/DermalyseAPI) to be running. For detailed instructions, please refer to the API's repository.

**Quick Setup Steps:**

1.  **Clone the API repository:**
    ```bash
    git clone https://github.com/jiten0709/DermalyseAPI.git
    cd DermalyseAPI
    ```
2.  **Create and activate a virtual environment:**
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    ```
3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
4.  **Start the server:**
    ```bash
    python3 run.py
    ```
    The API will be available at `http://127.0.0.1:5001`.

---

## 🤝 Contributing

Contributions are welcome! If you have suggestions for improving the app, please feel free to fork the repository and open a pull request.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/NewFeature`)
3.  Commit your Changes (`git commit -m 'Add some NewFeature'`)
4.  Push to the Branch (`git push origin feature/NewFeature`)
5.  Open a Pull Request

---
