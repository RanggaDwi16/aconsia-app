import { useEffect, useMemo, useState } from "react";
import { DoctorLayout } from "../../layouts/DoctorLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Label } from "../../components/ui/label";
import { Textarea } from "../../components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../../components/ui/select";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "../../components/ui/dialog";
import { Badge } from "../../components/ui/badge";
import { Plus, FileText, BookOpen, Trash2, Edit, AlertCircle } from "lucide-react";
import { getDesktopSession } from "../../../core/auth/session";
import {
  createDoctorContent,
  deleteDoctorContent,
  getDoctorContents,
  updateDoctorContent,
  type DoctorContentItem,
} from "../../../modules/doctor/services/doctorContentService";

type FormState = {
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
};

const EMPTY_FORM: FormState = {
  title: "",
  anesthesiaType: "",
  description: "",
  body: "",
};

const ANESTHESIA_OPTIONS = [
  "General Anesthesia",
  "Spinal Anesthesia",
  "Epidural Anesthesia",
  "Regional Anesthesia",
  "Local Anesthesia + Sedation",
];

function normalizeFormFromContent(content: DoctorContentItem): FormState {
  return {
    title: content.title,
    anesthesiaType: content.anesthesiaType === "-" ? "" : content.anesthesiaType,
    description: content.description,
    body: content.body,
  };
}

export function DoctorContent() {
  const session = getDesktopSession();
  const [contents, setContents] = useState<DoctorContentItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState("");
  const [isCreateOpen, setIsCreateOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState<FormState>(EMPTY_FORM);
  const [editingContent, setEditingContent] = useState<DoctorContentItem | null>(null);

  const totalContents = contents.length;
  const publishedContents = contents.filter((c) => c.status === "published").length;
  const draftContents = contents.filter((c) => c.status === "draft").length;

  const loadContents = async () => {
    if (!session?.uid) {
      setError("Sesi dokter tidak ditemukan. Silakan login ulang.");
      setIsLoading(false);
      return;
    }

    try {
      const data = await getDoctorContents(session.uid);
      setContents(data);
      setError("");
    } catch (loadErr) {
      console.error("[DoctorContent] Firestore load failed", loadErr);
      setError("Gagal memuat konten edukasi dari Firestore.");
      setContents([]);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    void loadContents();
  }, [session?.uid]);

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

  const resetForm = () => {
    setForm(EMPTY_FORM);
    setEditingContent(null);
  };

  const validateForm = () => {
    if (form.title.trim().length < 5) {
      return "Judul minimal 5 karakter.";
    }
    if (!form.anesthesiaType.trim()) {
      return "Jenis anestesi wajib dipilih.";
    }
    if (form.description.trim().length < 10) {
      return "Deskripsi minimal 10 karakter.";
    }
    if (form.body.trim().length < 30) {
      return "Isi konten minimal 30 karakter.";
    }
    return "";
  };

  const handleCreate = async () => {
    if (!session?.uid) return;
    const message = validateForm();
    if (message) {
      setError(message);
      return;
    }

    try {
      setSaving(true);
      setError("");
      await createDoctorContent({
        doctorUid: session.uid,
        doctorName: session.displayName || session.email || "Dokter",
        title: form.title.trim(),
        anesthesiaType: form.anesthesiaType,
        description: form.description.trim(),
        body: form.body.trim(),
      });
      setIsCreateOpen(false);
      resetForm();
      await loadContents();
    } catch (saveErr) {
      console.error("[DoctorContent] create failed", saveErr);
      setError("Gagal membuat konten. Periksa rules/konfigurasi Firestore.");
    } finally {
      setSaving(false);
    }
  };

  const handleEditSave = async () => {
    if (!editingContent) return;
    const message = validateForm();
    if (message) {
      setError(message);
      return;
    }

    try {
      setSaving(true);
      setError("");
      await updateDoctorContent({
        contentId: editingContent.id,
        title: form.title.trim(),
        anesthesiaType: form.anesthesiaType,
        description: form.description.trim(),
        body: form.body.trim(),
      });
      setIsEditOpen(false);
      resetForm();
      await loadContents();
    } catch (saveErr) {
      console.error("[DoctorContent] update failed", saveErr);
      setError("Gagal mengubah konten. Periksa rules/konfigurasi Firestore.");
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (content: DoctorContentItem) => {
    if (!window.confirm(`Hapus konten "${content.title}"?`)) return;

    try {
      setError("");
      await deleteDoctorContent(content.id);
      await loadContents();
    } catch (deleteErr) {
      console.error("[DoctorContent] delete failed", deleteErr);
      setError("Gagal menghapus konten. Pastikan Anda pemilik konten tersebut.");
    }
  };

  const openEditDialog = (content: DoctorContentItem) => {
    setEditingContent(content);
    setForm(normalizeFormFromContent(content));
    setIsEditOpen(true);
  };

  const statusSummary = useMemo(
    () => [
      { label: "Total Konten", value: totalContents },
      { label: "Published", value: publishedContents },
      { label: "Draft", value: draftContents },
    ],
    [draftContents, publishedContents, totalContents],
  );

  return (
    <DoctorLayout>
      <div className="p-8 space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Konten Edukasi</h1>
            <p className="text-gray-600 mt-1">Konten dokter terhubung langsung ke Firestore</p>
          </div>

          <Dialog
            open={isCreateOpen}
            onOpenChange={(open) => {
              setIsCreateOpen(open);
              if (!open) resetForm();
            }}
          >
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
                  Konten yang dibuat akan tersimpan di Firestore dengan status awal draft.
                </DialogDescription>
              </DialogHeader>
              <div className="space-y-4">
                <div className="space-y-2">
                  <Label>Judul</Label>
                  <Input
                    value={form.title}
                    onChange={(e) => setForm((prev) => ({ ...prev, title: e.target.value }))}
                    placeholder="Contoh: Persiapan Anestesi Spinal untuk Pasien"
                  />
                </div>
                <div className="space-y-2">
                  <Label>Jenis Anestesi</Label>
                  <Select
                    value={form.anesthesiaType}
                    onValueChange={(value) => setForm((prev) => ({ ...prev, anesthesiaType: value }))}
                  >
                    <SelectTrigger>
                      <SelectValue placeholder="Pilih jenis anestesi" />
                    </SelectTrigger>
                    <SelectContent>
                      {ANESTHESIA_OPTIONS.map((item) => (
                        <SelectItem key={item} value={item}>
                          {item}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Deskripsi Singkat</Label>
                  <Textarea
                    value={form.description}
                    onChange={(e) => setForm((prev) => ({ ...prev, description: e.target.value }))}
                    rows={3}
                  />
                </div>
                <div className="space-y-2">
                  <Label>Isi Konten</Label>
                  <Textarea
                    value={form.body}
                    onChange={(e) => setForm((prev) => ({ ...prev, body: e.target.value }))}
                    rows={8}
                  />
                </div>
                <div className="flex justify-end gap-2">
                  <Button variant="outline" onClick={() => setIsCreateOpen(false)} disabled={saving}>
                    Batal
                  </Button>
                  <Button onClick={() => void handleCreate()} disabled={saving}>
                    {saving ? "Menyimpan..." : "Simpan Draft"}
                  </Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        </div>

        {error && (
          <Card className="border-red-200">
            <CardContent className="pt-6 text-red-700 text-sm">
              <div className="flex items-start gap-2">
                <AlertCircle className="w-4 h-4 mt-0.5" />
                <span>{error}</span>
              </div>
            </CardContent>
          </Card>
        )}

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {statusSummary.map((item, idx) => (
            <Card key={item.label}>
              <CardContent className="p-6">
                <div className="flex items-center gap-4">
                  <div className={`p-3 rounded-lg ${idx === 0 ? "bg-blue-100" : idx === 1 ? "bg-green-100" : "bg-yellow-100"}`}>
                    {idx === 0 && <FileText className="w-6 h-6 text-blue-600" />}
                    {idx === 1 && <BookOpen className="w-6 h-6 text-green-600" />}
                    {idx === 2 && <Edit className="w-6 h-6 text-yellow-600" />}
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">{item.label}</p>
                    <p className="text-2xl font-bold">{item.value}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Daftar Konten Edukasi</CardTitle>
            <CardDescription>Semua data di bawah ini berasal dari Firestore.</CardDescription>
          </CardHeader>
          <CardContent>
            {isLoading ? (
              <div className="text-sm text-gray-600">Memuat konten...</div>
            ) : contents.length === 0 ? (
              <div className="text-sm text-gray-500">Belum ada konten untuk dokter ini.</div>
            ) : (
              <div className="space-y-4">
                {contents.map((content) => (
                  <div key={content.id} className="p-4 border rounded-lg hover:shadow-sm transition-shadow">
                    <div className="flex items-start justify-between gap-4">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-2 flex-wrap">
                          <FileText className="w-5 h-5 text-blue-600" />
                          <h3 className="font-semibold text-lg">{content.title}</h3>
                          <Badge className={getAnesthesiaColor(content.anesthesiaType)}>
                            {content.anesthesiaType}
                          </Badge>
                          <Badge variant="outline">
                            {content.status === "published" ? "Published" : "Draft"}
                          </Badge>
                        </div>
                        <p className="text-sm text-gray-600 mb-3">{content.description}</p>
                        <div className="text-xs text-gray-500">Dibuat: {content.createdAt}</div>
                      </div>
                      <div className="flex gap-2">
                        <Button
                          variant="outline"
                          size="sm"
                          className="gap-2"
                          onClick={() => openEditDialog(content)}
                        >
                          <Edit className="w-4 h-4" />
                          Edit
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          className="gap-2 text-red-600 hover:bg-red-50"
                          onClick={() => void handleDelete(content)}
                        >
                          <Trash2 className="w-4 h-4" />
                          Hapus
                        </Button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        <Dialog
          open={isEditOpen}
          onOpenChange={(open) => {
            setIsEditOpen(open);
            if (!open) resetForm();
          }}
        >
          <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>Edit Konten</DialogTitle>
              <DialogDescription>Perubahan akan langsung disimpan ke Firestore.</DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div className="space-y-2">
                <Label>Judul</Label>
                <Input
                  value={form.title}
                  onChange={(e) => setForm((prev) => ({ ...prev, title: e.target.value }))}
                />
              </div>
              <div className="space-y-2">
                <Label>Jenis Anestesi</Label>
                <Select
                  value={form.anesthesiaType}
                  onValueChange={(value) => setForm((prev) => ({ ...prev, anesthesiaType: value }))}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Pilih jenis anestesi" />
                  </SelectTrigger>
                  <SelectContent>
                    {ANESTHESIA_OPTIONS.map((item) => (
                      <SelectItem key={item} value={item}>
                        {item}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Deskripsi</Label>
                <Textarea
                  value={form.description}
                  onChange={(e) => setForm((prev) => ({ ...prev, description: e.target.value }))}
                  rows={3}
                />
              </div>
              <div className="space-y-2">
                <Label>Isi Konten</Label>
                <Textarea
                  value={form.body}
                  onChange={(e) => setForm((prev) => ({ ...prev, body: e.target.value }))}
                  rows={8}
                />
              </div>
              <div className="flex justify-end gap-2">
                <Button variant="outline" onClick={() => setIsEditOpen(false)} disabled={saving}>
                  Batal
                </Button>
                <Button onClick={() => void handleEditSave()} disabled={saving}>
                  {saving ? "Menyimpan..." : "Simpan Perubahan"}
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </DoctorLayout>
  );
}
