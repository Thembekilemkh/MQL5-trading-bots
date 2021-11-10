#include<Trade\Trade.mqh>
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
     string signal = "";
     return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      exitTrades();   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    //Fetch a siganl
    signal = checkEntry();
    
    // Validate the signal
    if (signal == "buy")
    {
      // Place a buy trade
      placeBuy();
      
    }
    else if (signal == "sell")
    {
      // Place a sell trade
      placeSell();
    }
    
    // Check if there are any open trades 
    if (PositionsTotal()>0)
    {
      // Check if it's time to exit thee trades
      
    }
   
  }
//+------------------------------------------------------------------+

void placeBuy()
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
         /*// Configure stop loss
         double devi = 2.5;
         double buyStop = buySL(devi);
         
         // configure take profit
         double dev = 2;
         string first = "first";
         string second = "second";
         double buyfirstTake = buyTP(dev, first);
         double buysecondTake = buyTP(dev, second);
         
         // place a buy trade
         trade.Buy(0.01, NULL, Ask, buyStop, buyfirstTake, NULL);
         trade.Buy(0.01, NULL, Ask, buyStop, buysecondTake, NULL);*/
         trade.Buy(0.01, NULL, Ask, (Bid-75*_Point), (Ask+100*_Point), NULL);
         
      }
}

void placeSell()
{
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
         /*double devi = 3;
         double sellStop = sellSL(devi);
         
         // configure take profit
         double dev = 2;
         string first = "first";
         string second = "second";
         double sellfirstTake = sellTP(dev, first);
         double sellsecondTake = sellTP(dev, second);
         
         // place a buy trade
         trade.Sell(0.01, NULL, Ask, sellStop, sellfirstTake, NULL);
         trade.Sell(0.01, NULL, Ask, sellStop, sellsecondTake, NULL);
         
         //trade.Sell(volume,_symbol,price,stop_loss, takeprofit, comment);*/
         trade.Sell(0.01, NULL, Ask, (Bid+75*_Point), (Ask-100*_Point), NULL);
         
         
      }
}

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
   
   // create a 1 period moving average
   double mid1[];
   
   // Sort
   ArraySetAsSeries(mid1, true);
   
   // A (1) deviation moving average lower and upper band
   double devlower1[];
   double devUpper1[]; 
   
   // Sort array
   ArraySetAsSeries(devlower1, true);
   ArraySetAsSeries(devUpper1, true); 
    
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
   int BollingerBands1=iBands(_Symbol, _Period, 1, 0, 2, PRICE_CLOSE);
   int BollingerBandsDev1=iBands(_Symbol, _Period, 20, 0, 1, PRICE_CLOSE);
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, 2, PRICE_CLOSE);
   int BollingerBands200=iBands(_Symbol, _Period, 200, 0, 2, PRICE_CLOSE);
   
   CopyBuffer(BollingerBands1, 0,0,3, mid1);
   
   CopyBuffer(BollingerBandsDev1,2,0,3, devlower1);
   CopyBuffer(BollingerBandsDev1,2,0,3, devUpper1);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands20,0,0,3, middleband);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   CopyBuffer(BollingerBands200,0,0,3, mid200);
   
   // Get the current value
   double currMidBand = middleband[0];
   double currUpBand = upperband[0];
   double currLowBand = lowerband[0];
   
   //Get the current value
   double prevMidBand = middleband[1];
   double prevUpBand = upperband[1];
   double prevLowBand = lowerband[1];
   
   double currMid200 = mid200[0];
   
   if (PriceInfo[0].close > currMid200)
   {
      if (mid1[0] > devlower1[0])
      {
         {signal="buy";}
      }
   }
   else if(PriceInfo[0].close < currMid200)
   {
      // Only looking for sell
      if (mid1[0] < devUpper1[0])
      {
         {signal="sell";}
      }
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
   double mid1[];
   double upperband[];
   double lowerband[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(mid1, true);
   ArraySetAsSeries(upperband, true);
   ArraySetAsSeries(lowerband, true);
   
   // Define the bollinger bands20
   int BollingerBands1=iBands(_Symbol, _Period, 1, 0, 1, PRICE_CLOSE);
   int BollingerBands20=iBands(_Symbol, _Period, 20, 0, 1, PRICE_CLOSE);
   
   // Copy prices into the arrays 
   CopyBuffer(BollingerBands1,0,0,3, mid1);
   CopyBuffer(BollingerBands20,1,0,3, upperband);
   CopyBuffer(BollingerBands20,2,0,3, lowerband);
   
   // Only looking for sells
   if (currentOpen == "buy")
   {
      if(mid1[0] < lowerband[0])
      {exitTrades();}
   }
   else if (currentOpen == "sell")
   {
      if(mid1[0] > upperband[0])
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
