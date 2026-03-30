import { useState, useEffect } from "react";
import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "../../components/ui/tabs";
import { BookOpen, FileText, CheckCircle, Eye, Lock, AlertCircle, MessageSquare } from "lucide-react";
import { Progress } from "../../components/ui/progress";
import { useNavigate } from "react-router";
import { getMaterialsByType } from "../../../data/learningMaterials";
import { canAccessAIChat } from "../../utils/dataSync";

export function PatientEducation() {
  const navigate = useNavigate();
  const [currentPatient, setCurrentPatient] = useState<any>(null);
  const [materials, setMaterials] = useState<any[]>([]);
  const [readingProgress, setReadingProgress] = useState<Record<string, number>>({});
  const [aiChatAccess, setAiChatAccess] = useState({
    canAccess: false,
    message: "",
    completedMaterials: 0,
    totalMaterials: 0
  });

  useEffect(() => {
    // Load patient data
    const patient = localStorage.getItem("currentPatient");
    if (patient) {
      const patientData = JSON.parse(patient);
      setCurrentPatient(patientData);
      
      // ✅ Load materials dari learningMaterials.ts berdasarkan jenis anestesi (SINGLE SOURCE OF TRUTH)
      if (patientData.anesthesiaType) {
        const patientMaterials = getMaterialsByType(patientData.anesthesiaType);
        setMaterials(patientMaterials);
        
        // Load saved reading progress
        const savedProgress = localStorage.getItem(`reading_progress_${patientData.id}`);
        if (savedProgress) {
          setReadingProgress(JSON.parse(savedProgress));
        }
        
        // Check AI Chat access
        const chatAccess = canAccessAIChat(patientData.id);
        setAiChatAccess(chatAccess);
      }
    }
  }, []);
  
  // ✅ SYNC: Ensure doctor and patient see the same materials
  const doctorMaterialsCount = materials.length;
  const patientMaterialsCount = materials.length; // Same source = always synced!
  const isSynced = doctorMaterialsCount === patientMaterialsCount;

  const completedCount = materials.filter(m => (readingProgress[m.id] || 0) === 100).length;
  const progressPercentage = materials.length > 0 
    ? Math.round((completedCount / materials.length) * 100) 
    : 0;

  return (
    <DashboardLayout role="patient" userName={currentPatient?.fullName || "Pasien"}>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Materi Edukasi</h1>
            <p className="text-gray-600 mt-1">
              Pelajari tentang {currentPatient?.anesthesiaType || "prosedur anestesi Anda"}
            </p>
          </div>
          
          {/* ✅ SYNC STATUS INDICATOR */}
          {isSynced ? (
            <Badge className="bg-green-600">
              ✓ Tersinkronisasi ({materials.length} materi)
            </Badge>
          ) : (
            <Badge className="bg-red-600">
              ⚠ Tidak Sinkron
            </Badge>
          )}
        </div>

        {/* ⚠️ WARNING: No Anesthesia Type Assigned */}
        {!currentPatient?.anesthesiaType && (
          <Card className="border-orange-200 bg-orange-50">
            <CardContent className="p-6">
              <div className="flex items-start gap-4">
                <AlertCircle className="w-8 h-8 text-orange-600 flex-shrink-0" />
                <div>
                  <h3 className="font-bold text-orange-900 mb-2">Menunggu Persetujuan Dokter</h3>
                  <p className="text-orange-800 text-sm">
                    Dokter anestesi belum memilih jenis anestesi untuk Anda. 
                    Materi edukasi akan muncul setelah dokter melakukan approval.
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Progress Overview */}
        {currentPatient?.anesthesiaType && (
          <Card className="bg-gradient-to-r from-blue-50 to-purple-50 border-2 border-blue-200">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <h3 className="text-lg font-semibold">Progress Pembelajaran</h3>
                  <p className="text-sm text-gray-600">
                    {completedCount} dari {materials.length} section selesai
                  </p>
                </div>
                <div className="text-right">
                  <p className="text-4xl font-bold text-blue-600">{progressPercentage}%</p>
                  <p className="text-xs text-gray-600">Tingkat Pemahaman</p>
                </div>
              </div>
              <Progress value={progressPercentage} className="h-4" />
              
              {/* AI Chat Status */}
              <div className="mt-4 p-4 bg-white border border-blue-200 rounded-lg">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <MessageSquare className="w-5 h-5 text-blue-600" />
                    <span className="text-sm font-semibold">Status AI Chat:</span>
                  </div>
                  {aiChatAccess.canAccess ? (
                    <Badge className="bg-green-600">✓ Tersedia</Badge>
                  ) : (
                    <Badge className="bg-gray-400">🔒 Terkunci</Badge>
                  )}
                </div>
                <p className="text-xs text-gray-600 mt-2">
                  {aiChatAccess.message}
                </p>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Education Content */}
        {currentPatient?.anesthesiaType && materials.length > 0 && (
          <Card>
            <CardHeader>
              <CardTitle>Materi Edukasi {currentPatient.anesthesiaType}</CardTitle>
              <CardDescription>
                {materials.length} section yang telah dipilih khusus untuk Anda
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-3">
              {materials.map((material, index) => {
                const progress = readingProgress[material.id] || 0;
                const isCompleted = progress === 100;
                const isPreviousCompleted = index === 0 || (readingProgress[materials[index - 1].id] || 0) === 100;
                const isLocked = !isPreviousCompleted;
                
                return (
                  <div
                    key={material.id}
                    className={`p-4 border-2 rounded-lg transition-all ${
                      isCompleted
                        ? "border-green-200 bg-green-50"
                        : isLocked
                          ? "border-gray-200 bg-gray-50 opacity-60"
                          : "border-blue-200 bg-white hover:shadow-md"
                    }`}
                  >
                    <div className="flex items-start gap-4">
                      <div className="flex-shrink-0">
                        {isCompleted ? (
                          <CheckCircle className="w-6 h-6 text-green-600" />
                        ) : isLocked ? (
                          <Lock className="w-6 h-6 text-gray-400" />
                        ) : (
                          <FileText className="w-6 h-6 text-blue-600" />
                        )}
                      </div>
                      
                      <div className="flex-1 min-w-0">
                        <div className="flex items-start justify-between gap-4 mb-2">
                          <div>
                            <h4 className="font-bold text-gray-900 mb-1">
                              Section {material.section}: {material.title}
                            </h4>
                            <p className="text-sm text-gray-600 line-clamp-2">
                              {material.description}
                            </p>
                          </div>
                          <Badge className={
                            isCompleted 
                              ? "bg-green-600 flex-shrink-0" 
                              : "bg-blue-600 flex-shrink-0"
                          }>
                            {progress}%
                          </Badge>
                        </div>
                        
                        <div className="flex items-center justify-between gap-4 mt-3">
                          <div className="flex items-center gap-3 text-xs text-gray-600">
                            <span>⏱ {material.estimatedTime}</span>
                            {isCompleted && <span className="text-green-600 font-semibold">✓ Selesai</span>}
                            {isLocked && <span className="text-gray-500">🔒 Selesaikan section sebelumnya</span>}
                          </div>
                          
                          <Button
                            size="sm"
                            onClick={() => navigate(`/patient/material/${material.id}`)}
                            disabled={isLocked}
                            className={
                              isLocked 
                                ? "bg-gray-300 cursor-not-allowed" 
                                : isCompleted
                                  ? "bg-green-600 hover:bg-green-700"
                                  : "bg-blue-600 hover:bg-blue-700"
                            }
                          >
                            {isCompleted ? "Baca Ulang" : "Mulai Baca"}
                          </Button>
                        </div>
                        
                        {/* Progress Bar */}
                        {!isLocked && progress > 0 && progress < 100 && (
                          <div className="mt-3">
                            <Progress value={progress} className="h-2" />
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                );
              })}
            </CardContent>
          </Card>
        )}
        
        {/* AI Chat CTA - Only show when all materials completed */}
        {aiChatAccess.canAccess && (
          <Card className="border-2 border-green-200 bg-gradient-to-br from-green-50 to-emerald-50">
            <CardContent className="p-8 text-center">
              <div className="w-20 h-20 bg-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <MessageSquare className="w-10 h-10 text-white" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-2">
                🎉 Selamat! Semua Materi Selesai
              </h3>
              <p className="text-gray-700 mb-6">
                Anda telah menyelesaikan {materials.length} section materi pembelajaran.<br />
                Langkah selanjutnya: Chat dengan AI Assistant untuk evaluasi pemahaman.
              </p>
              <Button 
                size="lg"
                className="bg-green-600 hover:bg-green-700 text-lg px-8 py-6 gap-3"
                onClick={() => navigate('/patient/chat-hybrid')}
              >
                <MessageSquare className="w-6 h-6" />
                Mulai AI Chat Evaluation
              </Button>
            </CardContent>
          </Card>
        )}
      </div>
    </DashboardLayout>
  );
}