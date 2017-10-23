/* Run this script to create the Library Management System database and create schema. */

-- create database
CREATE DATABASE Library_Management_System DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

USE Library_Management_System;

-- create schema
CREATE TABLE BOOK ( 
	Isbn CHAR(10) NOT NULL,
	Title VARCHAR(200) NOT NULL,
	CONSTRAINT pk_book PRIMARY KEY (Isbn)
);

CREATE TABLE AUTHORS ( 
	Author_id INT NOT NULL,
	Fullname VARCHAR(50) NOT NULL,
	Title VARCHAR(10),
	Fname VARCHAR(15),
	Mname VARCHAR(15),
	Lname VARCHAR(15) NOT NULL,
	Suffix VARCHAR(15),
	CONSTRAINT pk_authors PRIMARY KEY (Author_id)
);

CREATE TABLE BOOK_AUTHORS ( 
	Isbn CHAR(10) NOT NULL,
	Author_id INT NOT NULL,
	CONSTRAINT pk_book_authors PRIMARY KEY (Isbn, Author_id),
	CONSTRAINT fk_book_authors_authors FOREIGN KEY (Author_id) REFERENCES AUTHORS (Author_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_book_authors_book FOREIGN KEY (Isbn) REFERENCES BOOK (Isbn) ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE LIBRARY_BRANCH ( 
	Branch_id INT NOT NULL,
	Branch_name VARCHAR(20) NOT NULL,
	Address VARCHAR(40) NOT NULL,
	CONSTRAINT pk_library_branch PRIMARY KEY (Branch_id) 
);

CREATE TABLE BOOK_COPIES ( 
	Book_id CHAR(10) NOT NULL,
	Branch_id INT NOT NULL,
	No_Of_Copies INT NOT NULL,
	CONSTRAINT pk_book_copies PRIMARY KEY (Book_id, Branch_id),
	CONSTRAINT fk_book_copies_book FOREIGN KEY (Book_id) REFERENCES BOOK (Isbn) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_book_copies_library_branch FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH (Branch_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE BORROWER ( 
	Card_no CHAR(8) NOT NULL,
	Ssn CHAR(11) NOT NULL,
	Fname VARCHAR(15) NOT NULL,
	Lname VARCHAR(15) NOT NULL,
	Address VARCHAR(200) NOT NULL,
	Phone CHAR(14) NOT NULL,
	CONSTRAINT pk_borrower PRIMARY KEY (Card_no),
	CONSTRAINT uk_borrower UNIQUE (Ssn)
);

CREATE TABLE BOOK_LOANS ( 
	Loan_id INT NOT NULL,
	Isbn CHAR(10) NOT NULL,
	Branch_id INT NOT NULL,
	Card_no CHAR(8) NOT NULL,
	Date_out DATE NOT NULL,
	Due_date DATE NOT NULL,
	Date_in DATE,
	CONSTRAINT pk_book_loans PRIMARY KEY (Loan_id),
	CONSTRAINT fk_book_loans_book FOREIGN KEY (Isbn) REFERENCES BOOK (Isbn) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_book_loans_library_branch FOREIGN KEY (Branch_id) REFERENCES LIBRARY_BRANCH (Branch_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_book_loans_borrower FOREIGN KEY (Card_no) REFERENCES BORROWER (Card_no) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FINES (
	Loan_id INT NOT NULL,
	fine_amt DECIMAL(6,2) NOT NULL,
	paid BOOLEAN NOT NULL,
	CONSTRAINT pk_fines PRIMARY KEY (Loan_id),
	CONSTRAINT fk_fines_book_loans FOREIGN KEY (Loan_id) REFERENCES BOOK_LOANS (Loan_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- populate the database

