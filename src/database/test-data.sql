-- Budget API - Test Data Script for Single User
-- Creates one user with comprehensive dummy data to test all features
-- NOTE: Run Budget.sql first to create tables

-- ===== USER =====
INSERT INTO "users" ("username", "email", "password_hash", "default_currency", "timezone", "dark_mode", "is_active", "created_at", "last_login")
VALUES ('testuser', 'test@example.com', 'hashed_password_123', 1, 'America/New_York', true, true, NOW() - INTERVAL '90 days', NOW() - INTERVAL '1 day');

-- Get the user ID (assuming it's 1)
-- \set user_id 1

-- ===== ACCOUNTS =====
-- Create different account types to test
INSERT INTO "accounts" ("user_id", "name", "type", "institution_name", "starting_balance", "current_balance", "expected_balance", "currency", "is_active", "created_at", "updated_at")
VALUES 
  (1, 'Checking Account', 'checking', 'Bank of America', 5000.00, 5000.00, 5000.00, 1, true, NOW() - INTERVAL '180 days', NOW()),
  (1, 'Savings Account', 'savings', 'Bank of America', 10000.00, 10000.00, 10000.00, 1, true, NOW() - INTERVAL '180 days', NOW()),
  (1, 'Emergency Fund', 'savings', 'Capital One', 3000.00, 3000.00, 3000.00, 1, true, NOW() - INTERVAL '120 days', NOW()),
  (1, 'Investment Account', 'investment', 'Fidelity', 20000.00, 20500.00, 20500.00, 1, true, NOW() - INTERVAL '90 days', NOW());

-- ===== CATEGORIES =====
-- Main expense categories
INSERT INTO "categories" ("user_id", "name", "type", "parent_category_id", "icon", "color", "created_at", "updated_at")
VALUES 
  (1, 'Groceries', 'expense', NULL, 'shopping-cart', '#FF6B6B', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Utilities', 'expense', NULL, 'zap', '#4ECDC4', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Rent', 'expense', NULL, 'home', '#45B7D1', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Entertainment', 'expense', NULL, 'film', '#F7DC6F', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Transportation', 'expense', NULL, 'car', '#BB8FCE', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Gas', 'expense', NULL, 'fuel-pump', '#85C1E2', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Dining Out', 'expense', NULL, 'utensils', '#F8B739', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Subscriptions', 'expense', NULL, 'tv', '#52C93F', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Salary', 'income', NULL, 'dollar-sign', '#2ECC71', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Freelance Income', 'income', NULL, 'laptop', '#27AE60', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Transfer', 'transfer', NULL, 'arrow-right-left', '#95A5A6', NOW() - INTERVAL '180 days', NOW());

-- ===== TRANSACTIONS =====
-- Recurring income (bi-weekly salary) - note: recurring_id will be set after recurring_patterns exist
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "recurring_id", "tags")
VALUES 
  (1, 1, 'income', 'confirmed', 3500.00, 1, 9, 'Bi-weekly salary', 'Acme Corp', NOW() - INTERVAL '56 days', NOW() - INTERVAL '56 days', NOW(), NULL, '["salary", "recurring"]'),
  (1, 1, 'income', 'confirmed', 3500.00, 1, 9, 'Bi-weekly salary', 'Acme Corp', NOW() - INTERVAL '28 days', NOW() - INTERVAL '28 days', NOW(), NULL, '["salary", "recurring"]'),
  (1, 1, 'income', 'confirmed', 3500.00, 1, 9, 'Bi-weekly salary', 'Acme Corp', NOW(), NOW(), NOW(), NULL, '["salary", "recurring"]');

-- ===== RECURRING PATTERNS =====
-- Set up recurring pattern for salary (bi-weekly) - this will get ID 1
INSERT INTO "recurring_patterns" ("transaction_id", "frequency", "day_of_month", "next_occurrence", "end_date", "active", "created_at", "updated_at")
VALUES 
  (1, 'biweekly', NULL, NOW() + INTERVAL '3 days', NULL, true, NOW() - INTERVAL '90 days', NOW());

-- Update salary transactions to reference the recurring pattern
UPDATE "transactions" SET "recurring_id" = 1 WHERE "id" IN (1, 2, 3) AND "type" = 'income' AND "category_id" = 9;

-- Fixed monthly bills (rent)
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'confirmed', 1500.00, 1, 3, 'Monthly rent', 'Landlord LLC', NOW() - INTERVAL '60 days', NOW() - INTERVAL '60 days', NOW(), '["rent", "fixed"]'),
  (1, 1, 'expense', 'confirmed', 1500.00, 1, 3, 'Monthly rent', 'Landlord LLC', NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days', NOW(), '["rent", "fixed"]');

-- Utility payments
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'confirmed', 120.00, 1, 2, 'Electric bill', 'Power Company', NOW() - INTERVAL '45 days', NOW() - INTERVAL '45 days', NOW(), '["utilities"]'),
  (1, 1, 'expense', 'confirmed', 80.00, 1, 2, 'Water bill', 'Water Dept', NOW() - INTERVAL '40 days', NOW() - INTERVAL '40 days', NOW(), '["utilities"]'),
  (1, 1, 'expense', 'confirmed', 60.00, 1, 2, 'Internet', 'Comcast', NOW() - INTERVAL '50 days', NOW() - INTERVAL '50 days', NOW(), '["utilities"]');

-- Subscription services
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'confirmed', 14.99, 1, 8, 'Netflix subscription', 'Netflix', NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days', NOW(), '["subscriptions", "recurring"]'),
  (1, 1, 'expense', 'confirmed', 9.99, 1, 8, 'Spotify subscription', 'Spotify', NOW() - INTERVAL '25 days', NOW() - INTERVAL '25 days', NOW(), '["subscriptions", "recurring"]');

-- Groceries (various)
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'confirmed', 85.50, 1, 1, 'Weekly groceries', 'Whole Foods', NOW() - INTERVAL '50 days', NOW() - INTERVAL '50 days', NOW(), '["groceries"]'),
  (1, 1, 'expense', 'confirmed', 120.00, 1, 1, 'Weekly groceries', 'Whole Foods', NOW() - INTERVAL '43 days', NOW() - INTERVAL '43 days', NOW(), '["groceries"]'),
  (1, 1, 'expense', 'confirmed', 95.75, 1, 1, 'Weekly groceries', 'Whole Foods', NOW() - INTERVAL '36 days', NOW() - INTERVAL '36 days', NOW(), '["groceries"]'),
  (1, 1, 'expense', 'confirmed', 110.25, 1, 1, 'Weekly groceries', 'Whole Foods', NOW() - INTERVAL '29 days', NOW() - INTERVAL '29 days', NOW(), '["groceries"]'),
  (1, 1, 'expense', 'confirmed', 88.00, 1, 1, 'Weekly groceries', 'Whole Foods', NOW() - INTERVAL '22 days', NOW() - INTERVAL '22 days', NOW(), '["groceries"]'),
  (1, 1, 'expense', 'confirmed', 98.50, 1, 1, 'Weekly groceries', 'Whole Foods', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days', NOW(), '["groceries"]');

-- Dining out (test entertainment category)
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'confirmed', 45.00, 1, 7, 'Dinner with friends', 'Italian Restaurant', NOW() - INTERVAL '55 days', NOW() - INTERVAL '55 days', NOW(), '["dining", "social"]'),
  (1, 1, 'expense', 'confirmed', 32.00, 1, 7, 'Lunch', 'Burger Place', NOW() - INTERVAL '48 days', NOW() - INTERVAL '48 days', NOW(), '["dining"]'),
  (1, 1, 'expense', 'confirmed', 75.00, 1, 7, 'Date night', 'Steakhouse', NOW() - INTERVAL '35 days', NOW() - INTERVAL '35 days', NOW(), '["dining", "special"]');

-- Gas/Transportation
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'confirmed', 50.00, 1, 6, 'Gas fill-up', 'Shell Gas Station', NOW() - INTERVAL '40 days', NOW() - INTERVAL '40 days', NOW(), '["gas"]'),
  (1, 1, 'expense', 'confirmed', 55.00, 1, 6, 'Gas fill-up', 'Shell Gas Station', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days', NOW(), '["gas"]');

-- One-time income (bonus/freelance)
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'income', 'confirmed', 500.00, 1, 10, 'Freelance project payment', 'Upwork Client', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days', NOW(), '["freelance", "bonus"]');

-- Pending transactions (upcoming bills/income)
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "merchant_name", "transaction_date", "posted_date", "updated_at", "tags")
VALUES 
  (1, 1, 'expense', 'pending', 1500.00, 1, 3, 'Upcoming rent payment', 'Landlord LLC', NOW() + INTERVAL '2 days', NOW(), NOW(), '["rent", "pending"]'),
  (1, 1, 'income', 'pending', 3500.00, 1, 9, 'Upcoming salary', 'Acme Corp', NOW() + INTERVAL '3 days', NOW(), NOW(), '["salary", "pending"]'),
  (1, 1, 'expense', 'pending', 120.00, 1, 2, 'Upcoming electric bill', 'Power Company', NOW() + INTERVAL '5 days', NOW(), NOW(), '["utilities", "pending"]');

-- Transfer between accounts
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "description", "transaction_date", "posted_date", "updated_at", "related_account_id", "tags")
VALUES 
  (1, 1, 'transfer', 'confirmed', 1000.00, 1, 'Transfer to savings', NOW() - INTERVAL '70 days', NOW() - INTERVAL '70 days', NOW(), 2, '["transfer"]'),
  (1, 2, 'transfer', 'confirmed', 1000.00, 1, 'Transfer from checking', NOW() - INTERVAL '70 days', NOW() - INTERVAL '70 days', NOW(), 1, '["transfer"]'),
  (1, 2, 'transfer', 'confirmed', 500.00, 1, 'Transfer to emergency fund', NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days', NOW(), 3, '["transfer"]'),
  (1, 3, 'transfer', 'confirmed', 500.00, 1, 'Transfer from savings', NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days', NOW(), 2, '["transfer"]');

-- Goal contributions
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "category_id", "description", "transaction_date", "posted_date", "updated_at", "related_entity_type", "related_entity_id", "tags")
VALUES 
  (1, 2, 'goal_contribution', 'confirmed', 200.00, 1, NULL, 'Vacation fund contribution', NOW() - INTERVAL '45 days', NOW() - INTERVAL '45 days', NOW(), 'goal', 1, '["goals"]'),
  (1, 2, 'goal_contribution', 'confirmed', 200.00, 1, NULL, 'Vacation fund contribution', NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days', NOW(), 'goal', 1, '["goals"]'),
  (1, 2, 'goal_contribution', 'confirmed', 200.00, 1, NULL, 'Vacation fund contribution', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days', NOW(), 'goal', 1, '["goals"]');

-- Loan payment
INSERT INTO "transactions" ("user_id", "account_id", "type", "status", "amount", "currency", "description", "transaction_date", "posted_date", "updated_at", "related_entity_type", "related_entity_id", "tags")
VALUES 
  (1, 1, 'loan_payment', 'confirmed', 350.00, 1, 'Car loan payment', NOW() - INTERVAL '55 days', NOW() - INTERVAL '55 days', NOW(), 'loan', 1, '["loan"]'),
  (1, 1, 'loan_payment', 'confirmed', 350.00, 1, 'Car loan payment', NOW() - INTERVAL '25 days', NOW() - INTERVAL '25 days', NOW(), 'loan', 1, '["loan"]');

-- ===== BUDGETS =====
INSERT INTO "budgets" ("user_id", "category_id", "name", "budget_amount", "frequency", "rollover_enabled", "rollover_amount", "alert_threshold", "start_date", "end_date", "is_active", "created_at", "updated_at")
VALUES 
  (1, 1, 'Monthly Groceries', 400.00, 'monthly', true, 50.00, 350.00, NOW() - INTERVAL '90 days', NULL, true, NOW() - INTERVAL '90 days', NOW()),
  (1, 7, 'Entertainment & Dining', 300.00, 'monthly', false, NULL, 250.00, NOW() - INTERVAL '90 days', NULL, true, NOW() - INTERVAL '90 days', NOW()),
  (1, 6, 'Gas Budget', 200.00, 'monthly', true, 30.00, 150.00, NOW() - INTERVAL '90 days', NULL, true, NOW() - INTERVAL '90 days', NOW()),
  (1, 2, 'Utilities', 250.00, 'monthly', false, NULL, 200.00, NOW() - INTERVAL '90 days', NULL, true, NOW() - INTERVAL '90 days', NOW());

-- ===== BUDGET PERIODS =====
-- Test current and past budget periods
INSERT INTO "budget_periods" ("budget_id", "period_start", "period_end", "allocated_amount", "spent_amount", "remaining_amount", "rollover_from_previous", "status")
VALUES 
  -- Groceries for past months
  (1, (NOW() - INTERVAL '90 days')::date, (NOW() - INTERVAL '90 days')::date + INTERVAL '1 month', 400.00, 380.00, 20.00, 0.00, 'completed'),
  (1, (NOW() - INTERVAL '60 days')::date, (NOW() - INTERVAL '60 days')::date + INTERVAL '1 month', 400.00, 425.50, NULL, 20.00, 'completed'),
  (1, (NOW() - INTERVAL '30 days')::date, (NOW() - INTERVAL '30 days')::date + INTERVAL '1 month', 400.00, 392.25, 7.75, 15.00, 'active'),
  
  -- Entertainment for current period
  (2, (NOW() - INTERVAL '30 days')::date, (NOW() - INTERVAL '30 days')::date + INTERVAL '1 month', 300.00, 152.00, 148.00, 0.00, 'active'),
  
  -- Gas budget
  (3, (NOW() - INTERVAL '30 days')::date, (NOW() - INTERVAL '30 days')::date + INTERVAL '1 month', 200.00, 105.00, 95.00, 25.00, 'active'),
  
  -- Utilities
  (4, (NOW() - INTERVAL '30 days')::date, (NOW() - INTERVAL '30 days')::date + INTERVAL '1 month', 250.00, 260.00, NULL, 0.00, 'active');

-- ===== GOALS =====
INSERT INTO "goals" ("user_id", "name", "description", "target_amount", "current_amount", "contribution_amount", "contribution_frequency", "start_date", "target_date", "status", "priority", "auto_contribute", "created_at", "updated_at")
VALUES 
  (1, 'Vacation Fund', 'Summer vacation to Hawaii', 3000.00, 600.00, 200.00, 'biweekly', NOW() - INTERVAL '90 days', NOW() + INTERVAL '5 months', 'active', 1, true, NOW() - INTERVAL '90 days', NOW()),
  (1, 'Emergency Fund', 'Emergency savings buffer', 10000.00, 3000.00, 300.00, 'monthly', NOW() - INTERVAL '180 days', NULL, 'active', 2, true, NOW() - INTERVAL '180 days', NOW()),
  (1, 'New Car', 'Down payment for new car', 5000.00, 500.00, 250.00, 'monthly', NOW() - INTERVAL '60 days', NOW() + INTERVAL '18 months', 'active', 3, true, NOW() - INTERVAL '60 days', NOW()),
  (1, 'Home Office Setup', 'Complete home office', 2000.00, 500.00, NULL, NULL, NOW() - INTERVAL '30 days', NOW() + INTERVAL '6 months', 'active', 2, false, NOW() - INTERVAL '30 days', NOW());

-- ===== LOANS =====
INSERT INTO "loans" ("user_id", "name", "principal_amount", "remaining_amount", "interest_rate", "minimum_payment", "payment_frequency", "next_payment_date", "start_date", "end_date", "status", "notes", "created_at", "updated_at")
VALUES 
  (1, 'Car Loan', 15000.00, 8500.00, 4.5, 350.00, 'monthly', NOW() + INTERVAL '15 days', NOW() - INTERVAL '180 days', NOW() + INTERVAL '24 months', 'active', 'Financed through Bank of America', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Student Loans', 25000.00, 18000.00, 5.0, 250.00, 'monthly', NOW() + INTERVAL '10 days', NOW() - INTERVAL '365 days', NOW() + INTERVAL '120 months', 'active', 'Federal loans, 10-year repayment plan', NOW() - INTERVAL '365 days', NOW()),
  (1, 'Personal Loan from Mom', 2000.00, 1500.00, 0.0, NULL, NULL, NULL, NOW() - INTERVAL '120 days', NULL, 'active', 'Borrowed from mom for home repairs', NOW() - INTERVAL '120 days', NOW());

-- ===== CONTACTS =====
INSERT INTO "contacts" ("user_id", "name", "email", "phone", "notes", "created_at", "updated_at")
VALUES 
  (1, 'Acme Corp HR', 'hr@acmecorp.com', '555-0100', 'Employer - salary questions', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Mom', 'mom@example.com', '555-0101', 'Personal loan lender', NOW() - INTERVAL '120 days', NOW()),
  (1, 'Bank of America', 'support@bofa.com', '1-800-432-1000', 'Primary bank', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Landlord - John Smith', 'john.smith@landlord.com', '555-0102', 'Rent payment contact', NOW() - INTERVAL '180 days', NOW()),
  (1, 'Insurance Company', 'claims@insurance.com', '1-800-555-0103', 'Auto insurance', NOW() - INTERVAL '90 days', NOW());

-- ===== TAGS =====
INSERT INTO "tags" ("user_id", "name", "color", "created_at")
VALUES 
  (1, 'Essential', '#FF6B6B', NOW() - INTERVAL '180 days'),
  (1, 'Discretionary', '#F7DC6F', NOW() - INTERVAL '180 days'),
  (1, 'Recurring', '#4ECDC4', NOW() - INTERVAL '180 days'),
  (1, 'One-time', '#95A5A6', NOW() - INTERVAL '180 days'),
  (1, 'Pending', '#E74C3C', NOW() - INTERVAL '90 days');

-- ===== ALERTS =====
INSERT INTO "alerts" ("user_id", "type", "title", "message", "related_entity_type", "related_entity_id", "status", "created_at", "read_at")
VALUES 
  (1, 'budget_exceeded', 'Entertainment Budget Alert', 'You are approaching your entertainment budget limit for this month', 'budget', 2, 'unread', NOW() - INTERVAL '7 days', NULL),
  (1, 'goal_milestone', 'Vacation Goal Progress', 'You have saved $600 / $3000 for your vacation!', 'goal', 1, 'read', NOW() - INTERVAL '45 days', NOW() - INTERVAL '44 days'),
  (1, 'payment_due', 'Car Loan Payment Due', 'Your car loan payment of $350 is due in 3 days', 'loan', 1, 'unread', NOW() - INTERVAL '3 days', NULL),
  (1, 'pending_reminder', 'Pending Transactions', 'You have 3 pending transactions waiting to be confirmed', 'transaction', NULL, 'unread', NOW() - INTERVAL '1 day', NULL);

-- ===== AUDIT LOG =====
INSERT INTO "audit_logs" ("user_id", "entity_type", "entity_id", "action", "old_value", "new_value", "ip_address", "timestamp")
VALUES 
  (1, 'user', 1, 'update', '{"dark_mode": false}', '{"dark_mode": true}', '192.168.1.100', NOW() - INTERVAL '30 days'),
  (1, 'account', 1, 'create', NULL, '{"name": "Checking Account", "current_balance": 5000}', '192.168.1.100', NOW() - INTERVAL '180 days'),
  (1, 'budget', 1, 'create', NULL, '{"name": "Monthly Groceries", "budget_amount": 400}', '192.168.1.100', NOW() - INTERVAL '90 days'),
  (1, 'goal', 1, 'update', '{"current_amount": 400}', '{"current_amount": 600}', '192.168.1.100', NOW() - INTERVAL '5 days'),
  (1, 'transaction', 1, 'create', NULL, '{"type": "income", "amount": 3500}', '192.168.1.100', NOW() - INTERVAL '56 days');
