<div align="center">

# 📚 Fahamni
### Understand me — a full-stack private tutoring marketplace

[![Flutter](https://img.shields.io/badge/Flutter-3.11%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![React](https://img.shields.io/badge/React-19-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite-Build-646CFF?style=for-the-badge&logo=vite&logoColor=white)](https://vitejs.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](./LICENSE)

A modern platform for connecting students, parents, tutors, and admins through secure booking, real-time communication, and AI-powered study support.

</div>

---

## 🌟 Overview

Fahamni is a 2CP end-of-year project created at École Nationale Supérieure d'Informatique (ESI), Algiers. It brings together:

- students looking for certified tutors,
- parents tracking their children’s learning,
- tutors managing sessions and services,
- admins overseeing the whole marketplace.

The platform is powered by Flutter for the mobile experience, React + Vite for the admin dashboard, and Firebase for authentication, Firestore, storage, and cloud functions.

---

## 👨‍💼 My Role

I served as Team Lead on this project and personally built the core interaction layer of the mobile app, including:

- 🗓️ session scheduling and booking workflows
- 💬 real-time messaging with rich media support
- 🤖 an embedded AI study assistant
- ⭐ review and feedback flows
- 👤 tutor profile experiences
- 🗂️ Firestore-backed data models and parent dashboard features

---

## ✨ Key Features

### Mobile App

- Multi-role authentication with email/password, Google Sign-In, SMS OTP, and email OTP
- Tutor onboarding and approval workflow
- Public tutor profiles with credentials, ratings, and services
- Map-based discovery of tutoring services
- Booking, acceptance, rescheduling, and history tracking for sessions
- Real-time chat with text, images, audio, and file attachments
- AI study assistant for summarizing conversations, generating questions, and explaining concepts
- Quote and estimate requests with PDF export
- Reviews and ratings after completed sessions
- Push notifications and parent dashboard support

### Admin Web Dashboard

- Tutor validation and rejection workflow
- User and profile management
- Reports triage and admin messaging
- Statistics dashboards with charts
- Multilingual UI in English, French, and Arabic
- Real-time updates for pending tutors and reports

---

## 🏗️ Project Structure

```text
Fahamni/
├── fahamni/
│   ├── mobile/           # Flutter mobile application
│   │   ├── lib/          # App screens, services, models, repositories
│   │   ├── assets/       # Images, icons, fonts, and map style
│   │   └── pubspec.yaml
│   └── web/              # React admin dashboard
│       ├── src/          # Pages, components, Firebase config, i18n
│       └── package.json
├── android/ ios/ linux/ macos/ windows/
├── assets/
└── README.md
```

---

## 🧱 Architecture

### Data Layer

The app uses Cloud Firestore with separate collections for:

- users
- students
- tutors
- parents
- admins
- conversations
- messages
- notifications
- services
- sessions
- reports
- reviews

Firestore security rules enforce access control based on role, ownership, and participant membership.

### Mobile Auth Flow

The app routes users by role after authentication:

- student → student dashboard
- tutor → pending or validated teacher dashboard
- parent → parent dashboard
- suspended accounts → dedicated suspension gate

### Messaging System

The messaging layer supports:

- direct and group conversations,
- rich media attachments,
- audio messages,
- a built-in AI assistant panel.

### AI Study Assistant

The assistant can be configured to use either Anthropic Claude or Google Gemini and adapts its behavior based on the tutoring context, task type, and student level.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.11+
- Dart SDK 3.11+
- Node.js 18+
- Firebase project with Firestore, Auth, Storage, and Functions enabled
- Optional: Anthropic or Gemini API key for AI features

### Mobile App

```bash
git clone https://github.com/YOUR_USERNAME/Fahamni.git
cd Fahamni/fahamni/mobile
flutter pub get
```

Configure Firebase by adding:

- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist

Create your AI env file if needed:

```bash
cp ../../.env.example .env
```

Run the app:

```bash
flutter run
```

### Admin Dashboard

```bash
cd fahamni/web
npm install
npm run dev
```

---

## ⚙️ Configuration

### Mobile App — .env

The app can load AI settings from a .env file in the mobile project. Supported variables include:

- AI_PROVIDER
- ANTHROPIC_API_KEY
- ANTHROPIC_SMALL_MODEL
- ANTHROPIC_LARGE_MODEL
- GEMINI_API_KEY
- GEMINI_SMALL_MODEL
- GEMINI_LARGE_MODEL

If no env file is present, the app still runs and AI features simply remain unavailable.

### Firestore Rules

Deploy rules with:

```bash
firebase deploy --only firestore:rules
```

---

## 🧰 Tech Stack

### Mobile

- Flutter / Dart
- Firebase Auth, Firestore, Storage, Functions
- Google Maps, Geolocation, and routing
- Audio recording and media attachments
- PDF generation and printing
- dotenv and shared preferences

### Web

- React 19
- Vite
- Firebase SDK
- i18next for multilingual support
- Recharts for analytics

---

## 👥 Team

Fahamni was developed as a 2CP end-of-year project at ESI Algiers by a team of six students.

| Name | Contribution |
|---|---|
| Meznaoui Abdelmouname | Team Lead, messaging, sessions, AI assistant, review system, tutor profiles |
| Mahieddine Mohamed Mimoun | Admin dashboard, estimates/PDF system, Firebase infrastructure, i18n |
| Hamza Benrabah | Student home, teacher dashboard, notifications, schedule |
| Bedoui Wassim | Student backend, map exploration, services UI |
| Aimed Benahmed | Mobile auth flows, SMS OTP |
| Alicia Messaoud | Status screens and initial user-info flows |

---

## 🤝 Contributing

1. Fork the repository and create a branch.
2. Make your changes and test them locally.
3. Open a pull request with a clear description.

---

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.
