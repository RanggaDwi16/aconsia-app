/**
 * Data Synchronization Utility
 * Memastikan data antara dokter dan pasien tersinkronisasi dengan baik
 */

import { getMaterialsByType } from "../../data/learningMaterials";

export interface PatientData {
  id: string;
  fullName: string;
  mrn: string;
  surgeryType: string;
  surgeryDate: string;
  anesthesiaType: string | null;
  status: "pending" | "approved" | "in_progress" | "ready" | "completed";
  comprehensionScore: number;
  assignedDoctorId: string;
  scheduledConsentDate?: string;
  assessmentCompleted?: boolean;
  materialsReadCount?: number;
  aiRecommendations?: any[];
  lastChatDate?: string;
}

/**
 * Validasi dan sinkronisasi materi edukasi
 * Memastikan jumlah dan isi materi sama antara dokter dan pasien
 */
export function validateMaterialsSync(patientId: string, anesthesiaType: string): {
  isValid: boolean;
  errors: string[];
  doctorMaterialsCount: number;
  patientMaterialsCount: number;
} {
  const errors: string[] = [];
  
  // Get materials dari learningMaterials.ts (single source of truth)
  const materials = getMaterialsByType(anesthesiaType);
  
  // Expected: 10 sections for each anesthesia type
  const expectedCount = 10;
  
  if (materials.length !== expectedCount) {
    errors.push(`Expected ${expectedCount} materials, but found ${materials.length}`);
  }
  
  // Validate each material has required fields
  materials.forEach((material, index) => {
    if (!material.id) errors.push(`Material ${index} missing ID`);
    if (!material.title) errors.push(`Material ${index} missing title`);
    if (!material.content) errors.push(`Material ${index} missing content`);
    if (!material.section) errors.push(`Material ${index} missing section number`);
  });
  
  return {
    isValid: errors.length === 0,
    errors,
    doctorMaterialsCount: materials.length,
    patientMaterialsCount: materials.length, // Same source
  };
}

/**
 * Sync patient data from doctor approval
 */
export function syncPatientFromDoctorApproval(
  patientId: string,
  anesthesiaType: string,
  doctorId: string
): PatientData | null {
  try {
    // Get current patient data
    const currentPatient = localStorage.getItem("currentPatient");
    if (!currentPatient) return null;
    
    const patient = JSON.parse(currentPatient) as PatientData;
    
    // Update with doctor's selection
    const updatedPatient: PatientData = {
      ...patient,
      anesthesiaType,
      assignedDoctorId: doctorId,
      status: "approved",
    };
    
    // Save to localStorage
    localStorage.setItem("currentPatient", JSON.stringify(updatedPatient));
    
    // Sync to demoPatients array
    const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
    const patientIndex = demoPatients.findIndex((p: any) => p.id === patient.id);
    
    if (patientIndex !== -1) {
      demoPatients[patientIndex] = updatedPatient;
    } else {
      demoPatients.push(updatedPatient);
    }
    
    localStorage.setItem("demoPatients", JSON.stringify(demoPatients));
    
    return updatedPatient;
  } catch (error) {
    console.error("Error syncing patient data:", error);
    return null;
  }
}

/**
 * Get materials for patient based on assigned anesthesia type
 * Returns materials from learningMaterials.ts (single source of truth)
 */
export function getPatientMaterials(anesthesiaType: string) {
  return getMaterialsByType(anesthesiaType);
}

/**
 * Update patient reading progress
 */
export function updateReadingProgress(
  patientId: string,
  materialId: string,
  progress: number
): boolean {
  try {
    const progressKey = `reading_progress_${patientId}`;
    const savedProgress = JSON.parse(localStorage.getItem(progressKey) || "{}");
    
    savedProgress[materialId] = progress;
    
    localStorage.setItem(progressKey, JSON.stringify(savedProgress));
    
    // Update patient data
    const currentPatient = localStorage.getItem("currentPatient");
    if (currentPatient) {
      const patient = JSON.parse(currentPatient);
      const materials = getMaterialsByType(patient.anesthesiaType);
      
      // Calculate overall comprehension
      const totalProgress = Object.values(savedProgress).reduce((a: any, b: any) => a + b, 0) as number;
      const avgProgress = Math.round(totalProgress / materials.length);
      
      patient.comprehensionScore = avgProgress;
      patient.materialsReadCount = Object.keys(savedProgress).length;
      
      // Update status based on progress
      if (avgProgress === 100) {
        patient.status = "ready";
      } else if (avgProgress > 0) {
        patient.status = "in_progress";
      }
      
      localStorage.setItem("currentPatient", JSON.stringify(patient));
      
      // Sync to demoPatients
      const demoPatients = JSON.parse(localStorage.getItem("demoPatients") || "[]");
      const patientIndex = demoPatients.findIndex((p: any) => p.id === patient.id);
      if (patientIndex !== -1) {
        demoPatients[patientIndex] = patient;
        localStorage.setItem("demoPatients", JSON.stringify(demoPatients));
      }
    }
    
    return true;
  } catch (error) {
    console.error("Error updating reading progress:", error);
    return false;
  }
}

/**
 * Validate that doctor and patient have the same materials
 */
export function validateDoctorPatientSync(patientId: string): {
  isSync: boolean;
  message: string;
} {
  try {
    const currentPatient = localStorage.getItem("currentPatient");
    if (!currentPatient) {
      return { isSync: false, message: "Patient data not found" };
    }
    
    const patient = JSON.parse(currentPatient);
    
    if (!patient.anesthesiaType) {
      return { isSync: false, message: "Anesthesia type not assigned by doctor yet" };
    }
    
    // Get materials from single source of truth
    const materials = getMaterialsByType(patient.anesthesiaType);
    
    if (materials.length === 0) {
      return { isSync: false, message: `No materials found for ${patient.anesthesiaType}` };
    }
    
    // Validate materials count
    const validation = validateMaterialsSync(patientId, patient.anesthesiaType);
    
    if (!validation.isValid) {
      return { 
        isSync: false, 
        message: `Validation failed: ${validation.errors.join(", ")}` 
      };
    }
    
    return { 
      isSync: true, 
      message: `Successfully synced ${materials.length} materials for ${patient.anesthesiaType}` 
    };
  } catch (error) {
    return { 
      isSync: false, 
      message: `Error: ${error instanceof Error ? error.message : "Unknown error"}` 
    };
  }
}

/**
 * Check if patient can access AI Chat
 * AI Chat hanya bisa diakses setelah SEMUA materi selesai dibaca
 */
export function canAccessAIChat(patientId: string): {
  canAccess: boolean;
  message: string;
  completedMaterials: number;
  totalMaterials: number;
} {
  try {
    const currentPatient = localStorage.getItem("currentPatient");
    if (!currentPatient) {
      return { 
        canAccess: false, 
        message: "Patient data not found",
        completedMaterials: 0,
        totalMaterials: 0
      };
    }
    
    const patient = JSON.parse(currentPatient);
    
    if (!patient.anesthesiaType) {
      return { 
        canAccess: false, 
        message: "Anesthesia type not assigned yet",
        completedMaterials: 0,
        totalMaterials: 0
      };
    }
    
    const materials = getMaterialsByType(patient.anesthesiaType);
    const progressKey = `reading_progress_${patientId}`;
    const savedProgress = JSON.parse(localStorage.getItem(progressKey) || "{}");
    
    // Count completed materials (100% progress)
    const completedMaterials = materials.filter(m => savedProgress[m.id] === 100).length;
    const totalMaterials = materials.length;
    
    if (completedMaterials === totalMaterials) {
      return {
        canAccess: true,
        message: "All materials completed. AI Chat is now available!",
        completedMaterials,
        totalMaterials
      };
    }
    
    return {
      canAccess: false,
      message: `Please complete all materials first. ${completedMaterials}/${totalMaterials} completed.`,
      completedMaterials,
      totalMaterials
    };
  } catch (error) {
    return {
      canAccess: false,
      message: `Error: ${error instanceof Error ? error.message : "Unknown error"}`,
      completedMaterials: 0,
      totalMaterials: 0
    };
  }
}
