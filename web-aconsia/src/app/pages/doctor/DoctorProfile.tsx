import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Label } from "../../components/ui/label";
import { Input } from "../../components/ui/input";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "../../components/ui/tabs";
import { Avatar, AvatarFallback, AvatarImage } from "../../components/ui/avatar";
import { Edit, Save, TrendingUp, Award } from "lucide-react";
import { useState } from "react";

export function DoctorProfile() {
  const [isEditing, setIsEditing] = useState(false);
  const [profile, setProfile] = useState({
    fullName: "Dr. Ahmad Suryadi, Sp.An",
    dateOfBirth: "1985-05-15",
    gender: "Laki-laki",
    strNumber: "STR-123456789",
    sipNumber: "SIP-987654321",
    email: "ahmad.suryadi@rs.com",
    phoneNumber: "+62 812-3456-7890",
    specialty: "Anestesiologi dan Terapi Intensif",
  });

  const performanceMetrics = [
    { label: "Total Pasien", value: "32", trend: "+5 minggu ini" },
    { label: "Rata-rata Pemahaman", value: "92%", trend: "+3% dari bulan lalu" },
    { label: "Konten Dibuat", value: "18", trend: "6 jenis anestesi" },
    { label: "Rating Pasien", value: "4.8/5", trend: "Berdasarkan 28 ulasan" },
  ];

  const achievements = [
    { title: "Educator Expert", description: "Membuat 15+ konten edukasi", icon: Award, color: "text-yellow-500" },
    { title: "High Comprehension", description: "Rata-rata pemahaman >90%", icon: TrendingUp, color: "text-green-500" },
    { title: "Active Teacher", description: "Mengedukasi 30+ pasien", icon: Award, color: "text-blue-500" },
  ];

  return (
    <DashboardLayout role="doctor" userName="Dr. Ahmad Suryadi, Sp.An">
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Profil Dokter</h1>
            <p className="text-gray-600 mt-1">Kelola informasi profil dan lihat performa Anda</p>
          </div>
        </div>

        <Tabs defaultValue="profile" className="space-y-6">
          <TabsList>
            <TabsTrigger value="profile">Informasi Profil</TabsTrigger>
            <TabsTrigger value="performance">Performa</TabsTrigger>
          </TabsList>

          <TabsContent value="profile" className="space-y-6">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle>Data Pribadi</CardTitle>
                    <CardDescription>Informasi identitas dan kontak</CardDescription>
                  </div>
                  <Button
                    variant={isEditing ? "default" : "outline"}
                    onClick={() => setIsEditing(!isEditing)}
                    className="gap-2"
                  >
                    {isEditing ? (
                      <>
                        <Save className="w-4 h-4" />
                        Simpan
                      </>
                    ) : (
                      <>
                        <Edit className="w-4 h-4" />
                        Edit
                      </>
                    )}
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="flex items-center gap-6">
                  <Avatar className="w-24 h-24">
                    <AvatarImage src="" />
                    <AvatarFallback className="bg-blue-600 text-white text-2xl">
                      AS
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <Badge className="bg-green-500 mb-2">Status: Aktif</Badge>
                    <p className="text-sm text-gray-600">Bergabung sejak: Oktober 2025</p>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <Label htmlFor="fullName">Nama Lengkap</Label>
                    <Input
                      id="fullName"
                      value={profile.fullName}
                      onChange={(e) => setProfile({ ...profile, fullName: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="dateOfBirth">Tanggal Lahir</Label>
                    <Input
                      id="dateOfBirth"
                      type="date"
                      value={profile.dateOfBirth}
                      onChange={(e) => setProfile({ ...profile, dateOfBirth: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="gender">Jenis Kelamin</Label>
                    <Input
                      id="gender"
                      value={profile.gender}
                      onChange={(e) => setProfile({ ...profile, gender: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="specialty">Spesialisasi</Label>
                    <Input
                      id="specialty"
                      value={profile.specialty}
                      onChange={(e) => setProfile({ ...profile, specialty: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="strNumber">No. STR</Label>
                    <Input
                      id="strNumber"
                      value={profile.strNumber}
                      onChange={(e) => setProfile({ ...profile, strNumber: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="sipNumber">No. SIP</Label>
                    <Input
                      id="sipNumber"
                      value={profile.sipNumber}
                      onChange={(e) => setProfile({ ...profile, sipNumber: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="email">Email</Label>
                    <Input
                      id="email"
                      type="email"
                      value={profile.email}
                      onChange={(e) => setProfile({ ...profile, email: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="phoneNumber">No. WhatsApp</Label>
                    <Input
                      id="phoneNumber"
                      value={profile.phoneNumber}
                      onChange={(e) => setProfile({ ...profile, phoneNumber: e.target.value })}
                      disabled={!isEditing}
                    />
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="performance" className="space-y-6">
            {/* Performance Metrics */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              {performanceMetrics.map((metric) => (
                <Card key={metric.label}>
                  <CardContent className="p-6">
                    <p className="text-sm text-gray-600">{metric.label}</p>
                    <p className="text-3xl font-bold mt-2">{metric.value}</p>
                    <p className="text-xs text-gray-500 mt-2">{metric.trend}</p>
                  </CardContent>
                </Card>
              ))}
            </div>

            {/* Achievements */}
            <Card>
              <CardHeader>
                <CardTitle>Pencapaian</CardTitle>
                <CardDescription>Badge dan penghargaan yang telah diraih</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {achievements.map((achievement) => (
                    <div key={achievement.title} className="p-4 border rounded-lg flex items-start gap-4">
                      <div className={`p-3 rounded-lg bg-gray-100 ${achievement.color}`}>
                        <achievement.icon className="w-6 h-6" />
                      </div>
                      <div>
                        <p className="font-medium">{achievement.title}</p>
                        <p className="text-sm text-gray-600 mt-1">{achievement.description}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Patient Satisfaction */}
            <Card>
              <CardHeader>
                <CardTitle>Kepuasan Pasien</CardTitle>
                <CardDescription>Feedback dari pasien yang telah diedukasi</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {[
                    { name: "Ibu Sarah Wijaya", rating: 5, comment: "Dokter sangat profesional dan menjelaskan dengan detail. Terima kasih!" },
                    { name: "Bapak Andi Pratama", rating: 5, comment: "Dokter sangat sabar menjawab pertanyaan. Konten edukasinya mudah dipahami." },
                    { name: "Ibu Dewi Lestari", rating: 4, comment: "Sangat membantu. Penjelasan artikelnya bagus sekali." },
                  ].map((review, index) => (
                    <div key={index} className="p-4 border rounded-lg">
                      <div className="flex items-center justify-between mb-2">
                        <p className="font-medium">{review.name}</p>
                        <div className="flex gap-1">
                          {[...Array(5)].map((_, i) => (
                            <span key={i} className={i < review.rating ? "text-yellow-400" : "text-gray-300"}>
                              ★
                            </span>
                          ))}
                        </div>
                      </div>
                      <p className="text-sm text-gray-600">{review.comment}</p>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
}