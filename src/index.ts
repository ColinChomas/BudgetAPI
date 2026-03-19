import express, { Express, Request, Response } from 'express';
import { createCRUDRouter } from './routes/crudRouter.js';

const app: Express = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.static('public'));

// CORS middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// API Documentation route
app.get('/', (req: Request, res: Response) => {
  res.json({
    server: 'Budget API',
    version: '1.0.0',
    endpoints: {
      users: '/api/users',
      accounts: '/api/accounts',
      transactions: '/api/transactions',
      categories: '/api/categories',
      budgets: '/api/budgets',
      budget_periods: '/api/budget-periods',
      goals: '/api/goals',
      loans: '/api/loans',
      contacts: '/api/contacts',
      tags: '/api/tags',
      alerts: '/api/alerts',
      recurring_patterns: '/api/recurring-patterns',
      audit_logs: '/api/audit-logs',
    },
    methods: {
      'GET /api/:table': 'Get all records (with ?limit=100&offset=0)',
      'GET /api/:table/:id': 'Get single record by ID',
      'POST /api/:table': 'Create new record (send JSON body)',
      'PUT /api/:table/:id': 'Update record (send JSON body)',
      'DELETE /api/:table/:id': 'Delete record by ID',
      'GET /api/:table/search/:column/:value': 'Search records',
    },
  });
});

// API Routes - All tables
app.use('/api/users', createCRUDRouter('users', 'id'));
app.use('/api/accounts', createCRUDRouter('accounts', 'id'));
app.use('/api/transactions', createCRUDRouter('transactions', 'id'));
app.use('/api/categories', createCRUDRouter('categories', 'id'));
app.use('/api/budgets', createCRUDRouter('budgets', 'id'));
app.use('/api/budget-periods', createCRUDRouter('budget_periods', 'id'));
app.use('/api/goals', createCRUDRouter('goals', 'id'));
app.use('/api/loans', createCRUDRouter('loans', 'id'));
app.use('/api/contacts', createCRUDRouter('contacts', 'id'));
app.use('/api/tags', createCRUDRouter('tags', 'id'));
app.use('/api/alerts', createCRUDRouter('alerts', 'id'));
app.use('/api/recurring-patterns', createCRUDRouter('recurring_patterns', 'id'));
app.use('/api/audit-logs', createCRUDRouter('audit_logs', 'id'));

// Health check
app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    requested: req.path,
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Budget API Server running at http://localhost:${PORT}`);
  console.log(`📚 Visit http://localhost:${PORT} for documentation`);
  console.log(`💚 Database connected`);
});

export default app;
