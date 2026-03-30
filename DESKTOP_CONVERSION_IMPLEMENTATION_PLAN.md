# Desktop Conversion Implementation Plan (web-aconsia -> Production)

Target: mengubah UI web-aconsia menjadi desktop app produksi untuk role dokter + admin.

## 1) Target Architecture

## 1.1 App Layers

1. `Presentation` (pages/components)
2. `Application` (use-cases + orchestration)
3. `Data` (Firebase adapters)
4. `Core` (auth guard, error handling, telemetry)

## 1.2 Module Boundaries

- `modules/auth`
- `modules/doctor`
- `modules/admin`
- `modules/shared`

## 1.3 Role Guard

- route `/doctor/*`: hanya role `dokter` atau `admin`.
- route `/admin/*`: hanya role `admin`.
- role `pasien` ditolak di desktop entry.

---

## 2) Current Gaps (berdasarkan audit)

1. localStorage demo data masih dominan.
2. auth belum ke Firebase production flow.
3. belum ada centralized data service/repository.
4. belum ada audit log integration.
5. belum ada hard permission checks per action.

---

## 3) Technical Blueprint

## 3.1 Folder Refactor (disarankan)

- `src/core/firebase/` (init, converters)
- `src/core/auth/` (`authService`, `claims`, `guards`)
- `src/core/errors/`
- `src/core/telemetry/`
- `src/modules/doctor/`
- `src/modules/admin/`
- `src/modules/shared/`

## 3.2 Data Access Pattern

Gunakan repository pattern ringan:

- `DoctorRepository`
- `AdminRepository`
- `AssignmentRepository`
- `ContentRepository`
- `ChatRepository`

Setiap repository return object hasil standar:
- `ok: boolean`
- `data`
- `errorCode`
- `message`

---

## 4) Epic Breakdown

## Epic A - Auth & Session (Week 1)

Deliverables:
- Firebase Auth login dokter/admin.
- Session persistence aman.
- Custom claims verification pada login.
- Route guard full.

Tasks:
1. Buat `authService`.
2. Buat `useCurrentUser` hook.
3. Implement `ProtectedRoute` role-aware.
4. Replace login localStorage -> Firebase sign-in.
5. Logout cleanup.

Acceptance:
- user `dokter` tidak bisa buka `/admin`.
- user `pasien` tidak bisa login desktop.

## Epic B - Doctor Module Firestore Integration (Week 2-3)

Deliverables:
- Dashboard dokter dari Firestore.
- Patient approval workflow real.
- Assign konten workflow real.
- Progress monitoring real-time.

Tasks:
1. Query pasien scope dokter.
2. Implement approve + set anestesi via callable function.
3. Integrasi assignment create/update.
4. Integrasi monitoring progress + quiz summary.
5. Realtime update via snapshot listeners.

Acceptance:
- data dashboard 100% dari Firestore.
- assignment update tercermin di mobile pasien.

## Epic C - Admin Module Firestore Integration (Week 3-4)

Deliverables:
- Admin dashboard real data.
- User lifecycle management.
- Content moderation.
- Audit trail viewer.

Tasks:
1. CRUD user status (via function).
2. Moderation publish/unpublish konten.
3. Audit logs list + filter + export CSV.
4. Reporting cards + trend chart.

Acceptance:
- seluruh aksi admin tercatat di `admin_audit_logs`.

## Epic D - Quality, Security, and UX Hardening (Week 4-5)

Deliverables:
- Error boundary + fallback pages.
- Empty/loading skeleton konsisten.
- Telemetry events + error monitoring.
- E2E smoke tests.

Tasks:
1. Standard loading states.
2. Standard error components.
3. Add client-side event telemetry.
4. Add test scenario critical paths.

Acceptance:
- no uncaught error pada flow utama.
- lighthouse perf and accessibility baseline tercapai.

## Epic E - Optional Desktop Packaging (Week 6)

Deliverables:
- Tauri wrapper build macOS/Windows.
- Installer internal QA.

Tasks:
1. Setup Tauri config.
2. Build signing/internal distribution.
3. Smoke test installer update.

Acceptance:
- installer berjalan stabil di target environment.

---

## 5) Implementation Sequence (Task-by-Task)

1. Hapus seed demo autoload dari bootstrap app.
2. Introduce env config (`FIREBASE_API_KEY`, dst).
3. Implement auth module + protected routes.
4. Migrate doctor dashboard queries.
5. Migrate approval + assignment action.
6. Migrate admin dashboard & audit trail.
7. Remove localStorage dependency dari critical path.
8. Add analytics & error telemetry.
9. Regression test lintas role.

---

## 6) Definition of Done per Feature

- UI sesuai desain.
- Data source bukan mock/localStorage.
- Role guard aktif.
- Action sensitif lewat function.
- Error/loading/empty state tersedia.
- QA scenario pass.

---

## 7) Risk Register

1. Data inconsistency saat transisi localStorage -> Firestore.
- Mitigasi: feature flag + staged rollout.

2. Query berat pada dashboard.
- Mitigasi: index + aggregation strategy.

3. Permission bypass di client.
- Mitigasi: server-side rule + callable function checks.

4. Scope creep admin features.
- Mitigasi: freeze MVP admin scope dulu.

---

## 8) Recommended CI/CD Gates

1. Lint + type-check wajib.
2. Unit tests modules inti.
3. Build verification desktop web.
4. Emulator rule tests backend.
5. Staging UAT sign-off.

---

## 9) Output Akhir Phase 2 (Desktop)

- Desktop app dokter/admin production-ready berbasis web-aconsia.
- Semua data critical via Firebase.
- Security dan audit trail aktif.
- Siap scale ke packaging desktop installer jika dibutuhkan.
