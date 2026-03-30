using System.Text.Json;
using ACONSIA.Models;

namespace ACONSIA.Services;

public class StorageService
{
    private const string DoctorsKey = "doctors";
    private const string PatientsKey = "patients";
    private const string CurrentUserRoleKey = "userRole";
    private const string CurrentPatientKey = "currentPatient";
    private const string CurrentDoctorKey = "currentDoctor";
    private const string DemoInitializedKey = "demoInitialized";

    // Initialize demo data
    public void InitializeDemoData()
    {
        var initialized = Preferences.Get(DemoInitializedKey, false);

        if (!initialized)
        {
            // Create demo doctor
            var demoDoctor = new Doctor
            {
                Id = "DOC001",
                NamaLengkap = "Ahmad Fauzi",
                Email = "dokter@aconsia.com",
                Password = "dokter123",
                NomorSTR = "STR123456789",
                Spesialisasi = "Anestesiologi",
                RumahSakit = "RS Umum Pusat",
                CreatedAt = DateTime.Now.ToString("o")
            };

            // Create demo patient
            var demoPatient = new Patient
            {
                MRN = "MRN001",
                NamaLengkap = "Budi Santoso",
                NomorTelepon = "081234567890",
                Email = "budi@email.com",
                Status = "pending",
                CreatedAt = DateTime.Now.ToString("o")
            };

            SaveDoctors(new List<Doctor> { demoDoctor });
            SavePatients(new List<Patient> { demoPatient });
            Preferences.Set(DemoInitializedKey, true);

            System.Diagnostics.Debug.WriteLine("✅ Demo data initialized!");
            System.Diagnostics.Debug.WriteLine("📧 Doctor: dokter@aconsia.com / dokter123");
            System.Diagnostics.Debug.WriteLine("🏥 Patient: MRN001");
        }
    }

    // ========== DOCTORS ==========

    public List<Doctor> GetDoctors()
    {
        var json = Preferences.Get(DoctorsKey, "[]");
        return JsonSerializer.Deserialize<List<Doctor>>(json) ?? new List<Doctor>();
    }

    public void SaveDoctors(List<Doctor> doctors)
    {
        var json = JsonSerializer.Serialize(doctors);
        Preferences.Set(DoctorsKey, json);
    }

    public void AddDoctor(Doctor doctor)
    {
        var doctors = GetDoctors();
        doctors.Add(doctor);
        SaveDoctors(doctors);
    }

    public Doctor? FindDoctorByEmail(string email, string password)
    {
        var doctors = GetDoctors();
        return doctors.FirstOrDefault(d => d.Email == email && d.Password == password);
    }

    // ========== PATIENTS ==========

    public List<Patient> GetPatients()
    {
        var json = Preferences.Get(PatientsKey, "[]");
        return JsonSerializer.Deserialize<List<Patient>>(json) ?? new List<Patient>();
    }

    public void SavePatients(List<Patient> patients)
    {
        var json = JsonSerializer.Serialize(patients);
        Preferences.Set(PatientsKey, json);
    }

    public void AddPatient(Patient patient)
    {
        var patients = GetPatients();
        patients.Add(patient);
        SavePatients(patients);
    }

    public Patient? FindPatientByMRN(string mrn)
    {
        var patients = GetPatients();
        return patients.FirstOrDefault(p => p.MRN == mrn);
    }

    public void UpdatePatient(string mrn, Patient updatedPatient)
    {
        var patients = GetPatients();
        var index = patients.FindIndex(p => p.MRN == mrn);

        if (index != -1)
        {
            patients[index] = updatedPatient;
            SavePatients(patients);
        }
    }

    public List<Patient> GetPatientsByStatus(string status)
    {
        var patients = GetPatients();
        return patients.Where(p => p.Status == status).ToList();
    }

    // ========== USER SESSION ==========

    public void SaveUserRole(string role)
    {
        Preferences.Set(CurrentUserRoleKey, role);
    }

    public string? GetUserRole()
    {
        return Preferences.Get(CurrentUserRoleKey, null);
    }

    public void SaveCurrentPatient(Patient patient)
    {
        var json = JsonSerializer.Serialize(patient);
        Preferences.Set(CurrentPatientKey, json);
    }

    public Patient? GetCurrentPatient()
    {
        var json = Preferences.Get(CurrentPatientKey, null);
        if (!string.IsNullOrEmpty(json))
        {
            return JsonSerializer.Deserialize<Patient>(json);
        }
        return null;
    }

    public void SaveCurrentDoctor(Doctor doctor)
    {
        var json = JsonSerializer.Serialize(doctor);
        Preferences.Set(CurrentDoctorKey, json);
    }

    public Doctor? GetCurrentDoctor()
    {
        var json = Preferences.Get(CurrentDoctorKey, null);
        if (!string.IsNullOrEmpty(json))
        {
            return JsonSerializer.Deserialize<Doctor>(json);
        }
        return null;
    }

    public void Logout()
    {
        Preferences.Remove(CurrentUserRoleKey);
        Preferences.Remove(CurrentPatientKey);
        Preferences.Remove(CurrentDoctorKey);
    }

    public void ClearAll()
    {
        Preferences.Clear();
        InitializeDemoData();
    }
}
