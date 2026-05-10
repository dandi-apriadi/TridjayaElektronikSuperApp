import json

# Read the extracted jobdesk data
with open('jobdesk_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Map Excel sheet names to app role keys
role_map = {
    'KOORD GUNAWAN': ('koordinator', 'Job Desk Koordinator Harian'),
    'TAUFIK SUPPORT ELEKTRONIK': ('support_elektronik', 'Job Desk Support Elektronik Harian'),
    'SALES ELEKTRONIK': ('sales', 'Job Desk Sales Elektronik Harian'),
    'DRIVER': ('driver', 'Job Desk Driver Harian'),
    'PDI': ('pdi', 'Job Desk PDI Harian'),
    'ADMIN PENCAIRAN': ('admin_pencairan', 'Job Desk Admin Pencairan Harian'),
    'ADMIN SPK': ('admin_spk', 'Job Desk Admin SPK Harian'),
    'KASIR': ('kasir', 'Job Desk Kasir Harian'),
    'ADM STOK': ('admin_stok', 'Job Desk Admin Stok Harian'),
    'Support Konten': ('support_konten', 'Job Desk Support Konten Harian'),
    'selvia': ('admin_general', 'Job Desk Admin General Harian'),
    'Support Online': ('support_online', 'Job Desk Support Online Harian'),
    'Support event': ('support_event', 'Job Desk Support Event Harian'),
    'KRISNA': ('supervisor', 'Job Desk Supervisor Harian'),
    'GC': ('general_cashier', 'Job Desk General Cashier Harian'),
    'support mp': ('support_marketplace', 'Job Desk Support Marketplace Harian'),
    'onwil': ('onwil', 'Job Desk ON Wilayah Harian'),
    'crm': ('crm', 'Job Desk CRM Harian'),
    'poling': ('poling', 'Job Desk Poling Harian'),
    'desk call': ('desk_call', 'Job Desk Desk Call Harian'),
}

lines = []
lines.append("/// ============================================================")
lines.append("/// 📋 JOB DESK SYSTEM - DUMMY DATA")
lines.append("/// Data dari file JOBDESK HARIAN TE.xlsx (20 Divisi)")
lines.append("/// ============================================================")
lines.append("")
lines.append("import '../models/jobdesk_models.dart';")
lines.append("")
lines.append("class JobDeskDummyData {")

template_names = []

for sheet_name, tasks in data.items():
    if sheet_name not in role_map:
        continue
    role_key, display_name = role_map[sheet_name]
    var_name = f"{role_key}Template"
    template_names.append((var_name, role_key))

    lines.append(f"  static final {var_name} = JobDeskTemplate(")
    lines.append(f"    id: 'tpl_{role_key}_001',")
    lines.append(f"    role: '{role_key}',")
    lines.append(f"    name: '{display_name}',")
    lines.append(f"    isActive: true,")
    lines.append(f"    tasks: [")

    for i, t in enumerate(tasks):
        task_name = t['task'].replace("'", "\\'")
        lines.append(f"      JobDeskTaskItem(id: '{role_key}_{i+1:03d}', taskName: '{task_name}', sortOrder: {i+1}),")

    lines.append("    ],")
    lines.append("  );")
    lines.append("")

# allTemplates
lines.append("  static List<JobDeskTemplate> get allTemplates => [")
for vn, _ in template_names:
    lines.append(f"    {vn},")
lines.append("  ];")
lines.append("")

# getTemplateByRole
lines.append("  static JobDeskTemplate getTemplateByRole(String role) {")
lines.append("    switch (role) {")
for vn, rk in template_names:
    lines.append(f"      case '{rk}': return {vn};")
lines.append("      default: return salesTemplate;")
lines.append("    }")
lines.append("  }")
lines.append("")

# getDummySubmissionsForToday
lines.append("  static List<JobDeskSubmission> getDummySubmissionsForToday(JobDeskTemplate template) {")
lines.append("    return template.tasks.map((task) {")
lines.append("      final isCompleted = task.sortOrder % 3 != 0;")
lines.append("      return JobDeskSubmission(")
lines.append("        id: 'sub_\${task.id}_\${DateTime.now().millisecondsSinceEpoch}',")
lines.append("        assignmentId: 'assign_001',")
lines.append("        taskItemId: task.id,")
lines.append("        submissionDate: DateTime.now(),")
lines.append("        status: isCompleted ? JobDeskStatus.completed : JobDeskStatus.pending,")
lines.append("        actualValue: task.type == JobDeskTaskType.counter && isCompleted ? task.targetValue : null,")
lines.append("        taskItem: task,")
lines.append("      );")
lines.append("    }).toList();")
lines.append("  }")
lines.append("")

# getDummySubmissionsHistory
lines.append("  static List<JobDeskSubmission> getDummySubmissionsHistory() => [];")
lines.append("")

# getDummyEmployeeSummaries
lines.append("  static List<JobDeskEmployeeSummary> getDummyEmployeeSummaries() => [")
lines.append("    JobDeskEmployeeSummary(userId: 'e1', userName: 'Ahmad', role: 'Sales', branchName: 'Sam Ratulangi', totalTasks: 17, completedToday: 14, pendingToday: 3, completionRate: 82.3, streakDays: 5),")
lines.append("    JobDeskEmployeeSummary(userId: 'e2', userName: 'Budi', role: 'Driver', branchName: 'Bahu', totalTasks: 14, completedToday: 12, pendingToday: 2, completionRate: 85.7, streakDays: 3),")
lines.append("  ];")
lines.append("")

# getDummyVerificationQueue
lines.append("  static List<JobDeskVerificationQueueItem> getDummyVerificationQueue() => [")
lines.append("    JobDeskVerificationQueueItem(submissionId: 's1', userId: 'e1', userName: 'Ahmad', userAvatar: 'A', submissionDate: DateTime.now(), submittedAt: DateTime.now(), taskName: 'Follow up prospek', taskType: JobDeskTaskType.checkbox, totalProofs: 1),")
lines.append("  ];")

lines.append("}")
lines.append("")

output = "\n".join(lines)
out_path = '../mobile/lib/features/jobdesk/data/jobdesk_dummy_data.dart'
with open(out_path, 'w', encoding='utf-8') as f:
    f.write(output)

print(f"Generated {len(template_names)} templates to {out_path}")
for vn, rk in template_names:
    print(f"  - {rk}")
