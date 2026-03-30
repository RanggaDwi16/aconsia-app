import { useState, useEffect } from "react";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { 
  ArrowLeft, 
  Clock, 
  CheckCircle, 
  Lock,
  MessageSquare,
  BookOpen
} from "lucide-react";
import { useNavigate, useParams } from "react-router";
import { getMaterialsByType } from "../../../data/learningMaterials";

interface Material {
  id: string;
  title: string;
  description: string;
  type: string;
  section: number;
  part: number;
  content: string;
  estimatedTime: string;
  quiz?: {
    question: string;
    options: string[];
    correctAnswer: number;
    explanation: string;
  };
  readingProgress: number;
  status: "not_started" | "in_progress" | "completed";
}

export function EnhancedMaterialReader() {
  const navigate = useNavigate();
  const { materialId } = useParams();
  
  const [isOnline, setIsOnline] = useState(navigator.onLine);
  const [currentPatient, setCurrentPatient] = useState<any>(null);
  const [materials, setMaterials] = useState<Material[]>([]);
  const [currentMaterialIndex, setCurrentMaterialIndex] = useState(0);
  const [readingProgress, setReadingProgress] = useState<Record<string, number>>({});
  const [readingTime, setReadingTime] = useState<Record<string, number>>({});
  const [allMaterialsCompleted, setAllMaterialsCompleted] = useState(false);
  
  // ✅ Real countdown timer states
  const [remainingSeconds, setRemainingSeconds] = useState(45);
  const [isReading, setIsReading] = useState(false);
  const [timerStarted, setTimerStarted] = useState(false);
  
  // ✅ Quiz states
  const [showQuiz, setShowQuiz] = useState(false);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [quizSubmitted, setQuizSubmitted] = useState(false);
  const [quizPassed, setQuizPassed] = useState(false);
  const [quizCompleted, setQuizCompleted] = useState<Record<string, boolean>>({});
  
  // Load patient data and materials
  useEffect(() => {
    const patient = localStorage.getItem("currentPatient");
    if (patient) {
      const patientData = JSON.parse(patient);
      setCurrentPatient(patientData);
      
      // Load materials dari learningMaterials.ts berdasarkan jenis anestesi
      if (patientData.anesthesiaType) {
        const patientMaterials = getMaterialsByType(patientData.anesthesiaType);
        
        // Format materials with progress data
        const formattedMaterials = patientMaterials.map((m: any) => ({
          ...m,
          readingProgress: 0,
          status: "not_started" as const
        }));
        
        setMaterials(formattedMaterials);
        
        // Load saved reading progress
        const savedProgress = localStorage.getItem(`reading_progress_${patientData.id}`);
        if (savedProgress) {
          setReadingProgress(JSON.parse(savedProgress));
        }
        
        const savedTime = localStorage.getItem(`reading_time_${patientData.id}`);
        if (savedTime) {
          setReadingTime(JSON.parse(savedTime));
        }
        
        // Load saved quiz completed status
        const savedQuizCompleted = localStorage.getItem(`quiz_completed_${patientData.id}`);
        if (savedQuizCompleted) {
          setQuizCompleted(JSON.parse(savedQuizCompleted));
        }
      } else {
        // Jika belum ada jenis anestesi, redirect ke home
        navigate("/patient");
      }
    } else {
      navigate("/patient");
    }
  }, [navigate]);

  // Check if all materials are completed
  useEffect(() => {
    if (materials.length > 0 && currentPatient) {
      const allCompleted = materials.every((m) => {
        const progress = readingProgress[m.id] || 0;
        return progress >= 100;
      });
      setAllMaterialsCompleted(allCompleted);
      
      // Update patient comprehension score
      if (allCompleted) {
        const updatedPatient = {
          ...currentPatient,
          comprehensionScore: 100,
          status: "ready",
          materialsReadCount: materials.length
        };
        localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
        
        // Sync to demoPatients
        const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
        const patientIndex = demoPatients.findIndex((p: any) => p.id === currentPatient.id);
        if (patientIndex !== -1) {
          demoPatients[patientIndex] = updatedPatient;
          localStorage.setItem("demoPatients", JSON.stringify(demoPatients));
        }
      }
    }
  }, [materials, readingProgress, currentPatient]);

  // Online/offline listener
  useEffect(() => {
    const handleOnlineStatusChange = () => {
      setIsOnline(navigator.onLine);
    };

    window.addEventListener('online', handleOnlineStatusChange);
    window.addEventListener('offline', handleOnlineStatusChange);

    return () => {
      window.removeEventListener('online', handleOnlineStatusChange);
      window.removeEventListener('offline', handleOnlineStatusChange);
    };
  }, []);

  // ✅ Real-time countdown timer that actually runs!
  useEffect(() => {
    if (materials.length === 0) return;
    
    // Reset timer when changing material
    setRemainingSeconds(45);
    setTimerStarted(true); // ✅ Auto-start timer immediately!
    setIsReading(true);
  }, [currentMaterialIndex, materials.length]);

  // ✅ Countdown timer logic
  useEffect(() => {
    if (materials.length === 0) return;
    
    const material = materials[currentMaterialIndex];
    if (!material) return;
    
    const currentProgress = readingProgress[material.id] || 0;
    
    if (!timerStarted || remainingSeconds <= 0 || currentProgress >= 100) return;

    const interval = setInterval(() => {
      setRemainingSeconds(prev => {
        if (prev <= 1) {
          return 0;
        }
        return prev - 1;
      });
    }, 1000); // Countdown setiap 1 detik

    return () => clearInterval(interval);
  }, [timerStarted, remainingSeconds, readingProgress, materials, currentMaterialIndex]);

  // ✅ Auto-show quiz when reading is complete
  useEffect(() => {
    if (materials.length === 0) return;
    
    const material = materials[currentMaterialIndex];
    if (!material) return;
    
    const currentProgress = readingProgress[material.id] || 0;
    const isQuizAlreadyPassed = quizCompleted[material.id] || false;
    
    // Show quiz if: (progress 100% OR timer 0) AND quiz not completed yet
    if ((currentProgress >= 100 || remainingSeconds === 0) && !isQuizAlreadyPassed && !showQuiz) {
      setShowQuiz(true);
    }
  }, [readingProgress, remainingSeconds, materials, currentMaterialIndex, quizCompleted, showQuiz]);

  // Handle scroll to track reading
  const handleScroll = (materialId: string) => {
    // ✅ Start timer on first scroll
    if (!timerStarted) {
      setTimerStarted(true);
      setIsReading(true);
    }

    const element = document.getElementById(`material-${materialId}`);
    if (!element) return;
    
    const scrollTop = element.scrollTop;
    const scrollHeight = element.scrollHeight - element.clientHeight;
    const progress = scrollHeight > 0 ? Math.min(100, Math.round((scrollTop / scrollHeight) * 100)) : 0;
    
    setReadingProgress(prev => {
      const newProgress = { ...prev, [materialId]: Math.max(prev[materialId] || 0, progress) };
      
      // Save to localStorage
      if (currentPatient) {
        localStorage.setItem(`reading_progress_${currentPatient.id}`, JSON.stringify(newProgress));
      }
      
      return newProgress;
    });
  };

  // Mark material as complete
  const handleMarkComplete = (materialId: string) => {
    setReadingProgress(prev => {
      const newProgress = { ...prev, [materialId]: 100 };
      
      // Save to localStorage
      if (currentPatient) {
        localStorage.setItem(`reading_progress_${currentPatient.id}`, JSON.stringify(newProgress));
      }
      
      return newProgress;
    });
  };

  // Navigate to next material
  const handleNextMaterial = () => {
    if (currentMaterialIndex < materials.length - 1) {
      setCurrentMaterialIndex(currentMaterialIndex + 1);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  // Navigate to previous material
  const handlePrevMaterial = () => {
    if (currentMaterialIndex > 0) {
      setCurrentMaterialIndex(currentMaterialIndex - 1);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  // ✅ Handle quiz submission
  const handleQuizSubmit = () => {
    if (selectedAnswer === null) return;
    
    const material = materials[currentMaterialIndex];
    if (!material || !material.quiz) return;
    
    const isCorrect = selectedAnswer === material.quiz.correctAnswer;
    setQuizSubmitted(true);
    setQuizPassed(isCorrect);
    
    if (isCorrect) {
      // Mark quiz as completed
      setQuizCompleted(prev => {
        const updated = { ...prev, [material.id]: true };
        if (currentPatient) {
          localStorage.setItem(`quiz_completed_${currentPatient.id}`, JSON.stringify(updated));
        }
        return updated;
      });
      
      // Mark material as 100% complete
      setReadingProgress(prev => {
        const newProgress = { ...prev, [material.id]: 100 };
        if (currentPatient) {
          localStorage.setItem(`reading_progress_${currentPatient.id}`, JSON.stringify(newProgress));
        }
        return newProgress;
      });
    }
  };

  // ✅ Close quiz and move to next
  const handleQuizContinue = () => {
    if (quizPassed) {
      setShowQuiz(false);
      setSelectedAnswer(null);
      setQuizSubmitted(false);
      setQuizPassed(false);
      
      // Auto move to next material
      if (currentMaterialIndex < materials.length - 1) {
        setCurrentMaterialIndex(currentMaterialIndex + 1);
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    }
  };

  // ✅ Retry quiz
  const handleQuizRetry = () => {
    setSelectedAnswer(null);
    setQuizSubmitted(false);
    setQuizPassed(false);
  };

  if (!currentPatient || materials.length === 0) {
    return (
      <div className="min-h-screen bg-white flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Memuat materi pembelajaran...</p>
        </div>
      </div>
    );
  }

  const currentMaterial = materials[currentMaterialIndex];
  const progress = readingProgress[currentMaterial?.id] || 0;
  const overallProgress = Math.round(
    (Object.values(readingProgress).reduce((a, b) => a + b, 0) / (materials.length * 100)) * 100
  );
  
  // Calculate remaining time based on current progress (real-time)
  const remainingTime = Math.ceil(45 * (100 - progress) / 100);

  return (
    <div className="min-h-screen bg-white">
      {/* Online/Offline Banner */}
      {!isOnline && (
        <div className="bg-red-600 text-white py-2 px-4 text-center text-sm font-semibold sticky top-0 z-50">
          ⚠️ Tidak ada koneksi internet - Mode Offline
        </div>
      )}
      
      {/* Header */}
      <div className="sticky top-0 bg-white border-b border-gray-200 z-40">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between mb-3">
            <Button 
              variant="ghost" 
              size="sm" 
              onClick={() => navigate('/patient')}
              className="gap-2"
            >
              <ArrowLeft className="w-4 h-4" />
              Kembali
            </Button>
            
            <div className="flex items-center gap-2">
              <Badge className="bg-blue-600 text-white">
                {currentPatient.anesthesiaType}
              </Badge>
              <Badge variant="outline">
                Part {currentMaterialIndex + 1} / {materials.length}
              </Badge>
            </div>
          </div>
          
          {/* Overall Progress */}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold text-gray-700">
                Progress Keseluruhan
              </span>
              <span className="text-sm font-bold text-blue-600">
                {overallProgress}%
              </span>
            </div>
            <div className="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
              <div 
                className="h-full bg-gradient-to-r from-blue-500 to-blue-700 transition-all duration-500"
                style={{ width: `${overallProgress}%` }}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="container mx-auto px-4 py-6 max-w-4xl">
        <Card className="border-2 border-blue-200">
          <CardContent className="p-6">
            {/* Material Header */}
            <div className="mb-6">
              <h1 className="text-2xl font-bold text-gray-900 mb-2">
                {currentMaterial?.title}
              </h1>
              <p className="text-gray-600 mb-4">
                {currentMaterial?.description}
              </p>
              
              <div className="flex items-center gap-4 text-sm text-gray-600 flex-wrap">
                <div className="flex items-center gap-1">
                  <Clock className="w-4 h-4" />
                  <span>{currentMaterial?.estimatedTime}</span>
                </div>
                <div className="flex items-center gap-1">
                  <BookOpen className="w-4 h-4" />
                  <span>Section {currentMaterial?.section} - Part {currentMaterial?.part}</span>
                </div>
                {/* Real-time countdown timer */}
                <div className={`flex items-center gap-1 font-bold ${
                  remainingSeconds <= 10 ? "text-red-600" : 
                  remainingSeconds <= 20 ? "text-orange-600" : 
                  "text-green-600"
                }`}>
                  <Clock className="w-4 h-4" />
                  <span>⏱ Sisa {remainingSeconds}s</span>
                </div>
              </div>
            </div>

            {/* Reading Progress for Current Material */}
            <div className="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-semibold text-blue-900">
                  Progress Membaca Part Ini
                </span>
                <span className="text-sm font-bold text-blue-600">
                  {progress}%
                </span>
              </div>
              <div className="w-full h-2 bg-blue-200 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-blue-600 transition-all duration-300"
                  style={{ width: `${progress}%` }}
                />
              </div>
            </div>

            {/* Material Content */}
            <div 
              id={`material-${currentMaterial?.id}`}
              className="prose max-w-none mb-6 max-h-[60vh] overflow-y-auto pr-2 text-gray-700 leading-relaxed whitespace-pre-line"
              onScroll={() => handleScroll(currentMaterial?.id)}
            >
              {currentMaterial?.content || ""}
            </div>

            {/* Mark Complete Button */}
            {progress >= 80 && progress < 100 && remainingSeconds > 0 && (
              <div className="mb-6">
                <Button 
                  onClick={() => handleMarkComplete(currentMaterial?.id)}
                  className="w-full bg-green-600 hover:bg-green-700 gap-2"
                >
                  <CheckCircle className="w-5 h-5" />
                  Tandai Selesai
                </Button>
              </div>
            )}

            {/* Auto-complete when timer runs out */}
            {remainingSeconds === 0 && progress < 100 && (
              <div className="mb-6 p-4 bg-green-50 border-2 border-green-600 rounded-lg">
                <p className="text-green-900 font-semibold text-center">
                  ✅ Waktu baca selesai! Anda bisa lanjut ke part berikutnya.
                </p>
              </div>
            )}

            {/* Navigation Buttons */}
            <div className="flex gap-4">
              <Button 
                variant="outline"
                onClick={handlePrevMaterial}
                disabled={currentMaterialIndex === 0}
                className="flex-1"
              >
                ← Part Sebelumnya
              </Button>
              
              {currentMaterialIndex < materials.length - 1 ? (
                <Button 
                  onClick={handleNextMaterial}
                  disabled={progress < 100 && remainingSeconds > 0}
                  className="flex-1 bg-blue-600 hover:bg-blue-700"
                >
                  Part Berikutnya →
                </Button>
              ) : (
                allMaterialsCompleted && (
                  <Button 
                    onClick={() => navigate('/patient/chat-hybrid')}
                    className="flex-1 bg-green-600 hover:bg-green-700 gap-2"
                  >
                    <MessageSquare className="w-5 h-5" />
                    Lanjut ke AI Chat
                  </Button>
                )
              )}
            </div>
          </CardContent>
        </Card>

        {/* Materials List / Index */}
        <Card className="mt-6 border-2 border-gray-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">
              Daftar Materi ({materials.length} Parts)
            </h3>
            <div className="space-y-2">
              {materials.map((material, index) => {
                const materialProgress = readingProgress[material.id] || 0;
                const isCompleted = materialProgress >= 100;
                const isCurrent = index === currentMaterialIndex;
                const isLocked = index > 0 && (readingProgress[materials[index - 1].id] || 0) < 100;
                
                return (
                  <button
                    key={material.id}
                    onClick={() => !isLocked && setCurrentMaterialIndex(index)}
                    disabled={isLocked}
                    className={`w-full p-4 rounded-lg border-2 text-left transition-all ${
                      isCurrent 
                        ? "border-blue-600 bg-blue-50" 
                        : isCompleted
                          ? "border-green-200 bg-green-50 hover:bg-green-100"
                          : isLocked
                            ? "border-gray-200 bg-gray-50 opacity-50 cursor-not-allowed"
                            : "border-gray-200 bg-white hover:bg-gray-50"
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3 flex-1">
                        {isCompleted ? (
                          <CheckCircle className="w-5 h-5 text-green-600 flex-shrink-0" />
                        ) : isLocked ? (
                          <Lock className="w-5 h-5 text-gray-400 flex-shrink-0" />
                        ) : (
                          <div className="w-5 h-5 rounded-full border-2 border-blue-600 flex-shrink-0" />
                        )}
                        <div>
                          <p className={`font-semibold ${isCurrent ? "text-blue-900" : "text-gray-900"}`}>
                            S{material.section}-P{material.part}: {material.title}
                          </p>
                          <p className="text-xs text-gray-600 mt-1">
                            ⏱ {material.estimatedTime}
                          </p>
                        </div>
                      </div>
                      <Badge className={
                        isCompleted 
                          ? "bg-green-600" 
                          : isLocked 
                            ? "bg-gray-400"
                            : "bg-blue-600"
                      }>
                        {materialProgress}%
                      </Badge>
                    </div>
                  </button>
                );
              })}
            </div>
          </CardContent>
        </Card>

        {/* AI Chat CTA - Only show when ALL materials completed */}
        {allMaterialsCompleted && (
          <Card className="mt-6 border-2 border-green-200 bg-gradient-to-br from-green-50 to-emerald-50">
            <CardContent className="p-8 text-center">
              <div className="w-20 h-20 bg-green-600 rounded-full flex items-center justify-center mx-auto mb-4">
                <MessageSquare className="w-10 h-10 text-white" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-2">
                🎉 Selamat! Semua Materi Selesai
              </h3>
              <p className="text-gray-700 mb-6">
                Anda telah menyelesaikan {materials.length} parts materi pembelajaran.<br />
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

      {/* ✅ Quiz Modal - Mandatory Quiz After Reading */}
      {showQuiz && currentMaterial?.quiz && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
          <Card className="max-w-2xl w-full border-4 border-blue-600 shadow-2xl">
            <CardContent className="p-8">
              <div className="text-center mb-6">
                <div className="w-16 h-16 bg-blue-600 rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-3xl">📝</span>
                </div>
                <h2 className="text-2xl font-bold text-gray-900 mb-2">
                  Kuis Pemahaman
                </h2>
                <p className="text-gray-600">
                  Jawab pertanyaan berikut untuk melanjutkan ke part berikutnya
                </p>
              </div>

              {/* Quiz Question */}
              <div className="mb-6 p-4 bg-blue-50 border-2 border-blue-200 rounded-lg">
                <p className="text-lg font-semibold text-gray-900">
                  {currentMaterial.quiz.question}
                </p>
              </div>

              {/* Quiz Options */}
              <div className="space-y-3 mb-6">
                {currentMaterial.quiz.options.map((option, index) => (
                  <button
                    key={index}
                    onClick={() => !quizSubmitted && setSelectedAnswer(index)}
                    disabled={quizSubmitted}
                    className={`w-full p-4 text-left rounded-lg border-2 transition-all ${
                      selectedAnswer === index
                        ? quizSubmitted
                          ? index === currentMaterial.quiz!.correctAnswer
                            ? "border-green-600 bg-green-50"
                            : "border-red-600 bg-red-50"
                          : "border-blue-600 bg-blue-50"
                        : quizSubmitted && index === currentMaterial.quiz!.correctAnswer
                          ? "border-green-600 bg-green-50"
                          : "border-gray-200 bg-white hover:border-blue-400 hover:bg-blue-50"
                    } ${quizSubmitted ? "cursor-not-allowed" : "cursor-pointer"}`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`w-6 h-6 rounded-full border-2 flex items-center justify-center flex-shrink-0 ${
                        selectedAnswer === index
                          ? quizSubmitted
                            ? index === currentMaterial.quiz!.correctAnswer
                              ? "border-green-600 bg-green-600"
                              : "border-red-600 bg-red-600"
                            : "border-blue-600 bg-blue-600"
                          : "border-gray-400"
                      }`}>
                        {selectedAnswer === index && (
                          <span className="text-white text-sm">
                            {quizSubmitted
                              ? index === currentMaterial.quiz!.correctAnswer
                                ? "✓"
                                : "✗"
                              : "●"}
                          </span>
                        )}
                        {quizSubmitted && selectedAnswer !== index && index === currentMaterial.quiz!.correctAnswer && (
                          <span className="text-white text-sm">✓</span>
                        )}
                      </div>
                      <span className="font-medium text-gray-900">
                        {option}
                      </span>
                    </div>
                  </button>
                ))}
              </div>

              {/* Explanation after submission */}
              {quizSubmitted && (
                <div className={`mb-6 p-4 rounded-lg border-2 ${
                  quizPassed
                    ? "bg-green-50 border-green-600"
                    : "bg-red-50 border-red-600"
                }`}>
                  <p className={`font-bold mb-2 ${
                    quizPassed ? "text-green-900" : "text-red-900"
                  }`}>
                    {quizPassed ? "✅ Jawaban Benar!" : "❌ Jawaban Salah"}
                  </p>
                  <p className="text-gray-700">
                    {currentMaterial.quiz.explanation}
                  </p>
                </div>
              )}

              {/* Action Buttons */}
              <div className="flex gap-4">
                {!quizSubmitted ? (
                  <Button
                    onClick={handleQuizSubmit}
                    disabled={selectedAnswer === null}
                    className="w-full bg-blue-600 hover:bg-blue-700 text-lg py-6"
                  >
                    Kirim Jawaban
                  </Button>
                ) : quizPassed ? (
                  <Button
                    onClick={handleQuizContinue}
                    className="w-full bg-green-600 hover:bg-green-700 text-lg py-6 gap-2"
                  >
                    <CheckCircle className="w-5 h-5" />
                    {currentMaterialIndex < materials.length - 1 ? "Lanjut ke Part Berikutnya" : "Selesai"}
                  </Button>
                ) : (
                  <Button
                    onClick={handleQuizRetry}
                    className="w-full bg-orange-600 hover:bg-orange-700 text-lg py-6"
                  >
                    Coba Lagi
                  </Button>
                )}
              </div>
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
}