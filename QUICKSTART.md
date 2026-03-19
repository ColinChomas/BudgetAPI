# Quick Start Guide

## 1. Install Dependencies
```bash
npm install
```

## 2. Set Up Environment
```bash
cp .env.example .env
# Edit .env with your PostgreSQL credentials
```

## 3. Create & Populate Database
```bash
# Create database (if not exists)
createdb -U postgres budget_api

# Create tables
psql -U postgres -d budget_api -f "src/database/Budget.sql"

# Load test data (optional)
psql -U postgres -d budget_api -f "src/database/test-data.sql"
```

## 4. Start the Server
```bash
# Development (with auto-reload)
npm run dev

# Or production
npm run build
npm start
```

## 5. Open Dashboard
Visit: **http://localhost:3000**

---

## That's it! 🎉

You now have:
- ✅ Full CRUD API for all tables
- ✅ Beautiful web dashboard
- ✅ REST endpoints you can call from anywhere

## Quick Examples

### View a table
```
GET http://localhost:3000/api/users
```

### Add a record
```bash
curl -X POST http://localhost:3000/api/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "name": "New Account",
    "type": "savings",
    "current_balance": 1000,
    "expected_balance": 1000
  }'
```

### Update a record
```bash
curl -X PUT http://localhost:3000/api/transactions/1 \
  -H "Content-Type: application/json" \
  -d '{"status": "confirmed"}'
```

### Delete a record
```bash
curl -X DELETE http://localhost:3000/api/users/1
```

---

See SETUP.md for more detailed information!
