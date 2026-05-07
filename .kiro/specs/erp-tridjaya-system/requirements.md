# Requirements Document: Sistem ERP Tridjaya

## Introduction

Sistem ERP Tridjaya adalah platform manajemen terpadu untuk perusahaan retail multi-cabang yang mengelola produk Aki, TV, dan HP. Sistem ini mengintegrasikan manajemen operasional, inventori, CRM dengan otomasi WhatsApp, HRIS, dan monitoring digital marketing dalam satu ekosistem. Platform ini dibangun dengan backend Rust (Axum/Tokio), database PostgreSQL dan Redis, serta aplikasi mobile Flutter dengan offline-first capability.

## Glossary

- **System**: Sistem ERP Tridjaya secara keseluruhan
- **Backend_Service**: Layanan backend berbasis Rust (Axum/Tokio)
- **Mobile_App**: Aplikasi mobile Flutter untuk Android/iOS
- **Auth_Service**: Layanan autentikasi dan otorisasi berbasis JWT
- **RBAC_Module**: Modul Role-Based Access Control
- **Operational_Service**: Layanan manajemen operasional dan inventori
- **CRM_Service**: Layanan Customer Relationship Management
- **HRIS_Service**: Layanan Human Resource Information System
- **Social_Service**: Layanan monitoring media sosial
- **Notification_Service**: Layanan notifikasi WhatsApp dan push notification
- **WhatsApp_Gateway**: Gateway WhatsApp self-hosted untuk messaging
- **N8N_Service**: Layanan otomasi workflow dan AI chatbot
- **Database**: PostgreSQL sebagai database utama
- **Cache**: Redis untuk caching dan message queue
- **Object_Storage**: Penyimpanan file dan gambar (S3-compatible)
- **Owner**: Role dengan akses penuh ke semua cabang dan laporan
- **Kepala_Cabang**: Role untuk manajemen operasional cabang spesifik
- **Admin**: Role untuk input data dan manajemen inventori
- **Sales**: Role untuk manajemen prospek dan penjualan
- **Driver**: Role untuk jadwal dan rute pengiriman
- **Branch**: Cabang perusahaan retail
- **Inventory_Item**: Item inventori (Aki, TV, HP)
- **Prospect**: Data calon pembeli/pelanggan
- **Task**: Tugas yang diberikan kepada karyawan
- **Attendance**: Data kehadiran karyawan
- **Delivery_Schedule**: Jadwal pengiriman barang
- **Work_Report**: Laporan kerja harian karyawan
- **Stock_Alert**: Notifikasi stok rendah
- **Audit_Log**: Log perubahan data untuk transparansi

## Requirements

### Requirement 1: Autentikasi dan Otorisasi

**User Story:** As a system administrator, I want secure authentication and role-based access control, so that each user can only access features appropriate to their role.

#### Acceptance Criteria

1. WHEN a user attempts to login with valid credentials, THE Auth_Service SHALL generate a JWT token containing user role and branch information
2. WHEN a user attempts to login with invalid credentials, THE Auth_Service SHALL reject the login and return an error message
3. WHEN a user accesses a protected endpoint, THE Auth_Service SHALL validate the JWT token and verify role permissions
4. THE RBAC_Module SHALL enforce access restrictions based on five roles: Owner, Kepala_Cabang, Admin, Sales, and Driver
5. WHEN an Owner accesses the system, THE RBAC_Module SHALL grant access to all branches and all features
6. WHEN a Kepala_Cabang accesses the system, THE RBAC_Module SHALL restrict access to their assigned branch only
7. WHEN an Admin accesses the system, THE RBAC_Module SHALL grant access to data input and inventory management features
8. WHEN a Sales accesses the system, THE RBAC_Module SHALL grant access to prospect management and sales reporting features
9. WHEN a Driver accesses the system, THE RBAC_Module SHALL grant access to delivery schedule and route features only
10. WHEN a JWT token expires, THE Auth_Service SHALL require re-authentication

### Requirement 2: Dashboard Owner

**User Story:** As an Owner, I want a comprehensive dashboard showing all branches' performance, so that I can monitor the entire business at a glance.

#### Acceptance Criteria

1. WHEN an Owner logs in, THE Mobile_App SHALL display a dashboard with aggregated data from all branches
2. THE Mobile_App SHALL display total inventory levels across all branches for Aki, TV, and HP categories
3. THE Mobile_App SHALL display daily, weekly, and monthly sales performance for each branch
4. THE Mobile_App SHALL display attendance summary showing present, absent, and late employees across all branches
5. THE Mobile_App SHALL display pending tasks count for each branch
6. THE Mobile_App SHALL display low stock alerts from all branches
7. WHEN an Owner selects a specific branch, THE Mobile_App SHALL display detailed information for that branch
8. THE Mobile_App SHALL refresh dashboard data automatically every 5 minutes when online
9. WHEN the Owner is offline, THE Mobile_App SHALL display the last cached dashboard data with a timestamp
10. THE Mobile_App SHALL display employee performance rankings for Sales and non-Sales employees
11. THE Mobile_App SHALL display top performers and bottom performers for each category

### Requirement 3: Dashboard Kepala Cabang

**User Story:** As a Kepala Cabang, I want a dashboard showing my branch's operational status, so that I can manage daily operations effectively.

#### Acceptance Criteria

1. WHEN a Kepala_Cabang logs in, THE Mobile_App SHALL display a dashboard for their assigned branch only
2. THE Mobile_App SHALL display current inventory levels for Aki, TV, and HP in their branch
3. THE Mobile_App SHALL display today's attendance status for all employees in their branch
4. THE Mobile_App SHALL display pending and completed tasks for their branch employees
5. THE Mobile_App SHALL display today's delivery schedule for their branch
6. THE Mobile_App SHALL display low stock alerts for their branch with item details
7. THE Mobile_App SHALL display daily sales summary for their branch
8. THE Mobile_App SHALL display pending work reports that need approval
9. WHEN a Kepala_Cabang is offline, THE Mobile_App SHALL allow viewing cached dashboard data

### Requirement 4: Dashboard Admin

**User Story:** As an Admin, I want a dashboard focused on inventory and data management, so that I can efficiently handle data entry tasks.

#### Acceptance Criteria

1. WHEN an Admin logs in, THE Mobile_App SHALL display a dashboard with inventory management features
2. THE Mobile_App SHALL display current stock levels for all inventory categories in their branch
3. THE Mobile_App SHALL display recent stock movements (in/out) for the current day
4. THE Mobile_App SHALL display low stock alerts requiring attention
5. THE Mobile_App SHALL provide quick access to stock input forms
6. THE Mobile_App SHALL display pending data entry tasks assigned to the Admin
7. THE Mobile_App SHALL display recent audit log entries for inventory changes

### Requirement 5: Dashboard Sales

**User Story:** As a Sales, I want a dashboard showing my prospects and sales performance, so that I can track my sales activities and targets.

#### Acceptance Criteria

1. WHEN a Sales logs in, THE Mobile_App SHALL display a dashboard with CRM features
2. THE Mobile_App SHALL display total number of prospects assigned to the Sales
3. THE Mobile_App SHALL display prospects categorized by status (new, contacted, negotiation, closed, lost)
4. THE Mobile_App SHALL display today's follow-up tasks for prospects
5. THE Mobile_App SHALL display daily, weekly, and monthly sales achievement vs target
6. THE Mobile_App SHALL provide quick access to add new prospect form
7. THE Mobile_App SHALL display recent WhatsApp campaign results
8. THE Mobile_App SHALL display conversion rate statistics

### Requirement 6: Dashboard Driver

**User Story:** As a Driver, I want a dashboard showing my delivery schedule and routes, so that I can plan my deliveries efficiently.

#### Acceptance Criteria

1. WHEN a Driver logs in, THE Mobile_App SHALL display a dashboard with delivery schedule features
2. THE Mobile_App SHALL display today's delivery schedule with customer addresses
3. THE Mobile_App SHALL display delivery status (pending, in-progress, completed, failed)
4. THE Mobile_App SHALL display optimized route suggestions for multiple deliveries
5. THE Mobile_App SHALL provide navigation integration for each delivery address
6. THE Mobile_App SHALL allow marking deliveries as completed with photo proof
7. THE Mobile_App SHALL display delivery history for the current week
8. WHEN a Driver is offline, THE Mobile_App SHALL cache today's delivery schedule for offline access

### Requirement 7: Manajemen Inventori

**User Story:** As an Admin or Kepala Cabang, I want to manage inventory levels, so that stock data is accurate and up-to-date.

#### Acceptance Criteria

1. WHEN an authorized user adds stock, THE Operational_Service SHALL record the stock addition with timestamp and user information
2. WHEN an authorized user removes stock, THE Operational_Service SHALL record the stock removal with reason and user information
3. WHEN stock level falls below the defined threshold, THE Operational_Service SHALL generate a Stock_Alert
4. THE Operational_Service SHALL calculate real-time stock levels across all branches
5. WHEN a stock transaction is recorded, THE Operational_Service SHALL create an Audit_Log entry
6. THE Mobile_App SHALL support barcode scanning for quick stock entry
7. THE Mobile_App SHALL allow attaching photos to stock transactions
8. WHEN the user is offline, THE Mobile_App SHALL queue stock transactions for synchronization when online
9. THE Operational_Service SHALL prevent negative stock levels unless explicitly allowed for specific item types

### Requirement 8: Pelaporan Stok Terintegrasi

**User Story:** As a Kepala Cabang or Owner, I want integrated stock reporting across branches, so that I can monitor inventory distribution and identify stock imbalances.

#### Acceptance Criteria

1. WHEN an Owner requests stock report, THE Operational_Service SHALL generate a report showing stock levels for all branches
2. WHEN a Kepala_Cabang requests stock report, THE Operational_Service SHALL generate a report for their branch only
3. THE Operational_Service SHALL categorize stock by product type (Aki, TV, HP)
4. THE Operational_Service SHALL calculate stock turnover rate for each product category
5. THE Operational_Service SHALL identify branches with excess stock and branches with low stock
6. THE Operational_Service SHALL generate stock movement history for a specified date range
7. THE Mobile_App SHALL display stock reports with charts and visualizations
8. THE Mobile_App SHALL allow exporting stock reports as PDF

### Requirement 9: Pelaporan Karyawan

**User Story:** As an employee, I want to submit daily work reports, so that my activities are documented and my supervisor can track my progress.

#### Acceptance Criteria

1. WHEN an employee submits a work report, THE HRIS_Service SHALL record the report with timestamp and employee information
2. THE Mobile_App SHALL allow attaching multiple photos or documents to work reports
3. THE Mobile_App SHALL support offline work report creation with automatic sync when online
4. WHEN a work report is submitted, THE HRIS_Service SHALL notify the employee's supervisor
5. WHEN a Kepala_Cabang views work reports, THE Mobile_App SHALL display all reports from their branch employees
6. THE Mobile_App SHALL allow Kepala_Cabang to approve or reject work reports with comments
7. THE HRIS_Service SHALL store work report attachments in Object_Storage
8. THE Mobile_App SHALL display work report submission history for each employee

### Requirement 10: Absensi Karyawan

**User Story:** As an employee, I want to record my attendance with location and photo verification, so that my presence at the workplace is validated.

#### Acceptance Criteria

1. WHEN an employee checks in, THE HRIS_Service SHALL record attendance with timestamp, GPS coordinates, and selfie photo
2. THE HRIS_Service SHALL validate that GPS coordinates are within the defined geofence radius of the branch location
3. WHEN GPS coordinates are outside the geofence, THE HRIS_Service SHALL reject the attendance and notify the employee
4. THE HRIS_Service SHALL detect and flag duplicate attendance attempts within the same day
5. WHEN an employee checks out, THE HRIS_Service SHALL record the checkout time and calculate total working hours
6. THE Mobile_App SHALL capture a selfie photo during check-in for facial verification
7. THE HRIS_Service SHALL store attendance photos in Object_Storage
8. WHEN an employee is late, THE HRIS_Service SHALL mark the attendance as late and calculate delay duration
9. THE Mobile_App SHALL allow offline attendance recording with sync when connection is restored
10. WHEN a Kepala_Cabang views attendance, THE Mobile_App SHALL display attendance status for all branch employees

### Requirement 11: Manajemen Tugas (Task Management)

**User Story:** As a Kepala Cabang, I want to assign tasks to employees and track their completion, so that work is organized and accountable.

#### Acceptance Criteria

1. WHEN a Kepala_Cabang creates a task, THE HRIS_Service SHALL record the task with title, description, assignee, due date, and priority
2. WHEN a task is created, THE Notification_Service SHALL send a WhatsApp notification to the assigned employee
3. WHEN an employee views their dashboard, THE Mobile_App SHALL display all tasks assigned to them ordered by priority and due date
4. THE Mobile_App SHALL allow employees to mark tasks as in-progress or completed
5. WHEN a task is marked as completed, THE HRIS_Service SHALL notify the task creator
6. WHEN a task is overdue, THE Notification_Service SHALL send a reminder notification to the employee and their supervisor
7. THE Mobile_App SHALL allow attaching photos or documents as task completion proof
8. THE Mobile_App SHALL display task completion statistics for each employee
9. WHEN a Kepala_Cabang views task list, THE Mobile_App SHALL display all tasks for their branch with status filters

### Requirement 12: Jadwal Pengiriman

**User Story:** As a Kepala Cabang or Driver, I want to manage delivery schedules, so that deliveries are organized and tracked efficiently.

#### Acceptance Criteria

1. WHEN a Kepala_Cabang creates a delivery schedule, THE Operational_Service SHALL record delivery details including customer name, address, items, and scheduled time
2. WHEN a delivery is created, THE Notification_Service SHALL notify the assigned Driver via WhatsApp
3. WHEN a Driver views their dashboard, THE Mobile_App SHALL display today's deliveries ordered by scheduled time
4. THE Mobile_App SHALL provide route optimization suggestions for multiple deliveries
5. THE Mobile_App SHALL integrate with maps application for navigation to delivery addresses
6. WHEN a Driver marks a delivery as completed, THE Mobile_App SHALL require a photo proof of delivery
7. THE Operational_Service SHALL update delivery status in real-time
8. WHEN a delivery is delayed or failed, THE Mobile_App SHALL allow the Driver to add notes and reschedule
9. THE Mobile_App SHALL track delivery completion time and calculate delivery performance metrics
10. WHEN a Kepala_Cabang views delivery reports, THE Mobile_App SHALL display delivery statistics and performance for their branch

### Requirement 13: CRM - Manajemen Prospek

**User Story:** As a Sales, I want to manage prospect data and track sales pipeline, so that I can convert prospects into customers effectively.

#### Acceptance Criteria

1. WHEN a Sales adds a new prospect, THE CRM_Service SHALL record prospect details including name, phone, email, product interest, and source
2. THE CRM_Service SHALL assign a unique prospect ID to each new prospect
3. THE Mobile_App SHALL allow categorizing prospects by status (new, contacted, negotiation, closed, lost)
4. WHEN a Sales updates prospect status, THE CRM_Service SHALL record the status change with timestamp
5. THE Mobile_App SHALL allow adding notes and interaction history for each prospect
6. THE Mobile_App SHALL allow setting follow-up reminders for prospects
7. WHEN a follow-up reminder is due, THE Notification_Service SHALL send a notification to the Sales
8. THE Mobile_App SHALL display prospect conversion funnel statistics
9. THE CRM_Service SHALL prevent duplicate prospects based on phone number
10. THE Mobile_App SHALL allow offline prospect data entry with sync when online

### Requirement 14: WhatsApp Bulk Messaging

**User Story:** As a Sales or Kepala Cabang, I want to send bulk WhatsApp messages to prospects, so that I can reach multiple customers efficiently for marketing campaigns.

#### Acceptance Criteria

1. WHEN a user creates a bulk message campaign, THE CRM_Service SHALL validate the recipient list and message content
2. THE CRM_Service SHALL implement rate limiting to prevent WhatsApp number blocking (maximum 20 messages per minute)
3. WHEN a campaign is started, THE WhatsApp_Gateway SHALL queue messages in Redis for controlled delivery
4. THE WhatsApp_Gateway SHALL send messages with personalized content using prospect data (name, product interest)
5. THE CRM_Service SHALL track message delivery status (sent, delivered, read, failed)
6. WHEN a message fails to send, THE CRM_Service SHALL retry up to 3 times with exponential backoff
7. THE Mobile_App SHALL display campaign progress and delivery statistics in real-time
8. THE CRM_Service SHALL record campaign results including delivery rate, read rate, and response rate
9. THE Mobile_App SHALL allow scheduling campaigns for future execution
10. THE CRM_Service SHALL prevent sending duplicate messages to the same prospect within 24 hours

### Requirement 15: WhatsApp AI Chatbot

**User Story:** As a customer, I want to interact with an AI chatbot via WhatsApp, so that I can get quick answers to common questions without waiting for human response.

#### Acceptance Criteria

1. WHEN a customer sends a message to the business WhatsApp number, THE WhatsApp_Gateway SHALL forward the message to N8N_Service
2. THE N8N_Service SHALL process the message using AI to understand customer intent
3. WHEN the AI identifies a common question, THE N8N_Service SHALL generate an appropriate response and send it via WhatsApp_Gateway
4. WHEN the AI cannot handle the query, THE N8N_Service SHALL route the conversation to a human Sales representative
5. THE N8N_Service SHALL maintain conversation context for multi-turn interactions
6. THE CRM_Service SHALL automatically create a prospect record from chatbot interactions if the customer provides contact information
7. THE N8N_Service SHALL handle product inquiries by providing information about Aki, TV, and HP products
8. THE N8N_Service SHALL handle business hours inquiries by providing branch locations and operating hours
9. THE CRM_Service SHALL log all chatbot interactions for quality monitoring and training
10. THE N8N_Service SHALL support Indonesian language for natural conversation

### Requirement 16: Notifikasi Reminder

**User Story:** As a Kepala Cabang, I want automatic reminders sent to employees for pending tasks, so that deadlines are met and work is completed on time.

#### Acceptance Criteria

1. THE Notification_Service SHALL check for overdue tasks every hour
2. WHEN a task is overdue, THE Notification_Service SHALL send a WhatsApp reminder to the assigned employee
3. WHEN a task is due within 2 hours, THE Notification_Service SHALL send a proactive reminder to the employee
4. WHEN an employee has not submitted attendance by 9 AM, THE Notification_Service SHALL send a reminder
5. WHEN a work report is pending approval for more than 24 hours, THE Notification_Service SHALL remind the Kepala_Cabang
6. WHEN stock level reaches the alert threshold, THE Notification_Service SHALL notify the Admin and Kepala_Cabang
7. THE Notification_Service SHALL send daily summary notifications to Kepala_Cabang at end of business day
8. THE Notification_Service SHALL send weekly performance summary to Owner every Monday morning
9. THE Mobile_App SHALL allow users to configure notification preferences
10. THE Notification_Service SHALL respect quiet hours (10 PM - 7 AM) and queue notifications for next business hour

### Requirement 17: Dashboard Growth Sosial Media

**User Story:** As an Owner or Kepala Cabang, I want to monitor social media performance across all branch accounts, so that I can track digital marketing effectiveness.

#### Acceptance Criteria

1. WHEN an Owner accesses social media dashboard, THE Social_Service SHALL display aggregated metrics from all branch social media accounts
2. THE Social_Service SHALL integrate with Meta API to fetch Instagram and Facebook metrics
3. THE Social_Service SHALL integrate with TikTok API to fetch TikTok metrics
4. THE Mobile_App SHALL display follower growth trends with daily, weekly, and monthly views
5. THE Mobile_App SHALL display engagement metrics (likes, comments, shares) for each platform
6. THE Mobile_App SHALL display reach and impressions for recent posts
7. THE Mobile_App SHALL display ad campaign performance metrics (spend, reach, conversions)
8. THE Social_Service SHALL refresh social media data every 6 hours
9. THE Mobile_App SHALL allow comparing performance across different branches
10. THE Mobile_App SHALL display top-performing posts for each platform

### Requirement 18: Audit Log dan Transparansi

**User Story:** As an Owner, I want comprehensive audit logs of all data changes, so that I can ensure data integrity and investigate any suspicious activities.

#### Acceptance Criteria

1. WHEN any user modifies critical data (inventory, attendance, tasks, prospects), THE System SHALL create an Audit_Log entry
2. THE Audit_Log SHALL record user ID, timestamp, action type (create, update, delete), entity type, entity ID, old value, and new value
3. THE Audit_Log SHALL be immutable and cannot be deleted or modified by any user
4. WHEN an Owner views audit logs, THE Mobile_App SHALL display logs with filtering by date range, user, and action type
5. THE Mobile_App SHALL allow searching audit logs by entity ID or user name
6. THE Backend_Service SHALL store audit logs in a separate database table with retention policy of 2 years
7. THE Mobile_App SHALL display audit log details including before and after values for data changes
8. THE System SHALL log all authentication attempts (successful and failed)
9. THE System SHALL log all RBAC permission denials
10. THE Mobile_App SHALL allow exporting audit logs as CSV for external analysis

### Requirement 19: Offline-First Capability

**User Story:** As a field employee, I want the mobile app to work offline, so that I can continue working even with poor or no internet connection.

#### Acceptance Criteria

1. WHEN the Mobile_App detects no internet connection, THE Mobile_App SHALL switch to offline mode automatically
2. THE Mobile_App SHALL cache dashboard data for offline viewing with last sync timestamp
3. THE Mobile_App SHALL allow creating attendance records offline and sync when connection is restored
4. THE Mobile_App SHALL allow creating work reports offline with photos and sync when online
5. THE Mobile_App SHALL allow viewing assigned tasks offline
6. THE Mobile_App SHALL allow marking tasks as completed offline and sync status when online
7. THE Mobile_App SHALL allow viewing delivery schedules offline
8. THE Mobile_App SHALL queue all offline actions and sync in chronological order when connection is restored
9. WHEN sync conflicts occur, THE Mobile_App SHALL notify the user and provide conflict resolution options
10. THE Mobile_App SHALL display sync status indicator showing pending offline actions count

### Requirement 20: Laporan Otomatis ke Owner

**User Story:** As an Owner, I want to receive automated daily and weekly performance reports, so that I stay informed without manually checking the system.

#### Acceptance Criteria

1. THE Notification_Service SHALL generate a daily performance report at 6 PM every business day
2. THE daily report SHALL include total sales, attendance summary, pending tasks, and low stock alerts for all branches
3. THE Notification_Service SHALL generate a weekly performance report every Monday at 8 AM
4. THE weekly report SHALL include sales trends, top-performing branches, employee performance summary, and inventory status
5. THE Notification_Service SHALL format reports as PDF documents
6. THE Notification_Service SHALL send reports to Owner via WhatsApp
7. THE Notification_Service SHALL store generated reports in Object_Storage for future reference
8. THE Mobile_App SHALL allow Owner to access historical reports from the past 3 months
9. THE Notification_Service SHALL include visual charts and graphs in PDF reports
10. THE Owner SHALL be able to configure report frequency and content preferences

### Requirement 21: Internal Chat dan Memo

**User Story:** As an employee, I want to communicate with colleagues within the app, so that work-related communication is centralized and not mixed with personal chats.

#### Acceptance Criteria

1. WHEN a user sends a message, THE HRIS_Service SHALL deliver the message to the recipient in real-time
2. THE Mobile_App SHALL support one-on-one chat between employees
3. THE Mobile_App SHALL support group chats for branch teams
4. THE Mobile_App SHALL allow Kepala_Cabang to broadcast announcements to all branch employees
5. THE Mobile_App SHALL support sending text, photos, and documents in chats
6. THE HRIS_Service SHALL store chat messages in Database with encryption
7. THE Mobile_App SHALL display unread message count on the chat icon
8. THE Mobile_App SHALL send push notifications for new messages when app is in background
9. THE Mobile_App SHALL allow searching chat history by keyword
10. THE HRIS_Service SHALL retain chat messages for 90 days for compliance

### Requirement 22: Data Security dan Enkripsi

**User Story:** As a system administrator, I want all sensitive data to be encrypted, so that customer and business information is protected from unauthorized access.

#### Acceptance Criteria

1. THE Backend_Service SHALL encrypt all passwords using bcrypt with minimum 12 rounds
2. THE Backend_Service SHALL encrypt JWT tokens and validate signature on every request
3. THE Database SHALL encrypt sensitive fields (phone numbers, addresses, financial data) at rest
4. THE Mobile_App SHALL use HTTPS/TLS for all API communications
5. THE Backend_Service SHALL implement rate limiting to prevent brute force attacks (maximum 5 failed login attempts per 15 minutes)
6. THE Backend_Service SHALL sanitize all user inputs to prevent SQL injection attacks
7. THE Backend_Service SHALL implement CORS policy to restrict API access to authorized domains
8. THE Object_Storage SHALL use signed URLs with expiration for accessing sensitive files
9. THE Backend_Service SHALL log all security events (failed logins, permission denials, suspicious activities)
10. THE System SHALL comply with data protection regulations for customer data handling

### Requirement 23: Performance dan Scalability

**User Story:** As a system administrator, I want the system to handle growing data and users efficiently, so that performance remains consistent as the business expands.

#### Acceptance Criteria

1. THE Backend_Service SHALL respond to API requests within 200ms for 95% of requests under normal load
2. THE Cache SHALL store frequently accessed data (dashboard metrics, user sessions) to reduce database load
3. THE Backend_Service SHALL implement database connection pooling with minimum 10 and maximum 50 connections
4. THE Backend_Service SHALL use database indexes on frequently queried fields (user_id, branch_id, date ranges)
5. THE Backend_Service SHALL implement pagination for list endpoints with maximum 50 items per page
6. THE Mobile_App SHALL implement lazy loading for long lists and image galleries
7. THE Backend_Service SHALL compress API responses using gzip for payloads larger than 1KB
8. THE System SHALL support horizontal scaling by deploying multiple Backend_Service instances behind a load balancer
9. THE Cache SHALL implement cache invalidation strategy to ensure data consistency
10. THE Backend_Service SHALL implement background jobs for heavy operations (report generation, bulk messaging) using job queue

### Requirement 24: Employee Performance Monitoring and Ranking

**User Story:** As an Owner, I want to monitor employee performance with rankings for Sales and non-Sales staff, so that I can identify top performers and provide targeted support to underperformers.

#### Acceptance Criteria

1. THE Backend_Service SHALL calculate performance metrics for Sales employees based on prospects converted, revenue generated, and conversion rate
2. THE Backend_Service SHALL calculate performance metrics for non-Sales employees (Admin, Driver) based on task completion rate, attendance punctuality, and work report quality
3. THE Backend_Service SHALL generate rankings for Sales employees across all branches
4. THE Backend_Service SHALL generate rankings for non-Sales employees across all branches
5. THE Mobile_App SHALL display top 10 Sales performers with their metrics (prospects converted, revenue, conversion rate)
6. THE Mobile_App SHALL display bottom 5 Sales performers with their metrics
7. THE Mobile_App SHALL display top 10 non-Sales performers with their metrics (task completion rate, attendance rate, punctuality score)
8. THE Mobile_App SHALL display bottom 5 non-Sales performers with their metrics
9. THE Mobile_App SHALL allow filtering rankings by time period (daily, weekly, monthly, quarterly, yearly)
10. THE Mobile_App SHALL allow filtering rankings by branch
11. THE Mobile_App SHALL display performance trends for each employee (improving, declining, stable)
12. THE Mobile_App SHALL allow Owner to drill down into individual employee performance details
13. THE Backend_Service SHALL update performance metrics daily at midnight
14. THE Mobile_App SHALL display performance comparison charts (bar charts, line charts)
15. THE Mobile_App SHALL allow exporting performance reports as PDF

### Requirement 25: Deployment dan Infrastructure

**User Story:** As a system administrator, I want the system to be deployed using containers, so that deployment is consistent and scalable across environments.

#### Acceptance Criteria

1. THE Backend_Service SHALL be containerized using Docker with multi-stage builds
2. THE deployment SHALL use Docker Compose for local development environment
3. THE deployment SHALL use Kubernetes or Docker Swarm for production environment
4. THE Database SHALL run in a separate container with persistent volume for data storage
5. THE Cache SHALL run in a separate container with appropriate memory allocation
6. THE deployment SHALL include health check endpoints for all services
7. THE deployment SHALL implement automated backup for Database every 6 hours
8. THE deployment SHALL include monitoring and logging using Prometheus and Grafana
9. THE deployment SHALL implement zero-downtime deployment using rolling updates
10. THE deployment SHALL include disaster recovery plan with backup restoration procedures
