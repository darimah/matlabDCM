# 🎓 Quick Start Guide - Simulasi Model Kardiovaskular DCM

## Selamat Datang!

Halo Rufaida! Ini adalah panduan cepat untuk memulai simulasi model kardiovaskular DCM pediatrik untuk skripsi Anda.

## 📚 File-File yang Sudah Dibuat

### 1. Dokumentasi
- ✅ `PANDUAN_IMPLEMENTASI.md` - Panduan lengkap teori dan implementasi
- ✅ `matlab/README.md` - Instruksi penggunaan kode MATLAB

### 2. Kode MATLAB
- ✅ `matlab/main_simulation.m` - **Script utama** (mulai di sini!)
- ✅ `matlab/compare_healthy_vs_dcm.m` - Perbandingan healthy vs DCM
- ✅ `matlab/models/cardiovascular_model.m` - Model sistem kardiovaskular
- ✅ `matlab/optimization/optimize_parameters.m` - Optimisasi parameter
- ✅ `matlab/utils/validate_results.m` - Validasi hasil
- ✅ `matlab/data/patient_template.m` - Template input data pasien

## 🚀 Langkah Pertama (5 Menit)

### Step 1: Buka MATLAB
```matlab
cd('c:\Users\rufai\OneDrive\Documents\Skripsi\Anti\matlab')
```

### Step 2: Test dengan Data Contoh
Jalankan simulasi dengan data contoh yang sudah ada:
```matlab
main_simulation
```

Ini akan:
- ✅ Mengoptimasi parameter untuk pasien contoh
- ✅ Mensimulasikan 3 siklus jantung
- ✅ Membuat grafik pressure-volume loops
- ✅ Menampilkan hasil validasi

**Waktu eksekusi:** ~2-5 menit (tergantung komputer)

### Step 3: Lihat Perbandingan Healthy vs DCM
```matlab
compare_healthy_vs_dcm
```

Ini akan menunjukkan perbedaan antara jantung sehat dan DCM.

## 📝 Langkah Selanjutnya (Dengan Data Real)

### 1. Siapkan Data Pasien Anda

Buka `matlab/data/patient_template.m` dan isi dengan data dari protokol DCM:

```matlab
% Data dari Ekokardiografi
patient_data.HR = 101;           % Heart rate (bpm)
patient_data.Pao_sys = 109;      % Tekanan sistolik (mmHg)
patient_data.Pao_dias = 60;      % Tekanan diastolik (mmHg)
patient_data.Vlv_dias = 100;     % LVEDV (mL)
patient_data.Vlv_sys = 48;       % LVESV (mL)
patient_data.CO = 5.3;           % Cardiac output (L/min)
% ... dst
```

### 2. Jalankan Simulasi

Setelah data pasien siap, jalankan `main_simulation.m` lagi.

### 3. Interpretasi Hasil

Lihat output validasi:
```
Parameter          Model    Measured   Error
----------------------------------------
Pao sys (mmHg)    106.0    109.0      2.8%   ✅ < 10% = BAGUS
Pao dias (mmHg)    57.0     60.0      5.0%   ✅ < 10% = BAGUS
CO (L/min)          5.15     5.30     2.8%   ✅ < 10% = BAGUS
EF (%)             51.0     52.0      1.9%   ✅ < 10% = BAGUS
```

**Target:** Error < 10% (berdasarkan Bozkurt 2022)

## 🎯 Untuk Skripsi Anda

### Yang Perlu Anda Lakukan:

1. **Kumpulkan Data 5 Pasien** (sesuai protokol DCM)
   - Data demografis
   - Data ekokardiografi lengkap
   - Data klinis (Ross class, mitral regurgitation, dll)

2. **Jalankan Simulasi untuk Setiap Pasien**
   - Buat file `pasien_001.m`, `pasien_002.m`, dst
   - Jalankan `main_simulation.m` untuk masing-masing
   - Simpan hasil ke folder terpisah

3. **Analisis Hasil**
   - Bandingkan parameter teroptimasi antar pasien
   - Korelasi dengan severity DCM (Ross class, EF, dll)
   - Buat tabel perbandingan

4. **Visualisasi untuk Laporan**
   - Pressure-volume loops
   - Time series hemodinamik
   - Perbandingan healthy vs DCM
   - Grafik korelasi parameter

## 📊 Output untuk Laporan Skripsi

Dari simulasi ini, Anda akan mendapatkan:

### 1. Tabel Validasi
| Parameter | Pasien 1 | Pasien 2 | Pasien 3 | ... |
|-----------|----------|----------|----------|-----|
| EF (%)    | 52       | 28       | 39       | ... |
| CO (L/min)| 5.3      | 2.6      | 2.6      | ... |
| Error (%) | 1.9      | 3.2      | 2.1      | ... |

### 2. Parameter Teroptimasi
| Parameter  | Healthy | Mild DCM | Severe DCM |
|------------|---------|----------|------------|
| Ees,lv     | 2.5     | 1.3      | 0.9        |
| V0,lv      | 7.5     | 16       | 25         |
| ...        | ...     | ...      | ...        |

### 3. Grafik
- Pressure-Volume Loops (Figure 1)
- Hemodynamic Time Series (Figure 2)
- Perbandingan Healthy vs DCM

## ⚠️ Troubleshooting Cepat

### "Optimization did not converge"
➡️ **Solusi:** Periksa data input, pastikan tidak ada nilai ekstrem

### "ODE solver failed"
➡️ **Solusi:** Cek satuan (mL, mmHg, cm), validasi initial conditions

### Hasil tidak masuk akal
➡️ **Solusi:** Bandingkan dengan nilai normal pediatrik, konsultasi pembimbing

## 📖 Baca Lebih Lanjut

- **Teori lengkap:** `PANDUAN_IMPLEMENTASI.md`
- **Cara pakai:** `matlab/README.md`
- **Paper utama:** `bozkurt2022.md`
- **Paper referensi:** `bozkurt2019.md`

## 💡 Tips untuk Sukses

1. **Mulai dengan data contoh** - Pahami dulu cara kerjanya
2. **Validasi setiap langkah** - Jangan langsung ke semua pasien
3. **Dokumentasi lengkap** - Catat semua parameter dan hasil
4. **Konsultasi rutin** - Diskusi hasil dengan pembimbing
5. **Backup data** - Simpan semua hasil simulasi

## 🆘 Butuh Bantuan?

Jika ada yang tidak jelas:
1. Baca komentar di dalam kode
2. Lihat contoh di `compare_healthy_vs_dcm.m`
3. Konsultasi dengan pembimbing
4. Review paper Bozkurt 2022 & 2019

## ✅ Checklist Progres

### Minggu 1-2: Setup & Pemahaman
- [ ] Install MATLAB
- [ ] Test `main_simulation.m` dengan data contoh
- [ ] Pahami output dan grafik
- [ ] Baca paper Bozkurt 2022 & 2019

### Minggu 3-4: Pengumpulan Data
- [ ] Kumpulkan data 5 pasien dari RSAB Harapan Kita
- [ ] Validasi kelengkapan data sesuai protokol
- [ ] Input data ke template MATLAB

### Minggu 5-6: Simulasi
- [ ] Jalankan simulasi untuk semua pasien
- [ ] Validasi hasil (error < 10%)
- [ ] Troubleshooting jika ada masalah

### Minggu 7-8: Analisis & Laporan
- [ ] Analisis parameter teroptimasi
- [ ] Buat tabel dan grafik untuk laporan
- [ ] Interpretasi hasil klinis
- [ ] Tulis draft skripsi

---

## 🎉 Selamat Memulai!

Semua file sudah siap. Anda tinggal:
1. Buka MATLAB
2. Jalankan `main_simulation.m`
3. Lihat hasilnya!

**Good luck dengan penelitian Anda! 🚀**

---

*Dibuat untuk: Rufaida Kariemah (NPM 2206031561)*
*Pembimbing: dr. Puspita Anggraini Katili, M.Sc., Ph.D.*
*Tanggal: 11 Februari 2026*
