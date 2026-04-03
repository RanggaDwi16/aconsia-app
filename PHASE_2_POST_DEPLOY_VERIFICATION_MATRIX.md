# Phase 2 Post-Deploy Verification Matrix

Tanggal Deploy: ____ / ____ / ______
Environment: [ ] Staging  [ ] Production
Owner: __________________________

## 1) Runtime Health (T+0 sampai T+30m)

| Check | Expected | Status | Evidence |
|---|---|---|---|
| Landing desktop load | Halaman tampil normal | [ ] | __________ |
| Unified login load | Form login tampil & responsif | [ ] | __________ |
| Route guard | Akses route tanpa role ditolak | [ ] | __________ |
| Patient desktop redirect | Semua route `patient/*` redirect | [ ] | __________ |

## 2) Functional Critical Flows (T+30m sampai T+2h)

| Flow | Expected Result | Status | Evidence |
|---|---|---|---|
| Dokter login | Masuk ke dashboard dokter | [ ] | __________ |
| Assign anestesi | `pasien_profiles` update + audit log | [ ] | __________ |
| Approve pasien | Status berubah + audit log | [ ] | __________ |
| Reject pasien | Status berubah + audit log | [ ] | __________ |
| Admin login | Masuk ke dashboard admin | [ ] | __________ |
| Suspend user | `users.status=suspended` + audit | [ ] | __________ |
| Activate user | `users.status=active` + audit | [ ] | __________ |
| Publish konten | `konten.status=published` + audit | [ ] | __________ |
| Unpublish konten | `konten.status=draft` + audit | [ ] | __________ |
| Export reports/audit | File terunduh normal | [ ] | __________ |

## 3) Security & Data Integrity (T+2h sampai T+6h)

| Control | Expected Result | Status | Evidence |
|---|---|---|---|
| Immutable audit | `admin_audit_logs` tidak bisa update/delete client | [ ] | __________ |
| Sensitive direct writes | Ditolak rules untuk client | [ ] | __________ |
| Callable authz | Unauthorized call ditolak | [ ] | __________ |
| Role claims mapping | `doctor/admin` terbaca benar | [ ] | __________ |

## 4) Observability (T+6h sampai T+24h)

| Signal | Threshold | Status | Evidence |
|---|---|---|---|
| Login errors | Tidak ada lonjakan abnormal | [ ] | __________ |
| Callable failures | < 2% dari total call | [ ] | __________ |
| Audit log throughput | Stabil, tidak drop signifikan | [ ] | __________ |
| P95 latency callable | Sesuai baseline tim | [ ] | __________ |

## 5) Decision Gate (T+24h)

- [ ] Lanjut status release = **Stable**
- [ ] Butuh hotfix minor
- [ ] Trigger rollback

Catatan keputusan:
- __________________________________________
- __________________________________________
