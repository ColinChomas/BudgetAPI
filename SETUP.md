# Budget API - Setup & Running Guide

## Prerequisites

- Node.js 16+ installed
- PostgreSQL 12+ installed and running
- Database created and populated with schema

## Installation

1. **Install dependencies:**
```bash
npm install
```

2. **Set up environment variables:**

Copy `.env.example` to `.env` and update with your database credentials:
```bash
cp .env.example .env
```

Edit `.env`:
```
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=budget_api
PORT=3000
```

3. **Create and populate database:**

```bash
# Create database
createdb -U postgres budget_api

# Run schema
psql -U postgres -d budget_api -f "src/database/Budget.sql"

# Load test data (optional)
psql -U postgres -d budget_api -f "src/database/test-data.sql"
```

## Running the Server

### Development (with auto-reload)
```bash
npm run dev
```

### Production
```bash
npm run build
npm start
```

The server will start on `http://localhost:3000`

## Using the Dashboard

1. Open your browser and go to `http://localhost:3000`
2. Select a table from the left sidebar
3. View all records in the table
4. **Add**: Click "+ Add Record" button
5. **Edit**: Click "Edit" button on any row
6. **Delete**: Click "Delete" button on any row (with confirmation)

## API Endpoints

All endpoints return JSON responses with `{ success: boolean, data?: object, error?: string }`

### General Format
```
GET    /api/{table}              - Get all records (pagination: ?limit=100&offset=0)
GET    /api/{table}/:id          - Get single record
POST   /api/{table}              - Create record (send JSON body)
PUT    /api/{table}/:id          - Update record (send JSON body)
DELETE /api/{table}/:id          - Delete record
GET    /api/{table}/search/:column/:value - Search records
```

### Example Requests

**Get all users:**
```bash
curl http://localhost:3000/api/users
```

**Get specific user:**
```bash
curl http://localhost:3000/api/users/1
```

**Create new account:**
```bash
curl -X POST http://localhost:3000/api/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "name": "Savings Account",
    "type": "savings",
    "current_balance": 5000,
    "expected_balance": 5000
  }'
```

**Update transaction:**
```bash
curl -X PUT http://localhost:3000/api/transactions/1 \
  -H "Content-Type: application/json" \
  -d '{
    "status": "confirmed",
    "notes": "Updated note"
  }'
```

**Delete record:**
```bash
curl -X DELETE http://localhost:3000/api/users/1
```

**Search:**
```bash
curl http://localhost:3000/api/users/search/username/testuser
```

## Available Tables

- `users` - User accounts
- `accounts` - Bank/savings accounts
- `transactions` - All financial transactions
- `categories` - Transaction categories
- `budgets` - Budget definitions
- `budget-periods` - Budget tracking periods
- `goals` - Savings goals
- `loans` - Debt tracking
- `contacts` - Frequent contacts
- `tags` - Custom tags for organization
- `alerts` - User alerts/notifications
- `recurring-patterns` - Recurring transaction patterns
- `audit-logs` - System audit trail

## Troubleshooting

### "connect ECONNREFUSED" error
- Make sure PostgreSQL is running
- Check DB credentials in `.env`

### "relation does not exist" error
- Run the Budget.sql schema file first
- Verify database name matches `.env`

### CORS errors in dashboard
- Make sure server is running on `http://localhost:3000`
- Browser must reach the server directly (not through proxy)

### Port 3000 already in use
- Change `PORT` in `.env`
- Or kill the process: `lsof -ti:3000 | xargs kill -9`

## Project Structure

```
src/
├── index.ts              - Main server file
├── database/
│   ├── connection.ts     - Database connection pool
│   ├── Budget.sql        - Schema creation
│   └── test-data.sql     - Sample data
├── modules/
│   └── GenericCRUDService.ts - Reusable CRUD service
├── routes/
│   └── crudRouter.ts     - Dynamic route creator
└── controllers/          - (for future custom logic)

public/
└── index.html            - Web dashboard

.env                       - Environment variables (create from .env.example)
package.json              - Dependencies and scripts
```

## Features

Full CRUD operations on all tables  
Web dashboard  
RESTful API endpoints  
JSON request/response format  
Error handling and validation  
Auto-generated timestamps (created_at, updated_at)  
Pagination support  
Search functionality  
CORS enabled (can add more origins)  

## Next Steps

- Add authentication/authorization
- Add input validation
- Add filtering/sorting
- Add more advanced search
- Add relationship queries
- Add export to CSV
- Deploy to production server
