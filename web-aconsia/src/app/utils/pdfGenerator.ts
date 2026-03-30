import jsPDF from 'jspdf';
import 'jspdf-autotable';

// Extend jsPDF type to include autoTable
declare module 'jspdf' {
  interface jsPDF {
    autoTable: (options: any) => jsPDF;
  }
}

export interface PatientReportData {
  patientName: string;
  mrn: string;
  surgery: string;
  anesthesiaType: string;
  scheduledDate: string;
  doctor: string;
  comprehensionScore: number;
  quizzesTaken: number;
  educationProgress: number;
  contentsViewed: number;
  chatbotInteractions: number;
}

export interface DoctorPerformanceData {
  doctorName: string;
  period: string;
  totalPatients: number;
  avgComprehension: number;
  contentsCreated: number;
  topPatients: Array<{
    name: string;
    comprehension: number;
  }>;
}

export interface HospitalReportData {
  period: string;
  totalDoctors: number;
  totalPatients: number;
  avgComprehension: number;
  completionRate: number;
  anesthesiaDistribution: Array<{
    type: string;
    count: number;
    percentage: number;
  }>;
}

export class PDFGenerator {
  // Generate Patient Comprehension Report
  static generatePatientReport(data: PatientReportData): void {
    const doc = new jsPDF();
    
    // Header
    doc.setFillColor(37, 99, 235); // Blue
    doc.rect(0, 0, 210, 35, 'F');
    
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(20);
    doc.text('LAPORAN PEMAHAMAN PASIEN', 105, 15, { align: 'center' });
    doc.setFontSize(12);
    doc.text('Sistem Edukasi Informed Consent Anestesi', 105, 25, { align: 'center' });
    
    // Patient Info
    doc.setTextColor(0, 0, 0);
    doc.setFontSize(11);
    let yPos = 50;
    
    doc.setFont(undefined, 'bold');
    doc.text('INFORMASI PASIEN', 20, yPos);
    doc.setFont(undefined, 'normal');
    yPos += 10;
    
    const patientInfo = [
      ['Nama Pasien', data.patientName],
      ['No. Rekam Medis', data.mrn],
      ['Jenis Operasi', data.surgery],
      ['Jenis Anestesi', data.anesthesiaType],
      ['Tanggal Terjadwal', data.scheduledDate],
      ['Dokter Anestesi', data.doctor],
    ];
    
    doc.autoTable({
      startY: yPos,
      head: [],
      body: patientInfo,
      theme: 'plain',
      columnStyles: {
        0: { fontStyle: 'bold', cellWidth: 50 },
        1: { cellWidth: 120 }
      },
      margin: { left: 20 }
    });
    
    yPos = (doc as any).lastAutoTable.finalY + 15;
    
    // Comprehension Score
    doc.setFont(undefined, 'bold');
    doc.text('TINGKAT PEMAHAMAN', 20, yPos);
    doc.setFont(undefined, 'normal');
    yPos += 10;
    
    // Score box
    const scoreColor = data.comprehensionScore >= 90 ? [34, 197, 94] : 
                       data.comprehensionScore >= 80 ? [234, 179, 8] : [239, 68, 68];
    doc.setFillColor(scoreColor[0], scoreColor[1], scoreColor[2]);
    doc.roundedRect(20, yPos, 50, 30, 3, 3, 'F');
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(24);
    doc.text(`${data.comprehensionScore}%`, 45, yPos + 20, { align: 'center' });
    
    doc.setTextColor(0, 0, 0);
    doc.setFontSize(11);
    const status = data.comprehensionScore >= 90 ? 'SANGAT BAIK' :
                   data.comprehensionScore >= 80 ? 'BAIK' : 'PERLU EDUKASI LANJUTAN';
    doc.text(status, 80, yPos + 15);
    
    yPos += 40;
    
    // Metrics
    doc.setFont(undefined, 'bold');
    doc.text('METRIK PEMBELAJARAN', 20, yPos);
    yPos += 10;
    
    const metrics = [
      ['Progress Edukasi', `${data.educationProgress}%`],
      ['Kuis Diselesaikan', `${data.quizzesTaken} kuis`],
      ['Konten Dibaca/Ditonton', `${data.contentsViewed} materi`],
      ['Interaksi Chatbot', `${data.chatbotInteractions} percakapan`],
    ];
    
    doc.setFont(undefined, 'normal');
    doc.autoTable({
      startY: yPos,
      head: [],
      body: metrics,
      theme: 'grid',
      headStyles: { fillColor: [37, 99, 235] },
      columnStyles: {
        0: { fontStyle: 'bold', cellWidth: 80 },
        1: { cellWidth: 90 }
      },
      margin: { left: 20 }
    });
    
    yPos = (doc as any).lastAutoTable.finalY + 15;
    
    // Conclusion
    doc.setFont(undefined, 'bold');
    doc.text('KESIMPULAN', 20, yPos);
    doc.setFont(undefined, 'normal');
    yPos += 7;
    
    const conclusion = data.comprehensionScore >= 90 
      ? 'Pasien telah menunjukkan pemahaman yang sangat baik tentang prosedur anestesi. Pasien dinyatakan SIAP untuk menjalani prosedur operasi.'
      : data.comprehensionScore >= 80
      ? 'Pasien memiliki pemahaman yang baik tentang prosedur anestesi. Disarankan untuk review singkat sebelum operasi.'
      : 'Pasien perlu edukasi tambahan untuk meningkatkan pemahaman tentang prosedur anestesi sebelum operasi.';
    
    const splitConclusion = doc.splitTextToSize(conclusion, 170);
    doc.text(splitConclusion, 20, yPos);
    
    // Footer
    yPos = 270;
    doc.setFontSize(9);
    doc.setTextColor(100, 100, 100);
    doc.text(`Dicetak: ${new Date().toLocaleDateString('id-ID', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })}`, 105, yPos, { align: 'center' });
    doc.text('Sistem Edukasi Informed Consent Anestesi - Dokumen Rahasia Medis', 105, yPos + 5, { align: 'center' });
    
    // Save
    doc.save(`Laporan_Pasien_${data.mrn}_${new Date().getTime()}.pdf`);
  }

  // Generate Doctor Performance Report
  static generateDoctorReport(data: DoctorPerformanceData): void {
    const doc = new jsPDF();
    
    // Header
    doc.setFillColor(37, 99, 235);
    doc.rect(0, 0, 210, 35, 'F');
    
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(20);
    doc.text('LAPORAN PERFORMA DOKTER', 105, 15, { align: 'center' });
    doc.setFontSize(12);
    doc.text('Sistem Edukasi Informed Consent Anestesi', 105, 25, { align: 'center' });
    
    // Doctor Info
    doc.setTextColor(0, 0, 0);
    doc.setFontSize(11);
    let yPos = 50;
    
    doc.setFont(undefined, 'bold');
    doc.text(`Dokter: ${data.doctorName}`, 20, yPos);
    doc.setFont(undefined, 'normal');
    doc.text(`Periode: ${data.period}`, 20, yPos + 7);
    yPos += 20;
    
    // Key Metrics
    doc.setFont(undefined, 'bold');
    doc.text('METRIK UTAMA', 20, yPos);
    yPos += 10;
    
    const keyMetrics = [
      ['Total Pasien Diedukasi', data.totalPatients.toString()],
      ['Rata-rata Pemahaman Pasien', `${data.avgComprehension}%`],
      ['Konten Edukasi Dibuat', data.contentsCreated.toString()],
    ];
    
    doc.setFont(undefined, 'normal');
    doc.autoTable({
      startY: yPos,
      head: [],
      body: keyMetrics,
      theme: 'grid',
      headStyles: { fillColor: [37, 99, 235] },
      columnStyles: {
        0: { fontStyle: 'bold', cellWidth: 90 },
        1: { cellWidth: 80, halign: 'center' }
      },
      margin: { left: 20 }
    });
    
    yPos = (doc as any).lastAutoTable.finalY + 15;
    
    // Top Patients
    doc.setFont(undefined, 'bold');
    doc.text('PASIEN DENGAN PEMAHAMAN TERTINGGI', 20, yPos);
    yPos += 10;
    
    const topPatientsData = data.topPatients.map((p, i) => [
      (i + 1).toString(),
      p.name,
      `${p.comprehension}%`
    ]);
    
    doc.setFont(undefined, 'normal');
    doc.autoTable({
      startY: yPos,
      head: [['No', 'Nama Pasien', 'Skor']],
      body: topPatientsData,
      theme: 'striped',
      headStyles: { fillColor: [37, 99, 235] },
      columnStyles: {
        0: { cellWidth: 15, halign: 'center' },
        1: { cellWidth: 120 },
        2: { cellWidth: 35, halign: 'center' }
      },
      margin: { left: 20 }
    });
    
    yPos = (doc as any).lastAutoTable.finalY + 15;
    
    // Performance Rating
    doc.setFont(undefined, 'bold');
    doc.text('RATING PERFORMA', 20, yPos);
    yPos += 10;
    
    const rating = data.avgComprehension >= 90 ? '⭐⭐⭐⭐⭐ EXCELLENT' :
                   data.avgComprehension >= 85 ? '⭐⭐⭐⭐ VERY GOOD' :
                   data.avgComprehension >= 80 ? '⭐⭐⭐ GOOD' : '⭐⭐ NEEDS IMPROVEMENT';
    
    doc.setFontSize(14);
    doc.text(rating, 20, yPos);
    
    // Footer
    yPos = 270;
    doc.setFontSize(9);
    doc.setTextColor(100, 100, 100);
    doc.text(`Dicetak: ${new Date().toLocaleDateString('id-ID', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    })}`, 105, yPos, { align: 'center' });
    
    doc.save(`Laporan_Dokter_${data.doctorName.replace(/\s/g, '_')}_${new Date().getTime()}.pdf`);
  }

  // Generate Hospital Report
  static generateHospitalReport(data: HospitalReportData): void {
    const doc = new jsPDF();
    
    // Header
    doc.setFillColor(147, 51, 234); // Purple for admin
    doc.rect(0, 0, 210, 35, 'F');
    
    doc.setTextColor(255, 255, 255);
    doc.setFontSize(20);
    doc.text('LAPORAN RUMAH SAKIT', 105, 15, { align: 'center' });
    doc.setFontSize(12);
    doc.text('Sistem Edukasi Informed Consent Anestesi', 105, 25, { align: 'center' });
    
    doc.setTextColor(0, 0, 0);
    doc.setFontSize(11);
    let yPos = 50;
    
    doc.setFont(undefined, 'bold');
    doc.text(`Periode: ${data.period}`, 20, yPos);
    yPos += 15;
    
    // Overview
    doc.text('RINGKASAN SISTEM', 20, yPos);
    yPos += 10;
    
    const overview = [
      ['Total Dokter Anestesi Aktif', data.totalDoctors.toString()],
      ['Total Pasien Diedukasi', data.totalPatients.toString()],
      ['Rata-rata Pemahaman Global', `${data.avgComprehension}%`],
      ['Tingkat Penyelesaian', `${data.completionRate}%`],
    ];
    
    doc.setFont(undefined, 'normal');
    doc.autoTable({
      startY: yPos,
      head: [],
      body: overview,
      theme: 'grid',
      headStyles: { fillColor: [147, 51, 234] },
      columnStyles: {
        0: { fontStyle: 'bold', cellWidth: 90 },
        1: { cellWidth: 80, halign: 'center' }
      },
      margin: { left: 20 }
    });
    
    yPos = (doc as any).lastAutoTable.finalY + 15;
    
    // Anesthesia Distribution
    doc.setFont(undefined, 'bold');
    doc.text('DISTRIBUSI JENIS ANESTESI', 20, yPos);
    yPos += 10;
    
    const distributionData = data.anesthesiaDistribution.map(item => [
      item.type,
      item.count.toString(),
      `${item.percentage}%`
    ]);
    
    doc.setFont(undefined, 'normal');
    doc.autoTable({
      startY: yPos,
      head: [['Jenis Anestesi', 'Jumlah Pasien', 'Persentase']],
      body: distributionData,
      theme: 'striped',
      headStyles: { fillColor: [147, 51, 234] },
      columnStyles: {
        0: { cellWidth: 70 },
        1: { cellWidth: 50, halign: 'center' },
        2: { cellWidth: 50, halign: 'center' }
      },
      margin: { left: 20 }
    });
    
    // Footer
    yPos = 270;
    doc.setFontSize(9);
    doc.setTextColor(100, 100, 100);
    doc.text(`Dicetak: ${new Date().toLocaleDateString('id-ID', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    })}`, 105, yPos, { align: 'center' });
    
    doc.save(`Laporan_RS_${data.period.replace(/\s/g, '_')}_${new Date().getTime()}.pdf`);
  }
}
