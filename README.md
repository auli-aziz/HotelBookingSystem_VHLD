# Hotel Booking System

## Authors

- Bintang Siahaan (2206024322)
- Muhammad Abrisam Cahyo Juhartono (2206026050)
- Achmad Zaidan Lazuardy (2206059793)
- Aulia Anugrah Aziz (2206059364)

## Overview
`Hotel Booking System adalah suatu sistem yang memungkinkan user untuk melakukan reservasi kamar hotel. Sistem ini akan menghitung berapa uang yang harus dibayarkan oleh client berdasarkan jenis kamar yang dipilih, berapa orang yang menginap, dan waktu menginapnya. Selain itu, pengguna bisa mendapatkan uang kembalian bila jumlah uang yang dikasih melebihi harga kamar.`

## Tujuan
- Menerapkan bahasa VHDL untuk meningkatkan fungsionalitas dan efisiensi dalam kehidupan sehari-hari.
- Memperdalam pemahaman mengenai VHDL dan bagaimana penerapannya dalam pemrograman.
- Mengembangkan desain FSM yang inovatif dengan memanfaatkan kemampuan bahasa VHDL untuk kontrol sistem yang efisien.
- Mengidentifikasi dan mengimplementasikan strategi untuk meningkatkan keberlanjutan sistem melalui pemahaman dalam VHDL.



## Tools yang dipakai

- [VS Code](https://code.visualstudio.com/download)
- [ModelSim](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html)
- [Quartus Prime](https://www.intel.com/content/www/us/en/software-kit/660907/intel-quartus-prime-lite-edition-design-software-version-20-1-1-for-windows.html)
- [Github](https://desktop.github.com)

## Fitur-fitur
Berikut merupakan fitur-fitur yang ada pada proyek ini :

### Fitur booking kamar

`Fitur ini memungkinkan pengguna untuk memesan kamar hotel. Untuk memesan kamar, pengguna harus memasukkan nomor kamar, jumlah orang, dan jumlah malam menginap. Jika kamar tersedia, maka kamar tersebut akan dipesan dan total harga akan ditampilkan.`

### Fitur pembayaran

`Fitur ini memungkinkan pengguna untuk membayar biaya kamar yang telah dipesan. Pengguna harus memasukkan uang tunai yang sesuai dengan total harga. Jika uang yang dibayarkan cukup, maka pengguna akan berhasil check in dan uang kembalian akan diberikan.`

### Fitur display harga kamar

`Fitur ini memungkinkan pengguna untuk melihat harga kamar yang telah dipesan. Harga kamar ditampilkan dalam dua digit satuan jutaan dan dua digit satuan ratusan ribu.`

### Fitur state machine

`Kode di atas menggunakan state machine untuk mengatur aliran program. State machine ini terdiri dari lima state, yaitu:`
```bash
Idle : State awal di mana sistem menunggu pengguna untuk memulai proses booking.
Booking : State di mana pengguna memasukkan informasi pemesanan kamar.
Loading : State di mana sistem memeriksa ketersediaan kamar dan menyimpan nomor kamar yang dipesan.
Payment : State di mana pengguna melakukan pembayaran.
Check_in : State di mana pengguna check-in dan menerima uang kembalian.
```

## 7-Segment
`Seven segment merupakan tampilan output yang digunakan untuk menampilkan harga kamar dalam bentuk angka atau digit kepada pengguna. Tampilan ini memudahkan pengguna dalam melihat dan memahami jumlah harga yang harus dibayarkan untuk reservasi kamar di hotel.`

## Finite State Machine
`Berguna untuk menggambarkan kontroler booking yang memiliki keadaan seperti AVAILABLE, RESERVED, dan OCCUPIED`



