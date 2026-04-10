import { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router";
import { Card, CardContent, CardHeader } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Input } from "../../components/ui/input";
import { Badge } from "../../components/ui/badge";
import { MobileLayout } from "../../layouts/MobileLayout";
import { 
  ArrowLeft, 
  Send, 
  Clock,
  CheckCheck,
  Stethoscope,
  Info
} from "lucide-react";

interface Message {
  id: string;
  sender: "patient" | "doctor";
  text: string;
  timestamp: Date;
  read: boolean;
}

export function ContactDoctor() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState<Message[]>([]);
  const [inputMessage, setInputMessage] = useState("");
  const [doctorStatus, setDoctorStatus] = useState<"online" | "offline">("offline");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Get current patient data
  const currentPatient = JSON.parse(localStorage.getItem('currentPatient') || '{}');
  
  // Get doctor info from patient's assigned doctor
  const getDoctorInfo = () => {
    if (currentPatient.assignedDoctor) {
      return currentPatient.assignedDoctor;
    }
    return {
      name: "Dokter belum ditugaskan",
      specialization: "Spesialis Anestesi",
      hospital: "RS -",
      phone: "-",
      email: "-"
    };
  };

  const doctorInfo = getDoctorInfo();

  // Load chat history from localStorage
  useEffect(() => {
    const chatKey = `doctorChat_${currentPatient.mrn}`;
    const savedMessages = localStorage.getItem(chatKey);
    
    if (savedMessages) {
      const parsed = JSON.parse(savedMessages);
      setMessages(parsed.map((msg: any) => ({
        ...msg,
        timestamp: new Date(msg.timestamp)
      })));
    } else {
      // Initial info message
      const welcomeMessage: Message = {
        id: "info-1",
        sender: "doctor",
        text: `Halo ${currentPatient.fullName || 'Pasien'}! Ini adalah saluran komunikasi langsung dengan dokter anestesi Anda. Dokter akan merespons pesan Anda secepatnya.`,
        timestamp: new Date(),
        read: true
      };
      setMessages([welcomeMessage]);
    }
  }, [currentPatient.mrn, currentPatient.fullName]);

  // Auto-scroll to bottom when new message
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  // Save messages to localStorage
  useEffect(() => {
    if (messages.length > 0) {
      const chatKey = `doctorChat_${currentPatient.mrn}`;
      localStorage.setItem(chatKey, JSON.stringify(messages));
    }
  }, [messages, currentPatient.mrn]);

  const handleSendMessage = () => {
    if (!inputMessage.trim()) return;

    const newMessage: Message = {
      id: `msg-${Date.now()}`,
      sender: "patient",
      text: inputMessage,
      timestamp: new Date(),
      read: false
    };

    setMessages(prev => [...prev, newMessage]);
    setInputMessage("");

    // Show notification that message is sent to doctor
    setTimeout(() => {
      const notifMessage: Message = {
        id: `notif-${Date.now()}`,
        sender: "doctor",
        text: "✓ Pesan Anda telah terkirim ke dokter. Dokter akan merespons secepatnya.",
        timestamp: new Date(),
        read: true
      };
      setMessages(prev => [...prev, notifMessage]);
    }, 1000);
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString("id-ID", { 
      hour: "2-digit", 
      minute: "2-digit" 
    });
  };

  return (
    <MobileLayout showBottomNav={true}>
      <div className="flex flex-col h-screen">
        {/* Header */}
        <div className="flex-shrink-0 bg-white border-b border-slate-200">
          {/* Top Bar */}
          <div className="flex items-center gap-3 px-4 py-3">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => navigate('/patient')}
              className="p-2"
            >
              <ArrowLeft className="w-5 h-5" />
            </Button>
            
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <Stethoscope className="w-5 h-5 text-blue-600" />
                <div>
                  <h1 className="font-bold text-base text-slate-900">
                    {doctorInfo.name}
                  </h1>
                  <div className="flex items-center gap-2 text-xs text-slate-500">
                    <span>{doctorInfo.specialization}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Status Badge */}
            <Badge variant={doctorStatus === "online" ? "default" : "secondary"} className="text-xs">
              {doctorStatus === "online" ? "Online" : "Offline"}
            </Badge>
          </div>

        </div>

        {/* Info Banner */}
        <div className="flex-shrink-0 bg-blue-50 border-b border-blue-200 px-4 py-3">
          <div className="flex items-start gap-3">
            <Info className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div className="flex-1">
              <p className="text-sm text-blue-900">
                <strong>Catatan:</strong> Ini adalah komunikasi langsung dengan dokter Anda, 
                BUKAN chatbot AI. Dokter akan merespons pertanyaan Anda secepatnya.
              </p>
            </div>
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-slate-50">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.sender === "patient" ? "justify-end" : "justify-start"}`}
            >
              <div
                className={`max-w-[80%] rounded-2xl px-4 py-3 ${
                  message.sender === "patient"
                    ? "bg-blue-600 text-white"
                    : "bg-white text-slate-900 border border-slate-200"
                }`}
              >
                <p className="text-sm leading-relaxed whitespace-pre-wrap">
                  {message.text}
                </p>
                <div className={`flex items-center gap-1 mt-2 text-xs ${
                  message.sender === "patient" ? "text-blue-100" : "text-slate-500"
                }`}>
                  <Clock className="w-3 h-3" />
                  <span>{formatTime(message.timestamp)}</span>
                  {message.sender === "patient" && (
                    <CheckCheck className={`w-3 h-3 ml-1 ${message.read ? "text-blue-200" : ""}`} />
                  )}
                </div>
              </div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>

        {/* Input Area */}
        <div className="flex-shrink-0 bg-white border-t border-slate-200 p-4">
          <div className="flex gap-2">
            <Input
              value={inputMessage}
              onChange={(e) => setInputMessage(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="Ketik pesan untuk dokter..."
              className="flex-1 h-11"
            />
            <Button
              onClick={handleSendMessage}
              disabled={!inputMessage.trim()}
              className="bg-blue-600 hover:bg-blue-700 h-11 px-4"
            >
              <Send className="w-5 h-5" />
            </Button>
          </div>
          <p className="text-xs text-slate-500 mt-2 text-center">
            Pesan akan langsung diterima oleh dokter Anda
          </p>
        </div>
      </div>
    </MobileLayout>
  );
}
