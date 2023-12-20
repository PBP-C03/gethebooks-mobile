# GetTheBooks 📚

### Kini hadir dalam mobile version!

<br>

<img src="https://github.com/PBP-C03/main-project/assets/122893320/1a43097d-ed39-435c-a419-36cfd97c048d" width="300" alt="GeTheBooks Mockup">

### Deployment Website (TK PTS)
http://gethebooks-c03-tk.pbp.cs.ui.ac.id/

### Pipeline Status
[![Pipeline](https://build.appcenter.ms/v0.1/apps/216f9df2-2104-4d8b-bdd6-6d6a01753a6c/branches/main/badge)](https://build.appcenter.ms/v0.1/apps/216f9df2-2104-4d8b-bdd6-6d6a01753a6c/branches/main/badge)

### Tautan Link Aplikasi
https://install.appcenter.ms/orgs/pbp-c03/apps/gethebooks/distribution_groups/public/releases/3


## Pengembang Aplikasi 🛠️
Proyek ini dibuat oleh kelompok C03 yang beranggotakan sebagai berikut:
1. Afsar Rakha Farrasandi - 2206028636
2. Kaisa Dian Ferdinand - 2206816494
3. Yosef Nuraga Wicaksana - 2206082751
4. Steven Faustin Orginata - 2206030855
5. Kezia Natalia Theodora N. - 2206818316

## Nama Aplikasi

### GeTheBooks

## Cerita aplikasi dan manfaat aplikasi 📖
GeTheBooks adalah sebuah aplikasi revolusioner untuk berjualan buku, yang didesain untuk memperkuat minat baca di kalangan masyarakat Indonesia. Pengguna dapat dengan mudah mengunggah katalog buku pribadi mereka ke dalam aplikasi, sehingga buku-buku tersebut dapat ditemukan dan diakses oleh para pembeli potensial. Selain itu, GeTheBooks juga menyediakan beragam fitur yang mempermudah proses penjualan, termasuk opsi untuk menambahkan deskripsi, menetapkan harga, dan mengelola inventaris buku. Dengan demikian, para penjual dapat memiliki kendali penuh atas aktivitas jual-beli mereka dan memberikan pengalaman yang lebih baik bagi pembeli yang mencari buku-buku yang sesuai dengan minat dan preferensi mereka. Hal ini membuat GeTheBooks menjadi platform ideal bagi mereka yang ingin menjual dan berbagi kekayaan literatur mereka dengan komunitas yang berbagi minat.

Selain fitur-fitur utama yang telah disebutkan di atas, GeTheBooks juga menawarkan berbagai fasilitas tambahan yang memperkaya pengalaman pengguna. Salah satunya adalah Fitur QnA Forum, yang memungkinkan pengguna untuk berinteraksi dan berbagi pengetahuan terkait buku-buku yang mereka jual atau minati. Forum ini memberikan ruang bagi diskusi, tanya jawab, serta sarana untuk saling memberi rekomendasi antaranggota komunitas.

Tak hanya itu, terdapat juga Fitur Review and Rating, yang memungkinkan pembeli untuk memberikan ulasan dan penilaian terhadap buku-buku yang telah mereka beli. Hal ini tidak hanya membantu pembeli lain dalam memilih buku yang sesuai dengan preferensi mereka, tetapi juga memberikan umpan balik berharga bagi penjual untuk terus meningkatkan kualitas layanan mereka.

Fitur Keranjang Produk dan Fitur Checkout Produk adalah dua fitur penting lainnya. Fitur Keranjang Produk memungkinkan pembeli untuk mengumpulkan buku-buku pilihan mereka sebelum melakukan pembelian, sementara Fitur Checkout Produk menyediakan proses transaksi yang lancar dan aman. Keduanya dirancang untuk memberikan pengalaman belanja yang nyaman dan efisien bagi pengguna.

Dengan berbagai fitur ini, GeTheBooks tidak hanya menyediakan platform untuk berjualan buku, tetapi juga menciptakan sebuah komunitas yang aktif dan bersemangat dalam berbagi minat terhadap literatur. Dengan demikian, GeTheBooks menjadi lebih dari sekadar aplikasi jual-beli, tetapi juga menjadi wadah untuk menghubungkan para pecinta buku dan memperkuat budaya literasi di Indonesia.

### Kelebihan GeTheBooks

- Mengunggah katalog buku pribadi 📚
- Menemukan pembeli potensial 👥
- Mengelola inventaris buku dengan mudah 🗃️
- Memberikan pengalaman jual-beli yang nyaman 🛍️


## Daftar Modul ⭐
1. **Upload Book** 📖
    - Developer : Kaisa Dian Ferdinand
    - Deskripsi : Fitur untuk menambahkan buku baru yang akan dijual ke dalam katalog *Mobile App*. Pengguna dapat dengan bebas mengisi nama buku, harga buku, gambar, serta penulis


2. **QnA Forum** 💬
    - Developer : Kezia Natalia Theodora N.
    - Deskripsi : Fitur sebagai tempat diskusi pengguna terhadap buku - buku yang terdaftar dalam katalog *Mobile App*

3. **Review and Rating** 🌟
    - Developer : Steven Faustin Orginata
    - Deskripsi : Fitur ini memungkinkan pengguna untuk memberikan ulasan dan penilaian terhadap buku-buku yang mereka beli atau baca

4. **Keranjang Produk** 🛒
    - Developer : Afsar Rakha Farrasandi
    - Deskripsi :  Fitur untuk menyimpan buku di keranjang belanja yang ingin dibeli oleh pengguna sebelum melakukan pembayaran. Pengguna dapat mengatur jumlah buku yang ingin dibeli sesuai dengan yang diinginkan.

5. **Checkout Produk** 💳
    - Developer : Yosef Nuraga Wicaksana
    - Deskripsi : Fitur untuk melakukan *checkout* buku-buku yang sudah ada di keranjang. Pengguna akan diminta informasi mengenai email, dll.


## Sumber referensi *dataset* opsional
- https://www.kaggle.com/datasets/sootersaalu/amazon-top-50-bestselling-books-2009-2019
- https://www.kaggle.com/datasets/lukaanicin/book-covers-dataset
- https://www.kaggle.com/datasets/arashnic/book-recommendation-dataset/


## Peran pengguna
### User belum terdaftar
1. Mengakses homepage
2. Jika mengakses fitur-fitur seperti Menjual Buku, QnA Forum, Review & Rating, Keranjang Produk, Checkout Produk serta Profile akan keluar notif untuk melakukan login/sign up
      

### User terdaftar
1. Melihat homepage
2. Mengunjungi katalog aplikasi
2. Mengakses forum QnA aplikasi
3. Menambahkan buku ke dalam keranjang
4. Melakukan pembayaran buku dalam keranjang
5. Menambahkan saldo ke dalam akun pengguna

## Alur pengintegrasian dengan web service

- Menambahkan dependensi HTTP
- Membuat models dari data.
- Mengambil data JSON dari aplikasi web.
- Mengkonversi data yang telah diambil ke dalam bentuk models dengan manual serializations menggunakan built in JSON decoder.
- Mengimplementasikan desain front-end sesuai dengan aplikasi sebelumnya.
Integrasi front-end dan back-end.

## Berita Acara
[Berita Acara](https://docs.google.com/spreadsheets/d/1l3SVQlrwXRMFPmH6XVyqReK40lICL3elLnwczUgSlMg/edit?usp=sharing)