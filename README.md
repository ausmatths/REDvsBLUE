# REDvsBLUE

<div align="center">
  <h3>🏆 Match. Play. Compete. 🏆</h3>
  <p><strong>A real-world sports matchmaking and ranking platform inspired by Steam's competitive model</strong></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-3.5.4+-02569B?logo=flutter" alt="Flutter">
    <img src="https://img.shields.io/badge/Dart-3.9.0+-0175C2?logo=dart" alt="Dart">
    <img src="https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase" alt="Firebase">
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green" alt="Platform">
    <img src="https://img.shields.io/badge/License-Proprietary-red" alt="License">
    <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen" alt="PRs">
  </p>

  <p>
    <a href="#-overview">Overview</a> •
    <a href="#-key-features">Features</a> •
    <a href="#-getting-started">Getting Started</a> •
    <a href="#-roadmap">Roadmap</a> •
    <a href="#-contributing">Contributing</a>
  </p>
</div>

---

## 📖 Overview

**REDvsBLUE** is a cutting-edge mobile application that bridges the gap between digital matchmaking and real-world sports. Inspired by competitive gaming platforms like Steam, Dota 2, and PUBG, REDvsBLUE brings ELO-based ranking, skill-matched opponents, and tournament organization to physical sports enthusiasts.

The platform connects players across multiple sports disciplines (Badminton, Cricket, Football, Basketball, and more), integrates with local venues for seamless booking, tracks performance through comprehensive statistics and leaderboards, and provides real-time chat for coordination and community building.

### 🎯 Mission

To empower sports enthusiasts by providing easy access to evenly matched opponents, convenient venue booking, and competitive ranking systems for real-life matches.

### 🌟 Vision

To be the leading digital platform for organizing and enhancing real-world sports experiences through matchmaking, rankings, and community engagement.

---

## ✨ Key Features

### 🎮 Matchmaking Engine
- **ELO/MMR-Based Ranking System**: Intelligent skill-based matchmaking
- **GMR Points System**: GameMate Rating points track player performance
- **Medal Levels**: Bronze → Silver → Gold → Platinum → Diamond → Master → Grand Master
- **Multi-Sport Support**: Badminton, Cricket, Football, Basketball, and more
- **Quick Match**: Instant matchmaking across all sports

### 🏟️ Venue Integration
- **Real-Time Availability**: Live court/field availability tracking
- **Integrated Booking**: Seamless venue reservation system
- **Location-Based Search**: Find nearby sports facilities
- **Partner Venues**: Exclusive deals with local sports complexes

### 📊 Player Profiles & Statistics
- **Comprehensive Stats**: Win/loss records, match history, performance trends
- **Achievement System**: Badges, milestones, and rewards
- **Leaderboards**: Local and global rankings
- **Match History**: Detailed record of all past games

### 🏆 Tournament Management
- **Bracket System**: Support for 4, 8, 16, and 32-team tournaments
- **Automated Scheduling**: Smart slot allocation and round progression
- **Live Updates**: Real-time tournament brackets and scores
- **Prize Pools**: In-app tournament entry fees and rewards

### 💬 Chat & Social Features
- **Real-Time Messaging**: Instant chat with opponents and teammates
- **Match Coordination**: Plan games and discuss strategies
- **Friend Lists**: Connect with regular opponents
- **Team Creation**: Form and manage sports teams
- **Group Chats**: Team discussions and community groups
- **Community Events**: Local sports meetups and gatherings

---

## 🏗️ Technical Architecture

### Tech Stack

#### Frontend
- **Framework**: Flutter 3.5.4+ (Dart SDK)
- **State Management**: Riverpod 2.6.1 with code generation
- **Navigation**: GoRouter 13.2.5
- **UI Components**:
    - Flutter Animate (animations)
    - Cached Network Image (image caching)
    - Flutter SVG (vector graphics)
    - Google Fonts (typography)
    - FL Chart (data visualization)

#### Backend & Services
- **Authentication**: Firebase Auth (Email, Phone OTP, Google Sign-In)
- **Database**: Cloud Firestore (real-time NoSQL database)
- **Backend (Planned)**: Node.js + Express + PostgreSQL
- **Real-Time Features**: WebSockets / Firebase Realtime Database

#### APIs & Integrations
- **Location Services**: Geolocator for GPS and location tracking
- **Network Layer**: Dio 5.7.0 with custom interceptors
- **Local Storage**:
    - Hive (NoSQL local database)
    - SharedPreferences (key-value storage)

#### Code Quality
- **Architecture**: Clean Architecture with feature-based modules
    - Each feature follows the **3-layer pattern**: Data → Domain → Presentation
    - **Data Layer**: API calls, local storage, repositories implementation
    - **Domain Layer**: Business logic, entities, use cases, repository interfaces
    - **Presentation Layer**: UI screens, widgets, state management (Riverpod providers)
- **Code Generation**:
    - Freezed (immutable models)
    - JSON Serializable (API models)
    - Riverpod Generator (state management)
- **Linting**: Flutter Lints 3.0

### 📁 Project Structure

```
REDvsBLUE/
├── lib/
│   ├── core/
│   │   ├── constants/          # App-wide constants (colors, strings, sizes, sport types)
│   │   ├── errors/             # Custom error handling (failures, exceptions)
│   │   ├── network/            # Dio client, API endpoints
│   │   ├── router/             # GoRouter configuration
│   │   ├── theme/              # App theming (colors, text styles)
│   │   └── utils/              # Utilities (validators, formatters, extensions)
│   │
│   ├── features/
│   │   ├── auth/               # Authentication (login, register, OTP verification)
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── matchmaking/        # Player matchmaking and match search
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── venue/              # Venue listing, details, and booking
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── profile/            # User profiles and statistics
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── tournament/         # Tournament creation and management
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── ranking/            # Leaderboards and rankings
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── chat/               # Real-time messaging and communication
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │
│   │   └── home/               # Main dashboard and navigation
│   │       └── presentation/
│   │           └── screens/
│   │
│   ├── shared/                 # Shared components
│   │   ├── models/             # Common data models
│   │   ├── providers/          # Shared state providers
│   │   └── widgets/            # Reusable UI components
│   │       ├── buttons/
│   │       ├── cards/
│   │       ├── dialogs/
│   │       └── loaders/
│   │
│   ├── app.dart                # App initialization and configuration
│   └── main.dart               # Entry point
│
├── assets/
│   ├── animations/             # Lottie animations
│   ├── fonts/                  # Custom fonts
│   ├── icons/                  # App icons
│   └── images/                 # Image assets
│       ├── medals/             # Rank medal images
│       └── sports/             # Sport-specific graphics
│
├── android/                    # Android native code
├── ios/                        # iOS native code
├── web/                        # Web platform support
├── backup/                     # Configuration backups
├── pubspec.yaml               # Dependencies and configuration
└── README.md                  # This file
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.5.4 or higher
- **Dart SDK**: 3.9.0 or higher
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Platform Support**:
    - ✅ **Android**: Minimum SDK 21 (Android 5.0)
    - ✅ **iOS**: iOS 12.0+
    - ✅ **Web**: Progressive Web App support (in development)
- **Development Tools**:
    - Android Studio / Xcode for platform-specific builds
    - Firebase account for backend services
    - Git for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ausmatths/REDvsBLUE.git
   cd REDvsBLUE
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
    - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
    - Add Android and iOS apps to your Firebase project
    - Download and place configuration files:
        - `google-services.json` → `android/app/`
        - `GoogleService-Info.plist` → `ios/Runner/`
    - Enable Authentication methods (Email/Password, Phone, Google Sign-In)
    - Set up Cloud Firestore database

4. **Add assets** (if not already present)
    - Place medal images in `assets/images/medals/`
    - Place sport icons in `assets/images/sports/`
    - Add any custom fonts to `assets/fonts/`
    - Add animations to `assets/animations/`

5. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   # Run on connected device/emulator (default)
   flutter run
   
   # Run on specific platform
   flutter run -d chrome          # Web
   flutter run -d android         # Android
   flutter run -d ios             # iOS
   
   # Run in release mode
   flutter run --release
   ```

7. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle (for Play Store)
   flutter build appbundle --release
   
   # iOS
   flutter build ios --release
   
   # Web
   flutter build web --release
   ```

### Environment Configuration

Create a `.env` file in the root directory (this file is gitignored):

```env
# API Keys
GOOGLE_MAPS_API_KEY=your_google_maps_key
RAZORPAY_KEY=your_razorpay_key

# Firebase (if needed for web)
FIREBASE_API_KEY=your_firebase_api_key
```

---

## 📱 Screens & User Flow

### Authentication Flow
1. **Splash Screen** → Brand introduction with animated logo
2. **Onboarding** → Sport selection and skill level setup
3. **Login** → Email/phone authentication
4. **Register** → New user signup
5. **OTP Verification** → Phone number verification

### Main Application Screens

#### Home Navigation (Bottom Bar)
- 🎾 **Match Tab** → Matchmaking screen (sport selection, quick match)
- 📍 **Venues Tab** → Venue list, details, and booking
- 🏆 **Tournaments Tab** → Tournament list and brackets
- 📊 **Ranking Tab** → Leaderboards and player rankings
- 👤 **Profile Tab** → User profile, stats, and settings

#### Additional Screens
- **Match Search** → Real-time opponent search by sport
- **Match Details** → Game details, venue, time, opponent info
- **Venue Booking** → Court/field reservation interface
- **Chat** → Messaging with opponents and teams (in development)

---

## 📖 User Journey

### User Journey

1. **Onboarding**
    - Sport selection
    - Skill level assessment
    - Profile creation

2. **Matchmaking**
    - Choose sport and skill level
    - AI-powered opponent matching
    - Venue suggestion based on location

3. **Booking**
    - View available time slots
    - Book court/field
    - Payment integration

4. **Playing**
    - Match confirmation
    - Check-in at venue
    - Score tracking

5. **Post-Match**
    - Automatic GMR points calculation
    - Stats update
    - Leaderboard ranking adjustment

---

## 💰 Business Model

### Revenue Streams

1. **Subscription Plans**
    - **Free Tier**: Basic matchmaking, standard leaderboards
    - **Premium Tier**: Priority booking, advanced analytics, tournament hosting
    - **Pro Tier**: Personal coaching insights, exclusive venue access

2. **Venue Commissions**
    - 10-15% commission on bookings made through the platform
    - Partnership deals with sports complexes

3. **In-App Purchases**
    - Profile customizations (badges, themes)
    - Tournament entry fees
    - Achievement boosters

4. **Advertising & Sponsorships**
    - Sports gear brands
    - Nutrition companies
    - Local sports academies

---

## 🎯 Roadmap

### Phase 1: MVP (Months 1-3)
- [x] Project setup and architecture
- [x] Clean Architecture implementation with feature modules
- [x] Authentication screens (Login, Register, OTP Verification, Onboarding)
- [x] Home screen with bottom navigation
- [x] Matchmaking screen with sport selection
- [x] Match search functionality
- [x] Venue listing and details screens
- [x] Profile screen structure
- [x] Tournament list screen
- [x] Leaderboard/Ranking screen
- [x] Chat module foundation
- [ ] Backend API integration
- [ ] Real-time matchmaking logic
- [ ] GMR points calculation
- [ ] Venue booking flow completion

### Phase 2: Core Features (Months 3-6)
- [ ] Add Football and Cricket
- [ ] Automated venue API integration
- [ ] Tournament bracket system
- [ ] Real-time match updates
- [x] Chat module structure setup
- [ ] Complete social features (friend lists, group chats)
- [ ] Payment gateway integration

### Phase 3: Expansion (Months 6-12)
- [ ] Add Basketball, Pickleball, and Tennis
- [ ] Advanced ELO algorithm refinement
- [ ] AI-based coaching insights
- [ ] Corporate team features
- [ ] Wearable fitness tracker integration
- [ ] Multi-city expansion

### Phase 4: Scale (Year 2+)
- [ ] National rollout
- [ ] Professional tournament hosting
- [ ] Sponsorship management
- [ ] Mobile app optimizations
- [ ] Web platform launch

### 📍 Current Implementation Status

**✅ Completed Features:**
- Complete Clean Architecture setup with 8 feature modules
- Authentication flow (splash, onboarding, login, register, OTP verification)
- Home screen with bottom navigation (5 tabs)
- Matchmaking screen with animated sport selection
- Match search interface
- Venue list and details screens
- Venue booking screen
- Profile screen
- Tournament list screen
- Leaderboard/Ranking screen
- Chat module structure
- Core utilities (router, theme, constants)
- Shared widgets (buttons, cards, dialogs, loaders)
- Asset organization (medals, sports images, icons, fonts)

**🚧 In Progress:**
- Firebase integration and backend connectivity
- Real-time matchmaking algorithm
- GMR points calculation system
- Complete venue booking flow
- Tournament bracket implementation
- Chat functionality
- Social features (friends, teams)

**📋 Next Up:**
- Backend API development
- Payment gateway integration
- Real-time match updates
- Advanced analytics dashboard
- Push notifications

---

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🔧 Troubleshooting

### Common Issues

**1. Build Runner Conflicts**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**2. Firebase Configuration**
- Ensure `google-services.json` is in `android/app/`
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Run `flutterfire configure` if using FlutterFire CLI

**3. CocoaPods Issues (iOS)**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

**4. Gradle Build Failures (Android)**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**5. Code Generation Not Working**
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 📝 Development Tips

**Adding a New Feature Module:**
```bash
# Use the create_structure.sh script or manually create:
lib/features/your_feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

**State Management Best Practices:**
- Use Riverpod providers for state management
- Keep providers close to where they're used
- Use code generation with `@riverpod` annotation
- Implement loading, data, and error states

**Clean Architecture Guidelines:**
- **Never** import presentation layer in domain layer
- **Never** import data layer in domain layer
- Domain layer should be pure Dart (no Flutter dependencies)
- Use dependency injection via repository interfaces

**Running Code Generation Watch Mode:**
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- Follow Flutter/Dart style guide
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

---

## 🐛 Known Issues & Current Limitations

### In Development
- **Backend Integration**: Firebase services connected but API endpoints need implementation
- **Chat Functionality**: Chat screens created but real-time messaging pending
- **Matchmaking Algorithm**: ELO/GMR calculation logic in development
- **Payment Gateway**: Integration pending for automated venue payments
- **Tournament Brackets**: Visual bracket UI needs dynamic data implementation

### Planned Features
- **Push Notifications**: Real-time match alerts and updates
- **Advanced Analytics**: Detailed performance tracking and insights
- **Social Features**: Friend system, team management, community groups
- **Venue Partnerships**: Automated booking API integration
- **Multi-language Support**: Localization for different regions

### Platform Limitations
- **MVP Phase**: Currently focused on mobile platforms (Android/iOS)
- **Limited Sports**: Initially launching with Badminton, Football, Cricket, Basketball
- **Geo-Restrictions**: Initially launching in select metropolitan cities
- **Manual Processes**: Some venue bookings may require manual coordination initially

---

## 📄 License

This project is proprietary software. All rights reserved.

---

## 👥 Team

**REDvsBLUE Development Team**
- [Your Name] - Project Lead
- [Team Members] - Developers

---

## 📞 Contact & Support

- **Website**: [Coming Soon]
- **Email**: support@redvsblue.app
- **GitHub**: [https://github.com/ausmatths/REDvsBLUE](https://github.com/ausmatths/REDvsBLUE)
- **Discord**: [Join our community](#)

---

## 🎖️ Acknowledgments

- Inspired by Steam's matchmaking system
- Flutter community for amazing packages
- Early beta testers and sports enthusiasts
- Partner venues and sports complexes

---

## 📊 Project Statistics

![Flutter](https://img.shields.io/badge/Flutter-3.5.4-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9.0-blue.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

---

<div align="center">
  <p><strong>Built with ❤️ by the REDvsBLUE Team</strong></p>
  <p><em>"Bringing the competitive spirit of gaming to real-world sports"</em></p>
</div>