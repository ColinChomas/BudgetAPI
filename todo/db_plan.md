# Planning out my PostgreSQL database

1. Users

Basic Table
- id: int
- username: varchar
- email: varchar
- password_hash: varchar
- created_at: Date
- updated_at: Date
- last_login: Date

Settings Table
- currency_default: int -> Supported Currency Table?
- timezone: Date?

Have a tax table, allow one-to-many, z. B. A user could live in an income taxless state, so not required, or could not earn enough to qualify for income tax. Or they could be taxed from a different state that they live. Tax Table discussed below
- income_tax_rate: Double
- sales_tax_rate: Double --- This should be a default, however, there should be a field when inputting a purchase that allows you to specify location, although, tbh might be unnecessary as if you made the purchase you already paid it, but maybe have a calculator...
- property_tax_rate: Double --- This might need 

- notification_preferences: json? or another table?
- theme_preferences: json? or another table?

- is_active: bool

2. Accounts
Allow for users to specify an amount of money that is diverted into separate accounts, checking, savings, fun, etc. allow the user to create as many as they want.

id: int
user_id: int

name: varchar
account_type: varchar? int? Same as Name oder?
institution_name: varchar --- allow user to specify which bank they need to manually deposit this money too incase they forget. OPTIONAL

currency: idk if this is really necessary

starting_balance: double --- this is just for when they create the account
current_balance: double
expected_balance: double --- the (+/-) after the account to show pending payments z. B. 15,620.23 (-250.00), the -250 would be a modal that allows the user to be reminded what that payment is, with a see more to navigate to a new page.

created_at: Date
updated_at: Date

is_active: bool

# Transactions
Keep track of every transaction a user makes within their accounts.

id: int
user_id: int
account_id: int

type: varchar? int? probably int, but tbh maybe not
status: tinyint --- 0 -> need to pay, 1 -> need to get paid, 2 -> complete, 3 -> cancelled

amount: double
currency: int --- probably set to default unless otherwise specified

category_id: int --- preset categories, z. B. groceries, rent, loan_repayment, income, other, etc.

description: varchar
notes: varchar

transaction_date: Date --- when the transaction is meant to happen, send alert day before, whether its pay day or loan repayment day...
posted_date: Date --- time the user click create

created_at: Date --- time the record was created in the DB
updated_at: Date

is_recurring: bool
reccuring_id: int --- Annual, Monthly, Weekly, Bi-Weekly, maybe custom set by the User, maybe its own table? transcation_id reccuring_id reccuring_type next_date...

location?: to get tax type from the type field
merchant_name: varchar -- Work, Wegmans what ever...

tags: Array?

Possible Transaction Types:
- income
- expense
- transfer
- pending_incoming
- pending_outgoing
- goal_contribution
- budget_adjustment
- refund
- loan_payment
- loan_disbursement?

Status
- pending
- confirmed
- cancelled
- scheduled

# Categories
types of spending / income
z. B. 
- rent
- groceries
- gas
- entertainment

id: int
user_id: int?

name: varchar
type: int (expense, income, transfer)?

parent_category_id: int ?

icon ?
color ?

created_at
updated_at

# Budgets
id
user_id
category_id

name
budget_amount: double -- amount in that budget
frequency: int -- how often new money is added to the budget
rollover_enabled: bool -- whether or not unspent money in budget stays, or is moved to savings / another budget / acount
rollover_amount: double -- max amount to be rolled over to next interation of the budget
alert_threshold: double -- amount remaining to be notified, hey buddy you're spending too much here
start_date: date
end_date: date

created_at
updated_at

## Frequency Options
- weekly
- biweekly
- monthly
- halfyearly
- yearly
- other/custom? I'm unsure how to code this option

# Budget Period Tracking
id
budget_id

period_start
period_end

allocated_amount
spent_amount
remaining_amount

rollover_from_previous
rollover_to_next? unsure, maybe?

status: bool - Active, Inactive

# Income Source
id
user_id

name
employer_name -- or justname of thing paying you, robin hood? dividends?

amount
frequency: int -- frequency options from above
pay_day: tinyint 0..6, Monday - Sunday
tax_witholding?

start_date
end_date

is_active

notes

# One-Time Income
This may be necessary, the frequency could maybe just be set to null above?

id
user_id

amount
description

source

received_date

# Goals (Saving Goals)
example: 
SaveAmount: 2000.0
Reason: "Vacation"
AmountPer___: 50.0
Frequency: \[dropdown]

Then on view
Vacation ( 50.00 / 2000.00 )

id
user_id

name
description

target_amount
current_amount

contribution_amount
contribution_frequency

start_date
end_date

status

priority: int --> order in the users account maybe? list of all Goals?

auto_contribute: bool

created_at
updated_at

Statuses:
- active
- completed
- paused
- cancelled

# Pending Transactions
unconfirmed money

id
user_id
amount
type: int -- income / outgoing
description
expected_date
related_entity: varchar -- name of institution you need to pay or get paid by
status
resolved_date
created_at
updated_at

# Contacts
people who may come up commonly? Maybe you pay the kids allowance?
id
user_id

name
email?
phone?

notes

created_at
updated_at

# Loans / Debts
Track debt

id
user_id

principal_amount
remaining_amount

interest_rate
interest_rate_type? idk if this is necessary i dont know enough about this shit
minimum_payment
payment_frequency
next_payment_date
start_date
end_date
status
notes
created_at
updated_at

# Transfers
id

from_account_id
to_account_id

amount

transaction_id_from
transaction_id_to

transfer_date

notes

created_at
updated_at

# tags

id
user_id

name
color

# Alerts
id
user_id

type

title
message

related_entity_type
related_entity_id

status

created_at
read_at

# User Settings

id
user_id

default_currency
timezone

budget_alerts_enabled
goal_alerts_enabled

tax_calc_enabled

dark_mode

created_at
updated_at

# Audit Log
id
user_id

entity_type
entity_id

action

old_value
new_value

timestamp

---

users
│
├─ accounts
│   └─ transactions
│
├─ budgets
│   └─ budget_periods
│
├─ categories
│
├─ goals
│
├─ income_sources
│
├─ loans
│
├─ contacts
│
└─ notifications

_Minimum Viable Tables_
users
accounts
transactions
categories
budgets
goals

_Strong Design Recommendation_

Make transactions the central table.

Everything becomes a transaction:

paycheck
expense
transfer
goal contribution
loan payment
refund
pending payment

Example minimal transaction schema:

id
user_id
account_id
amount
type
category_id
status
timestamp
description