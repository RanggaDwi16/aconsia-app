using System.Text.Json.Serialization;

namespace ACONSIA.Models;

public class Doctor
{
    [JsonPropertyName("id")]
    public string Id { get; set; } = string.Empty;

    [JsonPropertyName("namaLengkap")]
    public string NamaLengkap { get; set; } = string.Empty;

    [JsonPropertyName("email")]
    public string Email { get; set; } = string.Empty;

    [JsonPropertyName("password")]
    public string Password { get; set; } = string.Empty;

    [JsonPropertyName("nomorSTR")]
    public string NomorSTR { get; set; } = string.Empty;

    [JsonPropertyName("spesialisasi")]
    public string Spesialisasi { get; set; } = string.Empty;

    [JsonPropertyName("rumahSakit")]
    public string RumahSakit { get; set; } = string.Empty;

    [JsonPropertyName("createdAt")]
    public string CreatedAt { get; set; } = DateTime.Now.ToString("o");
}
