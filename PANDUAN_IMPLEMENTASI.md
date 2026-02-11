# Panduan Implementasi Model Kardiovaskular DCM Pediatrik di MATLAB

## 📋 Ringkasan Penelitian

**Tujuan**: Mensimulasikan fungsi kardiovaskular anak penderita DCM menggunakan model lumped parameter

**Model Utama**: Bozkurt et al. (2022) - Patient-Specific Modelling and Parameter Optimisation to Simulate Dilated Cardiomyopathy in Children

**Referensi Tambahan**: Bozkurt (2019) - Mathematical modeling of cardiac function to evaluate clinical cases in adults and children

**Data Input**: Berdasarkan protokol DCM (ekokardiografi + data klinis)

---

## 🎯 Tahap Implementasi

### **TAHAP 1: Persiapan dan Pemahaman Model**

#### 1.1 Komponen Model Kardiovaskular
Model terdiri dari:
- **4 ruang jantung**: Atrium kiri/kanan, Ventrikel kiri/kanan
- **4 katup jantung**: Mitral, Aorta, Trikuspid, Pulmonal
- **Sirkulasi sistemik**: Aorta, arteri sistemik, vena sistemik
- **Sirkulasi pulmonal**: Arteri pulmonal, arteriol pulmonal, vena pulmonal

#### 1.2 Parameter yang Dibutuhkan dari Protokol Anda

**Parameter Demografis:**
- Usia (AGE)
- Jenis Kelamin (SEX)
- Body Surface Area (BSA)

**Parameter Hemodinamik (dari Ekokardiografi):**
- `HR` - Heart Rate (bpm)
- `Pao,sys` - Tekanan sistolik aorta (mmHg)
- `Pao,dias` - Tekanan diastolik aorta (mmHg)
- `Vlv,dias` (LVEDV) - Volume end-diastolic ventrikel kiri (mL)
- `Vlv,sys` (LVESV) - Volume end-systolic ventrikel kiri (mL)
- `Vrv,dias` (RVEDV) - Volume end-diastolic ventrikel kanan (mL)
- `Vrv,sys` (RVESV) - Volume end-systolic ventrikel kanan (mL)
- `Dlv,dias` (LVEDD) - Diameter end-diastolic ventrikel kiri (cm)
- `Dlv,sys` (LVESD) - Diameter end-systolic ventrikel kiri (cm)
- `llv` - Panjang sumbu panjang ventrikel kiri (cm)
- `lrv` - Panjang sumbu panjang ventrikel kanan (cm)
- `CO` - Cardiac Output (L/min)

**Parameter Validasi:**
- `FS` - Fractional Shortening (%)
- `EFlv` - Ejection Fraction ventrikel kiri (%)

---

### **TAHAP 2: Setup MATLAB**

#### 2.1 Struktur Folder
```
Anti/
├── PANDUAN_IMPLEMENTASI.md (file ini)
├── matlab/
│   ├── main_simulation.m          % Script utama
│   ├── models/
│   │   ├── cardiovascular_model.m % Model sistem kardiovaskular
│   │   ├── ventricle_pressure.m   % Model tekanan ventrikel
│   │   ├── atrium_pressure.m      % Model tekanan atrium
│   │   └── valve_flow.m           % Model aliran katup
│   ├── optimization/
│   │   ├── optimize_parameters.m  % Optimisasi parameter
│   │   └── objective_function.m   % Fungsi objektif
│   ├── utils/
│   │   ├── load_patient_data.m    % Load data pasien
│   │   ├── calculate_MAP.m        % Hitung Mean Arterial Pressure
│   │   └── validate_results.m     % Validasi hasil
│   └── data/
│       └── patient_data.mat       % Data pasien
```

#### 2.2 Software Requirements
- MATLAB R2017a atau lebih baru
- Simulink (opsional, untuk visualisasi)
- Optimization Toolbox

---

### **TAHAP 3: Implementasi Model Matematis**

#### 3.1 Persamaan Dasar Ventrikel Kiri

**Tekanan Ventrikel Kiri (plv):**
```
plv = plv,a + plv,p
```

**Komponen Aktif (plv,a):**
```
plv,a = Ees,lv × (Vlv - Vlv,0) × fact,lv(t)
```

**Komponen Pasif (plv,p):**
```
plv,p = A × (e^(B×Vlv) - 1)
```

**Volume Ventrikel Kiri (Vlv):**
```
Vlv = (2/3) × π × Klv × rlv² × llv
```

**Parameter yang Perlu Dioptimasi:**
- `Ees,lv` - End-systolic elastance ventrikel kiri
- `Vlv,0` - Zero-pressure volume ventrikel kiri
- `A, B` - Koefisien passive pressure
- `Klv` - Koefisien geometri ventrikel kiri

#### 3.2 Fungsi Aktivasi (fact,lv)

```matlab
function f = activation_function(t, T1, T2, T)
    % T1 = 0.33 × T (akhir sistol)
    % T2 = 0.45 × T (akhir relaksasi)
    % T = durasi siklus jantung (60/HR)
    
    if t < T1
        f = (1 - cos(t/T1 * pi)) / 2;
    elseif t < T2
        f = (1 + cos((t-T1)/(T2-T1) * pi)) / 2;
    else
        f = 0;
    end
end
```

#### 3.3 Sirkulasi Sistemik

**Aorta:**
```
dpao/dt = (Qav - Qao) / Cao
dQao/dt = (pao - pas - Rao×Qao) / Lao
```

**Parameter:**
- `Cao` - Compliance aorta
- `Rao` - Resistance aorta
- `Lao` - Inertance aorta

---

### **TAHAP 4: Strategi Optimisasi Parameter**

#### 4.1 Metode: Direct Search (Pattern Search)

Berdasarkan paper Bozkurt 2022, menggunakan **direct search method** dengan iterasi bertahap.

#### 4.2 Fungsi Objektif

```
f(x) = |fMAP(x) + fCO(x)|

fMAP(x) = (MAPpt - MAPm(x)) / MAPpt
fCO(x) = (COpt - COm(x)) / COpt
```

**Kriteria Konvergensi:**
- f(x) ≤ 0.05
- -0.1 ≤ fMAP(x) ≤ 0.1
- -0.1 ≤ fCO(x) ≤ 0.1

#### 4.3 Parameter yang Dioptimasi

**Vektor x (23 parameter):**
1. `Ees,lv` - Elastance ventrikel kiri
2. `Ees,rv` - Elastance ventrikel kanan
3. `V0,lv` - Zero-pressure volume kiri
4. `V0,rv` - Zero-pressure volume kanan
5. `Alv, Arv` - Koefisien passive pressure
6. `Blv, Brv` - Koefisien passive pressure
7. `Rao, Cao` - Resistance & compliance aorta
8. `Ras, Cas` - Resistance & compliance arteri sistemik
9. `Rvs, Cvs` - Resistance & compliance vena sistemik
10. `Rpo, Cpo` - Resistance & compliance arteri pulmonal
11. `Rap, Cap` - Resistance & compliance arteriol pulmonal
12. `Rvp, Cvp` - Resistance & compliance vena pulmonal
13. `Vblood` - Volume darah sirkulasi

**Vektor k (2 parameter untuk diameter):**
1. `Klv` - Koefisien geometri ventrikel kiri
2. `Krv` - Koefisien geometri ventrikel kanan

---

### **TAHAP 5: Workflow Implementasi**

```
┌─────────────────────────────────────┐
│ 1. Input Data Pasien                │
│    - Dari protokol DCM              │
│    - Format: patient_data.mat       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 2. Inisialisasi Parameter           │
│    - Bounds (upper/lower)           │
│    - Initial guess dari Tabel 1     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 3. Optimisasi Parameter (x)         │
│    - Iterasi 10x per simulasi       │
│    - Update bounds                  │
│    - Cek konvergensi                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 4. Optimisasi Diameter (k)          │
│    - Setelah volume teroptimasi     │
│    - Iterasi 10x per simulasi       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 5. Simulasi Model Lengkap           │
│    - Solve ODE (ode15s)             │
│    - 2-3 siklus jantung             │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ 6. Validasi & Visualisasi           │
│    - Bandingkan dengan data klinis  │
│    - Plot pressure-volume loops     │
│    - Hitung EF, FS, dll             │
└─────────────────────────────────────┘
```

---

### **TAHAP 6: Validasi Model**

#### 6.1 Parameter yang Divalidasi

**Hemodinamik:**
- Tekanan aorta sistolik/diastolik
- Volume ventrikel end-systolic/end-diastolic
- Cardiac output
- Diameter ventrikel

**Kriteria Keberhasilan:**
- Perbedaan < 10% dari data klinis (Bozkurt 2022)

#### 6.2 Indikator Klinis

**Ejection Fraction (EF):**
```
EF = (SV / EDV) × 100%
```

**Fractional Shortening (FS):**
```
FS = ((EDD - ESD) / EDD) × 100%
```

**Sphericity Index (SI):**
```
SI = l / Dmid
```

---

### **TAHAP 7: Analisis DCM**

#### 7.1 Modifikasi untuk DCM

Berdasarkan Bozkurt 2022, untuk simulasi DCM:

**Parameter yang Diubah:**
1. ↓ `Ees,lv` - Penurunan kontraktilitas (systolic dysfunction)
2. ↓ `A` - Penurunan koefisien passive (diastolic dysfunction)
3. ↑ `Ras` - Peningkatan resistensi sistemik
4. ↑ `Klv` - Remodeling & enlargement ventrikel

**Nilai Referensi (dari Tabel 1 Bozkurt 2022):**
- Healthy child: `Ees,lv = 3.5 mmHg/mL`
- DCM child: `Ees,lv = 1.3 mmHg/mL`

#### 7.2 Interpretasi Hasil

**Indikator DCM:**
- EF < 45% (severe < 30%)
- LVEDD meningkat (z-score > 2)
- SI menurun (lebih spherical)
- FS menurun

---

## 📊 Deliverables

### Output yang Diharapkan:

1. **Parameter teroptimasi** untuk setiap pasien
2. **Grafik pressure-volume loops**
3. **Time series**: tekanan, volume, diameter
4. **Tabel validasi**: perbandingan model vs klinis
5. **Indikator klinis**: EF, FS, SI, CO

---

## 🔧 Troubleshooting

### Masalah Umum:

**1. Optimisasi tidak konvergen**
- Perkecil bounds parameter
- Tambah jumlah iterasi
- Cek initial guess

**2. Hasil tidak realistis**
- Validasi input data
- Cek satuan (mL, mmHg, cm)
- Periksa parameter bounds

**3. ODE solver error**
- Gunakan ode15s (stiff solver)
- Kurangi max step size
- Tingkatkan toleransi

---

## 📚 Referensi Kunci

### Dari Bozkurt 2022:
- **Tabel 1**: Initial bounds parameter (halaman 717)
- **Tabel 2**: Parameter tetap (halaman 717)
- **Tabel 3**: Hasil validasi (halaman 718)
- **Persamaan 1-24**: Model matematis (halaman 713-717)

### Dari Bozkurt 2019:
- **Tabel 1 & 3**: Parameter atria & ventrikel (halaman 5-6)
- **Tabel 2 & 4**: Parameter sirkulasi (halaman 5-6)
- **Persamaan 1-19**: Model geometri (halaman 3-6)

---

## ✅ Checklist Implementasi

- [ ] Setup folder struktur MATLAB
- [ ] Buat fungsi model kardiovaskular dasar
- [ ] Implementasi fungsi aktivasi
- [ ] Buat fungsi objektif optimisasi
- [ ] Implementasi algoritma optimisasi
- [ ] Load dan validasi data pasien
- [ ] Test dengan 1 pasien
- [ ] Validasi hasil dengan data klinis
- [ ] Dokumentasi kode
- [ ] Visualisasi hasil

---

## 🚀 Next Steps

1. **Baca file template kode** yang akan saya buat
2. **Siapkan data pasien** dalam format yang sesuai
3. **Mulai dari model sederhana** (1 ventrikel) lalu expand
4. **Test incremental** - jangan langsung full model
5. **Konsultasi pembimbing** untuk validasi pendekatan

---

**Catatan**: Panduan ini akan dilengkapi dengan kode MATLAB yang siap pakai. Silakan lanjut ke file-file berikutnya untuk implementasi detail.
