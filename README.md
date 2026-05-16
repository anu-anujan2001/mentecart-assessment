# MenteCart – Service Booking System

A full-stack mobile booking platform built using Flutter, BLoC, Node.js, Express, TypeScript, and MongoDB.

---

# Tech Stack

## Frontend
- Flutter
- BLoC
- Dio
- Shared Preferences

## Backend
- Node.js
- Express.js
- TypeScript
- MongoDB
- Mongoose
- JWT Authentication
- Swagger

---

# Features

## Authentication
- Register
- Login
- JWT Authentication
- Role-based access

## Services
- View services
- Service details
- Slot selection
- Category support

## Cart
- Add to cart
- Update quantity
- Remove items

## Booking
- Checkout
- Payment method selection
- Booking history
- Booking status tracking

Booking lifecycle:

pending → confirmed → completed  
cancelled  
failed  

---

# Project Structure

## Backend

backend/
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── services/
│   ├── middleware/
│   ├── validators/
│   └── docs/

## Frontend

frontend/
├── lib/
│   ├── core/
│   ├── data/
│   ├── presentation/
│   └── main.dart

---

# Installation

## Backend Setup

### Clone

git clone https://github.com/anu-anujan2001/mentecart-assessment.git

### Enter backend

cd backend

### Install dependencies

npm install

### Create .env

PORT=5000

MONGODB_URI=mongodb://localhost:27017/mentecart

JWT_SECRET=your_secret_key

### Run backend

npm run dev
npm start

Backend:

http://localhost:5000

Swagger:

http://localhost:5000/api-docs

---

## Frontend Setup

### Enter frontend

cd frontend

### Install dependencies

flutter pub get

### Run

flutter run

---

# API Endpoints

## Auth

POST /auth/signup

POST /auth/login

GET /auth/me

---

## Services

GET /services

GET /services/:id

POST /services (admin)

---

## Cart

GET /cart

POST /cart/items

PATCH /cart/items/:id

DELETE /cart/items/:id

---

## Booking

POST /bookings/checkout

GET /bookings

GET /bookings/:id

POST /bookings/:id/cancel

PATCH /bookings/:id/complete (admin)

---

# Default Roles

## Customer
- Browse services
- Add to cart
- Checkout
- View bookings

## Admin
- Create services
- Manage services
- Complete bookings

---

# Bonus Features Implemented

- Error middleware
- Request logging
- Swagger documentation
- Role-based authorization

---

# Demo Video

https://youtube.com/shorts/xMabWWZh1jg?feature=share
