# 📁 Struktur Folder Lengkap

```
Anti/
│
├── 📄 QUICK_START.md                    ⭐ BACA INI DULU!
├── 📄 PANDUAN_IMPLEMENTASI.md           📚 Panduan lengkap teori & implementasi
├── 📄 bozkurt2022.md                    📖 Paper utama (model & optimisasi)
├── 📄 bozkurt2019.md                    📖 Paper referensi (geometri ventrikel)
├── 📄 protokolDCM.md                    📋 Protokol pengumpulan data
│
└── 📁 matlab/                           💻 KODE MATLAB
    │
    ├── 📄 README.md                     📖 Instruksi penggunaan
    ├── 📄 main_simulation.m             ⭐ SCRIPT UTAMA - Jalankan ini!
    ├── 📄 compare_healthy_vs_dcm.m      📊 Perbandingan healthy vs DCM
    │
    ├── 📁 models/                       🧮 Model matematis
    │   └── cardiovascular_model.m       - Model sistem kardiovaskular lengkap
    │                                      (4 ruang jantung + sirkulasi)
    │
    ├── 📁 optimization/                 🎯 Optimisasi parameter
    │   └── optimize_parameters.m        - Algoritma direct search
    │                                      (optimasi 23 parameter)
    │
    ├── 📁 utils/                        🔧 Fungsi utilitas
    │   └── validate_results.m           - Validasi & hitung indikator klinis
    │                                      (EF, FS, SI, error, dll)
    │
    └── 📁 data/                         💾 Data pasien & hasil
        ├── patient_template.m           - Template input data pasien
        └── simulation_results.mat       - Output hasil simulasi (akan dibuat)
```

---

## 🎯 Workflow Penelitian

```
┌─────────────────────────────────────────────────────────────┐
│  FASE 1: PERSIAPAN (Minggu 1-2)                             │
└─────────────────────────────────────────────────────────────┘
    │
    ├─► Baca QUICK_START.md
    ├─► Install MATLAB R2017a+
    ├─► Test main_simulation.m dengan data contoh
    ├─► Baca paper Bozkurt 2022 & 2019
    └─► Pahami protokol DCM
    
    ▼

┌─────────────────────────────────────────────────────────────┐
│  FASE 2: PENGUMPULAN DATA (Minggu 3-4)                      │
└─────────────────────────────────────────────────────────────┘
    │
    ├─► Kumpulkan data 5 pasien dari RSAB Harapan Kita
    │   • Data demografis (usia, BSA, dll)
    │   • Data ekokardiografi (HR, tekanan, volume, diameter)
    │   • Data klinis (Ross class, mitral regurgitation, dll)
    │
    ├─► Input data ke patient_template.m
    │   • Buat pasien_001.m, pasien_002.m, dst
    │   • Validasi kelengkapan data
    │
    └─► Verifikasi dengan pembimbing
    
    ▼

┌─────────────────────────────────────────────────────────────┐
│  FASE 3: SIMULASI (Minggu 5-6)                              │
└─────────────────────────────────────────────────────────────┘
    │
    ├─► Untuk setiap pasien:
    │   │
    │   ├─► Load data pasien
    │   ├─► Jalankan main_simulation.m
    │   ├─► Optimisasi 23 parameter
    │   ├─► Simulasi 3 siklus jantung
    │   ├─► Validasi hasil (error < 10%)
    │   └─► Save hasil ke .mat file
    │
    ├─► Jalankan compare_healthy_vs_dcm.m
    │   • Lihat perbedaan healthy vs DCM
    │
    └─► Troubleshooting jika ada error
    
    ▼

┌─────────────────────────────────────────────────────────────┐
│  FASE 4: ANALISIS & LAPORAN (Minggu 7-8)                    │
└─────────────────────────────────────────────────────────────┘
    │
    ├─► Analisis parameter teroptimasi
    │   • Bandingkan antar pasien
    │   • Korelasi dengan severity DCM
    │
    ├─► Buat visualisasi untuk laporan
    │   • Pressure-volume loops
    │   • Time series hemodinamik
    │   • Tabel perbandingan
    │
    ├─► Interpretasi hasil klinis
    │   • EF, FS, SI, CO
    │   • Validasi dengan data klinis
    │
    └─► Tulis laporan skripsi
    
    ▼

┌─────────────────────────────────────────────────────────────┐
│  OUTPUT AKHIR                                               │
└─────────────────────────────────────────────────────────────┘
    │
    ├─► Laporan Skripsi
    ├─► Parameter teroptimasi untuk 5 pasien
    ├─► Grafik & visualisasi
    ├─► Validasi model (error < 10%)
    └─► Interpretasi klinis
```

---

## 📊 Alur Eksekusi Kode

```
main_simulation.m
    │
    ├─► [1] Load patient data
    │   └─── patient_template.m
    │
    ├─► [2] Initialize parameters
    │   └─── bounds dari Tabel 1 (Bozkurt 2022)
    │
    ├─► [3] Optimize parameters ──────────┐
    │   │                                  │
    │   └─► optimize_parameters.m         │
    │       │                              │
    │       ├─► Loop iterasi (10x)        │
    │       │   │                          │
    │       │   └─► simulate_and_evaluate()│
    │       │       │                      │
    │       │       └─► cardiovascular_model.m
    │       │           │                  │
    │       │           ├─► Ventrikel     │
    │       │           ├─► Atrium        │
    │       │           ├─► Katup         │
    │       │           └─► Sirkulasi     │
    │       │                              │
    │       ├─► Calculate objective function
    │       │   • fMAP = (MAPtarget - MAPmodel) / MAPtarget
    │       │   • fCO = (COtarget - COmodel) / COtarget
    │       │   • f = |fMAP + fCO|
    │       │                              │
    │       └─► Update bounds             │
    │           • Narrow down around best │
    │           • Repeat until converge   │
    │                                      │
    ├─► [4] Full simulation ◄─────────────┘
    │   │
    │   └─► cardiovascular_model.m (3 cycles)
    │       └─── ODE solver (ode15s)
    │
    ├─► [5] Validate results
    │   │
    │   └─► validate_results.m
    │       │
    │       ├─► Calculate clinical indicators
    │       │   • EF = (SV / EDV) × 100%
    │       │   • FS = ((EDD - ESD) / EDD) × 100%
    │       │   • SI = l / Dmid
    │       │   • CO, MAP, dll
    │       │
    │       └─► Compare with measured data
    │           • Error = |model - measured| / measured
    │
    ├─► [6] Visualization
    │   ├─── Pressure-Volume Loops
    │   └─── Hemodynamic Time Series
    │
    └─► [7] Save results
        └─── simulation_results.mat
```

---

## 🔑 File Kunci & Fungsinya

| File | Fungsi | Kapan Digunakan |
|------|--------|-----------------|
| `QUICK_START.md` | Panduan cepat memulai | **Pertama kali** |
| `PANDUAN_IMPLEMENTASI.md` | Teori lengkap | Butuh detail teori |
| `main_simulation.m` | Script utama simulasi | **Setiap simulasi pasien** |
| `compare_healthy_vs_dcm.m` | Perbandingan kondisi | Analisis perbedaan |
| `cardiovascular_model.m` | Model matematis | Dipanggil otomatis |
| `optimize_parameters.m` | Optimisasi | Dipanggil otomatis |
| `validate_results.m` | Validasi | Dipanggil otomatis |
| `patient_template.m` | Template data | **Untuk setiap pasien baru** |

---

## 📈 Parameter yang Dioptimasi (23 total)

### Ventrikel (8 parameter)
```
Ees,lv  ─┐
Ees,rv  ─┤ Elastance (kontraktilitas)
         │
V0,lv   ─┤ Zero-pressure volume
V0,rv   ─┘

Alv, Arv ─┐ Koefisien passive pressure
Blv, Brv ─┘ (diastolic function)
```

### Sirkulasi Sistemik (6 parameter)
```
Aorta:          Rao, Cao
Arteri sistemik: Ras, Cas
Vena sistemik:   Rvs, Cvs
```

### Sirkulasi Pulmonal (6 parameter)
```
Arteri pulmonal:  Rpo, Cpo
Arteriol pulmonal: Rap, Cap
Vena pulmonal:     Rvp, Cvp
```

### Lainnya (3 parameter)
```
Vblood ─── Volume darah sirkulasi
Klv ───┐
Krv ───┘ Koefisien geometri ventrikel
```

---

## 🎓 Tips Penggunaan

### Untuk Pemula:
1. ✅ Mulai dengan `QUICK_START.md`
2. ✅ Jalankan `main_simulation.m` dengan data contoh
3. ✅ Pahami output sebelum pakai data real

### Untuk Debugging:
1. 🔍 Cek komentar di dalam kode
2. 🔍 Lihat contoh di `compare_healthy_vs_dcm.m`
3. 🔍 Baca error message dengan teliti

### Untuk Analisis:
1. 📊 Bandingkan parameter antar pasien
2. 📊 Korelasi dengan severity DCM
3. 📊 Validasi dengan literatur

---

## ✅ Checklist Sebelum Mulai

- [ ] MATLAB R2017a+ terinstall
- [ ] Sudah baca `QUICK_START.md`
- [ ] Data pasien lengkap (sesuai protokol)
- [ ] Memahami parameter yang akan dioptimasi
- [ ] Siap untuk interpretasi hasil

---

**Semua file sudah siap! Selamat memulai penelitian! 🚀**

*Rufaida Kariemah - NPM 2206031561*
*Pembimbing: dr. Puspita Anggraini Katili, M.Sc., Ph.D.*
