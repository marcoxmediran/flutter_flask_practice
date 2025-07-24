# Flutter Flask Practice

A simple note taking mobile application

## Technologies

- Flutter
- Flask
- MySQL

## Project Setup

1. Clone the repository

```bash
git clone https://github.com:marcoxmediran/flutter_flask_practice.git
cd flutter_flask_practice/
```

2. Run a MySQL server, and create database as specified by [Flask App](https://github.com/marcoxmediran/flutter_flask_practice/blob/main/api/app.py)

3. Install python packages and run the Flask REST API

```bash
cd api/
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

4. Navigate back to the project root directory, and run the Flutter application on an emulator

```bash
cd notes_app/
flutter run
```
