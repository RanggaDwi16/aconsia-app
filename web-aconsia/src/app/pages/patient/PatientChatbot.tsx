import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Avatar, AvatarFallback } from "../../components/ui/avatar";
import { Bot, Send, User, Heart } from "lucide-react";
import { useState } from "react";
import { ScrollArea } from "../../components/ui/scroll-area";

interface Message {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
}

export function PatientChatbot() {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "1",
      role: "assistant",
      content: "Halo Ibu Sarah! 👋 Saya adalah asisten AI yang siap membantu menjawab pertanyaan Anda tentang anestesi spinal untuk operasi caesar Anda. Jangan ragu untuk bertanya apa saja!",
      timestamp: "10:00"
    },
    {
      id: "2",
      role: "user",
      content: "Apakah anestesi spinal itu sakit?",
      timestamp: "10:02"
    },
    {
      id: "3",
      role: "assistant",
      content: "Pertanyaan yang sangat bagus, Ibu Sarah. 😊\n\nProses penyuntikan anestesi spinal mungkin terasa sedikit tidak nyaman, tapi dokter akan memberikan obat bius lokal terlebih dahulu di area penyuntikan. Jadi Anda hanya akan merasakan seperti dicubit sebentar.\n\nYang perlu Anda ingat:\n✓ Rasa tidak nyaman hanya sebentar (beberapa detik)\n✓ Setelah obat bekerja, Anda tidak akan merasakan sakit di bagian bawah tubuh\n✓ Tim medis akan memastikan Anda senyaman mungkin\n\nBanyak pasien mengatakan bahwa prosesnya lebih mudah dari yang mereka bayangkan. Apakah ada yang ingin Anda tanyakan lagi?",
      timestamp: "10:03"
    },
  ]);
  const [inputMessage, setInputMessage] = useState("");
  const [isTyping, setIsTyping] = useState(false);

  const handleSendMessage = () => {
    if (!inputMessage.trim()) return;

    // Add user message
    const userMessage: Message = {
      id: Date.now().toString(),
      role: "user",
      content: inputMessage,
      timestamp: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage("");
    setIsTyping(true);

    // Simulate AI response
    setTimeout(() => {
      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        role: "assistant",
        content: getAIResponse(inputMessage),
        timestamp: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' })
      };
      setMessages(prev => [...prev, aiResponse]);
      setIsTyping(false);
    }, 1500);
  };

  const getAIResponse = (question: string): string => {
    const q = question.toLowerCase();
    
    if (q.includes("efek samping") || q.includes("risiko")) {
      return "Efek samping anestesi spinal umumnya ringan dan sementara, Ibu Sarah. 💙\n\nYang mungkin terjadi:\n• Pusing atau mual (jarang terjadi)\n• Sakit kepala ringan (bisa diatasi dengan istirahat)\n• Kesemutan sementara (akan hilang dalam beberapa jam)\n• Tekanan darah turun (tim medis akan monitor ketat)\n\nTim anestesi Anda akan memantau kondisi Anda dengan sangat hati-hati. Jika ada ketidaknyamanan, segera beritahu mereka ya!";
    }
    
    if (q.includes("berapa lama") || q.includes("durasi")) {
      return "Durasi anestesi spinal biasanya 2-4 jam, cukup untuk operasi caesar Anda. ⏰\n\nTimeline:\n✓ Penyuntikan: 5-10 menit\n✓ Mulai bekerja: 10-15 menit\n✓ Efektif untuk: 2-4 jam\n✓ Pemulihan penuh: 6-8 jam\n\nSetelah operasi selesai, Anda akan mulai merasakan kembali bagian bawah tubuh secara bertahap. Ini normal dan aman!";
    }
    
    if (q.includes("puasa") || q.includes("makan")) {
      return "Sangat penting untuk puasa sebelum operasi, Ibu! 🍽️\n\nAturan puasa:\n• Makanan padat: 6-8 jam sebelum operasi\n• Air putih: 2 jam sebelum operasi\n• Jangan minum apapun selain air putih\n\nKenapa penting? Untuk mencegah komplikasi jika ada refleks muntah selama prosedur. Dokter Anda akan memberikan jadwal puasa yang tepat.";
    }
    
    return "Terima kasih atas pertanyaan Anda! 😊 Saya di sini untuk membantu Anda memahami prosedur anestesi spinal dengan lebih baik.\n\nAnda bisa bertanya tentang:\n• Prosedur anestesi spinal\n• Efek samping dan risiko\n• Persiapan sebelum operasi\n• Pemulihan setelah operasi\n• Apa yang akan Anda rasakan\n\nJangan ragu untuk bertanya apa saja. Tidak ada pertanyaan yang terlalu kecil! 💙";
  };

  const quickQuestions = [
    "Apakah saya akan tetap sadar selama operasi?",
    "Berapa lama efek anestesi bertahan?",
    "Apa yang harus saya lakukan sebelum operasi?",
    "Apakah ada pantangan makanan?"
  ];

  return (
    <DashboardLayout role="patient" userName="Ibu Sarah Wijaya">
      <div className="space-y-6 h-[calc(100vh-12rem)]">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Chatbot AI Anestesi</h1>
          <p className="text-gray-600 mt-1">Tanya jawab tentang prosedur anestesi Anda dengan asisten AI yang empatik</p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 h-[calc(100%-5rem)]">
          {/* Chat Area */}
          <Card className="lg:col-span-3 flex flex-col h-full">
            <CardHeader className="border-b bg-gradient-to-r from-blue-50 to-purple-50">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-blue-600 rounded-full flex items-center justify-center">
                  <Bot className="w-6 h-6 text-white" />
                </div>
                <div>
                  <CardTitle>AI Assistant</CardTitle>
                  <CardDescription>Siap menjawab pertanyaan Anda dengan empati</CardDescription>
                </div>
              </div>
            </CardHeader>
            
            <CardContent className="flex-1 flex flex-col p-0">
              <ScrollArea className="flex-1 p-6">
                <div className="space-y-4">
                  {messages.map((message) => (
                    <div
                      key={message.id}
                      className={`flex gap-3 ${message.role === 'user' ? 'flex-row-reverse' : 'flex-row'}`}
                    >
                      <Avatar className="flex-shrink-0">
                        <AvatarFallback className={message.role === 'user' ? 'bg-green-500' : 'bg-blue-500'}>
                          {message.role === 'user' ? <User className="w-5 h-5 text-white" /> : <Bot className="w-5 h-5 text-white" />}
                        </AvatarFallback>
                      </Avatar>
                      
                      <div className={`flex-1 ${message.role === 'user' ? 'text-right' : 'text-left'}`}>
                        <div
                          className={`inline-block p-4 rounded-lg max-w-[80%] ${
                            message.role === 'user'
                              ? 'bg-green-100 text-gray-900'
                              : 'bg-blue-50 text-gray-900'
                          }`}
                        >
                          <p className="whitespace-pre-line">{message.content}</p>
                        </div>
                        <p className="text-xs text-gray-500 mt-1">{message.timestamp}</p>
                      </div>
                    </div>
                  ))}
                  
                  {isTyping && (
                    <div className="flex gap-3">
                      <Avatar>
                        <AvatarFallback className="bg-blue-500">
                          <Bot className="w-5 h-5 text-white" />
                        </AvatarFallback>
                      </Avatar>
                      <div className="bg-blue-50 p-4 rounded-lg">
                        <div className="flex gap-1">
                          <div className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                          <div className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                          <div className="w-2 h-2 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </ScrollArea>

              <div className="border-t p-4">
                <div className="flex gap-2">
                  <Input
                    placeholder="Ketik pertanyaan Anda di sini..."
                    value={inputMessage}
                    onChange={(e) => setInputMessage(e.target.value)}
                    onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
                    className="flex-1"
                  />
                  <Button 
                    onClick={handleSendMessage}
                    className="bg-blue-600 hover:bg-blue-700"
                    disabled={!inputMessage.trim() || isTyping}
                  >
                    <Send className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Quick Questions Sidebar */}
          <Card className="h-full">
            <CardHeader>
              <CardTitle className="text-lg">Pertanyaan Cepat</CardTitle>
              <CardDescription className="text-xs">Klik untuk bertanya</CardDescription>
            </CardHeader>
            <CardContent className="space-y-3">
              {quickQuestions.map((question, index) => (
                <button
                  key={index}
                  onClick={() => setInputMessage(question)}
                  className="w-full p-3 text-left text-sm border rounded-lg hover:bg-blue-50 hover:border-blue-300 transition-colors"
                >
                  {question}
                </button>
              ))}
              
              <div className="mt-6 p-4 bg-purple-50 border border-purple-200 rounded-lg">
                <div className="flex items-center gap-2 mb-2">
                  <Heart className="w-4 h-4 text-purple-600" />
                  <p className="text-sm font-semibold text-purple-900">Mode Empatik</p>
                </div>
                <p className="text-xs text-purple-700">
                  AI kami dirancang untuk menjawab dengan nada yang tenang dan menenangkan, 
                  membantu mengurangi kecemasan Anda sebelum operasi.
                </p>
              </div>

              <div className="mt-4 p-4 bg-green-50 border border-green-200 rounded-lg">
                <p className="text-xs text-green-800">
                  <strong>Tips:</strong> Jangan ragu untuk bertanya berkali-kali sampai Anda benar-benar paham! 💚
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  );
}
