import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Textarea } from "../../components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../../components/ui/select";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "../../components/ui/dialog";
import { Badge } from "../../components/ui/badge";
import { Plus, FileText, BookOpen, Trash2, Edit, Eye } from "lucide-react";
import { useState, useEffect } from "react";
import { learningMaterials } from "../../../data/learningMaterials"; // ✅ IMPORT FROM SAME DATA SOURCE

export function DoctorContent() {
  // ✅ LOAD FROM learningMaterials.ts (SAME DATA AS PATIENT!)
  const [contents, setContents] = useState<any[]>([]);

  useEffect(() => {
    // Convert learningMaterials to content format
    const formattedContents = learningMaterials.map((material) => ({
      id: material.id,
      title: material.title,
      anesthesiaType: material.type, // ✅ Use 'type' from LearningMaterial interface
      description: material.description || "Materi pembelajaran informed consent anestesi",
      section: material.section,
      estimatedTime: material.estimatedTime,
      createdAt: "19 Mar 2026", // Current date
      views: Math.floor(Math.random() * 100) + 20, // Random views for demo
    }));
    setContents(formattedContents);
    console.log("✅ Loaded", formattedContents.length, "education contents from learningMaterials.ts");
  }, []);

  // ✅ NO NEED for this function anymore - just use type directly
  const getAnesthesiaColor = (type: string) => {
    const colors: Record<string, string> = {
      "Spinal Anesthesia": "bg-purple-100 text-purple-700",
      "General Anesthesia": "bg-blue-100 text-blue-700",
      "Epidural Anesthesia": "bg-green-100 text-green-700",
      "Regional Anesthesia": "bg-yellow-100 text-yellow-700",
      "Local Anesthesia + Sedation": "bg-pink-100 text-pink-700",
    };
    return colors[type] || "bg-gray-100 text-gray-700";
  };

  const totalViews = contents.reduce((sum, c) => sum + c.views, 0);
  const avgViews = contents.length > 0 ? Math.round(totalViews / contents.length) : 0;

  return (
    <DashboardLayout role="doctor" userName="Dr. Ahmad Suryadi, Sp.An">
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Konten Edukasi</h1>
            <p className="text-gray-600 mt-1">Kelola materi edukasi untuk pasien</p>
          </div>
          
          <Dialog>
            <DialogTrigger asChild>
              <Button className="bg-blue-600 hover:bg-blue-700 gap-2">
                <Plus className="w-4 h-4" />
                Tambah Konten
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
              <DialogHeader>
                <DialogTitle>Tambah Konten Edukasi Baru</DialogTitle>
                <DialogDescription>
                  Buat konten edukasi artikel/teks yang akan direkomendasikan ke pasien sesuai jenis anestesi mereka
                </DialogDescription>
              </DialogHeader>
              
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="contentTitle">Judul Konten</Label>
                  <Input id="contentTitle" placeholder="Contoh: Pengenalan Anestesi Spinal" />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="anesthesiaType">Jenis Anestesi</Label>
                  <Select>
                    <SelectTrigger id="anesthesiaType">
                      <SelectValue placeholder="Pilih jenis anestesi" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="general">Anestesi Umum (seluruh tubuh)</SelectItem>
                      <SelectItem value="spinal">Anestesi Spinal (setengah badan)</SelectItem>
                      <SelectItem value="epidural">Anestesi Epidural</SelectItem>
                      <SelectItem value="regional">Anestesi Regional</SelectItem>
                      <SelectItem value="local">Anestesi Lokal</SelectItem>
                    </SelectContent>
                  </Select>
                  <p className="text-xs text-gray-500 mt-1">
                    💡 Konten ini akan otomatis direkomendasikan ke pasien yang sesuai dengan jenis anestesi
                  </p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="description">Deskripsi Singkat</Label>
                  <Textarea 
                    id="description" 
                    placeholder="Jelaskan isi konten edukasi ini..."
                    rows={3}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="contentBody">Isi Konten (Artikel/Teks)</Label>
                  <Textarea 
                    id="contentBody" 
                    placeholder="Tulis konten edukasi di sini. Jelaskan prosedur, manfaat, risiko, dan hal-hal yang perlu diketahui pasien..."
                    rows={10}
                  />
                  <p className="text-xs text-blue-600 mt-1">
                    ℹ️ Sistem ini hanya mendukung konten berbasis teks/artikel (tanpa video atau visual)
                  </p>
                </div>

                <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mt-4">
                  <h4 className="font-semibold text-blue-900 mb-2">🎯 Sistem Auto-Filter Konten</h4>
                  <ul className="text-sm text-blue-800 space-y-1">
                    <li>✓ Konten hanya akan muncul untuk pasien dengan jenis anestesi yang sesuai</li>
                    <li>✓ Pasien dengan anestesi spinal hanya akan melihat konten anestesi spinal</li>
                    <li>✓ Pasien dengan anestesi umum hanya akan melihat konten anestesi umum</li>
                    <li>✓ Ini memastikan edukasi yang tepat dan relevan untuk setiap pasien</li>
                  </ul>
                </div>

                <div className="flex justify-end gap-2 pt-4">
                  <Button variant="outline">Batal</Button>
                  <Button className="bg-blue-600 hover:bg-blue-700">Publikasikan Konten</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-blue-100 rounded-lg">
                  <FileText className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Total Artikel</p>
                  <p className="text-2xl font-bold">{contents.length}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-green-100 rounded-lg">
                  <Eye className="w-6 h-6 text-green-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Total Views</p>
                  <p className="text-2xl font-bold">{totalViews}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardContent className="p-6">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-purple-100 rounded-lg">
                  <BookOpen className="w-6 h-6 text-purple-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Avg. Views/Artikel</p>
                  <p className="text-2xl font-bold">{avgViews}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Content List */}
        <Card>
          <CardHeader>
            <CardTitle>Daftar Konten Edukasi</CardTitle>
            <CardDescription>Materi artikel/teks yang telah dibuat untuk pasien</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {contents.map((content) => (
                <div key={content.id} className="p-4 border rounded-lg hover:shadow-md transition-shadow">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <FileText className="w-5 h-5 text-blue-600" />
                        <h3 className="font-semibold text-lg">{content.title}</h3>
                        <Badge className={getAnesthesiaColor(content.anesthesiaType)}>
                          {content.anesthesiaType}
                        </Badge>
                      </div>
                      <p className="text-sm text-gray-600 mb-3">{content.description}</p>
                      <div className="flex items-center gap-4 text-xs text-gray-500">
                        <span>📅 Dibuat: {content.createdAt}</span>
                        <span>•</span>
                        <span>👁️ {content.views} views</span>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <Button variant="outline" size="sm" className="gap-2">
                        <Edit className="w-4 h-4" />
                        Edit
                      </Button>
                      <Button variant="outline" size="sm" className="gap-2 text-red-600 hover:bg-red-50">
                        <Trash2 className="w-4 h-4" />
                        Hapus
                      </Button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Info Card */}
        <Card className="bg-gradient-to-r from-blue-50 to-purple-50 border-blue-200">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <span>💡</span>
              Tips Membuat Konten Edukasi (Text-Only)
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="space-y-2 text-sm">
              <li>✓ Gunakan bahasa yang mudah dipahami pasien awam</li>
              <li>✓ Jelaskan prosedur dengan detail tapi tidak terlalu teknis</li>
              <li>✓ Sertakan manfaat dan risiko dengan jujur</li>
              <li>✓ Tambahkan FAQ untuk pertanyaan umum</li>
              <li>✓ Update konten secara berkala sesuai perkembangan medis</li>
              <li>✓ Fokus pada konten berbasis teks/artikel (sistem tidak support video/visual)</li>
            </ul>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}