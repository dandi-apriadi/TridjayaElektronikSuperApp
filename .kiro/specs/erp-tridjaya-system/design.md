# Design Document: Sistem ERP Tridjaya

## Overview

Sistem ERP Tridjaya adalah platform manajemen terpadu berbasis cloud yang dirancang untuk mengelola operasional multi-cabang perusahaan retail (Aki, TV, HP). Sistem ini mengintegrasikan manajemen inventori, CRM dengan otomasi WhatsApp, HRIS, dan monitoring digital marketing dalam satu ekosistem yang aman dan scalable. Backend dibangun menggunakan Rust (Axum/Tokio) untuk performa tinggi dan keamanan memori, dengan PostgreSQL sebagai database utama dan Redis untuk caching serta message queue. Aplikasi mobile dikembangkan menggunakan Flutter untuk mendukung Android dan iOS dengan single codebase, dilengkapi dengan offline-first capability untuk operasional di lapangan dengan koneksi terbatas.

Sistem ini menerapkan Role-Based Access Control (RBAC) yang ketat dengan 5 role utama: Owner (akses penuh semua cabang), Kepala Cabang (manajemen operasional cabang spesifik), Admin (input data dan inventori), Sales (manajemen prospek dan penjualan), dan Driver (jadwal pengiriman). Setiap role memiliki dashboard dan fitur yang disesuaikan dengan tanggung jawab mereka, dengan audit log lengkap untuk transparansi dan keamanan data.

## Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        MA[Mobile App Flutter<br/>Android/iOS]
        WA[WhatsApp Gateway<br/>Self-Hosted]
    end
    
    subgraph "API Gateway Layer"
        AG[Axum API Gateway<br/>Rust]
        AUTH[Authentication Service<br/>JWT + RBAC]
    end
    
    subgraph "Application Services Layer"
        OPS[Operational Service<br/>Inventory, Reports]
        CRM[CRM Service<br/>Prospects, Campaigns]
        HRIS[HRIS Service<br/>Attendance, Tasks]
        SOCIAL[Social Media Service<br/>Analytics Integration]
        NOTIF[Notification Service<br/>WhatsApp, Push]
    end
    
    subgraph "Integration Layer"
        N8N[N8N Automation<br/>AI Chatbot, Workflows]
        WAPI[WhatsApp API<br/>Bulk Messaging]
        SMAPI[Social Media APIs<br/>Meta, TikTok]
    end
    
    subgraph "Data Layer"
        PG[(PostgreSQL<br/>Main Database)]
        REDIS[(Redis<br/>Cache & Queue)]
        S3[Object Storage<br/>Files, Images]
    end
    
    MA --> AG
    WA --> WAPI
    AG --> AUTH
    AUTH --> OPS
    AUTH --> CRM
    AUTH --> HRIS
    AUTH --> SOCIAL
    AUTH --> NOTIF
    
    OPS --> PG
    CRM --> PG
    HRIS --> PG
    SOCIAL --> PG
    
    OPS --> REDIS
    CRM --> REDIS
    NOTIF --> REDIS
    
    NOTIF --> WAPI
    WAPI --> N8N
    N8N --> WAPI
    
    SOCIAL --> SMAPI
    
    OPS --> S3
    HRIS --> S3
    
    style MA fill:#e1f5ff
    style AG fill:#fff4e1
    style PG fill:#e8f5e9
    style REDIS fill:#ffebee


## Technical Details

### Technology Stack

**Backend:**
- Language: Rust
- Framework: Axum (web framework) + Tokio (async runtime)
- API: RESTful JSON API with JWT authentication

**Database:**
- Primary: PostgreSQL (relational data)
- Cache: Redis (caching, message queue, session storage)
- Object Storage: S3-compatible storage for files and images

**Mobile:**
- Framework: Flutter (Dart)
- Platforms: Android and iOS
- Architecture: Offline-first with background sync

**Integration:**
- N8N: Self-hosted workflow automation for AI chatbot
- WhatsApp API: Self-hosted gateway for bulk messaging
- Social Media APIs: Meta (Facebook/Instagram) and TikTok

**Infrastructure:**
- Containerization: Docker
- Orchestration: Docker Compose (dev), Kubernetes/Swarm (prod)
- Monitoring: Prometheus + Grafana
- Deployment: Rolling updates with zero downtime

### Data Models

**User:**
- id: UUID
- username: String
- password_hash: String (bcrypt, 12 rounds)
- role: Enum (Owner, Kepala_Cabang, Admin, Sales, Driver)
- branch_id: UUID (nullable for Owner)
- whatsapp_number: String (for OTP-based password reset)
- is_active: Boolean (default true; set false to deactivate user and revoke all tokens)
- created_at: Timestamp
- updated_at: Timestamp
- deleted_at: Timestamp (nullable, soft delete — preserves audit trail)

**Branch:**
- id: UUID
- name: String
- address: String
- geofence_lat: Decimal
- geofence_lng: Decimal
- geofence_radius: Integer (meters)
- created_at: Timestamp

**Inventory_Item:**
- id: UUID
- branch_id: UUID
- category: Enum (Aki, TV, HP)
- name: String
- sku: String
- quantity: Integer
- low_stock_threshold: Integer
- created_at: Timestamp
- updated_at: Timestamp

**Stock_Transaction:**
- id: UUID
- item_id: UUID
- user_id: UUID
- type: Enum (Addition, Removal)
- quantity: Integer
- reason: String
- photo_url: String (nullable)
- created_at: Timestamp

**Attendance:**
- id: UUID
- user_id: UUID
- branch_id: UUID
- check_in_time: Timestamp
- check_out_time: Timestamp (nullable)
- gps_lat: Decimal
- gps_lng: Decimal
- selfie_url: String
- status: Enum (OnTime, Late, Absent)
- late_duration_minutes: Integer (nullable)
- working_hours: Decimal (nullable)
- created_at: Timestamp

**Task:**
- id: UUID
- title: String
- description: Text
- assignee_id: UUID
- creator_id: UUID
- branch_id: UUID
- due_date: Timestamp
- priority: Enum (Low, Medium, High, Urgent)
- status: Enum (Pending, InProgress, Completed, Cancelled)
- completion_proof_url: String (nullable)
- created_at: Timestamp
- updated_at: Timestamp

**Work_Report:**
- id: UUID
- user_id: UUID
- branch_id: UUID
- content: Text
- attachments: JSON (array of URLs)
- status: Enum (Pending, Approved, Rejected)
- reviewer_id: UUID (nullable)
- review_comment: Text (nullable)
- created_at: Timestamp
- reviewed_at: Timestamp (nullable)

**Delivery_Schedule:**
- id: UUID
- driver_id: UUID
- branch_id: UUID
- customer_name: String
- customer_address: String
- customer_phone: String
- items: JSON (array of item details)
- scheduled_time: Timestamp
- status: Enum (Pending, InProgress, Completed, Failed, Rescheduled)
- completion_photo_url: String (nullable)
- notes: Text (nullable)
- completed_at: Timestamp (nullable)
- created_at: Timestamp

**Prospect:**
- id: UUID
- sales_id: UUID
- branch_id: UUID (enforces branch-level isolation; Sales can only access prospects within their branch)
- name: String
- phone: String (unique)
- email: String (nullable)
- product_interest: Enum (Aki, TV, HP)
- source: String
- status: Enum (New, Contacted, Negotiation, Closed, Lost)
- notes: Text
- follow_up_date: Timestamp (nullable)
- created_at: Timestamp
- updated_at: Timestamp
- deleted_at: Timestamp (nullable, soft delete)

**WhatsApp_Campaign:**
- id: UUID
- creator_id: UUID
- branch_id: UUID (enforces branch isolation; campaign recipients must belong to same branch)
- name: String
- message_template: Text
- recipient_count: Integer
- sent_count: Integer
- delivered_count: Integer
- read_count: Integer
- failed_count: Integer
- status: Enum (Draft, Scheduled, InProgress, Completed, Cancelled)
- scheduled_at: Timestamp (nullable)
- started_at: Timestamp (nullable)
- completed_at: Timestamp (nullable)
- created_at: Timestamp

**WhatsApp_Message:**
- id: UUID
- campaign_id: UUID
- prospect_id: UUID
- phone: String
- message_content: Text
- status: Enum (Queued, Sent, Delivered, Read, Failed)
- sent_at: Timestamp (nullable)
- delivered_at: Timestamp (nullable)
- read_at: Timestamp (nullable)
- retry_count: Integer
- error_message: Text (nullable)
- created_at: Timestamp

**Chat_Message:**
- id: UUID
- sender_id: UUID
- recipient_id: UUID (nullable for group/broadcast)
- group_id: UUID (nullable)
- message_type: Enum (Text, Photo, Document)
- content: Text
- attachment_url: String (nullable)
- is_read: Boolean
- created_at: Timestamp

**Employee_Performance_Metric:**
- id: UUID
- user_id: UUID
- branch_id: UUID
- metric_date: Date
- role: Enum (Sales, Admin, Driver)
- prospects_converted: Integer (nullable, Sales only)
- revenue_generated: Decimal (nullable, Sales only)
- conversion_rate: Decimal (nullable, Sales only)
- tasks_completed: Integer (nullable, non-Sales)
- tasks_assigned: Integer (nullable, non-Sales)
- task_completion_rate: Decimal (nullable, non-Sales)
- attendance_days: Integer (nullable, non-Sales)
- working_days: Integer (nullable, non-Sales)
- attendance_rate: Decimal (nullable, non-Sales)
- late_count: Integer (nullable, non-Sales)
- punctuality_score: Decimal (nullable, non-Sales)
- work_reports_submitted: Integer (nullable, non-Sales)
- work_reports_approved: Integer (nullable, non-Sales)
- work_report_quality_score: Decimal (nullable, non-Sales)
- overall_score: Decimal
- rank_in_role: Integer
- rank_in_branch: Integer
- rank_overall: Integer
- performance_trend: Enum (Improving, Declining, Stable)
- created_at: Timestamp
- updated_at: Timestamp

**Audit_Log:**
- id: UUID
- user_id: UUID
- action: Enum (Create, Update, Delete, Login, Logout, PermissionDenied)
- entity_type: String
- entity_id: UUID
- old_value: JSON (nullable)
- new_value: JSON (nullable)
- ip_address: String
- user_agent: String
- created_at: Timestamp

### Security Considerations

1. **Authentication:**
   - JWT tokens with 24-hour expiration
   - JWT claims MUST include `jti` (JWT ID) — unique UUID per token — to support individual token revocation
   - Refresh token mechanism for seamless re-authentication; refresh tokens stored in Redis with 7-day TTL
   - Refresh tokens MUST be invalidated (deleted from Redis) on: logout, password change, account deactivation
   - Secure password hashing with bcrypt (12 rounds minimum)
   - OTP-based password reset via WhatsApp: 6-digit random OTP, 15-minute TTL in Redis, max 3 attempts/hour/user

2. **Authorization:**
   - Role-Based Access Control (RBAC) enforced at API level
   - Branch-level data isolation for non-Owner roles — enforced at both API middleware AND data model level (branch_id on Prospect, WhatsApp_Campaign)
   - Middleware validation on every protected endpoint
   - Prospect and campaign endpoints MUST filter by branch_id matching the authenticated user's branch_id for non-Owner roles

3. **Data Protection:**
   - Encryption at rest for sensitive fields (phone, address, financial data)
   - TLS/HTTPS for all API communications
   - Signed URLs with expiration for file access: max 15 minutes for direct viewing, max 1 hour for report downloads
   - Chat message `content` field encrypted with AES-256-GCM; per-conversation encryption keys stored in secret manager (not in application DB)
   - Input sanitization to prevent SQL injection and XSS
   - Soft delete (`deleted_at`) on User and Prospect tables to preserve audit trail integrity

4. **Rate Limiting:**
   - Login attempts: 5 per 15 minutes per IP
   - API requests: 100 per minute per user
   - WhatsApp messages: 20 per minute per campaign
   - File/photo uploads: 10 per minute per user
   - PDF report exports: 5 per minute per user
   - Attendance check-in: 2 per day per user (enforced at business logic level)
   - Password reset OTP requests: 3 per hour per user

5. **Audit Trail:**
   - Immutable audit logs for all critical operations
   - 2-year retention policy
   - Separate storage from operational data
   - **DB-level immutability enforcement:** The `audit_logs` table MUST be owned by a dedicated PostgreSQL role (`audit_writer`) that has INSERT privilege only. The application database user SHALL NOT have UPDATE or DELETE privileges on `audit_logs`. A PostgreSQL trigger SHALL be added to reject any UPDATE or DELETE attempt at the database level.

6. **Webhook Security:**
   - All N8N webhook endpoints MUST validate HMAC-SHA256 signature on incoming requests
   - Signature computed by WhatsApp_Gateway using a shared secret stored in secret manager
   - Requests with missing or invalid signatures are rejected with HTTP 401 and logged as security events
   - Shared secret rotated at minimum every 90 days

7. **Request Tracing:**
   - All API responses MUST include `X-Request-ID` header for end-to-end tracing
   - Request ID propagated across all internal service calls for debugging and audit correlation

### Performance Optimization

1. **Caching Strategy:**
   - Dashboard metrics cached for 5 minutes
   - User sessions in Redis
   - Frequently accessed reference data (branches, users)

2. **Database Optimization:**
   - Indexes on foreign keys and frequently queried fields
   - Connection pooling (10-50 connections)
   - Pagination for list endpoints (max 50 items)

3. **Mobile App Optimization:**
   - Lazy loading for lists and images
   - Image compression before upload
   - Background sync for offline operations
   - Local SQLite cache for offline data

4. **API Optimization:**
   - Response compression (gzip)
   - Selective field loading
   - Batch endpoints for bulk operations

### Offline-First Architecture

**Mobile App Local Storage:**
- SQLite database for cached data
- File system for photos and documents
- Sync queue for pending operations

**Sync Strategy:**
- Automatic sync when connection restored
- Conflict resolution: server wins for most cases, user prompt for critical data
- **Attendance conflict resolution: strict server-wins policy** — if an attendance record already exists on server for the same user and date, the offline record is rejected and the user is notified; no user prompt for attendance conflicts
- Incremental sync based on last sync timestamp
- Background sync service

**Offline Capabilities:**
- View cached dashboard data
- Record attendance (with GPS and photo)
- Create work reports
- View assigned tasks
- Mark tasks as completed
- View delivery schedules
- Create prospects
- View chat history

### Integration Architecture

**N8N Workflow Automation:**
- AI chatbot conversation handling
- Automated report generation
- Scheduled notification triggers
- Webhook processing for WhatsApp
- All incoming webhooks MUST be authenticated via HMAC-SHA256 signature validation before processing

**WhatsApp Gateway:**
- Self-hosted WhatsApp Business API
- Message queue in Redis
- Rate limiting and retry logic
- Delivery status tracking
- Attaches HMAC-SHA256 signature header to all webhook calls sent to N8N_Service

**Social Media Integration:**
- OAuth2 authentication for Meta and TikTok APIs
- Scheduled data refresh (every 6 hours)
- Metric aggregation and storage
- Error handling and retry logic

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: JWT Token Contains Correct User Information

*For any* valid user credentials, when authentication succeeds, the generated JWT token SHALL contain the correct user role and branch information matching the authenticated user's database record.

**Validates: Requirements 1.1**

### Property 2: Invalid Credentials Are Always Rejected

*For any* invalid credentials (wrong username, wrong password, non-existent user), the authentication service SHALL reject the login attempt and return an appropriate error message.

**Validates: Requirements 1.2**

### Property 3: Role-Based Permission Enforcement

*For any* JWT token and protected endpoint, the authorization service SHALL grant access if and only if the user's role has permission for that endpoint according to RBAC rules.

**Validates: Requirements 1.3**

### Property 4: Dashboard Data Aggregation Correctness

*For any* set of branch data, the Owner dashboard aggregation SHALL produce totals that equal the sum of individual branch values for inventory, sales, and attendance metrics.

**Validates: Requirements 2.1, 2.2, 2.3**

### Property 5: Branch Data Isolation for Kepala Cabang

*For any* Kepala Cabang user, all dashboard data and operations SHALL be filtered to show only data from their assigned branch, with no access to other branches' data.

**Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8**

### Property 6: Stock Transaction Recording Completeness

*For any* stock addition or removal operation, the system SHALL record a transaction entry containing timestamp, user information, quantity, and reason, and SHALL update the inventory item's quantity accordingly.

**Validates: Requirements 7.1, 7.2**

### Property 7: Stock Alert Generation on Low Threshold

*For any* inventory item, when the quantity falls below the defined low_stock_threshold after a transaction, the system SHALL generate a Stock_Alert.

**Validates: Requirements 7.3**

### Property 8: Real-Time Stock Calculation Accuracy

*For any* sequence of stock transactions on an inventory item, the calculated current stock level SHALL equal the initial quantity plus all additions minus all removals.

**Validates: Requirements 7.4**

### Property 9: Audit Log Creation for All Transactions

*For any* stock transaction, attendance record, task creation, or prospect modification, the system SHALL create an immutable Audit_Log entry containing user ID, timestamp, action type, entity details, and old/new values.

**Validates: Requirements 7.5, 18.1, 18.2**

### Property 10: Negative Stock Prevention

*For any* stock removal operation, if the removal quantity exceeds the current stock level and the item type does not explicitly allow negative stock, the system SHALL reject the operation.

**Validates: Requirements 7.9**

### Property 11: Geofence Validation for Attendance

*For any* attendance check-in attempt, the system SHALL accept the attendance if and only if the GPS coordinates are within the defined geofence radius of the branch location.

**Validates: Requirements 10.2, 10.3**

### Property 12: Duplicate Attendance Detection

*For any* user and date, the system SHALL reject any check-in attempt if an attendance record already exists for that user on that date.

**Validates: Requirements 10.4**

### Property 13: Working Hours Calculation Accuracy

*For any* attendance record with both check-in and check-out times, the calculated working hours SHALL equal the time difference between check-out and check-in in hours.

**Validates: Requirements 10.5**

### Property 14: Late Attendance Detection and Calculation

*For any* attendance check-in, if the check-in time is after the branch's defined start time, the system SHALL mark the attendance as late and calculate the delay duration in minutes.

**Validates: Requirements 10.8**

### Property 15: Task Assignment and Notification

*For any* task creation, the system SHALL record all task fields (title, description, assignee, due date, priority) and the task SHALL appear in the assignee's task list.

**Validates: Requirements 11.1, 11.3**

### Property 16: Task Filtering and Sorting Correctness

*For any* user's task list, the displayed tasks SHALL include only tasks assigned to that user, ordered first by priority (Urgent > High > Medium > Low) and then by due date (earliest first).

**Validates: Requirements 11.3**

### Property 17: Delivery Schedule Filtering by Date and Driver

*For any* Driver user and date, the displayed delivery schedule SHALL include only deliveries assigned to that driver with scheduled_time on that date, ordered by scheduled_time.

**Validates: Requirements 12.3**

### Property 18: Prospect Unique ID Assignment

*For any* set of created prospects, all prospect IDs SHALL be unique with no duplicates.

**Validates: Requirements 13.2**

### Property 19: Duplicate Prospect Prevention by Phone

*For any* new prospect creation attempt, if a prospect with the same phone number already exists, the system SHALL reject the creation and return an error indicating the duplicate.

**Validates: Requirements 13.9**

### Property 20: Prospect Conversion Funnel Calculation

*For any* set of prospects, the conversion funnel statistics SHALL correctly count prospects in each status category (New, Contacted, Negotiation, Closed, Lost) with totals summing to the total prospect count.

**Validates: Requirements 13.8**

### Property 21: Campaign Validation Correctness

*For any* bulk message campaign creation, the system SHALL validate that the recipient list is non-empty, all phone numbers are valid format, and the message content is non-empty, rejecting invalid campaigns.

**Validates: Requirements 14.1**

### Property 22: WhatsApp Rate Limiting Enforcement

*For any* sequence of WhatsApp messages in a campaign, the system SHALL enforce a maximum rate of 20 messages per minute, queuing excess messages for later delivery.

**Validates: Requirements 14.2**

### Property 23: Message Personalization Correctness

*For any* prospect and message template, the personalized message SHALL contain the prospect's name and product interest correctly substituted into the template placeholders.

**Validates: Requirements 14.4**

### Property 24: Message Retry Logic with Exponential Backoff

*For any* failed message send attempt, the system SHALL retry up to 3 times with exponentially increasing delays (e.g., 1s, 2s, 4s) before marking the message as permanently failed.

**Validates: Requirements 14.6**

### Property 25: Campaign Statistics Calculation

*For any* campaign, the displayed statistics (sent_count, delivered_count, read_count, failed_count) SHALL equal the count of messages in the corresponding status, and sent_count SHALL equal the sum of delivered_count, read_count, and failed_count.

**Validates: Requirements 14.7, 14.8**

### Property 26: Duplicate Message Prevention Within Time Window

*For any* prospect, if a message was sent to that prospect within the last 24 hours, the system SHALL prevent sending another message to the same prospect until the 24-hour window expires.

**Validates: Requirements 14.10**

### Property 27: Audit Log Immutability

*For any* created Audit_Log entry, any attempt to modify or delete the entry SHALL be rejected by the system.

**Validates: Requirements 18.3**

### Property 28: Audit Log Filtering Correctness

*For any* audit log query with filters (date range, user, action type), the returned logs SHALL include only entries matching all specified filter criteria.

**Validates: Requirements 18.4, 18.5**

### Property 29: Chat Message Delivery to Correct Recipient

*For any* one-on-one chat message, the message SHALL be delivered to and visible only by the specified recipient and the sender.

**Validates: Requirements 21.1, 21.2**

### Property 30: Password Encryption with Bcrypt

*For any* user password, the stored password_hash SHALL be a valid bcrypt hash with minimum 12 rounds, and the original password SHALL NOT be stored in plain text.

**Validates: Requirements 22.1**

### Property 31: JWT Signature Validation

*For any* JWT token, the system SHALL validate the token signature, and SHALL reject tokens with invalid signatures or expired timestamps.

**Validates: Requirements 22.2**

### Property 32: Login Rate Limiting Enforcement

*For any* IP address, after 5 failed login attempts within a 15-minute window, the system SHALL block further login attempts from that IP for the remainder of the window.

**Validates: Requirements 22.5**

### Property 33: SQL Injection Prevention Through Input Sanitization

*For any* user input used in database queries, the system SHALL sanitize the input to prevent SQL injection attacks, and malicious SQL patterns SHALL NOT be executed.

**Validates: Requirements 22.6**

### Property 34: Performance Ranking Calculation Correctness

*For any* set of employees with performance metrics, the ranking calculation SHALL order employees correctly by their overall_score in descending order, with rank 1 assigned to the highest score.

**Validates: Requirements 24.3, 24.4**

### Property 35: Performance Metric Aggregation Accuracy

*For any* employee and time period, the calculated performance metrics (conversion rate, task completion rate, attendance rate) SHALL equal the correct ratio of successful outcomes to total attempts.

**Validates: Requirements 24.1, 24.2**

### Property 36: Refresh Token Revocation on Logout and Password Change

*For any* user who has logged out or changed their password, any subsequent attempt to use a refresh token issued before that event SHALL be rejected by the Auth_Service.

**Validates: Requirements 1.12, 1.13, 26.3**

### Property 37: Prospect Branch Isolation

*For any* Sales user, all prospect list and prospect detail API responses SHALL contain only prospects where prospect.branch_id equals the authenticated user's branch_id.

**Validates: Requirements 13.1, 1.6**

### Property 38: Campaign Branch Isolation

*For any* campaign creation request, if any recipient prospect's branch_id does not match the creator's branch_id, the system SHALL reject the campaign creation with an appropriate error.

**Validates: Requirements 14.11, 14.12**

### Property 39: Task Assignment Branch Enforcement

*For any* task creation by a Kepala_Cabang, if the assignee's branch_id does not match the creator's branch_id, the system SHALL reject the task assignment. For an Owner creator, any branch_id combination SHALL be accepted.

**Validates: Requirements 11.10, 11.11, 11.12**

### Property 40: Delivery Status Transition Enforcement

*For any* delivery with status InProgress or Completed, any edit or cancel request SHALL be rejected. A Driver SHALL only be able to set status to InProgress, Completed, or Failed, and a notes field SHALL be required when status is set to Failed.

**Validates: Requirements 12.11, 12.12, 12.13**

### Property 41: Offline Attendance Conflict Resolution

*For any* offline attendance sync request where an attendance record already exists on the server for the same user_id and date, the server SHALL reject the offline record and return a conflict error without modifying the existing server record.

**Validates: Requirements 10.13, 19.9**

### Property 42: N8N Webhook HMAC Validation

*For any* webhook request received by the N8N_Service, if the HMAC-SHA256 signature header is absent or does not match the expected signature computed from the request body and shared secret, the request SHALL be rejected with HTTP 401.

**Validates: Requirements 27.1, 27.2, 27.3**
