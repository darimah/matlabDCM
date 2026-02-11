# Simulasi Model Kardiovaskular DCM Pediatrik

Implementasi MATLAB untuk pemodelan jantung anak penderita Dilated Cardiomyopathy (DCM) berdasarkan model lumped parameter Bozkurt et al. (2022).

## 📁 Struktur Folder

```
matlab/
├── main_simulation.m              # Script utama - MULAI DI SINI
├── models/
│   └── cardiovascular_model.m     # Model sistem kardiovaskular lengkap
├── optimization/
│   └── optimize_parameters.m      # Algoritma optimisasi parameter
├── utils/
│   └── validate_results.m         # Validasi dan perhitungan indikator klinis
└── data/
    ├── patient_template.m         # Template input data pasien
    └── simulation_results.mat     # Output hasil simulasi (akan dibuat)
```

## 🚀 Cara Menggunakan

### Langkah 1: Persiapan Data Pasien

1. Buka file `data/patient_template.m`
2. Isi semua parameter dengan data dari ekokardiografi pasien Anda
3. Sesuaikan dengan protokol DCM yang sudah Anda buat
4. Save dengan nama baru (misal: `pasien_001.m`)

**Parameter yang WAJIB diisi:**
- Data demografis: usia, jenis kelamin, BSA
- Heart Rate (HR)
- Tekanan aorta (sistolik & diastolik)
- Volume ventrikel (LVEDV, LVESV, RVEDV, RVESV)
- Diameter ventrikel (LVEDD, LVESD)
- Panjang sumbu panjang ventrikel (llv, lrv)
- Cardiac Output (CO)

### Langkah 2: Jalankan Simulasi

1. Buka MATLAB
2. Set working directory ke folder `matlab/`
3. Jalankan: `main_simulation.m`

```matlab
>> cd('c:\Users\rufai\OneDrive\Documents\Skripsi\Anti\matlab')
>> main_simulation
```

### Langkah 3: Lihat Hasil

Script akan otomatis:
- ✅ Mengoptimasi 23 parameter model
- ✅ Mensimulasi 3 siklus jantung
- ✅ Menghitung indikator klinis (EF, FS, SI)
- ✅ Membandingkan dengan data klinis
- ✅ Membuat visualisasi (pressure-volume loops, time series)
- ✅ Menyimpan hasil ke `data/simulation_results.mat`

## 📊 Output yang Dihasilkan

### 1. Validasi Numerik
```
Parameter          Model    Measured   Error
----------------------------------------
Pao sys (mmHg)    106.0    109.0      2.8%
Pao dias (mmHg)    57.0     60.0      5.0%
CO (L/min)          5.15     5.30     2.8%
LVEDV (mL)         98.0    100.0      2.0%
LVESV (mL)         48.0     48.0      0.0%
EF (%)             51.0     52.0      1.9%
```

### 2. Grafik Visualisasi

**Figure 1: Pressure-Volume Loops**
- Loop ventrikel kiri & kanan
- Menunjukkan fungsi kontraktil jantung

**Figure 2: Hemodynamic Time Series**
- Tekanan ventrikel & aorta vs waktu
- Volume ventrikel & atrium vs waktu
- Diameter ventrikel vs waktu

### 3. Parameter Teroptimasi

File `simulation_results.mat` berisi:
- `patient_data` - Data input pasien
- `optimized_params` - 23 parameter teroptimasi
- `validation` - Hasil validasi lengkap
- `time` - Vektor waktu simulasi
- `state` - State variables (volume, tekanan, dll)

## 🔧 Troubleshooting

### Error: "Optimization did not converge"
**Solusi:**
- Periksa apakah data input masuk akal (tidak ada nilai ekstrem)
- Coba perkecil bounds parameter di `main_simulation.m`
- Tambah `max_simulations` di `optimize_parameters.m`

### Error: "ODE solver failed"
**Solusi:**
- Pastikan semua satuan benar (mL, mmHg, cm, bpm)
- Cek initial conditions di `main_simulation.m` baris 125-132
- Gunakan toleransi lebih besar: `'RelTol', 1e-2`

### Hasil tidak realistis
**Solusi:**
- Validasi data input pasien
- Bandingkan dengan nilai normal pediatrik
- Konsultasi dengan pembimbing

## 📚 Referensi Model

### Persamaan Utama

**Tekanan Ventrikel Kiri:**
```
plv = Ees,lv × (Vlv - V0,lv) × fact,lv(t) + A × (e^(B×Vlv) - 1)
      └─────── aktif ──────┘                └───── pasif ─────┘
```

**Volume Ventrikel:**
```
Vlv = (2/3) × π × Klv × rlv² × llv
```

**Fungsi Aktivasi:**
```
         ⎧ (1 - cos(πt/T1))/2           , 0 ≤ t < T1
fact(t) = ⎨ (1 + cos(π(t-T1)/(T2-T1)))/2, T1 ≤ t < T2
         ⎩ 0                            , T2 ≤ t < T
```

### Parameter yang Dioptimasi (23 total)

**Ventrikel (8):**
- Ees,lv, Ees,rv - Elastance (kontraktilitas)
- V0,lv, V0,rv - Zero-pressure volume
- Alv, Arv, Blv, Brv - Koefisien passive pressure

**Sirkulasi Sistemik (6):**
- Rao, Cao - Aorta
- Ras, Cas - Arteri sistemik
- Rvs, Cvs - Vena sistemik

**Sirkulasi Pulmonal (6):**
- Rpo, Cpo - Arteri pulmonal
- Rap, Cap - Arteriol pulmonal
- Rvp, Cvp - Vena pulmonal

**Lainnya (3):**
- Vblood - Volume darah sirkulasi
- Klv, Krv - Koefisien geometri ventrikel

## 🎯 Interpretasi Hasil untuk DCM

### Indikator DCM:

**Ejection Fraction (EF):**
- Normal: > 55%
- Mild DCM: 45-55%
- Severe DCM: < 45% (atau < 30%)

**Fractional Shortening (FS):**
- Normal: > 28%
- DCM: < 25%

**Sphericity Index (SI):**
- Normal: > 2.0 (lebih ellipsoidal)
- DCM: < 1.5 (lebih spherical/bulat)

**Volume:**
- DCM: LVEDV meningkat (z-score > 2)
- DCM: LVEDD meningkat

### Modifikasi untuk Simulasi DCM:

Jika ingin mensimulasikan kondisi DCM yang lebih parah, ubah bounds parameter:

```matlab
% Di main_simulation.m, ubah:
bounds.Ees_lv = [0.7, 2.2];  % ↓ Kontraktilitas menurun
bounds.Alv = [0.65, 1.2];    % ↓ Diastolic dysfunction
bounds.Ras = [0.9, 1.6];     % ↑ Resistensi sistemik meningkat
bounds.Klv = [0.95, 2.0];    % ↑ Remodeling ventrikel
```

## 📝 Catatan Penting

1. **Satuan yang Digunakan:**
   - Volume: mL
   - Tekanan: mmHg
   - Waktu: detik
   - Panjang: cm
   - Flow rate: mL/s
   - Cardiac output: L/min

2. **Asumsi Model:**
   - Panjang sumbu panjang ventrikel konstan
   - Katup jantung ideal (tidak ada regurgitasi)
   - Geometri ventrikel ellipsoidal

3. **Validasi:**
   - Target error < 10% (Bozkurt 2022)
   - Bandingkan dengan data klinis
   - Konsultasi dengan klinisi

## 🆘 Bantuan Lebih Lanjut

Jika ada pertanyaan atau masalah:
1. Baca file `PANDUAN_IMPLEMENTASI.md` untuk penjelasan detail
2. Lihat komentar di dalam kode
3. Konsultasi dengan pembimbing
4. Referensi paper Bozkurt 2022 & 2019

## ✅ Checklist Sebelum Mulai

- [ ] MATLAB R2017a atau lebih baru terinstall
- [ ] Data pasien sudah lengkap dari ekokardiografi
- [ ] Sudah membaca `PANDUAN_IMPLEMENTASI.md`
- [ ] Memahami parameter yang akan dioptimasi
- [ ] Siap untuk interpretasi hasil

---

**Good luck dengan penelitian skripsi Anda! 🎓**

*Rufaida Kariemah - NPM 2206031561*
*Pembimbing: dr. Puspita Anggraini Katili, M.Sc., Ph.D.*
