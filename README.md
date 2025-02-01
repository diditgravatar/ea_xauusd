# Robot Trading XAUUSD Timeframe M15 
berikut adalah robot trading xauusd otomatis berjalan dengan metatrader5.

### **Fitur fitur yang diberikan:**
   1. **Entry Buy jika MA35 melewati MA82 dari bawah ke atas sampai 200pip Entry Buy baru di eksekusi**
   2. **Entry Sell jika MA35 melewati MA82 dari atas kebawah sampai jarak 200pip.**
   3. **Terdapat fitur stop loss , take profit dan lotSize.**
   4. **Eksekusi open order 1 x open order dalam satu persilangan antara MA35 dan MA82**


---

### **Script EA MetaTrader 5 (XAUUSD_MA_Cross.mq5)**
```mq5
//+------------------------------------------------------------------+
//| Expert Advisor for XAUUSD on M15                                 |
//| Entry conditions based on MA35 and MA82 crossings               |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

CTrade trade;

// Input Parameters
input int MA_Short_Period = 35;
input int MA_Long_Period = 82;
input double LotSize = 0.1;
input double StopLoss = 500;   // 50 pips
input double TakeProfit = 1000; // 100 pips
input int MA_Distance_Threshold = 200; // 20 pips
input ENUM_TIMEFRAMES Timeframe = PERIOD_M15;

// Global Variables
bool hasTraded = false;
int lastTradeDirection = 0; // 1 = Buy, -1 = Sell, 0 = None

//+------------------------------------------------------------------+
//| Calculate Moving Average                                        |
//+------------------------------------------------------------------+
double GetMA(int period, int shift)
{
    return iMA(Symbol(), Timeframe, period, 0, MODE_SMA, PRICE_CLOSE, shift);
}

//+------------------------------------------------------------------+
//| Check if there is an open order                                 |
//+------------------------------------------------------------------+
bool OrderExists()
{
    for (int i = 0; i < PositionsTotal(); i++)
    {
        if (PositionGetSymbol(i) == Symbol())
            return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Check Trade Conditions                                          |
//+------------------------------------------------------------------+
void CheckTradeConditions()
{
    double ma35_current = GetMA(MA_Short_Period, 0);
    double ma82_current = GetMA(MA_Long_Period, 0);
    double ma35_prev = GetMA(MA_Short_Period, 1);
    double ma82_prev = GetMA(MA_Long_Period, 1);
    
    double distance = MathAbs(ma35_current - ma82_current) / _Point;

    if (distance >= MA_Distance_Threshold && !OrderExists()) 
    {
        if (ma35_prev < ma82_prev && ma35_current > ma82_current) // Bullish Cross
        {
            if (!hasTraded || lastTradeDirection != 1) 
            {
                trade.Buy(LotSize, Symbol(), 0, StopLoss * _Point, TakeProfit * _Point);
                hasTraded = true;
                lastTradeDirection = 1;
            }
        } 
        else if (ma35_prev > ma82_prev && ma35_current < ma82_current) // Bearish Cross
        {
            if (!hasTraded || lastTradeDirection != -1) 
            {
                trade.Sell(LotSize, Symbol(), 0, StopLoss * _Point, TakeProfit * _Point);
                hasTraded = true;
                lastTradeDirection = -1;
            }
        }
    }

    // Reset trade flag when no active orders
    if (!OrderExists()) hasTraded = false;
}

//+------------------------------------------------------------------+
//| Expert initialization function                                  |
//+------------------------------------------------------------------+
int OnInit()
{
    hasTraded = false;
    lastTradeDirection = 0;
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert tick function                                            |
//+------------------------------------------------------------------+
void OnTick()
{
    CheckTradeConditions();
}
```

---

### **Cara Menggunakan di MetaTrader 5:**
1. **Buka MetaTrader 5** → Navigasi ke **File > Open Data Folder**.  
2. Masuk ke folder **`MQL5/Experts/`** lalu **buat file baru** dengan nama **`XAUUSD_MA_Cross.mq5`**.  
3. **Copy-paste script di atas** ke dalam file tersebut.  
4. **Buka MetaEditor**, lalu **compile** script.  
5. **Buka MetaTrader 5**, pasang EA di chart **XAUUSD, Timeframe M15**.  
6. Pastikan **AutoTrading aktif** agar robot dapat melakukan eksekusi order.  

---

### **Penjelasan Fitur:**
✅ **Satu Order per Persilangan**  
✅ **Hanya Eksekusi Jika Jarak MA ≥ 200 Pips**  
✅ **Stop Loss, Take Profit, dan Lot Size Bisa Dikonfigurasi**  
✅ **Mendeteksi Order Aktif dan Menunggu Persilangan Baru**  

### **Penjelasan Uji Robot**
   1. **Silahkan download atau copy paste script diatas**
   2. **Simpan di file_anda.mq5**
   3. **Silahkan pasang robot tersebut di metatrader5 serta aktifkan auto trading**
   4. **Ujicoba diakun demo apakah robot trading bisakah diandalkan**
   5. **Di sarankan pemakaian robot ini di layanan vps agar bekerja dalam 24x7 hari atau nonstop.**

### **Tujuan Pembuatan EA ini:**
 1. **Untuk mendapatkan take profit pada setiap open order yang dieksekusi oleh EA ini di dalam trading XAUUSD Timeframe M15.**
 2. **Author By Didit Farafat ingin mengembangkan Robot Trading Otomatis khusus untuk XAUUSD.**

