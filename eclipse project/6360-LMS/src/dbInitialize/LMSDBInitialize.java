package dbInitialize;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

public class LMSDBInitialize {
	
	public static void main(String[] args) {
		buildSQL();
		//executeSQL();
	}
	
	/**
	 * scan all the csv files to build the .sql files which contain SQL statements populating all the tables in the database
	 */
	private static void buildSQL() {
		useDB("data/sql/useDatabase.sql");
		
		initialBookAuthors("data/csv/books.csv", "data/sql/initialBook.sql", "data/sql/initialAuthors.sql", "data/sql/initialBookAuthors.sql");
		initialLibraryBranch("data/csv/library_branch.csv", "data/sql/initialLibraryBranch.sql");
		initialBookCopies("data/csv/book_copies.csv", "data/sql/initialBookCopies.sql");
		initialBorrowers("data/csv/borrowers.csv", "data/sql/initialBorrowers.sql");
		initialBookLoansFines("data/csv/book_loans.csv", "data/sql/initialBookLoans.sql", "data/sql/initialFines.sql");
	}
	
	/**
	 * create and populate the database
	 */
	/*
	private static void executeSQL() {
		Connection conn = null;
		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", "123");	// Create a connection to the local MySQL server, with the NO database selected
			Statement stmt = conn.createStatement(); // Create a SQL statement object to execute the query
			//stmt.executeUpdate("source data/sql/CreateSchema.sql");	// create database and schema
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}	
	}
	*/
	
	private static void useDB(String destinationFilePath) {
		PrintWriter writer = null;
		try {
			writer = new PrintWriter(new File(destinationFilePath));
			writer.println("USE Library_Management_System;");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (writer != null) {
				writer.close();
			}
		}
	}
	
	///!!!
	private static void initialBookAuthors(String sourceFilePath, String destinationFilePathBook, String destinationFilePathAuthors, String destinationFilePathBookAuthors) {
		Scanner sc = null;
		PrintWriter writerBook = null;
		PrintWriter writerAuthors = null;
		PrintWriter writerBookAuthors = null;
		try {
			sc = new Scanner(new File(sourceFilePath), "UTF-8");
			sc.useDelimiter("\t");
			writerBook = new PrintWriter(new File(destinationFilePathBook));
			writerAuthors = new PrintWriter(new File(destinationFilePathAuthors));
			writerBookAuthors = new PrintWriter(new File(destinationFilePathBookAuthors));
	        
	        sc.nextLine();	// content of first line is the attribute names
	        String[] currLine = null;
	        String cmdBook = null;
	        String cmdAuthors = null;
	        String cmdBookAuthors = null;
	        String[] fullNames = null;
	        int totalAuthorNum = 0;
	        int currAuthorId = 0;
	        LinkedHashMap<String, Integer> AuthorNameId = new LinkedHashMap<>();
	        
	        String title = null;
	        String fname = null;
	        String mname = null;
	        String lname = null;
	        String suffix = null;       
	        String bookTitle = null;
	        
	        while (sc.hasNextLine()) {	// scan the data
	            currLine = sc.nextLine().split("\t");
	            
	            // BOOK table
	            bookTitle = currLine[2].replace("\'", "\'\'");	// eliminate the influence of the apostrophe in the book title
	            cmdBook = "INSERT INTO BOOK VALUES ('" + currLine[0] + "','" + bookTitle + "');";
	            writerBook.println(cmdBook);
	            //writerBook.flush();
	            //System.out.println(cmdBook);
	            
	            fullNames = currLine[3].split(",");
	            for (String fullName : fullNames) {
	            	fullName = fullName.replace("\'", "\'\'");	// eliminate the influence of the apostrophe in author full name
	            	if (AuthorNameId.containsKey(fullName)) {	// the author is already added and has an id
	            		currAuthorId = AuthorNameId.get(fullName);
	            	} else {	// the author hasn't been added and has no id yet
	            		currAuthorId = ++totalAuthorNum;
	            		AuthorNameId.put(fullName, currAuthorId);
	            		// AUTHORS table
	            		///!!!!!!!!! this code below need to be modified to actually decompose the full name
	            		title = "NULL";
	            		fname = "NULL";
	            		mname = "NULL";
	            		lname = "NULL";
	            		suffix = "NULL";
	            		cmdAuthors = "INSERT INTO AUTHORS VALUES ('" + currAuthorId + "','" + fullName + "','" + title + "','" + fname + "','" + mname + "','" + lname + "','" + suffix + "');";
	            		writerAuthors.println(cmdAuthors);
	            	}
	            	// BOOK_AUTHORS table
	            	cmdBookAuthors = "INSERT INTO BOOK_AUTHORS VALUES ('" + currLine[0] + "','" + currAuthorId + "');";
	            	writerBookAuthors.println(cmdBookAuthors);
	            }
	        }
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (sc != null) {
				sc.close();
			}
			if (writerBook != null) {
				writerBook.close();
			}
			if (writerAuthors != null) {
				writerAuthors.close();
			}
			if (writerBookAuthors != null) {
				writerBookAuthors.close();
			}
		}
	}
	
	private static void initialLibraryBranch(String sourceFilePath, String destinationFilePath) {
		Scanner sc = null;
		PrintWriter writer = null;
		try {
			sc = new Scanner(new File(sourceFilePath));
			sc.useDelimiter("\t");
			writer = new PrintWriter(new File(destinationFilePath));
	        
	        sc.nextLine();	// content of first line is the attribute names
	        String[] currLine = null;
	        String cmd = null;
	        while (sc.hasNextLine()) {	// scan the data
	            currLine = sc.nextLine().split("\t");
	            cmd = "INSERT INTO LIBRARY_BRANCH VALUES ('" + currLine[0] + "','" + currLine[1] + "','" + currLine[2] + "');";
	            writer.println(cmd);
	        }
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (sc != null) {
				sc.close();
			}
			if (writer != null) {
				writer.close();
			}
		}
	}
	
	private static void initialBookCopies(String sourceFilePath, String destinationFilePath) {
		Scanner sc = null;
		PrintWriter writer = null;
		try {
			sc = new Scanner(new File(sourceFilePath));
			sc.useDelimiter("\t");
			writer = new PrintWriter(new File(destinationFilePath));
	        
	        sc.nextLine();	// content of first line is the attribute names
	        String[] currLine = null;
	        String cmd = null;
	        while (sc.hasNextLine()) {	// scan the data
	            currLine = sc.nextLine().split("\t");
	            cmd = "INSERT INTO BOOK_COPIES VALUES ('" + currLine[0] + "','" + currLine[1] + "','" + currLine[2] + "');";
	            writer.println(cmd);
	        }
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (sc != null) {
				sc.close();
			}
			if (writer != null) {
				writer.close();
			}
		}
	}
	
	private static void initialBorrowers(String sourceFilePath, String destinationFilePath) {
		Scanner sc = null;
		PrintWriter writer = null;
		try {
			sc = new Scanner(new File(sourceFilePath));
			sc.useDelimiter(",");
			writer = new PrintWriter(new File(destinationFilePath));
	        
	        sc.nextLine();	// content of first line is the attribute names
	        String[] currLine = null;
	        String cmd = null;
	        while (sc.hasNextLine()) {	// scan the data
	            currLine = sc.nextLine().split(",");
	            cmd = "INSERT INTO BORROWER VALUES ('" + currLine[0] + "','" + currLine[1] + "','" + currLine[2]  + "','" + currLine[3] + "','";	// add Card_no, Ssn, Fname, Lname
	            cmd = cmd + currLine[5] + ", " + currLine[6] + ", " + currLine[7] + "','";	// add address
	            cmd = cmd + currLine[8] + "');";	// add phone
	            writer.println(cmd);
	        }
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (sc != null) {
				sc.close();
			}
			if (writer != null) {
				writer.close();
			}
		}
	}
	
	/**
	 * calculate the time difference in days between endDay and startDay 
	 * @param startDay with format "yyyy-MM-dd"
	 * @param endDay with format "yyyy-MM-dd"
	 * @return
	 */
	private static long dayDifference(String startDay, String endDay) {
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
	private static long dayDifference(String startDay) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String dayNow = format.format(new Date());
		return dayDifference(startDay, dayNow);
	}
	
	private static void initialBookLoansFines(String sourceFilePath, String destinationFilePath, String destinationFilePathFine) {
		Scanner sc = null;
		PrintWriter writer = null;
		PrintWriter writerFine = null;
		try {
			sc = new Scanner(new File(sourceFilePath));
			sc.useDelimiter("\t");
			writer = new PrintWriter(new File(destinationFilePath));
			writerFine = new PrintWriter(new File(destinationFilePathFine));
	        
			// this csv file contains only data, i.e. there's no attribute name at the first line
	        String[] currLine = null;
	        String cmd = null;
	        String cmdFine = "";
	        double fine;
            String paid = "";
            DecimalFormat df = new DecimalFormat("0.00");
	        while (sc.hasNextLine()) {	// scan the data
	            currLine = sc.nextLine().split("\t");
	            cmd = "INSERT INTO BOOK_LOANS VALUES ('" + currLine[0] + "','" + currLine[1] + "','" + currLine[2] + "','" + currLine[3] + "','" + currLine[4]  + "','" + currLine[5]  + "','" + currLine[6] + "');";
	            writer.println(cmd);

	            fine = 0;
	            if (!currLine[6].equalsIgnoreCase("NULL")) {	// the book has been returned
	            	long diffDay = dayDifference(currLine[5], currLine[6]);
	            	if (diffDay > 0) {	// the book wasn't returned in time
	            		fine = diffDay * 0.25;
	            		paid = "1";
	            	}
	            } else {	// the book haven't been returned
	            	long diffDay = dayDifference(currLine[5]);
	            	if (diffDay > 0) {	// the due date is passed
	            		fine = diffDay * 0.25;
	            		paid = "0";
	            	}
	            }
	            if (fine > 0.0) {	// there's a fine for this book loan
	            	cmdFine = "INSERT INTO FINES VALUES ('" + currLine[0] + "','" + df.format(fine) + "','" + paid + "');";
	            	writerFine.println(cmdFine);
	            }
	        }
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (sc != null) {
				sc.close();
			}
			if (writer != null) {
				writer.close();
			}
			if (writerFine != null) {
				writerFine.close();
			}
		}
	}
}
