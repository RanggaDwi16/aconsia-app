import { useState } from "react";
import { useNavigate } from "react-router";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Badge } from "../../components/ui/badge";
import { 
  ArrowLeft, 
  User, 
  Mail, 
  Phone, 
  Lock,
  Building,
  Award,
  CheckCircle,
  AlertCircle
} from "lucide-react";
import logoImage from "figma:asset/1c448958f0817c176999b741d53bcc5ce9b3930d.png";

export function DoctorRegistration() {
  const navigate = useNavigate();
  
  const [formData, setFormData] = useState({
    fullName: "",
    email: "",
    phone: "",
    sipNumber: "", // Surat Izin Praktik
    strNumber: "", // Surat Tanda Registrasi
    specialization: "Anestesiologi",
    hospital: "",
    password: "",
    confirmPassword: ""
  });

  const [errors, setErrors] = useState<{ [key: string]: string }>({});

  const handleChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    // Clear error when user types
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: "" }));
    }
  };

  const validateForm = () => {
    const newErrors: { [key: string]: string } = {};

    // Full Name
    if (!formData.fullName.trim()) {
      newErrors.fullName = "Nama lengkap wajib diisi";
    } else if (formData.fullName.length < 3) {
      newErrors.fullName = "Nama minimal 3 karakter";
    }

    // Email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!formData.email.trim()) {
      newErrors.email = "Email wajib diisi";
    } else if (!emailRegex.test(formData.email)) {
      newErrors.email = "Format email tidak valid";
    }

    // Phone
    const phoneRegex = /^(\+62|62|0)[0-9]{9,12}$/;
    if (!formData.phone.trim()) {
      newErrors.phone = "No. telepon wajib diisi";
    } else if (!phoneRegex.test(formData.phone)) {
      newErrors.phone = "Format no. telepon tidak valid (08xx atau 62xxx)";
    }

    // SIP Number
    if (!formData.sipNumber.trim()) {
      newErrors.sipNumber = "No. SIP wajib diisi";
    } else if (formData.sipNumber.length < 10) {
      newErrors.sipNumber = "No. SIP minimal 10 karakter";
    }

    // STR Number
    if (!formData.strNumber.trim()) {
      newErrors.strNumber = "No. STR wajib diisi";
    } else if (formData.strNumber.length < 10) {
      newErrors.strNumber = "No. STR minimal 10 karakter";
    }

    // Hospital
    if (!formData.hospital.trim()) {
      newErrors.hospital = "Nama rumah sakit wajib diisi";
    }

    // Password
    if (!formData.password) {
      newErrors.password = "Password wajib diisi";
    } else if (formData.password.length < 6) {
      newErrors.password = "Password minimal 6 karakter";
    }

    // Confirm Password
    if (!formData.confirmPassword) {
      newErrors.confirmPassword = "Konfirmasi password wajib diisi";
    } else if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = "Password tidak cocok";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }

    // Get existing doctors
    const doctors = JSON.parse(localStorage.getItem('doctors') || '[]');
    
    // Check if doctor already exists
    const existingDoctor = doctors.find((d: any) => d.email === formData.email);
    if (existingDoctor) {
      alert("Email sudah terdaftar! Silakan login atau gunakan email lain.");
      return;
    }

    // Generate doctor ID
    const doctorId = `DOC-${Date.now()}`;

    // Create doctor object
    const doctorData = {
      id: doctorId,
      fullName: formData.fullName,
      email: formData.email,
      phone: formData.phone,
      sipNumber: formData.sipNumber,
      strNumber: formData.strNumber,
      specialization: formData.specialization,
      hospital: formData.hospital,
      password: formData.password, // In production, hash this!
      createdAt: new Date().toISOString(),
      status: "active"
    };

    // Add to doctors array
    doctors.push(doctorData);
    
    // Save to localStorage
    localStorage.setItem('doctors', JSON.stringify(doctors));
    localStorage.setItem('userRole', 'doctor');
    localStorage.setItem('currentDoctor', JSON.stringify(doctorData));

    alert("✅ Registrasi berhasil! Selamat datang, Dr. " + formData.fullName);
    navigate('/doctor/dashboard');
  };

  return (
    <div className="min-h-screen bg-white flex flex-col">
      
      {/* Main Content */}
      <div className="flex-1 flex items-center justify-center px-6 py-12">
        <div className="w-full max-w-2xl">
          
          {/* Back Button - Clean */}
          <button
            onClick={() => navigate('/')}
            className="flex items-center gap-2 text-slate-600 hover:text-slate-900 mb-8 transition-colors group"
          >
            <ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform" />
            <span className="font-medium">Kembali</span>
          </button>

          {/* Card Container - Clean with subtle shadow */}
          <div className="bg-white rounded-2xl shadow-lg border border-slate-200 overflow-hidden">
            
            {/* Header - Clean Emerald Solid */}
            <div className="bg-emerald-600 px-8 py-12 text-center">
              <div className="inline-flex items-center justify-center w-20 h-20 bg-white rounded-full mb-4 shadow-md">
                <img 
                  src={logoImage} 
                  alt="ACONSIA Logo" 
                  className="w-14 h-14 object-contain"
                />
              </div>
              
              <h1 className="text-2xl font-bold text-white mb-2">
                Registrasi Dokter
              </h1>
              <p className="text-sm text-emerald-100">
                Daftar sebagai Dokter Spesialis Anestesi
              </p>
            </div>

            {/* Form - Clean & Spacious */}
            <div className="p-8">
              <form onSubmit={handleSubmit} className="space-y-5">
                {/* Full Name */}
                <div className="space-y-2">
                  <Label htmlFor="fullName" className="text-base font-semibold flex items-center gap-2">
                    <User className="w-4 h-4 text-purple-600" />
                    Nama Lengkap <span className="text-red-600">*</span>
                  </Label>
                  <Input
                    id="fullName"
                    placeholder="Dr. Ahmad Suryadi, Sp.An"
                    value={formData.fullName}
                    onChange={(e) => handleChange("fullName", e.target.value)}
                    className={`text-base ${errors.fullName ? "border-red-500" : ""}`}
                  />
                  {errors.fullName && (
                    <p className="text-sm text-red-600 flex items-center gap-1">
                      <AlertCircle className="w-4 h-4" />
                      {errors.fullName}
                    </p>
                  )}
                </div>

                {/* Email */}
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-base font-semibold flex items-center gap-2">
                    <Mail className="w-4 h-4 text-purple-600" />
                    Email <span className="text-red-600">*</span>
                  </Label>
                  <Input
                    id="email"
                    type="email"
                    placeholder="ahmad.suryadi@hospital.com"
                    value={formData.email}
                    onChange={(e) => handleChange("email", e.target.value)}
                    className={`text-base ${errors.email ? "border-red-500" : ""}`}
                  />
                  {errors.email && (
                    <p className="text-sm text-red-600 flex items-center gap-1">
                      <AlertCircle className="w-4 h-4" />
                      {errors.email}
                    </p>
                  )}
                </div>

                {/* Phone */}
                <div className="space-y-2">
                  <Label htmlFor="phone" className="text-base font-semibold flex items-center gap-2">
                    <Phone className="w-4 h-4 text-purple-600" />
                    No. Telepon <span className="text-red-600">*</span>
                  </Label>
                  <Input
                    id="phone"
                    placeholder="08123456789"
                    value={formData.phone}
                    onChange={(e) => handleChange("phone", e.target.value)}
                    className={`text-base ${errors.phone ? "border-red-500" : ""}`}
                  />
                  {errors.phone && (
                    <p className="text-sm text-red-600 flex items-center gap-1">
                      <AlertCircle className="w-4 h-4" />
                      {errors.phone}
                    </p>
                  )}
                </div>

                {/* SIP & STR */}
                <div className="grid md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="sipNumber" className="text-base font-semibold flex items-center gap-2">
                      <Award className="w-4 h-4 text-purple-600" />
                      No. SIP <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      id="sipNumber"
                      placeholder="SIP/12345/2024"
                      value={formData.sipNumber}
                      onChange={(e) => handleChange("sipNumber", e.target.value)}
                      className={`text-base ${errors.sipNumber ? "border-red-500" : ""}`}
                    />
                    {errors.sipNumber && (
                      <p className="text-sm text-red-600 flex items-center gap-1">
                        <AlertCircle className="w-4 h-4" />
                        {errors.sipNumber}
                      </p>
                    )}
                    <p className="text-xs text-gray-500">Surat Izin Praktik</p>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="strNumber" className="text-base font-semibold flex items-center gap-2">
                      <Award className="w-4 h-4 text-purple-600" />
                      No. STR <span className="text-red-600">*</span>
                    </Label>
                    <Input
                      id="strNumber"
                      placeholder="STR/12345/2024"
                      value={formData.strNumber}
                      onChange={(e) => handleChange("strNumber", e.target.value)}
                      className={`text-base ${errors.strNumber ? "border-red-500" : ""}`}
                    />
                    {errors.strNumber && (
                      <p className="text-sm text-red-600 flex items-center gap-1">
                        <AlertCircle className="w-4 h-4" />
                        {errors.strNumber}
                      </p>
                    )}
                    <p className="text-xs text-gray-500">Surat Tanda Registrasi</p>
                  </div>
                </div>

                {/* Specialization */}
                <div className="space-y-2">
                  <Label htmlFor="specialization" className="text-base font-semibold flex items-center gap-2">
                    <User className="w-4 h-4 text-purple-600" />
                    Spesialisasi
                  </Label>
                  <div className="bg-purple-50 border-2 border-purple-200 rounded-md p-3">
                    <Badge className="bg-purple-600 text-white">
                      Sp.An - Spesialis Anestesiologi
                    </Badge>
                  </div>
                </div>

                {/* Hospital */}
                <div className="space-y-2">
                  <Label htmlFor="hospital" className="text-base font-semibold flex items-center gap-2">
                    <Building className="w-4 h-4 text-purple-600" />
                    Rumah Sakit <span className="text-red-600">*</span>
                  </Label>
                  <Input
                    id="hospital"
                    placeholder="RS Dr. Sardjito Yogyakarta"
                    value={formData.hospital}
                    onChange={(e) => handleChange("hospital", e.target.value)}
                    className={`text-base ${errors.hospital ? "border-red-500" : ""}`}
                  />
                  {errors.hospital && (
                    <p className="text-sm text-red-600 flex items-center gap-1">
                      <AlertCircle className="w-4 h-4" />
                      {errors.hospital}
                    </p>
                  )}
                </div>

                {/* Password */}
                <div className="space-y-2">
                  <Label htmlFor="password" className="text-base font-semibold flex items-center gap-2">
                    <Lock className="w-4 h-4 text-purple-600" />
                    Password <span className="text-red-600">*</span>
                  </Label>
                  <Input
                    id="password"
                    type="password"
                    placeholder="Minimal 6 karakter"
                    value={formData.password}
                    onChange={(e) => handleChange("password", e.target.value)}
                    className={`text-base ${errors.password ? "border-red-500" : ""}`}
                  />
                  {errors.password && (
                    <p className="text-sm text-red-600 flex items-center gap-1">
                      <AlertCircle className="w-4 h-4" />
                      {errors.password}
                    </p>
                  )}
                </div>

                {/* Confirm Password */}
                <div className="space-y-2">
                  <Label htmlFor="confirmPassword" className="text-base font-semibold flex items-center gap-2">
                    <Lock className="w-4 h-4 text-purple-600" />
                    Konfirmasi Password <span className="text-red-600">*</span>
                  </Label>
                  <Input
                    id="confirmPassword"
                    type="password"
                    placeholder="Ketik ulang password"
                    value={formData.confirmPassword}
                    onChange={(e) => handleChange("confirmPassword", e.target.value)}
                    className={`text-base ${errors.confirmPassword ? "border-red-500" : ""}`}
                  />
                  {errors.confirmPassword && (
                    <p className="text-sm text-red-600 flex items-center gap-1">
                      <AlertCircle className="w-4 h-4" />
                      {errors.confirmPassword}
                    </p>
                  )}
                </div>

                {/* Submit Button - Solid Purple */}
                <Button
                  type="submit"
                  className="w-full bg-purple-600 hover:bg-purple-700 text-white h-14 text-lg font-bold transition-colors"
                >
                  <CheckCircle className="w-5 h-5 mr-2" />
                  Daftar Sekarang
                </Button>

                {/* Login Link */}
                <div className="text-center pt-4 border-t">
                  <p className="text-sm text-gray-600">
                    Sudah punya akun?{' '}
                    <button
                      type="button"
                      onClick={() => navigate('/doctor/login')}
                      className="text-purple-600 font-semibold hover:underline"
                    >
                      Login di sini
                    </button>
                  </p>
                </div>
              </form>
            </div>
          </div>

          {/* Info Box */}
          <Card className="mt-6 border-2 border-purple-200 bg-purple-50">
            <CardContent className="p-4">
              <p className="text-sm text-purple-900">
                <strong>ℹ️ Catatan:</strong> Registrasi ini khusus untuk dokter anestesi yang sudah memiliki 
                SIP (Surat Izin Praktik) dan STR (Surat Tanda Registrasi) yang masih aktif.
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}