# Implementation Plan: Sistem ERP Tridjaya

## Overview

This implementation plan breaks down the ERP Tridjaya System into discrete coding tasks organized by technical layers and role-specific features. The system uses Rust (Axum/Tokio) for the backend, Flutter for mobile apps, PostgreSQL as the primary database, and Redis for caching and message queuing. The plan follows an incremental approach: infrastructure setup → core authentication → role-based features → integrations → testing and deployment.

Each task references specific requirements from the requirements document and includes property-based tests where applicable (based on the Correctness Properties defined in the design document).

## Tasks

### Phase 1: Infrastructure and Core Setup

- [ ] 1. Set up project structure and development environment
  - Create Rust workspace with Axum backend project structure
  - Create Flutter mobile app project with proper folder organization
  - Set up Docker Compose for local development (PostgreSQL, Redis, S3-compatible storage)
  - Configure environment variables and secrets management
  - Set up database migration tool (sqlx or diesel)
  - Create initial CI/CD pipeline configuration files
  - _Requirements: 24.1, 24.2, 24.3_

- [ ] 2. Implement database schema and migrations
  - [ ] 2.1 Create core entity tables (User, Branch, Audit_Log)
    - Write SQL migrations for User table with role enum and branch_id
    - Write SQL migrations for Branch table with geofence coordinates
    - Write SQL migrations for Audit_Log table with immutability constraints
    - Add indexes on foreign keys and frequently queried fields
    - _Requirements: 1.4, 1.5, 18.2, 18.6, 23.4_
  
  - [ ] 2.2 Create inventory management tables
    - Write SQL migrations for Inventory_Item table with category enum
    - Write SQL migrations for Stock_Transaction table with type enum
    - Add indexes for branch_id, item_id, and created_at fields
    - _Requirements: 7.1, 7.2, 7.5_
  
  - [ ] 2.3 Create HRIS tables
    - Write SQL migrations for Attendance table with geofence validation fields
    - Write SQL migrations for Task table with priority and status enums
    - Write SQL migrations for Work_Report table with approval workflow fields
    - Write SQL migrations for Delivery_Schedule table with status tracking
    - _Requirements: 10.1, 10.5, 11.1, 12.1_
  
  - [ ] 2.4 Create CRM and messaging tables
    - Write SQL migrations for Prospect table with unique phone constraint
    - Write SQL migrations for WhatsApp_Campaign table with statistics fields
    - Write SQL migrations for WhatsApp_Message table with retry tracking
    - Write SQL migrations for Chat_Message table with encryption support
    - _Requirements: 13.1, 13.2, 13.9, 14.1, 21.1_

- [ ] 3. Checkpoint - Database schema validation
  - Run all migrations successfully
  - Verify all tables created with correct constraints and indexes
  - Test rollback functionality for migrations
  - Ask the user if questions arise

### Phase 2: Authentication and Authorization (RBAC)

- [ ] 4. Implement authentication service
  - [ ] 4.1 Create user authentication module
    - Implement bcrypt password hashing with 12 rounds minimum
    - Create user registration endpoint with password validation
    - Create login endpoint that validates credentials against database
    - Implement JWT token generation with user role and branch_id in claims
    - Set JWT expiration to 24 hours
    - _Requirements: 1.1, 22.1, 22.2_
  
  - [ ]* 4.2 Write property test for JWT token correctness
    - **Property 1: JWT Token Contains Correct User Information**
    - **Validates: Requirements 1.1**
    - Generate random valid user credentials, authenticate, verify JWT contains correct role and branch_id
  
  - [ ]* 4.3 Write property test for invalid credentials rejection
    - **Property 2: Invalid Credentials Are Always Rejected**
    - **Validates: Requirements 1.2**
    - Generate random invalid credentials (wrong password, non-existent user), verify all are rejected
  
  - [ ] 4.4 Implement JWT validation middleware
    - Create Axum middleware to extract and validate JWT from Authorization header
    - Verify JWT signature and expiration
    - Extract user claims (user_id, role, branch_id) and attach to request context
    - Return 401 Unauthorized for invalid or expired tokens
    - _Requirements: 1.3, 1.10, 22.2_
  
  - [ ] 4.5 Implement refresh token mechanism
    - Create refresh token endpoint for seamless re-authentication
    - Store refresh tokens in Redis with expiration
    - Implement token rotation on refresh
    - _Requirements: 1.10_

- [ ] 5. Implement Role-Based Access Control (RBAC)
  - [ ] 5.1 Create RBAC middleware and permission definitions
    - Define permission matrix for 5 roles (Owner, Kepala_Cabang, Admin, Sales, Driver)
    - Create Axum middleware to check role permissions for each endpoint
    - Implement branch-level data isolation for non-Owner roles
    - Log permission denials to Audit_Log
    - _Requirements: 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 18.9_
  
  - [ ]* 5.2 Write property test for role-based permission enforcement
    - **Property 3: Role-Based Permission Enforcement**
    - **Validates: Requirements 1.3**
    - Generate random JWT tokens with different roles, test access to protected endpoints, verify permissions enforced correctly
  
  - [ ]* 5.3 Write unit tests for RBAC edge cases
    - Test Owner access to all branches
    - Test Kepala_Cabang restricted to assigned branch
    - Test permission denial logging
    - _Requirements: 1.5, 1.6, 18.9_

- [ ] 6. Implement rate limiting and security measures
  - [ ] 6.1 Create rate limiting middleware
    - Implement login rate limiting (5 attempts per 15 minutes per IP) using Redis
    - Implement API rate limiting (100 requests per minute per user)
    - Return 429 Too Many Requests when limits exceeded
    - _Requirements: 22.5_
  
  - [ ]* 6.2 Write property test for login rate limiting
    - **Property 32: Login Rate Limiting Enforcement**
    - **Validates: Requirements 22.5**
    - Simulate multiple failed login attempts from same IP, verify blocking after 5 attempts
  
  - [ ] 6.3 Implement input sanitization
    - Create input validation middleware for all endpoints
    - Sanitize SQL inputs to prevent injection attacks
    - Validate and sanitize JSON payloads
    - _Requirements: 22.6_
  
  - [ ]* 6.4 Write property test for SQL injection prevention
    - **Property 33: SQL Injection Prevention Through Input Sanitization**
    - **Validates: Requirements 22.6**
    - Generate random malicious SQL patterns in inputs, verify they are sanitized and not executed

- [ ] 7. Checkpoint - Authentication and authorization complete
  - Test login flow end-to-end for all 5 roles
  - Verify JWT tokens generated correctly
  - Verify RBAC permissions enforced
  - Verify rate limiting works
  - Ensure all tests pass, ask the user if questions arise


### Phase 3: Dashboard Services - Owner Role

- [ ] 8. Implement Owner dashboard backend service
  - [ ] 8.1 Create aggregated metrics calculation service
    - Implement function to aggregate inventory levels across all branches
    - Implement function to aggregate sales data (daily, weekly, monthly) per branch
    - Implement function to aggregate attendance summary across all branches
    - Implement function to count pending tasks per branch
    - Implement function to fetch low stock alerts from all branches
    - Implement function to fetch employee performance rankings (Sales and non-Sales)
    - Cache dashboard metrics in Redis with 5-minute TTL
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.10, 2.11, 23.2_
  
  - [ ]* 8.2 Write property test for dashboard aggregation correctness
    - **Property 4: Dashboard Data Aggregation Correctness**
    - **Validates: Requirements 2.1, 2.2, 2.3**
    - Generate random branch data, verify Owner dashboard totals equal sum of individual branches
  
  - [ ] 8.3 Create Owner dashboard API endpoints
    - Create GET /api/owner/dashboard endpoint returning aggregated metrics
    - Create GET /api/owner/branches/:id/details endpoint for branch-specific data
    - Create GET /api/owner/performance/rankings endpoint for employee rankings
    - Implement automatic refresh mechanism (5-minute intervals)
    - Restrict endpoints to Owner role only
    - _Requirements: 2.1, 2.7, 2.8, 2.10_
  
  - [ ]* 8.4 Write unit tests for Owner dashboard endpoints
    - Test aggregation with multiple branches
    - Test branch-specific detail retrieval
    - Test caching behavior
    - Test performance ranking retrieval
    - _Requirements: 2.1, 2.7, 2.10_

- [ ] 9. Implement Owner dashboard mobile UI (Flutter)
  - [ ] 9.1 Create Owner dashboard screen
    - Design dashboard layout with aggregated metrics cards
    - Implement inventory summary widget (Aki, TV, HP totals)
    - Implement sales performance widget with charts
    - Implement attendance summary widget
    - Implement pending tasks widget
    - Implement low stock alerts widget
    - Implement employee performance rankings widget with tabs (Sales/Non-Sales)
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.10, 2.11_
  
  - [ ] 9.2 Implement branch selection and detail view
    - Create branch selector dropdown
    - Create branch detail screen showing branch-specific data
    - Implement navigation from dashboard to branch details
    - _Requirements: 2.7_
  
  - [ ] 9.3 Implement offline caching for Owner dashboard
    - Cache dashboard data locally using SQLite
    - Display last cached data when offline with timestamp
    - Implement automatic refresh when connection restored
    - _Requirements: 2.8, 2.9, 19.2_
  
  - [ ] 9.4 Create employee performance ranking screen
    - Display top 10 and bottom 5 performers for Sales
    - Display top 10 and bottom 5 performers for non-Sales
    - Implement filter by time period (daily, weekly, monthly, quarterly, yearly)
    - Implement filter by branch
    - Display performance metrics for each employee
    - Display performance trend indicators (improving, declining, stable)
    - Implement drill-down to individual employee details
    - _Requirements: 2.10, 2.11, 24.5, 24.6, 24.7, 24.8, 24.9, 24.10, 24.11, 24.12_

### Phase 4: Dashboard Services - Kepala Cabang Role

- [ ] 10. Implement Kepala Cabang dashboard backend service
  - [ ] 10.1 Create branch-specific metrics service
    - Implement function to fetch inventory levels for specific branch
    - Implement function to fetch today's attendance for branch employees
    - Implement function to fetch pending/completed tasks for branch
    - Implement function to fetch today's delivery schedule for branch
    - Implement function to fetch low stock alerts for branch
    - Implement function to fetch daily sales summary for branch
    - Implement function to fetch pending work reports for branch
    - Apply branch_id filter based on JWT claims
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_
  
  - [ ]* 10.2 Write property test for branch data isolation
    - **Property 5: Branch Data Isolation for Kepala Cabang**
    - **Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8**
    - Generate data for multiple branches, verify Kepala Cabang only sees their assigned branch data
  
  - [ ] 10.3 Create Kepala Cabang dashboard API endpoints
    - Create GET /api/kepala-cabang/dashboard endpoint with branch filtering
    - Create GET /api/kepala-cabang/inventory endpoint
    - Create GET /api/kepala-cabang/attendance endpoint
    - Create GET /api/kepala-cabang/tasks endpoint
    - Create GET /api/kepala-cabang/deliveries endpoint
    - Create GET /api/kepala-cabang/work-reports/pending endpoint
    - Restrict all endpoints to Kepala_Cabang role
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.8_

- [ ] 11. Implement Kepala Cabang dashboard mobile UI (Flutter)
  - [ ] 11.1 Create Kepala Cabang dashboard screen
    - Design dashboard layout for branch operations
    - Implement inventory levels widget (Aki, TV, HP for branch)
    - Implement today's attendance widget with employee list
    - Implement pending tasks widget
    - Implement delivery schedule widget
    - Implement low stock alerts widget
    - Implement daily sales summary widget
    - Implement pending work reports widget
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_
  
  - [ ] 11.2 Implement offline caching for Kepala Cabang dashboard
    - Cache branch-specific dashboard data locally
    - Display cached data when offline
    - _Requirements: 3.9, 19.2_

### Phase 5: Dashboard Services - Admin Role

- [ ] 12. Implement Admin dashboard backend service
  - [ ] 12.1 Create inventory management service for Admin
    - Implement function to fetch current stock levels for branch
    - Implement function to fetch recent stock movements (today)
    - Implement function to fetch low stock alerts for branch
    - Implement function to fetch pending data entry tasks
    - Implement function to fetch recent audit log entries for inventory
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.6, 4.7_
  
  - [ ] 12.2 Create Admin dashboard API endpoints
    - Create GET /api/admin/dashboard endpoint
    - Create GET /api/admin/inventory endpoint
    - Create GET /api/admin/stock-movements endpoint
    - Create GET /api/admin/alerts endpoint
    - Create GET /api/admin/audit-logs endpoint
    - Restrict endpoints to Admin role
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.7_

- [ ] 13. Implement Admin dashboard mobile UI (Flutter)
  - [ ] 13.1 Create Admin dashboard screen
    - Design dashboard layout focused on inventory management
    - Implement current stock levels widget
    - Implement recent stock movements widget
    - Implement low stock alerts widget
    - Implement quick access buttons to stock input forms
    - Implement pending tasks widget
    - Implement recent audit log widget
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7_

### Phase 6: Dashboard Services - Sales Role

- [ ] 14. Implement Sales dashboard backend service
  - [ ] 14.1 Create CRM metrics service for Sales
    - Implement function to count total prospects assigned to Sales
    - Implement function to categorize prospects by status (new, contacted, negotiation, closed, lost)
    - Implement function to fetch today's follow-up tasks
    - Implement function to calculate sales achievement vs target (daily, weekly, monthly)
    - Implement function to fetch recent WhatsApp campaign results
    - Implement function to calculate conversion rate statistics
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.7, 5.8_
  
  - [ ]* 14.2 Write property test for prospect conversion funnel
    - **Property 20: Prospect Conversion Funnel Calculation**
    - **Validates: Requirements 13.8**
    - Generate random prospects with different statuses, verify funnel counts are correct and sum to total
  
  - [ ] 14.3 Create Sales dashboard API endpoints
    - Create GET /api/sales/dashboard endpoint
    - Create GET /api/sales/prospects/summary endpoint
    - Create GET /api/sales/follow-ups/today endpoint
    - Create GET /api/sales/performance endpoint
    - Create GET /api/sales/campaigns/recent endpoint
    - Restrict endpoints to Sales role
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.7_

- [ ] 15. Implement Sales dashboard mobile UI (Flutter)
  - [ ] 15.1 Create Sales dashboard screen
    - Design dashboard layout focused on CRM and sales
    - Implement total prospects widget
    - Implement prospects by status widget (pie chart or cards)
    - Implement today's follow-ups widget
    - Implement sales achievement widget with progress bars
    - Implement quick access button to add new prospect
    - Implement recent campaigns widget
    - Implement conversion rate widget
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8_

### Phase 7: Dashboard Services - Driver Role

- [ ] 16. Implement Driver dashboard backend service
  - [ ] 16.1 Create delivery schedule service for Driver
    - Implement function to fetch today's deliveries for specific driver
    - Implement function to filter deliveries by status (pending, in-progress, completed, failed)
    - Implement function to calculate optimized route suggestions
    - Implement function to fetch delivery history for current week
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.7_
  
  - [ ]* 16.2 Write property test for delivery filtering
    - **Property 17: Delivery Schedule Filtering by Date and Driver**
    - **Validates: Requirements 12.3**
    - Generate random deliveries for multiple drivers and dates, verify filtering returns correct subset
  
  - [ ] 16.3 Create Driver dashboard API endpoints
    - Create GET /api/driver/dashboard endpoint
    - Create GET /api/driver/deliveries/today endpoint
    - Create GET /api/driver/deliveries/history endpoint
    - Create GET /api/driver/route-optimization endpoint
    - Restrict endpoints to Driver role
    - _Requirements: 6.1, 6.2, 6.4, 6.7_

- [ ] 17. Implement Driver dashboard mobile UI (Flutter)
  - [ ] 17.1 Create Driver dashboard screen
    - Design dashboard layout focused on deliveries
    - Implement today's delivery schedule widget with customer addresses
    - Implement delivery status indicators (pending, in-progress, completed, failed)
    - Implement route optimization suggestions widget
    - Implement navigation integration buttons for each delivery
    - Implement delivery completion button with photo upload
    - Implement delivery history widget
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7_
  
  - [ ] 17.2 Implement offline caching for Driver dashboard
    - Cache today's delivery schedule locally
    - Allow offline viewing of cached deliveries
    - _Requirements: 6.8, 19.7_

- [ ] 18. Checkpoint - All role-based dashboards complete
  - Test each dashboard for all 5 roles
  - Verify data isolation works correctly
  - Verify offline caching works
  - Ensure all tests pass, ask the user if questions arise


### Phase 8: Inventory Management

- [ ] 19. Implement inventory management backend service
  - [ ] 19.1 Create stock transaction service
    - Implement POST /api/inventory/stock/add endpoint for stock additions
    - Implement POST /api/inventory/stock/remove endpoint for stock removals
    - Record timestamp, user_id, quantity, reason, and optional photo_url for each transaction
    - Update Inventory_Item quantity atomically using database transactions
    - Create Audit_Log entry for each stock transaction
    - Prevent negative stock levels (reject removal if quantity exceeds current stock)
    - _Requirements: 7.1, 7.2, 7.5, 7.9_
  
  - [ ]* 19.2 Write property test for stock transaction recording
    - **Property 6: Stock Transaction Recording Completeness**
    - **Validates: Requirements 7.1, 7.2**
    - Generate random stock operations, verify all transaction details recorded and quantity updated
  
  - [ ]* 19.3 Write property test for real-time stock calculation
    - **Property 8: Real-Time Stock Calculation Accuracy**
    - **Validates: Requirements 7.4**
    - Generate sequence of additions and removals, verify final stock equals initial + additions - removals
  
  - [ ]* 19.4 Write property test for negative stock prevention
    - **Property 10: Negative Stock Prevention**
    - **Validates: Requirements 7.9**
    - Attempt to remove more stock than available, verify operation rejected
  
  - [ ] 19.5 Implement stock alert service
    - Create background job to check inventory levels against low_stock_threshold
    - Generate Stock_Alert when quantity falls below threshold
    - Send notifications to Admin and Kepala_Cabang via Notification_Service
    - _Requirements: 7.3, 16.6_
  
  - [ ]* 19.6 Write property test for stock alert generation
    - **Property 7: Stock Alert Generation on Low Threshold**
    - **Validates: Requirements 7.3**
    - Simulate stock removal that crosses threshold, verify alert generated
  
  - [ ] 19.7 Create inventory query endpoints
    - Create GET /api/inventory/items endpoint with branch filtering and pagination
    - Create GET /api/inventory/items/:id endpoint for item details
    - Create GET /api/inventory/transactions endpoint with filtering by item, date range, user
    - Create GET /api/inventory/alerts endpoint for low stock alerts
    - _Requirements: 7.4, 8.1_

- [ ] 20. Implement inventory management mobile UI (Flutter)
  - [ ] 20.1 Create stock input forms
    - Create stock addition form with item selection, quantity, reason, and photo upload
    - Create stock removal form with item selection, quantity, reason, and photo upload
    - Implement barcode scanner integration for quick item selection
    - Implement photo capture and compression before upload
    - _Requirements: 7.1, 7.2, 7.6, 7.7_
  
  - [ ] 20.2 Create inventory list and detail screens
    - Create inventory list screen with search and filter by category
    - Create item detail screen showing current stock, threshold, and transaction history
    - Implement low stock alert indicators
    - _Requirements: 7.4, 7.3_
  
  - [ ] 20.3 Implement offline inventory management
    - Queue stock transactions locally when offline
    - Sync transactions in chronological order when connection restored
    - Display sync status and pending transaction count
    - _Requirements: 7.8, 19.3, 19.8_

- [ ] 21. Implement integrated stock reporting
  - [ ] 21.1 Create stock reporting service
    - Implement function to generate stock report for all branches (Owner) or specific branch (Kepala_Cabang)
    - Calculate stock turnover rate for each product category
    - Identify branches with excess stock and low stock
    - Generate stock movement history for specified date range
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5, 8.6_
  
  - [ ] 21.2 Create stock reporting API endpoints
    - Create GET /api/reports/stock endpoint with branch and date range filters
    - Create GET /api/reports/stock/turnover endpoint
    - Create GET /api/reports/stock/movements endpoint
    - Generate PDF reports using report generation library
    - _Requirements: 8.1, 8.6, 8.8_
  
  - [ ] 21.3 Create stock reporting mobile UI
    - Create stock report screen with charts and visualizations
    - Implement date range selector
    - Implement PDF export functionality
    - _Requirements: 8.7, 8.8_

### Phase 9: HRIS - Attendance Management

- [ ] 22. Implement attendance management backend service
  - [ ] 22.1 Create attendance recording service
    - Implement POST /api/attendance/check-in endpoint
    - Validate GPS coordinates against branch geofence (calculate distance from branch center)
    - Reject check-in if GPS is outside geofence radius
    - Detect and reject duplicate check-in attempts for same user and date
    - Store selfie photo in Object_Storage and save URL in database
    - Calculate late status by comparing check-in time with branch start time
    - Calculate late duration in minutes if late
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.6, 10.7, 10.8_
  
  - [ ]* 22.2 Write property test for geofence validation
    - **Property 11: Geofence Validation for Attendance**
    - **Validates: Requirements 10.2, 10.3**
    - Generate random GPS coordinates, verify check-in accepted only if within geofence radius
  
  - [ ]* 22.3 Write property test for duplicate attendance detection
    - **Property 12: Duplicate Attendance Detection**
    - **Validates: Requirements 10.4**
    - Attempt multiple check-ins for same user and date, verify only first is accepted
  
  - [ ] 22.4 Implement attendance check-out service
    - Implement POST /api/attendance/check-out endpoint
    - Calculate working hours as difference between check-out and check-in times
    - Update attendance record with check-out time and working hours
    - _Requirements: 10.5_
  
  - [ ]* 22.5 Write property test for working hours calculation
    - **Property 13: Working Hours Calculation Accuracy**
    - **Validates: Requirements 10.5**
    - Generate random check-in and check-out times, verify working hours calculated correctly
  
  - [ ]* 22.6 Write property test for late attendance detection
    - **Property 14: Late Attendance Detection and Calculation**
    - **Validates: Requirements 10.8**
    - Generate check-in times after branch start time, verify late status and duration calculated correctly
  
  - [ ] 22.7 Create attendance query endpoints
    - Create GET /api/attendance endpoint with filtering by branch, user, date range
    - Create GET /api/attendance/summary endpoint for dashboard metrics
    - _Requirements: 10.10_

- [ ] 23. Implement attendance mobile UI (Flutter)
  - [ ] 23.1 Create attendance check-in screen
    - Create check-in button with GPS location capture
    - Implement selfie camera capture with preview
    - Display geofence validation status (inside/outside)
    - Show error message if outside geofence
    - Display success confirmation with timestamp
    - _Requirements: 10.1, 10.2, 10.3, 10.6_
  
  - [ ] 23.2 Create attendance check-out screen
    - Create check-out button
    - Display total working hours after check-out
    - _Requirements: 10.5_
  
  - [ ] 23.3 Implement offline attendance recording
    - Allow check-in/check-out when offline
    - Store attendance data locally with GPS and photo
    - Sync to server when connection restored
    - _Requirements: 10.9, 19.3_
  
  - [ ] 23.4 Create attendance history screen
    - Display attendance history for current user
    - Show check-in/check-out times, working hours, late status
    - Filter by date range
    - _Requirements: 10.10_

### Phase 10: HRIS - Work Reports

- [ ] 24. Implement work report backend service
  - [ ] 24.1 Create work report submission service
    - Implement POST /api/work-reports endpoint
    - Store report content, attachments (photos/documents) in Object_Storage
    - Record timestamp and employee information
    - Set initial status as "Pending"
    - Send notification to employee's supervisor (Kepala_Cabang)
    - _Requirements: 9.1, 9.2, 9.4, 9.7_
  
  - [ ] 24.2 Create work report approval service
    - Implement PUT /api/work-reports/:id/approve endpoint
    - Implement PUT /api/work-reports/:id/reject endpoint
    - Allow Kepala_Cabang to add review comments
    - Update status and record reviewer_id and reviewed_at timestamp
    - Send notification to employee about approval/rejection
    - _Requirements: 9.6_
  
  - [ ] 24.3 Create work report query endpoints
    - Create GET /api/work-reports endpoint with filtering by user, branch, status, date range
    - Create GET /api/work-reports/pending endpoint for Kepala_Cabang
    - Create GET /api/work-reports/:id endpoint for report details
    - _Requirements: 9.5, 9.8_

- [ ] 25. Implement work report mobile UI (Flutter)
  - [ ] 25.1 Create work report submission screen
    - Create form with text input for report content
    - Implement multi-file attachment (photos and documents)
    - Implement photo capture and compression
    - Display submission confirmation
    - _Requirements: 9.1, 9.2_
  
  - [ ] 25.2 Implement offline work report creation
    - Allow creating work reports offline
    - Store reports and attachments locally
    - Sync to server when connection restored
    - _Requirements: 9.3, 19.4_
  
  - [ ] 25.3 Create work report approval screen (Kepala Cabang)
    - Display list of pending work reports
    - Create detail view with report content and attachments
    - Implement approve/reject buttons with comment input
    - _Requirements: 9.5, 9.6_
  
  - [ ] 25.4 Create work report history screen
    - Display work report submission history for employee
    - Show status (pending, approved, rejected) with color indicators
    - Display review comments if available
    - _Requirements: 9.8_

### Phase 11: HRIS - Task Management

- [ ] 26. Implement task management backend service
  - [ ] 26.1 Create task creation service
    - Implement POST /api/tasks endpoint
    - Record title, description, assignee_id, creator_id, branch_id, due_date, priority
    - Set initial status as "Pending"
    - Send WhatsApp notification to assigned employee via Notification_Service
    - _Requirements: 11.1, 11.2_
  
  - [ ]* 26.2 Write property test for task assignment
    - **Property 15: Task Assignment and Notification**
    - **Validates: Requirements 11.1, 11.3**
    - Create random tasks, verify all fields recorded and task appears in assignee's list
  
  - [ ] 26.3 Create task update service
    - Implement PUT /api/tasks/:id/status endpoint to update task status
    - Allow employees to mark tasks as "InProgress" or "Completed"
    - Allow attaching completion proof (photo/document)
    - Send notification to task creator when status changes to "Completed"
    - _Requirements: 11.4, 11.5, 11.7_
  
  - [ ] 26.4 Create task query endpoints
    - Create GET /api/tasks endpoint with filtering by assignee, branch, status, priority
    - Implement sorting by priority (Urgent > High > Medium > Low) then by due_date
    - Create GET /api/tasks/:id endpoint for task details
    - Create GET /api/tasks/statistics endpoint for completion metrics
    - _Requirements: 11.3, 11.8, 11.9_
  
  - [ ]* 26.5 Write property test for task filtering and sorting
    - **Property 16: Task Filtering and Sorting Correctness**
    - **Validates: Requirements 11.3**
    - Generate random tasks for multiple users, verify filtering returns correct subset ordered by priority and due date
  
  - [ ] 26.6 Implement task reminder service
    - Create background job to check for overdue tasks every hour
    - Send WhatsApp reminder for overdue tasks
    - Send proactive reminder for tasks due within 2 hours
    - _Requirements: 11.6, 16.1, 16.2, 16.3_

- [ ] 27. Implement task management mobile UI (Flutter)
  - [ ] 27.1 Create task creation screen (Kepala Cabang)
    - Create form with title, description, assignee selector, due date picker, priority selector
    - Implement assignee selection from branch employees
    - Display creation confirmation
    - _Requirements: 11.1_
  
  - [ ] 27.2 Create task list screen (Employee)
    - Display all tasks assigned to current user
    - Implement sorting by priority and due date
    - Implement status filters (pending, in-progress, completed)
    - Display overdue indicator for late tasks
    - _Requirements: 11.3, 11.9_
  
  - [ ] 27.3 Create task detail and update screen
    - Display task details (title, description, due date, priority, creator)
    - Implement status update buttons (start, complete)
    - Implement completion proof upload (photo/document)
    - _Requirements: 11.4, 11.7_
  
  - [ ] 27.4 Implement offline task management
    - Allow viewing assigned tasks offline
    - Allow marking tasks as completed offline
    - Sync status updates when connection restored
    - _Requirements: 19.5, 19.6_

### Phase 12: Delivery Schedule Management

- [ ] 28. Implement delivery schedule backend service
  - [ ] 28.1 Create delivery schedule creation service
    - Implement POST /api/deliveries endpoint
    - Record customer_name, customer_address, customer_phone, items, scheduled_time, driver_id, branch_id
    - Set initial status as "Pending"
    - Send WhatsApp notification to assigned Driver
    - _Requirements: 12.1, 12.2_
  
  - [ ] 28.2 Create delivery update service
    - Implement PUT /api/deliveries/:id/status endpoint
    - Allow Driver to update status (InProgress, Completed, Failed, Rescheduled)
    - Require completion_photo_url when marking as Completed
    - Allow adding notes for failed or rescheduled deliveries
    - Record completed_at timestamp
    - _Requirements: 12.6, 12.7, 12.8_
  
  - [ ] 28.3 Create delivery query endpoints
    - Create GET /api/deliveries endpoint with filtering by driver, branch, date, status
    - Create GET /api/deliveries/:id endpoint for delivery details
    - Create GET /api/deliveries/performance endpoint for metrics calculation
    - _Requirements: 12.3, 12.9, 12.10_
  
  - [ ] 28.4 Implement route optimization service
    - Create GET /api/deliveries/route-optimization endpoint
    - Calculate optimal delivery order based on GPS coordinates
    - Return suggested route with estimated travel times
    - _Requirements: 12.4_

- [ ] 29. Implement delivery schedule mobile UI (Flutter)
  - [ ] 29.1 Create delivery list screen (Driver)
    - Display today's deliveries ordered by scheduled time
    - Implement status indicators with color coding
    - Display customer name, address, and items
    - Implement filter by status
    - _Requirements: 12.3_
  
  - [ ] 29.2 Create delivery detail and update screen
    - Display full delivery details
    - Implement navigation button to open maps app with customer address
    - Implement status update buttons
    - Implement photo capture for completion proof
    - Implement notes input for failed/rescheduled deliveries
    - _Requirements: 12.5, 12.6, 12.8_
  
  - [ ] 29.3 Create delivery creation screen (Kepala Cabang)
    - Create form with customer details, items, scheduled time, driver selector
    - Implement driver selection from branch drivers
    - Display creation confirmation
    - _Requirements: 12.1_
  
  - [ ] 29.4 Create delivery performance screen
    - Display delivery statistics (completion rate, average time)
    - Show delivery history with filters
    - _Requirements: 12.9, 12.10_

- [ ] 30. Checkpoint - HRIS and delivery management complete
  - Test attendance, work reports, tasks, and deliveries end-to-end
  - Verify offline functionality works
  - Verify notifications sent correctly
  - Ensure all tests pass, ask the user if questions arise


### Phase 13: CRM - Prospect Management

- [ ] 31. Implement prospect management backend service
  - [ ] 31.1 Create prospect CRUD service
    - Implement POST /api/prospects endpoint to create new prospect
    - Validate phone number uniqueness before creation
    - Assign unique prospect ID
    - Record name, phone, email, product_interest, source, status, notes
    - Set initial status as "New"
    - _Requirements: 13.1, 13.2, 13.9_
  
  - [ ]* 31.2 Write property test for prospect unique ID assignment
    - **Property 18: Prospect Unique ID Assignment**
    - **Validates: Requirements 13.2**
    - Create multiple prospects, verify all IDs are unique
  
  - [ ]* 31.3 Write property test for duplicate prospect prevention
    - **Property 19: Duplicate Prospect Prevention by Phone**
    - **Validates: Requirements 13.9**
    - Attempt to create prospect with existing phone number, verify rejection
  
  - [ ] 31.4 Implement prospect update service
    - Implement PUT /api/prospects/:id endpoint
    - Allow updating status, notes, follow_up_date
    - Record status change timestamp
    - Create Audit_Log entry for status changes
    - _Requirements: 13.3, 13.4_
  
  - [ ] 31.5 Create prospect query endpoints
    - Create GET /api/prospects endpoint with filtering by status, product_interest, sales_id
    - Create GET /api/prospects/:id endpoint for prospect details
    - Create GET /api/prospects/funnel endpoint for conversion statistics
    - Implement pagination (max 50 items per page)
    - _Requirements: 13.3, 13.8, 23.5_
  
  - [ ] 31.6 Implement follow-up reminder service
    - Create background job to check for due follow-ups
    - Send notification to Sales when follow_up_date is reached
    - _Requirements: 13.6, 13.7, 16.7_

- [ ] 32. Implement prospect management mobile UI (Flutter)
  - [ ] 32.1 Create prospect creation screen
    - Create form with name, phone, email, product interest selector, source input
    - Implement phone number validation
    - Display error if duplicate phone number
    - Display creation confirmation
    - _Requirements: 13.1, 13.9_
  
  - [ ] 32.2 Create prospect list screen
    - Display all prospects assigned to current Sales
    - Implement filter by status
    - Implement search by name or phone
    - Display status indicators with color coding
    - _Requirements: 13.3_
  
  - [ ] 32.3 Create prospect detail and update screen
    - Display full prospect details
    - Implement status update dropdown
    - Implement notes input with history
    - Implement follow-up date picker
    - Display interaction history
    - _Requirements: 13.3, 13.4, 13.5, 13.6_
  
  - [ ] 32.4 Implement offline prospect management
    - Allow creating prospects offline
    - Allow updating prospect data offline
    - Sync changes when connection restored
    - _Requirements: 13.10, 19.10_
  
  - [ ] 32.5 Create prospect funnel visualization screen
    - Display conversion funnel with counts for each status
    - Implement pie chart or funnel chart
    - Display conversion rate percentage
    - _Requirements: 13.8_

### Phase 14: WhatsApp Bulk Messaging

- [ ] 33. Implement WhatsApp bulk messaging backend service
  - [ ] 33.1 Create campaign creation service
    - Implement POST /api/whatsapp/campaigns endpoint
    - Validate recipient list is non-empty
    - Validate all phone numbers are valid format
    - Validate message content is non-empty
    - Record campaign details with initial status "Draft"
    - _Requirements: 14.1_
  
  - [ ]* 33.2 Write property test for campaign validation
    - **Property 21: Campaign Validation Correctness**
    - **Validates: Requirements 14.1**
    - Generate campaigns with invalid data (empty recipients, invalid phones, empty message), verify rejection
  
  - [ ] 33.3 Implement message queue and rate limiting service
    - Create Redis queue for WhatsApp messages
    - Implement rate limiter (20 messages per minute)
    - Queue messages when campaign is started
    - Process queue with rate limiting enforcement
    - _Requirements: 14.2, 14.3_
  
  - [ ]* 33.4 Write property test for WhatsApp rate limiting
    - **Property 22: WhatsApp Rate Limiting Enforcement**
    - **Validates: Requirements 14.2**
    - Queue more than 20 messages, verify only 20 sent per minute
  
  - [ ] 33.5 Implement message personalization service
    - Create function to substitute placeholders in message template
    - Replace {{name}} with prospect name
    - Replace {{product}} with product interest
    - _Requirements: 14.4_
  
  - [ ]* 33.6 Write property test for message personalization
    - **Property 23: Message Personalization Correctness**
    - **Validates: Requirements 14.4**
    - Generate random prospects and templates, verify placeholders correctly substituted
  
  - [ ] 33.7 Implement message sending and retry logic
    - Integrate with WhatsApp_Gateway API
    - Track message status (Queued, Sent, Delivered, Read, Failed)
    - Implement retry logic with exponential backoff (1s, 2s, 4s)
    - Mark as permanently failed after 3 retries
    - Update campaign statistics in real-time
    - _Requirements: 14.5, 14.6_
  
  - [ ]* 33.8 Write property test for message retry logic
    - **Property 24: Message Retry Logic with Exponential Backoff**
    - **Validates: Requirements 14.6**
    - Simulate failed sends, verify retry attempts with correct delays
  
  - [ ] 33.9 Implement duplicate message prevention
    - Check if message sent to prospect within last 24 hours
    - Reject new message if within 24-hour window
    - _Requirements: 14.10_
  
  - [ ]* 33.10 Write property test for duplicate message prevention
    - **Property 26: Duplicate Message Prevention Within Time Window**
    - **Validates: Requirements 14.10**
    - Attempt to send multiple messages to same prospect within 24 hours, verify only first is sent
  
  - [ ] 33.11 Create campaign query endpoints
    - Create GET /api/whatsapp/campaigns endpoint with filtering by status, date range
    - Create GET /api/whatsapp/campaigns/:id endpoint for campaign details
    - Create GET /api/whatsapp/campaigns/:id/statistics endpoint for delivery stats
    - _Requirements: 14.7, 14.8_
  
  - [ ]* 33.12 Write property test for campaign statistics calculation
    - **Property 25: Campaign Statistics Calculation**
    - **Validates: Requirements 14.7, 14.8**
    - Generate campaign with messages in different statuses, verify statistics calculated correctly

- [ ] 34. Implement WhatsApp bulk messaging mobile UI (Flutter)
  - [ ] 34.1 Create campaign creation screen
    - Create form with campaign name, message template, recipient selection
    - Implement recipient selection (all prospects, by status, by product interest, custom list)
    - Display recipient count preview
    - Implement message template editor with placeholder hints
    - Display validation errors
    - _Requirements: 14.1, 14.4_
  
  - [ ] 34.2 Create campaign list screen
    - Display all campaigns with status indicators
    - Implement filter by status
    - Display basic statistics (sent, delivered, read counts)
    - _Requirements: 14.7_
  
  - [ ] 34.3 Create campaign detail and statistics screen
    - Display full campaign details
    - Display real-time delivery statistics with progress bars
    - Display message list with individual statuses
    - Implement campaign scheduling for future execution
    - _Requirements: 14.7, 14.8, 14.9_

### Phase 15: WhatsApp AI Chatbot Integration

- [ ] 35. Implement WhatsApp AI chatbot backend integration
  - [ ] 35.1 Create WhatsApp webhook handler
    - Implement POST /api/whatsapp/webhook endpoint to receive incoming messages
    - Forward messages to N8N_Service for AI processing
    - Handle webhook authentication and validation
    - _Requirements: 15.1_
  
  - [ ] 35.2 Integrate with N8N workflow automation
    - Set up N8N workflow for AI chatbot conversation handling
    - Configure AI model for Indonesian language support
    - Implement intent recognition for common questions (product inquiries, business hours)
    - Implement context management for multi-turn conversations
    - _Requirements: 15.2, 15.5, 15.7, 15.10_
  
  - [ ] 35.3 Implement chatbot response routing
    - Route AI-generated responses back to WhatsApp_Gateway
    - Route unhandled queries to human Sales representatives
    - Create notification for Sales when human intervention needed
    - _Requirements: 15.3, 15.4_
  
  - [ ] 35.4 Implement automatic prospect creation from chatbot
    - Extract contact information from chatbot conversations
    - Automatically create Prospect record when customer provides details
    - Link chatbot conversation to prospect record
    - _Requirements: 15.6_
  
  - [ ] 35.5 Create chatbot interaction logging service
    - Log all chatbot interactions to database
    - Store conversation history with timestamps
    - Track AI response quality metrics
    - _Requirements: 15.9_

- [ ] 36. Implement chatbot management mobile UI (Flutter)
  - [ ] 36.1 Create chatbot conversation monitoring screen (Sales/Kepala Cabang)
    - Display active chatbot conversations
    - Show conversation history for each customer
    - Implement takeover button to switch from AI to human
    - Display AI confidence scores
    - _Requirements: 15.4_
  
  - [ ] 36.2 Create chatbot analytics screen
    - Display chatbot usage statistics
    - Show common questions and response accuracy
    - Display conversion rate from chatbot to prospect
    - _Requirements: 15.9_

### Phase 16: Notification and Reminder System

- [ ] 37. Implement notification service backend
  - [ ] 37.1 Create notification queue service
    - Implement Redis-based notification queue
    - Create notification types (task reminder, attendance reminder, stock alert, etc.)
    - Implement priority-based queue processing
    - _Requirements: 16.1, 16.2, 16.3, 16.4, 16.5, 16.6, 16.7_
  
  - [ ] 37.2 Implement scheduled notification jobs
    - Create hourly job to check overdue tasks
    - Create daily job to check attendance at 9 AM
    - Create job to check pending work report approvals (24-hour threshold)
    - Create job to check stock levels for alerts
    - Create daily summary job at end of business day
    - Create weekly summary job every Monday morning
    - _Requirements: 16.1, 16.2, 16.3, 16.4, 16.5, 16.6, 16.7, 16.8_
  
  - [ ] 37.3 Implement WhatsApp notification sender
    - Integrate with WhatsApp_Gateway for sending notifications
    - Format notifications with appropriate templates
    - Track notification delivery status
    - _Requirements: 11.2, 12.2, 16.1-16.8_
  
  - [ ] 37.4 Implement quiet hours and notification preferences
    - Respect quiet hours (10 PM - 7 AM)
    - Queue notifications during quiet hours for next business hour
    - Store user notification preferences in database
    - Allow users to configure notification types and frequency
    - _Requirements: 16.9, 16.10_

- [ ] 38. Implement notification preferences mobile UI (Flutter)
  - [ ] 38.1 Create notification settings screen
    - Display toggle switches for each notification type
    - Implement quiet hours configuration
    - Implement notification frequency settings
    - Save preferences to backend
    - _Requirements: 16.9_
  
  - [ ] 38.2 Implement push notification handling
    - Configure Firebase Cloud Messaging (FCM) for push notifications
    - Handle notification reception when app is in background
    - Implement notification tap handling to navigate to relevant screen
    - Display notification badge counts
    - _Requirements: 21.8_

### Phase 17: Social Media Dashboard

- [ ] 39. Implement social media integration backend service
  - [ ] 39.1 Create Meta API integration
    - Implement OAuth2 authentication for Meta (Facebook/Instagram)
    - Create service to fetch follower counts from Instagram and Facebook
    - Create service to fetch engagement metrics (likes, comments, shares)
    - Create service to fetch reach and impressions
    - Create service to fetch ad campaign performance
    - _Requirements: 17.2, 17.5, 17.6, 17.7_
  
  - [ ] 39.2 Create TikTok API integration
    - Implement OAuth2 authentication for TikTok
    - Create service to fetch follower counts from TikTok
    - Create service to fetch engagement metrics
    - Create service to fetch video views and reach
    - _Requirements: 17.3, 17.5, 17.6_
  
  - [ ] 39.3 Implement social media data aggregation service
    - Aggregate metrics from all platforms for Owner dashboard
    - Calculate growth trends (daily, weekly, monthly)
    - Identify top-performing posts across platforms
    - Store historical data for trend analysis
    - Implement scheduled data refresh every 6 hours
    - _Requirements: 17.1, 17.4, 17.8, 17.10_
  
  - [ ] 39.4 Create social media API endpoints
    - Create GET /api/social-media/dashboard endpoint for aggregated metrics
    - Create GET /api/social-media/trends endpoint for growth trends
    - Create GET /api/social-media/top-posts endpoint
    - Create GET /api/social-media/branch-comparison endpoint
    - Restrict to Owner and Kepala_Cabang roles
    - _Requirements: 17.1, 17.4, 17.9_

- [ ] 40. Implement social media dashboard mobile UI (Flutter)
  - [ ] 40.1 Create social media dashboard screen
    - Display follower counts for each platform with growth indicators
    - Implement follower growth trend charts (daily, weekly, monthly)
    - Display engagement metrics with visualizations
    - Display reach and impressions statistics
    - Display ad campaign performance metrics
    - _Requirements: 17.1, 17.4, 17.5, 17.6, 17.7_
  
  - [ ] 40.2 Create branch comparison screen
    - Display side-by-side comparison of social media performance across branches
    - Implement filter by platform
    - Implement date range selector
    - _Requirements: 17.9_
  
  - [ ] 40.3 Create top posts screen
    - Display top-performing posts for each platform
    - Show engagement metrics for each post
    - Implement filter by platform and date range
    - _Requirements: 17.10_

### Phase 18: Audit Log and Transparency

- [ ] 41. Implement audit log backend service
  - [ ] 41.1 Create audit log recording service
    - Implement function to create Audit_Log entries for all critical operations
    - Record user_id, timestamp, action type, entity type, entity_id, old_value, new_value
    - Record IP address and user agent
    - Ensure audit logs are immutable (no update or delete operations)
    - _Requirements: 18.1, 18.2, 18.3_
  
  - [ ]* 41.2 Write property test for audit log creation
    - **Property 9: Audit Log Creation for All Transactions**
    - **Validates: Requirements 7.5, 18.1, 18.2**
    - Perform various operations (stock transaction, attendance, task creation), verify audit log created for each
  
  - [ ]* 41.3 Write property test for audit log immutability
    - **Property 27: Audit Log Immutability**
    - **Validates: Requirements 18.3**
    - Attempt to modify or delete audit log entries, verify operations rejected
  
  - [ ] 41.4 Create audit log query service
    - Implement filtering by date range, user, action type, entity type
    - Implement search by entity ID or user name
    - Implement pagination for large result sets
    - _Requirements: 18.4, 18.5_
  
  - [ ]* 41.5 Write property test for audit log filtering
    - **Property 28: Audit Log Filtering Correctness**
    - **Validates: Requirements 18.4, 18.5**
    - Generate audit logs with various attributes, apply filters, verify correct subset returned
  
  - [ ] 41.6 Create audit log API endpoints
    - Create GET /api/audit-logs endpoint with filtering and pagination
    - Create GET /api/audit-logs/:id endpoint for log details
    - Create GET /api/audit-logs/export endpoint for CSV export
    - Restrict to Owner role only
    - _Requirements: 18.4, 18.5, 18.10_
  
  - [ ] 41.7 Implement audit log retention policy
    - Create background job to archive audit logs older than 2 years
    - Move archived logs to separate storage
    - Maintain audit log integrity during archival
    - _Requirements: 18.6_

- [ ] 42. Implement audit log mobile UI (Flutter)
  - [ ] 42.1 Create audit log viewer screen (Owner)
    - Display audit logs in chronological order
    - Implement filters (date range, user, action type)
    - Implement search by entity ID or user name
    - Display before and after values for data changes
    - _Requirements: 18.4, 18.5, 18.7_
  
  - [ ] 42.2 Create audit log detail screen
    - Display full audit log entry details
    - Show old_value and new_value in readable format
    - Display IP address and user agent
    - _Requirements: 18.7_
  
  - [ ] 42.3 Implement audit log export functionality
    - Create export button to generate CSV file
    - Allow selecting date range for export
    - Download CSV file to device
    - _Requirements: 18.10_

### Phase 19: Employee Performance Monitoring and Ranking

- [ ] 43. Implement employee performance metrics backend service
  - [ ] 43.1 Create Employee_Performance_Metric table migration
    - Write SQL migration for Employee_Performance_Metric table
    - Add indexes on user_id, branch_id, metric_date, role
    - Add indexes on rank fields for efficient ranking queries
    - _Requirements: 24.1, 24.2, 24.3, 24.4_
  
  - [ ] 43.2 Create performance calculation service for Sales employees
    - Implement function to calculate prospects_converted (count of prospects with status "Closed")
    - Implement function to calculate revenue_generated from closed prospects
    - Implement function to calculate conversion_rate (closed / total prospects)
    - Implement function to calculate overall_score for Sales (weighted: 40% conversion rate, 40% revenue, 20% prospect count)
    - _Requirements: 24.1_
  
  - [ ] 43.3 Create performance calculation service for non-Sales employees
    - Implement function to calculate task_completion_rate (completed tasks / assigned tasks)
    - Implement function to calculate attendance_rate (attendance days / working days)
    - Implement function to calculate punctuality_score (100 - (late_count / attendance_days * 100))
    - Implement function to calculate work_report_quality_score (approved reports / submitted reports)
    - Implement function to calculate overall_score for non-Sales (weighted: 40% task completion, 30% attendance, 20% punctuality, 10% work report quality)
    - _Requirements: 24.2_
  
  - [ ]* 43.4 Write property test for performance metric calculation
    - **Property 35: Performance Metric Aggregation Accuracy**
    - **Validates: Requirements 24.1, 24.2**
    - Generate random employee activities, verify calculated metrics match expected ratios
  
  - [ ] 43.5 Create ranking calculation service
    - Implement function to rank Sales employees by overall_score (descending)
    - Implement function to rank non-Sales employees by overall_score (descending)
    - Assign rank_in_role, rank_in_branch, rank_overall
    - Support filtering by branch
    - _Requirements: 24.3, 24.4, 24.10_
  
  - [ ]* 43.6 Write property test for ranking calculation
    - **Property 34: Performance Ranking Calculation Correctness**
    - **Validates: Requirements 24.3, 24.4**
    - Generate random employee scores, verify ranking order is correct with rank 1 for highest score
  
  - [ ] 43.7 Create performance trend analysis service
    - Implement function to compare current period metrics with previous period
    - Calculate trend (Improving if score increased >5%, Declining if decreased >5%, Stable otherwise)
    - Store trend in Employee_Performance_Metric table
    - _Requirements: 24.11_
  
  - [ ] 43.8 Create scheduled job for daily performance calculation
    - Create background job that runs daily at midnight
    - Calculate performance metrics for all employees
    - Calculate rankings for all roles
    - Calculate performance trends
    - Store results in Employee_Performance_Metric table
    - _Requirements: 24.13_
  
  - [ ] 43.9 Create performance query API endpoints
    - Create GET /api/performance/rankings/sales endpoint with filters (time period, branch, limit)
    - Create GET /api/performance/rankings/non-sales endpoint with filters
    - Create GET /api/performance/employee/:id endpoint for individual employee details
    - Create GET /api/performance/trends endpoint for trend analysis
    - Restrict all endpoints to Owner role
    - _Requirements: 24.5, 24.6, 24.7, 24.8, 24.9, 24.10, 24.11, 24.12_

- [ ] 44. Implement employee performance monitoring mobile UI (Flutter)
  - [ ] 44.1 Create performance rankings screen
    - Create tabbed interface (Sales / Non-Sales)
    - Display top 10 performers with metrics in ranked list
    - Display bottom 5 performers with metrics in separate section
    - Implement color coding (green for top, red for bottom, yellow for middle)
    - Display performance trend indicators (↑ improving, ↓ declining, → stable)
    - _Requirements: 24.5, 24.6, 24.7, 24.8, 24.11_
  
  - [ ] 44.2 Create performance filters
    - Implement time period filter (daily, weekly, monthly, quarterly, yearly)
    - Implement branch filter (all branches or specific branch)
    - Update rankings when filters change
    - _Requirements: 24.9, 24.10_
  
  - [ ] 44.3 Create individual employee performance detail screen
    - Display employee name, role, branch
    - Display all performance metrics with labels
    - Display overall score with visual gauge
    - Display rank (in role, in branch, overall)
    - Display performance trend chart (line chart showing score over time)
    - Display comparison with average performer
    - _Requirements: 24.12_
  
  - [ ] 44.4 Create performance comparison charts
    - Implement bar chart comparing top 10 performers
    - Implement line chart showing performance trends over time
    - Implement pie chart showing distribution of performance levels (top 20%, middle 60%, bottom 20%)
    - _Requirements: 24.14_
  
  - [ ] 44.5 Implement performance report export
    - Create export button to generate PDF report
    - Include rankings, metrics, and charts in PDF
    - Allow selecting time period and branch for export
    - Download PDF to device
    - _Requirements: 24.15_

- [ ] 45. Checkpoint - Employee performance monitoring complete
  - Test performance calculation for Sales employees
  - Test performance calculation for non-Sales employees
  - Test ranking calculation and ordering
  - Test trend analysis
  - Test filtering by time period and branch
  - Verify daily scheduled job runs correctly
  - Ensure all tests pass, ask the user if questions arise


### Phase 20: Internal Chat and Memo

- [ ] 46. Implement internal chat backend service
  - [ ] 43.1 Create chat message service
    - Implement POST /api/chat/messages endpoint for sending messages
    - Support one-on-one chat between employees
    - Support group chats for branch teams
    - Support broadcast messages from Kepala_Cabang to branch employees
    - Store messages in database with encryption
    - _Requirements: 21.1, 21.2, 21.3, 21.4, 21.6_
  
  - [ ]* 43.2 Write property test for chat message delivery
    - **Property 29: Chat Message Delivery to Correct Recipient**
    - **Validates: Requirements 21.1, 21.2**
    - Send one-on-one messages, verify delivered only to specified recipient and sender
  
  - [ ] 43.3 Implement real-time message delivery
    - Set up WebSocket connection for real-time messaging
    - Implement message push to online recipients
    - Store messages for offline recipients for later delivery
    - Update message read status when recipient views message
    - _Requirements: 21.1, 21.7_
  
  - [ ] 43.4 Implement chat file sharing
    - Support sending photos and documents in chats
    - Store files in Object_Storage
    - Generate signed URLs for file access
    - _Requirements: 21.5_
  
  - [ ] 43.5 Create chat query endpoints
    - Create GET /api/chat/conversations endpoint to list user's conversations
    - Create GET /api/chat/messages/:conversation_id endpoint for message history
    - Create GET /api/chat/unread-count endpoint for unread message count
    - Implement search in chat history by keyword
    - _Requirements: 21.7, 21.9_
  
  - [ ] 43.6 Implement chat message retention policy
    - Create background job to delete messages older than 90 days
    - Maintain compliance with retention policy
    - _Requirements: 21.10_

- [ ] 47. Implement internal chat mobile UI (Flutter)
  - [ ] 44.1 Create chat conversation list screen
    - Display all conversations with last message preview
    - Display unread message count badge
    - Implement search for conversations
    - Display online/offline status indicators
    - _Requirements: 21.2, 21.7_
  
  - [ ] 44.2 Create chat message screen
    - Display message history in chronological order
    - Implement real-time message updates
    - Implement message input with send button
    - Support sending text, photos, and documents
    - Display message read status (sent, delivered, read)
    - _Requirements: 21.1, 21.5_
  
  - [ ] 44.3 Create group chat and broadcast screens
    - Implement group chat creation with member selection
    - Implement broadcast message screen for Kepala_Cabang
    - Display group member list
    - _Requirements: 21.3, 21.4_
  
  - [ ] 44.4 Implement push notifications for new messages
    - Send push notification when new message received and app in background
    - Display notification with sender name and message preview
    - Navigate to chat screen when notification tapped
    - _Requirements: 21.8_
  
  - [ ] 44.5 Implement chat search functionality
    - Create search screen for finding messages by keyword
    - Display search results with context
    - Navigate to message in conversation when result tapped
    - _Requirements: 21.9_

- [ ] 48. Checkpoint - Communication features complete
  - Test WhatsApp bulk messaging end-to-end
  - Test AI chatbot integration
  - Test notification system
  - Test internal chat functionality
  - Ensure all tests pass, ask the user if questions arise


### Phase 21: Automated Reporting

- [ ] 49. Implement automated reporting backend service
  - [ ] 49.1 Create daily performance report generator
    - Implement function to generate daily report at 6 PM
    - Include total sales, attendance summary, pending tasks, low stock alerts for all branches
    - Format report as PDF with charts and visualizations
    - Store generated report in Object_Storage
    - Send report to Owner via WhatsApp
    - _Requirements: 20.1, 20.2, 20.5, 20.6, 20.9_
  
  - [ ] 49.2 Create weekly performance report generator
    - Implement function to generate weekly report every Monday at 8 AM
    - Include sales trends, top-performing branches, employee performance summary, inventory status
    - Format report as PDF with charts and visualizations
    - Store generated report in Object_Storage
    - Send report to Owner via WhatsApp
    - _Requirements: 20.3, 20.4, 20.5, 20.6, 20.9_
  
  - [ ] 49.3 Implement report scheduling service
    - Create scheduled jobs for daily and weekly reports
    - Implement configurable report frequency and content
    - Store report generation history
    - _Requirements: 20.1, 20.3, 20.10_
  
  - [ ] 49.4 Create report query endpoints
    - Create GET /api/reports/history endpoint to list generated reports
    - Create GET /api/reports/:id/download endpoint to download report PDF
    - Implement filtering by report type and date range
    - Restrict to Owner role
    - _Requirements: 20.7, 20.8_

- [ ] 50. Implement automated reporting mobile UI (Flutter)
  - [ ] 50.1 Create report history screen (Owner)
    - Display list of generated reports with date and type
    - Implement filter by report type (daily, weekly)
    - Implement date range filter
    - Display download button for each report
    - _Requirements: 20.8_
  
  - [ ] 50.2 Create report configuration screen (Owner)
    - Allow configuring report frequency
    - Allow selecting report content preferences
    - Save configuration to backend
    - _Requirements: 20.10_
  
  - [ ] 50.3 Implement report viewer
    - Display PDF reports within the app
    - Implement zoom and scroll functionality
    - Allow sharing reports via WhatsApp or email
    - _Requirements: 20.7_

### Phase 22: Data Security and Encryption

- [ ] 51. Implement data security measures
  - [ ] 48.1 Implement password encryption
    - Ensure all passwords encrypted with bcrypt (12 rounds minimum)
    - Implement password strength validation
    - _Requirements: 22.1_
  
  - [ ]* 48.2 Write property test for password encryption
    - **Property 30: Password Encryption with Bcrypt**
    - **Validates: Requirements 22.1**
    - Create users with passwords, verify stored as bcrypt hash with 12+ rounds, original not stored
  
  - [ ] 48.3 Implement JWT token security
    - Ensure JWT tokens signed with strong secret key
    - Implement token signature validation on every request
    - Implement token expiration checking
    - _Requirements: 22.2_
  
  - [ ]* 48.4 Write property test for JWT signature validation
    - **Property 31: JWT Signature Validation**
    - **Validates: Requirements 22.2**
    - Generate tokens with invalid signatures or expired timestamps, verify rejection
  
  - [ ] 48.5 Implement database field encryption
    - Encrypt sensitive fields (phone numbers, addresses, financial data) at rest
    - Implement encryption/decryption middleware
    - Use AES-256 encryption
    - _Requirements: 22.3_
  
  - [ ] 48.6 Implement HTTPS/TLS for API communications
    - Configure TLS certificates for backend API
    - Enforce HTTPS for all API endpoints
    - Implement certificate validation in mobile app
    - _Requirements: 22.4_
  
  - [ ] 48.7 Implement CORS policy
    - Configure CORS to restrict API access to authorized domains
    - Implement preflight request handling
    - _Requirements: 22.7_
  
  - [ ] 48.8 Implement signed URLs for file access
    - Generate signed URLs with expiration for Object_Storage files
    - Validate signatures before serving files
    - Set appropriate expiration times (1 hour for sensitive files)
    - _Requirements: 22.8_
  
  - [ ] 48.9 Implement security event logging
    - Log all failed login attempts
    - Log all permission denials
    - Log suspicious activities (multiple failed attempts, unusual access patterns)
    - Store security logs separately from audit logs
    - _Requirements: 22.9_

### Phase 23: Performance Optimization and Caching

- [ ] 52. Implement caching strategy
  - [ ] 52.1 Implement Redis caching for dashboard metrics
    - Cache Owner dashboard aggregated metrics (5-minute TTL)
    - Cache Kepala_Cabang dashboard metrics (5-minute TTL)
    - Cache frequently accessed reference data (branches, users)
    - Implement cache invalidation on data updates
    - _Requirements: 23.2, 23.9_
  
  - [ ] 52.2 Implement database connection pooling
    - Configure connection pool with minimum 10 and maximum 50 connections
    - Implement connection health checks
    - Implement connection timeout handling
    - _Requirements: 23.3_
  
  - [ ] 52.3 Implement database query optimization
    - Add indexes on frequently queried fields (verified in Phase 1)
    - Implement query result caching for expensive queries
    - Optimize N+1 query problems with eager loading
    - _Requirements: 23.4_
  
  - [ ] 52.4 Implement API pagination
    - Implement pagination for all list endpoints (max 50 items per page)
    - Include total count and page metadata in responses
    - Implement cursor-based pagination for large datasets
    - _Requirements: 23.5_
  
  - [ ] 52.5 Implement API response compression
    - Enable gzip compression for responses larger than 1KB
    - Configure compression level for optimal performance
    - _Requirements: 23.7_
  
  - [ ] 52.6 Implement background job queue
    - Set up Redis-based job queue for heavy operations
    - Implement job workers for report generation, bulk messaging, data aggregation
    - Implement job retry logic and failure handling
    - _Requirements: 23.10_

- [ ] 53. Implement mobile app performance optimization
  - [ ] 53.1 Implement lazy loading in Flutter
    - Implement lazy loading for long lists (inventory, prospects, tasks)
    - Implement infinite scroll with pagination
    - Implement image lazy loading with placeholders
    - _Requirements: 23.6_
  
  - [ ] 53.2 Implement image compression
    - Compress images before upload (max 1MB per image)
    - Implement image quality adjustment based on network speed
    - Generate thumbnails for image galleries
    - _Requirements: 23.6_
  
  - [ ] 53.3 Optimize offline data storage
    - Implement efficient SQLite schema for local cache
    - Implement data pruning for old cached data
    - Optimize sync queries to minimize data transfer
    - _Requirements: 19.2, 19.8_

### Phase 24: Offline-First Capability

- [ ] 54. Implement offline sync service
  - [ ] 54.1 Create sync queue management
    - Implement local SQLite database for offline data storage
    - Create sync queue for pending operations
    - Implement operation prioritization (critical operations first)
    - Store operations with timestamps for chronological sync
    - _Requirements: 19.1, 19.8_
  
  - [ ] 54.2 Implement automatic sync on connection restore
    - Detect network connection changes
    - Trigger sync automatically when connection restored
    - Display sync progress to user
    - Handle sync failures gracefully
    - _Requirements: 19.8_
  
  - [ ] 54.3 Implement conflict resolution
    - Detect conflicts when syncing (server data changed since last sync)
    - Implement server-wins strategy for most cases
    - Prompt user for critical data conflicts (e.g., stock transactions)
    - Log all conflict resolutions
    - _Requirements: 19.9_
  
  - [ ] 54.4 Implement incremental sync
    - Track last sync timestamp for each data type
    - Fetch only data changed since last sync
    - Implement delta sync to minimize data transfer
    - _Requirements: 19.8_
  
  - [ ] 54.5 Implement background sync service
    - Create background service for periodic sync (every 15 minutes when online)
    - Implement battery-efficient sync scheduling
    - Respect user's data saver settings
    - _Requirements: 19.8_

- [ ] 55. Implement offline UI indicators
  - [ ] 55.1 Create offline mode indicator
    - Display offline mode banner when no connection
    - Show last sync timestamp
    - Display pending operations count
    - _Requirements: 19.1, 19.10_
  
  - [ ] 55.2 Create sync status indicator
    - Display sync progress during synchronization
    - Show success/failure status after sync
    - Display sync errors with retry option
    - _Requirements: 19.10_

- [ ] 56. Checkpoint - Performance and offline features complete
  - Test caching strategy effectiveness
  - Test offline functionality for all supported features
  - Test sync conflict resolution
  - Verify performance improvements
  - Ensure all tests pass, ask the user if questions arise

### Phase 25: Deployment and Infrastructure

- [ ] 57. Implement containerization
  - [ ] 57.1 Create Docker images
    - Create Dockerfile for Rust backend with multi-stage build
    - Create Dockerfile for PostgreSQL with initialization scripts
    - Create Dockerfile for Redis with configuration
    - Create Dockerfile for N8N workflow automation
    - Optimize image sizes and build times
    - _Requirements: 24.1_
  
  - [ ] 57.2 Create Docker Compose configuration
    - Create docker-compose.yml for local development
    - Configure service dependencies and networking
    - Configure volume mounts for persistent data
    - Configure environment variables
    - _Requirements: 24.2_
  
  - [ ] 57.3 Create Kubernetes/Swarm configuration
    - Create Kubernetes manifests for production deployment
    - Configure service replicas for horizontal scaling
    - Configure load balancer for API gateway
    - Configure persistent volumes for database and Redis
    - Configure secrets management
    - _Requirements: 24.3, 24.8_

- [ ] 58. Implement health checks and monitoring
  - [ ] 58.1 Create health check endpoints
    - Implement GET /health endpoint for liveness check
    - Implement GET /ready endpoint for readiness check
    - Check database connectivity, Redis connectivity, external API availability
    - _Requirements: 24.6_
  
  - [ ] 58.2 Implement Prometheus metrics
    - Expose Prometheus metrics endpoint
    - Track API request latency, error rates, throughput
    - Track database query performance
    - Track cache hit/miss rates
    - Track background job queue length
    - _Requirements: 24.8_
  
  - [ ] 58.3 Set up Grafana dashboards
    - Create dashboard for API performance metrics
    - Create dashboard for database performance
    - Create dashboard for cache performance
    - Create dashboard for business metrics (users, transactions, messages)
    - Configure alerting rules for critical metrics
    - _Requirements: 24.8_

- [ ] 59. Implement backup and disaster recovery
  - [ ] 59.1 Implement automated database backup
    - Create backup script for PostgreSQL
    - Schedule backups every 6 hours
    - Store backups in separate storage location
    - Implement backup retention policy (keep last 30 days)
    - _Requirements: 24.7_
  
  - [ ] 59.2 Implement backup restoration procedure
    - Create restoration script for PostgreSQL
    - Test restoration procedure regularly
    - Document restoration steps
    - _Requirements: 24.10_
  
  - [ ] 59.3 Create disaster recovery plan
    - Document disaster recovery procedures
    - Define Recovery Time Objective (RTO) and Recovery Point Objective (RPO)
    - Test disaster recovery procedures
    - _Requirements: 24.10_

- [ ] 60. Implement zero-downtime deployment
  - [ ] 60.1 Configure rolling updates
    - Implement rolling update strategy for Kubernetes/Swarm
    - Configure health checks for deployment validation
    - Implement automatic rollback on deployment failure
    - _Requirements: 24.9_
  
  - [ ] 60.2 Implement database migration strategy
    - Implement backward-compatible database migrations
    - Test migrations in staging environment before production
    - Implement migration rollback procedures
    - _Requirements: 24.9_

### Phase 26: Testing and Quality Assurance

- [ ] 61. Implement integration tests
  - [ ]* 61.1 Write integration tests for authentication flow
    - Test complete login flow from request to JWT generation
    - Test token validation and refresh
    - Test RBAC enforcement across endpoints
    - _Requirements: 1.1, 1.3, 1.10_
  
  - [ ]* 61.2 Write integration tests for dashboard services
    - Test Owner dashboard aggregation with real database
    - Test Kepala_Cabang dashboard with branch filtering
    - Test caching behavior
    - _Requirements: 2.1, 3.1, 23.2_
  
  - [ ]* 61.3 Write integration tests for inventory management
    - Test stock addition and removal with database transactions
    - Test stock alert generation
    - Test audit log creation
    - _Requirements: 7.1, 7.2, 7.3, 7.5_
  
  - [ ]* 61.4 Write integration tests for HRIS features
    - Test attendance recording with geofence validation
    - Test work report submission and approval workflow
    - Test task creation and assignment
    - Test delivery schedule management
    - _Requirements: 10.1, 10.2, 9.1, 9.6, 11.1, 12.1_
  
  - [ ]* 61.5 Write integration tests for CRM features
    - Test prospect creation with duplicate prevention
    - Test WhatsApp campaign creation and execution
    - Test message rate limiting
    - _Requirements: 13.1, 13.9, 14.1, 14.2_
  
  - [ ]* 61.6 Write integration tests for offline sync
    - Test offline operation queuing
    - Test sync on connection restore
    - Test conflict resolution
    - _Requirements: 19.3, 19.8, 19.9_

- [ ] 62. Implement end-to-end tests for mobile app
  - [ ]* 62.1 Write E2E tests for Owner role
    - Test login as Owner
    - Test dashboard viewing with all branches
    - Test branch detail navigation
    - _Requirements: 1.1, 2.1, 2.7_
  
  - [ ]* 62.2 Write E2E tests for Kepala Cabang role
    - Test login as Kepala_Cabang
    - Test dashboard viewing with branch restriction
    - Test task creation and assignment
    - Test work report approval
    - _Requirements: 1.1, 3.1, 11.1, 9.6_
  
  - [ ]* 62.3 Write E2E tests for Admin role
    - Test login as Admin
    - Test stock addition with photo
    - Test stock removal
    - _Requirements: 1.1, 7.1, 7.2_
  
  - [ ]* 62.4 Write E2E tests for Sales role
    - Test login as Sales
    - Test prospect creation
    - Test WhatsApp campaign creation
    - _Requirements: 1.1, 13.1, 14.1_
  
  - [ ]* 62.5 Write E2E tests for Driver role
    - Test login as Driver
    - Test delivery list viewing
    - Test delivery completion with photo
    - _Requirements: 1.1, 12.3, 12.6_

- [ ] 63. Implement load testing
  - [ ]* 63.1 Create load test scenarios
    - Test API performance under normal load (100 concurrent users)
    - Test API performance under peak load (500 concurrent users)
    - Test database performance under load
    - Test cache effectiveness under load
    - _Requirements: 23.1_
  
  - [ ]* 63.2 Analyze load test results
    - Verify 95th percentile response time under 200ms
    - Identify performance bottlenecks
    - Optimize based on findings
    - _Requirements: 23.1_

- [ ] 64. Final checkpoint - Complete system testing
  - Run all property-based tests
  - Run all integration tests
  - Run all end-to-end tests
  - Run load tests
  - Verify all requirements met
  - Ensure all tests pass, ask the user if questions arise

### Phase 27: Documentation and Deployment

- [ ] 65. Create system documentation
  - [ ] 65.1 Write API documentation
    - Document all API endpoints with request/response examples
    - Document authentication and authorization requirements
    - Document error codes and handling
    - Generate OpenAPI/Swagger specification
  
  - [ ] 65.2 Write deployment documentation
    - Document infrastructure requirements
    - Document deployment procedures for development, staging, production
    - Document environment variable configuration
    - Document backup and restoration procedures
  
  - [ ] 65.3 Write user documentation
    - Create user guide for each role (Owner, Kepala_Cabang, Admin, Sales, Driver)
    - Document mobile app features with screenshots
    - Create troubleshooting guide
    - Create FAQ document
  
  - [ ] 65.4 Write developer documentation
    - Document code architecture and design patterns
    - Document database schema with ER diagrams
    - Document development setup procedures
    - Document testing procedures

- [ ] 66. Prepare for production deployment
  - [ ] 66.1 Set up production environment
    - Provision production servers/cloud resources
    - Configure production database with replication
    - Configure production Redis cluster
    - Configure production object storage
    - Configure SSL/TLS certificates
  
  - [ ] 66.2 Configure production secrets
    - Generate strong JWT secret keys
    - Configure database credentials
    - Configure API keys for external services (Meta, TikTok, WhatsApp)
    - Store secrets securely (e.g., AWS Secrets Manager, HashiCorp Vault)
  
  - [ ] 66.3 Deploy to production
    - Deploy backend services using rolling update strategy
    - Run database migrations
    - Verify health checks pass
    - Monitor deployment for errors
  
  - [ ] 66.4 Deploy mobile app
    - Build production APK for Android
    - Build production IPA for iOS
    - Submit to Google Play Store
    - Submit to Apple App Store
    - Monitor app store review process

- [ ] 67. Post-deployment verification
  - [ ] 67.1 Verify production deployment
    - Test all critical user flows in production
    - Verify all integrations working (WhatsApp, Meta, TikTok)
    - Verify monitoring and alerting configured
    - Verify backups running successfully
  
  - [ ] 67.2 Conduct user acceptance testing
    - Onboard pilot users from each role
    - Gather feedback on usability and performance
    - Address critical issues identified
  
  - [ ] 67.3 Create support procedures
    - Set up support ticketing system
    - Train support team on system features
    - Create escalation procedures for critical issues
    - Set up on-call rotation for production support

- [ ] 68. Final checkpoint - System ready for production use
  - All features implemented and tested
  - All documentation complete
  - Production environment configured and deployed
  - User acceptance testing passed
  - Support procedures in place
  - System is ready for production use!

## Notes

- **Tasks marked with `*` are optional** and can be skipped for faster MVP delivery. However, property-based tests are highly recommended for ensuring correctness.
- **Each task references specific requirements** for traceability back to the requirements document.
- **Checkpoints are included** at reasonable breaks to ensure incremental validation and allow for user feedback.
- **Property tests validate universal correctness properties** defined in the design document, ensuring the system behaves correctly across all valid inputs.
- **Unit tests and integration tests** validate specific examples, edge cases, and end-to-end workflows.
- **The implementation follows an incremental approach**: infrastructure → authentication → role-based features → integrations → testing → deployment.
- **Offline-first capability** is integrated throughout the mobile app implementation to ensure field employees can work with poor or no internet connection.
- **Security measures** are implemented at every layer: authentication, authorization, encryption, input validation, rate limiting, and audit logging.
- **Performance optimization** is built in from the start: caching, connection pooling, pagination, compression, and background jobs.
- **The system is designed for scalability**: horizontal scaling, load balancing, database replication, and zero-downtime deployment.
- **Employee performance monitoring** provides Owner with comprehensive rankings for Sales and non-Sales staff with detailed metrics and trends.

## Implementation Guidance

When implementing these tasks:

1. **Start with infrastructure and core authentication** (Phases 1-2) to establish the foundation.
2. **Implement role-based dashboards** (Phases 3-7) to provide immediate value to each user role.
3. **Build operational features** (Phases 8-12) for inventory, HRIS, and delivery management.
4. **Add CRM and communication features** (Phases 13-16) for customer engagement.
5. **Integrate external services** (Phases 15, 17) for WhatsApp AI chatbot and social media monitoring.
6. **Implement transparency and security** (Phases 18, 22) for audit logging and data protection.
7. **Add employee performance monitoring** (Phase 19) for comprehensive staff evaluation and ranking.
8. **Implement internal communication** (Phase 20) for team collaboration.
9. **Add automated reporting** (Phase 21) for Owner insights.
10. **Optimize performance and offline capability** (Phases 23-24) for production readiness.
11. **Deploy and test** (Phases 25-26) with comprehensive testing and deployment procedures.
12. **Document and launch** (Phase 27) with complete documentation and production deployment.

Each phase builds on the previous phases, ensuring a solid foundation before adding more complex features. The checkpoint tasks ensure that each phase is complete and working before moving to the next phase.
