# WorkForce AI - System Architecture

## Overview
WorkForce AI is a company automation platform where businesses deploy AI "workers" instead of hiring employees. Workers execute tasks via n8n workflows, enabling complete company automation.

## Core Concepts

### Hierarchy
```
Company (CEO tier)
├── Department
│   ├── Manager
│   │   └── Workers (AI agents)
│   └── Workers
└── Department
    └── Workers
```

### Worker Types
- **Sales Workers**: Outreach, lead generation, CRM updates
- **Support Workers**: Customer service, ticket handling
- **Marketing Workers**: Content, social media, campaigns
- **Development Workers**: Code review, deployment, monitoring
- **Operations Workers**: Data entry, reporting, scheduling
- **Custom Workers**: User-defined via prompts

## Tech Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **UI Library**: Tailwind CSS + shadcn/ui
- **State**: Zustand
- **Real-time**: Socket.io client
- **Charts**: Recharts

### Backend
- **Runtime**: Node.js 20
- **Framework**: Next.js API Routes
- **Database**: PostgreSQL
- **ORM**: Prisma
- **Auth**: NextAuth.js
- **Queue**: BullMQ + Redis
- **Real-time**: Socket.io

### External Services
- **n8n**: Workflow execution engine
- **Redis**: Caching + job queues
- **S3/MinIO**: File storage

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        FRONTEND (Next.js)                        │
├─────────────────────────────────────────────────────────────────┤
│  Landing Page │ Dashboard │ Worker Builder │ Admin Panel        │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                      API LAYER (Next.js API)                     │
├─────────────────────────────────────────────────────────────────┤
│  Auth │ Companies │ Workers │ Workflows │ Admin │ Billing       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │PostgreSQL│  │  Redis   │  │   n8n    │
        │ Database │  │  Cache   │  │  Engine  │
        └──────────┘  └──────────┘  └──────────┘
```

## Worker Creation Flow

```
1. User enters plain English prompt
   │
   ▼
2. API sends to n8n "Enhance Prompt" workflow
   │
   ▼
3. Enhanced prompt returned with structure
   │
   ▼
4. API sends to n8n "Create Workflow" workflow
   │
   ▼
5. New n8n workflow created from template
   │
   ▼
6. Worker record saved with workflow ID
   │
   ▼
7. Worker ready for deployment
```

## Database Schema Overview

- **User**: Account information
- **Company**: Organization with tier/plan
- **Department**: Sub-units of company
- **Worker**: AI agent with workflow reference
- **WorkerExecution**: Execution history
- **WorkflowTemplate**: Pre-built workflow templates
- **Subscription**: Billing/plan info

## Pricing Tiers

| Tier | Workers | Departments | Executions/mo | Price |
|------|---------|-------------|---------------|-------|
| Free Trial | 3 | 1 | 100 | $0 (30 days) |
| Starter | 10 | 3 | 1,000 | $29/mo |
| Company Block | 50 | 10 | 10,000 | $99/mo |
| CEO | Unlimited | Unlimited | 100,000 | $299/mo |
| Enterprise | Custom | Custom | Custom | Custom |

## Security

- JWT-based authentication
- Role-based access control (Owner, Admin, Manager, Viewer)
- API rate limiting
- Encrypted credentials storage
- Audit logging
