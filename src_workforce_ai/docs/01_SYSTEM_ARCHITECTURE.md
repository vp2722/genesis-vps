# WorkForce AI - System Architecture

## Overview

WorkForce AI is a company automation platform that deploys AI workers instead of human employees. The platform allows companies to create AI workers from natural language prompts, which are then transformed into automated n8n workflows.

## Core Concept

**Traditional Automation**: Users build workflows manually
**WorkForce AI**: Users describe what they need in natural language → AI creates and deploys workers

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Frontend Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Landing    │  │   Dashboard  │  │ Admin Panel  │          │
│  │   (Public)   │  │   (Authed)   │  │  (SuperUser) │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                      API Gateway / BFF                           │
│                    (Next.js API Routes)                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Authentication  │  Rate Limiting  │  Request Validation │  │
│  └──────────────────────────────────────────────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                     Application Layer                            │
│  ┌────────────────┐  ┌────────────────┐  ┌─────────────────┐  │
│  │ Worker Service │  │  Dept Service  │  │  Org Service    │  │
│  └────────────────┘  └────────────────┘  └─────────────────┘  │
│  ┌────────────────┐  ┌────────────────┐  ┌─────────────────┐  │
│  │ Prompt Service │  │ Billing Service│  │ Template Service│  │
│  └────────────────┘  └────────────────┘  └─────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                     Integration Layer                            │
│  ┌────────────────┐  ┌────────────────┐  ┌─────────────────┐  │
│  │ n8n API Client │  │  Claude API    │  │  Stripe API     │  │
│  └────────────────┘  └────────────────┘  └─────────────────┘  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────────────┐
│                       Data Layer                                 │
│  ┌────────────────┐  ┌────────────────┐  ┌─────────────────┐  │
│  │   PostgreSQL   │  │     Redis      │  │   S3/Storage    │  │
│  │   (Primary)    │  │   (Cache)      │  │   (Artifacts)   │  │
│  └────────────────┘  └────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. Frontend Layer

#### Landing Page (Public)
- No signup required for trial
- Interactive demo of AI worker creation
- Pricing tiers display
- Onboarding flow

#### Dashboard (Authenticated)
- Organization overview
- Department management
- Worker deployment interface
- Usage analytics
- Billing management

#### Admin Panel (SuperUser)
- Workflow template management
- System-wide analytics
- User management
- Platform configuration

### 2. API Gateway / BFF

**Technology**: Next.js API Routes + tRPC

**Responsibilities**:
- Request routing
- Authentication/Authorization
- Rate limiting per tier
- Request/Response transformation
- Error handling

### 3. Application Services

#### Worker Service
- Worker creation from prompts
- Worker lifecycle management
- Worker monitoring
- Worker configuration

#### Department Service
- Department CRUD operations
- Department-worker associations
- Department analytics

#### Organization Service
- Company profile management
- Tier management
- Multi-tenancy isolation

#### Prompt Enhancement Service
- Natural language processing
- Prompt optimization via Claude
- Workflow specification generation
- Template matching

#### Billing Service
- Stripe integration
- Subscription management
- Usage tracking
- Tier enforcement

#### Template Service
- Workflow template CRUD
- Template versioning
- Template marketplace
- Real-time template updates

### 4. Integration Layer

#### n8n Integration
**Purpose**: Execute workflows generated from prompts

**Capabilities**:
- Workflow creation via API
- Workflow execution
- Webhook management
- Execution monitoring

#### Claude API Integration
**Purpose**: Enhance prompts and generate workflow specs

**Capabilities**:
- Prompt enhancement
- Workflow generation
- Natural language understanding
- Context-aware recommendations

#### Stripe Integration
**Purpose**: Payment processing

**Capabilities**:
- Subscription management
- Usage-based billing
- Webhook handling

### 5. Data Layer

#### PostgreSQL (Primary Database)
**Schema Entities**:
- Organizations
- Users
- Departments
- Workers
- Workflows
- Templates
- Subscriptions
- Usage Logs
- Audit Logs

#### Redis (Cache & Sessions)
**Use Cases**:
- Session management
- Rate limiting counters
- Workflow execution cache
- Real-time analytics

#### S3/Object Storage
**Use Cases**:
- Workflow artifacts
- Worker execution logs
- Template assets
- Backup storage

## Data Flow

### Worker Creation Flow

```
┌────────┐
│  User  │
└───┬────┘
    │ 1. Natural language prompt
    │    "I need a worker to send weekly sales reports"
    ▼
┌─────────────────┐
│   Dashboard     │
└───┬─────────────┘
    │ 2. POST /api/workers/create
    ▼
┌─────────────────┐
│  API Gateway    │ ─── Rate Limit Check
└───┬─────────────┘     Auth Check
    │                   Tier Check
    │ 3. Forward to Worker Service
    ▼
┌─────────────────┐
│ Worker Service  │
└───┬─────────────┘
    │ 4. Send to Prompt Service
    ▼
┌──────────────────┐
│ Prompt Service   │
└───┬──────────────┘
    │ 5. Enhance prompt via Claude
    ▼
┌──────────────────┐
│   Claude API     │
│                  │
│ Enhancement Flow:│
│ - Clarify intent │
│ - Add context    │
│ - Structure data │
│ - Generate spec  │
└───┬──────────────┘
    │ 6. Enhanced prompt + workflow spec
    ▼
┌──────────────────┐
│ Prompt Service   │
└───┬──────────────┘
    │ 7. Send spec to n8n
    ▼
┌──────────────────┐
│  n8n API Client  │
└───┬──────────────┘
    │ 8. Create workflow
    ▼
┌──────────────────┐
│   n8n Platform   │
│                  │
│ - Parse spec     │
│ - Create nodes   │
│ - Configure      │
│ - Activate       │
└───┬──────────────┘
    │ 9. Workflow ID + Webhook URL
    ▼
┌──────────────────┐
│ Worker Service   │
│                  │
│ - Save to DB     │
│ - Create worker  │
│ - Link workflow  │
└───┬──────────────┘
    │ 10. Worker details
    ▼
┌──────────────────┐
│    Dashboard     │
│                  │
│ Display:         │
│ - Worker card    │
│ - Status         │
│ - Controls       │
└──────────────────┘
```

## Security Architecture

### Authentication
- **Strategy**: JWT-based authentication
- **Provider**: NextAuth.js with multiple providers
- **Session Storage**: Redis
- **Token Refresh**: Automatic with sliding window

### Authorization
- **Model**: Role-Based Access Control (RBAC)
- **Roles**:
  - Guest (trial)
  - Company Manager
  - CEO/Admin
  - SuperUser

### Multi-Tenancy
- **Isolation**: Row-Level Security (RLS) in PostgreSQL
- **Organization ID**: Required in all queries
- **API Keys**: Per-organization API keys for external integrations

### Data Protection
- **Encryption at Rest**: Database encryption
- **Encryption in Transit**: TLS 1.3
- **Secrets Management**: Environment variables + Vault
- **PII Handling**: GDPR-compliant data handling

## Scalability Strategy

### Horizontal Scaling
- **API Layer**: Stateless services behind load balancer
- **Worker Processing**: Queue-based with multiple consumers
- **Database**: Read replicas for analytics

### Vertical Scaling
- **Database**: Connection pooling (PgBouncer)
- **Redis**: Redis Cluster for distributed caching
- **n8n**: Multiple n8n instances behind load balancer

### Performance Optimization
- **Caching Strategy**: Multi-layer (Browser → CDN → Redis → DB)
- **Query Optimization**: Indexed queries, materialized views
- **Asset Optimization**: CDN for static assets
- **Code Splitting**: Lazy loading for frontend

## Monitoring & Observability

### Metrics
- **Application Metrics**: Request rates, error rates, latency
- **Business Metrics**: Workers created, executions, conversions
- **Infrastructure Metrics**: CPU, memory, disk, network

### Logging
- **Structured Logging**: JSON format with correlation IDs
- **Log Aggregation**: Centralized logging (ELK/Loki)
- **Log Levels**: DEBUG, INFO, WARN, ERROR, FATAL

### Tracing
- **Distributed Tracing**: OpenTelemetry
- **Trace Propagation**: Across all services
- **Performance Analysis**: Slow query identification

### Alerting
- **Health Checks**: Endpoint monitoring
- **Error Thresholds**: Automated alerts
- **SLA Monitoring**: Uptime and performance SLAs

## Disaster Recovery

### Backup Strategy
- **Database**: Daily full backups, hourly incremental
- **Retention**: 30 days for production data
- **Testing**: Monthly restore tests

### High Availability
- **Database**: Primary-replica setup with auto-failover
- **Redis**: Redis Sentinel for HA
- **API**: Multi-AZ deployment

### Incident Response
- **Runbooks**: Documented procedures
- **On-Call**: 24/7 rotation
- **Post-Mortems**: After major incidents

## Technology Stack

### Frontend
- **Framework**: Next.js 14 (App Router)
- **UI Library**: React 18
- **Styling**: Tailwind CSS + shadcn/ui
- **State Management**: Zustand + React Query
- **Type Safety**: TypeScript

### Backend
- **Runtime**: Node.js 20
- **Framework**: Next.js API Routes
- **API**: tRPC for type-safe APIs
- **Validation**: Zod
- **ORM**: Prisma

### Database
- **Primary**: PostgreSQL 16
- **Cache**: Redis 7
- **Search**: PostgreSQL Full-Text Search

### Infrastructure
- **Hosting**: Vercel (Frontend) + Railway/Render (Backend)
- **CDN**: Vercel Edge Network
- **Storage**: AWS S3 or Cloudflare R2
- **Email**: Resend or SendGrid

### DevOps
- **CI/CD**: GitHub Actions
- **Container**: Docker
- **Monitoring**: Sentry + Vercel Analytics
- **Logging**: Better Stack (Logtail)

## Deployment Architecture

### Environments
1. **Development**: Local development
2. **Staging**: Pre-production testing
3. **Production**: Live environment

### Deployment Strategy
- **Strategy**: Blue-Green deployment
- **Rollback**: Automatic on failure
- **Health Checks**: Before traffic routing
- **Database Migrations**: Zero-downtime migrations

## Future Considerations

### Phase 2 Enhancements
- Worker marketplace
- Custom integrations
- Advanced analytics dashboard
- Mobile app

### Phase 3 Enhancements
- AI worker collaboration
- Multi-worker workflows
- Advanced scheduling
- Workflow optimization AI

### Scalability Milestones
- **1K organizations**: Current architecture
- **10K organizations**: Add read replicas
- **100K organizations**: Microservices architecture
- **1M+ organizations**: Distributed system with event sourcing
