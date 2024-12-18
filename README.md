# Flutter Calculator App - Project Submission Documentation

## Project Overview
A feature-rich calculator application built with Flutter that implements core calculation functionality, history tracking, and several bonus features.

### Core Features Implemented
1. **Basic Calculator Operations**
   - Addition, subtraction, multiplication, and division
   - Error handling for division by zero
   - Input validation and user feedback

2. **Interactive UI**
   - On-screen number pad (0-9)
   - Operation buttons (+, -, *, /)
   - Equal sign (=) and Clear (C) buttons
   - Click-only interaction (no keyboard input)

3. **History Management**
   - Local storage implementation using Hive
   - Show/Hide history functionality
   - Clear history option
   - History filtering by operation type

4. **Bonus Features Implemented**
   - Light/Dark mode support with theme switching
   - Input validation with user feedback
   - History filtering by operation type
   - Animated history view toggling

## Technical Implementation

### Architecture
The project follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/
│   ├── repositories/
│   └── data_providers/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── use_cases/
└── presentation/
    ├── blocs/
    ├── screens/
    └── widgets/
```

### State Management
- **Flutter Bloc** for state management
- Separate Event and State classes for clear state handling
- Bloc implementation for calculator operations and history management

### Storage Solution
- **Hive** for local storage
- Persistent history storage
- Efficient data retrieval and storage

### Dependencies Used
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  math_expressions: ^2.4.0
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

## Setup Instructions

1. Clone the repository:
```bash
git clone [repository-url]
cd calculator_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters:
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## Design Choices

### UI/UX Decisions
1. **Clean Interface**
   - Minimalist design for better user focus
   - Clear visual hierarchy
   - Responsive layout that works across device sizes

2. **Theme Support**
   - Light and dark mode for user preference
   - Consistent color scheme across themes
   - Easy theme toggle in app bar

3. **History Display**
   - Bottom sheet implementation for easy access
   - Filterable history by operation type
   - Clear visual separation between expression and result

### Technical Decisions
1. **Clean Architecture**
   - Separation of concerns for better maintainability
   - Clear dependency flow
   - Easy to test and modify components

2. **Hive for Storage**
   - Fast, lightweight local storage solution
   - Type-safe with code generation
   - Better performance compared to SQLite for simple data

3. **Error Handling**
   - Comprehensive validation of expressions
   - User-friendly error messages
   - Graceful handling of edge cases

## Testing
The app includes:
- Unit tests for core logic
- Widget tests for UI components
- Integration tests for critical user flows

## Future Improvements
1. Additional calculator functions (scientific operations)
2. History export functionality
3. Custom themes support
4. Gesture-based interactions
5. Cloud backup for history

