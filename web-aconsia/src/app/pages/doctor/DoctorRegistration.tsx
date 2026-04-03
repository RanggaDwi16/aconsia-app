import { useState } from "react";
import { useNavigate } from "react-router";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Badge } from "../../components/ui/badge";
import { Tooltip, TooltipContent, TooltipTrigger } from "../../components/ui/tooltip";
import { 
  ArrowLeft, 
  User, 
  Mail, 
  Phone, 
  Lock,
  Eye,
  EyeOff,
  Building,
  Award,
  CheckCircle,
  AlertCircle
} from "lucide-react";
import { BrandLogo } from "../../components/BrandLogo";
import { createUserWithEmailAndPassword } from "firebase/auth";
import { doc, serverTimestamp, setDoc } from "firebase/firestore";
import { firebaseAuth, firestore } from "../../../core/firebase/client";
import { saveDesktopSession } from "../../../core/auth/session";

type DoctorRegistrationField =
  | "fullName"
  | "email"
  | "phone"
  | "sipNumber"
  | "strNumber"
  | "hospital"
  | "password"
  | "confirmPassword";

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const FULL_NAME_REGEX = /^[A-Za-z.,'`\-\s]+$/;
const PHONE_REGEX = /^(\+62|62|0)[0-9]{9,12}$/;

const sanitizePhoneInput = (value: string) => {
  let output = value.replace(/[^\d+]/g, "");
  output = output.startsWith("+")
    ? `+${output.slice(1).replace(/[+]/g, "")}`
    : output.replace(/[+]/g, "");
  return output.slice(0, 15);
};

export function DoctorRegistration() {
  const navigate = useNavigate();
  const [submitError, setSubmitError] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  
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

  const [errors, setErrors] = useState<Record<DoctorRegistrationField, string>>({
    fullName: "",
    email: "",
    phone: "",
    sipNumber: "",
    strNumber: "",
    hospital: "",
    password: "",
    confirmPassword: "",
  });
  const [touched, setTouched] = useState<Record<DoctorRegistrationField, boolean>>({
    fullName: false,
    email: false,
    phone: false,
    sipNumber: false,
    strNumber: false,
    hospital: false,
    password: false,
    confirmPassword: false,
  });

  const validateField = (
    field: DoctorRegistrationField,
    data: typeof formData,
  ): string => {
    const fullName = data.fullName.trim();
    const email = data.email.trim().toLowerCase();
    const phone = data.phone.trim();
    const sipNumber = data.sipNumber.trim();
    const strNumber = data.strNumber.trim();
    const hospital = data.hospital.trim();
    const password = data.password;
    const confirmPassword = data.confirmPassword;

    switch (field) {
      case "fullName":
        if (!fullName) return "Nama lengkap wajib diisi";
        if (fullName.length < 3) return "Nama minimal 3 karakter";
        if (fullName.length > 80) return "Nama maksimal 80 karakter";
        if (!FULL_NAME_REGEX.test(fullName)) {
          return "Nama hanya boleh huruf dan tanda baca umum";
        }
        return "";

      case "email":
        if (!email) return "Email wajib diisi";
        if (email.length > 120) return "Email maksimal 120 karakter";
        if (!EMAIL_REGEX.test(email)) return "Format email tidak valid";
        return "";

      case "phone":
        if (!phone) return "No. telepon wajib diisi";
        if (!PHONE_REGEX.test(phone)) {
          return "Format no. telepon tidak valid (08xx / 62xx / +62xx)";
        }
        return "";

      case "sipNumber":
        if (!sipNumber) return "No. SIP wajib diisi";
        if (sipNumber.length > 80) return "No. SIP maksimal 80 karakter";
        return "";

      case "strNumber":
        if (!strNumber) return "No. STR wajib diisi";
        if (strNumber.length > 80) return "No. STR maksimal 80 karakter";
        return "";

      case "hospital":
        if (!hospital) return "Nama rumah sakit wajib diisi";
        if (hospital.length < 3) return "Nama rumah sakit minimal 3 karakter";
        if (hospital.length > 120) return "Nama rumah sakit maksimal 120 karakter";
        return "";

      case "password":
        if (!password) return "Password wajib diisi";
        if (password.length < 6) return "Password minimal 6 karakter";
        if (password.length > 64) return "Password maksimal 64 karakter";
        return "";

      case "confirmPassword":
        if (!confirmPassword) return "Konfirmasi password wajib diisi";
        if (password !== confirmPassword) return "Password tidak cocok";
        return "";

      default:
        return "";
    }
  };

  const handleChange = (field: DoctorRegistrationField, value: string) => {
    const nextValue = (() => {
      if (field === "phone") return sanitizePhoneInput(value);
      if (field === "sipNumber" || field === "strNumber") return value.slice(0, 80);
      if (field === "email") return value.trimStart().slice(0, 120);
      if (field === "fullName") return value.replace(/\s+/g, " ").trimStart().slice(0, 80);
      if (field === "hospital") return value.replace(/\s+/g, " ").trimStart().slice(0, 120);
      if (field === "password" || field === "confirmPassword") return value.slice(0, 64);
      return value;
    })();

    setFormData((prev) => {
      const updated = { ...prev, [field]: nextValue };
      const shouldValidateNow =
        touched[field]
        || (field !== "password" && field !== "confirmPassword" && nextValue.trim().length > 0)
        || ((field === "password" || field === "confirmPassword") && nextValue.length > 0);
      if (shouldValidateNow) {
        const message = validateField(field, updated);
        setErrors((prevErrors) => ({ ...prevErrors, [field]: message }));
      }
      if (field === "password" && touched.confirmPassword) {
        const confirmMessage = validateField("confirmPassword", updated);
        setErrors((prevErrors) => ({ ...prevErrors, confirmPassword: confirmMessage }));
      }
      return updated;
    });
  };

  const handleBlur = (field: DoctorRegistrationField) => {
    setTouched((prev) => ({ ...prev, [field]: true }));
    setErrors((prev) => ({
      ...prev,
      [field]: validateField(field, formData),
      ...(field === "password"
        ? { confirmPassword: touched.confirmPassword ? validateField("confirmPassword", formData) : prev.confirmPassword }
        : {}),
    }));
  };

  const validateForm = () => {
    const fields: DoctorRegistrationField[] = [
      "fullName",
      "email",
      "phone",
      "sipNumber",
      "strNumber",
      "hospital",
      "password",
      "confirmPassword",
    ];
    const newErrors = fields.reduce<Record<DoctorRegistrationField, string>>(
      (acc, field) => {
        acc[field] = validateField(field, formData);
        return acc;
      },
      {
        fullName: "",
        email: "",
        phone: "",
        sipNumber: "",
        strNumber: "",
        hospital: "",
        password: "",
        confirmPassword: "",
      },
    );

    setTouched({
      fullName: true,
      email: true,
      phone: true,
      sipNumber: true,
      strNumber: true,
      hospital: true,
      password: true,
      confirmPassword: true,
    });
    setErrors(newErrors);
    return !Object.values(newErrors).some(Boolean);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitError("");
    
    if (!validateForm()) {
      return;
    }

    try {
      setIsSubmitting(true);

      const email = formData.email.trim().toLowerCase();
      const fullName = formData.fullName.trim();
      const phone = formData.phone.trim();
      const hospital = formData.hospital.trim();
      const sipNumber = formData.sipNumber.trim();
      const strNumber = formData.strNumber.trim();

      const credential = await createUserWithEmailAndPassword(
        firebaseAuth,
        email,
        formData.password,
      );
      const uid = credential.user.uid;

      await setDoc(
        doc(firestore, "users", uid),
        {
          uid,
          email,
          name: fullName,
          displayName: fullName,
          role: "dokter",
          status: "active",
          phone,
          hospital,
          specialization: formData.specialization,
          sipNumber,
          strNumber,
          isProfileCompleted: true,
          createdAt: serverTimestamp(),
          updatedAt: serverTimestamp(),
        },
        { merge: true },
      );

      await setDoc(
        doc(firestore, "dokter_profiles", uid),
        {
          uid,
          email,
          fullName,
          nama: fullName,
          phoneNumber: phone,
          noTelepon: phone,
          hospitalName: hospital,
          namaRumahSakit: hospital,
          specialization: formData.specialization,
          sipNumber,
          strNumber,
          status: "active",
          createdAt: serverTimestamp(),
          updatedAt: serverTimestamp(),
        },
        { merge: true },
      );

      saveDesktopSession({
        uid,
        email,
        role: "doctor",
        displayName: fullName,
      });

      navigate("/doctor");
    } catch (error: any) {
      const code = String(error?.code || "");
      if (code === "auth/email-already-in-use") {
        setSubmitError("Email sudah terdaftar. Silakan login dengan akun tersebut.");
      } else if (code === "auth/weak-password") {
        setSubmitError("Password terlalu lemah. Gunakan minimal 6 karakter.");
      } else if (code === "auth/invalid-email") {
        setSubmitError("Format email tidak valid.");
      } else {
        setSubmitError("Registrasi dokter gagal. Periksa koneksi/Firebase config lalu coba lagi.");
      }
    } finally {
      setIsSubmitting(false);
    }
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
              <BrandLogo />
              
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
                {submitError && (
                  <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                    <div className="flex items-start gap-3">
                      <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
                      <p className="text-sm text-red-800 leading-relaxed">{submitError}</p>
                    </div>
                  </div>
                )}

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
                    onBlur={() => handleBlur("fullName")}
                    maxLength={80}
                    aria-invalid={Boolean(errors.fullName)}
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
                    onBlur={() => handleBlur("email")}
                    maxLength={120}
                    autoComplete="email"
                    autoCapitalize="none"
                    aria-invalid={Boolean(errors.email)}
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
                    onBlur={() => handleBlur("phone")}
                    inputMode="tel"
                    autoComplete="tel"
                    maxLength={15}
                    aria-invalid={Boolean(errors.phone)}
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
                      onBlur={() => handleBlur("sipNumber")}
                      maxLength={80}
                      aria-invalid={Boolean(errors.sipNumber)}
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
                      onBlur={() => handleBlur("strNumber")}
                      maxLength={80}
                      aria-invalid={Boolean(errors.strNumber)}
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
                    onBlur={() => handleBlur("hospital")}
                    maxLength={120}
                    aria-invalid={Boolean(errors.hospital)}
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
                  <div className="relative">
                    <Input
                      id="password"
                      type={showPassword ? "text" : "password"}
                      placeholder="Minimal 6 karakter"
                      value={formData.password}
                      onChange={(e) => handleChange("password", e.target.value)}
                      onBlur={() => handleBlur("password")}
                      autoComplete="new-password"
                      maxLength={64}
                      aria-invalid={Boolean(errors.password)}
                      className={`text-base pr-12 ${errors.password ? "border-red-500" : ""}`}
                    />
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button
                          type="button"
                          onClick={() => setShowPassword((prev) => !prev)}
                          className="absolute right-3 top-1/2 -translate-y-1/2 rounded-md p-1 text-slate-500 hover:bg-slate-100 hover:text-slate-700 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-300"
                          aria-label={showPassword ? "Sembunyikan password" : "Tampilkan password"}
                          aria-pressed={showPassword}
                        >
                          {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                        </button>
                      </TooltipTrigger>
                      <TooltipContent side="top" sideOffset={8}>
                        {showPassword ? "Sembunyikan password" : "Tampilkan password"}
                      </TooltipContent>
                    </Tooltip>
                  </div>
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
                  <div className="relative">
                    <Input
                      id="confirmPassword"
                      type={showConfirmPassword ? "text" : "password"}
                      placeholder="Ketik ulang password"
                      value={formData.confirmPassword}
                      onChange={(e) => handleChange("confirmPassword", e.target.value)}
                      onBlur={() => handleBlur("confirmPassword")}
                      autoComplete="new-password"
                      maxLength={64}
                      aria-invalid={Boolean(errors.confirmPassword)}
                      className={`text-base pr-12 ${errors.confirmPassword ? "border-red-500" : ""}`}
                    />
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <button
                          type="button"
                          onClick={() => setShowConfirmPassword((prev) => !prev)}
                          className="absolute right-3 top-1/2 -translate-y-1/2 rounded-md p-1 text-slate-500 hover:bg-slate-100 hover:text-slate-700 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-slate-300"
                          aria-label={showConfirmPassword ? "Sembunyikan password" : "Tampilkan password"}
                          aria-pressed={showConfirmPassword}
                        >
                          {showConfirmPassword ? (
                            <EyeOff className="w-5 h-5" />
                          ) : (
                            <Eye className="w-5 h-5" />
                          )}
                        </button>
                      </TooltipTrigger>
                      <TooltipContent side="top" sideOffset={8}>
                        {showConfirmPassword ? "Sembunyikan password" : "Tampilkan password"}
                      </TooltipContent>
                    </Tooltip>
                  </div>
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
                  disabled={isSubmitting}
                  className="w-full bg-purple-600 hover:bg-purple-700 text-white h-14 text-lg font-bold transition-colors disabled:opacity-60"
                >
                  <CheckCircle className="w-5 h-5 mr-2" />
                  {isSubmitting ? "Memproses..." : "Daftar Sekarang"}
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
