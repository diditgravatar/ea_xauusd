
//+------------------------------------------------------------------+
//| Expert Advisor for XAUUSD on M15                                 |
//| Author Didit Farafat                                             |
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
