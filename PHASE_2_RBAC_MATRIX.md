# Phase 2 RBAC Matrix (Pasien, Dokter, Admin)

Dokumen ini adalah referensi izin akses lintas platform untuk Firebase Auth + Firestore.

## 1) Prinsip Dasar

1. Otorisasi utama berbasis custom claim `role`.
2. Dokumen `users.role` dipakai untuk UI/read model, bukan sumber validasi final.
3. Semua aksi sensitif (`admin`, assign, moderation) wajib lewat Cloud Functions.
4. Least privilege: role hanya dapat akses yang diperlukan.

---

## 2) Roles

- `pasien`
- `dokter`
- `admin`
- `system` (service account / Cloud Functions)

---

## 3) Global Permission Summary

| Capability | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Login | ✅ | ✅ | ✅ | ✅ |
| Read own user profile | ✅ | ✅ | ✅ | ✅ |
| Update own basic profile | ✅ | ✅ | ✅ | ✅ |
| Manage user lifecycle | ❌ | ❌ | ✅ | ✅ |
| Approve pasien | ❌ | ✅ (scope) | ✅ | ✅ |
| Assign konten | ❌ | ✅ (scope) | ✅ | ✅ |
| Manage konten publish | ❌ | ✅ (own/scope) | ✅ | ✅ |
| Read chat session scope | ✅ (own) | ✅ (scope) | ✅ | ✅ |
| Read all audit logs | ❌ | ❌ | ✅ | ✅ |

---

## 4) Collection-Level Matrix

## 4.1 users/{uid}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | self-only (register path) | self-only | via invitation/create | ✅ |
| Read | own | own | any | ✅ |
| Update basic fields (`displayName`, `photoUrl`) | own | own | any | ✅ |
| Update role/status/permissions | ❌ | ❌ | via function only | ✅ |
| Delete | self (deactivate preferred) | self (deactivate preferred) | admin flow | ✅ |

## 4.2 pasien_profiles/{uid}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | self | ❌ | ✅ | ✅ |
| Read | own | if assigned (`assignedDokterId == auth.uid`) | any | ✅ |
| Update | own editable fields only | medical/assignment fields in scope | any | ✅ |
| Delete | ❌ | ❌ | soft delete policy | ✅ |

## 4.3 dokter_profiles/{uid}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | ❌ | self | ✅ | ✅ |
| Read | assigned dokter only / public subset | own | any | ✅ |
| Update | ❌ | own | any | ✅ |
| Delete | ❌ | ❌ | soft delete policy | ✅ |

## 4.4 konten/{kontenId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | ❌ | ✅ | ✅ | ✅ |
| Read draft | ❌ | owner/scope | any | ✅ |
| Read published | if assigned/relevant | ✅ | ✅ | ✅ |
| Update | ❌ | owner/scope | any | ✅ |
| Publish/Unpublish | ❌ | owner/scope + validation | ✅ | ✅ |
| Delete | ❌ | owner/scope | ✅ | ✅ |

## 4.5 konten/{kontenId}/sections/{sectionId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Read | if konten assigned/published allowed | ✅ | ✅ | ✅ |
| Write | ❌ | owner/scope | ✅ | ✅ |

## 4.6 assignments/{assignmentId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | ❌ | via function | via function | ✅ |
| Read | own | assigned doctor scope | any | ✅ |
| Update progress | own, limited fields | scope fields | any | ✅ |
| Complete/close/reassign | ❌ direct | via function | via function | ✅ |
| Delete | ❌ | via function | via function | ✅ |

## 4.7 reading_sessions/{sessionId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | own | ❌ | ✅ | ✅ |
| Read | own | assigned doctor scope | any | ✅ |
| Update/End | own session only | ❌ | ✅ | ✅ |

## 4.8 quiz_results/{resultId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | own | ❌ | ✅ | ✅ |
| Read | own | assigned doctor scope | any | ✅ |
| Update | restricted/self correction limited | ❌ | ✅ | ✅ |

## 4.9 chat_sessions/{sessionId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | own pair only | own pair only | ✅ | ✅ |
| Read | participant only | participant only | any | ✅ |
| Update session metadata | participant limited | participant limited | ✅ | ✅ |

## 4.10 chat_sessions/{sessionId}/messages/{messageId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | participant only | participant only | ✅ | ✅ |
| Read | participant only | participant only | any | ✅ |
| Update `isRead` | receiver only | receiver only | ✅ | ✅ |
| Delete | sender within policy window | sender within policy window | ✅ | ✅ |

## 4.11 notifications/{notificationId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | ❌ | ❌ | via function | ✅ |
| Read | own | own | any | ✅ |
| Update `isRead` | own | own | any | ✅ |
| Delete | own (soft delete preferred) | own | any | ✅ |

## 4.12 admin_audit_logs/{logId}

| Action | Pasien | Dokter | Admin | System |
|---|---:|---:|---:|---:|
| Create | ❌ | ❌ | ❌ direct | ✅ only |
| Read | ❌ | ❌ | ✅ | ✅ |
| Update/Delete | ❌ | ❌ | ❌ | ❌ |

---

## 5) Platform Guard Mapping

- Mobile Flutter:
  - hanya role `pasien`.
  - jika role bukan pasien → logout + halaman info.

- Desktop Web/App:
  - role `dokter` dan `admin`.
  - role pasien ditolak di entry desktop.

---

## 6) Claim Contract

Custom claims minimal:

- `role`: `pasien | dokter | admin`
- `hospitalId`: string
- `permissions`: string[] (opsional granular)
- `isActive`: bool

---

## 7) Catatan Implementasi

1. Gunakan callable function `adminSetRole()` untuk perubahan role.
2. Semua operasi moderation konten memanggil function agar audit trail konsisten.
3. Tambahkan emulator tests untuk setiap rule penting (allow/deny).
