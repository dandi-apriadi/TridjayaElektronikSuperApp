# Implementation Plan: Sistem ERP Tridjaya

## Overview

This implementation plan follows a **Mobile-First Development** approach where the Flutter mobile application is built first with dummy data for rapid prototyping and UI/UX validation. Only the authentication (login) feature will be integrated with the backend API initially. After the mobile app design is approved, backend implementation will proceed to replace dummy data with real API endpoints.

**Development Phases:**
- **Phase A (Current):** Flutter Mobile App with dummy data + real Auth API only
- **Phase B (After Approval):** Backend API implementation to replace dummy data

> ⚠️ **Phase B tasks will not begin until the user explicitly approves the Flutter UI in Phase A.**

---

## PHASE A — Flutter Mobile App (Mobile-First)

### Phase 1: Flutter Project Setup

- [ ] 1. Set up Flutter project and development environment
  - Create Flutter project with proper folder structure (features, shared, core)
  - Set up state management (Riverpod or BLoC)
  - Configure routing (GoRouter)
  - Set up dependency injection
  - Add core packages: dio, flutter_secure_storage, cached_network_image, fl_chart, intl
  - Set up dummy data layer (local JSON / hardcoded models)
  - Configure environment variables for API base URL
  - _Requirements: 24.1, 24.2_

- [ ] 2. Implement real Authentication with backend API
  - [ ] 2.1 Create login screen UI
    - Design professional login screen with branding
    - Implement email/username and password input fields with validation
    - Implement "Login" button with loading state
    - Display error messages for invalid credentials
    - _Requirements: 1.1, 1.2_
  
  - [ ] 2.2 Integrate Auth API (ONLY real API in Phase A)
    - Call POST /api/auth/login endpoint with credentials
    - Parse JWT token from response
    - Store JWT and user role securely in flutter_secure_storage
    - Extract role (Owner, Kepala_Cabang, Admin, Sales, Driver) from JWT claims
    - Redirect to role-specific dashboard after successful login
    - Handle 401 Unauthorized and show appropriate error
    - _Requirements: 1.1, 1.2, 1.3, 22.1, 22.2_
  
  - [ ] 2.3 Implement session management
    - Auto-login if valid token exists in secure storage
    - Implement logout (clear token from storage)
    - Implement token expiry detection and redirect to login
    - _Requirements: 1.10_

- [ ] 3. Checkpoint - Login & Setup complete
  - Login screen renders correctly
  - Login with real API works for all 5 roles
  - JWT stored and parsed correctly
  - Each role redirects to its respective dashboard
  - Ask the user if questions arise

---

### Phase 2: Owner Dashboard UI (Dummy Data)

- [ ] 4. Implement Owner dashboard screen with dummy data
  - [ ] 4.1 Create Owner dashboard screen layout
    - Design dashboard with role header and branch selector
    - Implement aggregated metrics cards (Inventory, Sales, Attendance, Tasks)
    - Implement low stock alerts list widget
    - Implement employee performance rankings widget with tabs (Sales / Non-Sales)
    - All data sourced from local dummy data provider
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.10, 2.11_
  
  - [ ] 4.2 Create dummy data for Owner dashboard
    - Define DummyOwnerDashboard model with sample metrics
    - Define DummyBranch list (e.g., Cabang Pusat, Cabang Selatan)
    - Define DummyInventorySummary per branch
    - Define DummySalesData with daily/weekly/monthly breakdown
    - Define DummyAttendanceSummary per branch
    - Define DummyPerformanceRanking (top 10, bottom 5 per category)
  
  - [ ] 4.3 Implement branch detail navigation
    - Create branch selector dropdown
    - Create branch detail screen with branch-specific dummy metrics
    - Implement navigation from dashboard to branch details
    - _Requirements: 2.7_
  
  - [ ] 4.4 Implement employee performance ranking screen
    - Display top 10 / bottom 5 for Sales and non-Sales
    - Implement filter by time period (daily, weekly, monthly)
    - Implement filter by branch
    - Display performance trend indicators (↑ improving, ↓ declining, → stable)
    - Drill-down to individual employee detail screen
    - All data from dummy data provider
    - _Requirements: 2.10, 2.11, 24.5–24.12_

---

### Phase 3: Kepala Cabang Dashboard UI (Dummy Data)

- [ ] 5. Implement Kepala Cabang dashboard screen with dummy data
  - [ ] 5.1 Create Kepala Cabang dashboard layout
    - Design branch-focused dashboard
    - Implement inventory levels widget (Aki, TV, HP for the branch)
    - Implement today's attendance widget (employee list with status)
    - Implement pending tasks widget
    - Implement delivery schedule widget
    - Implement low stock alerts widget
    - Implement daily sales summary widget
    - Implement pending work reports widget
    - All data from dummy data provider
    - _Requirements: 3.1–3.8_
  
  - [ ] 5.2 Create dummy data for Kepala Cabang dashboard
    - Define DummyBranchInventory with sample stock levels
    - Define DummyAttendanceList with employee check-in statuses
    - Define DummyTaskList with priorities and statuses
    - Define DummyDeliverySchedule for today
    - Define DummyWorkReportPending list

---

### Phase 4: Admin Dashboard UI (Dummy Data)

- [ ] 6. Implement Admin dashboard screen with dummy data
  - [ ] 6.1 Create Admin dashboard layout
    - Design inventory-focused dashboard
    - Implement current stock levels widget
    - Implement recent stock movements widget (today)
    - Implement low stock alerts widget
    - Implement quick-access buttons to stock entry forms
    - Implement pending tasks widget
    - Implement recent audit log widget
    - All data from dummy data provider
    - _Requirements: 4.1–4.7_
  
  - [ ] 6.2 Create stock input form screens (UI only)
    - Create stock addition form (item selection, quantity, reason, photo)
    - Create stock removal form (item selection, quantity, reason, photo)
    - Implement form validation (UI only, no API call)
    - Implement barcode scanner placeholder UI
    - Implement photo picker UI
    - _Requirements: 7.1, 7.2, 7.6, 7.7_
  
  - [ ] 6.3 Create inventory list and detail screens
    - Create inventory list screen with search and filter by category
    - Create item detail screen (stock level, threshold, transaction history)
    - Implement low stock alert indicator badges
    - All data from dummy data provider
    - _Requirements: 7.3, 7.4_
  
  - [ ] 6.4 Create dummy data for Admin dashboard
    - Define DummyInventoryItemList with various categories
    - Define DummyStockMovements (recent additions and removals)
    - Define DummyAuditLogEntries

---

### Phase 5: Sales Dashboard UI (Dummy Data)

- [ ] 7. Implement Sales dashboard screen with dummy data
  - [ ] 7.1 Create Sales dashboard layout
    - Design CRM-focused dashboard
    - Implement total prospects widget with status breakdown (pie chart or cards)
    - Implement today's follow-ups widget
    - Implement sales achievement widget with progress bar vs target
    - Implement quick-access "Add Prospect" button
    - Implement recent campaigns widget
    - Implement conversion rate widget
    - All data from dummy data provider
    - _Requirements: 5.1–5.8_
  
  - [ ] 7.2 Create prospect management screens (UI only)
    - Create prospect list screen with search and filter by status
    - Create add/edit prospect form (name, phone, product interest, status)
    - Create prospect detail screen with follow-up history
    - All data from dummy data provider
    - _Requirements: 13.1, 13.2_
  
  - [ ] 7.3 Create dummy data for Sales dashboard
    - Define DummyProspectList with statuses (new, contacted, negotiation, closed, lost)
    - Define DummyFollowUpList for today
    - Define DummySalesTarget with daily/weekly/monthly achievement data
    - Define DummyCampaignList

---

### Phase 6: Driver Dashboard UI (Dummy Data)

- [ ] 8. Implement Driver dashboard screen with dummy data
  - [ ] 8.1 Create Driver dashboard layout
    - Design delivery-focused dashboard
    - Implement today's delivery schedule list (customer, address, status)
    - Implement delivery status indicators (pending, in-progress, completed, failed)
    - Implement route optimization placeholder widget
    - Implement map/navigation launch button per delivery
    - Implement delivery completion button with photo picker (UI only)
    - Implement delivery history widget
    - All data from dummy data provider
    - _Requirements: 6.1–6.7_
  
  - [ ] 8.2 Create dummy data for Driver dashboard
    - Define DummyDeliveryList for today with customer details and addresses
    - Define DummyDeliveryHistory for current week

---

### Phase 7: Shared Feature Screens UI (Dummy Data)

- [ ] 9. Implement attendance screens with dummy data
  - [ ] 9.1 Create check-in screen
    - Design check-in button with GPS location capture placeholder
    - Implement selfie camera capture UI with preview
    - Display dummy geofence validation status (inside/outside)
    - Show success confirmation screen with timestamp
    - _Requirements: 10.1, 10.2, 10.6_
  
  - [ ] 9.2 Create check-out screen
    - Check-out button UI
    - Display total working hours (calculated from dummy check-in time)
    - _Requirements: 10.5_
  
  - [ ] 9.3 Create attendance history screen
    - Display dummy attendance history list
    - Show check-in/check-out times, working hours, late status
    - Filter by date range (UI only)
    - _Requirements: 10.10_

- [ ] 10. Implement work report screens with dummy data
  - [ ] 10.1 Create work report submission screen
    - Text input form for report content
    - Multi-file attachment UI (photos + documents)
    - Submission confirmation dialog (UI only, no API)
    - _Requirements: 9.1, 9.2_
  
  - [ ] 10.2 Create work report list/history screen
    - List of work reports with status badges (pending, approved, rejected)
    - Tap to view detail (report content, attachments, review comments)
    - All from dummy data provider
    - _Requirements: 9.8_
  
  - [ ] 10.3 Create work report approval screen (Kepala Cabang)
    - List of pending work reports
    - Approve / Reject buttons with comment input (UI only)
    - _Requirements: 9.5, 9.6_

- [ ] 11. Implement task management screens with dummy data
  - [ ] 11.1 Create task list screen
    - Display tasks sorted by priority (Urgent > High > Medium > Low)
    - Filter by status (pending, in-progress, completed)
    - Display due dates with overdue indicators
    - All from dummy data provider
    - _Requirements: 11.6, 11.7_
  
  - [ ] 11.2 Create task detail and update screen
    - Show task title, description, assignee, priority, due date
    - "Mark as In Progress" and "Mark as Complete" buttons (UI only)
    - Attach completion proof (photo picker UI only)
    - _Requirements: 11.4, 11.5_
  
  - [ ] 11.3 Create task creation form (Kepala Cabang / Owner)
    - Input fields: title, description, assignee picker, priority, due date
    - Submit button (UI only, no API)
    - _Requirements: 11.1, 11.2_

- [ ] 12. Implement CRM / WhatsApp Blast screens with dummy data
  - [ ] 12.1 Create WhatsApp campaign list screen
    - Display campaign list with status and stats (sent, read, replied)
    - Dummy data provider for campaign list
    - _Requirements: 14.1, 14.2_
  
  - [ ] 12.2 Create campaign creation screen (UI only)
    - Template selector
    - Prospect group selector
    - Schedule picker
    - Preview before send (UI only)
    - _Requirements: 14.3, 14.4_

- [ ] 13. Implement user profile and settings screens
  - Create profile screen (name, role, branch, profile photo)
  - Create settings screen (notification preferences, theme toggle)
  - Logout button with confirmation dialog
  - _Requirements: 20.1, 20.2_

---

### Phase 8: Polish, Navigation & UX

- [ ] 14. Implement bottom navigation and drawer
  - Implement role-specific bottom navigation bar
  - Implement side drawer with role-specific menu items
  - Ensure navigation is consistent across all screens
  - _Requirements: 1.4, 1.5_

- [ ] 15. Implement notification UI
  - Create notification center screen (dummy data)
  - Implement in-app notification badge on bell icon
  - _Requirements: 16.1, 16.2_

- [ ] 16. Implement offline/online state indicators
  - Show connectivity status banner when offline
  - Display "cached data" indicator when viewing offline data
  - _Requirements: 19.1, 19.2_

- [ ] 17. Final polish and UX review
  - Ensure consistent typography, spacing, and color scheme
  - Implement loading skeletons for all data-loading screens
  - Implement empty state screens for all list screens
  - Implement error state screens
  - Ensure all screens are responsive for various phone sizes

---

### Phase 9: ✅ User Approval Checkpoint

- [ ] 18. **APPROVAL GATE — Present Flutter UI for User Review**
  - Demo all 5 role dashboards to user
  - Collect feedback on UI/UX design, navigation flow, and feature completeness
  - Document requested changes
  - Apply revisions to Flutter UI
  - **⛔ Phase B (Backend) will NOT start until user explicitly approves here**

---

## PHASE B — Backend Implementation (After UI Approval)

> ⚠️ **The following tasks are blocked until Phase A is approved by the user.**

---

### Phase 10: Infrastructure and Database Setup

- [ ] 19. Set up backend project and development environment
  - Create Rust workspace with Axum backend project structure
  - Set up Docker Compose for local development (PostgreSQL, Redis, S3-compatible storage)
  - Configure environment variables and secrets management
  - Set up database migration tool (sqlx)
  - Create initial CI/CD pipeline configuration files
  - _Requirements: 24.1, 24.2, 24.3_

- [ ] 20. Implement database schema and migrations
  - [ ] 20.1 Create core entity tables (User, Branch, Audit_Log)
    - Write SQL migrations for User table with role enum and branch_id
    - Write SQL migrations for Branch table with geofence coordinates
    - Write SQL migrations for Audit_Log table with immutability constraints
    - Add indexes on foreign keys and frequently queried fields
    - _Requirements: 1.4, 1.5, 18.2, 18.6, 23.4_
  
  - [ ] 20.2 Create inventory management tables
    - Write SQL migrations for Inventory_Item table with category enum
    - Write SQL migrations for Stock_Transaction table with type enum
    - Add indexes for branch_id, item_id, and created_at fields
    - _Requirements: 7.1, 7.2, 7.5_
  
  - [ ] 20.3 Create HRIS tables
    - Write SQL migrations for Attendance table with geofence validation fields
    - Write SQL migrations for Task table with priority and status enums
    - Write SQL migrations for Work_Report table with approval workflow fields
    - Write SQL migrations for Delivery_Schedule table with status tracking
    - _Requirements: 10.1, 10.5, 11.1, 12.1_
  
  - [ ] 20.4 Create CRM and messaging tables
    - Write SQL migrations for Prospect table with unique phone constraint
    - Write SQL migrations for WhatsApp_Campaign table with statistics fields
    - Write SQL migrations for WhatsApp_Message table with retry tracking
    - Write SQL migrations for Chat_Message table with encryption support
    - _Requirements: 13.1, 13.2, 13.9, 14.1, 21.1_

- [ ] 21. Checkpoint - Database schema validation
  - Run all migrations successfully
  - Verify all tables created with correct constraints and indexes
  - Test rollback functionality for migrations

---

### Phase 11: Authentication Backend

- [ ] 22. Implement full authentication service (Rust/Axum)
  - [ ] 22.1 Create user authentication module
    - Implement bcrypt password hashing with 12 rounds minimum
    - Create user registration endpoint
    - Create POST /api/auth/login endpoint (used by Flutter since Phase A)
    - Implement JWT token generation with user role and branch_id in claims
    - Set JWT expiration to 24 hours
    - _Requirements: 1.1, 22.1, 22.2_
  
  - [ ] 22.2 Implement JWT validation middleware
    - Create Axum middleware to extract and validate JWT from Authorization header
    - Extract user claims (user_id, role, branch_id) and attach to request context
    - Return 401 Unauthorized for invalid or expired tokens
    - _Requirements: 1.3, 1.10, 22.2_
  
  - [ ] 22.3 Implement RBAC middleware
    - Define permission matrix for 5 roles
    - Create Axum middleware to enforce role permissions per endpoint
    - Implement branch-level data isolation for non-Owner roles
    - _Requirements: 1.4–1.9, 18.9_
  
  - [ ] 22.4 Implement refresh token and rate limiting
    - Refresh token storage in Redis
    - Login rate limiting (5 attempts per 15 minutes per IP)
    - Input sanitization middleware
    - _Requirements: 1.10, 22.5, 22.6_

---

### Phase 12: Owner Backend APIs

- [ ] 23. Implement Owner dashboard backend service
  - Implement aggregated metrics service (inventory, sales, attendance, tasks) across all branches
  - Cache dashboard metrics in Redis with 5-minute TTL
  - Create GET /api/owner/dashboard endpoint
  - Create GET /api/owner/branches/:id/details endpoint
  - Create GET /api/owner/performance/rankings endpoint
  - _Requirements: 2.1–2.11_

- [ ] 24. Connect Flutter Owner dashboard to real API
  - Replace DummyOwnerDashboard provider with API service calls
  - Implement error handling and loading states
  - Implement offline caching with SQLite (Drift)
  - _Requirements: 2.8, 2.9, 19.2_

---

### Phase 13: Kepala Cabang Backend APIs

- [ ] 25. Implement Kepala Cabang dashboard backend service
  - Implement branch-specific metrics service with branch_id filter
  - Create GET /api/kepala-cabang/dashboard endpoint
  - Create attendance, tasks, delivery, work-report endpoints
  - _Requirements: 3.1–3.9_

- [ ] 26. Connect Flutter Kepala Cabang dashboard to real API
  - Replace dummy providers with API service calls
  - Implement offline caching
  - _Requirements: 3.9, 19.2_

---

### Phase 14: Admin Backend APIs

- [ ] 27. Implement inventory management backend service
  - Implement POST /api/inventory/stock/add endpoint
  - Implement POST /api/inventory/stock/remove endpoint (prevent negative stock)
  - Implement stock alert background job
  - Implement GET /api/inventory/items, /transactions, /alerts endpoints
  - Write property tests for stock calculation and alert generation
  - _Requirements: 7.1–7.9_

- [ ] 28. Implement Admin dashboard backend service
  - Aggregate inventory, stock movements, audit logs for branch
  - Create GET /api/admin/dashboard endpoint
  - _Requirements: 4.1–4.7_

- [ ] 29. Connect Flutter Admin screens to real API
  - Replace dummy providers with API calls
  - Connect stock input forms to real POST endpoints
  - Implement offline queue for stock transactions
  - _Requirements: 7.8, 19.3, 19.8_

---

### Phase 15: Sales Backend APIs

- [ ] 30. Implement CRM backend service
  - Implement Prospect CRUD endpoints
  - Implement conversion funnel calculation
  - Implement WhatsApp campaign management
  - Create Sales dashboard metrics endpoints
  - _Requirements: 5.1–5.8, 13.1–13.9, 14.1–14.9_

- [ ] 31. Connect Flutter Sales screens to real API
  - Replace dummy providers with API calls
  - Connect prospect forms to real POST/PUT endpoints
  - _Requirements: 13.1, 13.2_

---

### Phase 16: Driver Backend APIs

- [ ] 32. Implement delivery management backend service
  - Implement delivery schedule CRUD endpoints
  - Implement delivery status update endpoint
  - Implement route optimization suggestion
  - _Requirements: 6.1–6.8, 12.1–12.7_

- [ ] 33. Connect Flutter Driver screens to real API
  - Replace dummy providers with API calls
  - Connect delivery completion to real PUT endpoint
  - Implement offline caching for today's deliveries
  - _Requirements: 6.8, 19.7_

---

### Phase 17: HRIS Backend APIs

- [ ] 34. Implement attendance backend service
  - Implement POST /api/attendance/check-in with GPS geofence validation
  - Implement POST /api/attendance/check-out with working hours calculation
  - Implement duplicate attendance detection
  - Store selfie photos in Object Storage
  - Write property tests: geofence validation, duplicate detection, hours calculation
  - _Requirements: 10.1–10.10_

- [ ] 35. Implement work report backend service
  - Implement POST /api/work-reports endpoint
  - Implement approval/rejection endpoints (Kepala Cabang)
  - Send notifications on submission and review
  - _Requirements: 9.1–9.8_

- [ ] 36. Implement task management backend service
  - Implement POST /api/tasks endpoint with WhatsApp notification
  - Implement task status update endpoint
  - Write property test for task assignment
  - _Requirements: 11.1–11.7_

- [ ] 37. Connect Flutter HRIS screens to real API
  - Replace dummy attendance, work report, task providers with API calls
  - Implement offline sync queue for attendance and work reports
  - _Requirements: 10.9, 9.3, 19.3, 19.4_

---

### Phase 18: Integrations

- [ ] 38. Implement WhatsApp integration (N8N / WA Business API)
  - Set up N8N workflow for WhatsApp message dispatch
  - Implement retry mechanism for failed messages
  - Implement campaign blast scheduler
  - _Requirements: 14.1–14.9, 16.1–16.9_

- [ ] 39. Implement social media monitoring (optional)
  - Set up monitoring for brand mentions (Tokopedia, Shopee, Instagram, Google)
  - Notification pipeline for negative reviews
  - _Requirements: 15.1–15.9_

- [ ] 40. Implement push notification service
  - Set up Firebase Cloud Messaging (FCM) for push notifications
  - Implement notification delivery for tasks, attendance, work reports
  - _Requirements: 16.1–16.9_

---

### Phase 19: Reporting & Analytics

- [ ] 41. Implement stock reporting service
  - Stock turnover, cross-branch comparison, movement history
  - PDF export
  - _Requirements: 8.1–8.8_

- [ ] 42. Implement sales and performance reporting
  - Employee performance ranking calculation (sales, revenue, attendance, tasks)
  - Multi-period filtering (daily, weekly, monthly, quarterly, yearly)
  - _Requirements: 24.1–24.12_

- [ ] 43. Connect Flutter reporting screens to real API
  - Replace dummy report data with real API calls
  - Implement PDF export and share

---

### Phase 20: Security, Testing & Deployment

- [ ] 44. Write comprehensive property-based tests
  - JWT correctness (Property 1)
  - Invalid credentials rejection (Property 2)
  - RBAC enforcement (Property 3)
  - Dashboard aggregation correctness (Property 4)
  - Branch data isolation (Property 5)
  - Stock transaction recording (Property 6)
  - Stock alert generation (Property 7)
  - Real-time stock calculation (Property 8)
  - Negative stock prevention (Property 10)
  - Geofence validation (Property 11)
  - Duplicate attendance detection (Property 12)
  - Working hours calculation (Property 13)
  - Late attendance detection (Property 14)
  - Task assignment (Property 15)
  - Login rate limiting (Property 32)
  - SQL injection prevention (Property 33)
  - _Requirements: 22.1–22.6_

- [ ] 45. Implement audit logging
  - Log all data mutations with user_id, action, old/new values, timestamp
  - Create immutable audit trail for compliance
  - _Requirements: 18.1–18.9_

- [ ] 46. Production deployment
  - Deploy Rust backend to VPS (Docker + Nginx)
  - Configure PostgreSQL and Redis for production
  - Configure SSL certificates
  - Set up automated backups
  - Publish Flutter app to Google Play Store / APK distribution
  - _Requirements: 23.1–23.5_

- [ ] 47. Final system validation
  - End-to-end testing for all 5 roles
  - Performance and load testing
  - Security audit
  - User acceptance testing
  - Ask the user if questions arise
