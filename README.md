# DAILY-DRIFT

**DAILY-DRIFT** is a Flutter app that helps you build consistency in your daily routines. It sends end-of-day reminders to mark completed tasks, resets them for the next day, and shows you a dashboard with progress insights, streaks, and ai chat bot.

---

## 🧭 Features

- Create, read, update, and delete daily tasks (routines)  
- End-of-day notification to mark which tasks you completed  
- Automatic reset of task completion for the next day  
- Dashboard with insights:  
  - Consistency percentage (how often you complete *all* tasks)  
  - Streaks (consecutive days of full completion)  

---

## 🛠 Tech Stack

- Flutter (for cross-platform UI)  
- Firebase Authentication (for per-user accounts)  
- Cloud Firestore (to store user routines and daily completion logs)  
- Local notifications to trigger reminders  
- Material 3 theming  

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed  
- A Firebase project with Authentication & Firestore enabled  
- Android/iOS development setup

### Setup steps

1. Clone the repository:

   ```bash
   git clone https://github.com/GoDxVictoryRR/DAILY-DRIFT-.git
   cd DAILY-DRIFT-
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase:

   - Add `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) in the respective directories.  
   - Ensure Authentication (e-mail/password or your preferred sign-in method) is enabled.  
   - Set up Firestore rules so each user’s data is private.

4. Run on device or emulator:

   ```bash
   flutter run
   ```

---


## 🔮 Potential Enhancements / Future Ideas

- AI-powered suggestions: Suggest new routines based on habits  
- Natural language input: Let users type “Walk 30 min each morning” and parse automatically  
- Smarter notifications: Adjust reminding time based on user behavior  
- Weekly/monthly reports of consistency  

---

## 💬 Contributing

Contributions, issues, and feature requests are welcome!  

1. Fork the project  
2. Create your feature branch (`git checkout -b feature/my-feature`)  
3. Commit your changes (`git commit -m 'Add some feature'`)  
4. Push to the branch (`git push origin feature/my-feature`)  
5. Open a Pull Request  

---

## ⭐ About the Name

“**DAILY-DRIFT**” stands for the idea of gently drifting toward better habits each day — small consistent steps add up.
