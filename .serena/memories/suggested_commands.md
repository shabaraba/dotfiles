# SmartCSV Development Commands

## Local Development
```bash
# Frontend only (port 5173)
npm run dev

# Backend Workers only (port 8787)
npm run dev:workers

# Both frontend and backend concurrently
npm run dev:all
```

## Build and Type Checking
```bash
npm run build              # Build frontend for production
npm run build:workers      # Dry-run build for Workers
npm run typecheck          # Run TypeScript type checking
npm run lint               # Run ESLint
```

## Testing
```bash
npm run test               # Run Vitest in watch mode
npm run test:run           # Run tests once
npm run test:ui            # Run Vitest with UI
npm run test:coverage      # Run tests with coverage
```

## Database Operations
```bash
# Run migrations (local)
npx wrangler d1 execute smartcsv_db --local --file=./migrations/<filename>.sql

# Run migrations (production)
npx wrangler d1 execute smartcsv_db --remote --file=./migrations/<filename>.sql

# Query local database
npx wrangler d1 execute smartcsv_db --local --command="SELECT * FROM users LIMIT 10"
```

## Queue Operations (Development)
```bash
npm run queue:process      # Manually process all queued jobs
npm run queue:status       # Check queue status
```

## Deployment
```bash
# Build frontend
npm run build

# Deploy to Cloudflare Workers
npx wrangler deploy

# List secrets
wrangler secret list
```

## E2E Testing
```bash
# 1. Start tunnel (separate terminal)
pnpm run tunnel:persistent

# 2. Start dev servers (separate terminal)
npm run dev:all

# 3. Upload CSV via UI (http://localhost:5173/upload)
# 4. Process queue
npm run queue:process
```

## System Utilities (macOS)
- `ls` - List files
- `find` - Find files (BSD version, different from GNU)
- `grep` - Search text (BSD version)
- `git` - Version control
- Use `brew install gnu-sed` for GNU sed (`gsed`)
