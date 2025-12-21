# SmartCSV Code Style and Conventions

## File Organization
- **Root directory**: Minimal files only (configs, package.json, README, CLAUDE.md)
- **Documentation**: `docs/` directory
- **Scripts**: `scripts/` directory
- **Test data**: `test-data/` directory
- **Tests**: co-located with source files (`*.test.ts`) or `src/tests/`
- **Migrations**: `migrations/` directory

## Naming Conventions
- **Components**: PascalCase (`UserProfile.tsx`)
- **Hooks**: camelCase with `use` prefix (`useAuth.ts`)
- **Types**: PascalCase for interfaces/types (`User`, `MappingConfig`)
- **Files**: kebab-case for utilities (`csv-parser.ts`)
- **API routes**: kebab-case (`/api/mappings`)

## Type Safety
- Use TypeScript strict mode
- Zod schemas for API validation in `src/types/`
- Share types between frontend and backend
- Drizzle types for database operations

## Component Structure
```typescript
// shadcn/ui components in src/components/ui/
// Feature components in src/components/{feature}/
// Page components in src/pages/

// Example structure:
src/components/
  csv/
    CSVUploader.tsx
    CSVPreview.tsx
  mapping/
    MappingForm.tsx
    MappingList.tsx
```

## State Management
- Zustand stores in `src/contexts/`
- React Query for server state
- Local state with useState for UI-only state

## Backend Structure
```typescript
// Workers structure:
src/workers/
  api/          # Route handlers
  services/     # Business logic
  db/           # Database layer
    repositories/  # Data access
  queue-handlers/  # Queue consumers
```

## Error Handling
- Use Zod for validation errors
- Custom error classes for domain errors
- Error boundaries in React
- Proper HTTP status codes in API responses

## Comments
- Avoid unnecessary comments
- Use JSDoc for public APIs
- Self-documenting code preferred
- Explain "why" not "what"

## Testing
- Unit tests: co-located with source (`*.test.ts`)
- Integration tests: `src/tests/integration/`
- Mock external dependencies (Smaregi API, D1, KV)
- Test critical paths: CSV parsing, mapping logic, queue processing
