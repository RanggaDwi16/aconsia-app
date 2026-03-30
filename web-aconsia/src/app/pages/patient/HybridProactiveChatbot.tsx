import { useState, useEffect, useRef } from "react";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Input } from "../../components/ui/input";
import { ArrowLeft, Send, Bot, User, Sparkles, TrendingUp, CheckCircle } from "lucide-react";
import { useNavigate } from "react-router";

interface Message {
  id: string;
  type: "ai" | "user";
  content: string;
  timestamp: Date;
  questionType?: "proactive" | "assessment" | "followup" | "recommendation";
  options?: string[];
  correctAnswer?: string;
  relatedSection?: number; // Track which section this question relates to
  isRecommendation?: boolean; // NEW: Mark recommendation messages
}

export function HybridProactiveChatbot() {
  const navigate = useNavigate();
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const [messages, setMessages] = useState<Message[]>([]);
  const [inputValue, setInputValue] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const [comprehensionScore, setComprehensionScore] = useState(60);
  const [questionCount, setQuestionCount] = useState(0);
  const [weakSections, setWeakSections] = useState<number[]>([]); // Track sections where user struggled
  const [isCompleted, setIsCompleted] = useState(false); // NEW: Track if chat is completed

  // Auto-scroll to bottom
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Initialize with greeting
  useEffect(() => {
    setTimeout(() => {
      addAIMessage(
        "Hai! Saya adalah AI Assistant untuk edukasi informed consent anestesi. Saya akan menanyakan beberapa pertanyaan untuk memastikan pemahaman Anda. 😊",
        "proactive"
      );
    }, 500);

    setTimeout(() => {
      askNextQuestion();
    }, 2000);
  }, []);

  const addAIMessage = (
    content: string,
    questionType?: "proactive" | "assessment" | "followup" | "recommendation",
    options?: string[]
  ) => {
    const newMessage: Message = {
      id: Date.now().toString(),
      type: "ai",
      content,
      timestamp: new Date(),
      questionType,
      options,
    };
    setMessages((prev) => [...prev, newMessage]);
  };

  const addUserMessage = (content: string) => {
    const newMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      content,
      timestamp: new Date(),
    };
    setMessages((prev) => [...prev, newMessage]);
  };

  const askNextQuestion = () => {
    setIsTyping(true);

    setTimeout(() => {
      setIsTyping(false);

      const questions = [
        {
          question:
            "Mari kita mulai dengan pertanyaan sederhana. Mengapa pasien harus puasa 6-8 jam sebelum operasi dengan anestesi umum?",
          options: [
            "Ya, untuk mencegah aspirasi (cairan lambung masuk paru-paru)",
            "Ya, tapi saya belum tahu alasannya secara detail",
            "Tidak yakin, bisa jelaskan lebih detail?",
            "💬 Saya ingin menjelaskan dengan kata-kata sendiri",
          ],
          correctAnswer:
            "Ya, untuk mencegah aspirasi (cairan lambung masuk paru-paru)",
          relatedSection: 10, // Section 10: Persiapan yang Harus Anda Lakukan
        },
        {
          question:
            "Bagus! Sekarang, apa yang sebaiknya Anda lakukan jika memiliki riwayat alergi obat?",
          options: [
            "Memberitahu tim anestesi sebelum operasi",
            "Tidak perlu memberitahu karena tidak penting",
            "Menunggu sampai ditanya saat operasi",
            "💬 Saya ingin menjelaskan dengan kata-kata sendiri",
          ],
          correctAnswer: "Memberitahu tim anestesi sebelum operasi",
          relatedSection: 6, // Section 6: Risiko dan Efek Samping Anestesi
        },
        {
          question:
            "Pertanyaan terakhir: Apa yang terjadi setelah operasi selesai dan anestesi dihentikan?",
          options: [
            "Pasien langsung bangun dan bisa pulang",
            "Pasien dipantau di ruang pemulihan hingga sadar penuh",
            "Pasien tidur sampai besok pagi",
            "💬 Saya ingin menjelaskan dengan kata-kata sendiri",
          ],
          correctAnswer:
            "Pasien dipantau di ruang pemulihan hingga sadar penuh",
          relatedSection: 8, // Section 8: Prognosis dan Pemulihan
        },
      ];

      if (questionCount < questions.length) {
        const currentQuestion = questions[questionCount];
        const newMessage: Message = {
          id: Date.now().toString(),
          type: "ai",
          content: currentQuestion.question,
          timestamp: new Date(),
          questionType: "proactive",
          options: currentQuestion.options,
          correctAnswer: currentQuestion.correctAnswer,
          relatedSection: currentQuestion.relatedSection,
        };
        setMessages((prev) => [...prev, newMessage]);
      } else {
        // All questions done - generate recommendations
        const sectionTitles: { [key: number]: string } = {
          1: "Diagnosa Penyakit Anda",
          2: "Jenis Anestesi yang Akan Digunakan",
          3: "Kenapa Saya Perlu Anestesi?",
          4: "Tahapan Prosedur Anestesi",
          5: "Tujuan Pemberian Anestesi",
          6: "Risiko dan Efek Samping Anestesi",
          7: "Komplikasi yang Mungkin Terjadi",
          8: "Prognosis dan Pemulihan",
          9: "Alternatif Selain Anestesi",
          10: "Persiapan yang Harus Anda Lakukan",
        };

        let completionMessage = `🎉 Luar biasa! Anda telah menyelesaikan sesi chat. Tingkat pemahaman Anda sekarang: ${comprehensionScore}%.`;

        // Generate unique weak sections OUTSIDE the if-else block
        const uniqueWeakSections = [...new Set(weakSections)];

        if (comprehensionScore >= 80) {
          completionMessage += " Anda sudah siap untuk informed consent!";
        } else {
          // Generate recommendations
          if (uniqueWeakSections.length > 0) {
            completionMessage += "\n\nSaya lihat Anda masih kurang memahami:";
            uniqueWeakSections.forEach((sectionNum) => {
              completionMessage += `\n• Section ${sectionNum}: ${sectionTitles[sectionNum]}`;
            });
            completionMessage += "\n\nSilakan baca kembali section-section tersebut untuk meningkatkan pemahaman Anda. 📖";
          } else {
            completionMessage += " Silakan baca materi lagi untuk meningkatkan pemahaman.";
          }
        }

        addAIMessage(completionMessage, "recommendation");
        setIsCompleted(true);

        // 💾 SAVE RECOMMENDATIONS TO LOCALSTORAGE
        saveRecommendations(uniqueWeakSections, sectionTitles, comprehensionScore);
      }
    }, 1500);
  };

  // NEW: Save recommendations to show on dashboard
  const saveRecommendations = (
    weakSectionNums: number[],
    sectionTitles: { [key: number]: string },
    score: number
  ) => {
    const currentPatient = localStorage.getItem("currentPatient");
    if (!currentPatient) return;

    const patient = JSON.parse(currentPatient);

    // Generate recommendations array
    const recommendations = weakSectionNums.map((num) => ({
      sectionNum: num,
      title: sectionTitles[num],
      reason: `Anda masih kurang memahami section ini berdasarkan hasil assessment AI.`,
    }));

    // Update patient data
    const updatedPatient = {
      ...patient,
      comprehensionScore: score,
      aiRecommendations: recommendations,
      lastChatDate: new Date().toISOString(),
    };

    // Save to all storage locations
    localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
    localStorage.setItem(`patient_${patient.nik}`, JSON.stringify(updatedPatient));

    // Update demoPatients array
    const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
    const updatedDemoPatients = demoPatients.map((p: any) =>
      p.id === patient.id ? updatedPatient : p
    );
    localStorage.setItem("demoPatients", JSON.stringify(updatedDemoPatients));

    console.log("✅ AI recommendations saved to localStorage!", recommendations);
  };

  const handleOptionClick = (option: string) => {
    // Check if user wants to type manually
    if (option.includes("💬 Saya ingin menjelaskan")) {
      addUserMessage(option);
      setIsTyping(true);

      setTimeout(() => {
        setIsTyping(false);
        addAIMessage(
          "Silakan ketik jawaban Anda di kolom input di bawah. Saya akan menganalisis pemahaman Anda. 😊",
          "assessment"
        );
      }, 1000);

      // Focus input
      setTimeout(() => {
        inputRef.current?.focus();
      }, 1500);
      return;
    }

    // Regular option selected
    addUserMessage(option);
    setIsTyping(true);

    setTimeout(() => {
      setIsTyping(false);

      // Simple assessment logic
      const lastMessage = messages[messages.length - 1];
      const isCorrect = option === lastMessage.correctAnswer;

      if (isCorrect) {
        setComprehensionScore((prev) => Math.min(prev + 10, 100));
        addAIMessage(
          "✅ Benar! Pemahaman Anda sangat baik. Mari lanjut ke pertanyaan berikutnya.",
          "assessment"
        );
      } else if (option.includes("belum tahu") || option.includes("Tidak yakin")) {
        setComprehensionScore((prev) => Math.max(prev + 3, 0));
        addAIMessage(
          "Tidak apa-apa! Saya akan jelaskan: " +
            (lastMessage.correctAnswer || "...") +
            ". Silakan baca kembali materi terkait untuk pemahaman lebih dalam. 📖",
          "assessment"
        );
        // Add weak section
        if (lastMessage.relatedSection) {
          setWeakSections((prev) => [...prev, lastMessage.relatedSection]);
        }
      } else {
        setComprehensionScore((prev) => Math.max(prev + 5, 0));
        addAIMessage(
          "Jawaban Anda kurang tepat, tapi sudah bagus! Yang benar adalah: " +
            (lastMessage.correctAnswer || "...") +
            ". Mari lanjut ke pertanyaan berikutnya.",
          "assessment"
        );
        // Add weak section for wrong answer
        if (lastMessage.relatedSection) {
          setWeakSections((prev) => [...prev, lastMessage.relatedSection]);
        }
      }

      setQuestionCount((prev) => prev + 1);

      setTimeout(() => {
        askNextQuestion();
      }, 2000);
    }, 1500);
  };

  const handleSubmitText = () => {
    if (!inputValue.trim()) return;

    addUserMessage(inputValue);
    setInputValue("");
    setIsTyping(true);

    setTimeout(() => {
      setIsTyping(false);

      // Simple keyword analysis
      const keywords = ["aspirasi", "puasa", "alergi", "pemulihan", "monitoring"];
      const foundKeywords = keywords.filter((kw) =>
        inputValue.toLowerCase().includes(kw)
      );

      if (foundKeywords.length > 0) {
        setComprehensionScore((prev) => Math.min(prev + 8, 100));
        addAIMessage(
          `✅ Bagus! Saya melihat Anda menyebutkan kata kunci penting: "${foundKeywords.join(
            ", "
          )}". Ini menunjukkan pemahaman yang baik. Mari lanjut ke pertanyaan berikutnya.`,
          "assessment"
        );
      } else {
        setComprehensionScore((prev) => Math.max(prev + 3, 0));
        addAIMessage(
          "Terima kasih atas jawaban Anda. Namun, saya sarankan untuk membaca kembali materi agar pemahaman lebih mendalam. 📖",
          "assessment"
        );
      }

      setQuestionCount((prev) => prev + 1);

      setTimeout(() => {
        askNextQuestion();
      }, 2000);
    }, 1500);
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSubmitText();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-cyan-50 flex flex-col">
      {/* Header */}
      <div className="bg-white border-b sticky top-0 z-10 shadow-sm">
        <div className="container mx-auto px-4 py-4 max-w-3xl">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => navigate("/patient")}
              >
                <ArrowLeft className="w-5 h-5" />
              </Button>
              <div>
                <div className="flex items-center gap-2">
                  <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
                    <Bot className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h1 className="text-lg font-bold text-gray-900">
                      AI Assistant
                    </h1>
                    <div className="flex items-center gap-1 text-xs text-green-600">
                      <span className="w-2 h-2 bg-green-600 rounded-full animate-pulse"></span>
                      <span>Online</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Comprehension Score Badge */}
            <Card className="border-blue-200 bg-blue-50">
              <CardContent className="p-2 px-3">
                <div className="flex items-center gap-2">
                  <TrendingUp className="w-4 h-4 text-blue-600" />
                  <div>
                    <p className="text-xs text-gray-600">Pemahaman</p>
                    <p className="text-lg font-bold text-blue-600">
                      {comprehensionScore}%
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>

      {/* Chat Messages */}
      <div className="flex-1 overflow-y-auto">
        <div className="container mx-auto px-4 py-6 max-w-3xl">
          <div className="space-y-4">
            {messages.map((message) => (
              <div
                key={message.id}
                className={`flex items-start gap-3 ${
                  message.type === "user" ? "flex-row-reverse" : ""
                }`}
              >
                {/* Avatar */}
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 ${
                    message.type === "ai"
                      ? "bg-gradient-to-br from-purple-500 to-pink-500"
                      : "bg-blue-600"
                  }`}
                >
                  {message.type === "ai" ? (
                    <Bot className="w-6 h-6 text-white" />
                  ) : (
                    <User className="w-6 h-6 text-white" />
                  )}
                </div>

                {/* Message Content */}
                <div
                  className={`flex-1 max-w-[80%] ${
                    message.type === "user" ? "items-end" : ""
                  }`}
                >
                  <Card
                    className={`${
                      message.type === "ai"
                        ? "bg-white border-gray-200"
                        : "bg-blue-600 border-blue-600"
                    }`}
                  >
                    <CardContent className="p-4">
                      <p
                        className={`text-sm leading-relaxed whitespace-pre-line ${ 
                          message.type === "ai"
                            ? "text-gray-900"
                            : "text-white"
                        }`}
                      >
                        {message.content}
                      </p>

                      {/* Quick Reply Options */}
                      {message.options && message.options.length > 0 && (
                        <div className="mt-4 space-y-2">
                          <div className="flex items-center gap-2 text-xs text-blue-600 mb-2">
                            <Sparkles className="w-4 h-4" />
                            <span className="font-semibold">
                              💡 Pilih jawaban atau ketik manual di bawah:
                            </span>
                          </div>
                          {message.options.map((option, idx) => (
                            <button
                              key={idx}
                              onClick={() => handleOptionClick(option)}
                              className={`w-full p-3 text-left border-2 rounded-lg transition-all text-sm ${
                                option.includes("💬")
                                  ? "border-purple-300 bg-purple-50 hover:border-purple-500 hover:bg-purple-100 font-semibold text-purple-900"
                                  : "border-gray-200 bg-white hover:border-blue-500 hover:bg-blue-50 text-gray-900"
                              }`}
                            >
                              {option}
                            </button>
                          ))}
                        </div>
                      )}
                    </CardContent>
                  </Card>
                  <p className="text-xs text-gray-500 mt-1 px-2">
                    {message.timestamp.toLocaleTimeString("id-ID", {
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
              </div>
            ))}

            {/* Typing Indicator */}
            {isTyping && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-full flex items-center justify-center">
                  <Bot className="w-6 h-6 text-white" />
                </div>
                <Card className="bg-white border-gray-200">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-1">
                      <span className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></span>
                      <span
                        className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"
                        style={{ animationDelay: "0.2s" }}
                      ></span>
                      <span
                        className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"
                        style={{ animationDelay: "0.4s" }}
                      ></span>
                    </div>
                  </CardContent>
                </Card>
              </div>
            )}

            {/* Completion Button - Show when chat is completed */}
            {isCompleted && (
              <div className="flex justify-center mt-6">
                <Button
                  onClick={() => {
                    navigate("/patient");
                  }}
                  className="bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-700 hover:to-emerald-700 text-white px-8 py-6 h-auto text-base font-semibold rounded-xl shadow-lg hover:shadow-xl transition-all"
                >
                  <CheckCircle className="w-5 h-5 mr-2" />
                  Selesai & Kembali ke Dashboard
                </Button>
              </div>
            )}

            <div ref={messagesEndRef} />
          </div>
        </div>
      </div>

      {/* Input Area */}
      <div className="bg-white border-t sticky bottom-0 shadow-lg">
        <div className="container mx-auto px-4 py-4 max-w-3xl">
          <div className="flex items-center gap-3">
            <div className="flex-1 relative">
              <Input
                ref={inputRef}
                type="text"
                placeholder="Ketik jawaban Anda di sini... (opsional)"
                value={inputValue}
                onChange={(e) => setInputValue(e.target.value)}
                onKeyPress={handleKeyPress}
                className="pr-12 h-12 text-base border-2 border-gray-200 focus:border-blue-500"
              />
              <Badge
                variant="secondary"
                className="absolute right-3 top-1/2 -translate-y-1/2 bg-blue-100 text-blue-700 text-xs"
              >
                Optional
              </Badge>
            </div>
            <Button
              onClick={handleSubmitText}
              disabled={!inputValue.trim()}
              className="bg-blue-600 hover:bg-blue-700 h-12 px-6"
            >
              <Send className="w-5 h-5" />
            </Button>
          </div>
          <p className="text-xs text-gray-500 mt-2 text-center">
            💡 Tip: Pilih quick reply atau ketik manual untuk jawaban lebih detail
          </p>
        </div>
      </div>
    </div>
  );
}