import { query } from '../database/connection.js';

export class GenericCRUDService {
  constructor(private tableName: string, private idColumn: string = 'id') {}

  // Get all records
  async getAll(limit: number = 100, offset: number = 0) {
    const text = `SELECT * FROM "${this.tableName}" LIMIT $1 OFFSET $2`;
    const result = await query(text, [limit, offset]);
    return result.rows;
  }

  // Get single record by ID
  async getById(id: any) {
    const text = `SELECT * FROM "${this.tableName}" WHERE "${this.idColumn}" = $1`;
    const result = await query(text, [id]);
    return result.rows[0] || null;
  }

  // Create record
  async create(data: Record<string, any>) {
    const columns = Object.keys(data);
    const values = Object.values(data);
    const placeholders = columns.map((_, i) => `$${i + 1}`).join(', ');
    const columnNames = columns.map(col => `"${col}"`).join(', ');

    const text = `INSERT INTO "${this.tableName}" (${columnNames}) VALUES (${placeholders}) RETURNING *`;
    const result = await query(text, values);
    return result.rows[0];
  }

  // Update record
  async update(id: any, data: Record<string, any>) {
    const columns = Object.keys(data);
    const values = Object.values(data);
    const setClause = columns.map((col, i) => `"${col}" = $${i + 1}`).join(', ');

    const text = `UPDATE "${this.tableName}" SET ${setClause}, "updated_at" = NOW() WHERE "${this.idColumn}" = $${columns.length + 1} RETURNING *`;
    const result = await query(text, [...values, id]);
    return result.rows[0] || null;
  }

  // Delete record
  async delete(id: any) {
    const text = `DELETE FROM "${this.tableName}" WHERE "${this.idColumn}" = $1 RETURNING *`;
    const result = await query(text, [id]);
    return result.rows[0] || null;
  }

  // Get count
  async count() {
    const text = `SELECT COUNT(*) as count FROM "${this.tableName}"`;
    const result = await query(text);
    return parseInt(result.rows[0].count);
  }

  // Search/filter
  async search(column: string, value: any) {
    const text = `SELECT * FROM "${this.tableName}" WHERE "${column}" ILIKE $1 LIMIT 50`;
    const result = await query(text, [`%${value}%`]);
    return result.rows;
  }
}
