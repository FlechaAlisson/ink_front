# ink_front

A new Flutter project.

## Getting Started

lib/
├─ core/
│ ├─ errors/
│ ├─ utils/
│ ├─ theme/
│ ├─ router/
│ ├─ widgets/
│ └─ firebase/
│ ├─ firebase_providers.dart
│ └─ firebase_options.dart
│
├─ features/
│ ├─ auth/
│ │ ├─ bloc/
│ │ │ ├─
│ │ │ └─
│ │ ├─ data/
│ │ │ └─ auth_repository.dart
│ │ ├─ model/
│ │ │ └─ user_model.dart
│ │ └─ view/
│ │ ├─ login_page.dart
│ │ ├─ register_page.dart
│ │ └─ widgets/
│ │ └─ text_fields.dart
│ │
│ ├─ appointments/
│ │ ├─ controller/
│ │ │ ├─ appointment_controller.dart
│ │ │ └─ appointment_provider.dart
│ │ ├─ data/
│ │ │ └─ appointment_repository.dart
│ │ ├─ model/
│ │ │ └─ appointment_model.dart
│ │ └─ view/
│ │ ├─ appointments_page.dart
│ │ └─ widgets/
│ │ └─ appointment_card.dart
│
├─ app/
│ ├─ app_widget.dart
│ └─ app_provider.dart
│
└─ main.dart
