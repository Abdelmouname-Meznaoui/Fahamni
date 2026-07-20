<div align="center">

# 📚 Fahamni
### *"Understand me"* — A Full-Stack Private Tutoring Marketplace

[![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![React](https://img.shields.io/badge/React-19-61DAFB?style=flat-square&logo=react&logoColor=black)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite-Build-646CFF?style=flat-square&logo=vite&logoColor=white)](https://vitejs.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](./LICENSE)

**2CP End-of-Year Project — École Nationale Supérieure d'Informatique (ESI), Algiers**

*Students find and book certified tutors. Parents monitor their children's learning. Admins manage the whole platform — powered by Firebase and an embedded AI study assistant.*

</div>

---

## 👋 About My Role

I served as **Team Lead** on Fahamni, a 6-person graduation project. Alongside coordinating the team, I personally built the core interaction layer of the mobile app:

- 🗓️ **Session scheduling** — booking, accept/decline flow, status & history tracking
- 💬 **Real-time messaging** — group & direct conversations, images, audio, file attachments, media galleries
- 🤖 **AI Study Assistant** — Claude/Gemini-powered chat assistant embedded in tutoring conversations
- ⭐ **Reviews system** — post-session ratings and feedback
- 👤 **Teacher profiles** — public tutor profile pages and credential display
- 🗂️ **Database models & parent dashboard** — Firestore data layer and parent-facing views

---

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Dependencies](#dependencies)
- [Team](#team)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### 📱 Mobile App

| Feature | Description |
|---|---|
| **Multi-role authentication** | Email/password, Google Sign-In, SMS OTP, and email OTP for students, tutors, and parents |
| **Teacher onboarding & approval** | Tutors upload certification files at registration; accounts stay pending until admin validation |
| **Teacher profiles** ⭐ | Public-facing tutor profile pages showing expertise, credentials, rating, and services |
| **Map-based service discovery** | Interactive Google Maps screen with geolocation and routing to browse tutoring services |
| **Tutoring services** | Tutors create named services with subject, level, mode (in-person/online), price, and availability |
| **Session scheduling** ⭐ | Students book sessions; tutors accept or decline; full status and history tracking |
| **Real-time messaging** ⭐ | Group & direct conversations — text, images, audio messages, file attachments, media galleries |
| **AI Study Assistant** ⭐ | Slide-up sheet in any tutor conversation — ask Claude (Anthropic) or Gemini to summarise chats, generate practice questions, simplify tutor messages, or explain concepts. Provider and model switchable via `.env` |
| **Quote & estimate system** | Students request price quotes; tutors respond with formal estimates exportable as PDF |
| **Feedback & ratings** ⭐ | Students leave star reviews for tutors after sessions |
| **Push notifications** | In-app notification centre backed by a Firestore `notifications` collection |
| **Suspended-account gate** | Suspended users see a dedicated status screen instead of the main UI |
| **Parent dashboard** ⭐ | Parents track linked children's schedules, tutors, and courses; can explore services for a child |
| **Courses** | Tutors organise enrolled students into courses with sessions, members, and shared resources |

*⭐ = features I built and owned*

### 🖥️ Admin Web Dashboard

| Feature | Description |
|---|---|
| **Teacher validation workflow** | Review pending tutor applications, inspect credentials, validate or reject with a reason |
| **User management** | Browse/search students, tutors, parents; view profiles; suspend or reinstate accounts |
| **Reports management** | Triage session and behaviour reports submitted by users |
| **Admin messaging** | Open a conversation with any user directly from their profile |
| **Statistics** | Recharts-powered charts for user growth, session trends, tutor activity, and revenue |
| **Real-time notifications** | Live Firestore listeners push new applications and reports to the bell icon instantly |
| **Multilingual UI** | English, French, and Arabic with full RTL document direction switching |
| **Admin settings** | Profile editing and language preference persisted in Firestore and `localStorage` |

---

## Project Structure

```text
Fahamni/
├── fahamni/
│   ├── mobile/                         # Flutter cross-platform mobile app
│   │   ├── lib/
│   │   │   ├── main.dart               # Entry point; AuthGate routes by role
│   │   │   ├── firebase_options.dart   # Generated Firebase config (per-platform)
│   │   │   ├── models/                 # Dart data classes
│   │   │   │   ├── user_model.dart     # Abstract base; factory dispatches to sub-types
│   │   │   │   ├── student_model.dart
│   │   │   │   ├── tutor_model.dart    # expertise, rating, certification fields
│   │   │   │   ├── parent_model.dart
│   │   │   │   ├── chat_model.dart     # ConversationModel + MessageModel
│   │   │   │   ├── service_model.dart
│   │   │   │   ├── session_model.dart
│   │   │   │   ├── notification_model.dart
│   │   │   │   ├── quote_model.dart
│   │   │   │   ├── resource_model.dart
│   │   │   │   ├── review_model.dart
│   │   │   │   └── ai_message.dart     # AI chat history entry
│   │   │   ├── Services/               # Business logic & Firebase wrappers
│   │   │   │   ├── auth_.service.dart          # Sign-up, sign-in, Google, OTP, certification upload
│   │   │   │   ├── ai_service.dart             # Claude / Gemini streaming AI assistant
│   │   │   │   ├── chat_service.dart           # Conversation CRUD, messaging
│   │   │   │   ├── notification_service.dart   # In-app push notifications
│   │   │   │   ├── session_service.dart        # Session lifecycle
│   │   │   │   ├── services_service.dart       # Tutor service listings
│   │   │   │   ├── student_tutor_action_service.dart
│   │   │   │   ├── review_service.dart
│   │   │   │   ├── ressource_service.dart
│   │   │   │   ├── admin_support_chat_service.dart
│   │   │   │   ├── email_otp_service.dart
│   │   │   │   ├── phone_auth_service.dart
│   │   │   │   ├── parent_child_service.dart
│   │   │   │   ├── guest_mode_service.dart
│   │   │   │   └── suspended_account_gate.dart
│   │   │   ├── repositories/           # Data-access layer abstraction
│   │   │   │   ├── chat_repository.dart
│   │   │   │   ├── firestore_chat_repository.dart
│   │   │   │   ├── review_repository.dart
│   │   │   │   └── firestore_review_repository.dart
│   │   │   ├── navigation/
│   │   │   │   └── app_navigation.dart
│   │   │   ├── messaging/              # All chat UI
│   │   │   │   ├── conversation_page.dart
│   │   │   │   ├── chat_page.dart
│   │   │   │   ├── message_bubble.dart
│   │   │   │   ├── Message_input.dart       # Rich input: text, image, audio, file
│   │   │   │   ├── ai_assistant_sheet.dart  # Slide-up AI panel
│   │   │   │   ├── ai_study_chat_page.dart
│   │   │   │   └── admin_support_chat_page.dart
│   │   │   ├── StudentHomePage/
│   │   │   ├── TeacherDashboard/
│   │   │   ├── ParentDashboread/
│   │   │   ├── Courses/
│   │   │   ├── Explore_map_pages/
│   │   │   ├── estimate/               # Quote request, estimate builder, PDF export
│   │   │   ├── feedback/
│   │   │   ├── Login_Screen/
│   │   │   ├── Onboarding/
│   │   │   ├── Notification_page/
│   │   │   ├── Account_Settings_Student/
│   │   │   ├── Account_Settings_Teacher/
│   │   │   ├── Account_Settings_Parent/
│   │   │   ├── User_status/
│   │   │   ├── utils/
│   │   │   └── widgets/
│   │   ├── firestore.rules
│   │   ├── storage.rules
│   │   ├── functions/
│   │   ├── assets/
│   │   └── pubspec.yaml
│   │
│   └── web/                            # React admin dashboard
│       ├── src/
│       │   ├── main.jsx
│       │   ├── App.jsx                 # Firebase Auth gate
│       │   ├── Dashboard.jsx           # Shell layout + routing state machine
│       │   ├── Login.jsx
│       │   ├── TeachersPage.jsx
│       │   ├── TeacherProfilePage.jsx
│       │   ├── UsersPage.jsx
│       │   ├── UserProfilePage.jsx
│       │   ├── ReportsPage.jsx
│       │   ├── MessagesPage.jsx
│       │   ├── StatisticsPage.jsx
│       │   ├── SettingsPage.jsx
│       │   ├── ServiceDetailPanel.jsx
│       │   ├── firebase.js
│       │   ├── i18n.js                 # i18next + RTL switching
│       │   └── locales/
│       │       ├── en.json
│       │       ├── fr.json
│       │       └── ar.json
│       ├── package.json
│       └── vite.config.js
│
├── Instalation web/                    # Static landing page
├── android/ ios/ linux/ macos/ windows/
├── .env.example
└── package.json
```

---

## Architecture

### Data Model & Firestore Collections

All data lives in Cloud Firestore, structured as separate top-level collections per role:

| Collection | Purpose |
|---|---|
| `users` | Lightweight auth lookup: `uid`, `email`, `role`, `account_status`, `is_suspended` |
| `students` | Full student profiles |
| `tutors` | Tutor profiles — `expertise_domain`, `certification_url`, `account_status` (pending/validated/rejected), `average_rating` |
| `parents` | Parent profiles with child links |
| `admins` | Admin accounts; presence here grants admin Firestore privileges |
| `conversations` | Chat threads; `participants[]` drives access control |
| `messages` | Sub-collection under each conversation |
| `notifications` | In-app notifications for the mobile notification centre |
| `services` | Tutor service listings |
| `sessions` | Booked sessions with a full status lifecycle |
| `reports` | User-submitted reports on sessions or behaviour |
| `reviews` | Star ratings tied to tutor + student + session |

Firestore security rules (`fahamni/mobile/firestore.rules`) encode the permission model: `isAdmin()` checks for a document in `admins/` under the caller's UID; conversation access uses `participants[]` membership; tutors own their services and sessions via `tutor_id` field checks.

### Mobile Auth Flow

`main.dart → AuthGate._checkAuth()`:

1. No Firebase user → show `OnboardingScreen` (first run) or `LoginScreen`.
2. Logged in → fetch `users/{uid}` for role and `is_suspended`.
3. Fetch the role-specific profile document to double-check `is_suspended`.
4. Dispatch to the correct home screen:
   - `student` → `Studenthomepage`
   - `tutor` + pending → `TeacherGuestDashboardScreen`
   - `tutor` + validated → `TeacherDashboardScreen`
   - `parent` → `Parenthomepage`
   - any + `is_suspended == true` → `SuspendedAccountGate.accountScreenForRole(role)`

### Messaging System

The real-time messaging layer sits on `chat_service.dart` and the `chat_repository` abstraction, backed by `conversations/{id}/messages` sub-collections:

- **Conversation types** — direct (student ↔ tutor) and group threads, driven by the `participants[]` array in each conversation document.
- **Rich content** — text, images, audio recordings (`record` + `just_audio`), and file attachments, each rendered by `message_bubble.dart` with a dedicated media gallery view.
- **Composer** — `Message_input.dart` handles text, camera/file picking, and audio capture in a single rich input component.
- **Access control** — Firestore rules gate reads/writes on `participants[]` membership, so only conversation members can read or send messages.

### AI Study Assistant

`AIService` (`lib/Services/ai_service.dart`) streams responses token-by-token from either **Anthropic Claude** or **Google Gemini**, selected at runtime via `AI_PROVIDER` in `.env`.

The system prompt is dynamically constructed from:

- The student's `StudyLevel` (primary / secondary / university) — adjusts vocabulary and depth.
- The `AITaskType` (summarise, practice question, simplify, explain, smart reply, general help) — adjusts the task instruction.
- An injected transcript of the real tutor conversation as context.

The service first attempts a streaming HTTP request; if streaming fails (e.g. browser CORS restrictions), it falls back to a non-streaming POST and simulates streaming by yielding words with 15ms delays.

Model selection is task-aware: `explainConcept` uses the **large** model; all other tasks use the **small** model — both configurable in `.env`.

### Session Scheduling

Session lifecycle is managed by `session_service.dart` and `session_model.dart`:

- Students initiate a booking request against a tutor's published service (`services_service.dart`).
- Tutors accept or decline from their dashboard; state transitions are written to the `sessions` collection.
- Each session retains a status history so both parties can see past accept/decline/reschedule events.
- Completed sessions unlock the review flow.

### Reviews System

Post-session, students can leave a star rating and comment via `review_service.dart`, backed by the `review_repository` / `firestore_review_repository` abstraction. Reviews are written to the `reviews` collection keyed by tutor + student + session, and roll up into each tutor's `average_rating` shown on their profile.

### Teacher Profiles

Public tutor profile pages surface `expertise_domain`, `certification_url` status, `average_rating`, and published services, pulling from the `tutors` collection and aggregating live review data.

### Admin Web Dashboard

`Dashboard.jsx` is a single-component state machine: all pages share a common `active` string (`"dashboard"`, `"teachers"`, `"users"`, …). Page components are conditionally rendered — no router library needed. Error boundaries (`PageErrorBoundary`) wrap each page so a crash in one section doesn't bring down the whole shell.

Real-time notifications arrive via two `onSnapshot` listeners (pending tutors + pending reports) that run for the lifetime of the session. Read state is stored in `localStorage` under a per-admin key.

The i18n system (`src/i18n.js`) uses `react-i18next` with three locale bundles (EN / FR / AR). Switching to Arabic also flips `document.documentElement.dir` to `"rtl"`. The admin's language preference is stored in their Firestore document and applied on login.

---

## Installation

### Prerequisites

- Flutter SDK ≥ 3.11 and Dart SDK ≥ 3.11
- Node.js ≥ 18 and npm
- A Firebase project with Firestore, Auth, Storage, and Functions enabled
- *(Optional)* Anthropic API key or Google Gemini API key for AI features

### Mobile App (Flutter)

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/Fahamni.git
cd Fahamni/fahamni/mobile

# 2. Install Flutter dependencies
flutter pub get

# 3. Configure Firebase
# Place your google-services.json in android/app/
# Place your GoogleService-Info.plist in ios/Runner/

# 4. Create your .env file for AI features (optional)
cp ../../.env.example .env
# Fill in ANTHROPIC_API_KEY or GEMINI_API_KEY

# 5. Run on a connected device or emulator
flutter run
```

> **Note:** The app uses `firebase_app_check` with `AndroidProvider.debug` — suitable for development. Switch to `AndroidProvider.playIntegrity` for production builds.

### Admin Web Dashboard (React)

```bash
cd fahamni/web

# 1. Install dependencies
npm install

# 2. Configure Firebase
# Edit src/firebase.js with your Firebase project credentials

# 3. Start the development server
npm run dev
# → http://localhost:5173

# 4. Production build
npm run build
```

---

## Usage

### Running the Mobile App

```bash
cd fahamni/mobile

# Debug on Android
flutter run -d android

# Debug on iOS
flutter run -d ios

# Release APK
flutter build apk --release
```

### Running the Admin Dashboard

```bash
cd fahamni/web
npm run dev
```

Navigate to `http://localhost:5173`. Log in with an admin account — the user's UID must exist in the `admins` Firestore collection.

### Seeding Test Data

```bash
# From fahamni/web/
node seed-test-data.cjs          # General seed
node seed-rejected-teachers.cjs  # Seed teachers with rejected status
node seed_last_login.cjs         # Backfill last_login timestamps
node migrate-is-suspended.cjs    # Migration: add is_suspended to existing docs
```

> Requires `serviceAccountKey.json` (Firebase Admin SDK private key) in the same directory. **Do not commit this file.**

---

## Configuration

### Mobile App — `.env`

Place at `fahamni/mobile/.env` (copy from `.env.example`):

| Variable | Default | Description |
|---|---|---|
| `AI_PROVIDER` | `anthropic` | AI backend: `anthropic` or `gemini` |
| `ANTHROPIC_API_KEY` | — | Your Anthropic API key |
| `ANTHROPIC_SMALL_MODEL` | `claude-3-5-haiku-latest` | Fast tasks (summarise, smart reply, practice Q) |
| `ANTHROPIC_LARGE_MODEL` | `claude-3-7-sonnet-latest` | Deep tasks (explain concept) |
| `GEMINI_API_KEY` | — | Your Google Gemini API key |
| `GEMINI_SMALL_MODEL` | `gemini-2.5-flash` | Gemini fast model |
| `GEMINI_LARGE_MODEL` | `gemini-2.5-pro` | Gemini deep model |

If `.env` is absent, the app starts normally — AI features are simply unavailable.

### Firestore Security Rules

```bash
firebase deploy --only firestore:rules
```

---

## Dependencies

### Mobile (Flutter / Dart)

| Package | Purpose |
|---|---|
| `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` | Core Firebase SDK |
| `firebase_app_check` | App attestation |
| `cloud_functions` | Server-side logic via Firebase Functions |
| `google_sign_in` | OAuth login via Google account |
| `google_maps_flutter` | Interactive map for service discovery |
| `geolocator`, `geocoding`, `flutter_polyline_points` | Location and routing |
| `http` | Streaming HTTP requests to AI APIs |
| `flutter_dotenv` | Loads `.env` at startup |
| `record`, `just_audio` | Audio message recording and playback |
| `file_picker`, `image_picker` | Attachment and camera access |
| `pdf`, `printing` | Quote/estimate PDF generation |
| `flutter_markdown`, `flutter_math_fork` | Render AI responses with Markdown and LaTeX |
| `cached_network_image` | Remote image caching |
| `shared_preferences` | Local persistence |
| `intl` | Date/time formatting |
| `permission_handler` | Runtime permissions |

### Web (React / Node)

| Package | Purpose |
|---|---|
| `react` + `react-dom` v19 | UI library |
| `firebase` v12 | Firestore and Auth client SDK |
| `i18next` + `react-i18next` | EN / FR / AR with RTL support |
| `recharts` | Statistics charts |
| `lucide-react` | Icon set |
| `vite` | Build tool and dev server |

---

## Team

Fahamni was developed as a 2CP end-of-year project at ESI Algiers by a team of six students.

| Name | Role |
|---|---|
| **Meznaoui Abdelmouname (Team Lead)** | Session scheduling, real-time messaging, AI Study Assistant, reviews system, teacher profiles, database models, parent dashboard |
| Mahieddine Mohamed Mimoun | Admin web dashboard, estimate/PDF system, Firebase infrastructure, i18n, deployment |
| Hamza Benrabah | Student homepage, teacher dashboard, notifications, schedule |
| Bedoui Wassim | Student backend page, Google Maps / explore, service UI |
| Aimed Benahmed | Mobile auth flows, SMS OTP |
| Alicia Messaoud | Status screens, initial user-info pages |

---

## Contributing

1. Fork the repository and create a branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Run `flutter analyze` (mobile) or `npm run lint` (web) before committing.
3. Keep Firestore security rules in sync with any new collections you add.
4. Open a pull request with a clear description of the change.

---

## License

MIT License — see [LICENSE](./LICENSE) for details.
