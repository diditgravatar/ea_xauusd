Untuk membuat Expert Advisor (EA) di MetaTrader 5 (MT5) dengan fitur-fitur yang Anda inginkan, berikut adalah langkah-langkah serta skrip dasar yang dapat Anda gunakan. Fitur yang diminta adalah sebagai berikut:

1. **Entry Buy** ketika MA35 (Moving Average periode 35) melewati MA82 (Moving Average periode 82) dari bawah ke atas.
2. **Entry Sell** ketika MA35 melewati MA82 dari atas ke bawah.
3. **Stop Loss** dan **Take Profit** disertakan untuk setiap trade.
4. EA ini hanya akan melakukan 1 kali open order per persilangan antara MA35 dan MA82.

### Skrip MQL5 untuk Expert Advisor

```mql5
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Set up the moving averages
   Print("EA Initialized");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("EA Deinitialized");
  }

//+------------------------------------------------------------------+
//| Expert tick function (main loop)                                 |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Define period and prices
   int fastMA = 35;   // Period of the fast MA (MA35)
   int slowMA = 82;   // Period of the slow MA (MA82)
   int maShift = 0;   // No shift

   double maFastCurrent, maFastPrevious;
   double maSlowCurrent, maSlowPrevious;
   
   // Get the current and previous values of MA35 and MA82
   maFastCurrent = iMA(Symbol(), PERIOD_M15, fastMA, maShift, MODE_SMA, PRICE_CLOSE, 0);
   maFastPrevious = iMA(Symbol(), PERIOD_M15, fastMA, maShift, MODE_SMA, PRICE_CLOSE, 1);
   
   maSlowCurrent = iMA(Symbol(), PERIOD_M15, slowMA, maShift, MODE_SMA, PRICE_CLOSE, 0);
   maSlowPrevious = iMA(Symbol(), PERIOD_M15, slowMA, maShift, MODE_SMA, PRICE_CLOSE, 1);

   // Check if there is already an open trade
   if (PositionsTotal() == 0)
   {
      // Buy condition: MA35 crosses above MA82
      if (maFastPrevious < maSlowPrevious && maFastCurrent > maSlowCurrent)
      {
         // Open a Buy order with stop loss and take profit
         double stopLoss = Ask - 200 * Point;  // 200 pips stop loss
         double takeProfit = Ask + 200 * Point; // 200 pips take profit
         OrderSend(Symbol(), OP_BUY, 0.1, Ask, 2, stopLoss, takeProfit, "Buy Order", 0, 0, Blue);
      }
      // Sell condition: MA35 crosses below MA82
      else if (maFastPrevious > maSlowPrevious && maFastCurrent < maSlowCurrent)
      {
         // Open a Sell order with stop loss and take profit
         double stopLoss = Bid + 200 * Point;  // 200 pips stop loss
         double takeProfit = Bid - 200 * Point; // 200 pips take profit
         OrderSend(Symbol(), OP_SELL, 0.1, Bid, 2, stopLoss, takeProfit, "Sell Order", 0, 0, Red);
      }
   }
  }
```

### Penjelasan Skrip
1. **OnInit()**: Fungsi ini dipanggil saat EA dimulai. Di sini, Anda dapat menambahkan pengaturan awal untuk EA, namun dalam skrip ini hanya mencetak pesan "EA Initialized".
   
2. **OnDeinit()**: Fungsi ini dipanggil ketika EA dihentikan. Anda bisa menambahkan perintah untuk membersihkan data atau menyimpan log jika diperlukan.

3. **OnTick()**: Fungsi utama yang dipanggil setiap kali ada pergerakan harga (tick). 
   - Skrip ini memonitor dua moving average (MA35 dan MA82) dengan menggunakan `iMA()` untuk mendapatkan nilai MA di periode M15.
   - Jika persilangan terjadi antara MA35 dan MA82, maka akan membuka posisi Buy atau Sell.
   - **Entry Buy** jika MA35 melewati MA82 dari bawah ke atas, dan **Entry Sell** jika MA35 melewati MA82 dari atas ke bawah.
   - Setiap posisi dilengkapi dengan Stop Loss dan Take Profit sebesar 200 pips.

4. **OrderSend()**: Digunakan untuk membuka order, baik Buy atau Sell, dengan Stop Loss dan Take Profit yang telah ditentukan.
Untuk menggunakan Expert Advisor (EA) di MetaTrader 5 (MT5), ikuti langkah-langkah berikut:

### 1. **Mempersiapkan MetaEditor dan Menyimpan EA**

1. **Buka MetaTrader 5**:
   - Jalankan MetaTrader 5 di komputer Anda.

2. **Buka MetaEditor**:
   - Di dalam MetaTrader 5, klik pada menu **"Tools"** > **"MetaEditor"** atau tekan **F4** pada keyboard untuk membuka MetaEditor.

3. **Buat File EA Baru**:
   - Di dalam MetaEditor, pilih **"File"** > **"New"**.
   - Pilih **"Expert Advisor (template)"** dan klik **Next**.
   - Berikan nama untuk EA Anda, misalnya "MA_Cross_Trade" dan klik **Finish**.

4. **Salin dan Tempel Kode EA**:
   - Setelah file EA baru terbuka, hapus kode default yang ada di file tersebut.
   - Salin kode yang saya berikan sebelumnya dan tempelkan di file EA yang baru.
   - Simpan file tersebut dengan menekan **Ctrl + S** atau klik **File** > **Save**.

5. **Komplikasi EA**:
   - Klik tombol **"Compile"** (atau tekan F7) di MetaEditor untuk mengkompilasi file EA. Jika tidak ada error, Anda akan melihat pesan "0 error(s), 0 warning(s)" di bagian bawah.
   
### 2. **Menambahkan EA ke MetaTrader 5**

1. **Pindah ke MetaTrader 5**:
   - Kembali ke aplikasi **MetaTrader 5**.

2. **Buka Navigator**:
   - Klik **"View"** > **"Navigator"** atau tekan **Ctrl + N** untuk membuka panel Navigator.
   - Di panel Navigator, Anda akan melihat folder **"Expert Advisors"**. Klik pada tanda **"+"** di sebelah folder tersebut untuk memperluas daftar Expert Advisors.

3. **Temukan EA yang Anda Buat**:
   - Anda akan melihat EA yang telah Anda buat (misalnya, "MA_Cross_Trade") di dalam daftar. Klik kanan pada nama EA tersebut dan pilih **"Attach to a chart"**.

4. **Pilih Pair dan Timeframe**:
   - Setelah Anda meng-attach EA ke chart, pilih simbol **XAUUSD** dan **Timeframe M15** (atau timeframe yang sesuai dengan kebutuhan Anda).
   - Pastikan di bawah grafik, pada bagian **"AutoTrading"** (pada toolbar atas), tombol ini berwarna hijau, yang menunjukkan bahwa EA siap untuk berjalan.

### 3. **Mengatur Stop Loss dan Take Profit**
- Dalam skrip yang saya berikan, sudah ada perhitungan untuk Stop Loss (200 pips) dan Take Profit (200 pips) pada setiap order.
- Anda tidak perlu mengatur manual karena EA sudah mengatur hal tersebut otomatis saat open order.

### 4. **Menjalankan EA**
- **Live Trading**: Setelah EA terpasang pada chart XAUUSD M15, EA akan otomatis memonitor persilangan antara MA35 dan MA82. Ketika kondisi untuk Buy atau Sell terpenuhi, EA akan membuka order sesuai aturan yang telah ditentukan.
  
### 5. **Monitoring dan Menutup EA**
- **Monitoring**: Anda dapat memonitor kinerja EA dan posisi trading yang dibuka di tab **"Trade"** di jendela Terminal (di bagian bawah MetaTrader 5).
- **Menutup EA**: Jika ingin menghentikan EA, Anda bisa klik kanan pada chart dan pilih **"Expert Advisors"** > **"Remove"**.

### 6. **Mengecek Log dan Debugging**
- Untuk memeriksa log atau jika terjadi masalah dengan EA, buka **"Journal"** di bagian bawah MetaTrader 5. Di sini Anda bisa melihat informasi tentang setiap order, error, atau peringatan.

### Catatan Tambahan:
- **AutoTrading** harus diaktifkan di MetaTrader 5 untuk EA dapat berfungsi.
- Jika Anda menjalankan EA pada akun demo terlebih dahulu, pastikan pengaturan **Lot Size** atau manajemen risiko sesuai dengan toleransi Anda untuk menghindari kerugian yang tidak terkontrol.


