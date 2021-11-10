//+------------------------------------------------------------------+
//|                                                MeanReversion.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

#include<Trade\Trade.mqh>
CTrade trade;

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      // check exit
   if (PositionsTotal()> 0)
   {
      exitTrades();
   }
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Check for a valid entry
   string signal = checkEntry();
   
   // Place a trade if valid
   if (signal == "buy")
   {
      // place a buy trade
      // Get the ask price
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
      double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
      
      // Get your accout balance
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      
      // Get your equity
      double equity = AccountInfoDouble(ACCOUNT_EQUITY);
      
      if (equity >= balance)
      {
         trade.Buy(0.01, NULL, Ask, (Bid-75*_Point), (Ask+100*_Point), NULL);
         
      }
   }
   else if (signal == "sell")
   {
      //Place a sell tarde
      // Get the ask price
      double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
      double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
      
      // Get your accout balance
      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      
      // Get your equity
      double equity = AccountInfoDouble(ACCOUNT_EQUITY);
      
      if (equity >= balance)
      {
         // Configure stop loss
         /**/ //(0.01, NULL, Ask, buyStop, buysecondTake, NULL)
         trade.Sell(0.01, NULL, Ask, (Bid+75*_Point), (Ask-100*_Point), NULL);
         
         
      }
   }
   else
   {Comment(signal);}
   
   
   // check exit
   if (PositionsTotal()> 0)
   {
      checkTPExit(signal);
      checkSLExit(signal);
   }
  }
//+------------------------------------------------------------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------------------------------------------------------------------------------------+
double buySL(double dev)
{
   //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   // Craete our return value
   double stopLoss;
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, dev, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   stopLoss = lowerband[0];
   return stopLoss;
}


double buyTP(double dev, string num)
{
   //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   // Craete our return value
   double takeProfit;
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, dev, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   if (num == "first")
   {
      takeProfit = middleband[0];
   }
   else if (num == "second")
   {
      takeProfit = upperband[0];
   }
   
   return takeProfit;
}

//+------------------------------------------------------------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------------------------------------------------------------------------------------+

double sellSL(double dev)
{
   //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   // Craete our return value
   double stopLoss;
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, dev, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   stopLoss = upperband[0];
   return stopLoss;
}

double sellTP(double dev, string num)
{
   //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   // Craete our return value
   double takeProfit;
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, dev, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   if (num == "first")
   {takeProfit = middleband[0];}
   else if (num == "second")
   {takeProfit = lowerband[0];}
   
   return takeProfit;
}

//+------------------------------------------------------------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------------------------------------------------------------------------------------+

string checkEntry()
{
   //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   // Craete our return value
   string signal = "";
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   // Get the middle line of the band(200)
   double mid200[];
   
   // Sort
   ArraySetAsSeries(mid200, true);
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, 2, PRICE_CLOSE);
   int MA200=iMA(_Symbol, _Period, MA1Per, 0, MODE_SMA, PRICE_MEDIAN)
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   CopyBuffer(MA200,0,0,3, mid200);
   
   // Get the current value
   double currMidBand = middleband[0];
   double currUpBand = upperband[0];
   double currLowBand = lowerband[0];
   
   //Get the current value
   double prevMidBand = middleband[1];
   double prevUpBand = upperband[1];
   double prevLowBand = lowerband[1];
   
   // Get the current value
   double currMid200 = mid200[0];
   
   //  Check the trend
   if (PriceInfo[0].close > currMid200)
   {
      // Only looking for buys
      if((PriceInfo[1].close > prevLowBand)&&(PriceInfo[0].close < currLowBand))
      {signal="buy";}
   }
   // 
   else if(PriceInfo[0].close < currMid200)
   {
      // Only looking for sell
      if((PriceInfo[1].close < prevUpBand)&&(PriceInfo[0].close > currUpBand))
      {signal="sell";}
   }
   else
   {
      signal = "no dice";
   }
   
   return signal;
   
}

void checkTPExit(string currentOpen)
{
   //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, 1, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   // Only looking for sells
   if (currentOpen == "buy")
   {
      if(PriceInfo[0].close > upperband[0])
      {exitTrades();}
   }
   else if (currentOpen == "sell")
   {
      if(PriceInfo[0].close < lowerband[0])
      {exitTrades();}
   } 
 
}

void exitTrades()
{

      // close positions
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
      int ticket = PositionGetTicket(i);
      trade.PositionClose(i);
   }
   
}

void checkSLExit(string currentOpen)
{
      //Create an arrya for prices
   MqlRates PriceInfo[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo, true);
   
   // Fill the array twith price data
   //int Data = CopyRates(Symbol(), Period(), 0, 3, PriceInfo);
   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(),Period()), PriceInfo); 
   
   
   // Create an array of our bollinger lines
   double middleband[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(middleband, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   // Define the bollinger bands20
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, 3, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   // Only looking for sells
   if (currentOpen == "buy")
   {
      if(PriceInfo[0].close < lowerband[0])
      {exitTrades();}
   }
   else if (currentOpen == "sell")
   {
      if(PriceInfo[0].close > upperband[0])
      {exitTrades();}
   } 
}

void loop_trades()
{
     for (int i=PositionsTotal()-1; i>=0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         ENUM_POSITION_TYPE position = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
         double volume = PositionGetDouble(POSITION_VOLUME);
         double profit = PositionGetDouble(POSITION_PROFIT);
         double openprice = PositionGetDouble(POSITION_PRICE_OPEN);
         Print ("Ticket = ", ticket, ", Type = ", EnumToString(position), ", Volume = ", volume, ", Profit = ", profit);
         
         if (position==POSITION_TYPE_BUY)
            trade.PositionModify(ticket,openprice-100*_Point,openprice+200*_Point);
         
         if (position==POSITION_TYPE_SELL)
            trade.PositionModify(ticket,openprice+100*_Point,openprice-200*_Point);
      }
}
//+------------------------------------------------------------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------------------------------------------------------------------------------------+