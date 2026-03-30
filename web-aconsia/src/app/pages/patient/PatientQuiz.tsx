import { DashboardLayout } from "../../components/DashboardLayout";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../../components/ui/card";
import { Button } from "../../components/ui/button";
import { Badge } from "../../components/ui/badge";
import { Progress } from "../../components/ui/progress";
import { RadioGroup, RadioGroupItem } from "../../components/ui/radio-group";
import { Label } from "../../components/ui/label";
import { ClipboardCheck, Award, TrendingUp, CheckCircle, XCircle, RefreshCw } from "lucide-react";
import { useState } from "react";

interface Question {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
  explanation: string;
}

export function PatientQuiz() {
  const [currentQuizIndex, setCurrentQuizIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [showResult, setShowResult] = useState(false);
  const [quizStarted, setQuizStarted] = useState(false);
  const [answers, setAnswers] = useState<(number | null)[]>([]);
  const [showFinalResult, setShowFinalResult] = useState(false);

  // Kuis khusus untuk Anestesi Spinal
  const quizzes: Question[] = [
    {
      id: "1",
      question: "Apa itu anestesi spinal?",
      options: [
        "Obat bius yang membuat tidur total",
        "Suntikan ke tulang belakang yang membuat mati rasa bagian bawah tubuh",
        "Obat bius yang dihirup melalui hidung",
        "Obat penghilang rasa sakit biasa"
      ],
      correctAnswer: 1,
      explanation: "Anestesi spinal adalah teknik pembiusan dengan menyuntikkan obat ke ruang subarachnoid di tulang belakang, yang membuat mati rasa pada bagian bawah tubuh sambil tetap sadar."
    },
    {
      id: "2",
      question: "Berapa lama biasanya efek anestesi spinal bertahan?",
      options: [
        "30 menit - 1 jam",
        "2-4 jam",
        "8-12 jam",
        "24 jam"
      ],
      correctAnswer: 1,
      explanation: "Efek anestesi spinal umumnya bertahan 2-4 jam, yang cukup untuk operasi caesar dan memberikan waktu pemulihan awal yang nyaman."
    },
    {
      id: "3",
      question: "Posisi apa yang biasanya digunakan saat penyuntikan anestesi spinal?",
      options: [
        "Berbaring telentang",
        "Duduk membungkuk atau berbaring miring dengan punggung melengkung",
        "Berdiri tegak",
        "Berbaring tengkurap"
      ],
      correctAnswer: 1,
      explanation: "Pasien diminta duduk membungkuk atau berbaring miring dengan punggung melengkung agar tulang belakang lebih terbuka, memudahkan dokter menemukan lokasi penyuntikan yang tepat."
    },
    {
      id: "4",
      question: "Apa keuntungan utama anestesi spinal untuk operasi caesar?",
      options: [
        "Pasien tetap sadar dan bisa segera melihat bayinya",
        "Tidak ada efek samping sama sekali",
        "Lebih murah dari jenis anestesi lain",
        "Bisa langsung pulang setelah operasi"
      ],
      correctAnswer: 0,
      explanation: "Keuntungan utama adalah ibu tetap sadar selama operasi dan bisa langsung melihat serta mendengar tangisan bayinya, menciptakan momen bonding yang berharga."
    },
    {
      id: "5",
      question: "Apa yang harus dilakukan jika merasa sakit kepala setelah anestesi spinal?",
      options: [
        "Mengabaikannya karena akan hilang sendiri",
        "Segera memberitahu tim medis",
        "Langsung minum obat warung",
        "Banyak berdiri dan berjalan"
      ],
      correctAnswer: 1,
      explanation: "Sakit kepala pasca-anestesi spinal (PDPH) perlu dilaporkan ke tim medis. Mereka akan memberikan penanganan yang tepat, seperti istirahat berbaring, hidrasi, atau terapi khusus jika diperlukan."
    }
  ];

  const previousScores = [
    { date: "5 Mar 2026", score: 80, questions: 5 },
    { date: "6 Mar 2026", score: 90, questions: 5 },
    { date: "7 Mar 2026", score: 95, questions: 5 }
  ];

  const handleStartQuiz = () => {
    setQuizStarted(true);
    setCurrentQuizIndex(0);
    setAnswers(new Array(quizzes.length).fill(null));
    setSelectedAnswer(null);
    setShowResult(false);
    setShowFinalResult(false);
  };

  const handleAnswerSelect = (answerIndex: number) => {
    setSelectedAnswer(answerIndex);
  };

  const handleSubmitAnswer = () => {
    if (selectedAnswer === null) return;
    
    const newAnswers = [...answers];
    newAnswers[currentQuizIndex] = selectedAnswer;
    setAnswers(newAnswers);
    setShowResult(true);
  };

  const handleNextQuestion = () => {
    if (currentQuizIndex < quizzes.length - 1) {
      setCurrentQuizIndex(currentQuizIndex + 1);
      setSelectedAnswer(null);
      setShowResult(false);
    } else {
      setShowFinalResult(true);
    }
  };

  const calculateScore = () => {
    let correct = 0;
    answers.forEach((answer, index) => {
      if (answer === quizzes[index].correctAnswer) {
        correct++;
      }
    });
    return Math.round((correct / quizzes.length) * 100);
  };

  const currentQuestion = quizzes[currentQuizIndex];
  const isCorrect = selectedAnswer === currentQuestion.correctAnswer;

  if (!quizStarted) {
    return (
      <DashboardLayout role="patient" userName="Ibu Sarah Wijaya">
        <div className="space-y-6">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Kuis Pemahaman</h1>
            <p className="text-gray-600 mt-1">Ukur pemahaman Anda tentang anestesi spinal</p>
          </div>

          <Card className="border-l-4 border-l-purple-600">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <ClipboardCheck className="w-6 h-6 text-purple-600" />
                Kuis Anestesi Spinal
              </CardTitle>
              <CardDescription>
                Kuis ini dirancang khusus untuk mengukur pemahaman Anda tentang prosedur anestesi spinal
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="bg-purple-50 border border-purple-200 rounded-lg p-4">
                <h4 className="font-semibold text-purple-900 mb-2">Informasi Kuis</h4>
                <ul className="text-sm text-purple-800 space-y-1">
                  <li>📝 Total {quizzes.length} pertanyaan pilihan ganda</li>
                  <li>⏱️ Tidak ada batasan waktu - kerjakan dengan tenang</li>
                  <li>💡 Penjelasan akan diberikan untuk setiap jawaban</li>
                  <li>✅ Skor minimal 80% untuk dinyatakan paham</li>
                </ul>
              </div>

              <Button 
                size="lg" 
                className="w-full bg-purple-600 hover:bg-purple-700"
                onClick={handleStartQuiz}
              >
                Mulai Kuis
              </Button>
            </CardContent>
          </Card>

          {/* Previous Scores */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <TrendingUp className="w-5 h-5 text-green-600" />
                Riwayat Skor Anda
              </CardTitle>
              <CardDescription>Progress pemahaman dari waktu ke waktu</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {previousScores.map((record, index) => (
                  <div key={index} className="flex items-center justify-between p-4 border rounded-lg">
                    <div className="flex items-center gap-4">
                      <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                        record.score >= 90 ? 'bg-green-100' : 
                        record.score >= 80 ? 'bg-yellow-100' : 'bg-red-100'
                      }`}>
                        <span className={`text-lg font-bold ${
                          record.score >= 90 ? 'text-green-700' : 
                          record.score >= 80 ? 'text-yellow-700' : 'text-red-700'
                        }`}>
                          {record.score}
                        </span>
                      </div>
                      <div>
                        <p className="font-medium">{record.date}</p>
                        <p className="text-sm text-gray-600">{record.questions} pertanyaan</p>
                      </div>
                    </div>
                    {record.score >= 90 && (
                      <Award className="w-6 h-6 text-yellow-500" />
                    )}
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </DashboardLayout>
    );
  }

  if (showFinalResult) {
    const finalScore = calculateScore();
    const isPassed = finalScore >= 80;

    return (
      <DashboardLayout role="patient" userName="Ibu Sarah Wijaya">
        <div className="space-y-6">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Hasil Kuis</h1>
            <p className="text-gray-600 mt-1">Kuis pemahaman anestesi spinal selesai</p>
          </div>

          <Card className={`border-l-4 ${isPassed ? 'border-l-green-600' : 'border-l-yellow-600'}`}>
            <CardHeader className="text-center">
              <div className={`w-24 h-24 mx-auto rounded-full flex items-center justify-center mb-4 ${
                isPassed ? 'bg-green-100' : 'bg-yellow-100'
              }`}>
                <span className={`text-4xl font-bold ${
                  isPassed ? 'text-green-700' : 'text-yellow-700'
                }`}>
                  {finalScore}
                </span>
              </div>
              <CardTitle className="text-2xl">
                {isPassed ? "Excellent! 🎉" : "Bagus! Terus Belajar 📚"}
              </CardTitle>
              <CardDescription className="text-base">
                {isPassed 
                  ? "Anda telah memahami prosedur anestesi spinal dengan sangat baik!"
                  : "Anda sudah cukup paham, tapi ada beberapa hal yang perlu dipelajari lebih lanjut."
                }
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h4 className="font-semibold text-blue-900 mb-3">Ringkasan Hasil</h4>
                <div className="grid grid-cols-3 gap-4 text-center">
                  <div>
                    <p className="text-2xl font-bold text-blue-600">
                      {answers.filter((a, i) => a === quizzes[i].correctAnswer).length}
                    </p>
                    <p className="text-sm text-gray-600">Benar</p>
                  </div>
                  <div>
                    <p className="text-2xl font-bold text-red-600">
                      {answers.filter((a, i) => a !== quizzes[i].correctAnswer).length}
                    </p>
                    <p className="text-sm text-gray-600">Salah</p>
                  </div>
                  <div>
                    <p className="text-2xl font-bold text-purple-600">{quizzes.length}</p>
                    <p className="text-sm text-gray-600">Total</p>
                  </div>
                </div>
              </div>

              <div className="space-y-3">
                <h4 className="font-semibold">Review Jawaban:</h4>
                {quizzes.map((q, index) => {
                  const userAnswer = answers[index];
                  const isCorrectAnswer = userAnswer === q.correctAnswer;
                  return (
                    <div key={q.id} className={`p-4 border rounded-lg ${
                      isCorrectAnswer ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'
                    }`}>
                      <div className="flex items-start gap-3">
                        {isCorrectAnswer ? (
                          <CheckCircle className="w-5 h-5 text-green-600 flex-shrink-0 mt-1" />
                        ) : (
                          <XCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-1" />
                        )}
                        <div className="flex-1">
                          <p className="font-medium mb-1">{index + 1}. {q.question}</p>
                          <p className="text-sm text-gray-700">
                            <span className="font-medium">Jawaban Anda: </span>
                            {q.options[userAnswer!]}
                          </p>
                          {!isCorrectAnswer && (
                            <p className="text-sm text-green-700 mt-1">
                              <span className="font-medium">Jawaban yang benar: </span>
                              {q.options[q.correctAnswer]}
                            </p>
                          )}
                          <p className="text-sm text-gray-600 mt-2 italic">{q.explanation}</p>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="flex gap-3">
                <Button 
                  variant="outline" 
                  className="flex-1 gap-2"
                  onClick={() => {
                    setQuizStarted(false);
                    setShowFinalResult(false);
                  }}
                >
                  Kembali
                </Button>
                <Button 
                  className="flex-1 gap-2 bg-purple-600 hover:bg-purple-700"
                  onClick={handleStartQuiz}
                >
                  <RefreshCw className="w-4 h-4" />
                  Coba Lagi
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </DashboardLayout>
    );
  }

  return (
    <DashboardLayout role="patient" userName="Ibu Sarah Wijaya">
      <div className="space-y-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Kuis Pemahaman</h1>
          <p className="text-gray-600 mt-1">Pertanyaan {currentQuizIndex + 1} dari {quizzes.length}</p>
        </div>

        <div className="mb-4">
          <Progress value={((currentQuizIndex + 1) / quizzes.length) * 100} className="h-2" />
        </div>

        <Card>
          <CardHeader>
            <div className="flex items-center justify-between mb-2">
              <Badge className="bg-purple-600">Pertanyaan {currentQuizIndex + 1}</Badge>
              <Badge variant="outline">Anestesi Spinal</Badge>
            </div>
            <CardTitle className="text-xl">{currentQuestion.question}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            {!showResult ? (
              <>
                <RadioGroup value={selectedAnswer?.toString()} onValueChange={(val) => handleAnswerSelect(parseInt(val))}>
                  <div className="space-y-3">
                    {currentQuestion.options.map((option, index) => (
                      <div key={index} className="flex items-center space-x-3 p-4 border rounded-lg hover:bg-gray-50 cursor-pointer">
                        <RadioGroupItem value={index.toString()} id={`option-${index}`} />
                        <Label htmlFor={`option-${index}`} className="flex-1 cursor-pointer">
                          {option}
                        </Label>
                      </div>
                    ))}
                  </div>
                </RadioGroup>

                <Button
                  className="w-full bg-purple-600 hover:bg-purple-700"
                  onClick={handleSubmitAnswer}
                  disabled={selectedAnswer === null}
                >
                  Submit Jawaban
                </Button>
              </>
            ) : (
              <>
                <div className={`p-4 rounded-lg border-l-4 ${
                  isCorrect ? 'bg-green-50 border-l-green-600' : 'bg-red-50 border-l-red-600'
                }`}>
                  <div className="flex items-start gap-3 mb-3">
                    {isCorrect ? (
                      <CheckCircle className="w-6 h-6 text-green-600 flex-shrink-0" />
                    ) : (
                      <XCircle className="w-6 h-6 text-red-600 flex-shrink-0" />
                    )}
                    <div>
                      <p className="font-semibold mb-1">
                        {isCorrect ? "Jawaban Anda Benar! 🎉" : "Jawaban Kurang Tepat"}
                      </p>
                      {!isCorrect && (
                        <p className="text-sm">
                          Jawaban yang benar: <strong>{currentQuestion.options[currentQuestion.correctAnswer]}</strong>
                        </p>
                      )}
                    </div>
                  </div>
                  <div className="pl-9">
                    <p className="text-sm text-gray-700"><strong>Penjelasan:</strong></p>
                    <p className="text-sm text-gray-700 mt-1">{currentQuestion.explanation}</p>
                  </div>
                </div>

                <Button
                  className="w-full bg-purple-600 hover:bg-purple-700"
                  onClick={handleNextQuestion}
                >
                  {currentQuizIndex < quizzes.length - 1 ? "Pertanyaan Selanjutnya" : "Lihat Hasil"}
                </Button>
              </>
            )}
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
}
