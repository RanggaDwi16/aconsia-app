import assert from "node:assert/strict";
import {
  mergePatientRowsByCanonicalUid,
  normalizeDoctorPatientDisplay,
} from "./patientDataNormalizer";

function fakeTimestamp(iso: string) {
  const date = new Date(iso);
  return {
    toDate: () => date,
    toMillis: () => date.getTime(),
  };
}

export function runPatientDataNormalizerTests() {
  const timestampCase = normalizeDoctorPatientDisplay({
    noRekamMedis: "RM-001",
    jenisOperasi: "Appendektomi",
    preOperativeAssessment: {
      scheduledSignatureDate: fakeTimestamp("2026-04-12T09:00:00.000Z"),
      scheduledSignatureTime: "09:00",
    },
  });
  assert.equal(timestampCase.mrnText, "RM-001");
  assert.equal(timestampCase.diagnosisText, "Appendektomi");
  assert.match(timestampCase.scheduleText, /09:00/);

  const isoCase = normalizeDoctorPatientDisplay({
    mrn: "RM-ISO",
    surgeryType: "Hernia",
    preOperativeAssessment: {
      scheduledSignatureDate: "2026-04-13T00:00:00.000Z",
      scheduledSignatureTime: "10:30",
    },
  });
  assert.equal(isoCase.mrnText, "RM-ISO");
  assert.equal(isoCase.diagnosisText, "Hernia");
  assert.match(isoCase.scheduleText, /10:30/);

  const nestedDiagnosisCase = normalizeDoctorPatientDisplay({
    preOperativeAssessment: {
      data: {
        diagnosis: "Kolelitiasis",
      },
    },
  });
  assert.equal(nestedDiagnosisCase.diagnosisText, "Kolelitiasis");

  const emptyCase = normalizeDoctorPatientDisplay({});
  assert.equal(emptyCase.mrnText, "Belum diisi");
  assert.equal(emptyCase.diagnosisText, "Belum diisi");
  assert.equal(emptyCase.scheduleText, "Belum dijadwalkan");

  const dedupeCase = mergePatientRowsByCanonicalUid([
    {
      docId: "doc-lama",
      data: {
        uid: "pasien-001",
        noRekamMedis: "RM-LAMA",
        updatedAt: "2026-04-10T01:00:00.000Z",
      },
    },
    {
      docId: "doc-baru",
      data: {
        uid: "pasien-001",
        jenisOperasi: "Operasi Baru",
        updatedAt: "2026-04-12T01:00:00.000Z",
      },
    },
  ]);
  assert.equal(dedupeCase.length, 1);
  assert.equal(dedupeCase[0].primaryDocId, "doc-baru");
  assert.equal(
    normalizeDoctorPatientDisplay(dedupeCase[0].data).mrnText,
    "RM-LAMA",
  );
}

if (process.env.RUN_NORMALIZER_TESTS === "1") {
  runPatientDataNormalizerTests();
  // eslint-disable-next-line no-console
  console.log("patientDataNormalizer tests passed");
}
