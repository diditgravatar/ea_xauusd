# EA XAUUSD M15
Berikut adalah skrip dasar Expert Advisor (EA) untuk MetaTrader 5 yang mengikuti aturan yang Anda tentukan:

### **Fitur Utama:**
- **Entry Buy:** MA35 melewati MA82 dari bawah ke atas, dan harga bergerak 200 pip setelah persilangan sebelum entry.
- **Exit Buy:** MA35 melewati MA82 dari atas ke bawah.
- **Entry Sell:** MA35 melewati MA82 dari atas ke bawah, dan harga bergerak 200 pip setelah persilangan sebelum entry.
- **Exit Sell:** MA35 melewati MA82 dari bawah ke atas.
- **Hanya 1 open order per persilangan.**
- **Trading pada XAUUSD dengan timeframe M15.**

---

### **Kode EA untuk MetaTrader 5 (MQL5)**
```mql5
//+------------------------------------------------------------------+
//| Expert Advisor untuk XAUUSD M15 dengan MA35 & MA82               |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;

input int MA_Short = 35;
input int MA_Long = 82;
input int LotSize = 0.1; // untuk saldo $1000
input double PipBuffer = 200;  // 200 pip setelah persilangan

double previousMA_Short, previousMA_Long;
bool buyExecuted = false, sellExecuted = false;

//+------------------------------------------------------------------+
//| Hitung Moving Average                                           |
//+------------------------------------------------------------------+
double CalculateMA(int period, int shift)
{
   return iMA(Symbol(), PERIOD_M15, period, 0, MODE_SMA, PRICE_CLOSE, shift);
}

//+------------------------------------------------------------------+
//| Cek apakah ada posisi aktif                                     |
//+------------------------------------------------------------------+
bool PositionExists(int type)
{
   for (int i = 0; i < PositionsTotal(); i++)
   {
      if (PositionGetSymbol(i) == Symbol() && PositionGetInteger(POSITION_TYPE) == type)
         return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Fungsi utama EA                                                 |
//+------------------------------------------------------------------+
void OnTick()
{
   double currentMA_Short = CalculateMA(MA_Short, 0);
   double currentMA_Long = CalculateMA(MA_Long, 0);
   double prevPrice = iClose(Symbol(), PERIOD_M15, 1); // Harga sebelumnya
   double currentPrice = iClose(Symbol(), PERIOD_M15, 0); // Harga sekarang

   // ENTRY BUY
   if (previousMA_Short < previousMA_Long && currentMA_Short > currentMA_Long && !buyExecuted)
   {
      if (currentPrice >= prevPrice + PipBuffer * _Point && !PositionExists(ORDER_TYPE_BUY))
      {
         trade.Buy(LotSize, Symbol(), 0, 0, 0, "Buy XAUUSD");
         buyExecuted = true;
         sellExecuted = false;
      }
   }

   // EXIT BUY
   if (previousMA_Short > previousMA_Long && currentMA_Short < currentMA_Long && PositionExists(ORDER_TYPE_BUY))
   {
      trade.PositionClose(Symbol());
   }

   // ENTRY SELL
   if (previousMA_Short > previousMA_Long && currentMA_Short < currentMA_Long && !sellExecuted)
   {
      if (currentPrice <= prevPrice - PipBuffer * _Point && !PositionExists(ORDER_TYPE_SELL))
      {
         trade.Sell(LotSize, Symbol(), 0, 0, 0, "Sell XAUUSD");
         sellExecuted = true;
         buyExecuted = false;
      }
   }

   // EXIT SELL
   if (previousMA_Short < previousMA_Long && currentMA_Short > currentMA_Long && PositionExists(ORDER_TYPE_SELL))
   {
      trade.PositionClose(Symbol());
   }

   // Simpan nilai MA sebelumnya untuk perbandingan di tick berikutnya
   previousMA_Short = currentMA_Short;
   previousMA_Long = currentMA_Long;
}

//+------------------------------------------------------------------+
```

---

### **Cara Menggunakan EA di MetaTrader 5**
1. **Buka MetaTrader 5** dan masuk ke **MetaEditor** (`Ctrl+M` > `File` > `New` > `Expert Advisor`).
2. **Salin kode di atas** dan tempelkan di jendela editor.
3. **Kompilasi kode** (`F7`) dan pastikan tidak ada error.
4. **Tambahkan EA ke chart XAUUSD timeframe M15**.
5. **Jalankan auto trading** (aktifkan tombol "AutoTrading").

---

### **Penjelasan Kode**
- **CTrade trade;** → Digunakan untuk melakukan order buy/sell.
- **CalculateMA()** → Menghitung moving average (SMA) untuk MA35 dan MA82.
- **PositionExists()** → Mengecek apakah ada posisi aktif.
- **OnTick()** → Fungsi utama yang berjalan setiap kali ada perubahan harga (tick).
- **PipBuffer = 200** → EA hanya akan entry setelah harga bergerak 200 pip dari persilangan.

Silakan uji coba di akun demo terlebih dahulu sebelum digunakan di akun real.
