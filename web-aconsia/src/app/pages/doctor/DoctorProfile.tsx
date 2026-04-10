import { useEffect, useMemo, useState } from "react";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Label } from "../../components/ui/label";
import { Input } from "../../components/ui/input";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "../../components/ui/tabs";
import { Avatar, AvatarFallback } from "../../components/ui/avatar";
import { Edit, Save, AlertCircle, Award, TrendingUp } from "lucide-react";
import { getDesktopSession } from "../../../core/auth/session";
import {
  getDoctorPerformance,
  getDoctorProfile,
  updateDoctorProfile,
  type DoctorProfileData,
  type DoctorPerformanceData,
} from "../../../modules/doctor/services/doctorProfileService";
import { userMessages } from "../../copy/userMessages";

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE_REGEX = /^(\+62|62|0)[0-9]{9,12}$/;

function emptyPerformance(): DoctorPerformanceData {
  return {
    totalPatients: 0,
    avgComprehension: 0,
    approvedPatients: 0,
    pendingPatients: 0,
  };
}

export function DoctorProfile() {
  const [isLoading, setIsLoading] = useState(true);
  const [isEditing, setIsEditing] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [loadError, setLoadError] = useState("");
  const [saveError, setSaveError] = useState("");
  const [profile, setProfile] = useState<DoctorProfileData | null>(null);
  const [draft, setDraft] = useState<DoctorProfileData | null>(null);
  const [performance, setPerformance] = useState<DoctorPerformanceData>(emptyPerformance);

  const session = getDesktopSession();

  const initials = useMemo(() => {
    const name = draft?.fullName || profile?.fullName || "Dokter";
    return name
      .split(" ")
      .map((part) => part.charAt(0).toUpperCase())
      .filter(Boolean)
      .slice(0, 2)
      .join("");
  }, [draft?.fullName, profile?.fullName]);

  const statusLabel = useMemo(() => {
    const status = (draft?.status || profile?.status || "active").toLowerCase();
    return status === "active" ? "Aktif" : status;
  }, [draft?.status, profile?.status]);

  const loadData = async () => {
    if (!session?.uid) {
      setLoadError("Sesi login tidak ditemukan. Silakan login ulang.");
      setIsLoading(false);
      return;
    }

    try {
      const [profileData, performanceData] = await Promise.all([
        getDoctorProfile(session.uid),
        getDoctorPerformance(session.uid),
      ]);

      setProfile(profileData);
      setDraft(profileData);
      setPerformance(performanceData);
      setLoadError("");
    } catch (error) {
      console.error("[DoctorProfile] load failed", error);
      setLoadError(userMessages.doctorProfile.loadError);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    void loadData();
  }, []);

  const handleEditToggle = () => {
    if (!profile) return;
    setSaveError("");

    if (isEditing) {
      setDraft(profile);
      setIsEditing(false);
      return;
    }

    setIsEditing(true);
  };

  const validateDraft = () => {
    if (!draft) return "Data profil belum siap.";
    if (draft.fullName.trim().length < 3) return "Nama lengkap minimal 3 karakter.";
    if (!EMAIL_REGEX.test(draft.email.trim().toLowerCase())) return "Format email tidak valid.";
    if (!PHONE_REGEX.test(draft.phoneNumber.trim())) {
      return "Format no. telepon tidak valid (08xx / 62xx / +62xx).";
    }
    if (!draft.hospitalName.trim()) return "Rumah sakit wajib diisi.";
    if (!draft.sipNumber.trim()) return "No. SIP wajib diisi.";
    if (!draft.strNumber.trim()) return "No. STR wajib diisi.";
    return "";
  };

  const handleSave = async () => {
    if (!session?.uid || !draft) return;

    const validationError = validateDraft();
    if (validationError) {
      setSaveError(validationError);
      return;
    }

    try {
      setIsSaving(true);
      setSaveError("");
      await updateDoctorProfile(session.uid, draft);
      setIsEditing(false);
      await loadData();
    } catch (error) {
      console.error("[DoctorProfile] save failed", error);
      setSaveError(userMessages.doctorProfile.saveError);
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <DoctorLayout>
      <div className="p-8 space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Profil Dokter</h1>
          <p className="text-gray-600 mt-1">Kelola informasi profil dan lihat performa Anda</p>
        </div>

        {isLoading && (
          <Card>
            <CardContent className="p-6 text-center text-gray-600">Memuat data profil...</CardContent>
          </Card>
        )}

        {!isLoading && loadError && (
          <Card className="border-red-200">
            <CardContent className="p-6 text-center">
              <AlertCircle className="w-10 h-10 text-red-600 mx-auto mb-3" />
              <p className="text-red-700 font-medium">{loadError}</p>
            </CardContent>
          </Card>
        )}

        {!isLoading && !loadError && draft && (
          <Tabs defaultValue="profile" className="space-y-6">
            <TabsList>
              <TabsTrigger value="profile">Informasi Profil</TabsTrigger>
              <TabsTrigger value="performance">Performa</TabsTrigger>
            </TabsList>

            <TabsContent value="profile">
              <Card>
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <div>
                      <CardTitle>Data Pribadi</CardTitle>
                      <CardDescription>Informasi identitas dan kontak</CardDescription>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button
                        variant={isEditing ? "default" : "outline"}
                        onClick={isEditing ? handleSave : handleEditToggle}
                        disabled={isSaving}
                        className="gap-2"
                      >
                        {isEditing ? (
                          <>
                            <Save className="w-4 h-4" />
                            {isSaving ? "Menyimpan..." : "Simpan"}
                          </>
                        ) : (
                          <>
                            <Edit className="w-4 h-4" />
                            Edit
                          </>
                        )}
                      </Button>
                      {isEditing && (
                        <Button variant="outline" onClick={handleEditToggle} disabled={isSaving}>
                          Batal
                        </Button>
                      )}
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="flex items-center gap-6">
                    <Avatar className="w-24 h-24">
                      <AvatarFallback className="bg-blue-600 text-white text-2xl">
                        {initials || "D"}
                      </AvatarFallback>
                    </Avatar>
                    <div>
                      <Badge className="bg-green-500 mb-2">Status: {statusLabel}</Badge>
                      <p className="text-sm text-gray-600">
                        Bergabung sejak: {draft.joinedAtLabel || "-"}
                      </p>
                    </div>
                  </div>

                  {saveError && (
                    <div className="rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
                      {saveError}
                    </div>
                  )}

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="space-y-2">
                      <Label htmlFor="fullName">Nama Lengkap</Label>
                      <Input
                        id="fullName"
                        value={draft.fullName}
                        onChange={(e) =>
                          setDraft((prev) => (prev ? { ...prev, fullName: e.target.value } : prev))
                        }
                        disabled={!isEditing}
                      />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="specialization">Spesialisasi</Label>
                      <Input id="specialization" value={draft.specialization} disabled />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="strNumber">No. STR</Label>
                      <Input
                        id="strNumber"
                        value={draft.strNumber}
                        onChange={(e) =>
                          setDraft((prev) => (prev ? { ...prev, strNumber: e.target.value } : prev))
                        }
                        disabled={!isEditing}
                      />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="sipNumber">No. SIP</Label>
                      <Input
                        id="sipNumber"
                        value={draft.sipNumber}
                        onChange={(e) =>
                          setDraft((prev) => (prev ? { ...prev, sipNumber: e.target.value } : prev))
                        }
                        disabled={!isEditing}
                      />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="email">Email</Label>
                      <Input
                        id="email"
                        type="email"
                        value={draft.email}
                        onChange={(e) =>
                          setDraft((prev) => (prev ? { ...prev, email: e.target.value } : prev))
                        }
                        disabled={!isEditing}
                      />
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="phoneNumber">No. WhatsApp</Label>
                      <Input
                        id="phoneNumber"
                        value={draft.phoneNumber}
                        onChange={(e) =>
                          setDraft((prev) => (prev ? { ...prev, phoneNumber: e.target.value } : prev))
                        }
                        disabled={!isEditing}
                      />
                    </div>

                    <div className="space-y-2 md:col-span-2">
                      <Label htmlFor="hospitalName">Rumah Sakit</Label>
                      <Input
                        id="hospitalName"
                        value={draft.hospitalName}
                        onChange={(e) =>
                          setDraft((prev) => (prev ? { ...prev, hospitalName: e.target.value } : prev))
                        }
                        disabled={!isEditing}
                      />
                    </div>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="performance" className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <Card>
                  <CardContent className="p-6">
                    <p className="text-sm text-gray-600">Total Pasien</p>
                    <p className="text-3xl font-bold mt-2">{performance.totalPatients}</p>
                    <p className="text-xs text-gray-500 mt-1">Pasien aktif dokter</p>
                  </CardContent>
                </Card>
                <Card>
                  <CardContent className="p-6">
                    <p className="text-sm text-gray-600">Pasien Disetujui</p>
                    <p className="text-3xl font-bold mt-2">{performance.approvedPatients}</p>
                    <p className="text-xs text-gray-500 mt-1">Sudah lanjut edukasi</p>
                  </CardContent>
                </Card>
                <Card>
                  <CardContent className="p-6">
                    <p className="text-sm text-gray-600">Menunggu Review</p>
                    <p className="text-3xl font-bold mt-2">{performance.pendingPatients}</p>
                    <p className="text-xs text-gray-500 mt-1">Perlu approval dokter</p>
                  </CardContent>
                </Card>
                <Card>
                  <CardContent className="p-6">
                    <p className="text-sm text-gray-600">Rata-rata Pemahaman</p>
                    <p className="text-3xl font-bold mt-2">{performance.avgComprehension}%</p>
                    <p className="text-xs text-gray-500 mt-1">Skor edukasi pasien</p>
                  </CardContent>
                </Card>
              </div>

              <Card>
                <CardHeader>
                  <CardTitle>Pencapaian Dokter</CardTitle>
                  <CardDescription>Ringkasan performa edukasi pasien</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid gap-4 md:grid-cols-3">
                    <div className="rounded-lg border p-4">
                      <div className="mb-2 flex h-10 w-10 items-center justify-center rounded-lg bg-amber-100 text-amber-600">
                        <Award className="h-5 w-5" />
                      </div>
                      <p className="font-medium text-gray-900">Educator Expert</p>
                      <p className="text-sm text-gray-600">Aktif membangun materi edukasi dokter.</p>
                    </div>
                    <div className="rounded-lg border p-4">
                      <div className="mb-2 flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-100 text-emerald-600">
                        <TrendingUp className="h-5 w-5" />
                      </div>
                      <p className="font-medium text-gray-900">High Comprehension</p>
                      <p className="text-sm text-gray-600">Mayoritas pasien memiliki pemahaman baik.</p>
                    </div>
                    <div className="rounded-lg border p-4">
                      <div className="mb-2 flex h-10 w-10 items-center justify-center rounded-lg bg-blue-100 text-blue-600">
                        <Award className="h-5 w-5" />
                      </div>
                      <p className="font-medium text-gray-900">Active Clinician</p>
                      <p className="text-sm text-gray-600">Konsisten melakukan review pasien.</p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        )}
      </div>
    </DoctorLayout>
  );
}
