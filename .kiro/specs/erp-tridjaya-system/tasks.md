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
  
  - [ ] 2.4 Implement password reset UI ("Lupa Password" flow)
    - Add "Lupa Password" link on login screen
    - Create OTP request screen (input username/phone, submit to POST /api/auth/password-reset/request)
    - Create OTP verification screen (6-digit input, 15-minute countdown timer)
    - Create new password input screen with confirmation field
    - Handle error states: invalid OTP, expired OTP, rate limit exceeded
    - _Requirements: 26.1, 26.4, 26.5, 26.7_

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
  
  - [ ] 7.4 Create stock availability widget for Sales (read-only)
    - Display product availability status (Tersedia / Habis) per category (Aki, TV, HP) for the Sales employee's branch
    - Use dummy data; no stock quantity shown — only availability indicator
    - _Requirements: 5.9_

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

### Phase 8.6: 👑 Super Admin System (NEW)
> Kontrol penuh sistem untuk Super Administrator

- [ ] 18.1 Super Admin Role & Models
  - [x] 18.1.1 Add SuperAdmin to UserRole enum
  - [x] 18.1.2 Create Super Admin models (SystemConfig, UserManagement, AuditLog)
  - [x] 18.1.3 Create RoleDefinition and Permission models
  - [x] 18.1.4 Create SecurityAlert and FeatureFlag models
  - [x] 18.1.5 Create dummy data for all Super Admin features
  - _Requirements: NEW - Super Admin Control

- [ ] 18.2 Super Admin Dashboard UI
  - [x] 18.2.1 Create SuperAdminDashboardScreen with 6 tabs
    - Overview: System stats, role distribution, recent activity
    - Users: Full user management (CRUD, suspend, impersonate)
    - Branches: Branch management and monitoring
    - Security: Security alerts and monitoring
    - Audit Logs: Complete system audit trail
    - System: Feature flags, configuration, backups
  - [x] 18.2.2 Implement user management actions
    - Add/edit/delete users
    - Suspend/activate users
    - Reset passwords
    - Impersonate users
    - View user details and history
  - [x] 18.2.3 Implement security monitoring
    - Critical alerts display
    - Alert severity levels (Critical, High, Medium, Low)
    - Alert resolution workflow
  - [x] 18.2.4 Implement audit logging UI
    - All system actions logged
    - Filter by action type, user, date
    - Export audit logs
  - _Requirements: NEW - Super Admin Dashboard

- [ ] 18.3 Super Admin Navigation & Routes
  - [x] 18.3.1 Add SuperAdmin to UserRoleExtension with permissions
    - canAccessAllBranches: true
    - canManageAllUsers: true
    - canEditAnyData: true
    - isSuperAdmin: true
  - [x] 18.3.2 Add Super Admin routes to app_router
    - /superadmin (Dashboard)
    - /superadmin/users/create
    - /superadmin/users/:id/edit
    - /superadmin/settings
    - /superadmin/security/:id
  - [x] 18.3.3 Add Super Admin bottom navigation
    - Dashboard, Pengguna, Monitoring, Profil
  - _Requirements: NEW - Super Admin Navigation

---

### Phase 8.5: 📋 Job Desk System (NEW)
> Sistem job desk fleksibel per role dengan proof foto

- [ ] 17.1 Implement Job Desk UI - Owner/Superadmin Management
  - [ ] 17.1.1 Create Job Desk template management screen
    - List all templates per role (Support Online, Sales, Driver, etc)
    - Search and filter templates
    - Activate/deactivate templates
    - _Requirements: NEW - Job Desk Management
  
  - [ ] 17.1.2 Create Job Desk template form screen
    - Template name and role selection
    - Dynamic task list editor (add/edit/delete/reorder)
    - Task configuration: name, description, type (counter/checkbox)
    - Proof requirements: photo/document/none
    - Target value and unit (e.g., 200 orang, 5 kontak)
    - Mandatory/optional toggle
    - Preview template before save
    - _Requirements: NEW - Template Builder
  
  - [ ] 17.1.3 Create Job Desk assignment screen
    - Select employees by role/branch (multi-select)
    - Assign template to selected employees
    - Set validity period (start-end date)
    - Bulk assignment capabilities
    - Assignment history view
    - _Requirements: NEW - Assignment Management
  
  - [ ] 17.1.4 Create Job Desk monitoring dashboard
    - Overview: completion rate per role/branch
    - Employee progress list with status
    - Filter by date range, role, branch
    - Drill-down to individual employee detail
    - Export/report capabilities (placeholder)
    - _Requirements: NEW - Monitoring & Analytics

- [x] 17.1.5 Create Job Desk Activity Report Screen (NEW)
  - **Role-based access control:**
    - Owner: Lihat semua cabang (system-wide view)
    - Kepala Cabang: Hanya cabang sendiri (branch-restricted)
    - PIC: Lihat semua untuk penilaian & verifikasi
  - **3 Tab Interface:**
    - Overview: Summary cards, role breakdown, alerts/notifications
    - Karyawan: List karyawan dengan filter (branch, role, status)
    - Cabang: Summary per cabang (Owner/SuperAdmin only)
  - **Features:**
    - Search karyawan by name/role/branch
    - Filter by status: notStarted, pending, inProgress, pendingVerification, verified
    - Employee cards dengan progress bar dan score badge
    - Branch health indicators (excellent/good/average/poor)
    - Alerts: no activity, low completion, pending verification, excellent performance
    - Export to PDF/Excel (placeholder)
    - Detail modal untuk lihat submission history
  - **Data Models:** EmployeeJobDeskActivity, BranchJobDeskSummary, DailyJobDeskReport
  - **Dummy Data:** 4 cabang, 10+ karyawan, mixed activity statuses
  - _Requirements: NEW - Activity Reporting & Analytics_

- [ ] 17.2 Implement Job Desk UI - Employee Daily Input
  - [ ] 17.2.1 Create My Job Desk dashboard screen
    - Today's task list with progress ring
    - Task status: pending/completed/verified
    - Counter tasks with +/- buttons
    - Checkbox tasks for simple completion
    - Photo proof requirement indicator
    - Daily completion summary
    - Streak/achievement display (gamification placeholder)
    - _Requirements: NEW - Employee Dashboard
  
  - [ ] 17.2.2 Create Job Desk submission screen
    - Task-by-task input form
    - Camera integration for photo proof
    - Gallery picker for multiple photos
    - Notes/comment input per task
    - Real-time validation (e.g., min 200 broadcast)
    - Submit confirmation with summary
    - Offline mode support (save draft)
    - _Requirements: NEW - Task Submission
  
  - [ ] 17.2.3 Create Job Desk history screen
    - Calendar view of past submissions
    - Daily detail view with all tasks
    - Filter by status: all/completed/pending
    - View submitted photos
    - Edit history (if allowed by admin)
    - _Requirements: NEW - History Tracking
  
  - [ ] 17.2.4 Create Photo proof viewer/camera screen
    - Camera with guidelines overlay
    - Photo preview and retake option
    - Multiple photo capture (3-5 photos)
    - Timestamp and GPS tag display (if enabled)
    - Gallery integration for existing photos
    - _Requirements: NEW - Proof Capture

- [ ] 17.3 Implement Job Desk UI - PIC/Owner Verification & Scoring
  - [ ] 17.3.1 Create PIC Dashboard Screen
    - Overview: All employees job desk submissions for selected date
    - Auto-priority algorithm: Who to check first (completion %, overdue, etc)
    - Filter by branch, role, completion status, verification status
    - Quick stats: Pending verification, Completed, Need attention
    - _Requirements: NEW - PIC Dashboard
  
  - [ ] 17.3.2 Create Photo Review Screen
    - One-by-one photo review interface
    - Zoom, pan, and annotate photos
    - Score input (1-100) per task submission
    - Comment/note per photo
    - Navigation: Previous/Next photo
    - Mark as verified or flag for revision
    - _Requirements: NEW - Photo Review
  
  - [ ] 17.3.3 Create Verification Detail Screen
    - Employee profile header with completion summary
    - All tasks with submitted proofs in list
    - Individual task score input
    - Auto-calculate total score based on weights
    - Override individual scores
    - Final approval with signature/comment
    - _Requirements: NEW - Verification Detail
  
  - [ ] 17.3.4 Create Daily Scoring Recap Screen
    - Auto-generated at 09:00 WITA cutoff
    - All employees scores for previous day
    - Export/download report (CSV/PDF placeholder)
    - Edit scores (PIC can modify after cutoff)
    - Lock indicator for closed submissions
    - _Requirements: NEW - Daily Recap

- [ ] 17.4 Job Desk Time-Based Rules (Cutoff System)
  - [ ] 17.4.1 Cutoff Time Configuration
    - Default cutoff: 09:00 WITA
    - Configurable per branch (optional)
    - Countdown timer for employees (show time remaining)
    - _Requirements: NEW - Cutoff Settings
  
  - [ ] 17.4.2 Submission Lock Mechanism
    - Auto-lock submissions at cutoff time
    - Previous day submissions locked for employees
    - Current day opens after 09:00 WITA
    - Visual indicators: Locked/Unlocked status
    - _Requirements: NEW - Time Locking
  
  - [ ] 17.4.3 PIC Edit Permissions
    - PIC can edit scores anytime after cutoff
    - Edit history tracking (who, when, what changed)
    - Reason for edit field (required)
    - Notification to employee if score changed
    - _Requirements: NEW - Edit Tracking

- [ ] 17.4 Pre-defined Templates (Seed Data - UI Only)
  - [ ] 17.4.1 Support Online template
    - Tasks: Update data pelamar, Broadcast 200 orang, 5 prospek/hari,
      Sosmed management, Kenalan 5 orang, Tambah kontak 5,
      IDG LKH harian, Share ke 100 grup, SS WA ke Ko Iwan,
      WA Bomber 3x, TikTok upload & live, Ucapan ulang tahun
    - Proof requirements: Photo for broadcast, SS for WA
    - _Requirements: NEW - Support Online Role
  
  - [ ] 17.4.2 Sales template
    - Tasks: Follow-up prospek, Kunjungan customer, Input data,
      Update pipeline, Laporan harian
    - Proof requirements: Photo for kunjungan
    - _Requirements: NEW - Sales Role
  
  - [ ] 17.4.3 Driver template
    - Tasks: Check kendaraan (pagi/sore), Deliver orders,
      Update status, Laporan pengiriman
    - Proof requirements: Photo for check kendaraan
    - _Requirements: NEW - Driver Role
  
  - [ ] 17.4.4 Admin template
    - Tasks: Stok check, Input transaksi, Rekonsiliasi,
      Laporan harian admin
    - Proof requirements: Photo for stok
    - _Requirements: NEW - Admin Role

- [ ] 17.5 Job Desk Navigation Integration
  - Add "Job Desk" menu item to bottom nav for all roles
  - Role-specific icons and labels
  - Badge for pending tasks
  - _Requirements: 1.4, 1.5

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
    - Write SQL migrations for User table with role enum, branch_id, whatsapp_number, is_active, and deleted_at fields
    - Write SQL migrations for Branch table with geofence coordinates
    - Write SQL migrations for Audit_Log table with immutability constraints
    - Create dedicated PostgreSQL role `audit_writer` with INSERT-only privilege on audit_logs table; revoke UPDATE and DELETE from application user
    - Add PostgreSQL trigger on audit_logs to reject any UPDATE or DELETE at DB level
    - Add indexes on foreign keys and frequently queried fields
    - _Requirements: 1.4, 1.5, 18.2, 18.3, 18.6, 23.4_
  
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
    - Write SQL migrations for Prospect table with unique phone constraint and branch_id field
    - Write SQL migrations for WhatsApp_Campaign table with statistics fields and branch_id field
    - Write SQL migrations for WhatsApp_Message table with retry tracking
    - Write SQL migrations for Chat_Message table with encryption support (content stored as encrypted bytes)
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
    - Implement JWT token generation with user role, branch_id, and jti (UUID) in claims
    - Set JWT expiration to 24 hours
    - _Requirements: 1.1, 1.11, 22.1, 22.2_
  
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
    - Refresh token storage in Redis with 7-day TTL keyed by user_id
    - On logout: delete refresh token from Redis immediately
    - On password change or user deactivation: delete all refresh tokens for that user from Redis
    - Login rate limiting (5 attempts per 15 minutes per IP)
    - Input sanitization middleware
    - _Requirements: 1.10, 1.12, 1.13, 22.5, 22.6_
  
  - [ ] 22.5 Implement password reset via WhatsApp OTP
    - Create POST /api/auth/password-reset/request endpoint: validate user exists, generate 6-digit OTP, store in Redis with 15-minute TTL and 3-attempt counter per hour, send OTP via WhatsApp_Gateway
    - Create POST /api/auth/password-reset/verify endpoint: validate OTP, check expiry and attempt count, update password hash with bcrypt, invalidate all refresh tokens for user, create Audit_Log entry
    - Implement OTP attempt counter in Redis to block after 3 failed attempts per hour
    - _Requirements: 26.1, 26.2, 26.3, 26.4, 26.5, 26.6_

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
  - Implement Prospect CRUD endpoints with branch_id filter enforced for non-Owner roles
  - Implement conversion funnel calculation
  - Implement WhatsApp campaign management with branch isolation: validate all recipient prospects belong to creator's branch before campaign creation
  - Create Sales dashboard metrics endpoints
  - Create GET /api/inventory/availability endpoint (returns only Tersedia/Habis per category for Sales role, filtered by branch)
  - _Requirements: 5.1–5.9, 13.1–13.9, 14.1–14.12_

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
  - Accept and log mock_location_detected flag from mobile app; reject check-in if mock location is detected
  - Implement POST /api/attendance/check-out with working hours calculation
  - Implement duplicate attendance detection (applies to all roles including Driver)
  - Implement offline sync conflict resolution: reject offline attendance if server record already exists for same user+date (server-wins)
  - Store selfie photos in Object Storage
  - Write property tests: geofence validation, duplicate detection, hours calculation, offline conflict resolution, mock location rejection
  - _Requirements: 10.1–10.13_

- [ ] 35. Implement work report backend service
  - Implement POST /api/work-reports endpoint
  - Implement approval/rejection endpoints (Kepala Cabang)
  - Implement escalation background job: check every hour for work reports pending > 48 hours; notify Owner and grant Owner temporary approval access
  - Implement PUT /api/work-reports/:id/approve endpoint accessible by both Kepala_Cabang and Owner (Owner only when escalated)
  - Send notifications on submission and review
  - _Requirements: 9.1–9.9_

- [ ] 36. Implement task management backend service
  - Implement POST /api/tasks endpoint with WhatsApp notification
  - Enforce branch isolation: validate assignee belongs to same branch as creator; allow cross-branch only if creator role is Owner
  - Implement task status update endpoint
  - Implement delivery edit/cancel endpoints with status-based guard (only allow edit/cancel when status = Pending)
  - Enforce Driver cannot cancel delivery; Driver can only set status to InProgress, Completed, or Failed (notes required for Failed)
  - Write property tests: task assignment branch enforcement, delivery status transition enforcement
  - _Requirements: 11.1–11.12, 12.11–12.13_

- [ ] 37. Connect Flutter HRIS screens to real API
  - Replace dummy attendance, work report, task providers with API calls
  - Implement offline sync queue for attendance and work reports
  - _Requirements: 10.9, 9.3, 19.3, 19.4_

---

### Phase 18: Integrations

- [ ] 38. Implement WhatsApp integration (N8N / WA Business API)
  - Set up N8N workflow for WhatsApp message dispatch
  - Implement HMAC-SHA256 webhook authentication: WhatsApp_Gateway signs all webhook payloads with shared secret; N8N validates signature on every incoming webhook before processing
  - Store webhook shared secret in secret manager; implement rotation mechanism (minimum every 90 days)
  - Implement retry mechanism for failed messages
  - Implement campaign blast scheduler
  - _Requirements: 14.1–14.9, 16.1–16.9, 27.1–27.5_

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
  - Refresh token revocation on logout and password change (Property 36)
  - Prospect branch isolation: Sales cannot access prospects from other branches (Property 37)
  - Campaign branch isolation: campaign rejected if any recipient is from different branch (Property 38)
  - Task assignment branch enforcement: Kepala Cabang cannot assign cross-branch, Owner can (Property 39)
  - Delivery status transition enforcement: cannot edit/cancel InProgress or Completed delivery; Driver cannot cancel (Property 40)
  - Offline attendance conflict resolution: server-wins, reject offline record if server record exists (Property 41)
  - N8N webhook HMAC validation: invalid or missing signature returns 401 (Property 42)
  - _Requirements: 22.1–22.12, 26.1–26.6, 27.1–27.5_

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
