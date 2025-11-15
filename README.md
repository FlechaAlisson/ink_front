# 🧿 Ink Front — Aplicativo de Agendamentos para Estúdios de Tatuagem

Aplicação **Flutter** focada em **agendamento de horários**, **gestão de usuários** e **integração completa com backend via Cloud Functions + Firestore**.  
O repositório contém toda a camada de apresentação, navegação, UI, estados e comunicação com o backend.

---

# 📌 Objetivo do Projeto

- Criar um app moderno e simples para o cliente visualizar horários disponíveis, agendar sessões e gerenciar seu perfil.
- Oferecer ao tatuador uma arquitetura sólida, escalável e integrada ao ecossistema Firebase.
- Facilitar a manutenção e expansão futura, usando arquitetura limpa, modular e baseada em estados.

---

# 🏗️ Arquitetura Geral

O projeto segue uma abordagem **modular**, organizada em:

- **Features**
  - Agendamentos
  - Usuário
  - Perfil
  - Onboarding
- **Shared Layer**
  - Widgets
  - Estilos e temas
  - Helpers
- **Core**
  - Auth
  - Configurações globais
  - Navegação

---

# 🔥 Fluxos do Sistema (com imagens)

## 📅 Fluxo de Agendamento

### **Descrição do fluxo**

- O aplicativo solicita horários disponíveis ao backend.
- O backend delega a lógica ao Firestore.
- Os horários retornam pelo mesmo caminho até o App.
- O usuário escolhe e agenda.
- O backend valida, registra no Firestore e retorna confirmação.

### **Principais ações**

- Busca horários disponíveis
- Validação de conflitos
- Registro de agendamento
- Retorno ao app

---

## 👤 Fluxo de Registro de Usuário

### **Descrição do fluxo**

- O app envia os dados iniciais do usuário para o backend.
- O backend cria o usuário no _Authentication_.
- Com o ID retornado, cria o documento do usuário no _Firestore_.
- O backend devolve o identificador final ao app.

### **Principais ações**

- Criação segura do usuário
- Persistência unificada no Firestore
- Integração com Firebase Authentication

---

# 🧩 Tecnologias Utilizadas

| Tecnologia                  | Uso                             |
| --------------------------- | ------------------------------- |
| **Flutter**                 | Desenvolvimento multiplataforma |
| **Firebase Authentication** | Autenticação de usuários        |
| **Cloud Firestore**         | Banco de dados                  |
| **Cloud Functions**         | Backend serverless              |
| **Flutter Bloc**            | Gerenciamento de estado         |
| **Dart**                    | Linguagem principal             |

---

# 📚 Estrutura de Pastas

```text
lib/
  features/
    appointments/
    user/
    profile/
  core/
    auth/
    navigation/
  shared/
    widgets/
    styles/
    utils/
```
