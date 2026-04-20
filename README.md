

<h1 align="center" style="color:#2e8b57;">PROJEK AKHIR PEMROGRAMAN BERBASIS APLIKASI</h1>

<img width="1280" height="1280" alt="image" src="https://github.com/user-attachments/assets/6583026c-8c8f-4f64-a070-5895729d92c8" />

<h2 align="center" style="color:#4CAF50;">APLIKASI SMARTNOTA KJ</h2>

## 📚 Daftar Isi
- [👤 Profil Anggota](#-profil-anggota)
- [📝 Deskripsi Program](#-deskripsi-program)
- [⚙️ Fitur Program](#️-fitur-program)
- [📂 Struktur Folder / Package](#-struktur-folder--package)
  
## 👤 Profil Anggota
|   Muhammad Nur Alfian   |    Nanda Pesona Putri   |  Jabbar Hafizh Abdillah  |   Keisya Siti Nafisa Andini   |  Chaesarrio Taufiqul Hakim  |
|-------------------------|-------------------------|--------------------------|------------------------|-----------------------------|
| **NIM:** 2409116105 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116101 <br> **Kelas:** SI C '24 <br>  | **NIM:** 2409116116 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116115 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116096 <br> **Kelas:** SI C '24 <br> |

## Deskripsi Program
SmartNota KJ merupakan aplikasi berbasis digital yang dirancang untuk membantu proses pencatatan, pengelolaan, dan pengarsipan nota secara terintegrasi. Aplikasi ini memungkinkan pengguna untuk menyimpan data nota dalam bentuk digital, baik melalui input manual maupun unggahan gambar, sehingga data menjadi lebih rapi, mudah diakses, dan tidak mudah hilang. SmartNota KJ mendukung kolaborasi antar admin di berbagai cabang dalam satu sistem terpusat, sehingga seluruh data nota dapat dipantau secara real-time dan lebih efisien. Dengan adanya fitur pencarian, filter, dan pengelolaan data, aplikasi ini membantu meningkatkan efisiensi kerja serta meminimalkan kesalahan dalam pencatatan transaksi. 

---

### ⚙️ 1. Teknologi & Package

| Package              | Versi    | Kegunaan                                        |
| -------------------- | -------- | ----------------------------------------------- |
| `supabase_flutter`   | ^2.3.4   | Database, Authentication, Storage, dan Realtime |
| `flutter_dotenv`     | ^5.1.0   | Menyimpan URL & API Key di file `.env`          |
| `provider`           | ^6.1.2   | State management aplikasi                       |
| `google_fonts`       | ^6.2.1   | Kustomisasi font pada UI                        |
| `fl_chart`           | ^0.68.0  | Menampilkan grafik dan visualisasi data nota    |
| `http`               | ^1.2.0   | Melakukan HTTP request ke server                |
| `intl`               | ^0.19.0  | Format tanggal dan waktu                        |
| `uuid`               | ^4.4.0   | Generate ID unik untuk setiap nota              |
| `image_picker`       | ^0.8.7+4 | Mengambil foto dari kamera atau galeri          |
| `gal`                | ^2.3.0   | Menyimpan gambar ke galeri perangkat            |
| `pdf`                | ^3.10.8  | Membuat file PDF dari data nota                 |
| `printing`           | ^5.12.0  | Cetak dan ekspor dokumen PDF                    |
| `permission_handler` | ^11.3.1  | Mengelola izin akses perangkat                  |
| `device_info_plus`   | ^10.1.0  | Mengambil informasi perangkat pengguna          |
| `path_provider`      | ^2.1.4   | Mengakses direktori penyimpanan lokal           |
| `open_filex`         | ^4.3.4   | Membuka file (PDF, gambar) dari aplikasi        |
| `cupertino_icons`    | ^1.0.6   | Ikon bergaya iOS                                |

---

### 2. Fungsi Utama  
Fungsi utama SmartNota KJ adalah mengarsipkan dan mengelola nota secara digital agar data lebih terorganisir, mudah dicari, dan tidak mudah hilang, dengan cara memungkinkan pengguna menyimpan nota dengan foto atau input manual, serta mengaksesnya kembali kapan saja dengan lebih praktis. SmartNota KJ juga menghubungkan admin admin di berbagai cabang di satu aplikasi sehingga semua nota dapat disimpan dengan lebih efisie.

---

### 👥 3. Peran Utama dalam Sistem  
- **Supervisor**: Menginput hasil panen dan menerima permintaan pesanan dari distributor.  
- **Admin**: Melihat data hasil panen petani dan membuat permintaan.  

## Fitur Program

Aplikasi **SmartNota KJ** memiliki beberapa fitur utama yang dibedakan berdasarkan peran pengguna: **Supervisor** dan **Admin**. 

### 1. Fitur untuk Admin
Admin memiliki kontrol penuh terhadap sistem dan pengguna dalam aplikasi AgriChain. Berikut fitur-fitur utama yang dapat dilakukan oleh admin:

**Kelola Akun Admin**
Admin dapat menambah, mengedit, dan menghapus data akun pengguna yang memiliki akses ke sistem SmartNota KJ. Informasi yang dikelola meliputi nama, nomor telepon, serta status akun (aktif/nonaktif) untuk memastikan kontrol akses yang teratur.
Upload Nota
Admin dapat mengunggah (upload) data nota transaksi dari berbagai toko yang tersedia di sistem. Data yang diinput mencakup informasi toko, tanggal transaksi, serta detail nota lainnya untuk keperluan pencatatan dan monitoring.
Edit & Hapus Nota
Admin dapat melakukan perubahan (edit) maupun penghapusan data nota apabila terdapat kesalahan input atau data sudah tidak diperlukan, sehingga menjaga keakuratan database.
Download Nota
Admin dapat mengunduh data nota yang tersimpan dalam sistem untuk keperluan arsip, pelaporan, atau analisis lebih lanjut.
Filter Chip dan Rentang Tanggal
Admin dapat memfilter data nota berdasarkan kategori tertentu (seperti toko) serta rentang tanggal tertentu, sehingga memudahkan pencarian dan analisis data transaksi.
Arsip Nota
Admin dapat mengarsipkan nota yang sudah tidak aktif atau sudah selesai diproses. Fitur ini membantu dalam pengelompokan data antara nota aktif dan arsip agar tampilan tetap rapi dan terorganisir. 
  
---

###  2. Fitur untuk Admin
- **Upload Nota**  
  Petani dapat menambahkan data hasil panen seperti luas lahan, nama sawah, dan lokasi.
  
- **Download Nota**  
  Petani dapat melihat daftar permintaan dari distributor dan menerima permintaan tersebut.
  
- **Filter Rentang Tanggal**  
  Menampilkan informasi panen dan permintaan dalam satu tampilan yang mudah dipahami.  

---

## 📂 Struktur Folder / Package

## 📁 Struktur Folder

```bash
lib/
├── constants/
│   └── store_options.dart
│
├── models/
│   ├── nota_model.dart
│   └── user_model.dart
│
├── pages/
│   ├── admin_dashboard.dart
│   ├── admin_main.dart
│   ├── admin_nota_page.dart
│   ├── login_page.dart
│   ├── nota_detail_page.dart
│   ├── nota_form_page.dart
│   ├── nota_list_page.dart
│   ├── rekap_page.dart
│   ├── splash_page.dart
│   ├── supervisor_dashboard.dart
│   ├── supervisor_main.dart
│   └── user_management_page.dart
│
├── providers/
│   ├── auth_provider.dart
│   └── nota_provider.dart
│
├── services/
│   ├── auth_service.dart
│   └── nota_service.dart
│
├── themes/
│   └── app_theme.dart
│
├── utils/
│   └── format_utils.dart
│
├── widgets/
│   └── app_widgets.dart
│
└── main.dart
```

## Widget yang Digunakan
# SmartNota KJ

> Aplikasi Flutter untuk manajemen arsip foto nota berbasis cloud

---

## Deskripsi Aplikasi

**SmartNota KJ** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu tim toko dalam mengelola dan mengarsipkan nota secara digital. Setiap nota dapat dilengkapi dengan foto bukti transaksi yang tersimpan di cloud (Supabase), sehingga data nota mudah diakses kapan saja dan di mana saja.

Aplikasi ini mendukung dua peran pengguna: **Admin** yang bertugas mencatat dan mengelola nota milik mereka sendiri, serta **Supervisor** yang dapat memantau seluruh nota dari semua admin, mengelola akun pengguna, dan melihat rekap data secara keseluruhan.

---

## Fitur Aplikasi

### Autentikasi
- Login dan logout menggunakan email & password melalui Supabase Auth.
- Sistem dua peran: **Admin** dan **Supervisor** dengan tampilan dashboard yang berbeda.
- Splash screen dengan animasi fade & scale serta pengecekan sesi otomatis.

### Dashboard Admin
- Ringkasan statistik: total nota tercatat, jumlah nota yang ditambahkan hari ini.
- Daftar nota terbaru milik admin yang sedang login.
- Tombol cepat untuk menambah nota baru.
- Pull-to-refresh untuk memperbarui data.

### Dashboard Supervisor
- Ringkasan global seluruh nota aktif dari semua admin.
- Daftar nota terbaru beserta informasi admin penginput.
- Akses cepat ke halaman manajemen pengguna.

### Form Tambah / Edit Nota
- Upload foto nota dari **kamera** atau **galeri** perangkat.
- Nomor nota **digenerate otomatis** menggunakan UUID yang disesuaikan.
- Pilihan kategori nota: penjualan, pembelian, atau retur.
- Pilihan nama toko dari daftar toko yang telah ditentukan.
- Input tanggal dengan date picker.
- Field keterangan teks opsional.
- Mendukung mode **tambah** dan **edit** pada nota yang sudah ada.

### Detail Nota
- Tampilan foto nota dari cloud storage.
- Informasi lengkap: nomor nota, tanggal, nama toko, kategori, admin penginput, dan status.
- **Unduh nota** sebagai file **PDF** atau simpan foto langsung ke **galeri perangkat**.
- Aksi hapus nota dengan konfirmasi dialog.

### Daftar & Filter Nota
- Daftar semua nota (khusus Supervisor) atau nota milik sendiri (Admin).
- Filter berdasarkan rentang tanggal (dari – sampai) menggunakan date picker.
- Filter berdasarkan nama toko.
- Navigasi langsung ke halaman detail dari tiap item.

### Rekap Kalender
- Tampilan kalender bulan per bulan.
- Setiap tanggal yang memiliki nota ditandai secara visual.
- Tap tanggal untuk melihat daftar nota yang masuk pada hari tersebut melalui animated bottom panel.
- Navigasi antar bulan dan pilihan langsung ke bulan/tahun tertentu.

### Manajemen Pengguna *(Supervisor only)*
- Lihat seluruh daftar akun admin.
- Tambah akun admin baru langsung dari aplikasi.
- Aktifkan atau nonaktifkan akun admin (toggle status).

---

## Widget yang Digunakan

| Widget | Digunakan Pada |
|---|---|
| `SliverAppBar` + `FlexibleSpaceBar` | Dashboard Admin & Supervisor |
| `CustomScrollView` + berbagai Sliver | Dashboard & halaman daftar |
| `RefreshIndicator` | Dashboard (pull-to-refresh) |
| `FadeTransition` + `ScaleTransition` | Splash screen |
| `AnimationController` + `CurvedAnimation` | Splash screen & animasi rekap kalender |
| `Form` + `TextFormField` | Form tambah/edit nota & login |
| `DropdownButtonFormField` | Pilihan kategori & nama toko |
| `showDatePicker` | Filter tanggal & input tanggal nota |
| `showModalBottomSheet` | Pilihan format unduh (PDF / JPG) |
| `AlertDialog` | Konfirmasi hapus nota |
| `PopupMenuButton` | Menu logout pada AppBar |
| `Image.network` / `Image.asset` / `Image.memory` | Tampilan foto nota & logo |
| `CircularProgressIndicator` | Loading state di berbagai halaman |
| `Switch` | Toggle aktif/nonaktif akun pengguna |
| `BottomNavigationBar` | Navigasi tab Admin & Supervisor |
| `Stack` + `Positioned` | Layout halaman login |
| Custom `AppButton` | Tombol aksi utama & outlined |
| Custom `AppTextField` | Input teks berseragam di seluruh app |

---

## Nilai Tambah

Aplikasi ini menggunakan beberapa package tambahan di luar yang diajarkan di praktikum:

### 1. `pdf` + `printing`
Digunakan untuk membuat dokumen PDF secara programatik dari data nota (termasuk menyematkan foto nota) dan menampilkan dialog preview/print/share menggunakan `Printing.layoutPdf`.

### 2. `gal`
Digunakan untuk menyimpan foto nota langsung ke galeri perangkat (Android & iOS) tanpa memerlukan path file manual.

### 3. `permission_handler`
Digunakan untuk meminta dan mengelola izin runtime perangkat, seperti izin kamera, penyimpanan (storage), dan akses galeri foto sebelum melakukan operasi terkait.

### 4. `device_info_plus`
Digunakan bersama `permission_handler` untuk mendeteksi versi Android/iOS secara akurat, sehingga permintaan izin dapat disesuaikan dengan API level perangkat (misal: perbedaan izin storage pada Android 12 ke bawah vs Android 13 ke atas).

### 5. `uuid`
Digunakan untuk membuat nomor nota yang unik secara otomatis berbasis UUID, sehingga setiap nota memiliki identifikasi yang tidak berulang tanpa memerlukan counter dari server.

### 6. `google_fonts`
Digunakan untuk menerapkan tipografi kustom (Playfair Display) pada elemen-elemen branding seperti judul aplikasi di dashboard, memberikan kesan visual yang lebih profesional dan konsisten.
---



  
>>>>>>> cd224c42e6e6f13d1907b1f094d7362c85141f81
