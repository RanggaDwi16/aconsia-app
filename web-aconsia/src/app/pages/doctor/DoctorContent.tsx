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
import { Checkbox } from "../../components/ui/checkbox";
import { Plus, FileText, BookOpen, Trash2, Edit, AlertCircle } from "lucide-react";
import { getDesktopSession } from "../../../core/auth/session";
import { userMessages } from "../../copy/userMessages";
import { getDoctorScopedPatients } from "../../../modules/doctor/services/doctorDashboardService";
import {
  assignDoctorContentToPatients,
  createDoctorContent,
  deleteDoctorContent,
  doctorContentAnesthesiaOptions,
  getDoctorContentAssignmentRecipients,
  getDoctorContents,
  unassignAllDoctorContentRecipients,
  unassignDoctorContentFromPatients,
  updateDoctorContent,
  type ContentAssignmentRecipient,
  type DoctorContentItem,
} from "../../../modules/doctor/services/doctorContentService";

type FormState = {
  title: string;
  anesthesiaType: string;
  description: string;
  body: string;
};

type AssignPatientItem = {
  id: string;
  fullName: string;
  mrn: string;
};

const EMPTY_FORM: FormState = {
  title: "",
  anesthesiaType: "",
  description: "",
  body: "",
};

const ANESTHESIA_OPTIONS = doctorContentAnesthesiaOptions;

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
  const [successMessage, setSuccessMessage] = useState("");
  const [isCreateOpen, setIsCreateOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [isAssignOpen, setIsAssignOpen] = useState(false);
  const [isManageAssignmentOpen, setIsManageAssignmentOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [assigning, setAssigning] = useState(false);
  const [form, setForm] = useState<FormState>(EMPTY_FORM);
  const [editingContent, setEditingContent] = useState<DoctorContentItem | null>(null);
  const [assigningContent, setAssigningContent] = useState<DoctorContentItem | null>(null);
  const [managingAssignmentContent, setManagingAssignmentContent] = useState<DoctorContentItem | null>(null);
  const [assignPatients, setAssignPatients] = useState<AssignPatientItem[]>([]);
  const [selectedPasienIds, setSelectedPasienIds] = useState<string[]>([]);
  const [assignSearch, setAssignSearch] = useState("");
  const [unassignSearch, setUnassignSearch] = useState("");
  const [selectedUnassignPasienIds, setSelectedUnassignPasienIds] = useState<string[]>([]);
  const [assignmentRecipientsByContent, setAssignmentRecipientsByContent] = useState<
    Record<string, ContentAssignmentRecipient[]>
  >({});
  const [bulkUnassigning, setBulkUnassigning] = useState(false);

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
      const recipientsMap = await getDoctorContentAssignmentRecipients(
        session.uid,
        data.map((item) => item.id),
      );
      setContents(data);
      setAssignmentRecipientsByContent(recipientsMap);
      setError("");
    } catch (loadErr) {
      console.error("[DoctorContent] Firestore load failed", loadErr);
      setError(userMessages.doctorContent.loadError);
      setContents([]);
      setAssignmentRecipientsByContent({});
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    void loadContents();
  }, [session?.uid]);

  const getAnesthesiaColor = (type: string) => {
    const colors: Record<string, string> = {
      "Anestesi Spinal": "bg-purple-100 text-purple-700",
      "Anestesi Umum": "bg-blue-100 text-blue-700",
      "Anestesi Epidural": "bg-green-100 text-green-700",
      "Anestesi Regional": "bg-yellow-100 text-yellow-700",
      "Anestesi Lokal + Sedasi": "bg-pink-100 text-pink-700",
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
      setSuccessMessage("");
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
      setSuccessMessage("Konten draft berhasil disimpan.");
      await loadContents();
    } catch (saveErr) {
      console.error("[DoctorContent] create failed", saveErr);
      setError(userMessages.doctorContent.createError);
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
      setSuccessMessage("");
      await updateDoctorContent({
        contentId: editingContent.id,
        title: form.title.trim(),
        anesthesiaType: form.anesthesiaType,
        description: form.description.trim(),
        body: form.body.trim(),
      });
      setIsEditOpen(false);
      resetForm();
      setSuccessMessage("Konten berhasil diperbarui.");
      await loadContents();
    } catch (saveErr) {
      console.error("[DoctorContent] update failed", saveErr);
      setError(userMessages.doctorContent.updateError);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (content: DoctorContentItem) => {
    if (!window.confirm(`Hapus konten "${content.title}"?`)) return;

    try {
      setError("");
      setSuccessMessage("");
      await deleteDoctorContent(content.id);
      setSuccessMessage("Konten berhasil dihapus.");
      await loadContents();
    } catch (deleteErr) {
      console.error("[DoctorContent] delete failed", deleteErr);
      setError(userMessages.doctorContent.deleteError);
    }
  };

  const openEditDialog = (content: DoctorContentItem) => {
    setEditingContent(content);
    setForm(normalizeFormFromContent(content));
    setIsEditOpen(true);
  };

  const openAssignDialog = async (content: DoctorContentItem) => {
    if (!session?.uid) return;
    if (content.status !== "published") {
      setError("Konten draft belum bisa di-assign. Publish via Admin terlebih dahulu.");
      return;
    }
    try {
      setError("");
      setSuccessMessage("");
      const pasienList = await getDoctorScopedPatients(session.uid);
      const mappedPatients = pasienList.map((item) => ({
        id: item.id,
        fullName: item.fullName,
        mrn: item.mrn,
      }));
      setAssignPatients(mappedPatients);
      setAssigningContent(content);
      setSelectedPasienIds([]);
      setAssignSearch("");
      setIsAssignOpen(true);
    } catch (loadErr) {
      console.error("[DoctorContent] load pasien for assign failed", loadErr);
      setError("Gagal memuat daftar pasien untuk assignment.");
    }
  };

  const filteredAssignPatients = useMemo(() => {
    const keyword = assignSearch.trim().toLowerCase();
    if (!keyword) return assignPatients;
    return assignPatients.filter((patient) => {
      const label = `${patient.fullName} ${patient.mrn}`.toLowerCase();
      return label.includes(keyword);
    });
  }, [assignPatients, assignSearch]);

  const toggleSelectedPasien = (pasienId: string) => {
    setSelectedPasienIds((prev) =>
      prev.includes(pasienId) ? prev.filter((id) => id !== pasienId) : [...prev, pasienId],
    );
  };

  const handleSelectAllFiltered = () => {
    const filteredIds = filteredAssignPatients.map((patient) => patient.id);
    setSelectedPasienIds((prev) => Array.from(new Set([...prev, ...filteredIds])));
  };

  const handleClearSelection = () => {
    setSelectedPasienIds([]);
  };

  const handleAssignContent = async () => {
    if (!session?.uid || !assigningContent || selectedPasienIds.length === 0) return;
    try {
      setAssigning(true);
      setError("");
      setSuccessMessage("");
      const result = await assignDoctorContentToPatients({
        doctorUid: session.uid,
        contentId: assigningContent.id,
        pasienIds: selectedPasienIds,
      });
      if (result.assignedCount > 0 && result.failedCount === 0) {
        setSuccessMessage(`Konten berhasil di-assign ke ${result.assignedCount} pasien.`);
      } else if (result.assignedCount > 0 && result.failedCount > 0) {
        const failedSample = result.failedPatients
          .slice(0, 2)
          .map((item) => item.reason)
          .join(", ");
        setSuccessMessage(
          `Berhasil assign ke ${result.assignedCount} pasien. ${result.failedCount} gagal${
            failedSample ? ` (${failedSample}${result.failedCount > 2 ? ", dst." : ""})` : "."
          }`,
        );
      } else {
        setError("Assign konten gagal. Pastikan pasien berada di scope dokter.");
        return;
      }
      setIsAssignOpen(false);
      setAssigningContent(null);
      setSelectedPasienIds([]);
      setAssignSearch("");
      await loadContents();
    } catch (assignErr) {
      console.error("[DoctorContent] assign failed", assignErr);
      setError("Assign konten gagal. Pastikan pasien berada di scope dokter.");
    } finally {
      setAssigning(false);
    }
  };

  const openManageAssignmentDialog = (content: DoctorContentItem) => {
    setManagingAssignmentContent(content);
    setSelectedUnassignPasienIds([]);
    setUnassignSearch("");
    setIsManageAssignmentOpen(true);
  };

  const manageRecipients = useMemo(() => {
    if (!managingAssignmentContent) return [];
    return assignmentRecipientsByContent[managingAssignmentContent.id] || [];
  }, [assignmentRecipientsByContent, managingAssignmentContent]);

  const filteredManageRecipients = useMemo(() => {
    const keyword = unassignSearch.trim().toLowerCase();
    if (!keyword) return manageRecipients;
    return manageRecipients.filter((item) => item.fullName.toLowerCase().includes(keyword) || item.mrn.toLowerCase().includes(keyword));
  }, [manageRecipients, unassignSearch]);

  const toggleSelectedUnassign = (pasienId: string) => {
    setSelectedUnassignPasienIds((prev) =>
      prev.includes(pasienId) ? prev.filter((id) => id !== pasienId) : [...prev, pasienId],
    );
  };

  const handleUnassignSelectedFromManage = async () => {
    if (!session?.uid || !managingAssignmentContent || selectedUnassignPasienIds.length === 0) return;
    setBulkUnassigning(true);
    try {
      setError("");
      setSuccessMessage("");
      const result = await unassignDoctorContentFromPatients({
        doctorUid: session.uid,
        contentId: managingAssignmentContent.id,
        pasienIds: selectedUnassignPasienIds,
      });
      if (result.updatedCount > 0) {
        setSuccessMessage(`Berhasil batalkan assignment ${result.updatedCount} pasien.`);
      }
      if (result.failedCount > 0 && result.updatedCount === 0) {
        setError(result.failedPatients[0]?.reason || "Gagal membatalkan assignment.");
      }
      setIsManageAssignmentOpen(false);
      setSelectedUnassignPasienIds([]);
      await loadContents();
    } catch (error) {
      console.error("[DoctorContent] unassign selected failed", error);
      setError("Gagal membatalkan assignment terpilih.");
    } finally {
      setBulkUnassigning(false);
    }
  };

  const handleUnassignAllFromManage = async () => {
    if (!session?.uid || !managingAssignmentContent) return;
    const confirmed = window.confirm("Batalkan assignment untuk semua pasien pada konten ini?");
    if (!confirmed) return;
    setBulkUnassigning(true);
    try {
      setError("");
      setSuccessMessage("");
      const result = await unassignAllDoctorContentRecipients({
        doctorUid: session.uid,
        contentId: managingAssignmentContent.id,
      });
      if (result.updatedCount > 0) {
        setSuccessMessage(`Berhasil batalkan assignment ${result.updatedCount} pasien.`);
      } else {
        setSuccessMessage("Tidak ada assignment aktif yang perlu dibatalkan.");
      }
      setIsManageAssignmentOpen(false);
      await loadContents();
    } catch (error) {
      console.error("[DoctorContent] unassign all from manage failed", error);
      setError("Gagal membatalkan semua assignment.");
    } finally {
      setBulkUnassigning(false);
    }
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
            <p className="text-gray-600 mt-1">{userMessages.doctorContent.subtitle}</p>
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
                  {userMessages.doctorContent.createDialogDescription}
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
        {!error && successMessage && (
          <Card className="border-green-200 bg-green-50">
            <CardContent className="pt-6 text-green-700 text-sm">{successMessage}</CardContent>
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
            <CardDescription>{userMessages.doctorContent.listDescription}</CardDescription>
          </CardHeader>
          <CardContent>
            {isLoading ? (
              <div className="text-sm text-gray-600">Memuat konten...</div>
            ) : contents.length === 0 ? (
              <div className="text-sm text-gray-500">Belum ada konten untuk dokter ini.</div>
            ) : (
              <div className="space-y-4">
                {contents.map((content) => (
                  <div
                    key={content.id}
                    className="rounded-xl border border-slate-200 p-4 transition-shadow hover:shadow-sm"
                  >
                    <div className="grid grid-cols-1 gap-4 lg:grid-cols-[minmax(0,1fr)_auto]">
                      <div className="min-w-0">
                        <div className="mb-2 flex flex-wrap items-center gap-2">
                          <FileText className="h-5 w-5 text-blue-600" />
                          <h3 className="truncate text-lg font-semibold text-slate-900">{content.title}</h3>
                          <Badge className={getAnesthesiaColor(content.anesthesiaType)}>
                            {content.anesthesiaType}
                          </Badge>
                          <Badge variant="outline" className="text-slate-600">
                            {content.status === "published" ? "Published" : "Draft"}
                          </Badge>
                        </div>
                        <p className="mb-3 line-clamp-2 text-sm text-slate-600">{content.description}</p>
                        <div className="rounded-lg border border-slate-200 bg-slate-50/70 p-3">
                          <div className="mb-2 flex items-center justify-between gap-2">
                            <p className="text-xs font-semibold text-slate-700">Di-assign ke</p>
                            <span className="text-[11px] text-slate-500">
                              {assignmentRecipientsByContent[content.id]?.length || 0} pasien
                            </span>
                          </div>
                          {assignmentRecipientsByContent[content.id]?.length ? (
                            <div className="flex flex-wrap gap-1.5">
                              {assignmentRecipientsByContent[content.id].slice(0, 4).map((recipient) => (
                                <Badge
                                  key={recipient.pasienId}
                                  variant="secondary"
                                  className="bg-white text-slate-700"
                                >
                                  {recipient.fullName}
                                </Badge>
                              ))}
                              {assignmentRecipientsByContent[content.id].length > 4 && (
                                <Badge variant="outline" className="text-slate-600">
                                  +{assignmentRecipientsByContent[content.id].length - 4} lainnya
                                </Badge>
                              )}
                            </div>
                          ) : (
                            <p className="text-xs text-slate-500">Belum di-assign</p>
                          )}
                        </div>
                        <div className="mt-3 text-xs text-slate-500">Dibuat: {content.createdAt}</div>
                        {content.status !== "published" && (
                          <div className="mt-2 text-xs font-medium text-amber-700">
                            Publish via Admin terlebih dahulu sebelum assign ke pasien.
                          </div>
                        )}
                      </div>
                      <div className="flex w-full flex-wrap items-start justify-start gap-2 md:w-auto md:flex-nowrap md:justify-end">
                        <Button
                          variant="outline"
                          size="sm"
                          className="gap-2"
                          onClick={() => void openAssignDialog(content)}
                          disabled={content.status !== "published"}
                        >
                          Assign
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          className="gap-2"
                          onClick={() => openManageAssignmentDialog(content)}
                        >
                          Kelola
                        </Button>
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
                          Hapus Konten
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
              <DialogDescription>{userMessages.doctorContent.editDialogDescription}</DialogDescription>
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

        <Dialog
          open={isAssignOpen}
          onOpenChange={(open) => {
            setIsAssignOpen(open);
            if (!open) {
              setAssigningContent(null);
              setSelectedPasienIds([]);
              setAssignSearch("");
            }
          }}
        >
          <DialogContent className="max-w-lg">
            <DialogHeader>
              <DialogTitle>Assign Konten ke Pasien</DialogTitle>
              <DialogDescription>
                Pilih pasien yang akan menerima konten ini.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-3">
              <p className="text-sm text-gray-700">
                Konten: <span className="font-semibold">{assigningContent?.title || "-"}</span>
              </p>
              <div className="space-y-2">
                <Label>Pilih Pasien</Label>
                <Input
                  value={assignSearch}
                  onChange={(event) => setAssignSearch(event.target.value)}
                  placeholder="Cari pasien berdasarkan nama/RM..."
                />
                <div className="flex items-center justify-between text-xs">
                  <span className="text-gray-600">{selectedPasienIds.length} pasien dipilih</span>
                  <div className="flex gap-2">
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="h-7 px-2 text-xs"
                      onClick={handleSelectAllFiltered}
                      disabled={filteredAssignPatients.length === 0}
                    >
                      Pilih semua
                    </Button>
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="h-7 px-2 text-xs"
                      onClick={handleClearSelection}
                      disabled={selectedPasienIds.length === 0}
                    >
                      Hapus semua
                    </Button>
                  </div>
                </div>
                <div className="max-h-56 overflow-y-auto rounded-md border">
                  {filteredAssignPatients.length === 0 ? (
                    <div className="p-3 text-sm text-gray-500">Pasien tidak ditemukan.</div>
                  ) : (
                    filteredAssignPatients.map((patient) => (
                      <label
                        key={patient.id}
                        className="flex cursor-pointer items-center gap-3 border-b px-3 py-2 text-sm last:border-b-0 hover:bg-gray-50"
                      >
                        <Checkbox
                          checked={selectedPasienIds.includes(patient.id)}
                          onCheckedChange={() => toggleSelectedPasien(patient.id)}
                        />
                        <span className="flex-1">
                          {patient.fullName} <span className="text-gray-500">(RM: {patient.mrn})</span>
                        </span>
                      </label>
                    ))
                  )}
                </div>
              </div>
              {assignPatients.length === 0 && (
                <p className="text-sm text-amber-700">
                  Belum ada pasien ter-assign pada akun dokter ini.
                </p>
              )}
            </div>
            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setIsAssignOpen(false)} disabled={assigning}>
                Batal
              </Button>
              <Button
                onClick={() => void handleAssignContent()}
                disabled={assigning || selectedPasienIds.length === 0 || assignPatients.length === 0}
              >
                {assigning ? "Menyimpan..." : "Assign"}
              </Button>
            </div>
          </DialogContent>
        </Dialog>

        <Dialog
          open={isManageAssignmentOpen}
          onOpenChange={(open) => {
            setIsManageAssignmentOpen(open);
            if (!open) {
              setManagingAssignmentContent(null);
              setSelectedUnassignPasienIds([]);
              setUnassignSearch("");
            }
          }}
        >
          <DialogContent className="max-w-lg">
            <DialogHeader>
              <DialogTitle>Kelola Assignment</DialogTitle>
              <DialogDescription>
                Batalkan assignment per pasien atau sekaligus semua pasien.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-3">
              <p className="text-sm text-gray-700">
                Konten: <span className="font-semibold">{managingAssignmentContent?.title || "-"}</span>
              </p>
              <Input
                value={unassignSearch}
                onChange={(event) => setUnassignSearch(event.target.value)}
                placeholder="Cari pasien..."
              />
              <div className="text-xs text-gray-600">{selectedUnassignPasienIds.length} pasien dipilih</div>
              <div className="max-h-56 overflow-y-auto rounded-md border">
                {filteredManageRecipients.length === 0 ? (
                  <div className="p-3 text-sm text-gray-500">Belum ada assignment aktif.</div>
                ) : (
                  filteredManageRecipients.map((recipient) => (
                    <label
                      key={recipient.pasienId}
                      className="flex cursor-pointer items-center gap-3 border-b px-3 py-2 text-sm last:border-b-0 hover:bg-gray-50"
                    >
                      <Checkbox
                        checked={selectedUnassignPasienIds.includes(recipient.pasienId)}
                        onCheckedChange={() => toggleSelectedUnassign(recipient.pasienId)}
                      />
                      <span className="flex-1">
                        {recipient.fullName} <span className="text-gray-500">(RM: {recipient.mrn})</span>
                      </span>
                    </label>
                  ))
                )}
              </div>
            </div>
            <div className="flex justify-between gap-2">
              <Button
                variant="outline"
                className="text-red-600 hover:text-red-700"
                onClick={() => void handleUnassignAllFromManage()}
                disabled={bulkUnassigning || manageRecipients.length === 0}
              >
                Batalkan Semua
              </Button>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  onClick={() => setIsManageAssignmentOpen(false)}
                  disabled={bulkUnassigning}
                >
                  Tutup
                </Button>
                <Button
                  onClick={() => void handleUnassignSelectedFromManage()}
                  disabled={bulkUnassigning || selectedUnassignPasienIds.length === 0}
                >
                  {bulkUnassigning ? "Memproses..." : "Batalkan Terpilih"}
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </DoctorLayout>
  );
}
