package dbHostApp;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

public class dataProcess {
	
	/**
	 * calculate the time difference in days between endDay and startDay 
	 * @param startDay with format "yyyy-MM-dd"
	 * @param endDay with format "yyyy-MM-dd"
	 * @return
	 */
	public static long dayDifference(String startDay, String endDay) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		long diffDay = 0;
		try {
			Date d1 = format.parse(startDay);
			Date d2 = format.parse(endDay);
	        long diffMilliSec = d2.getTime() - d1.getTime();
	        diffDay = TimeUnit.MILLISECONDS.toDays(diffMilliSec);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return diffDay;
	}
	
	/**
	 * calculate the time difference in days between the current date and the startDay
	 * @param startDay
	 * @return
	 */
	public static long dayDifference(String startDay) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String dayNow = format.format(new Date());
		return dayDifference(startDay, dayNow);
	}
}
