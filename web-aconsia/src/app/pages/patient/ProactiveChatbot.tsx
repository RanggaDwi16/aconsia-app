import { useState, useEffect, useRef } from "react";
import { Card, CardContent } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Badge } from "../../components/ui/badge";
import { Send, Bot, User, Sparkles, AlertCircle, CheckCircle, ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router";

interface Message {
  id: string;
  type: "ai" | "user";
  content: string;
  timestamp: Date;
  questionType?: "proactive" | "clarification" | "assessment";
  options?: string[];
}

export function ProactiveChatbot() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const [comprehensionScore, setComprehensionScore] = useState(0); // START FROM 0%
  const [weakAreas, setWeakAreas] = useState<string[]>([]);
  const messagesEndRef = useRef<HTMLDivElement>(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  useEffect(() => {
    // Initial AI greeting - PROACTIVE
    setTimeout(() => {
      addAIMessage(
        "Halo! 👋 Saya AI Assistant Anda untuk membantu memahami prosedur Anestesi Umum.\n\n" +
        "Saya akan menanyakan beberapa hal untuk memastikan Anda benar-benar paham. Jangan khawatir, tidak ada jawaban yang salah! 😊\n\n" +
        "Mari kita mulai dengan pertanyaan pertama:",
        "proactive"
      );
      
      setTimeout(() => {
        addAIMessage(
          "Saya lihat Anda sudah membaca materi 'Pengenalan Anestesi Umum'. Coba ceritakan dengan kata-kata Anda sendiri: Apa yang Anda pahami tentang anestesi umum?",
          "proactive",
          []
        );
      }, 1500);
    }, 1000);
  }, []);

  const addAIMessage = (content: string, questionType: "proactive" | "clarification" | "assessment" = "proactive", options?: string[]) => {
    const newMessage: Message = {
      id: Date.now().toString(),
      type: "ai",
      content,
      timestamp: new Date(),
      questionType,
      options,
    };
    setMessages(prev => [...prev, newMessage]);
  };

  const addUserMessage = (content: string) => {
    const newMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      content,
      timestamp: new Date(),
    };
    setMessages(prev => [...prev, newMessage]);
  };

  const handleSend = () => {
    if (!input.trim()) return;

    addUserMessage(input);
    setInput("");
    setIsTyping(true);

    // Simulate AI response with proactive follow-up questions
    setTimeout(() => {
      analyzeUserResponse(input);
    }, 1500);
  };

  const analyzeUserResponse = (userResponse: string) => {
    setIsTyping(false);

    // Simulate AI analysis with quick reply options
    const responses = [
      {
        feedback: "Bagus! Saya senang Anda sudah memahami konsep dasarnya. ✅",
        followUp: "Sekarang, apakah Anda memahami mengapa pasien perlu berpuasa sebelum anestesi umum?",
        type: "proactive" as const,
        options: [
          "Ya, untuk mencegah aspirasi",
          "Ya, tapi belum tahu alasannya",
          "Tidak, bisa jelaskan?"
        ],
      },
      {
        feedback: "Terima kasih atas penjelasannya. Saya melihat ada bagian yang mungkin masih perlu diperjelas.",
        followUp: "Coba saya tanyakan lebih spesifik: Menurut Anda, apa yang terjadi pada tubuh saat diberikan obat anestesi umum?",
        type: "clarification" as const,
        options: [
          "Tubuh kehilangan kesadaran",
          "Otot-otot menjadi rileks",
          "Tidak merasakan sakit",
          "Saya kurang paham, jelaskan lagi"
        ],
      },
      {
        feedback: "Hmm, sepertinya ada sedikit kebingungan di sini. Tidak apa-apa! Mari saya bantu.",
        followUp: "Saya merekomendasikan Anda membaca kembali bagian 'Cara Kerja Anestesi Umum'. Apakah Anda ingin ringkasan singkat sekarang?",
        type: "assessment" as const,
        recommendation: "Persiapan Sebelum Anestesi",
        options: [
          "Ya, buatkan ringkasan singkat",
          "Nanti saya baca sendiri dulu",
          "Minta penjelasan tambahan"
        ],
      },
    ];

    const randomResponse = responses[Math.floor(Math.random() * responses.length)];

    addAIMessage(randomResponse.feedback, randomResponse.type);

    setTimeout(() => {
      if (randomResponse.recommendation) {
        addAIMessage(
          `💡 Rekomendasi: Saya melihat Anda perlu memperkuat pemahaman tentang "${randomResponse.recommendation}".`,
          "assessment",
          randomResponse.options
        );
      } else {
        addAIMessage(randomResponse.followUp, randomResponse.type, randomResponse.options);
      }
    }, 1000);
  };

  const handleOptionClick = (option: string) => {
    addUserMessage(option);
    setIsTyping(true);

    setTimeout(() => {
      setIsTyping(false);
      if (option.includes("ringkasan")) {
        addAIMessage(
          "Baik, ini ringkasan singkat:\n\n" +
          "📌 Persiapan Sebelum Anestesi:\n" +
          "1. Puasa minimal 6 jam sebelum operasi\n" +
          "2. Hindari minum air 2 jam sebelum operasi\n" +
          "3. Informasikan semua obat yang sedang dikonsumsi\n" +
          "4. Lepas perhiasan dan makeup\n\n" +
          "Apakah sekarang sudah lebih jelas?",
          "clarification",
          ["Sudah jelas", "Masih ada yang belum paham"]
        );
        
        // Update comprehension score
        setComprehensionScore(prev => Math.min(prev + 5, 100));
      } else {
        addAIMessage(
          "Baik! Tidak masalah. Anda bisa membacanya nanti di bagian Materi Pembelajaran.\n\n" +
          "Sekarang saya mau tanya hal lain: Apakah Anda sudah memahami risiko dan efek samping dari anestesi umum?",
          "proactive"
        );
      }
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-emerald-50">
      <div className="container mx-auto px-4 py-8 max-w-3xl">
        {/* Header */}
        <div className="flex items-center gap-4 mb-6">
          <Button variant="ghost" size="sm" onClick={() => navigate('/patient')}>
            <ArrowLeft className="w-4 h-4 mr-2" />
            Kembali
          </Button>
          <div className="flex-1">
            <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
              <Bot className="w-6 h-6 text-green-600" />
              AI Assistant
            </h1>
            <p className="text-sm text-gray-600">Proactive Learning Companion</p>
          </div>
        </div>

        {/* Comprehension Score */}
        <Card className="mb-6 border-blue-200 bg-blue-50">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div className="flex-1">
                <p className="text-sm text-gray-700 mb-2">Tingkat Pemahaman Saat Ini</p>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-blue-600 h-2 rounded-full transition-all duration-500"
                    style={{ width: `${comprehensionScore}%` }}
                  />
                </div>
              </div>
              <div className="ml-4 text-right">
                <p className="text-2xl font-bold text-blue-600">{comprehensionScore}%</p>
                <p className="text-xs text-gray-600">
                  {comprehensionScore >= 80 ? "Sangat Baik!" : `${80 - comprehensionScore}% lagi`}
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Weak Areas Alert */}
        {weakAreas.length > 0 && (
          <Card className="mb-6 border-orange-200 bg-orange-50">
            <CardContent className="p-4">
              <div className="flex items-start gap-3">
                <AlertCircle className="w-5 h-5 text-orange-600 flex-shrink-0 mt-0.5" />
                <div>
                  <p className="font-semibold text-orange-900 mb-1">Area yang Perlu Diperkuat:</p>
                  <div className="flex flex-wrap gap-2">
                    {weakAreas.map((area, idx) => (
                      <Badge key={idx} variant="secondary" className="bg-orange-100 text-orange-800">
                        {area}
                      </Badge>
                    ))}
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Chat Messages */}
        <Card className="mb-6">
          <CardContent className="p-0">
            <div className="h-[500px] overflow-y-auto p-6 space-y-4">
              {messages.map((message) => (
                <div 
                  key={message.id} 
                  className={`flex gap-3 ${message.type === "user" ? "flex-row-reverse" : ""}`}
                >
                  {/* Avatar */}
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                    message.type === "ai" 
                      ? "bg-gradient-to-br from-green-500 to-emerald-600" 
                      : "bg-blue-600"
                  }`}>
                    {message.type === "ai" ? (
                      <Bot className="w-5 h-5 text-white" />
                    ) : (
                      <User className="w-5 h-5 text-white" />
                    )}
                  </div>

                  {/* Message Content */}
                  <div className={`flex-1 max-w-[80%] ${message.type === "user" ? "items-end" : ""}`}>
                    <div className={`rounded-2xl p-4 ${
                      message.type === "ai"
                        ? "bg-white border border-gray-200"
                        : "bg-blue-600 text-white"
                    }`}>
                      {message.questionType === "proactive" && message.type === "ai" && (
                        <div className="flex items-center gap-2 mb-2">
                          <Sparkles className="w-4 h-4 text-purple-600" />
                          <span className="text-xs font-semibold text-purple-600">Pertanyaan Proaktif</span>
                        </div>
                      )}
                      
                      {message.questionType === "assessment" && message.type === "ai" && (
                        <div className="flex items-center gap-2 mb-2">
                          <CheckCircle className="w-4 h-4 text-green-600" />
                          <span className="text-xs font-semibold text-green-600">Assessment</span>
                        </div>
                      )}

                      <p className="text-sm whitespace-pre-line">{message.content}</p>

                      {/* Message Options (Quick Replies) */}
                      {message.options && message.options.length > 0 && (
                        <div className="mt-3 space-y-2">
                          <div className="flex items-center gap-2 text-xs text-gray-600 mb-2">
                            <span className="bg-blue-600 text-white px-2 py-0.5 rounded-full">✎</span>
                            <span>Pilih Jawaban Di bawah ini</span>
                          </div>
                          {message.options.map((option, idx) => (
                            <button
                              key={idx}
                              onClick={() => handleOptionClick(option)}
                              className="w-full p-3 text-left border-2 border-gray-200 rounded-lg hover:border-blue-600 hover:bg-blue-50 transition-all text-sm text-gray-900"
                            >
                              {option}
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                    <p className="text-xs text-gray-500 mt-1 px-2">
                      {message.timestamp.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })}
                    </p>
                  </div>
                </div>
              ))}

              {/* Typing Indicator */}
              {isTyping && (
                <div className="flex gap-3">
                  <div className="w-8 h-8 rounded-full bg-gradient-to-br from-green-500 to-emerald-600 flex items-center justify-center">
                    <Bot className="w-5 h-5 text-white" />
                  </div>
                  <div className="bg-white border border-gray-200 rounded-2xl p-4">
                    <div className="flex gap-1">
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: "0ms" }} />
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: "150ms" }} />
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: "300ms" }} />
                    </div>
                  </div>
                </div>
              )}

              <div ref={messagesEndRef} />
            </div>
          </CardContent>
        </Card>

        {/* Input */}
        <Card>
          <CardContent className="p-4">
            <form 
              onSubmit={(e) => {
                e.preventDefault();
                handleSend();
              }}
              className="flex gap-2"
            >
              <Input
                value={input}
                onChange={(e) => setInput(e.target.value)}
                placeholder="Ketik jawaban atau pertanyaan Anda..."
                className="flex-1"
                disabled={isTyping}
              />
              <Button 
                type="submit" 
                disabled={!input.trim() || isTyping}
                className="bg-green-600 hover:bg-green-700"
              >
                <Send className="w-4 h-4" />
              </Button>
            </form>
            <p className="text-xs text-gray-500 mt-2 text-center">
              💡 Tip: Jawab sejujurnya! AI akan menyesuaikan pertanyaan dengan level pemahaman Anda
            </p>
          </CardContent>
        </Card>

        {/* Info Box */}
        <Card className="mt-6 border-purple-200 bg-gradient-to-br from-purple-50 to-pink-50">
          <CardContent className="p-4">
            <div className="flex items-start gap-3">
              <Sparkles className="w-5 h-5 text-purple-600 flex-shrink-0" />
              <div className="text-sm">
                <p className="font-semibold text-purple-900 mb-1">Tentang AI Proaktif:</p>
                <ul className="text-purple-800 space-y-1">
                  <li>• AI akan <strong>menanyakan pertanyaan</strong> untuk menguji pemahaman Anda</li>
                  <li>• Jika ada area yang lemah, AI akan <strong>merekomendasikan materi</strong></li>
                  <li>• Semakin banyak interaksi, semakin akurat rekomendasi AI</li>
                  <li>• Progress Anda akan <strong>ter-tracking otomatis</strong></li>
                </ul>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}