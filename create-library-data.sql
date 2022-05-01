DROP DATABASE IF EXISTS LIBRARYDB;

CREATE DATABASE LIBRARYDB;

USE LIBRARYDB;

CREATE TABLE BOOK(ISBN CHAR(20) NOT NULL, Title VARCHAR(500) NOT NULL);
LOAD DATA LOCAL INFILE 'books.csv' INTO TABLE BOOK FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 1 LINES (@col1,@col2,@col3,@col4,@col5,@col6,@col7) set ISBN=@col1 , Title = @col3;
ALTER TABLE BOOK ADD UNIQUE INDEX id_index(ISBN);

CREATE TABLE AUTHORS(Author_ID INT(11) NOT NULL AUTO_INCREMENT, Fullname VARCHAR(255) NOT NULL, PRIMARY KEY(Author_ID));
LOAD DATA LOCAL INFILE 'books.csv' INTO TABLE AUTHORS FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 1 LINES (@col1,@col2,@col3,@col4,@col5,@col6,@col7) set Fullname=@col4;

CREATE TABLE BOOK_AUTHORS
(
ISBN VARCHAR(13) NOT NULL,
AUTHOR_ID INT(11) NOT NULL AUTO_INCREMENT,
constraint BOOK_AUTHORS_PK
PRIMARY KEY(ISBN, AUTHOR_ID),
CONSTRAINT BOOK_AUTHORS_FK1
FOREIGN KEY(ISBN)
REFERENCES BOOK(ISBN)
ON UPDATE CASCADE
ON DELETE CASCADE,
constraint BOOK_AUTHORS_FK2
FOREIGN KEY(AUTHOR_ID)
REFERENCES AUTHORS(AUTHOR_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);
set foreign_key_checks = 0;
LOAD DATA LOCAL INFILE 'books.csv' INTO TABLE BOOK_AUTHORS FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 1 LINES (@col1,@col2,@col3,@col4,@col5,@col6,@col7) set ISBN=@col1;
set foreign_key_checks = 1;

CREATE TABLE BORROWERS(Card_no VARCHAR(20) NOT NULL, SSN VARCHAR(11) NOT NULL,Fname VARCHAR(20) NOT NULL, Lname VARCHAR(20) NOT NULL, Address VARCHAR(255) NOT NULL, Phone CHAR(20) NOT NULL,PRIMARY KEY(Card_no));
LOAD DATA LOCAL INFILE 'borrowers.csv' INTO TABLE BORROWERS FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9) set Card_no=@col1 ,SSN=@col2, Fname = @col3 , Lname = @col4, Address = CONCAT(@col6,@col7,@col8) , Phone = @col9;

CREATE TABLE BOOK_LOANS(Loan_Id INT(11) NOT NULL AUTO_INCREMENT, ISBN CHAR(20) NOT NULL, Card_no VARCHAR(20) NOT NULL, Date_out datetime, Due_date datetime, Date_in datetime, PRIMARY KEY(Loan_id));
ALTER TABLE BOOK_LOANS ADD CONSTRAINT id_fkA FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN);
ALTER TABLE BOOK_LOANS ADD CONSTRAINT id_fkC FOREIGN KEY (Card_no) REFERENCES BORROWERS(Card_no);

CREATE TABLE FINES(Loan_id INT(11),fine_amt DECIMAL(5,2),paid BOOLEAN);
ALTER TABLE FINES ADD CONSTRAINT id_fkD FOREIGN KEY (loan_id) REFERENCES BOOK_LOANS(loan_id);
