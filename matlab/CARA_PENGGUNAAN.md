# 🔗 Koneksi Patient Template & Main Simulation

## ✅ SUDAH TERKONEKSI!

Sekarang `patient_template.m` dan `main_simulation.m` sudah terkoneksi dengan baik!

---

## 📖 Cara Menggunakan

### **Metode 1: Menggunakan File Pasien Terpisah (RECOMMENDED)**

#### **Untuk Pasien Pertama:**

1. **Copy template:**
   ```matlab
   % Di MATLAB Command Window:
   copyfile('data/patient_template.m', 'data/pasien_001.m')
   ```

2. **Edit `pasien_001.m`:**
   - Buka file `data/pasien_001.m`
   - Isi semua field yang ditandai `← ISI DARI ECHO`
   - Save file

3. **Jalankan simulasi:**
   ```matlab
   >> pasien_001           % Load data pasien ke workspace
   >> main_simulation      % Jalankan simulasi
   ```

#### **Untuk Pasien Berikutnya:**

Ulangi langkah yang sama dengan nama file berbeda:
```matlab
>> pasien_002
>> main_simulation

>> pasien_003
>> main_simulation
```

---

### **Metode 2: Edit Template Langsung (CEPAT)**

1. **Edit `patient_template.m`** dengan data pasien
2. **Jalankan:**
   ```matlab
   >> patient_template     % Load data
   >> main_simulation      % Simulasi
   ```

---

## 🎯 Bagaimana Koneksinya Bekerja?

### **Di `patient_template.m` atau `pasien_001.m`:**
```matlab
%% File ini membuat variabel 'patient_data' di workspace
patient_data = struct();
patient_data.name = 'Pasien 001';
patient_data.HR = 95;
% ... dst
```

### **Di `main_simulation.m`:**
```matlab
%% Script ini CEK apakah 'patient_data' ada di workspace
if exist('patient_data', 'var')
    % Jika ada → GUNAKAN data tersebut
    fprintf('✓ Menggunakan data pasien dari workspace\n');
else
    % Jika tidak ada → Gunakan data contoh
    fprintf('⚠ Menggunakan data contoh\n');
end
```

---

## 📋 Checklist Data yang Harus Diisi

### **WAJIB (dari Protokol DCM):**
- [ ] `HR` - Heart Rate (bpm)
- [ ] `Pao_sys` - Tekanan sistolik (mmHg)
- [ ] `Pao_dias` - Tekanan diastolik (mmHg)
- [ ] `Vlv_dias` - LVEDV (mL)
- [ ] `Vlv_sys` - LVESV (mL)
- [ ] `Vrv_dias` - RVEDV (mL)
- [ ] `Vrv_sys` - RVESV (mL)
- [ ] `Dlv_dias` - LVEDD (cm)
- [ ] `Dlv_sys` - LVESD (cm)
- [ ] `llv` - Panjang sumbu LV (cm)
- [ ] `lrv` - Panjang sumbu RV (cm)
- [ ] `CO` - Cardiac Output (L/min)
- [ ] `EF_measured` - Ejection Fraction (%)

### **OPSIONAL:**
- [ ] `Drv_dias` - RVEDD (jika tidak ada, biarkan `NaN`)
- [ ] `Drv_sys` - RVESD (jika tidak ada, biarkan `NaN`)

### **OTOMATIS DIHITUNG:**
- ✅ `BSA` - dari tinggi & berat
- ✅ `FS_measured` - dari LVEDD & LVESD
- ✅ `MAP` - dari tekanan sistolik & diastolik
- ✅ `llv_sys`, `llv_dias` - sama dengan `llv` (konstan)
- ✅ `lrv_sys`, `lrv_dias` - sama dengan `lrv` (konstan)

---

## 💡 Tips Penting

### **1. Panjang Sumbu (llv, lrv) - KONSTAN**

**Sesuai asumsi Bozkurt 2022:**
```matlab
% Jika echo memberikan llv = 6.8 cm
patient_data.llv = 6.8;
patient_data.llv_sys = 6.8;   // ← SAMA (konstan)
patient_data.llv_dias = 6.8;  // ← SAMA (konstan)
```

**Jangan** estimasi dengan persentase! Gunakan nilai konstan.

### **2. Diameter RV (Drv) - Opsional**

**Jika TIDAK ada di echo:**
```matlab
patient_data.Drv_dias = NaN;  // Biarkan NaN
patient_data.Drv_sys = NaN;   // Biarkan NaN
```

**Jika ADA di echo:**
```matlab
patient_data.Drv_dias = 2.8;  // Isi dengan nilai real
patient_data.Drv_sys = 2.0;   // Isi dengan nilai real
```

### **3. Fractional Shortening (FS)**

**Jika TIDAK ada di echo, hitung otomatis:**
```matlab
patient_data.FS_measured = ((patient_data.Dlv_dias - patient_data.Dlv_sys) / patient_data.Dlv_dias) * 100;
```

---

## 🔍 Cara Mengecek Data Sudah Benar

Setelah menjalankan file pasien, cek di workspace:

```matlab
>> pasien_001

% Cek apakah variabel 'patient_data' ada:
>> whos patient_data

% Lihat isi data:
>> patient_data

% Cek field tertentu:
>> patient_data.HR
>> patient_data.EF_measured
```

---

## 🎬 Contoh Workflow Lengkap

### **Simulasi 3 Pasien:**

```matlab
%% PASIEN 1
>> edit data/pasien_001.m      % Edit data
>> pasien_001                  % Load data
>> main_simulation             % Simulasi
>> movefile('data/simulation_results.mat', 'data/pasien_001_results.mat')

%% PASIEN 2
>> edit data/pasien_002.m      % Edit data
>> clear patient_data          % Hapus data pasien 1
>> pasien_002                  % Load data pasien 2
>> main_simulation             % Simulasi
>> movefile('data/simulation_results.mat', 'data/pasien_002_results.mat')

%% PASIEN 3
>> edit data/pasien_003.m
>> clear patient_data
>> pasien_003
>> main_simulation
>> movefile('data/simulation_results.mat', 'data/pasien_003_results.mat')
```

---

## ⚠️ Troubleshooting

### **Problem: "Menggunakan data contoh"**

**Penyebab:** Variabel `patient_data` tidak ada di workspace

**Solusi:**
1. Pastikan Anda sudah menjalankan file pasien (misal: `pasien_001`)
2. Cek dengan: `whos patient_data`
3. Jika tidak ada, jalankan lagi: `pasien_001`

### **Problem: Data tidak berubah**

**Penyebab:** Variabel lama masih di workspace

**Solusi:**
```matlab
>> clear patient_data    % Hapus data lama
>> pasien_002           % Load data baru
>> main_simulation      % Simulasi dengan data baru
```

### **Problem: Error "field not found"**

**Penyebab:** Ada field yang belum diisi

**Solusi:**
1. Cek semua field WAJIB sudah diisi
2. Pastikan tidak ada typo di nama field
3. Gunakan template sebagai referensi

---

## ✅ Kesimpulan

**Sekarang Anda bisa:**
1. ✅ Membuat file pasien terpisah (`pasien_001.m`, `pasien_002.m`, dll)
2. ✅ Mengisi data sesuai protokol DCM
3. ✅ Menjalankan simulasi dengan mudah
4. ✅ Menyimpan hasil untuk setiap pasien

**Workflow yang benar:**
```
Edit pasien_001.m → Jalankan pasien_001 → Jalankan main_simulation → Save hasil
```

---

**Semua sudah siap! Selamat mensimulasikan! 🚀**
