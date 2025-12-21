# SmartCSV Project Overview

## Purpose
SmartCSV is a full-stack web application that resolves limitations in Smaregi's native CSV import functionality. It provides flexible CSV header mapping, large file processing (millions of rows), and enhanced error handling for Smaregi product imports.

## Key Features
- Flexible CSV header mapping with saved configurations
- Large-scale file processing (1000-row chunks)
- Detailed error handling with in-app correction
- Multi-tenant support via `contract_id`

## Technology Stack
- **Frontend**: React 18 + Vite (SPA)
- **UI Framework**: shadcn/ui (Radix UI + TailwindCSS)
- **Backend**: Cloudflare Workers (Hono framework)
- **Database**: Cloudflare D1 (SQLite-compatible)
- **ORM**: Drizzle ORM
- **State Management**: Zustand + React Query
- **Authentication**: Smaregi OAuth 2.0 + OpenID Connect (PKCE)
- **Background Processing**: Cloudflare Queues
- **CSV Processing**: PapaParse

## Architecture
### Multi-Tenant
- All APIs require `contract_id` parameter for data isolation
- Database queries filter by `user_id` AND `contract_id`

### Data Flow
1. CSV Upload → PapaParse → preview
2. Header mapping → save configuration
3. Import job → Cloudflare Queue → chunked processing (1000 rows)
4. Queue consumer → Smaregi API → D1 database
5. Frontend polls job status → displays errors

## Important Constraints
### Cloudflare Workers
- Request timeout: 30 seconds (use Queues for long tasks)
- Memory: 128MB limit
- No Node.js APIs (use Web APIs only)

### Cloudflare D1
- SQLite-compatible only
- Date handling: ISO 8601 strings
- Migrations: manual via wrangler CLI

### CSV Processing
- Chunk size: 1000 rows per batch
- Recommend <50MB file size for browser upload
