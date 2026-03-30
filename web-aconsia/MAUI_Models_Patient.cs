using System.Text.Json.Serialization;

namespace ACONSIA.Models;

public class Patient
{
    [JsonPropertyName("mrn")]
    public string MRN { get; set; } = string.Empty;

    [JsonPropertyName("namaLengkap")]
    public string NamaLengkap { get; set; } = string.Empty;

    [JsonPropertyName("nomorTelepon")]
    public string NomorTelepon { get; set; } = string.Empty;

    [JsonPropertyName("email")]
    public string Email { get; set; } = string.Empty;

    [JsonPropertyName("status")]
    public string Status { get; set; } = "pending"; // pending, approved, rejected

    [JsonPropertyName("anesthesiaType")]
    public string? AnesthesiaType { get; set; }

    [JsonPropertyName("doctorName")]
    public string? DoctorName { get; set; }

    [JsonPropertyName("surgeryDate")]
    public string? SurgeryDate { get; set; }

    [JsonPropertyName("comprehensionScore")]
    public int ComprehensionScore { get; set; } = 0;

    [JsonPropertyName("createdAt")]
    public string CreatedAt { get; set; } = DateTime.Now.ToString("o");

    [JsonPropertyName("approvalDate")]
    public string? ApprovalDate { get; set; }

    [JsonPropertyName("rejectionReason")]
    public string? RejectionReason { get; set; }
}
