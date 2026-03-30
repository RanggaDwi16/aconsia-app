import { createContext, useContext, useState, useEffect, ReactNode } from "react";

interface PatientData {
  id: string;
  userId: string;
  fullName: string;
  mrn: string;
  dateOfBirth: string;
  age: number;
  gender: string;
  phone: string;
  email: string;
  address: string;
  surgeryType: string;
  surgeryDate: string;
  asaStatus: string;
  anesthesiaType: string | null; // Set by doctor
  medicalHistory: string;
  allergies: string;
  medications: string;
  status: "pending" | "approved" | "completed";
  assignedDoctorId: string;
  comprehensionScore: number;
}

interface PatientContextType {
  patient: PatientData | null;
  setPatient: (patient: PatientData | null) => void;
  updatePatient: (updates: Partial<PatientData>) => void;
  isLoading: boolean;
}

const PatientContext = createContext<PatientContextType | undefined>(undefined);

export function PatientProvider({ children }: { children: ReactNode }) {
  const [patient, setPatient] = useState<PatientData | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  // Load patient from localStorage (simulate backend)
  useEffect(() => {
    const loadPatient = () => {
      const savedPatient = localStorage.getItem("currentPatient");
      if (savedPatient) {
        setPatient(JSON.parse(savedPatient));
      }
      setIsLoading(false);
    };

    loadPatient();
  }, []);

  // Save to localStorage whenever patient changes
  useEffect(() => {
    if (patient) {
      localStorage.setItem("currentPatient", JSON.stringify(patient));
    }
  }, [patient]);

  const updatePatient = (updates: Partial<PatientData>) => {
    setPatient((prev) => (prev ? { ...prev, ...updates } : null));
  };

  return (
    <PatientContext.Provider value={{ patient, setPatient, updatePatient, isLoading }}>
      {children}
    </PatientContext.Provider>
  );
}

export function usePatient() {
  const context = useContext(PatientContext);
  if (context === undefined) {
    throw new Error("usePatient must be used within a PatientProvider");
  }
  return context;
}
