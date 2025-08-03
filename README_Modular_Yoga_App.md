# 🧘 Modular Yoga Session App

A Flutter-based mobile app designed to guide users through structured yoga sessions using audio, images, and pose metadata from a JSON file. Built with flexibility in mind — add new sessions easily without changing code.

---

## Features

-  **Modular sessions** from JSON files
- Audio instructions per pose
- Visual guidance with pose images
- Automatic pose transitions
- Play / Pause controls
- Background music support
- Streak tracking with Shared Preferences
- Animated session completion screen
- Web-compatible (runs in Chrome)
- Dynamic session loading (add new `.json` sessions)

---

## Folder Structure

```
lib/
├── main.dart                     # App entry point
├── models/                       # Data models (e.g., Pose, ModularFlow)
├── services/                     # JSON & asset loaders
├── screens/
│   ├── home_screen.dart          # Home page with session list
│   ├── modular_session_screen.dart # Modular session player
├── widgets/
│   └── session_card.dart         # Reusable card widget for sessions
assets/
├── audio/                        # Audio clips for poses & sessions
├── images/                       # Images for poses and backgrounds
├── sessions/
│   ├── catcow.json               # Example modular session
│   ├── poses_converted.json      # Another session
```

---

## How to Add New Sessions

1. Create a new `.json` session (see `catcow.json` as reference)
2. Place audio files in `assets/audio/`
3. Place images in `assets/images/`
4. Update `pubspec.yaml` to include new assets (optional if using asset wildcards)
5. Run `flutter pub get`



## Setup Instructions

1. Clone this repo  
2. Ensure Flutter is installed (`flutter doctor`)  
3. Run `flutter pub get`  
4. Launch on Chrome or Android:
   ```bash
   flutter run -d chrome
   # or
   flutter run -d android
   ```

---

## JSON Format

Example `catcow.json` format:

```json
{
  "metadata": { "title": "Cat-Cow Flow", "defaultLoopCount": 4 },
  "assets": {
    "images": { "cat": "Cat.png" },
    "audio": { "intro": "cat_cow_intro.mp3" }
  },
  "sequence": [
    {
      "type": "segment",
      "audioRef": "intro",
      "durationSec": 10,
      "script": [
        {
          "text": "Inhale... arch your spine.",
          "startSec": 0,
          "endSec": 10,
          "imageRef": "cat"
        }
      ]
    }
  ]
}
```


