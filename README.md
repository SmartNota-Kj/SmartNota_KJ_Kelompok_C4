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
|   Muhammad Nur Alfian   |    Nanda Pesona Putri   |  Jabbar Hafizh Abdillah  |   Keisya Siti Nafisa Andini   |  Chaessario Taufiqul Hakim  |
|-------------------------|-------------------------|--------------------------|------------------------|-----------------------------|
| **NIM:** 2309116105 <br> **Kelas:** SI C '24 <br> | **NIM:** 2309116101 <br> **Kelas:** SI C '24 <br>  | **NIM:** 2309116116 <br> **Kelas:** SI C '24 <br> | **NIM:** 2309116115 <br> **Kelas:** SI C '24 <br> | **NIM:** 2409116096 <br> **Kelas:** SI C '24 <br> |

## Nama Program
AgriChain merupakan sebuah sistem informasi pertanian yang berfungsi sebagai wadah digital khusus hasil panen padi. Platform ini mempertemukan petani dan distributor dalam satu sistem terpadu di mana petani dapat mencatat dan menawarkan hasil panennya secara langsung, sementara distributor dapat melakukan permintaan dan pemesanan sesuai kebutuhan. 


## Deskripsi Program
Aplikasi AgriChain adalah sistem informasi berbasis Java yang dirancang untuk membantu proses distribusi hasil panen antara petani dan distributor secara digital dan terintegrasi yang dikelola oleh admin. Tujuan utama aplikasi ini adalah untuk menciptakan rantai pasok pertanian yang lebih efisien, transparan, dan mudah digunakan oleh semua pihak yang terlibat dalam ekosistem pertanian lokal.  

---

### ⚙️ 1. Kebutuhan Sistem  
Agar aplikasi AgriChain bisa dijalankan dengan baik, berikut beberapa alat dan library yang digunakan dalam pengembangannya:  
- **`JDK 24`**: Digunakan untuk menjalankan dan mengompilasi program berbasis Java. Versi ini mendukung fitur-fitur modern untuk meningkatkan performa dan keamanan aplikasi.
- **`Apache NetBeans IDE 22`**: Digunakan sebagai lingkungan pengembangan (IDE) untuk menulis kode, mendesain tampilan GUI, serta menjalankan proyek Maven secara efisien.
- **`XAMPP`**: Berfungsi sebagai server lokal yang menyediakan layanan MySQL untuk penyimpanan data aplikasi.  
- **`Hibernate ORM (hibernate-core-6.4.1.Final.jar)`**: Framework utama yang digunakan untuk mengelola komunikasi antara objek Java dan tabel di database MySQL melalui konsep Object Relational Mapping (ORM).
- **`Jakarta Persistence API (jakarta.persistence-api-3.1.0.jar)`**: Menyediakan standar anotasi dan fungsi JPA yang digunakan Hibernate untuk memetakan class Java ke struktur tabel database.
- **`MySQL Connector (mysql-connector-j-8.0.33.jar)`**: Berfungsi sebagai penghubung antara Hibernate dengan database MySQL agar proses pengambilan dan penyimpanan data dapat dilakukan dengan lancar.
- **`Jakarta Transaction API (jakarta.transaction-api-2.0.1.jar)`**: Menangani proses commit dan rollback pada transaksi database untuk menjaga integritas data.
- **`SLF4J (slf4j-api & slf4j-simple 2.0.12)`**: Digunakan sebagai library logging untuk mencatat aktivitas Hibernate dan membantu proses debugging aplikasi.
- **`FlatLaf (flatlaf-3.2.jar)`**: Library yang mempercantik tampilan GUI berbasis Swing agar terlihat lebih modern dan responsif.
-  **`LGoodDatePicker (11.2.0.jar)`**: Menyediakan komponen kalender interaktif yang digunakan untuk memilih tanggal secara langsung pada tampilan aplikasi.

---

### 🌾 2. Fungsi Utama  
AgriChain hadir untuk mempermudah komunikasi dan transaksi antara petani dan distributor tanpa perantara. Petani dapat menginput hasil panen yang mereka miliki, sementara distributor dapat melihat data hasil panen tersebut dan membuat permintaan langsung kepada petani. Aplikasi ini juga memungkinkan admin untuk mengelola akun pengguna dan memantau aktivitas sistem.

---

### 👥 3. Peran Utama dalam Sistem  
- **Petani**: Menginput hasil panen dan menerima permintaan pesanan dari distributor.  
- **Distributor**: Melihat data hasil panen petani dan membuat permintaan.  
- **Admin**: Mengelola data petani dan distributor serta memastikan sistem berjalan dengan baik.  

## 📈 Use Case Diagram

<details>
  <summary><b>Use Case</b></summary>
  <img src="https://github.com/user-attachments/assets/756ba630-9549-48a9-b95a-6c2417c66cd1" alt="">
</details>

## 🔁 Flowchart Program

<details>
  <summary><b>1. Menu Login</b></summary>
  <img src="https://github.com/user-attachments/assets/f630d6be-a69e-4258-a95e-4caee7c7ab82" alt="">
</details>

<details>
  <summary><b>2. Menu Admin</b></summary>
  <img src="https://github.com/user-attachments/assets/2bc89c91-ce24-497e-bb5e-84bbac70a99c" alt="">
</details>

<details>
  <summary><b>3. Menu Petani</b></summary>
  <img src="https://github.com/user-attachments/assets/a2783650-a352-4c23-bc05-465d99f45606" alt="">
</details>

<details>
  <summary>4. <b>Menu Distributor</b></summary>
  <img src="https://github.com/user-attachments/assets/76f8c6e2-87d1-4043-a9dd-c51eaa7e245d" alt="">
</details>

<details>
  <summary>5. <b>Kelola Petani</b></summary>
  <img src="https://github.com/user-attachments/assets/d77c99c3-4dd6-4df5-9980-9c48658cbe2d" alt="">
</details>

<details>
  <summary>6. <b>Kelola Distributor</b></summary>
  <img src="https://github.com/user-attachments/assets/2161cf25-15d8-477c-8759-c16bf37c0668" alt="">
</details>


## ⚙️ Fitur Program

Aplikasi **AgriChain** memiliki beberapa fitur utama yang dibedakan berdasarkan peran pengguna: **Petani**, **Distributor**, dan **Admin**.

### 🧑‍💼 1. Fitur untuk Admin
Admin memiliki kontrol penuh terhadap sistem dan pengguna dalam aplikasi AgriChain. Berikut fitur-fitur utama yang dapat dilakukan oleh admin:

- **Kelola Akun Distributor**  
  Admin dapat menambah, mengedit, dan menghapus data distributor, termasuk nama, nomor telepon, status, dan tanggal registrasi.  

- **Kelola Akun Petani**  
  Admin bisa menambah, mengedit, dan menghapus data petani, termasuk nama, nomor telepon dan status sekaligus memantau hasil panen, serta aktivitas yang dilakukan di sistem.  

- **Pantau Permintaan Hasil Panen**  
  Admin dapat melihat daftar permintaan yang dilakukan oleh distributor kepada petani dan memastikan transaksi berjalan lancar.  

- **Manajemen Database Terpusat**  
  Semua data pengguna, hasil panen, dan permintaan tersimpan di database MySQL, sehingga memudahkan pemantauan dan pencarian data.  

- **Antarmuka Visual Interaktif**  
  Admin dapat berinteraksi langsung melalui tampilan GUI yang sederhana dan mudah digunakan, dilengkapi tombol Tambah, Edit, Hapus, serta tabel data.  

---

### 👨‍🌾 2. Fitur untuk Petani
- **Input Data Hasil Panen**  
  Petani dapat menambahkan data hasil panen seperti luas lahan, nama sawah, dan lokasi.  
- **Melihat dan Mengelola Permintaan**  
  Petani dapat melihat daftar permintaan dari distributor dan menerima permintaan tersebut.  
- **Dashboard Petani**  
  Menampilkan informasi panen dan permintaan dalam satu tampilan yang mudah dipahami.  

---

### 🚚 3. Fitur untuk Distributor
- **Melihat Data Petani dan Hasil Panen**  
  Distributor dapat mencari dan menyortir data hasil panen berdasarkan lokasi atau jumlah panen.  
- **Membuat Permintaan Hasil Panen**  
  Distributor dapat membuat permintaan kepada petani secara langsung dari aplikasi.  
- **Pantau Status Permintaan**  
  Distributor bisa melihat status permintaan yang dikirim apakah sudah diterima, sedang diproses, atau dipenuhi.  

---

### 🖥️ 4. Fitur Umum
- **Login dan Register Sesuai Role**  
  Pengguna baru dapat mendaftar sebagai Petani atau Distributor, dan sistem akan menampilkan halaman sesuai perannya.  
- **Koneksi Database Otomatis**  
  Semua data tersimpan otomatis di MySQL menggunakan JDBC Connector.  
- **Tampilan GUI Menarik dan Responsif**  
  Dibangun menggunakan Java Swing dengan layout AbsoluteLayout dan tema modern dari FlatLaf.  

## 💡 Penerapan OOP

<details>
<summary><b>1. Encapsulation</b></summary>

<img width="704" height="235" alt="image" src="https://github.com/user-attachments/assets/8b74ec32-44e1-4e94-b78f-7436035f755b" />

Salah satu contoh penerapannya terdapat pada class `Petani`. Setiap atribut seperti `idPetani`, `namaLengkap`, `username`, dan lainnya diberi modifier **private**, artinya data tersebut tidak bisa diakses langsung dari luar class. Akses hanya bisa dilakukan melalui **getter** dan **setter** yang disediakan, sehingga data dalam objek terlindungi dari perubahan sembarangan.  

Prinsip ini juga diterapkan pada beberapa class lain seperti di bagian **Controller** dan **Database**, terutama untuk atribut yang bersifat sensitif.

</details>

---

<details>
<summary><b>2. Inheritance</b></summary>

<img width="492" height="177" alt="image" src="https://github.com/user-attachments/assets/e8d7997e-fa53-4875-8b21-5ac571133bb8" />

<img width="668" height="50" alt="image" src="https://github.com/user-attachments/assets/7e61ce44-62f3-4bd5-a19d-67621101912f" />

Beberapa class pada package **Controller** mewarisi struktur dasar CRUD dari class abstrak `BaseController`.  
Artinya, controller-controller turunan tidak perlu menulis ulang method umum seperti `insert()`, `update()`, dan `delete()`,  
namun cukup **meng-override** method tersebut sesuai kebutuhan masing-masing entitas.

</details>

---

<details>
<summary><b>3. Polymorphism</b></summary>

<img width="1007" height="435" alt="image" src="https://github.com/user-attachments/assets/8daf8257-17fa-4ae4-a155-d69724e0e6fa" />

Penerapan polymorphism terlihat pada penggunaan method dengan nama yang sama di berbagai class pada package **Controller**,  
seperti `insert()` pada `petaniController`, `distributorController`, dan `permintaanController`.  

Meskipun nama method-nya sama, masing-masing memiliki **implementasi yang berbeda** sesuai dengan jenis data yang dikelola.  
Hal ini menunjukkan bahwa satu nama method dapat memiliki banyak bentuk perilaku tergantung pada objek yang memanggilnya.

</details>

---

<details>
<summary><b>4. Abstraction</b></summary>

<img width="577" height="127" alt="image" src="https://github.com/user-attachments/assets/6ad67e8c-b21d-4dc7-9d38-bf69e9e86dfc" />

Penerapan abstraction terdapat pada class `BaseController`, yang berfungsi sebagai **kerangka dasar bagi semua controller**.  
Class ini hanya mendefinisikan method abstrak seperti `insert()`, `update()`, dan `delete()` tanpa menjelaskan detail implementasinya.  

Setiap controller turunan kemudian mengisi logika sesuai kebutuhan masing-masing.  
Dengan cara ini, program menyembunyikan detail teknis yang kompleks dan hanya menampilkan bagian penting yang perlu diketahui.

</details>

---

<details>
<summary><b>5. Interface</b></summary>

<img width="423" height="134" alt="image" src="https://github.com/user-attachments/assets/0b9131f1-887a-4380-bda9-be20b05fc21e" />

<img width="687" height="63" alt="image" src="https://github.com/user-attachments/assets/93de5a91-9974-4f54-a828-0b51a8af66a5" />

Penerapan interface terlihat pada class `CRUDService`, yang berisi kumpulan method abstrak seperti `insert()`, `update()`, `delete()`, dan `getAll()`.  
Interface ini menjadi **standar perilaku** yang harus diikuti oleh setiap class service, seperti `petaniService`, `adminService`, dan `distributorService`.  

Dengan mengimplementasikan `CRUDService`, semua service tersebut dijamin memiliki struktur dan fungsi dasar yang sama,  
meskipun cara kerjanya bisa berbeda sesuai kebutuhan masing-masing entitas.

</details>


## 📂 Struktur Folder / Package

Struktur folder pada proyek AgriChain dirancang menggunakan pola MVC (Model–View–Controller) untuk memisahkan antara logika bisnis, tampilan, dan data. Pola ini membuat pengembangan aplikasi lebih mudah, teratur, dan efisien. Folder Model berisi kelas-kelas entitas yang mewakili data, View berisi tampilan GUI menggunakan Java Swing, dan Controller mengatur alur logika antara keduanya. Selain itu, terdapat package pendukung seperti Database untuk pengelolaan data menggunakan Hibernate, Session untuk menyimpan data pengguna yang sedang login, Resources untuk file pendukung seperti ikon dan gambar, serta Main sebagai titik awal eksekusi program.

<img width="310" height="211" alt="image" src="https://github.com/user-attachments/assets/e3362218-1b84-4cb9-9e82-1e73e88b8157" />

Secara umum, struktur foldernya adalah sebagai berikut:

<details>
  <summary>🧠 <b>Controller</b></summary>
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
  
## 🧰 Library / Framework yang Digunakan

Dalam pengembangan aplikasi AgriChain, digunakan beberapa library dan framework (dikelola melalui Maven dependencies) yang berfungsi untuk membantu proses pengembangan antarmuka (GUI), koneksi ke database, serta pengelolaan data menggunakan Hibernate ORM.. 

<img width="476" height="225" alt="image" src="https://github.com/user-attachments/assets/6e7a0b25-3b3d-4e52-bcb1-9fd036fac1c0" />

Berikut daftar library dan fungsinya:

- **`LGoodDatePicker-11.2.0.jar`**
  Library yang menyediakan komponen pemilih tanggal (calendar picker) agar pengguna dapat memilih tanggal secara langsung melalui antarmuka aplikasi.
- **`flatlaf-3.2.jar`**
  Library tampilan modern untuk Java Swing GUI, membuat antarmuka aplikasi lebih bersih dan profesional.
- **`hibernate-core-6.4.1.Final.jar`**
  Framework utama untuk ORM (Object Relational Mapping) yang menghubungkan objek Java dengan tabel di database MySQL tanpa menulis query SQL secara langsung.
- **`jakarta.persistence-api-3.1.0.jar`**
  Library pendukung Hibernate yang menyediakan standar JPA (Jakarta Persistence API), termasuk anotasi seperti @Entity, @Table, dan @Column.
- **`mysql-connector-j-8.0.33.jar`**
  Library penghubung antara aplikasi dan database MySQL agar Hibernate dapat melakukan operasi penyimpanan dan pengambilan data.
- **`slf4j-api-2.0.12.jar & slf4j-simple-2.0.12.jar`**
  Framework untuk logging sistem yang membantu mencatat aktivitas program dan debugging pada saat Hibernate atau aplikasi berjalan.
- **`jakarta.transaction-api-2.0.1.jar`**
  Digunakan untuk manajemen transaksi database seperti commit, rollback, dan pengendalian sesi Hibernate.
- **`protobuf-java-3.21.9.jar`**
  Library internal yang digunakan Hibernate untuk serialisasi data agar proses komunikasi data menjadi lebih cepat dan efisien.
  
## 🖥️ Panduan & Antarmuka Pengguna (GUI)

<details>
<summary><b>1. Menu Utama</b></summary>
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
  <p align="center"><b><em>1.3. Halaman Registrasi Utama</em></b><br>
  Pada halaman ini, pengguna dapat memilih peran (Admin, Petani, atau Distributor) sebelum melakukan proses login atau pendaftaran akun baru.
  </p>

  <img src="https://github.com/user-attachments/assets/ca8b9469-4fe5-4742-9809-2d009c0b8011" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.4. Form Registrasi Petani</em></b><br>
  Halaman ini digunakan oleh <b>Petani</b> untuk membuat akun baru. Petani dapat mengisi data pribadi seperti nama, username, dan password agar dapat mengakses sistem serta mengelola data hasil panennya.
  </p>

  <img src="https://github.com/user-attachments/assets/68bfd802-9060-4b53-8a0d-3964f9375886" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.5. Form Registrasi Distributor</em></b><br>
  Halaman ini digunakan oleh <b>Distributor</b> untuk mendaftar ke dalam sistem. Distributor perlu mengisi data perusahaan dan informasi kontak agar dapat melihat dan mengajukan permintaan hasil panen dari petani.
  </p>
</div>
<br>
</details>

<details>
<summary><b>4. Menu Admin</b></summary>
<br>

<div align="center">

  <img src="https://github.com/user-attachments/assets/6ca911f8-4b23-4c80-a752-edce29e4d012" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.6. Menu Admin</em></b><br>
  Halaman ini menampilkan dua fitur utama bagi Admin yaitu <b>Kelola Petani</b> dan <b>Kelola Distributor</b>. Admin dapat mengatur data pengguna seperti menambah, mengubah, atau menghapus informasi. Tombol <b>Keluar</b> digunakan untuk kembali ke halaman utama.
  </p>

  <img src="https://github.com/user-attachments/assets/c0ace4f4-2c1e-4284-aab1-1d8abfa92e75" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.7. Menu Kelola Petani</em></b><br>
  Halaman ini digunakan oleh Admin untuk mengelola data petani. Tersedia dua fitur utama, yaitu <b>Kelola Akun</b> untuk mengatur informasi petani dan <b>Kelola Panen</b> untuk memantau hasil panen yang telah tercatat.
  </p>

  <img src="https://github.com/user-attachments/assets/f2e45dcb-a75f-4014-8a47-3f5ec06629af" width="800" height="500" alt="image"/>
  <p align="center"><b><em>1.8. Kelola Akun Petani</em></b><br>
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
