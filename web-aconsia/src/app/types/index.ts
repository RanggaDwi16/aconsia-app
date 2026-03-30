export type UserRole = 'admin' | 'doctor' | 'patient';

export type AnesthesiaType = 'general' | 'spinal' | 'epidural' | 'regional' | 'local';

export type ASAStatus = 'I' | 'II' | 'III' | 'IV' | 'V';

export interface Doctor {
  id: string;
  fullName: string;
  dateOfBirth: string;
  gender: 'male' | 'female';
  strNumber: string;
  sipNumber: string;
  email: string;
  phoneNumber: string;
  specialty: string;
  accountStatus: 'active' | 'inactive';
  joinedDate: string;
  profilePhoto?: string;
}

export interface Patient {
  id: string;
  fullName: string;
  medicalRecordNumber: string;
  surgeryType: string;
  anesthesiaType: AnesthesiaType;
  nik: string;
  dateOfBirth: string;
  gender: 'male' | 'female';
  profilePhoto?: string;
  phoneNumber: string;
  email: string;
  guardianName?: string;
  guardianAddress?: string;
  guardianRelation?: string;
  guardianPhone?: string;
  guardianEmail?: string;
  doctorId: string;
}

export interface PatientMedicalData {
  patientId: string;
  mainDisease: string;
  drugAllergies: string[];
  previousSurgeries: string[];
  asaStatus: ASAStatus;
  height: number;
  weight: number;
  isPregnant?: boolean;
  currentMedications: string[];
}

export interface ProcedureInfo {
  id: string;
  patientId: string;
  anesthesiaType: AnesthesiaType;
  scheduledDate: string;
  doctorId: string;
  approvalStatus: 'pending' | 'approved' | 'rejected';
  createdAt: string;
}

export interface EducationalContent {
  id: string;
  title: string;
  anesthesiaType: AnesthesiaType;
  content: string;
  videoUrl?: string;
  imageUrl?: string;
  doctorId: string;
  createdAt: string;
  updatedAt: string;
}

export interface QuizQuestion {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
  anesthesiaType: AnesthesiaType;
}

export interface QuizResult {
  id: string;
  patientId: string;
  quizId: string;
  score: number;
  completedAt: string;
}

export interface ComprehensionReport {
  patientId: string;
  anesthesiaType: AnesthesiaType;
  comprehensionScore: number;
  quizzesTaken: number;
  lastAssessment: string;
  educationProgress: number;
}
