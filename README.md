# PKP User Management System

A full-stack Ruby on Rails application providing User Management (CRUD), Web Session Authentication (Login/Register), and a RESTful API secured with JWT tokens[cite: 1].

---

## Technical Stack

* **Language:** Ruby 3.3+
* **Framework:** Ruby on Rails 8 (no Devise/Sorcery gems used per assessment guidelines)[cite: 1]
* **Database:** PostgreSQL
* **Styling:** Tailwind CSS
* **Interactivity:** Hotwire (Turbo + Stimulus)
* **API Authentication:** Custom JWT (`jwt` gem)
* **Soft Deletes:** `acts_as_paranoid`
* **Containerization:** Docker & Docker Compose

---

## Features & Business Rules

1. **Custom Authentication:** Built from scratch using Rails `has_secure_password`[cite: 1].
2. **Strict Validations:**
   * Unique Email as primary registration key[cite: 1].
   * Name must start with a letter and contain only letters and spaces[cite: 1].
   * Password min length: 6 characters[cite: 1].
   * Password complexity: Requires uppercase, lowercase, digit, and special character[cite: 1].
3. **Soft Deletion:** Soft deletes users (`deleted_at`) preserving database integrity.
4. **Interactive UI:** Smooth flash messages with Turbo Streams and dynamic password input toggle via Stimulus.
5. **Restricted Actions:** Users cannot delete their own account.

---

## Quick Start with Docker

### Prerequisites
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed on Windows/Mac/Linux.

### Installation & Application Setup[cite: 1]

1. **Extract and Navigate to Directory:**
```bash
cd pkp-user-management
```

2. **Build and Start Containers:**
```bash
docker compose up --build
```
Note: Database creation, migrations, and seeding run automatically on boot via docker-compose.yml.

4. **Access the Web Application:**
Open your browser at `http://localhost:3000`.


---

## Default Seed Credentials

Once the containers start, you can log in using:

* **Email:** `admin@test.com`
* **Password:** `P4ss_word`

---

## Test Suite Execution

You can also run the complete RSpec test suite covering Models, Web Requests, and API Endpoints:
docker compose exec web bundle exec rspec

---

## RESTful API Endpoints

Base URL: `http://localhost:3000/api/v1`

### 1. Public Authentication Endpoints

#### Register

* **POST** `/api/v1/register`
* **Body:**
```json
{
  "email": "user@example.com",
  "name": "Rahmad Riyadi",
  "password": "P4ssword!"
}

```

* **Response (201 Created):** Returns JWT token and user object.

#### Login

* **POST** `/api/v1/login`
* **Body:**
```json
{
  "email": "admin@test.com",
  "password": "P4ss_word"
}

```


* **Response (200 OK):** Returns JWT token and user object.

---

### 2. Protected Users Endpoints

> **Note:** Include the header `Authorization: <your_jwt_token>` for all protected requests.

| Method | Endpoint | Description |
| --- | --- | --- |
| **GET** | `/api/v1/current_user` | Fetch current authenticated user |
| **GET** | `/api/v1/users` | List all non-deleted users |
| **GET** | `/api/v1/users/:id` | Show specific user |
| **POST** | `/api/v1/users` | Create new user |
| **PATCH/PUT** | `/api/v1/users/:id` | Update user details |
| **DELETE** | `/api/v1/users/:id` | Soft-delete user (Self-deletion forbidden) |