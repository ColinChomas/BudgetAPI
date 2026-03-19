import { Router, Request, Response } from 'express';
import { GenericCRUDService } from '../modules/GenericCRUDService.js';

export const createCRUDRouter = (tableName: string, idColumn: string = 'id') => {
  const router = Router();
  const service = new GenericCRUDService(tableName, idColumn);

  // GET all records
  router.get('/', async (req: Request, res: Response) => {
    try {
      const limit = parseInt((req.query.limit as string) || '100') || 100;
      const offset = parseInt((req.query.offset as string) || '0') || 0;
      const records = await service.getAll(limit, offset);
      const count = await service.count();
      res.json({
        success: true,
        table: tableName,
        count,
        limit,
        offset,
        data: records,
      });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  });

  // GET single record
  router.get('/:id', async (req: Request, res: Response) => {
    try {
      const record = await service.getById(req.params.id);
      if (!record) {
        return res.status(404).json({ success: false, error: 'Record not found' });
      }
      res.json({ success: true, data: record });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  });

  // CREATE record
  router.post('/', async (req: Request, res: Response) => {
    try {
      const record = await service.create(req.body);
      res.status(201).json({ success: true, data: record });
    } catch (error: any) {
      res.status(400).json({ success: false, error: error.message });
    }
  });

  // UPDATE record
  router.put('/:id', async (req: Request, res: Response) => {
    try {
      const record = await service.update(req.params.id, req.body);
      if (!record) {
        return res.status(404).json({ success: false, error: 'Record not found' });
      }
      res.json({ success: true, data: record });
    } catch (error: any) {
      res.status(400).json({ success: false, error: error.message });
    }
  });

  // DELETE record
  router.delete('/:id', async (req: Request, res: Response) => {
    try {
      const record = await service.delete(req.params.id);
      if (!record) {
        return res.status(404).json({ success: false, error: 'Record not found' });
      }
      res.json({ success: true, message: 'Record deleted', data: record });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  });

  // SEARCH by column
  router.get('/search/:column/:value', async (req: Request, res: Response) => {
    try {
      const { column, value } = req.params;
      if (!column || !value) {
        return res.status(400).json({ success: false, error: 'Column and value are required' });
      }
      const records = await service.search(column as string, value as string);
      res.json({ success: true, data: records });
    } catch (error: any) {
      res.status(500).json({ success: false, error: error.message });
    }
  });

  return router;
};
