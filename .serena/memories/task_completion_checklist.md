# Task Completion Checklist

When a task is completed, ensure the following:

## Code Quality
- [ ] TypeScript type check passes: `npm run typecheck`
- [ ] ESLint passes: `npm run lint`
- [ ] Tests pass: `npm run test:run`
- [ ] Build succeeds: `npm run build`
- [ ] Workers build succeeds: `npm run build:workers`

## Documentation
- [ ] Update CLAUDE.md if architectural changes
- [ ] Update relevant docs in `docs/` if needed
- [ ] Add/update inline comments for complex logic (sparingly)

## Testing
- [ ] Unit tests for new functions/utilities
- [ ] Integration tests for API endpoints
- [ ] Manual E2E test if UI changes:
  1. Start tunnel: `pnpm run tunnel:persistent`
  2. Start servers: `npm run dev:all`
  3. Test workflow end-to-end
  4. Process queue: `npm run queue:process`
  5. Verify results in UI

## Database Changes
- [ ] Create migration file in `migrations/`
- [ ] Test migration locally: `npx wrangler d1 execute smartcsv_db --local --file=./migrations/<file>.sql`
- [ ] Document schema changes in migration file comments
- [ ] Update Drizzle schema in `src/workers/db/schema.ts`

## Before Commit
- [ ] Remove console.logs and debug code
- [ ] Remove temporary files
- [ ] Review git diff for unintended changes
- [ ] Ensure no secrets or API keys in code

## Deployment Checklist (Production)
- [ ] All tests pass in CI/CD
- [ ] Run migrations on production DB
- [ ] Update environment variables/secrets if needed
- [ ] Deploy: `npx wrangler deploy`
- [ ] Smoke test production deployment
- [ ] Monitor error logs after deployment
