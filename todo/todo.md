# Budget App – System Design & API Plan

I asked AI to reorganize the yap file (preplan.txt) that I had created from Voice-to-text while driving into this plan.

## Overview

A personal budgeting application that:

- Tracks income, expenses, loans, and budgets
- Automatically calculates available money
- Supports savings goals
- Handles multiple accounts
- Tracks pending transactions
- Works across devices via a hosted API

---

# Core System Architecture

The backend should be divided into logical modules.

## Modules

1. Users / Authentication
2. Accounts
3. Income Sources
4. One-Time Income
5. Expenses
6. Budget Categories
7. Goals
8. Pending Transactions
9. Tax Calculations
10. Transaction Timeline

---

# 1. User Authentication

Handles account access and settings.

## Features

- User login
- Access from any device
- Personal financial data isolation
- Settings configuration

## API


POST /users
POST /auth/login
GET /users/{id}
PATCH /users/{id}/settings


---

# 2. Accounts

Represents where money is stored.

Examples:

- Checking
- Savings
- Cash

## Features

- Multiple accounts
- Track actual balance
- Track expected balance

## Data Model


Account

id

user_id

name

type

current_balance

expected_balance


## API


GET /accounts
POST /accounts
PATCH /accounts/{id}
DELETE /accounts/{id}


---

# 3. Income Sources

Recurring income streams.

Examples:

- Paychecks
- Rental income
- Side jobs

## Features

- Weekly / biweekly / monthly frequency
- Multiple income sources
- Ability to disable income without deleting history

## Data Model


IncomeSource

id

user_id

name

amount

frequency

active

start_date

end_date


## API


GET /income-sources
POST /income-sources
PATCH /income-sources/{id}
DELETE /income-sources/{id}


---

# 4. One-Time Income

For non-recurring payments.

Examples:

- Selling items
- Friend paying you
- Dividends

## Data Model


OneTimeIncome

id

user_id

amount

description

date


## API


POST /income/one-time
GET /income/one-time


---

# 5. Expenses

Tracks individual spending events.

Examples:

- Groceries
- Gas
- Restaurants

## Features

- Description
- Category
- Linked account
- Timestamp

## Data Model


Expense

id

user_id

account_id

category_id

amount

description

date


## API


GET /expenses
POST /expenses
DELETE /expenses/{id}


---

# 6. Budget Categories

Defines planned spending limits.

Examples:

- Rent
- Groceries
- Fun
- Utilities

## Features

- Weekly / biweekly / monthly budgets
- Automatic tracking
- Optional rollover

## Data Model


BudgetCategory

id

user_id

name

amount

frequency

rollover_enabled


## API


GET /budgets
POST /budgets
PATCH /budgets/{id}


---

# 7. Goals

Savings targets.

Examples:

- Save $2000
- Vacation fund
- Emergency fund

## Features

- Automatic contributions
- Progress tracking
- Frequency-based contributions

## Data Model


Goal

id

user_id

target_amount

contribution_amount

contribution_frequency

current_progress


## API


GET /goals
POST /goals
PATCH /goals/{id}


---

# 8. Pending Transactions

Tracks money not yet finalized.

Examples:

- Friend owes you money
- You owe someone money

## Features

- Does not affect confirmed balance
- Shows potential balance changes

Example display:


Balance: $2000
Pending: +$100
Potential Balance: $2100


## Data Model


PendingTransaction

id

user_id

amount

type

description

status


## API


GET /pending
POST /pending
PATCH /pending/{id}/confirm


---

# 9. Budget Rollover

Handles unused budget funds.

Example:


Food Budget: $300
Spent: $200
Remaining: $100


User options:

- Keep in category
- Move to another category
- Apply to savings goal

## API


POST /budgets/{id}/rollover


---

# 10. Tax Calculations

Optional financial calculations.

Possible taxes:

- Sales tax
- Property tax
- Estimated income tax

## Data Model


TaxProfile

income_tax_rate

property_tax

sales_tax


## API


GET /tax
POST /tax/settings


---

# 11. Transaction Timeline

Unified financial history feed.

Example timeline:


Jan 10 – Grocery Store – -$45
Jan 11 – Paycheck – +$850
Jan 12 – Friend owes you – +$100 (pending)


## API


GET /timeline


---

# Core Financial Calculations

## Available Money


available =
total_income

recurring_budgets

goal_contributions

expenses


---

## Expected Account Balance


expected_balance =
starting_balance

income

expenses


---

## Remaining Budget


remaining =
budget_amount

expenses_in_category


---

# Suggested Database Tables


users
accounts
income_sources
one_time_income
expenses
budgets
goals
pending_transactions
tax_profiles
transactions


---

# Future Feature Ideas

## Bank Integration

Automatically import transactions using services like:

- Plaid
- Teller

---

## Smart Budget Suggestions

Example:


"You spend about $280/week on food. Increase your budget?"


---

## Automatic Expense Categorization

Examples:


Walmart → Groceries
Shell → Gas
Starbucks → Dining


---

## Notifications

Examples:

- Budget exceeded
- Goal progress updates
- Pending payment reminders

---

## Forecasting

Example prediction:


"If spending continues, you will have $820 by May 1"


---

## Debt Tracking


Loan

balance

interest_rate

payment_schedule


---

## Investment Tracking

Track:

- Stocks
- Dividends
- Portfolio value

---

## Multi-Currency Support

Useful for international users or travel.

---

## Offline Mode

Local storage on device with sync when online.

---

## Shared Budgets

Allow multiple users (partners/roommates) to share financial tracking.

---

# Recommended Architecture Improvement

Instead of separate transaction types, consider a **single unified transaction model**.

## Universal Transaction Model


Transaction

id

user_id

type (income, expense, pending)

amount

category

account

description

status

timestamp


This allows everything to be stored as a transaction:

- Paychecks
- Purchases
- Pending payments
- Transfers

Benefits:

- Simpler database structure
- Easier analytics
- Easier timeline generation
- Cleaner API