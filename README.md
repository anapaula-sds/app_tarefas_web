# Nome do App

> Breve descrição de uma ou duas linhas sobre o propósito do aplicativo.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## 📱 Sobre o projeto

Descreva aqui o objetivo do app, o público-alvo e o problema que ele resolve.

### Principais funcionalidades

- Funcionalidade 1
- Funcionalidade 2
- Funcionalidade 3

## 🖼️ Screenshots

| Tela 1 | Tela 2 | Tela 3 |
|--------|--------|--------|
| ![tela1](docs/screenshots/tela1.png) | ![tela2](docs/screenshots/tela2.png) | ![tela3](docs/screenshots/tela3.png) |

## 🏗️ Arquitetura

Descreva o padrão de arquitetura adotado (ex: Clean Architecture, MVVM, feature-first).

```
lib/
├── core/              # Configurações, temas, utils, constantes
├── data/              # Repositórios, datasources, models
├── domain/            # Entidades e casos de uso
├── presentation/      # Telas, widgets, controllers/blocs
└── main.dart
```

## 🚀 Tecnologias

- **Flutter** — SDK principal
- **Dart** — linguagem
- **[State Management]** — ex: Riverpod, Bloc, Provider
- **[Backend/API]** — ex: Dart Frog, REST, GraphQL
- **[Banco local]** — ex: Sqflite, Drift, Hive
- **[Autenticação]** — ex: Firebase Auth
- **FVM** — controle de versão do Flutter SDK

## ⚙️ Pré-requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) (versão gerenciada via [FVM](https://fvm.app/))
- [FVM](https://fvm.app/documentation/getting-started/installation)
- Android Studio / Xcode configurados para emuladores
- Uma conta de acesso a `.env` / secrets do projeto (solicitar ao time)

## 🔧 Instalação

Clone o repositório:

```bash
git clone https://github.com/sua-org/seu-repo.git
cd seu-repo
```

Instale a versão correta do Flutter via FVM:

```bash
fvm install
fvm use
```

Instale as dependências:

```bash
fvm flutter pub get
```

Configure as variáveis de ambiente:

```bash
cp .env.example .env
# preencha as chaves necessárias
```

Gere os arquivos de código (se o projeto usar `build_runner`):

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## ▶️ Executando o projeto

```bash
# Emulador/dispositivo padrão
fvm flutter run

# Especificando ambiente (flavor)
fvm flutter run --flavor dev -t lib/main_dev.dart

# Web
fvm flutter run -d chrome
```

## 🧪 Testes

```bash
# Testes unitários e de widget
fvm flutter test

# Com cobertura
fvm flutter test --coverage
```

## 📦 Build

```bash
# Android (App Bundle)
fvm flutter build appbundle --flavor prod -t lib/main_prod.dart

# Android (APK)
fvm flutter build apk --release

# iOS
fvm flutter build ipa --flavor prod -t lib/main_prod.dart
```

## 🌱 Ambientes / Flavors

| Flavor | Descrição | Entry point |
|--------|-----------|-------------|
| `dev`  | Ambiente de desenvolvimento | `lib/main_dev.dart` |
| `staging` | Ambiente de homologação | `lib/main_staging.dart` |
| `prod` | Produção | `lib/main_prod.dart` |

## 🗂️ Estrutura de branches

- `main` — produção, apenas via merge de `release/*`
- `develop` — integração contínua
- `feature/*` — novas funcionalidades
- `fix/*` — correções de bugs
- `release/*` — preparação de versão

## ✅ Convenções de commit

Utilizamos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: adiciona tela de login
fix: corrige crash ao abrir câmera
chore: atualiza dependências
docs: atualiza README
```

## 🔄 CI/CD

Descreva o pipeline (ex: GitHub Actions) e o que cada workflow faz:

- `.github/workflows/ci.yml` — lint, testes e build em cada PR
- `.github/workflows/release.yml` — build e publicação nas lojas

## 📄 Licença

Distribuído sob a licença MIT. Veja `LICENSE` para mais detalhes.

## 👥 Contribuindo

1. Faça um fork do projeto
2. Crie sua branch (`git checkout -b feature/nome-da-feature`)
3. Commit suas mudanças (`git commit -m 'feat: minha feature'`)
4. Push para a branch (`git push origin feature/nome-da-feature`)
5. Abra um Pull Request

## 📬 Contato

Nome — email@exemplo.com
