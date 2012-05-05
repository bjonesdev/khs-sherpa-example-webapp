package com.khs.example.endpoints;

import java.io.InputStreamReader;
import java.net.URL;

import com.khs.sherpa.annotation.Endpoint;
import com.khs.sherpa.annotation.Param;

@Endpoint(authenticated = false)
public class StockService {

	private final String YAHOO_FINANCE_URL = "http://finance.yahoo.com/d/quotes.csv?";
	private final String PARAMS = "snd1l1yrj1";
	private final String TICKERS = "s=XOM+JNJ+MSFT+GOOG+GE+INTC+AAPL+ORCL+VMW+CSCO";
	private final static String NA = "N/A";

	static class Stock {
		public String ticker;
		public String name;
		public String tradeDate;
		public float price;
		public float dividendYield;
		public float pe;
	}

	public Stock quote(@Param(name = "ticker") String ticker) {

		String content = "";
		try {
			URL url = new URL(YAHOO_FINANCE_URL + "s=" + ticker + "&f=" + PARAMS);
			InputStreamReader in = new InputStreamReader(url.openStream());
			int c;
			while ((c = in.read()) > 0) {
				content = content + (char) c;
			}

		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		// parse csv result format
		String rows[] = content.split("\r\n");
		Stock stock = new Stock();
		for (String value : rows) {
			String[] values = value.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
			if (values[5].equals(NA)) {
				break;
			}
			stock = new Stock();
			stock.ticker = values[0].replaceAll("\"", "");
			stock.name = values[1].replaceAll("\"", "");
			stock.tradeDate = values[2].replaceAll("\"", "");
			stock.price = new Float(values[3]);
			stock.dividendYield = values[4].equals(NA) ? 0.0f : new Float(values[4]);
			stock.pe = new Float(values[5]);
			return stock;

		}

		stock.ticker = "Ticker " + ticker + " not found";

		return stock;
	}
	
	
}
