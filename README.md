

<h1 align="center" style="color:#2e8b57;">PROJEK AKHIR PEMROGRAMAN BERBASIS APLIKASI</h1>

<img width="1280" height="1280" alt="image" src="https://github.com/user-attachments/assets/6583026c-8c8f-4f64-a070-5895729d92c8" />

<h2 align="center" style="color:#4CAF50;">APLIKASI SMARTNOTA KJ</h2>

## 📚 Daftar Isi
- [👤 Profil Anggota](#-profil-anggota)
- [🌾 Nama Program](#-nama-program)
- [📝 Deskripsi Program](#-deskripsi-program)
- [⚙️ Fitur Program](#️-fitur-program)
- [📂 Struktur Folder / Package](#-struktur-folder--package)
- [🧰 Library / Framework yang Digunakan](#-library--framework-yang-digunakan)
  
## 👤 Profil Anggota
|   Muhammad Nur Alfian   |    Nanda Pesona Putri   |  Jabbar Hafizh Abdillah  |   Keisya Siti Nafisa Andini   |  Chaesarrio Taufiqul Hakim  |
|-------------------------|-------------------------|--------------------------|------------------------|-----------------------------|
| **NIM:** 2409116105 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116101 <br> **Kelas:** SI C '24 <br>  | **NIM:** 2409116116 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116115 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116096 <br> **Kelas:** SI C '24 <br> |

## Nama Program. 


## Deskripsi Program
Aplikasi AgriChain adalah sistem informasi berbasis Java yang dirancang untuk membantu proses distribusi hasil panen antara petani dan distributor secara digital dan terintegrasi yang dikelola oleh admin. Tujuan utama aplikasi ini adalah untuk menciptakan rantai pasok pertanian yang lebih efisien, transparan, dan mudah digunakan oleh semua pihak yang terlibat dalam ekosistem pertanian lokal.  

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

## ⚙️ Fitur Program

Aplikasi **SmartNota KJ** memiliki beberapa fitur utama yang dibedakan berdasarkan peran pengguna: **Supervisor** dan **Admin**. 

### 🧑‍💼 1. Fitur untuk Admin
Admin memiliki kontrol penuh terhadap sistem dan pengguna dalam aplikasi AgriChain. Berikut fitur-fitur utama yang dapat dilakukan oleh admin:

- **Kelola Akun Admin**  
  Admin dapat menambah, mengedit, dan menghapus data distributor, termasuk nama, nomor telepon, status, dan tanggal registrasi.  
- **Upload Nota**  
  Admin bisa menambah, mengedit, dan menghapus data petani, termasuk nama, nomor telepon dan status sekaligus memantau hasil panen, serta aktivitas yang dilakukan di sistem.  
- **Edit & Hapus Nota**  
  Admin dapat melihat daftar permintaan yang dilakukan oleh distributor kepada petani dan memastikan transaksi berjalan lancar.  
- **Download Nota**  
  Semua data pengguna, hasil panen, dan permintaan tersimpan di database MySQL, sehingga memudahkan pemantauan dan pencarian data.  
- **Filter Chip dan Rentang Tanggal**  
  Admin dapat berinteraksi langsung melalui tampilan GUI yang sederhana dan mudah digunakan, dilengkapi tombol Tambah, Edit, Hapus, serta tabel data.
 - **Arsip Nota**  
  Admin dapat berinteraksi langsung melalui tampilan GUI yang sederhana dan mudah digunakan, dilengkapi tombol Tambah, Edit, Hapus, serta tabel data.  
  
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
Secara umum, struktur foldernya adalah sebagai berikut:

<details>
  <summary>🧠 <b>Constant</b></summary>
  Package ini berisi seluruh logika utama aplikasi (business logic) yang mengatur alur kerja antara tampilan (view) dan data (model). Controller menerima input dari user melalui form GUI, memproses data, lalu menghubungkannya ke database lewat package Database.

  <img width="268" height="202" alt="Screenshot 2025-11-05 012336" src="https://github.com/user-attachments/assets/e416d39d-049b-4da3-af3b-73ac67fce9df" />

Berikut beberapa file penting di dalamnya:
- **`BaseController.java`**: Kelas dasar (abstrak) yang menyimpan fungsi umum yang dipakai controller lain, misalnya pola CRUD/validasi sederhana agar kode tidak duplikat.
- **`LoginController.java`**: Mengelola proses login untuk Admin, Petani, dan Distributor (cek username/password, arahkan ke dashboard).
- **`RegisterController.java`**: Mengelola pendaftaran akun baru (validasi input, simpan user). 
- **`distributorController.java`**: Logika untuk fitur milik Distributor, termasuk melihat info petani dan membuat permintaan.
- **`generateID.java`**: Utilitas untuk membuat ID unik otomatis (mis. PRM01, PAN01, dst.) agar tidak terjadi bentrok ID.
- **`hasilPanenController.java`**: Mengatur kelola hasil panen (tambah, edit, hapus, muat tabel) milik Petani/Admin. 
- **`permintaanController.java`**: Mengelola permintaan hasil panen (tambah, ubah status: menunggu/disetujui/ditolak/dipenuhi, muat tabel).
- **`petaniController.java`**: Mengelola data Petani (profil, kontak, lokasi/luas lahan, muat tabel). 

Package ini berfungsi sebagai “otak” dari aplikasi yang mengatur hubungan antar komponen dan memastikan logika berjalan dengan benar.
</details> 

---

<details>
  <summary>🗄️ <b>Database</b></summary>
Package Database berfungsi untuk mengatur seluruh proses komunikasi dan pengelolaan data antara aplikasi AgriChain dengan database MySQL menggunakan Hibernate dengan penerapan DAO (Data Access Object) pattern.
Setiap class di package ini berperan sebagai service layer yang menjadi penghubung antara controller dan database, sehingga logika bisnis dan logika data tetap terpisah.
Struktur ini membuat kode menjadi lebih rapi, modular, dan mudah dikelola ketika terjadi perubahan di skema database.

<img width="264" height="190" alt="image" src="https://github.com/user-attachments/assets/63b38183-5f40-4cc2-b52d-a6270ca595ea" />

- **`CRUDService.java`**: Menyediakan **fungsi dasar CRUD** (*Create, Read, Update, Delete*) yang dapat digunakan oleh berbagai service lain.  
  Dengan adanya class ini, semua proses database dapat dilakukan secara efisien tanpa perlu menulis ulang query yang sama.

- **`Koneksi.java`**: Mengatur koneksi utama ke MySQL.  
  File ini menyimpan konfigurasi seperti URL database, username, dan password.  
  Semua file lain akan menggunakan koneksi dari sini agar tidak perlu membuat koneksi baru berulang kali.

- **`adminService.java`**: Berfungsi untuk mengelola data **Admin**, termasuk menambah akun baru, memperbarui data, dan menampilkan daftar admin.

- **`distributorService.java`**: Menangani semua operasi terkait **Distributor**, seperti menyimpan data pendaftaran, memperbarui status, serta mengambil data distributor dari database.

- **`hasilPanenService.java`**: Mengelola data **hasil panen** dari petani, meliputi jenis hasil panen, jumlah, satuan (kg/ton), dan status data.  
  File ini membantu `hasilPanenController` dalam memuat daftar hasil panen serta menambahkan data baru.

- **`permintaanService.java`**: Mengatur data **permintaan hasil panen** dari distributor ke petani.
  Termasuk menambah permintaan baru, memperbarui status (misalnya menunggu, diterima, atau selesai), serta menampilkan daftar permintaan yang aktif.

- **`petaniService.java`**: Digunakan untuk mengatur data **Petani**, seperti nama, nomor telepon, lokasi sawah, dan luas lahan.  
  File ini biasanya digunakan oleh `petaniController` untuk menampilkan dan memperbarui data petani di GUI.
</details>

---

<details>
  <summary>🧩 <b>Model</b></summary>
Package ini berisi **kelas-kelas representasi data (entity class)** yang mencerminkan tabel di database.  

<img width="276" height="136" alt="image" src="https://github.com/user-attachments/assets/98462358-673d-4569-b0f6-bca486df7d61" />

  Setiap model memiliki atribut dan metode *getter/setter* yang digunakan untuk mengatur atau mengambil nilai data.

- **`Admin.java`**: Menyimpan data admin seperti ID, nama, dan nomor telepon.  
- **`Distributor.java`**: Menyimpan informasi distributor seperti nama, status, dan tanggal registrasi.  
- **`Permintaan.java`**: Mewakili data permintaan hasil panen oleh distributor.  
- **`Petani.java`**: Berisi data petani seperti nama sawah, luas lahan, dan lokasi.  
- **`hasilPanen.java`**: Menyimpan data panen yang dimasukkan oleh petani (jenis, jumlah, satuan).

Package ini berperan sebagai wadah data yang dikirim atau diterima antar komponen aplikasi.
</details>

---

<details>
  <summary>🔐 <b>Session</b></summary>
Package ini berfungsi untuk **menyimpan informasi pengguna yang sedang login** agar bisa digunakan di berbagai tampilan (form). Misalnya menyimpan ID user, nama, dan perannya (Admin, Petani, Distributor).

<img width="271" height="45" alt="image" src="https://github.com/user-attachments/assets/4b92d37e-7db6-4abf-84fc-09bb93d72df2" />

- **`Session.java`**: Berisi variabel global yang bisa diakses oleh semua form untuk melacak siapa yang sedang aktif menggunakan aplikasi.

Dengan Session, user tidak perlu login berulang kali saat berpindah halaman.
</details>

---

<details>
  <summary>🚀 <b>Main</b></summary>
Package ini berisi file utama yang menjalankan program.

<img width="267" height="47" alt="image" src="https://github.com/user-attachments/assets/e02610c0-7cc5-4d03-b0e3-f75976fd0436" />

---

<details>
  <summary>🖼️ <b>Resources</b></summary>

Package **Resources** berisi seluruh **file pendukung tampilan aplikasi**, seperti gambar latar belakang (`*.png`), ikon tombol, serta file konfigurasi Hibernate (`hibernate.cfg.xml`).  
Semua aset visual yang digunakan di package `View` diambil dari folder ini agar tampilan aplikasi lebih menarik dan konsisten. Selain itu, file konfigurasi Hibernate di sini berfungsi untuk mengatur koneksi aplikasi dengan database MySQL secara otomatis tanpa perlu menulis ulang pengaturan di setiap kelas.
</details>

---

- **`Main.java`**: Menjadi *entry point* aplikasi. File ini biasanya memanggil form pertama (seperti LoginForm) dan melakukan inisialisasi awal sebelum program berjalan.

Package ini memastikan aplikasi berjalan dengan urutan dan konfigurasi yang benar saat pertama kali dijalankan.
</details>

---

<details>
  <summary>🖼️ <b>View</b></summary>

Package View berisi seluruh tampilan antarmuka pengguna (GUI) yang dibuat menggunakan Java Swing. Setiap file di dalam package ini merepresentasikan satu halaman atau form dalam aplikasi AgriChain, seperti login, registrasi, menu utama, hingga halaman pengelolaan data.  

<img width="349" height="428" alt="Screenshot 2025-11-05 014527" src="https://github.com/user-attachments/assets/cde4759f-dc97-4007-8213-f0d25eb98912" />

Semua elemen visual seperti tombol, tabel, dan field input diatur di sini agar pengguna dapat berinteraksi langsung dengan sistem. Secara singkat, package ini merupakan bagian tampilan (frontend) dari aplikasi, tempat pengguna berinteraksi langsung dengan sistem.
</details>
  
## 🧰 


## 🖥️ Panduan & Antarmuka Pengguna 

<details>
<summary><b>1. Login Page</b></summary>
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/6006ced9-2ed5-4a5a-93ba-e91c2d84e24a" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.1. Menu Utama</em></b><br>
  Halaman ini merupakan tampilan awal aplikasi AgriChain. Pengguna dapat melakukan <b>login</b> untuk masuk ke sistem, atau memilih opsi <b>daftar</b> jika belum memiliki akun. Menu ini menjadi pintu masuk utama bagi Admin, Petani, maupun Distributor sebelum mengakses fitur masing-masing.</p>
</div> <br>
</details>

<details>
<summary><b>2. Menu Login</b></summary>
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/4c98e056-54f7-42c6-9942-8eec59741452" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.2. Menu Login</em></b><br>
  Halaman ini digunakan oleh Admin, <b>Petani</b>, dan <b>Distributor</b> untuk masuk ke sistem. Pengguna perlu memasukkan <b>username</b> dan <b>password</b> yang terdaftar untuk mengakses akun masing-masing.  Tombol <b>Kembali</b> digunakan untuk kembali ke menu utama, sedangkan tautan <b>Daftar</b> mengarahkan ke halaman pendaftaran akun baru.
  </p>
</div> <br>
</details>
    
<details>
<summary><b>3. Menu Registrasi</b></summary>
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/c4394e2e-343a-436e-a068-58852fc451c0" width="800" height="500" alt="image"/>
  <p align="center"><b><em>Dashboard Supervisor</em></b><br>
  Pada halaman ini, pengguna dapat memilih peran (Admin, Petani, atau Distributor) sebelum melakukan proses login atau pendaftaran akun baru.
  </p>

  <img src="https://github.com/user-attachments/assets/ca8b9469-4fe5-4742-9809-2d009c0b8011" width="800" height="500" alt="image"/>
  <p align="center"><b><em>Menu Nota</em></b><br>
  Halaman ini digunakan oleh <b>Petani</b> untuk membuat akun baru. Petani dapat mengisi data pribadi seperti nama, username, dan password agar dapat mengakses sistem serta mengelola data hasil panennya.
  </p>

  <img src="https://github.com/user-attachments/assets/68bfd802-9060-4b53-8a0d-3964f9375886" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.5. Form Registrasi Distributor</em></b><br>
  Halaman ini digunakan oleh <b>Menu Rekap</b> untuk mendaftar ke dalam sistem. Distributor perlu mengisi data perusahaan dan informasi kontak agar dapat melihat dan mengajukan permintaan hasil panen dari petani.
  </p>
</div>
<br>
</details>

<details>
<summary><b>4. Menu Admin</b></summary>
<br>

<div align="center">

  <img src="https://github.com/user-attachments/assets/6ca911f8-4b23-4c80-a752-edce29e4d012" width="800" height="500" alt="image"/>
  <p align="center"><b><em>Menu Pengguna</em></b><br>
  Halaman ini menampilkan dua fitur utama bagi Admin yaitu <b>Kelola Petani</b> dan <b>Kelola Distributor</b>. Admin dapat mengatur data pengguna seperti menambah, mengubah, atau menghapus informasi. Tombol <b>Keluar</b> digunakan untuk kembali ke halaman utama.
  </p>

  <img src="https://github.com/user-attachments/assets/c0ace4f4-2c1e-4284-aab1-1d8abfa92e75" width="800" height="500" alt="image"/>
  <p align="center"><b><em>Dashboard Admin</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data petani. Tersedia dua fitur utama, yaitu <b>Kelola Akun</b> untuk mengatur informasi petani dan <b>Kelola Panen</b> untuk memantau hasil panen yang telah tercatat.
  </p>

  <img src="https://github.com/user-attachments/assets/f2e45dcb-a75f-4014-8a47-3f5ec06629af" width="800" height="500" alt="image"/>
  <p align="center"><b><em>Menu Nota</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data akun petani. Admin dapat menambahkan, mengubah, atau menghapus data seperti nama petani, username, password, nomor telepon, serta informasi lahan. Data yang tersimpan akan langsung ditampilkan pada tabel di bawahnya.
  </p>

  <img src="https://github.com/user-attachments/assets/ba8daffe-5d2a-451a-a519-587b10918b1e" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.9. Kelola Panen</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data hasil panen dari setiap petani. Admin dapat menambahkan, mengedit, atau menghapus data panen seperti jumlah panen, satuan, tanggal panen, serta ID petani dan admin yang terkait. Data panen yang tersimpan akan ditampilkan pada tabel di bagian bawah.
  </p>

  <img src="https://github.com/user-attachments/assets/5f28dd23-e785-4015-81ee-bf2e81cd2975" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.10. Menu Kelola Distrubutor</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data distributor. Tersedia dua fitur utama, yaitu <b>Kelola Akun</b> untuk mengatur informasi distributor dan <b>Kelola Permintaan</b> untuk memantau serta memproses permintaan yang diajukan oleh distributor.
  </p>

  <img src="https://github.com/user-attachments/assets/c8f1d5f8-7a9e-45d6-88ef-c10e9293b5ed" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.11. Kelola Akun Distributor</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data akun distributor. Admin dapat menambahkan, mengedit, atau menghapus informasi seperti nama distributor, username, password, nomor telepon, nama usaha, dan wilayah pasar. Semua data yang diperbarui akan langsung ditampilkan pada tabel di bawahnya.
  </p>

  <img src="https://github.com/user-attachments/assets/8cf3097d-9b78-47dd-b662-69d2c5f23b05" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.12. Kelola Permintaan</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data permintaan dari distributor. Admin dapat menambah, mengedit, atau menghapus data permintaan serta memperbarui status seperti menunggu, diterima, ditolak, atau dipenuhi. Semua data permintaan ditampilkan dalam tabel di bagian bawah agar mudah dipantau dan diperbarui.
  </p>

</div>
<br>
</details>  

<details>
<summary><b>5. Menu Petani</b></summary>
<br>

<div align="center">

  <img src="https://github.com/user-attachments/assets/29ba5ca8-d595-44c2-bfee-cfab9d774a4d" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.13. Menu Petani</em></b><br>
  Halaman ini menampilkan dua fitur utama bagi Petani, yaitu <b>Hasil Panen</b> dan <b>Permintaan</b>. Melalui menu ini, petani dapat mengelola data hasil panen yang mereka input serta melihat atau membuat permintaan distribusi hasil panen. Tombol <b>Keluar</b> digunakan untuk kembali ke halaman utama aplikasi.
  </p>

  <img src="https://github.com/user-attachments/assets/dee29d9f-6af3-4beb-9494-d18489b503c0" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.14. Hasil Panen</em></b><br>
  Halaman ini menampilkan dua fitur utama bagi Petani, yaitu <b>Hasil Panen</b> dan <b>Permintaan</b>. Melalui menu ini, petani dapat mengelola data hasil panen yang mereka input serta melihat atau membuat permintaan distribusi hasil panen. Tombol <b>Keluar</b> digunakan untuk kembali ke halaman utama aplikasi.
  </p>

  <img src="https://github.com/user-attachments/assets/8023050b-2670-414c-879e-66e11cfdc210" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.15. Permintaan</em></b><br>
  Halaman ini digunakan oleh Petani untuk melihat dan mengelola permintaan hasil panen dari distributor. Petani dapat memantau status setiap permintaan, seperti <em>menunggu</em>, <em>disetujui</em>, atau <em>ditolak</em>, serta memperbarui data jika diperlukan. Tombol <b>Simpan</b> berfungsi untuk menyimpan perubahan status, sedangkan tombol <b>Kembali</b> digunakan untuk kembali ke menu utama.
  </p>
  
</div>
<br>
</details> 

<details>
<summary><b>6. Menu Distributor</b></summary>
<br>

<div align="center">

  <img src="https://github.com/user-attachments/assets/797b356d-5d44-4ac1-a35b-1328dbf5a6b9" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.16. Menu Distributor</em></b><br>
  Halaman ini menampilkan dua fitur utama bagi Distributor, yaitu <b>Info Petani</b> dan <b>Buat Permintaan</b>. Melalui menu ini, distributor dapat melihat informasi lengkap mengenai petani serta membuat permintaan pembelian hasil panen. Tombol <b>Keluar</b> digunakan untuk kembali ke halaman utama aplikasi.
  </p>

  <img src="https://github.com/user-attachments/assets/94ada041-d945-4366-a287-81f38c41e078" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.17. Info Petani</em></b><br>
  Halaman ini menampilkan dua fitur utama bagi Distributor, yaitu <b>Info Petani</b> dan <b>Buat Permintaan</b>. Melalui menu ini, distributor dapat melihat informasi lengkap mengenai petani serta membuat permintaan pembelian hasil panen. Tombol <b>Keluar</b> digunakan untuk kembali ke halaman utama aplikasi.
  </p>

  <img src="https://github.com/user-attachments/assets/f0550510-4671-4965-81a3-d5b8258a1567" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.18. Buat Permintaan</em></b><br>
  Halaman ini digunakan oleh Distributor untuk membuat dan mengelola permintaan hasil panen dari petani. Distributor dapat memasukkan <b>jumlah permintaan</b> beserta satuannya, lalu menambahkan data ke dalam tabel. Data permintaan yang telah dibuat akan tampil bersama informasi seperti status dan tanggal permintaan. Tombol <b>Kembali</b> digunakan untuk kembali ke menu utama distributor.
  </p>

</div>
<br>
</details>  
>>>>>>> cd224c42e6e6f13d1907b1f094d7362c85141f81
