# Amigo - AI Chat Bot

Amigo is a Flutter-based chatbot application that uses Google's Gemini AI to provide intelligent conversational responses.

## Features

- Real-time chat interface with Gemini AI
- Markdown support for formatted AI responses
- Clean and modern UI with dark theme
- Message history in the current session
- Typing indicators for better UX

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter** (version 3.0 or higher)
- **Dart** (comes with Flutter)
- **Android Studio** or **Xcode** (for mobile development)
- A **Google Gemini API key** (get one at [Google AI Studio](https://aistudio.google.com))

## Getting Started

### 1. Clone and Setup

```bash
# Navigate to the project directory
cd Amigo-app

# Get Flutter dependencies
flutter pub get
```

### 2. Configure API Key

The app requires a Google Gemini API key to function. Follow these simple steps:

1. Get your free API key from [Google AI Studio](https://aistudio.google.com)
2. Rename the example file:
   ```bash
   # Windows
   ren lib\config\api_key.example.txt lib\config\api_key.txt
   
   # macOS / Linux
   mv lib/config/api_key.example.txt lib/config/api_key.txt
   ```
3. Open `lib/config/api_key.txt` and replace the placeholder with your API key:
   ```
   YOUR_ACTUAL_API_KEY_HERE
   ```

**Note:** The `lib/config/api_key.txt` file is in `.gitignore` and will never be committed to version control, keeping your API key safe.

### 3. Run the App

```bash
# Run on default device/emulator
flutter run

# Run on specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

### 4. Build APK/IPA

```bash
# Build Android APK
flutter build apk

# Build iOS
flutter build ios
```

## Project Structure

```
Amigo-app/
├── lib/
│   ├── main.dart           # App entry point
│   ├── mybot.dart          # ChatBot widget and logic
│   └── config/
│       ├── api_key.txt     # Your API key (not in git)
│       └── api_key.example.txt  # Template
├── test/
│   └── widget_test.dart
├── android/                # Android configuration
├── ios/                    # iOS configuration
├── web/                    # Web configuration
└── pubspec.yaml           # Dependencies
```

## Dependencies

Key packages used:

- **dash_chat_2** - Chat UI component
- **flutter_markdown** - Markdown rendering for AI responses
- **http** - API communication

## Troubleshooting

### "API Configuration Error" dialog when app starts

- Ensure you've renamed `lib/config/api_key.example.txt` to `lib/config/api_key.txt`
- Check that the file contains a valid API key (not empty or containing placeholder text)
- Make sure there are no extra spaces or blank lines in the file
- After fixing the file, rebuild: `flutter clean && flutter pub get && flutter run`

### Build errors

```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

### API errors

- Check your internet connection
- Verify your API key is valid at [Google AI Studio](https://aistudio.google.com)
- Ensure your API key has quota remaining
- Check console output for detailed error messages

## Security

**Your API key file is protected from git commits** using `.gitignore`. It is:
- Stored as `lib/config/api_key.txt` in your project (never committed to git)
- Bundled with the app as an asset at build time
- Not visible in the source code repository

## License

This project is open source.
