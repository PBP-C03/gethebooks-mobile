# GetTheBooks

## Pengembang Aplikasi
Proyek ini dibuat oleh kelompok C03 yang beranggotakan sebagai berikut:
1. Afsar Rakha Farrasandi - 2206028636
2. Kaisa Dian Ferdinand - 2206816494
3. Yosef Nuraga Wicaksana - 2206082751
4. Steven Faustin Orginata - 2206030855
5. Kezia Natalia Theodora N. - 2206818316

## Nama Aplikasi

### GeTheBooks

## Cerita aplikasi dan manfaat aplikasi
GeTheBooks adalah sebuah aplikasi revolusioner untuk berjualan buku, yang didesain untuk memperkuat minat baca di kalangan masyarakat Indonesia. Pengguna dapat dengan mudah mengunggah katalog buku pribadi mereka ke dalam aplikasi, sehingga buku-buku tersebut dapat ditemukan dan diakses oleh para pembeli potensial. Selain itu, GeTheBooks juga menyediakan beragam fitur yang mempermudah proses penjualan, termasuk opsi untuk menambahkan deskripsi, menetapkan harga, dan mengelola inventaris buku. Dengan demikian, para penjual dapat memiliki kendali penuh atas aktivitas jual-beli mereka dan memberikan pengalaman yang lebih baik bagi pembeli yang mencari buku-buku yang sesuai dengan minat dan preferensi mereka. Hal ini membuat GeTheBooks menjadi platform ideal bagi mereka yang ingin menjual dan berbagi kekayaan literatur mereka dengan komunitas yang berbagi minat.

Selain fitur-fitur utama yang telah disebutkan di atas, GeTheBooks juga menawarkan berbagai fasilitas tambahan yang memperkaya pengalaman pengguna. Salah satunya adalah Fitur QnA Forum, yang memungkinkan pengguna untuk berinteraksi dan berbagi pengetahuan terkait buku-buku yang mereka jual atau minati. Forum ini memberikan ruang bagi diskusi, tanya jawab, serta sarana untuk saling memberi rekomendasi antaranggota komunitas.

Tak hanya itu, terdapat juga Fitur Review and Rating, yang memungkinkan pembeli untuk memberikan ulasan dan penilaian terhadap buku-buku yang telah mereka beli. Hal ini tidak hanya membantu pembeli lain dalam memilih buku yang sesuai dengan preferensi mereka, tetapi juga memberikan umpan balik berharga bagi penjual untuk terus meningkatkan kualitas layanan mereka.

Fitur Keranjang Produk dan Fitur Checkout Produk adalah dua fitur penting lainnya. Fitur Keranjang Produk memungkinkan pembeli untuk mengumpulkan buku-buku pilihan mereka sebelum melakukan pembelian, sementara Fitur Checkout Produk menyediakan proses transaksi yang lancar dan aman. Keduanya dirancang untuk memberikan pengalaman belanja yang nyaman dan efisien bagi pengguna.

Dengan berbagai fitur ini, GeTheBooks tidak hanya menyediakan platform untuk berjualan buku, tetapi juga menciptakan sebuah komunitas yang aktif dan bersemangat dalam berbagi minat terhadap literatur. Dengan demikian, GeTheBooks menjadi lebih dari sekadar aplikasi jual-beli, tetapi juga menjadi wadah untuk menghubungkan para pecinta buku dan memperkuat budaya literasi di Indonesia.


## Daftar Modul
1. Fitur Upload Buku ke katalog
    - Developer : Kaisa Dian Ferdinand
    - Deskripsi : Fitur untuk menambahkan buku baru yang akan dijual ke dalam katalog *mobile app*. Pengguna dapat dengan bebas mengisi nama buku, harga buku, gambar, serta penulis


2. Fitur QnA Forum
    - Developer : Kezia Natalia Theodora N.
    - Deskripsi : Fitur sebagai tempat diskusi pengguna terhadap buku - buku yang terdaftar dalam katalog *mobile app*

3. Fitur Review and Rating
    - Developer : Steven Faustin Orginata
    - Deskripsi : Fitur ini memungkinkan pengguna untuk memberikan ulasan dan penilaian terhadap buku-buku yang mereka beli atau baca

4. Fitur Keranjang Produk
    - Developer : Afsar Rakha Farrasandi
    - Deskripsi :  Fitur untuk menyimpan buku di keranjang belanja yang ingin dibeli oleh pengguna sebelum melakukan pembayaran. Pengguna dapat mengatur jumlah buku yang ingin dibeli sesuai dengan yang diinginkan.

5. Fitur *Checkout* Produk
    - Developer : Yosef Nuraga Wicaksana
    - Deskripsi : Fitur untuk melakukan *checkout* buku-buku yang sudah ada di keranjang. Pengguna akan diminta informasi mengenai alamat dan jasa pengiriman, dll.


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



## Alur pengintegrasian aplikasi mobile dengan web service
### Untuk fitur Review:

User akan membuka halaman review dengan meng-klik buku yang ingin dilihat. Lalu, data review akan di-fetch melalui endpoint yang telah dibuat pada PTS. Endpoint untuk review adalah https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/json/. Kita akan mendapatkan suatu response di mana body response akan di-decode menjadi String JSON. Dari String JSON ini akan dibuat menjadi object Review yang nantinya akan di loop dan di show.

Untuk method post review menggunakan endpoint https://gethebooks-c03-tk.pbp.cs.ui.ac.id/book/<id_buku>/add-review/. Terdapat 2 field, yaitu rating dan review. Untuk tiap field, akan diambil valuenya dan akan di-pass menggunakan method pada pbp_django_auth untuk selanjutnya di-post.



### Untuk fitur Checkout:

User akan membuka halaman checkout melalui halaman keranjang lalu akan dimulai dengan fetch data feedback melalui endpoint yang digunakan adalah checkoutbook/get-order/. Response yang didapatkan kemudian didecode dengan format JSON sehingga menjadi sebuah Map. Map yang telah didapatkan kemudian diiterasi dalam sebuah loop untuk dapat menampilkan pesanan yang sudah dimasukkan ke dalam keranjang. Selain menampilkan kemudian terdapat beberapa endpoint untuk mengubah jumlah book yakni https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkoutbook/inc-book/<int:id>/ untuk menambahkan jumlah buku, https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkoutbook/dec-book/<int:id>/ untuk mengurangi jumlah buku, https://gethebooks-c03-tk.pbp.cs.ui.ac.id/checkoutbook/del-book/<int:id>/ untuk menghapus pesanan buku. Kemudian fungsi POST akan menggunakan button yang akan melakukan fetch melalui endpoint checkoutbook/pay-order/.  Response yang didapatkan yakni berupa data mengenai pembayaran user berhasil atau tidak.



### Untuk fitur Upload Book:
Fitur Upload Book pada platform GetheBooks memungkinkan pengguna untuk mengunggah buku baru ke dalam koleksi. Prosesnya dimulai dengan mengisi formulir dengan detail buku dan mengunggah file buku. Setelah validasi data, sistem menyimpan informasi ke dalam database dan file di server melalui endpoint khusus seperti https://gethebooks-c03-tk.pbp.cs.ui.ac.id/uploadbook/add-book/. Pengguna mendapatkan respons berhasil dan dapat melihat buku baru dihalaman profil atau katalog. Opsi tambahan seperti edit data informasi dan delete buku dapat digunakan setelah proses upload, memberikan fleksibilitas dan meningkatkan interaktivitas pengguna.



## Berita Acara
[Berita Acara](https://docs.google.com/spreadsheets/d/1l3SVQlrwXRMFPmH6XVyqReK40lICL3elLnwczUgSlMg/edit?usp=sharing)