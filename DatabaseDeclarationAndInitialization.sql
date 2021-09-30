/*
======================
     CREATE TABLE
======================
If there any error appear, change the staff table name
*/

--Membership Type Table
CREATE TABLE membership_type (
	membership_type_id VARCHAR(10) NOT NULL,
	membership_type_name VARCHAR(10) NOT NULL,
	membership_loan_max_amount NUMBER(10) NOT NULL,
	membership_loan_max_day NUMBER(10) NOT NULL,
	book_reservation_max_amount NUMBER(10) NOT NULL,
	room_reservation_max_duration NUMBER(4,2) NOT NULL,
	membership_price NUMBER(4,2) NOT NULL,
	PRIMARY KEY (membership_type_id)
);

--Membership Table
CREATE TABLE membership (
	member_id VARCHAR(10) NOT NULL,
	member_name VARCHAR(30) NOT NULL,
	member_join_date DATE NOT NULL,
	member_ic VARCHAR(15) NOT NULL,
	member_gender CHAR(2) NOT NULL,
	member_phone_number VARCHAR(13) NOT NULL,
	member_email VARCHAR(30) NOT NULL,
	membership_type_id VARCHAR(5) NOT NULL,
	PRIMARY KEY (member_id)
);

--Staff Table
CREATE TABLE staff (
	staff_id VARCHAR(5) NOT NULL,
	staff_name VARCHAR(30) NOT NULL,
	staff_join_date DATE NOT NULL,
	staff_email VARCHAR(30) NOT NULL,
	staff_gender CHAR(2) NOT NULL,
	staff_password VARCHAR(30) NOT NULL,
	staff_ic VARCHAR(20) NOT NULL,
	staff_phone_number VARCHAR(15) NOT NULL,
	PRIMARY KEY (staff_id)
);

--Room Table
CREATE TABLE room (
    room_id varchar(10) NOT NULL,
    room_type varchar(2) NOT NULL,
    room_building varchar(20) NOT NULL,
    room_floor char(2) NOT NULL,
    room_no varchar(3) NOT NULL,
    min_mem NUMBER(3) DEFAULT 1 CHECK (min_mem >= 1),
    max_mem NUMBER(3) DEFAULT 1 CHECK (max_mem >= 1),
    room_price NUMBER(6,2) DEFAULT 0 CHECK (room_price >= 0),
    PRIMARY KEY (room_id)
);

--Reservation Table
CREATE TABLE reservation (
	reservation_id varchar(15) NOT NULL,
	reserve_type varchar(4) NOT NULL,
	requested_date date NOT NULL,
	member_id varchar(10) NOT NULL,
	reserve_method varchar(25) NOT NULL,
	staff_id varchar(5) NOT NULL,
	remarks varchar(35),
	status varchar(10) DEFAULT 'Pending' NOT NULL,
	PRIMARY KEY (reservation_id),
	FOREIGN KEY (member_id) REFERENCES membership (member_id),
	FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

--Room Reservation Table
CREATE TABLE room_reservation (
	reservation_id varchar(13) NOT NULL,
	room_id varchar(9) NOT NULL,
	reservation_desc varchar(30) NOT NULL,
	reserved_start_time Date NOT NULL,
	duration NUMBER(5) NOT NULL CHECK (duration >= 0),
	reserved_checkout_time Date NOT NULL,
	room_users NUMBER(3) DEFAULT 1 CHECK (room_users >= 1),
	total_costs NUMBER(6,2) DEFAULT 0 CHECK (total_costs >= 0),
	PRIMARY KEY (reservation_id,room_id),
	FOREIGN KEY (reservation_id) REFERENCES reservation (reservation_id),
	FOREIGN KEY (room_id) REFERENCES room (room_id)
);

--Book Category Table
CREATE TABLE book_category (
	category_id varchar(4) NOT NULL,
	category_name varchar(30) NOT NULL,
	latest_update date NOT NULL,
	PRIMARY KEY (category_id)
);

--Author Table
CREATE TABLE author(
	author_id varchar(10)NOT NULL,
	first_name varchar(30)NOT NULL,
	last_name varchar(30)NOT NULL,
	gender char(1)NOT NULL,
	birth_date date NOT NULL,
	email varchar(50)NOT NULL,
	contact_number varchar(12)NOT NULL,
	nationality varchar(30)NOT NULL,
	PRIMARY KEY (author_id)
);

--Book Table
CREATE TABLE book (
	book_id varchar(13) NOT NULL,
	book_title varchar(50) NOT NULL,
	category_id varchar(4) NOT NULL,
	publish_date date NOT NULL,
	language varchar(30) DEFAULT 'English' NOT NULL,
	isbn varchar(20) NOT NULL,
	numpages number(4) NOT NULL,
	PRIMARY KEY (book_id),
	FOREIGN KEY (category_id) REFERENCES book_category(category_id)
);

--Book Authors Table
CREATE TABLE book_authors (
	book_id varchar(13) NOT NULL,
	author_id varchar(10) NOT NULL,
	PRIMARY KEY (book_id, author_id),
	FOREIGN KEY (book_id) REFERENCES book(book_id),
	FOREIGN KEY (author_id) REFERENCES author(author_id)
);

--Book Reservation Table
CREATE TABLE book_reservation (
	reservation_id varchar(13) NOT NULL,
	book_id varchar(13) NOT NULL,
	reserved_date date NOT NULL,
	PRIMARY KEY (reservation_id,book_id),
	FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id),
	FOREIGN KEY (book_id) REFERENCES book(book_id)
);

--Book Loan Table 
CREATE TABLE book_loan(
	loan_id varchar(10)NOT NULL,
	staff_id varchar(5)NOT NULL, 
	member_id varchar(10) NOT NULL,
	loan_amount NUMBER(2)NOT NULL,
	loan_start_date date NOT NULL,
	loan_due_date date NOT NULL,
	PRIMARY KEY (loan_id),
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
	FOREIGN KEY (member_id) REFERENCES membership(member_id)
);

--Lend Book Table
CREATE TABLE lend_books(
	loan_id varchar(10)NOT NULL,
	book_id varchar(13)NOT NULL,
	lend_status varchar(6)NOT NULL,
	PRIMARY KEY (loan_id,book_id),
	FOREIGN KEY (loan_id) REFERENCES book_loan(loan_id),
	FOREIGN KEY (book_id) REFERENCES book(book_id)
);

--Book Return Table 
CREATE TABLE book_return (
	return_id varchar(13) NOT NULL,
	loan_id varchar(10) NOT NULL,
	staff_id varchar(5) NOT NULL,
	date_returns date NOT NULL,
	return_amount number(11) NOT NULL,
	overdue_status varchar(10) NOT NULL,
	late_days number DEFAULT '0' NOT NULL,
	fine_amount number DEFAULT '0.00' NOT NULL,
	PRIMARY KEY (return_id),
	FOREIGN KEY (loan_id) REFERENCES book_loan(loan_id),
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

--Payment Table
CREATE TABLE payment (
	payment_id VARCHAR(20) NOT NULL,
	staff_id VARCHAR(5) NOT NULL,
	member_id VARCHAR(10),
	payment_date DATE NOT NULL,
	return_id VARCHAR(13),
	reservation_id VARCHAR(15),
	payment_desc VARCHAR(30) NOT NULL,
	payment_method VARCHAR(30) NOT NULL,
	payment_amount NUMBER(6,2) NOT NULL,
	PRIMARY KEY (payment_id),
	FOREIGN KEY (staff_id) REFERENCES staff (staff_id),
	FOREIGN KEY (member_id) REFERENCES membership (member_id),
	FOREIGN KEY (return_id) REFERENCES book_return (return_id),
	FOREIGN KEY (reservation_id) REFERENCES reservation (reservation_id)
); 


/*
=======================
     INSERT RECORD
=======================
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI'; 


--Membership type table
INSERT INTO membership_type VALUES ('BR01', 'Bronze', 2, 3, 2, 0.50, 30.00);
INSERT INTO membership_type VALUES ('GD01', 'Gold', 6, 9, 6, 1.50, 50.00);
INSERT INTO membership_type VALUES ('SV01', 'Silver', 4, 6, 4, 1.00, 40.00);


--Membership table
INSERT INTO membership VALUES ('M101BR','Lee Wei Lin',TO_DATE('2020-03-19','YYYY-MM-DD'),'010719-07-0978','F','012-3456789','leewl@gmail.com','BR01');
INSERT INTO membership VALUES ('M102SV','Bok Yuk Teng',TO_DATE('2020-01-10','YYYY-MM-DD'),'010519-07-0034','F','012-4567890','bokyt@gmail.com','SV01');
INSERT INTO membership VALUES ('M103BR','Khaw Khai Wen',TO_DATE('2019-09-19','YYYY-MM-DD'),'010312-07-0134','F','012-5678901','khawkw@gmail.com','BR01');
INSERT INTO membership VALUES ('M104SV','Cheah Kai Li',TO_DATE('2018-12-20','YYYY-MM-DD'),'011223-07-7878','F','012-6789012','cheahkl@gmail.com','SV01');
INSERT INTO membership VALUES ('M105GD','Ooi Mun Fung',TO_DATE('2020-03-11','YYYY-MM-DD'),'010329-07-0977','M','012-7890123','ooimf@gmail.com','GD01');

INSERT INTO membership VALUES ('M106SV','Hooi Pei Ling',TO_DATE('2019-03-24','YYYY-MM-DD'),'001120-07-8008','F','012-8901234','hooipl@gmail.comm','SV01');
INSERT INTO membership VALUES ('M107BR','Jordan Lim',TO_DATE('2020-02-22','YYYY-MM-DD'),'000102-07-0233','M','012-9012345','jordanlim@gmail.com','BR01');
INSERT INTO membership VALUES ('M108GD','Goh Chun Ping',TO_DATE('2019-07-13','YYYY-MM-DD'),'000713-07-0015','M','012-1245789','gohcp@gmail.com','GD01');
INSERT INTO membership VALUES ('M109SV','Lee Chun Fai',TO_DATE('2020-05-05','YYYY-MM-DD'),'010908-07-4557','M','012-5679013','leecf@gmail.com','SV01');
INSERT INTO membership VALUES ('M110BR','Choo Kai Jun',TO_DATE('2018-11-09','YYYY-MM-DD'),'000625-07-3309','M','012-2345890','chookj@gmail.com','BR01');

INSERT INTO membership VALUES ('M111GD','Lee Ai Ming',TO_DATE('2020-02-03','YYYY-MM-DD'),'020222-07-0623','M','013-4567125','leeam@gmail.com','GD01');
INSERT INTO membership VALUES ('M112BR','Tan Ah Seng',TO_DATE('2020-04-22','YYYY-MM-DD'),'990819-07-4005','M','013-4334123','tanas@gmail.com','BR01');
INSERT INTO membership VALUES ('M113SV','Tan Bee Ru',TO_DATE('2020-01-12','YYYY-MM-DD'),'980728-07-2234','F','016-4507123','tanbr@gmail.com','SV01');
INSERT INTO membership VALUES ('M114BR','Sim Meng Hong',TO_DATE('2020-06-26','YYYY-MM-DD'),'000524-07-5509','M','011-2345678','simmh@gmail.com','BR01');
INSERT INTO membership VALUES ('M115GD','Ang Hui Chin',TO_DATE('2020-03-27','YYYY-MM-DD'),'000322-07-6656','F','013-4560098','anghc@gmail.com','GD01');

INSERT INTO membership VALUES ('M116BR','Ang Yi Hang',TO_DATE('2019-10-16','YYYY-MM-DD'),'001117-07-1001','M','011-1223678','angyh@gmail.com','BR01');
INSERT INTO membership VALUES ('M117SV','Teoh Zi Hong',TO_DATE('2019-12-16','YYYY-MM-DD'),'030412-07-3119','M','013-8799023','teohzh@gmail.com','SV01');
INSERT INTO membership VALUES ('M118GD','Chan Yao Meng',TO_DATE('2019-07-23','YYYY-MM-DD'),'010830-07-2013','M','016-5667890','chanym@gmail.com','GD01');
INSERT INTO membership VALUES ('M119BR','Loo Sze Pei',TO_DATE('2019-04-29','YYYY-MM-DD'),'020331-07-0922','F','016-2297123','loosp@gmail.com','BR01');
INSERT INTO membership VALUES ('M120GD','Teh Ping Yang',TO_DATE('2019-01-18','YYYY-MM-DD'),'001212-07-5503','M','013-3356788','tehpy@gmail.com','GD01');


--Staff table
INSERT INTO staff VALUES ('S101M','Poh Choo Meng',TO_DATE('2018-06-15','YYYY-MM-DD'),'pohcm@logicallibrary.com','M','pohchoomeng001','011111-07-0011','013-1234567');
INSERT INTO staff VALUES ('S102F','Choo Zhi Yan',TO_DATE('2018-06-15','YYYY-MM-DD'),'choozy@logicallibrary.com','F','choozhiyan002','001227-07-2334','012-3344556');
INSERT INTO staff VALUES ('S103M','William Choong',TO_DATE('2018-06-15','YYYY-MM-DD'),'williamc@logicallibrary.com','M','williamchong003','011212-07-1299','013-1234589');
INSERT INTO staff VALUES ('S104M','Chew Wei Chung',TO_DATE('2018-06-15','YYYY-MM-DD'),'chewwc@logicallibrary.com','M','chewweichung004','010113-07-9909','012-2244556');
INSERT INTO staff VALUES ('S105M','Ng Kar Kei',TO_DATE('2018-07-01','YYYY-MM-DD'),'ngkk@logicallibrary.com','M','ngkarkei005','010625-07-6677','013-1255567');

INSERT INTO staff VALUES ('S106F','Ng Chi Ern',TO_DATE('2018-07-01','YYYY-MM-DD'),'ngce@logicallibrary.com','F','ngchiern006','010909-07-8880','012-5584556');
INSERT INTO staff VALUES ('S107F','Fong Shu Leng',TO_DATE('2018-07-01','YYYY-MM-DD'),'fongsl@logicallibrary.com','F','fongshuleng007','010323-07-2298','013-5432567');
INSERT INTO staff VALUES ('S108F','Tan Ke Xing',TO_DATE('2018-07-01','YYYY-MM-DD'),'tankx@logicallibrary.com','F','tankexing008','010914-07-2202','012-3348876');
INSERT INTO staff VALUES ('S109M','Oon Kheng Hung',TO_DATE('2018-07-01','YYYY-MM-DD'),'oonkh@logicallibrary.com','M','oonkhenghung009','001109-07-1223','013-1255007');
INSERT INTO staff VALUES ('S110F','Choo Zhi Ying',TO_DATE('2018-07-18','YYYY-MM-DD'),'zhiying@logicallibrary.com','F','choozhiying010','001130-07-0098','012-3234596');

INSERT INTO staff VALUES ('S111F','Lim Yen Gee',TO_DATE('2018-07-25','YYYY-MM-DD'),'limyg@logicallibrary.com','F','limyengee011','000814-07-1222','013-1234998');
INSERT INTO staff VALUES ('S112F','Lim Chia Ern',TO_DATE('2018-07-25','YYYY-MM-DD'),'limce@logicallibrary.com','F','limchiaern012','000522-07-0322','012-1225886');
INSERT INTO staff VALUES ('S113M','Lim Calson',TO_DATE('2018-07-25','YYYY-MM-DD'),'limcalson@logicallibrary.com','M','limcalson013','001123-07-0127','012-1144599');
INSERT INTO staff VALUES ('S114M','Lim Jia Wei',TO_DATE('2018-07-25','YYYY-MM-DD'),'limjw@logicallibrary.com','M','limjiawei014','000814-07-1222','013-1234998');
INSERT INTO staff VALUES ('S115M','Ezekiel Teo Hong Ming',TO_DATE('2018-07-25','YYYY-MM-DD'),'ezekiel@logicallibrary.com','M','ezekielteohongming015','000607-07-5557','013-1099567');

INSERT INTO staff VALUES ('S116M','Tan Zhi Sen',TO_DATE('2018-07-25','YYYY-MM-DD'),'tanzs@logicallibrary.com','M','tanzhisen016','001217-07-1779','012-3244252');
INSERT INTO staff VALUES ('S117M','Cheah Yew Siang',TO_DATE('2018-07-25','YYYY-MM-DD'),'cheahys@logicallibrary.com','M','cheahyewsiang017','000105-07-2005','013-6634568');
INSERT INTO staff VALUES ('S118F','Leong Vern Kei',TO_DATE('2018-08-01','YYYY-MM-DD'),'leongvk@logicallibrary.com','F','leongvernkei018','010213-07-0022','012-0099844');
INSERT INTO staff VALUES ('S119F','Leong Vern Yee',TO_DATE('2018-08-01','YYYY-MM-DD'),'leongvy@logicallibrary.com','F','leongvernyee019','031208-07-1210','013-5434900');
INSERT INTO staff VALUES ('S120F','Hor Xu Zhe',TO_DATE('2018-08-05','YYYY-MM-DD'),'horxz@logicallibrary.com','F','horxuzhe020','001107-07-1007','012-3113556');


--Room table
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-AGF-1', 'S1', 'Block A', 'GF', '001');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-AGF-2', 'S1', 'Block A', 'GF', '002');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-AGF-3', 'S1', 'Block A', 'GF', '003');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-A1F-4', 'S1', 'Block A', '1F', '004');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-A1F-5', 'S1', 'Block A', '1F', '005');
INSERT INTO room VALUES ('MR-A1F-6', 'M1', 'Block A', '1F', '006',2,6,25.00);
INSERT INTO room VALUES ('MR-A1F-7', 'M1', 'Block A', '1F', '007',2,6,25.00);
INSERT INTO room VALUES ('MR-A2F-8', 'M2', 'Block A', '2F', '008',4,8,35.00);
INSERT INTO room VALUES ('MR-A2F-9', 'M2', 'Block A', '2F', '009',4,8,35.00);
INSERT INTO room VALUES ('MR-A2F-10', 'M2', 'Block A', '2F', '010',4,8,35.00);

INSERT INTO room VALUES ('MR-A3F-11', 'M3', 'Block A', '3F', '011',6,15,50.00);
INSERT INTO room VALUES ('MR-A3F-12', 'M3', 'Block A', '3F', '012',6,15,50.00);
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-BGF-13', 'S1', 'Block B', 'GF', '013');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-BGF-14', 'S1', 'Block B', 'GF', '014');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-BGF-15', 'S1', 'Block B', 'GF', '015');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-B1F-16', 'S1', 'Block B', '1F', '016');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-B1F-17', 'S1', 'Block B', '1F', '017');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-B1F-18', 'S1', 'Block B', '1F', '018');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-B1F-19', 'S1', 'Block B', '1F', '019');
INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-B1F-20', 'S1', 'Block B', '1F', '020');

INSERT INTO room(room_id,room_type,room_building,room_floor,room_no) VALUES ('SR-B2F-21', 'S1', 'Block B', '2F', '021');
INSERT INTO room VALUES ('MR-B2F-22', 'M1', 'Block B', '2F', '022',2,6,25.00);
INSERT INTO room VALUES ('MR-B2F-23', 'M1', 'Block B', '2F', '023',2,6,25.00);
INSERT INTO room VALUES ('MR-B2F-24', 'M1', 'Block B', '2F', '024',2,6,25.00);
INSERT INTO room VALUES ('MR-B2F-25', 'M2', 'Block B', '2F', '025',4,8,35.00);


--Reservation table
INSERT INTO reservation VALUES ('200301-M3-1', 'Room', TO_DATE('2020-03-01','YYYY-MM-DD'), 'M105GD', 'Direct', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200301-M1-2', 'Room', TO_DATE('2020-03-01','YYYY-MM-DD'), 'M115GD', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200301-S1-3', 'Room', TO_DATE('2020-03-01','YYYY-MM-DD'), 'M114BR', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200301-B1-4', 'Book', TO_DATE('2020-03-01','YYYY-MM-DD'), 'M101BR', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200302-B1-5', 'Book', TO_DATE('2020-03-02','YYYY-MM-DD'), 'M114BR', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200302-B1-6', 'Book', TO_DATE('2020-03-02','YYYY-MM-DD'), 'M108GD', 'Contact', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200302-B1-7', 'Book', TO_DATE('2020-03-02','YYYY-MM-DD'), 'M112BR', 'Website', 'S104M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200303-B1-8', 'Book', TO_DATE('2020-03-03','YYYY-MM-DD'), 'M120GD', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200303-B1-9', 'Book', TO_DATE('2020-03-03','YYYY-MM-DD'), 'M112BR', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200303-S1-10', 'Room', TO_DATE('2020-03-03','YYYY-MM-DD'), 'M111GD', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200304-M1-11', 'Room', TO_DATE('2020-03-04','YYYY-MM-DD'), 'M115GD', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200304-M1-12', 'Room', TO_DATE('2020-03-04','YYYY-MM-DD'), 'M106SV', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200304-S1-13', 'Room', TO_DATE('2020-03-04','YYYY-MM-DD'), 'M101BR', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200304-S1-14', 'Room', TO_DATE('2020-03-04','YYYY-MM-DD'), 'M108GD', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200305-B1-15', 'Book', TO_DATE('2020-03-05','YYYY-MM-DD'), 'M103BR', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200305-B1-16', 'Book', TO_DATE('2020-03-05','YYYY-MM-DD'), 'M106SV', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200305-B1-17', 'Book', TO_DATE('2020-03-05','YYYY-MM-DD'), 'M120GD', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200305-B1-18', 'Book', TO_DATE('2020-03-05','YYYY-MM-DD'), 'M101BR', 'Contact', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200305-M1-19', 'Room', TO_DATE('2020-03-05','YYYY-MM-DD'), 'M120GD', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200306-M2-20', 'Room', TO_DATE('2020-03-06','YYYY-MM-DD'), 'M112BR', 'Website', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200306-S1-21', 'Room', TO_DATE('2020-03-06','YYYY-MM-DD'), 'M118GD', 'Website', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200306-S1-22', 'Room', TO_DATE('2020-03-06','YYYY-MM-DD'), 'M119BR', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200306-S1-23', 'Room', TO_DATE('2020-03-06','YYYY-MM-DD'), 'M102SV', 'Direct', 'S108F','Head Phone','Done');
INSERT INTO reservation VALUES ('200307-B1-24', 'Book', TO_DATE('2020-03-07','YYYY-MM-DD'), 'M110BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200307-S1-25', 'Room', TO_DATE('2020-03-07','YYYY-MM-DD'), 'M115GD', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200307-M2-26', 'Room', TO_DATE('2020-03-07','YYYY-MM-DD'), 'M119BR', 'Website', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200307-S1-27', 'Room', TO_DATE('2020-03-07','YYYY-MM-DD'), 'M107BR', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200308-B1-28', 'Book', TO_DATE('2020-03-08','YYYY-MM-DD'), 'M103BR', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200308-B1-29', 'Book', TO_DATE('2020-03-08','YYYY-MM-DD'), 'M102SV', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200308-M1-30', 'Room', TO_DATE('2020-03-08','YYYY-MM-DD'), 'M115GD', 'Website', 'S101M','HDMI Cable, Speaker','Done');
INSERT INTO reservation VALUES ('200308-M2-31', 'Room', TO_DATE('2020-03-08','YYYY-MM-DD'), 'M113SV', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200308-M1-32', 'Room', TO_DATE('2020-03-08','YYYY-MM-DD'), 'M109SV', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200309-B1-33', 'Book', TO_DATE('2020-03-09','YYYY-MM-DD'), 'M101BR', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200309-B1-34', 'Book', TO_DATE('2020-03-09','YYYY-MM-DD'), 'M104SV', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200309-B1-35', 'Book', TO_DATE('2020-03-09','YYYY-MM-DD'), 'M103BR', 'Direct', 'S101M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200309-M3-36', 'Room', TO_DATE('2020-03-09','YYYY-MM-DD'), 'M102SV', 'Website', 'S105M','Pointer','Done');
INSERT INTO reservation VALUES ('200310-B1-37', 'Book', TO_DATE('2020-03-10','YYYY-MM-DD'), 'M101BR', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200310-S1-38', 'Room', TO_DATE('2020-03-10','YYYY-MM-DD'), 'M107BR', 'Direct', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200310-S1-39', 'Room', TO_DATE('2020-03-10','YYYY-MM-DD'), 'M104SV', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200310-B1-40', 'Book', TO_DATE('2020-03-10','YYYY-MM-DD'), 'M118GD', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200311-M1-41', 'Room', TO_DATE('2020-03-11','YYYY-MM-DD'), 'M118GD', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200311-M1-42', 'Room', TO_DATE('2020-03-11','YYYY-MM-DD'), 'M116BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200311-B1-43', 'Book', TO_DATE('2020-03-11','YYYY-MM-DD'), 'M113SV', 'Contact', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200312-B1-44', 'Book', TO_DATE('2020-03-12','YYYY-MM-DD'), 'M119BR', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200312-M2-45', 'Room', TO_DATE('2020-03-12','YYYY-MM-DD'), 'M116BR', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200312-B1-46', 'Book', TO_DATE('2020-03-12','YYYY-MM-DD'), 'M110BR', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200313-S1-47', 'Room', TO_DATE('2020-03-13','YYYY-MM-DD'), 'M109SV', 'Direct', 'S120F','Head Phone','Done');
INSERT INTO reservation VALUES ('200313-B1-48', 'Book', TO_DATE('2020-03-13','YYYY-MM-DD'), 'M105GD', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200313-B1-49', 'Book', TO_DATE('2020-03-13','YYYY-MM-DD'), 'M113SV', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200313-B1-50', 'Book', TO_DATE('2020-03-13','YYYY-MM-DD'), 'M113SV', 'Direct', 'S103M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200313-S1-51', 'Room', TO_DATE('2020-03-13','YYYY-MM-DD'), 'M107BR', 'Website', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200314-B1-52', 'Book', TO_DATE('2020-03-14','YYYY-MM-DD'), 'M105GD', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200314-B1-53', 'Book', TO_DATE('2020-03-14','YYYY-MM-DD'), 'M114BR', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200314-B1-54', 'Book', TO_DATE('2020-03-14','YYYY-MM-DD'), 'M115GD', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200314-M1-55', 'Room', TO_DATE('2020-03-14','YYYY-MM-DD'), 'M114BR', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200314-B1-56', 'Book', TO_DATE('2020-03-14','YYYY-MM-DD'), 'M105GD', 'Direct', 'S102F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200314-M2-57', 'Room', TO_DATE('2020-03-14','YYYY-MM-DD'), 'M114BR', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200315-B1-58', 'Book', TO_DATE('2020-03-15','YYYY-MM-DD'), 'M106SV', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200315-B1-59', 'Book', TO_DATE('2020-03-15','YYYY-MM-DD'), 'M111GD', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200315-S1-60', 'Room', TO_DATE('2020-03-15','YYYY-MM-DD'), 'M103BR', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200316-B1-61', 'Book', TO_DATE('2020-03-16','YYYY-MM-DD'), 'M112BR', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200316-S1-62', 'Room', TO_DATE('2020-03-16','YYYY-MM-DD'), 'M106SV', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200316-M1-63', 'Room', TO_DATE('2020-03-16','YYYY-MM-DD'), 'M105GD', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200316-B1-64', 'Book', TO_DATE('2020-03-16','YYYY-MM-DD'), 'M110BR', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200317-S1-65', 'Room', TO_DATE('2020-03-17','YYYY-MM-DD'), 'M114BR', 'Contact', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200317-S1-66', 'Room', TO_DATE('2020-03-17','YYYY-MM-DD'), 'M108GD', 'Direct', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200317-S1-67', 'Room', TO_DATE('2020-03-17','YYYY-MM-DD'), 'M118GD', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200318-B1-68', 'Book', TO_DATE('2020-03-18','YYYY-MM-DD'), 'M117SV', 'Website', 'S106F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200318-B1-69', 'Book', TO_DATE('2020-03-18','YYYY-MM-DD'), 'M102SV', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200318-B1-70', 'Book', TO_DATE('2020-03-18','YYYY-MM-DD'), 'M109SV', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200319-B1-71', 'Book', TO_DATE('2020-03-19','YYYY-MM-DD'), 'M115GD', 'Website', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200319-B1-72', 'Book', TO_DATE('2020-03-19','YYYY-MM-DD'), 'M117SV', 'Website', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200319-B1-73', 'Book', TO_DATE('2020-03-19','YYYY-MM-DD'), 'M120GD', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200319-B1-74', 'Book', TO_DATE('2020-03-19','YYYY-MM-DD'), 'M115GD', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200319-B1-75', 'Book', TO_DATE('2020-03-19','YYYY-MM-DD'), 'M116BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200320-M1-76', 'Room', TO_DATE('2020-03-20','YYYY-MM-DD'), 'M110BR', 'Direct', 'S103M','Speaker','Done');
INSERT INTO reservation VALUES ('200320-M1-77', 'Room', TO_DATE('2020-03-20','YYYY-MM-DD'), 'M105GD', 'Contact', 'S101M','HDMI Cable, Pointer, Speaker','Done');
INSERT INTO reservation VALUES ('200320-B1-78', 'Book', TO_DATE('2020-03-20','YYYY-MM-DD'), 'M115GD', 'Direct', 'S115M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200320-B1-79', 'Book', TO_DATE('2020-03-20','YYYY-MM-DD'), 'M103BR', 'Website', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200321-B1-80', 'Book', TO_DATE('2020-03-21','YYYY-MM-DD'), 'M114BR', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200321-B1-81', 'Book', TO_DATE('2020-03-21','YYYY-MM-DD'), 'M107BR', 'Website', 'S118F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200321-M1-82', 'Room', TO_DATE('2020-03-21','YYYY-MM-DD'), 'M101BR', 'Direct', 'S113M','HDMI Cable, Pointer, Speaker','Done');
INSERT INTO reservation VALUES ('200321-B1-83', 'Book', TO_DATE('2020-03-21','YYYY-MM-DD'), 'M110BR', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200322-S1-84', 'Room', TO_DATE('2020-03-22','YYYY-MM-DD'), 'M117SV', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200322-M1-85', 'Room', TO_DATE('2020-03-22','YYYY-MM-DD'), 'M114BR', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200322-B1-86', 'Book', TO_DATE('2020-03-22','YYYY-MM-DD'), 'M119BR', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200323-S1-87', 'Room', TO_DATE('2020-03-23','YYYY-MM-DD'), 'M114BR', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200323-M3-88', 'Room', TO_DATE('2020-03-23','YYYY-MM-DD'), 'M116BR', 'Contact', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200323-B1-89', 'Book', TO_DATE('2020-03-23','YYYY-MM-DD'), 'M111GD', 'Direct', 'S118F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200323-B1-90', 'Book', TO_DATE('2020-03-23','YYYY-MM-DD'), 'M107BR', 'Contact', 'S116M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200324-B1-91', 'Book', TO_DATE('2020-03-24','YYYY-MM-DD'), 'M104SV', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200324-B1-92', 'Book', TO_DATE('2020-03-24','YYYY-MM-DD'), 'M101BR', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200324-M1-93', 'Room', TO_DATE('2020-03-24','YYYY-MM-DD'), 'M110BR', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200324-S1-94', 'Room', TO_DATE('2020-03-24','YYYY-MM-DD'), 'M107BR', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200324-B1-95', 'Book', TO_DATE('2020-03-24','YYYY-MM-DD'), 'M104SV', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200325-M1-96', 'Room', TO_DATE('2020-03-25','YYYY-MM-DD'), 'M108GD', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200325-B1-97', 'Book', TO_DATE('2020-03-25','YYYY-MM-DD'), 'M111GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200325-M1-98', 'Room', TO_DATE('2020-03-25','YYYY-MM-DD'), 'M109SV', 'Website', 'S105M','Poitner, Speaker','Done');
INSERT INTO reservation VALUES ('200325-M1-99', 'Room', TO_DATE('2020-03-25','YYYY-MM-DD'), 'M105GD', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200325-S1-100', 'Room', TO_DATE('2020-03-25','YYYY-MM-DD'), 'M111GD', 'Website', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200326-S1-101', 'Room', TO_DATE('2020-03-26','YYYY-MM-DD'), 'M119BR', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200326-B1-102', 'Book', TO_DATE('2020-03-26','YYYY-MM-DD'), 'M105GD', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200326-M2-103', 'Room', TO_DATE('2020-03-26','YYYY-MM-DD'), 'M117SV', 'Direct', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200327-S1-104', 'Room', TO_DATE('2020-03-27','YYYY-MM-DD'), 'M101BR', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200327-B1-105', 'Book', TO_DATE('2020-03-27','YYYY-MM-DD'), 'M110BR', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200327-B1-106', 'Book', TO_DATE('2020-03-27','YYYY-MM-DD'), 'M119BR', 'Website', 'S112F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200327-B1-107', 'Book', TO_DATE('2020-03-27','YYYY-MM-DD'), 'M117SV', 'Contact', 'S103M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200327-B1-108', 'Book', TO_DATE('2020-03-27','YYYY-MM-DD'), 'M118GD', 'Contact', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200328-M1-109', 'Room', TO_DATE('2020-03-28','YYYY-MM-DD'), 'M103BR', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200328-B1-110', 'Book', TO_DATE('2020-03-28','YYYY-MM-DD'), 'M107BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200328-B1-111', 'Book', TO_DATE('2020-03-28','YYYY-MM-DD'), 'M105GD', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200329-M2-112', 'Room', TO_DATE('2020-03-29','YYYY-MM-DD'), 'M110BR', 'Direct', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200329-B1-113', 'Book', TO_DATE('2020-03-29','YYYY-MM-DD'), 'M120GD', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200329-B1-114', 'Book', TO_DATE('2020-03-29','YYYY-MM-DD'), 'M108GD', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200329-S1-115', 'Room', TO_DATE('2020-03-29','YYYY-MM-DD'), 'M113SV', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200329-S1-116', 'Room', TO_DATE('2020-03-29','YYYY-MM-DD'), 'M117SV', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200329-B1-117', 'Book', TO_DATE('2020-03-29','YYYY-MM-DD'), 'M106SV', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200330-B1-118', 'Book', TO_DATE('2020-03-30','YYYY-MM-DD'), 'M111GD', 'Website', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200330-S1-119', 'Room', TO_DATE('2020-03-30','YYYY-MM-DD'), 'M107BR', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200330-S1-120', 'Room', TO_DATE('2020-03-30','YYYY-MM-DD'), 'M119BR', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200330-S1-121', 'Room', TO_DATE('2020-03-30','YYYY-MM-DD'), 'M106SV', 'Website', 'S105M','Head Phone','Done');
INSERT INTO reservation VALUES ('200330-M2-122', 'Room', TO_DATE('2020-03-30','YYYY-MM-DD'), 'M116BR', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200331-S1-123', 'Room', TO_DATE('2020-03-31','YYYY-MM-DD'), 'M107BR', 'Direct', 'S103M','Head Phone','Done');
INSERT INTO reservation VALUES ('200331-B1-124', 'Book', TO_DATE('2020-03-31','YYYY-MM-DD'), 'M108GD', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200331-B1-125', 'Book', TO_DATE('2020-03-31','YYYY-MM-DD'), 'M115GD', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200401-S1-126', 'Room', TO_DATE('2020-04-01','YYYY-MM-DD'), 'M106SV', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200401-B1-127', 'Book', TO_DATE('2020-04-01','YYYY-MM-DD'), 'M118GD', 'Direct', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200401-B1-128', 'Book', TO_DATE('2020-04-01','YYYY-MM-DD'), 'M101BR', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200401-B1-129', 'Book', TO_DATE('2020-04-01','YYYY-MM-DD'), 'M113SV', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200402-M3-130', 'Room', TO_DATE('2020-04-02','YYYY-MM-DD'), 'M102SV', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200402-S1-131', 'Room', TO_DATE('2020-04-02','YYYY-MM-DD'), 'M118GD', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200402-B1-132', 'Book', TO_DATE('2020-04-02','YYYY-MM-DD'), 'M112BR', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200402-S1-133', 'Room', TO_DATE('2020-04-02','YYYY-MM-DD'), 'M115GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200403-B1-134', 'Book', TO_DATE('2020-04-03','YYYY-MM-DD'), 'M109SV', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200403-S1-135', 'Room', TO_DATE('2020-04-03','YYYY-MM-DD'), 'M103BR', 'Direct', 'S109M','Head Phone','Done');
INSERT INTO reservation VALUES ('200403-M3-136', 'Room', TO_DATE('2020-04-03','YYYY-MM-DD'), 'M108GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200404-B1-137', 'Book', TO_DATE('2020-04-04','YYYY-MM-DD'), 'M108GD', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200404-B1-138', 'Book', TO_DATE('2020-04-04','YYYY-MM-DD'), 'M110BR', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200404-M1-139', 'Room', TO_DATE('2020-04-04','YYYY-MM-DD'), 'M115GD', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200404-M1-140', 'Room', TO_DATE('2020-04-04','YYYY-MM-DD'), 'M112BR', 'Website', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200405-S1-141', 'Room', TO_DATE('2020-04-05','YYYY-MM-DD'), 'M102SV', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200405-B1-142', 'Book', TO_DATE('2020-04-05','YYYY-MM-DD'), 'M115GD', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200405-M1-143', 'Room', TO_DATE('2020-04-05','YYYY-MM-DD'), 'M106SV', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200405-B1-144', 'Book', TO_DATE('2020-04-05','YYYY-MM-DD'), 'M119BR', 'Direct', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200405-B1-145', 'Book', TO_DATE('2020-04-05','YYYY-MM-DD'), 'M111GD', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200405-M3-146', 'Room', TO_DATE('2020-04-05','YYYY-MM-DD'), 'M101BR', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200406-B1-147', 'Book', TO_DATE('2020-04-06','YYYY-MM-DD'), 'M111GD', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200406-M1-148', 'Room', TO_DATE('2020-04-06','YYYY-MM-DD'), 'M114BR', 'Contact', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200406-B1-149', 'Book', TO_DATE('2020-04-06','YYYY-MM-DD'), 'M116BR', 'Contact', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200406-B1-150', 'Book', TO_DATE('2020-04-06','YYYY-MM-DD'), 'M120GD', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200406-B1-151', 'Book', TO_DATE('2020-04-06','YYYY-MM-DD'), 'M105GD', 'Website', 'S102F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200407-M2-152', 'Room', TO_DATE('2020-04-07','YYYY-MM-DD'), 'M104SV', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200407-M2-153', 'Room', TO_DATE('2020-04-07','YYYY-MM-DD'), 'M111GD', 'Direct', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200407-B1-154', 'Book', TO_DATE('2020-04-07','YYYY-MM-DD'), 'M105GD', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200407-B1-155', 'Book', TO_DATE('2020-04-07','YYYY-MM-DD'), 'M103BR', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200407-B1-156', 'Book', TO_DATE('2020-04-07','YYYY-MM-DD'), 'M108GD', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200407-M1-157', 'Room', TO_DATE('2020-04-07','YYYY-MM-DD'), 'M104SV', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200408-B1-158', 'Book', TO_DATE('2020-04-08','YYYY-MM-DD'), 'M107BR', 'Website', 'S120F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200408-M2-159', 'Room', TO_DATE('2020-04-08','YYYY-MM-DD'), 'M111GD', 'Direct', 'S114M','HDMI Cable, Pointer, Speaker','Done');
INSERT INTO reservation VALUES ('200408-B1-160', 'Book', TO_DATE('2020-04-08','YYYY-MM-DD'), 'M102SV', 'Website', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200409-B1-161', 'Book', TO_DATE('2020-04-09','YYYY-MM-DD'), 'M114BR', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200409-S1-162', 'Room', TO_DATE('2020-04-09','YYYY-MM-DD'), 'M111GD', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200409-S1-163', 'Room', TO_DATE('2020-04-09','YYYY-MM-DD'), 'M115GD', 'Direct', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200409-M1-164', 'Room', TO_DATE('2020-04-09','YYYY-MM-DD'), 'M105GD', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200410-B1-165', 'Book', TO_DATE('2020-04-10','YYYY-MM-DD'), 'M114BR', 'Direct', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200410-B1-166', 'Book', TO_DATE('2020-04-10','YYYY-MM-DD'), 'M104SV', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200410-M3-167', 'Room', TO_DATE('2020-04-10','YYYY-MM-DD'), 'M101BR', 'Website', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200410-M3-168', 'Room', TO_DATE('2020-04-10','YYYY-MM-DD'), 'M118GD', 'Website', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200411-B1-169', 'Book', TO_DATE('2020-04-11','YYYY-MM-DD'), 'M102SV', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200411-S1-170', 'Room', TO_DATE('2020-04-11','YYYY-MM-DD'), 'M113SV', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200411-B1-171', 'Book', TO_DATE('2020-04-11','YYYY-MM-DD'), 'M120GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200412-M1-172', 'Room', TO_DATE('2020-04-12','YYYY-MM-DD'), 'M118GD', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200412-B1-173', 'Book', TO_DATE('2020-04-12','YYYY-MM-DD'), 'M119BR', 'Website', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200412-S1-174', 'Room', TO_DATE('2020-04-12','YYYY-MM-DD'), 'M101BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200413-B1-175', 'Book', TO_DATE('2020-04-13','YYYY-MM-DD'), 'M102SV', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200413-B1-176', 'Book', TO_DATE('2020-04-13','YYYY-MM-DD'), 'M115GD', 'Contact', 'S119F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200413-B1-177', 'Book', TO_DATE('2020-04-13','YYYY-MM-DD'), 'M110BR', 'Contact', 'S117M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200413-B1-178', 'Book', TO_DATE('2020-04-13','YYYY-MM-DD'), 'M118GD', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200413-M1-179', 'Room', TO_DATE('2020-04-13','YYYY-MM-DD'), 'M110BR', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200413-B1-180', 'Book', TO_DATE('2020-04-13','YYYY-MM-DD'), 'M120GD', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200414-M1-181', 'Room', TO_DATE('2020-04-14','YYYY-MM-DD'), 'M115GD', 'Direct', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200414-M2-182', 'Room', TO_DATE('2020-04-14','YYYY-MM-DD'), 'M113SV', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200414-B1-183', 'Book', TO_DATE('2020-04-14','YYYY-MM-DD'), 'M104SV', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200414-B1-184', 'Book', TO_DATE('2020-04-14','YYYY-MM-DD'), 'M108GD', 'Website', 'S105M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200414-B1-185', 'Book', TO_DATE('2020-04-14','YYYY-MM-DD'), 'M120GD', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200414-S1-186', 'Room', TO_DATE('2020-04-14','YYYY-MM-DD'), 'M103BR', 'Website', 'S117M','Head Phone','Done');
INSERT INTO reservation VALUES ('200415-B1-187', 'Book', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M120GD', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200415-M2-188', 'Room', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M119BR', 'Direct', 'S113M','HDMI Cable, Speaker','Done');
INSERT INTO reservation VALUES ('200415-B1-189', 'Book', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M117SV', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200415-S1-190', 'Room', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M111GD', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200415-B1-191', 'Book', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M116BR', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200415-B1-192', 'Book', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M105GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200415-B1-193', 'Book', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M107BR', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200415-B1-194', 'Book', TO_DATE('2020-04-15','YYYY-MM-DD'), 'M108GD', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200416-B1-195', 'Book', TO_DATE('2020-04-16','YYYY-MM-DD'), 'M114BR', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200416-S1-196', 'Room', TO_DATE('2020-04-16','YYYY-MM-DD'), 'M116BR', 'Contact', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200416-S1-197', 'Room', TO_DATE('2020-04-16','YYYY-MM-DD'), 'M104SV', 'Website', 'S114M','Head Phone','Done');
INSERT INTO reservation VALUES ('200417-B1-198', 'Book', TO_DATE('2020-04-17','YYYY-MM-DD'), 'M116BR', 'Website', 'S106F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200417-S1-199', 'Room', TO_DATE('2020-04-17','YYYY-MM-DD'), 'M112BR', 'Contact', 'S119F','Head Phone','Done');
INSERT INTO reservation VALUES ('200417-M1-200', 'Room', TO_DATE('2020-04-17','YYYY-MM-DD'), 'M105GD', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200417-B1-201', 'Book', TO_DATE('2020-04-17','YYYY-MM-DD'), 'M102SV', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200417-B1-202', 'Book', TO_DATE('2020-04-17','YYYY-MM-DD'), 'M116BR', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200418-B1-203', 'Book', TO_DATE('2020-04-18','YYYY-MM-DD'), 'M118GD', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200418-M2-204', 'Room', TO_DATE('2020-04-18','YYYY-MM-DD'), 'M101BR', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200418-M2-205', 'Room', TO_DATE('2020-04-18','YYYY-MM-DD'), 'M117SV', 'Contact', 'S110F','HDMI Cable','Done');
INSERT INTO reservation VALUES ('200419-B1-206', 'Book', TO_DATE('2020-04-19','YYYY-MM-DD'), 'M104SV', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200419-B1-207', 'Book', TO_DATE('2020-04-19','YYYY-MM-DD'), 'M119BR', 'Direct', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200419-B1-208', 'Book', TO_DATE('2020-04-19','YYYY-MM-DD'), 'M114BR', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200419-S1-209', 'Room', TO_DATE('2020-04-19','YYYY-MM-DD'), 'M114BR', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200420-B1-210', 'Book', TO_DATE('2020-04-20','YYYY-MM-DD'), 'M107BR', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200420-B1-211', 'Book', TO_DATE('2020-04-20','YYYY-MM-DD'), 'M108GD', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200420-M3-212', 'Room', TO_DATE('2020-04-20','YYYY-MM-DD'), 'M113SV', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200421-S1-213', 'Room', TO_DATE('2020-04-21','YYYY-MM-DD'), 'M109SV', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200421-B1-214', 'Book', TO_DATE('2020-04-21','YYYY-MM-DD'), 'M120GD', 'Direct', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200421-B1-215', 'Book', TO_DATE('2020-04-21','YYYY-MM-DD'), 'M105GD', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200422-S1-216', 'Room', TO_DATE('2020-04-22','YYYY-MM-DD'), 'M112BR', 'Contact', 'S101M','Head Phone','Done');
INSERT INTO reservation VALUES ('200422-S1-217', 'Room', TO_DATE('2020-04-22','YYYY-MM-DD'), 'M112BR', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200422-S1-218', 'Room', TO_DATE('2020-04-22','YYYY-MM-DD'), 'M107BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200422-B1-219', 'Book', TO_DATE('2020-04-22','YYYY-MM-DD'), 'M115GD', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200422-B1-220', 'Book', TO_DATE('2020-04-22','YYYY-MM-DD'), 'M117SV', 'Direct', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200423-M2-221', 'Room', TO_DATE('2020-04-23','YYYY-MM-DD'), 'M111GD', 'Website', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200423-B1-222', 'Book', TO_DATE('2020-04-23','YYYY-MM-DD'), 'M119BR', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200423-S1-223', 'Room', TO_DATE('2020-04-23','YYYY-MM-DD'), 'M110BR', 'Website', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200423-B1-224', 'Book', TO_DATE('2020-04-23','YYYY-MM-DD'), 'M116BR', 'Website', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200423-B1-225', 'Book', TO_DATE('2020-04-23','YYYY-MM-DD'), 'M109SV', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200424-S1-226', 'Room', TO_DATE('2020-04-24','YYYY-MM-DD'), 'M108GD', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200424-B1-227', 'Book', TO_DATE('2020-04-24','YYYY-MM-DD'), 'M104SV', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200424-B1-228', 'Book', TO_DATE('2020-04-24','YYYY-MM-DD'), 'M110BR', 'Website', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200424-S1-229', 'Room', TO_DATE('2020-04-24','YYYY-MM-DD'), 'M118GD', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200424-B1-230', 'Book', TO_DATE('2020-04-24','YYYY-MM-DD'), 'M112BR', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200425-M1-231', 'Room', TO_DATE('2020-04-25','YYYY-MM-DD'), 'M102SV', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200425-M1-232', 'Room', TO_DATE('2020-04-25','YYYY-MM-DD'), 'M103BR', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200425-M1-233', 'Room', TO_DATE('2020-04-25','YYYY-MM-DD'), 'M116BR', 'Website', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200425-B1-234', 'Book', TO_DATE('2020-04-25','YYYY-MM-DD'), 'M106SV', 'Website', 'S117M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200426-M3-235', 'Room', TO_DATE('2020-04-26','YYYY-MM-DD'), 'M105GD', 'Website', 'S120F','HDMI Cable, Speaker','Done');
INSERT INTO reservation VALUES ('200426-M1-236', 'Room', TO_DATE('2020-04-26','YYYY-MM-DD'), 'M109SV', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200426-M2-237', 'Room', TO_DATE('2020-04-26','YYYY-MM-DD'), 'M117SV', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200427-B1-238', 'Book', TO_DATE('2020-04-27','YYYY-MM-DD'), 'M119BR', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200427-B1-239', 'Book', TO_DATE('2020-04-27','YYYY-MM-DD'), 'M108GD', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200427-M2-240', 'Room', TO_DATE('2020-04-27','YYYY-MM-DD'), 'M106SV', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200428-M2-241', 'Room', TO_DATE('2020-04-28','YYYY-MM-DD'), 'M115GD', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200428-B1-242', 'Book', TO_DATE('2020-04-28','YYYY-MM-DD'), 'M105GD', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200428-B1-243', 'Book', TO_DATE('2020-04-28','YYYY-MM-DD'), 'M112BR', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200428-B1-244', 'Book', TO_DATE('2020-04-28','YYYY-MM-DD'), 'M110BR', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200429-S1-245', 'Room', TO_DATE('2020-04-29','YYYY-MM-DD'), 'M110BR', 'Website', 'S120F','Head Phone','Done');
INSERT INTO reservation VALUES ('200429-M1-246', 'Room', TO_DATE('2020-04-29','YYYY-MM-DD'), 'M101BR', 'Website', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200429-M1-247', 'Room', TO_DATE('2020-04-29','YYYY-MM-DD'), 'M103BR', 'Contact', 'S110F','Speaker','Done');
INSERT INTO reservation VALUES ('200429-M3-248', 'Room', TO_DATE('2020-04-29','YYYY-MM-DD'), 'M101BR', 'Contact', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200429-S1-249', 'Room', TO_DATE('2020-04-29','YYYY-MM-DD'), 'M116BR', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200430-S1-250', 'Room', TO_DATE('2020-04-30','YYYY-MM-DD'), 'M104SV', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200430-M2-251', 'Room', TO_DATE('2020-04-30','YYYY-MM-DD'), 'M113SV', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200430-B1-252', 'Book', TO_DATE('2020-04-30','YYYY-MM-DD'), 'M110BR', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200501-B1-253', 'Book', TO_DATE('2020-05-01','YYYY-MM-DD'), 'M105GD', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200501-B1-254', 'Book', TO_DATE('2020-05-01','YYYY-MM-DD'), 'M107BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200501-S1-255', 'Room', TO_DATE('2020-05-01','YYYY-MM-DD'), 'M109SV', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200502-S1-256', 'Room', TO_DATE('2020-05-02','YYYY-MM-DD'), 'M114BR', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200502-B1-257', 'Book', TO_DATE('2020-05-02','YYYY-MM-DD'), 'M109SV', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200502-M1-258', 'Room', TO_DATE('2020-05-02','YYYY-MM-DD'), 'M117SV', 'Contact', 'S109M','HDMI Cable, Pointer, Speaker','Done');
INSERT INTO reservation VALUES ('200502-M3-259', 'Room', TO_DATE('2020-05-02','YYYY-MM-DD'), 'M108GD', 'Website', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200502-S1-260', 'Room', TO_DATE('2020-05-02','YYYY-MM-DD'), 'M118GD', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200503-M3-261', 'Room', TO_DATE('2020-05-03','YYYY-MM-DD'), 'M109SV', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200503-B1-262', 'Book', TO_DATE('2020-05-03','YYYY-MM-DD'), 'M104SV', 'Website', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200503-S1-263', 'Room', TO_DATE('2020-05-03','YYYY-MM-DD'), 'M108GD', 'Website', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200503-S1-264', 'Room', TO_DATE('2020-05-03','YYYY-MM-DD'), 'M111GD', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200503-S1-265', 'Room', TO_DATE('2020-05-03','YYYY-MM-DD'), 'M116BR', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200503-B1-266', 'Book', TO_DATE('2020-05-03','YYYY-MM-DD'), 'M109SV', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200504-B1-267', 'Book', TO_DATE('2020-05-04','YYYY-MM-DD'), 'M107BR', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200504-B1-268', 'Book', TO_DATE('2020-05-04','YYYY-MM-DD'), 'M107BR', 'Contact', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200504-M3-269', 'Room', TO_DATE('2020-05-04','YYYY-MM-DD'), 'M113SV', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200504-B1-270', 'Book', TO_DATE('2020-05-04','YYYY-MM-DD'), 'M106SV', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200505-S1-271', 'Room', TO_DATE('2020-05-05','YYYY-MM-DD'), 'M101BR', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200505-B1-272', 'Book', TO_DATE('2020-05-05','YYYY-MM-DD'), 'M112BR', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200505-B1-273', 'Book', TO_DATE('2020-05-05','YYYY-MM-DD'), 'M101BR', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200505-B1-274', 'Book', TO_DATE('2020-05-05','YYYY-MM-DD'), 'M106SV', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200506-B1-275', 'Book', TO_DATE('2020-05-06','YYYY-MM-DD'), 'M119BR', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200506-B1-276', 'Book', TO_DATE('2020-05-06','YYYY-MM-DD'), 'M117SV', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200506-S1-277', 'Room', TO_DATE('2020-05-06','YYYY-MM-DD'), 'M106SV', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200507-M1-278', 'Room', TO_DATE('2020-05-07','YYYY-MM-DD'), 'M112BR', 'Website', 'S113M','Poitner, Speaker','Done');
INSERT INTO reservation VALUES ('200507-B1-279', 'Book', TO_DATE('2020-05-07','YYYY-MM-DD'), 'M102SV', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200507-B1-280', 'Book', TO_DATE('2020-05-07','YYYY-MM-DD'), 'M106SV', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200507-B1-281', 'Book', TO_DATE('2020-05-07','YYYY-MM-DD'), 'M101BR', 'Direct', 'S120F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200507-S1-282', 'Room', TO_DATE('2020-05-07','YYYY-MM-DD'), 'M113SV', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200508-B1-283', 'Book', TO_DATE('2020-05-08','YYYY-MM-DD'), 'M117SV', 'Website', 'S119F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200508-B1-284', 'Book', TO_DATE('2020-05-08','YYYY-MM-DD'), 'M112BR', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200508-M2-285', 'Room', TO_DATE('2020-05-08','YYYY-MM-DD'), 'M104SV', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200508-M1-286', 'Room', TO_DATE('2020-05-08','YYYY-MM-DD'), 'M119BR', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200508-M1-287', 'Room', TO_DATE('2020-05-08','YYYY-MM-DD'), 'M109SV', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200509-M1-288', 'Room', TO_DATE('2020-05-09','YYYY-MM-DD'), 'M108GD', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200509-B1-289', 'Book', TO_DATE('2020-05-09','YYYY-MM-DD'), 'M104SV', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200509-M1-290', 'Room', TO_DATE('2020-05-09','YYYY-MM-DD'), 'M115GD', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200510-S1-291', 'Room', TO_DATE('2020-05-10','YYYY-MM-DD'), 'M107BR', 'Website', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200510-B1-292', 'Book', TO_DATE('2020-05-10','YYYY-MM-DD'), 'M115GD', 'Contact', 'S107F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200510-M2-293', 'Room', TO_DATE('2020-05-10','YYYY-MM-DD'), 'M116BR', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200510-B1-294', 'Book', TO_DATE('2020-05-10','YYYY-MM-DD'), 'M117SV', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200510-B1-295', 'Book', TO_DATE('2020-05-10','YYYY-MM-DD'), 'M110BR', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200510-B1-296', 'Book', TO_DATE('2020-05-10','YYYY-MM-DD'), 'M103BR', 'Contact', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200511-B1-297', 'Book', TO_DATE('2020-05-11','YYYY-MM-DD'), 'M108GD', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200511-M1-298', 'Room', TO_DATE('2020-05-11','YYYY-MM-DD'), 'M109SV', 'Website', 'S113M','HDMI Cable, Speaker','Done');
INSERT INTO reservation VALUES ('200511-B1-299', 'Book', TO_DATE('2020-05-11','YYYY-MM-DD'), 'M110BR', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200512-B1-300', 'Book', TO_DATE('2020-05-12','YYYY-MM-DD'), 'M103BR', 'Direct', 'S105M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200512-B1-301', 'Book', TO_DATE('2020-05-12','YYYY-MM-DD'), 'M107BR', 'Contact', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200512-B1-302', 'Book', TO_DATE('2020-05-12','YYYY-MM-DD'), 'M113SV', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200513-B1-303', 'Book', TO_DATE('2020-05-13','YYYY-MM-DD'), 'M118GD', 'Website', 'S114M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200513-M1-304', 'Room', TO_DATE('2020-05-13','YYYY-MM-DD'), 'M103BR', 'Direct', 'S107F','HDMI Cable, Speaker','Done');
INSERT INTO reservation VALUES ('200513-B1-305', 'Book', TO_DATE('2020-05-13','YYYY-MM-DD'), 'M112BR', 'Website', 'S120F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200513-M2-306', 'Room', TO_DATE('2020-05-13','YYYY-MM-DD'), 'M113SV', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200514-B1-307', 'Book', TO_DATE('2020-05-14','YYYY-MM-DD'), 'M120GD', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200514-B1-308', 'Book', TO_DATE('2020-05-14','YYYY-MM-DD'), 'M108GD', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200514-B1-309', 'Book', TO_DATE('2020-05-14','YYYY-MM-DD'), 'M109SV', 'Website', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200515-B1-310', 'Book', TO_DATE('2020-05-15','YYYY-MM-DD'), 'M103BR', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200515-S1-311', 'Room', TO_DATE('2020-05-15','YYYY-MM-DD'), 'M111GD', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200515-M1-312', 'Room', TO_DATE('2020-05-15','YYYY-MM-DD'), 'M111GD', 'Website', 'S107F','Speaker','Done');
INSERT INTO reservation VALUES ('200515-M2-313', 'Room', TO_DATE('2020-05-15','YYYY-MM-DD'), 'M116BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200515-B1-314', 'Book', TO_DATE('2020-05-15','YYYY-MM-DD'), 'M111GD', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200515-B1-315', 'Book', TO_DATE('2020-05-15','YYYY-MM-DD'), 'M102SV', 'Website', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200516-M3-316', 'Room', TO_DATE('2020-05-16','YYYY-MM-DD'), 'M102SV', 'Website', 'S117M','HDMI Cable','Done');
INSERT INTO reservation VALUES ('200516-S1-317', 'Room', TO_DATE('2020-05-16','YYYY-MM-DD'), 'M112BR', 'Website', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200516-S1-318', 'Room', TO_DATE('2020-05-16','YYYY-MM-DD'), 'M110BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200516-B1-319', 'Book', TO_DATE('2020-05-16','YYYY-MM-DD'), 'M102SV', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200516-M1-320', 'Room', TO_DATE('2020-05-16','YYYY-MM-DD'), 'M114BR', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200517-M2-321', 'Room', TO_DATE('2020-05-17','YYYY-MM-DD'), 'M117SV', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200517-B1-322', 'Book', TO_DATE('2020-05-17','YYYY-MM-DD'), 'M107BR', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200517-S1-323', 'Room', TO_DATE('2020-05-17','YYYY-MM-DD'), 'M106SV', 'Direct', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200517-S1-324', 'Room', TO_DATE('2020-05-17','YYYY-MM-DD'), 'M104SV', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200518-M1-325', 'Room', TO_DATE('2020-05-18','YYYY-MM-DD'), 'M107BR', 'Contact', 'S113M','HDMI Cable','Done');
INSERT INTO reservation VALUES ('200518-S1-326', 'Room', TO_DATE('2020-05-18','YYYY-MM-DD'), 'M118GD', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200518-S1-327', 'Room', TO_DATE('2020-05-18','YYYY-MM-DD'), 'M105GD', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200519-B1-328', 'Book', TO_DATE('2020-05-19','YYYY-MM-DD'), 'M102SV', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200519-B1-329', 'Book', TO_DATE('2020-05-19','YYYY-MM-DD'), 'M117SV', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200519-S1-330', 'Room', TO_DATE('2020-05-19','YYYY-MM-DD'), 'M120GD', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200519-B1-331', 'Book', TO_DATE('2020-05-19','YYYY-MM-DD'), 'M102SV', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200519-M1-332', 'Room', TO_DATE('2020-05-19','YYYY-MM-DD'), 'M115GD', 'Website', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200520-S1-333', 'Room', TO_DATE('2020-05-20','YYYY-MM-DD'), 'M106SV', 'Contact', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200520-M1-334', 'Room', TO_DATE('2020-05-20','YYYY-MM-DD'), 'M107BR', 'Direct', 'S108F','Poitner, Speaker','Done');
INSERT INTO reservation VALUES ('200520-B1-335', 'Book', TO_DATE('2020-05-20','YYYY-MM-DD'), 'M110BR', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200520-S1-336', 'Room', TO_DATE('2020-05-20','YYYY-MM-DD'), 'M104SV', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200520-B1-337', 'Book', TO_DATE('2020-05-20','YYYY-MM-DD'), 'M120GD', 'Website', 'S106F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200521-S1-338', 'Room', TO_DATE('2020-05-21','YYYY-MM-DD'), 'M108GD', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200521-B1-339', 'Book', TO_DATE('2020-05-21','YYYY-MM-DD'), 'M119BR', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200521-M1-340', 'Room', TO_DATE('2020-05-21','YYYY-MM-DD'), 'M118GD', 'Website', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200521-M3-341', 'Room', TO_DATE('2020-05-21','YYYY-MM-DD'), 'M112BR', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200522-S1-342', 'Room', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M115GD', 'Website', 'S114M','Head Phone','Done');
INSERT INTO reservation VALUES ('200522-B1-343', 'Book', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M112BR', 'Direct', 'S106F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200522-B1-344', 'Book', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M120GD', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200522-M2-345', 'Room', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M110BR', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200522-B1-346', 'Book', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M106SV', 'Contact', 'S115M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200522-B1-347', 'Book', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M107BR', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200522-S1-348', 'Room', TO_DATE('2020-05-22','YYYY-MM-DD'), 'M108GD', 'Contact', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200523-B1-349', 'Book', TO_DATE('2020-05-23','YYYY-MM-DD'), 'M103BR', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200523-S1-350', 'Room', TO_DATE('2020-05-23','YYYY-MM-DD'), 'M101BR', 'Contact', 'S108F','Head Phone','Done');
INSERT INTO reservation VALUES ('200523-B1-351', 'Book', TO_DATE('2020-05-23','YYYY-MM-DD'), 'M115GD', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200524-S1-352', 'Room', TO_DATE('2020-05-24','YYYY-MM-DD'), 'M114BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200524-B1-353', 'Book', TO_DATE('2020-05-24','YYYY-MM-DD'), 'M112BR', 'Contact', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200524-S1-354', 'Room', TO_DATE('2020-05-24','YYYY-MM-DD'), 'M119BR', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200524-S1-355', 'Room', TO_DATE('2020-05-24','YYYY-MM-DD'), 'M102SV', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200525-S1-356', 'Room', TO_DATE('2020-05-25','YYYY-MM-DD'), 'M117SV', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200525-M1-357', 'Room', TO_DATE('2020-05-25','YYYY-MM-DD'), 'M119BR', 'Direct', 'S106F','Pointer','Done');
INSERT INTO reservation VALUES ('200525-S1-358', 'Room', TO_DATE('2020-05-25','YYYY-MM-DD'), 'M113SV', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200525-S1-359', 'Room', TO_DATE('2020-05-25','YYYY-MM-DD'), 'M116BR', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200525-M1-360', 'Room', TO_DATE('2020-05-25','YYYY-MM-DD'), 'M112BR', 'Website', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200526-B1-361', 'Book', TO_DATE('2020-05-26','YYYY-MM-DD'), 'M106SV', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200526-S1-362', 'Room', TO_DATE('2020-05-26','YYYY-MM-DD'), 'M114BR', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200526-S1-363', 'Room', TO_DATE('2020-05-26','YYYY-MM-DD'), 'M115GD', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200526-S1-364', 'Room', TO_DATE('2020-05-26','YYYY-MM-DD'), 'M109SV', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200527-B1-365', 'Book', TO_DATE('2020-05-27','YYYY-MM-DD'), 'M114BR', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200527-B1-366', 'Book', TO_DATE('2020-05-27','YYYY-MM-DD'), 'M105GD', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200527-S1-367', 'Room', TO_DATE('2020-05-27','YYYY-MM-DD'), 'M117SV', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200527-B1-368', 'Book', TO_DATE('2020-05-27','YYYY-MM-DD'), 'M104SV', 'Website', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200528-S1-369', 'Room', TO_DATE('2020-05-28','YYYY-MM-DD'), 'M119BR', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200528-B1-370', 'Book', TO_DATE('2020-05-28','YYYY-MM-DD'), 'M115GD', 'Direct', 'S101M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200528-B1-371', 'Book', TO_DATE('2020-05-28','YYYY-MM-DD'), 'M106SV', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200529-M1-372', 'Room', TO_DATE('2020-05-29','YYYY-MM-DD'), 'M108GD', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200529-B1-373', 'Book', TO_DATE('2020-05-29','YYYY-MM-DD'), 'M111GD', 'Direct', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200529-S1-374', 'Room', TO_DATE('2020-05-29','YYYY-MM-DD'), 'M105GD', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200530-M3-375', 'Room', TO_DATE('2020-05-30','YYYY-MM-DD'), 'M106SV', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200530-B1-376', 'Book', TO_DATE('2020-05-30','YYYY-MM-DD'), 'M114BR', 'Website', 'S111F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200530-S1-377', 'Room', TO_DATE('2020-05-30','YYYY-MM-DD'), 'M110BR', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200531-B1-378', 'Book', TO_DATE('2020-05-31','YYYY-MM-DD'), 'M104SV', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200531-M3-379', 'Room', TO_DATE('2020-05-31','YYYY-MM-DD'), 'M101BR', 'Website', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200531-B1-380', 'Book', TO_DATE('2020-05-31','YYYY-MM-DD'), 'M116BR', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200531-S1-381', 'Room', TO_DATE('2020-05-31','YYYY-MM-DD'), 'M116BR', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200601-S1-382', 'Room', TO_DATE('2020-06-01','YYYY-MM-DD'), 'M111GD', 'Contact', 'S120F','Head Phone','Done');
INSERT INTO reservation VALUES ('200601-S1-383', 'Room', TO_DATE('2020-06-01','YYYY-MM-DD'), 'M109SV', 'Website', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200601-B1-384', 'Book', TO_DATE('2020-06-01','YYYY-MM-DD'), 'M116BR', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200602-B1-385', 'Book', TO_DATE('2020-06-02','YYYY-MM-DD'), 'M103BR', 'Website', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200602-B1-386', 'Book', TO_DATE('2020-06-02','YYYY-MM-DD'), 'M119BR', 'Direct', 'S105M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200602-B1-387', 'Book', TO_DATE('2020-06-02','YYYY-MM-DD'), 'M104SV', 'Website', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200602-S1-388', 'Room', TO_DATE('2020-06-02','YYYY-MM-DD'), 'M107BR', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200603-B1-389', 'Book', TO_DATE('2020-06-03','YYYY-MM-DD'), 'M107BR', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200603-S1-390', 'Room', TO_DATE('2020-06-03','YYYY-MM-DD'), 'M120GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200603-B1-391', 'Book', TO_DATE('2020-06-03','YYYY-MM-DD'), 'M109SV', 'Direct', 'S114M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200603-S1-392', 'Room', TO_DATE('2020-06-03','YYYY-MM-DD'), 'M109SV', 'Contact', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200603-M2-393', 'Room', TO_DATE('2020-06-03','YYYY-MM-DD'), 'M104SV', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200604-B1-394', 'Book', TO_DATE('2020-06-04','YYYY-MM-DD'), 'M107BR', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200604-S1-395', 'Room', TO_DATE('2020-06-04','YYYY-MM-DD'), 'M111GD', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200604-B1-396', 'Book', TO_DATE('2020-06-04','YYYY-MM-DD'), 'M117SV', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200604-S1-397', 'Room', TO_DATE('2020-06-04','YYYY-MM-DD'), 'M101BR', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200605-B1-398', 'Book', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M116BR', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200605-M1-399', 'Room', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M112BR', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200605-S1-400', 'Room', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M108GD', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200605-S1-401', 'Room', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M112BR', 'Website', 'S115M','Head Phone','Done');
INSERT INTO reservation VALUES ('200605-M1-402', 'Room', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M120GD', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200605-B1-403', 'Book', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M112BR', 'Contact', 'S108F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200605-S1-404', 'Room', TO_DATE('2020-06-05','YYYY-MM-DD'), 'M119BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200606-S1-405', 'Room', TO_DATE('2020-06-06','YYYY-MM-DD'), 'M103BR', 'Website', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200606-S1-406', 'Room', TO_DATE('2020-06-06','YYYY-MM-DD'), 'M114BR', 'Contact', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200606-M1-407', 'Room', TO_DATE('2020-06-06','YYYY-MM-DD'), 'M120GD', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200606-M1-408', 'Room', TO_DATE('2020-06-06','YYYY-MM-DD'), 'M111GD', 'Website', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200607-B1-409', 'Book', TO_DATE('2020-06-07','YYYY-MM-DD'), 'M106SV', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200607-B1-410', 'Book', TO_DATE('2020-06-07','YYYY-MM-DD'), 'M104SV', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200607-S1-411', 'Room', TO_DATE('2020-06-07','YYYY-MM-DD'), 'M117SV', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200608-B1-412', 'Book', TO_DATE('2020-06-08','YYYY-MM-DD'), 'M116BR', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200608-B1-413', 'Book', TO_DATE('2020-06-08','YYYY-MM-DD'), 'M106SV', 'Website', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200608-B1-414', 'Book', TO_DATE('2020-06-08','YYYY-MM-DD'), 'M119BR', 'Direct', 'S116M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200608-B1-415', 'Book', TO_DATE('2020-06-08','YYYY-MM-DD'), 'M102SV', 'Website', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200609-S1-416', 'Room', TO_DATE('2020-06-09','YYYY-MM-DD'), 'M105GD', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200609-M1-417', 'Room', TO_DATE('2020-06-09','YYYY-MM-DD'), 'M106SV', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200609-S1-418', 'Room', TO_DATE('2020-06-09','YYYY-MM-DD'), 'M104SV', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200609-B1-419', 'Book', TO_DATE('2020-06-09','YYYY-MM-DD'), 'M109SV', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200609-B1-420', 'Book', TO_DATE('2020-06-09','YYYY-MM-DD'), 'M104SV', 'Direct', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200610-B1-421', 'Book', TO_DATE('2020-06-10','YYYY-MM-DD'), 'M103BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200610-M1-422', 'Room', TO_DATE('2020-06-10','YYYY-MM-DD'), 'M110BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200610-B1-423', 'Book', TO_DATE('2020-06-10','YYYY-MM-DD'), 'M115GD', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200611-S1-424', 'Room', TO_DATE('2020-06-11','YYYY-MM-DD'), 'M117SV', 'Website', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200611-S1-425', 'Room', TO_DATE('2020-06-11','YYYY-MM-DD'), 'M117SV', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200611-M2-426', 'Room', TO_DATE('2020-06-11','YYYY-MM-DD'), 'M118GD', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200611-B1-427', 'Book', TO_DATE('2020-06-11','YYYY-MM-DD'), 'M113SV', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200611-B1-428', 'Book', TO_DATE('2020-06-11','YYYY-MM-DD'), 'M108GD', 'Website', 'S108F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200611-S1-429', 'Room', TO_DATE('2020-06-11','YYYY-MM-DD'), 'M104SV', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200612-B1-430', 'Book', TO_DATE('2020-06-12','YYYY-MM-DD'), 'M104SV', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200612-B1-431', 'Book', TO_DATE('2020-06-12','YYYY-MM-DD'), 'M119BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200612-B1-432', 'Book', TO_DATE('2020-06-12','YYYY-MM-DD'), 'M115GD', 'Website', 'S119F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200612-S1-433', 'Room', TO_DATE('2020-06-12','YYYY-MM-DD'), 'M108GD', 'Website', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200613-B1-434', 'Book', TO_DATE('2020-06-13','YYYY-MM-DD'), 'M106SV', 'Contact', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200613-S1-435', 'Room', TO_DATE('2020-06-13','YYYY-MM-DD'), 'M119BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200613-B1-436', 'Book', TO_DATE('2020-06-13','YYYY-MM-DD'), 'M113SV', 'Website', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200613-M1-437', 'Room', TO_DATE('2020-06-13','YYYY-MM-DD'), 'M101BR', 'Direct', 'S106F','Pointer','Done');
INSERT INTO reservation VALUES ('200613-B1-438', 'Book', TO_DATE('2020-06-13','YYYY-MM-DD'), 'M110BR', 'Direct', 'S118F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200614-B1-439', 'Book', TO_DATE('2020-06-14','YYYY-MM-DD'), 'M104SV', 'Website', 'S110F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200614-M1-440', 'Room', TO_DATE('2020-06-14','YYYY-MM-DD'), 'M116BR', 'Website', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200614-B1-441', 'Book', TO_DATE('2020-06-14','YYYY-MM-DD'), 'M114BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200614-S1-442', 'Room', TO_DATE('2020-06-14','YYYY-MM-DD'), 'M116BR', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200615-B1-443', 'Book', TO_DATE('2020-06-15','YYYY-MM-DD'), 'M108GD', 'Direct', 'S104M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200615-B1-444', 'Book', TO_DATE('2020-06-15','YYYY-MM-DD'), 'M110BR', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200615-B1-445', 'Book', TO_DATE('2020-06-15','YYYY-MM-DD'), 'M114BR', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200615-S1-446', 'Room', TO_DATE('2020-06-15','YYYY-MM-DD'), 'M120GD', 'Direct', 'S110F','Head Phone','Done');
INSERT INTO reservation VALUES ('200616-B1-447', 'Book', TO_DATE('2020-06-16','YYYY-MM-DD'), 'M108GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200616-B1-448', 'Book', TO_DATE('2020-06-16','YYYY-MM-DD'), 'M120GD', 'Direct', 'S111F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200616-S1-449', 'Room', TO_DATE('2020-06-16','YYYY-MM-DD'), 'M112BR', 'Contact', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200616-M1-450', 'Room', TO_DATE('2020-06-16','YYYY-MM-DD'), 'M119BR', 'Contact', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200617-S1-451', 'Room', TO_DATE('2020-06-17','YYYY-MM-DD'), 'M116BR', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200617-B1-452', 'Book', TO_DATE('2020-06-17','YYYY-MM-DD'), 'M107BR', 'Direct', 'S120F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200617-S1-453', 'Room', TO_DATE('2020-06-17','YYYY-MM-DD'), 'M115GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200618-S1-454', 'Room', TO_DATE('2020-06-18','YYYY-MM-DD'), 'M117SV', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200618-M3-455', 'Room', TO_DATE('2020-06-18','YYYY-MM-DD'), 'M111GD', 'Direct', 'S110F','HDMI Cable, Pointer','Done');
INSERT INTO reservation VALUES ('200618-B1-456', 'Book', TO_DATE('2020-06-18','YYYY-MM-DD'), 'M118GD', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200619-B1-457', 'Book', TO_DATE('2020-06-19','YYYY-MM-DD'), 'M105GD', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200619-S1-458', 'Room', TO_DATE('2020-06-19','YYYY-MM-DD'), 'M118GD', 'Direct', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200619-B1-459', 'Book', TO_DATE('2020-06-19','YYYY-MM-DD'), 'M113SV', 'Direct', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200619-B1-460', 'Book', TO_DATE('2020-06-19','YYYY-MM-DD'), 'M114BR', 'Website', 'S116M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200620-B1-461', 'Book', TO_DATE('2020-06-20','YYYY-MM-DD'), 'M116BR', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200620-S1-462', 'Room', TO_DATE('2020-06-20','YYYY-MM-DD'), 'M110BR', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200620-B1-463', 'Book', TO_DATE('2020-06-20','YYYY-MM-DD'), 'M105GD', 'Direct', 'S109M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200620-B1-464', 'Book', TO_DATE('2020-06-20','YYYY-MM-DD'), 'M102SV', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200621-S1-465', 'Room', TO_DATE('2020-06-21','YYYY-MM-DD'), 'M115GD', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200621-B1-466', 'Book', TO_DATE('2020-06-21','YYYY-MM-DD'), 'M111GD', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200621-S1-467', 'Room', TO_DATE('2020-06-21','YYYY-MM-DD'), 'M118GD', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200621-B1-468', 'Book', TO_DATE('2020-06-21','YYYY-MM-DD'), 'M119BR', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200622-S1-469', 'Room', TO_DATE('2020-06-22','YYYY-MM-DD'), 'M101BR', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200622-S1-470', 'Room', TO_DATE('2020-06-22','YYYY-MM-DD'), 'M120GD', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200622-B1-471', 'Book', TO_DATE('2020-06-22','YYYY-MM-DD'), 'M119BR', 'Website', 'S103M',NULL,'Done');
INSERT INTO reservation VALUES ('200623-B1-472', 'Book', TO_DATE('2020-06-23','YYYY-MM-DD'), 'M118GD', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200623-S1-473', 'Room', TO_DATE('2020-06-23','YYYY-MM-DD'), 'M115GD', 'Contact', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200623-B1-474', 'Book', TO_DATE('2020-06-23','YYYY-MM-DD'), 'M109SV', 'Website', 'S119F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200624-B1-475', 'Book', TO_DATE('2020-06-24','YYYY-MM-DD'), 'M116BR', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200624-S1-476', 'Room', TO_DATE('2020-06-24','YYYY-MM-DD'), 'M108GD', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200624-S1-477', 'Room', TO_DATE('2020-06-24','YYYY-MM-DD'), 'M116BR', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200624-B1-478', 'Book', TO_DATE('2020-06-24','YYYY-MM-DD'), 'M120GD', 'Contact', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200625-B1-479', 'Book', TO_DATE('2020-06-25','YYYY-MM-DD'), 'M110BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200625-S1-480', 'Room', TO_DATE('2020-06-25','YYYY-MM-DD'), 'M118GD', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200625-B1-481', 'Book', TO_DATE('2020-06-25','YYYY-MM-DD'), 'M102SV', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200625-M1-482', 'Room', TO_DATE('2020-06-25','YYYY-MM-DD'), 'M120GD', 'Contact', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200625-B1-483', 'Book', TO_DATE('2020-06-25','YYYY-MM-DD'), 'M105GD', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200626-S1-484', 'Room', TO_DATE('2020-06-26','YYYY-MM-DD'), 'M113SV', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200626-M3-485', 'Room', TO_DATE('2020-06-26','YYYY-MM-DD'), 'M120GD', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200626-B1-486', 'Book', TO_DATE('2020-06-26','YYYY-MM-DD'), 'M116BR', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200626-B1-487', 'Book', TO_DATE('2020-06-26','YYYY-MM-DD'), 'M108GD', 'Website', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200626-M3-488', 'Room', TO_DATE('2020-06-26','YYYY-MM-DD'), 'M120GD', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200627-M2-489', 'Room', TO_DATE('2020-06-27','YYYY-MM-DD'), 'M118GD', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200627-M1-490', 'Room', TO_DATE('2020-06-27','YYYY-MM-DD'), 'M103BR', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200627-B1-491', 'Book', TO_DATE('2020-06-27','YYYY-MM-DD'), 'M114BR', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200628-B1-492', 'Book', TO_DATE('2020-06-28','YYYY-MM-DD'), 'M108GD', 'Website', 'S112F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200628-B1-493', 'Book', TO_DATE('2020-06-28','YYYY-MM-DD'), 'M101BR', 'Website', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200628-S1-494', 'Room', TO_DATE('2020-06-28','YYYY-MM-DD'), 'M116BR', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200629-M1-495', 'Room', TO_DATE('2020-06-29','YYYY-MM-DD'), 'M106SV', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200629-S1-496', 'Room', TO_DATE('2020-06-29','YYYY-MM-DD'), 'M113SV', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200629-M1-497', 'Room', TO_DATE('2020-06-29','YYYY-MM-DD'), 'M107BR', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200629-M1-498', 'Room', TO_DATE('2020-06-29','YYYY-MM-DD'), 'M102SV', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200630-S1-499', 'Room', TO_DATE('2020-06-30','YYYY-MM-DD'), 'M107BR', 'Contact', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200630-B1-500', 'Book', TO_DATE('2020-06-30','YYYY-MM-DD'), 'M115GD', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200630-S1-501', 'Room', TO_DATE('2020-06-30','YYYY-MM-DD'), 'M114BR', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200630-B1-502', 'Book', TO_DATE('2020-06-30','YYYY-MM-DD'), 'M112BR', 'Contact', 'S105M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200630-B1-503', 'Book', TO_DATE('2020-06-30','YYYY-MM-DD'), 'M110BR', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200701-B1-504', 'Book', TO_DATE('2020-07-01','YYYY-MM-DD'), 'M108GD', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200701-M2-505', 'Room', TO_DATE('2020-07-01','YYYY-MM-DD'), 'M114BR', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200701-S1-506', 'Room', TO_DATE('2020-07-01','YYYY-MM-DD'), 'M108GD', 'Contact', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200702-S1-507', 'Room', TO_DATE('2020-07-02','YYYY-MM-DD'), 'M120GD', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200702-M2-508', 'Room', TO_DATE('2020-07-02','YYYY-MM-DD'), 'M102SV', 'Website', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200702-S1-509', 'Room', TO_DATE('2020-07-02','YYYY-MM-DD'), 'M112BR', 'Contact', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200703-M1-510', 'Room', TO_DATE('2020-07-03','YYYY-MM-DD'), 'M106SV', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200703-M1-511', 'Room', TO_DATE('2020-07-03','YYYY-MM-DD'), 'M118GD', 'Website', 'S113M','Poitner, Speaker','Done');
INSERT INTO reservation VALUES ('200703-B1-512', 'Book', TO_DATE('2020-07-03','YYYY-MM-DD'), 'M109SV', 'Website', 'S113M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200703-S1-513', 'Room', TO_DATE('2020-07-03','YYYY-MM-DD'), 'M109SV', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200703-M1-514', 'Room', TO_DATE('2020-07-03','YYYY-MM-DD'), 'M106SV', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200704-S1-515', 'Room', TO_DATE('2020-07-04','YYYY-MM-DD'), 'M101BR', 'Website', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200704-M2-516', 'Room', TO_DATE('2020-07-04','YYYY-MM-DD'), 'M103BR', 'Website', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200704-B1-517', 'Book', TO_DATE('2020-07-04','YYYY-MM-DD'), 'M110BR', 'Contact', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200704-M1-518', 'Room', TO_DATE('2020-07-04','YYYY-MM-DD'), 'M111GD', 'Contact', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200705-S1-519', 'Room', TO_DATE('2020-07-05','YYYY-MM-DD'), 'M111GD', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200705-M2-520', 'Room', TO_DATE('2020-07-05','YYYY-MM-DD'), 'M107BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200705-B1-521', 'Book', TO_DATE('2020-07-05','YYYY-MM-DD'), 'M102SV', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200706-B1-522', 'Book', TO_DATE('2020-07-06','YYYY-MM-DD'), 'M108GD', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200706-B1-523', 'Book', TO_DATE('2020-07-06','YYYY-MM-DD'), 'M107BR', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200706-B1-524', 'Book', TO_DATE('2020-07-06','YYYY-MM-DD'), 'M120GD', 'Contact', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200706-B1-525', 'Book', TO_DATE('2020-07-06','YYYY-MM-DD'), 'M104SV', 'Website', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200707-B1-526', 'Book', TO_DATE('2020-07-07','YYYY-MM-DD'), 'M103BR', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200707-S1-527', 'Room', TO_DATE('2020-07-07','YYYY-MM-DD'), 'M105GD', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200707-S1-528', 'Room', TO_DATE('2020-07-07','YYYY-MM-DD'), 'M119BR', 'Contact', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200707-B1-529', 'Book', TO_DATE('2020-07-07','YYYY-MM-DD'), 'M101BR', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200708-B1-530', 'Book', TO_DATE('2020-07-08','YYYY-MM-DD'), 'M108GD', 'Website', 'S112F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200708-M2-531', 'Room', TO_DATE('2020-07-08','YYYY-MM-DD'), 'M118GD', 'Direct', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200708-B1-532', 'Book', TO_DATE('2020-07-08','YYYY-MM-DD'), 'M119BR', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200709-B1-533', 'Book', TO_DATE('2020-07-09','YYYY-MM-DD'), 'M109SV', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200709-B1-534', 'Book', TO_DATE('2020-07-09','YYYY-MM-DD'), 'M110BR', 'Direct', 'S114M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200709-B1-535', 'Book', TO_DATE('2020-07-09','YYYY-MM-DD'), 'M113SV', 'Website', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200710-S1-536', 'Room', TO_DATE('2020-07-10','YYYY-MM-DD'), 'M110BR', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200710-S1-537', 'Room', TO_DATE('2020-07-10','YYYY-MM-DD'), 'M115GD', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200710-B1-538', 'Book', TO_DATE('2020-07-10','YYYY-MM-DD'), 'M111GD', 'Website', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200710-B1-539', 'Book', TO_DATE('2020-07-10','YYYY-MM-DD'), 'M117SV', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200711-S1-540', 'Room', TO_DATE('2020-07-11','YYYY-MM-DD'), 'M111GD', 'Direct', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200711-B1-541', 'Book', TO_DATE('2020-07-11','YYYY-MM-DD'), 'M101BR', 'Website', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200711-S1-542', 'Room', TO_DATE('2020-07-11','YYYY-MM-DD'), 'M115GD', 'Direct', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200711-S1-543', 'Room', TO_DATE('2020-07-11','YYYY-MM-DD'), 'M101BR', 'Direct', 'S102F','Head Phone','Done');
INSERT INTO reservation VALUES ('200711-B1-544', 'Book', TO_DATE('2020-07-11','YYYY-MM-DD'), 'M110BR', 'Direct', 'S119F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200712-S1-545', 'Room', TO_DATE('2020-07-12','YYYY-MM-DD'), 'M102SV', 'Website', 'S119F','Head Phone','Done');
INSERT INTO reservation VALUES ('200712-B1-546', 'Book', TO_DATE('2020-07-12','YYYY-MM-DD'), 'M119BR', 'Direct', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200712-B1-547', 'Book', TO_DATE('2020-07-12','YYYY-MM-DD'), 'M104SV', 'Direct', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200713-B1-548', 'Book', TO_DATE('2020-07-13','YYYY-MM-DD'), 'M105GD', 'Contact', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200713-B1-549', 'Book', TO_DATE('2020-07-13','YYYY-MM-DD'), 'M109SV', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200713-M1-550', 'Room', TO_DATE('2020-07-13','YYYY-MM-DD'), 'M101BR', 'Contact', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200713-S1-551', 'Room', TO_DATE('2020-07-13','YYYY-MM-DD'), 'M105GD', 'Contact', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200714-M1-552', 'Room', TO_DATE('2020-07-14','YYYY-MM-DD'), 'M116BR', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200714-B1-553', 'Book', TO_DATE('2020-07-14','YYYY-MM-DD'), 'M107BR', 'Contact', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200714-M1-554', 'Room', TO_DATE('2020-07-14','YYYY-MM-DD'), 'M110BR', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200715-B1-555', 'Book', TO_DATE('2020-07-15','YYYY-MM-DD'), 'M103BR', 'Direct', 'S105M',NULL,'Done');
INSERT INTO reservation VALUES ('200715-S1-556', 'Room', TO_DATE('2020-07-15','YYYY-MM-DD'), 'M120GD', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200715-B1-557', 'Book', TO_DATE('2020-07-15','YYYY-MM-DD'), 'M118GD', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200715-B1-558', 'Book', TO_DATE('2020-07-15','YYYY-MM-DD'), 'M107BR', 'Contact', 'S107F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200716-S1-559', 'Room', TO_DATE('2020-07-16','YYYY-MM-DD'), 'M114BR', 'Contact', 'S118F',NULL,'Done');
INSERT INTO reservation VALUES ('200716-B1-560', 'Book', TO_DATE('2020-07-16','YYYY-MM-DD'), 'M113SV', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200716-B1-561', 'Book', TO_DATE('2020-07-16','YYYY-MM-DD'), 'M108GD', 'Direct', 'S116M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200716-M1-562', 'Room', TO_DATE('2020-07-16','YYYY-MM-DD'), 'M106SV', 'Website', 'S119F',NULL,'Done');
INSERT INTO reservation VALUES ('200716-B1-563', 'Book', TO_DATE('2020-07-16','YYYY-MM-DD'), 'M115GD', 'Contact', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200716-B1-564', 'Book', TO_DATE('2020-07-16','YYYY-MM-DD'), 'M107BR', 'Direct', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200717-S1-565', 'Room', TO_DATE('2020-07-17','YYYY-MM-DD'), 'M116BR', 'Direct', 'S109M',NULL,'Done');
INSERT INTO reservation VALUES ('200717-B1-566', 'Book', TO_DATE('2020-07-17','YYYY-MM-DD'), 'M109SV', 'Website', 'S101M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200717-S1-567', 'Room', TO_DATE('2020-07-17','YYYY-MM-DD'), 'M102SV', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200717-M1-568', 'Room', TO_DATE('2020-07-17','YYYY-MM-DD'), 'M117SV', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200718-M1-569', 'Room', TO_DATE('2020-07-18','YYYY-MM-DD'), 'M113SV', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200718-M1-570', 'Room', TO_DATE('2020-07-18','YYYY-MM-DD'), 'M117SV', 'Contact', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200718-M1-571', 'Room', TO_DATE('2020-07-18','YYYY-MM-DD'), 'M116BR', 'Website', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200719-B1-572', 'Book', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M110BR', 'Website', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200719-M1-573', 'Room', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M103BR', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200719-B1-574', 'Book', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M119BR', 'Contact', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200719-S1-575', 'Room', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M103BR', 'Website', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200719-M2-576', 'Room', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M118GD', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200719-S1-577', 'Room', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M114BR', 'Contact', 'S102F','Head Phone','Done');
INSERT INTO reservation VALUES ('200719-S1-578', 'Room', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M113SV', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200719-M1-579', 'Room', TO_DATE('2020-07-19','YYYY-MM-DD'), 'M115GD', 'Direct', 'S104M',NULL,'Done');
INSERT INTO reservation VALUES ('200720-B1-580', 'Book', TO_DATE('2020-07-20','YYYY-MM-DD'), 'M116BR', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200720-B1-581', 'Book', TO_DATE('2020-07-20','YYYY-MM-DD'), 'M104SV', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200720-S1-582', 'Room', TO_DATE('2020-07-20','YYYY-MM-DD'), 'M107BR', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200720-S1-583', 'Room', TO_DATE('2020-07-20','YYYY-MM-DD'), 'M104SV', 'Contact', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200720-B1-584', 'Book', TO_DATE('2020-07-20','YYYY-MM-DD'), 'M118GD', 'Direct', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200721-B1-585', 'Book', TO_DATE('2020-07-21','YYYY-MM-DD'), 'M108GD', 'Direct', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200721-S1-586', 'Room', TO_DATE('2020-07-21','YYYY-MM-DD'), 'M110BR', 'Website', 'S120F',NULL,'Done');
INSERT INTO reservation VALUES ('200721-S1-587', 'Room', TO_DATE('2020-07-21','YYYY-MM-DD'), 'M103BR', 'Contact', 'S108F','Head Phone','Done');
INSERT INTO reservation VALUES ('200721-M1-588', 'Room', TO_DATE('2020-07-21','YYYY-MM-DD'), 'M113SV', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200722-B1-589', 'Book', TO_DATE('2020-07-22','YYYY-MM-DD'), 'M112BR', 'Contact', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200722-B1-590', 'Book', TO_DATE('2020-07-22','YYYY-MM-DD'), 'M109SV', 'Website', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200722-M1-591', 'Room', TO_DATE('2020-07-22','YYYY-MM-DD'), 'M103BR', 'Website', 'S110F','Poitner, Speaker','Done');
INSERT INTO reservation VALUES ('200723-B1-592', 'Book', TO_DATE('2020-07-23','YYYY-MM-DD'), 'M109SV', 'Website', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200723-M1-593', 'Room', TO_DATE('2020-07-23','YYYY-MM-DD'), 'M114BR', 'Contact', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200723-M2-594', 'Room', TO_DATE('2020-07-23','YYYY-MM-DD'), 'M115GD', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200724-B1-595', 'Book', TO_DATE('2020-07-24','YYYY-MM-DD'), 'M108GD', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200724-B1-596', 'Book', TO_DATE('2020-07-24','YYYY-MM-DD'), 'M108GD', 'Contact', 'S113M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200724-M1-597', 'Room', TO_DATE('2020-07-24','YYYY-MM-DD'), 'M114BR', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200724-B1-598', 'Book', TO_DATE('2020-07-24','YYYY-MM-DD'), 'M119BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200724-B1-599', 'Book', TO_DATE('2020-07-24','YYYY-MM-DD'), 'M108GD', 'Contact', 'S106F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200724-M2-600', 'Room', TO_DATE('2020-07-24','YYYY-MM-DD'), 'M105GD', 'Website', 'S106F',NULL,'Done');
INSERT INTO reservation VALUES ('200725-S1-601', 'Room', TO_DATE('2020-07-25','YYYY-MM-DD'), 'M117SV', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200725-M1-602', 'Room', TO_DATE('2020-07-25','YYYY-MM-DD'), 'M111GD', 'Direct', 'S111F',NULL,'Done');
INSERT INTO reservation VALUES ('200725-B1-603', 'Book', TO_DATE('2020-07-25','YYYY-MM-DD'), 'M115GD', 'Website', 'S111F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200725-S1-604', 'Room', TO_DATE('2020-07-25','YYYY-MM-DD'), 'M111GD', 'Website', 'S104M','Head Phone','Done');
INSERT INTO reservation VALUES ('200726-S1-605', 'Room', TO_DATE('2020-07-26','YYYY-MM-DD'), 'M115GD', 'Contact', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200726-B1-606', 'Book', TO_DATE('2020-07-26','YYYY-MM-DD'), 'M103BR', 'Direct', 'S117M',NULL,'Done');
INSERT INTO reservation VALUES ('200726-B1-607', 'Book', TO_DATE('2020-07-26','YYYY-MM-DD'), 'M105GD', 'Website', 'S105M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200727-S1-608', 'Room', TO_DATE('2020-07-27','YYYY-MM-DD'), 'M102SV', 'Contact', 'S102F','Head Phone','Done');
INSERT INTO reservation VALUES ('200727-B1-609', 'Book', TO_DATE('2020-07-27','YYYY-MM-DD'), 'M117SV', 'Website', 'S102F',NULL,'Done');
INSERT INTO reservation VALUES ('200727-B1-610', 'Book', TO_DATE('2020-07-27','YYYY-MM-DD'), 'M117SV', 'Direct', 'S117M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200728-B1-611', 'Book', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M101BR', 'Direct', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200728-B1-612', 'Book', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M107BR', 'Direct', 'S107F','Bookmarks','Done');
INSERT INTO reservation VALUES ('200728-S1-613', 'Room', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M106SV', 'Direct', 'S112F',NULL,'Done');
INSERT INTO reservation VALUES ('200728-B1-614', 'Book', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M106SV', 'Direct', 'S116M',NULL,'Done');
INSERT INTO reservation VALUES ('200728-B1-615', 'Book', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M114BR', 'Contact', 'S103M','Bookmarks','Done');
INSERT INTO reservation VALUES ('200728-B1-616', 'Book', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M104SV', 'Website', 'S114M',NULL,'Done');
INSERT INTO reservation VALUES ('200728-M3-617', 'Room', TO_DATE('2020-07-28','YYYY-MM-DD'), 'M116BR', 'Website', 'S107F',NULL,'Done');
INSERT INTO reservation VALUES ('200729-M2-618', 'Room', TO_DATE('2020-07-29','YYYY-MM-DD'), 'M104SV', 'Direct', 'S115M','HDMI Cable','Done');
INSERT INTO reservation VALUES ('200729-B1-619', 'Book', TO_DATE('2020-07-29','YYYY-MM-DD'), 'M112BR', 'Direct', 'S108F',NULL,'Done');
INSERT INTO reservation VALUES ('200729-B1-620', 'Book', TO_DATE('2020-07-29','YYYY-MM-DD'), 'M119BR', 'Direct', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200729-B1-621', 'Book', TO_DATE('2020-07-29','YYYY-MM-DD'), 'M105GD', 'Website', 'S113M',NULL,'Done');
INSERT INTO reservation VALUES ('200730-B1-622', 'Book', TO_DATE('2020-07-30','YYYY-MM-DD'), 'M113SV', 'Website', 'S101M',NULL,'Done');
INSERT INTO reservation VALUES ('200730-S1-623', 'Room', TO_DATE('2020-07-30','YYYY-MM-DD'), 'M102SV', 'Contact', 'S107F','Head Phone','Done');
INSERT INTO reservation VALUES ('200730-M1-624', 'Room', TO_DATE('2020-07-30','YYYY-MM-DD'), 'M113SV', 'Website', 'S115M',NULL,'Done');
INSERT INTO reservation VALUES ('200731-B1-625', 'Book', TO_DATE('2020-07-31','YYYY-MM-DD'), 'M112BR', 'Direct', 'S110F',NULL,'Done');
INSERT INTO reservation VALUES ('200731-S1-626', 'Room', TO_DATE('2020-07-31','YYYY-MM-DD'), 'M120GD', 'Contact', 'S113M','Head Phone','Done');
INSERT INTO reservation VALUES ('200731-M2-627', 'Room', TO_DATE('2020-07-31','YYYY-MM-DD'), 'M115GD', 'Contact', 'S118F',NULL,'Done');


--Room Reservation table
INSERT INTO room_reservation VALUES ('200301-M3-1','MR-A3F-11','Meeting Room',TO_DATE('2020-03-06 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-06 14:27','YYYY-MM-DD HH24:MI'),8,25);
INSERT INTO room_reservation VALUES ('200301-M1-2','MR-B2F-23','Meeting Room',TO_DATE('2020-03-02 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-02 13:55','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200301-S1-3','SR-BGF-15','Study Room',TO_DATE('2020-03-06 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-06 14:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200303-S1-10','SR-AGF-3','Study Room',TO_DATE('2020-03-05 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-05 14:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200304-M1-11','MR-B2F-24','Meeting Room',TO_DATE('2020-03-07 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-07 17:30','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation VALUES ('200304-M1-12','MR-A1F-7','Meeting Room',TO_DATE('2020-03-06 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-06 11:24','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200304-S1-13','SR-B1F-16','Study Room',TO_DATE('2020-03-07 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-07 10:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200304-S1-14','SR-AGF-2','Study Room',TO_DATE('2020-03-09 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-09 15:59','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200305-M1-19','MR-A1F-6','Meeting Room',TO_DATE('2020-03-07 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-07 14:23','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation VALUES ('200306-M2-20','MR-A2F-10','Meeting Room',TO_DATE('2020-03-07 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-07 13:50','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200306-S1-21','SR-BGF-13','Study Room',TO_DATE('2020-03-07 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-07 11:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200306-S1-22','SR-B2F-21','Study Room',TO_DATE('2020-03-11 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-11 09:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200306-S1-23','SR-AGF-3','Study Room',TO_DATE('2020-03-07 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-07 09:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200307-S1-25','SR-B1F-20','Study Room',TO_DATE('2020-03-07 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-07 14:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200307-M2-26','MR-A2F-9','Meeting Room',TO_DATE('2020-03-10 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-10 16:00','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200307-S1-27','SR-B1F-19','Study Room',TO_DATE('2020-03-10 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-10 17:30','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200308-M1-30','MR-B2F-24','Meeting Room',TO_DATE('2020-03-12 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-12 13:59','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation VALUES ('200308-M2-31','MR-A2F-10','Meeting Room',TO_DATE('2020-03-08 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-08 12:29','YYYY-MM-DD HH24:MI'),5,17.5);
INSERT INTO room_reservation VALUES ('200308-M1-32','MR-A1F-6','Meeting Room',TO_DATE('2020-03-13 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-13 11:54','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation VALUES ('200309-M3-36','MR-A3F-12','Meeting Room',TO_DATE('2020-03-14 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-14 09:52','YYYY-MM-DD HH24:MI'),11,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200310-S1-38','SR-AGF-3','Study Room',TO_DATE('2020-03-14 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-14 14:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200310-S1-39','SR-B1F-18','Study Room',TO_DATE('2020-03-15 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-15 13:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200311-M1-41','MR-B2F-22','Meeting Room',TO_DATE('2020-03-15 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-15 09:26','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation VALUES ('200311-M1-42','MR-B2F-22','Meeting Room',TO_DATE('2020-03-12 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-12 10:52','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation VALUES ('200312-M2-45','MR-A2F-9','Meeting Room',TO_DATE('2020-03-16 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-16 17:24','YYYY-MM-DD HH24:MI'),8,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200313-S1-47','SR-B1F-18','Study Room',TO_DATE('2020-03-14 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-14 15:51','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200313-S1-51','SR-AGF-2','Study Room',TO_DATE('2020-03-17 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-17 15:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200314-M1-55','MR-A1F-6','Meeting Room',TO_DATE('2020-03-19 16:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-19 16:52','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation VALUES ('200314-M2-57','MR-B2F-25','Meeting Room',TO_DATE('2020-03-15 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-15 17:24','YYYY-MM-DD HH24:MI'),8,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200315-S1-60','SR-B1F-17','Study Room',TO_DATE('2020-03-19 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-19 12:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200316-S1-62','SR-B1F-20','Study Room',TO_DATE('2020-03-20 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-20 11:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200316-M1-63','MR-B2F-24','Meeting Room',TO_DATE('2020-03-19 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-19 15:22','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200317-S1-65','SR-BGF-14','Study Room',TO_DATE('2020-03-21 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-21 14:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200317-S1-66','SR-A1F-5','Study Room',TO_DATE('2020-03-21 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-21 16:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200317-S1-67','SR-AGF-2','Study Room',TO_DATE('2020-03-21 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-21 10:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200320-M1-76','MR-B2F-23','Meeting Room',TO_DATE('2020-03-25 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-25 15:58','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation VALUES ('200320-M1-77','MR-B2F-23','Meeting Room',TO_DATE('2020-03-20 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-20 13:20','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200321-M1-82','MR-A1F-6','Meeting Room',TO_DATE('2020-03-24 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-24 11:30','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200322-S1-84','SR-BGF-13','Study Room',TO_DATE('2020-03-22 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-22 16:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200322-M1-85','MR-B2F-23','Meeting Room',TO_DATE('2020-03-24 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-24 16:30','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200323-S1-87','SR-A1F-5','Study Room',TO_DATE('2020-03-24 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-24 12:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200323-M3-88','MR-A3F-11','Meeting Room',TO_DATE('2020-03-27 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-27 12:23','YYYY-MM-DD HH24:MI'),11,50);
INSERT INTO room_reservation VALUES ('200324-M1-93','MR-B2F-23','Meeting Room',TO_DATE('2020-03-24 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-24 09:57','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200324-S1-94','SR-BGF-13','Study Room',TO_DATE('2020-03-24 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-24 14:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200325-M1-96','MR-B2F-22','Meeting Room',TO_DATE('2020-03-26 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-26 11:55','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200325-M1-98','MR-B2F-23','Meeting Room',TO_DATE('2020-03-30 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-30 12:51','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation VALUES ('200325-M1-99','MR-A1F-7','Meeting Room',TO_DATE('2020-03-28 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-28 14:30','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200325-S1-100','SR-B1F-16','Study Room',TO_DATE('2020-03-30 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-30 10:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200326-S1-101','SR-B1F-18','Study Room',TO_DATE('2020-03-30 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-03-30 10:25','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200326-M2-103','MR-B2F-25','Meeting Room',TO_DATE('2020-03-28 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-28 16:27','YYYY-MM-DD HH24:MI'),5,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200327-S1-104','SR-B2F-21','Study Room',TO_DATE('2020-03-27 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-03-27 09:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200328-M1-109','MR-A1F-6','Meeting Room',TO_DATE('2020-04-01 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-01 14:21','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200329-M2-112','MR-A2F-8','Meeting Room',TO_DATE('2020-04-01 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-01 15:28','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200329-S1-115','SR-AGF-3','Study Room',TO_DATE('2020-04-01 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-01 16:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200329-S1-116','SR-A1F-5','Study Room',TO_DATE('2020-04-02 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-02 14:25','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200330-S1-119','SR-B1F-18','Study Room',TO_DATE('2020-04-04 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-04 12:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200330-S1-120','SR-A1F-5','Study Room',TO_DATE('2020-04-03 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-03 15:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200330-S1-121','SR-B1F-20','Study Room',TO_DATE('2020-04-04 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-04 12:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200330-M2-122','MR-B2F-25','Meeting Room',TO_DATE('2020-04-04 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-04 13:53','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200331-S1-123','SR-B1F-17','Study Room',TO_DATE('2020-04-05 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-05 11:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200401-S1-126','SR-B1F-17','Study Room',TO_DATE('2020-04-06 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-06 15:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200402-M3-130','MR-A3F-12','Meeting Room',TO_DATE('2020-04-05 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-05 15:52','YYYY-MM-DD HH24:MI'),12,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200402-S1-131','SR-A1F-4','Study Room',TO_DATE('2020-04-06 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-06 17:25','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200402-S1-133','SR-B2F-21','Study Room',TO_DATE('2020-04-05 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-05 14:55','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200403-S1-135','SR-B1F-16','Study Room',TO_DATE('2020-04-07 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-07 10:53','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200403-M3-136','MR-A3F-11','Meeting Room',TO_DATE('2020-04-03 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-03 13:55','YYYY-MM-DD HH24:MI'),7,50);
INSERT INTO room_reservation VALUES ('200404-M1-139','MR-B2F-22','Meeting Room',TO_DATE('2020-04-04 11:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-04 11:23','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation VALUES ('200404-M1-140','MR-B2F-23','Meeting Room',TO_DATE('2020-04-08 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-08 09:58','YYYY-MM-DD HH24:MI'),5,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200405-S1-141','SR-AGF-1','Study Room',TO_DATE('2020-04-07 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-07 10:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200405-M1-143','MR-B2F-23','Meeting Room',TO_DATE('2020-04-07 11:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-07 11:55','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation VALUES ('200405-M3-146','MR-A3F-12','Meeting Room',TO_DATE('2020-04-06 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-06 10:26','YYYY-MM-DD HH24:MI'),11,50);
INSERT INTO room_reservation VALUES ('200406-M1-148','MR-B2F-24','Meeting Room',TO_DATE('2020-04-06 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-06 13:22','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation VALUES ('200407-M2-152','MR-A2F-8','Meeting Room',TO_DATE('2020-04-08 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-08 13:53','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation VALUES ('200407-M2-153','MR-B2F-25','Meeting Room',TO_DATE('2020-04-11 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-11 10:59','YYYY-MM-DD HH24:MI'),7,35);
INSERT INTO room_reservation VALUES ('200407-M1-157','MR-B2F-22','Meeting Room',TO_DATE('2020-04-07 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-07 10:58','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200408-M2-159','MR-A2F-10','Meeting Room',TO_DATE('2020-04-09 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-09 13:50','YYYY-MM-DD HH24:MI'),8,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200409-S1-162','SR-B1F-19','Study Room',TO_DATE('2020-04-10 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-10 14:59','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200409-S1-163','SR-B1F-19','Study Room',TO_DATE('2020-04-12 11:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-12 11:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200409-M1-164','MR-B2F-24','Meeting Room',TO_DATE('2020-04-09 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-09 13:59','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation VALUES ('200410-M3-167','MR-A3F-11','Meeting Room',TO_DATE('2020-04-10 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-10 16:20','YYYY-MM-DD HH24:MI'),10,50);
INSERT INTO room_reservation VALUES ('200410-M3-168','MR-A3F-12','Meeting Room',TO_DATE('2020-04-10 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-10 13:29','YYYY-MM-DD HH24:MI'),7,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200411-S1-170','SR-B2F-21','Study Room',TO_DATE('2020-04-14 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-14 14:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200412-M1-172','MR-B2F-22','Meeting Room',TO_DATE('2020-04-13 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-13 13:53','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200412-S1-174','SR-B1F-17','Study Room',TO_DATE('2020-04-13 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-13 15:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200413-M1-179','MR-A1F-7','Meeting Room',TO_DATE('2020-04-13 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-13 13:58','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation VALUES ('200414-M1-181','MR-B2F-23','Meeting Room',TO_DATE('2020-04-18 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-18 16:30','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation VALUES ('200414-M2-182','MR-A2F-10','Meeting Room',TO_DATE('2020-04-19 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-19 15:55','YYYY-MM-DD HH24:MI'),8,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200414-S1-186','SR-AGF-1','Study Room',TO_DATE('2020-04-19 11:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-19 11:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200415-M2-188','MR-A2F-10','Meeting Room',TO_DATE('2020-04-18 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-18 13:59','YYYY-MM-DD HH24:MI'),7,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200415-S1-190','SR-BGF-13','Study Room',TO_DATE('2020-04-18 11:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-18 11:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200416-S1-196','SR-BGF-13','Study Room',TO_DATE('2020-04-18 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-18 09:55','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200416-S1-197','SR-A1F-4','Study Room',TO_DATE('2020-04-18 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-18 14:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200417-S1-199','SR-BGF-13','Study Room',TO_DATE('2020-04-19 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-19 15:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200417-M1-200','MR-B2F-24','Meeting Room',TO_DATE('2020-04-20 16:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-20 16:55','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation VALUES ('200418-M2-204','MR-A2F-10','Meeting Room',TO_DATE('2020-04-19 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-19 14:26','YYYY-MM-DD HH24:MI'),5,17.5);
INSERT INTO room_reservation VALUES ('200418-M2-205','MR-A2F-9','Meeting Room',TO_DATE('2020-04-22 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-22 09:57','YYYY-MM-DD HH24:MI'),6,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200419-S1-209','SR-AGF-2','Study Room',TO_DATE('2020-04-22 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-22 09:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200420-M3-212','MR-A3F-11','Meeting Room',TO_DATE('2020-04-22 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-22 16:23','YYYY-MM-DD HH24:MI'),11,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200421-S1-213','SR-B1F-20','Study Room',TO_DATE('2020-04-22 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-22 14:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200422-S1-216','SR-A1F-5','Study Room',TO_DATE('2020-04-26 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-26 15:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200422-S1-217','SR-AGF-1','Study Room',TO_DATE('2020-04-25 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-25 14:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200422-S1-218','SR-AGF-3','Study Room',TO_DATE('2020-04-25 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-25 15:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200423-M2-221','MR-A2F-10','Meeting Room',TO_DATE('2020-04-28 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-28 15:56','YYYY-MM-DD HH24:MI'),6,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200423-S1-223','SR-BGF-15','Study Room',TO_DATE('2020-04-26 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-26 12:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200424-S1-226','SR-B1F-19','Study Room',TO_DATE('2020-04-25 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-25 10:51','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200424-S1-229','SR-B2F-21','Study Room',TO_DATE('2020-04-29 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-29 13:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200425-M1-231','MR-B2F-23','Meeting Room',TO_DATE('2020-04-27 16:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-27 16:53','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation VALUES ('200425-M1-232','MR-B2F-23','Meeting Room',TO_DATE('2020-04-28 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-28 17:25','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200425-M1-233','MR-A1F-6','Meeting Room',TO_DATE('2020-04-30 10:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-30 10:56','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation VALUES ('200426-M3-235','MR-A3F-11','Meeting Room',TO_DATE('2020-04-28 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-28 13:53','YYYY-MM-DD HH24:MI'),8,25);
INSERT INTO room_reservation VALUES ('200426-M1-236','MR-B2F-23','Meeting Room',TO_DATE('2020-04-27 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-27 13:30','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation VALUES ('200426-M2-237','MR-A2F-10','Meeting Room',TO_DATE('2020-04-26 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-26 16:24','YYYY-MM-DD HH24:MI'),8,35);
INSERT INTO room_reservation VALUES ('200427-M2-240','MR-A2F-8','Meeting Room',TO_DATE('2020-04-28 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-28 13:30','YYYY-MM-DD HH24:MI'),7,17.5);
INSERT INTO room_reservation VALUES ('200428-M2-241','MR-A2F-8','Meeting Room',TO_DATE('2020-05-03 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-03 15:59','YYYY-MM-DD HH24:MI'),4,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200429-S1-245','SR-A1F-4','Study Room',TO_DATE('2020-05-01 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-01 14:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200429-M1-246','MR-B2F-23','Meeting Room',TO_DATE('2020-04-30 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-30 10:54','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation VALUES ('200429-M1-247','MR-A1F-6','Meeting Room',TO_DATE('2020-05-01 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-01 12:56','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200429-M3-248','MR-A3F-12','Meeting Room',TO_DATE('2020-05-03 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-03 10:52','YYYY-MM-DD HH24:MI'),7,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200429-S1-249','SR-B1F-16','Study Room',TO_DATE('2020-04-29 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-04-29 13:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200430-S1-250','SR-BGF-14','Study Room',TO_DATE('2020-04-30 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-04-30 13:24','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200430-M2-251','MR-A2F-10','Meeting Room',TO_DATE('2020-05-02 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-02 12:57','YYYY-MM-DD HH24:MI'),4,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200501-S1-255','SR-B1F-16','Study Room',TO_DATE('2020-05-06 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-06 16:24','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200502-S1-256','SR-B2F-21','Study Room',TO_DATE('2020-05-03 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-03 12:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200502-M1-258','MR-B2F-23','Meeting Room',TO_DATE('2020-05-06 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-06 12:30','YYYY-MM-DD HH24:MI'),5,25);
INSERT INTO room_reservation VALUES ('200502-M3-259','MR-A3F-12','Meeting Room',TO_DATE('2020-05-04 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-04 16:28','YYYY-MM-DD HH24:MI'),9,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200502-S1-260','SR-B1F-18','Study Room',TO_DATE('2020-05-07 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-07 13:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200503-M3-261','MR-A3F-12','Meeting Room',TO_DATE('2020-05-04 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-04 16:54','YYYY-MM-DD HH24:MI'),13,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200503-S1-263','SR-B1F-18','Study Room',TO_DATE('2020-05-03 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-03 09:51','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200503-S1-264','SR-A1F-4','Study Room',TO_DATE('2020-05-03 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-03 15:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200503-S1-265','SR-AGF-2','Study Room',TO_DATE('2020-05-07 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-07 11:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200504-M3-269','MR-A3F-11','Meeting Room',TO_DATE('2020-05-06 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-06 14:56','YYYY-MM-DD HH24:MI'),8,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200505-S1-271','SR-BGF-15','Study Room',TO_DATE('2020-05-08 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-08 16:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200506-S1-277','SR-B1F-17','Study Room',TO_DATE('2020-05-11 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-11 14:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200507-M1-278','MR-B2F-23','Meeting Room',TO_DATE('2020-05-07 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-07 15:53','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200507-S1-282','SR-AGF-2','Study Room',TO_DATE('2020-05-12 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-12 10:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200508-M2-285','MR-A2F-9','Meeting Room',TO_DATE('2020-05-13 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-13 16:00','YYYY-MM-DD HH24:MI'),6,17.5);
INSERT INTO room_reservation VALUES ('200508-M1-286','MR-A1F-6','Meeting Room',TO_DATE('2020-05-12 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-12 11:25','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation VALUES ('200508-M1-287','MR-A1F-6','Meeting Room',TO_DATE('2020-05-11 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-11 14:50','YYYY-MM-DD HH24:MI'),5,25);
INSERT INTO room_reservation VALUES ('200509-M1-288','MR-B2F-22','Meeting Room',TO_DATE('2020-05-12 11:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-12 11:53','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation VALUES ('200509-M1-290','MR-B2F-24','Meeting Room',TO_DATE('2020-05-10 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-10 09:54','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200510-S1-291','SR-A1F-4','Study Room',TO_DATE('2020-05-15 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-15 12:30','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200510-M2-293','MR-A2F-9','Meeting Room',TO_DATE('2020-05-15 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-15 13:57','YYYY-MM-DD HH24:MI'),4,17.5);
INSERT INTO room_reservation VALUES ('200511-M1-298','MR-B2F-23','Meeting Room',TO_DATE('2020-05-13 11:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-13 11:55','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation VALUES ('200513-M1-304','MR-B2F-22','Meeting Room',TO_DATE('2020-05-17 11:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-17 11:27','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation VALUES ('200513-M2-306','MR-A2F-10','Meeting Room',TO_DATE('2020-05-18 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-18 09:55','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200515-S1-311','SR-A1F-5','Study Room',TO_DATE('2020-05-17 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-17 12:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200515-M1-312','MR-B2F-23','Meeting Room',TO_DATE('2020-05-15 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-15 10:51','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation VALUES ('200515-M2-313','MR-A2F-8','Meeting Room',TO_DATE('2020-05-19 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-19 15:27','YYYY-MM-DD HH24:MI'),4,35);
INSERT INTO room_reservation VALUES ('200516-M3-316','MR-A3F-12','Meeting Room',TO_DATE('2020-05-18 10:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-18 10:54','YYYY-MM-DD HH24:MI'),7,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200516-S1-317','SR-B1F-20','Study Room',TO_DATE('2020-05-18 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-18 12:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200516-S1-318','SR-AGF-2','Study Room',TO_DATE('2020-05-19 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-19 14:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200516-M1-320','MR-B2F-23','Meeting Room',TO_DATE('2020-05-16 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-16 13:29','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation VALUES ('200517-M2-321','MR-A2F-9','Meeting Room',TO_DATE('2020-05-18 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-18 10:00','YYYY-MM-DD HH24:MI'),7,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200517-S1-323','SR-AGF-1','Study Room',TO_DATE('2020-05-18 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-18 16:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200517-S1-324','SR-A1F-4','Study Room',TO_DATE('2020-05-21 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-21 13:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200518-M1-325','MR-B2F-23','Meeting Room',TO_DATE('2020-05-18 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-18 09:57','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200518-S1-326','SR-B1F-19','Study Room',TO_DATE('2020-05-21 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-21 12:25','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200518-S1-327','SR-B2F-21','Study Room',TO_DATE('2020-05-19 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-19 10:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200519-S1-330','SR-AGF-1','Study Room',TO_DATE('2020-05-22 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-22 12:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200519-M1-332','MR-A1F-7','Meeting Room',TO_DATE('2020-05-21 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-21 09:53','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200520-S1-333','SR-BGF-14','Study Room',TO_DATE('2020-05-20 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-20 14:59','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200520-M1-334','MR-B2F-22','Meeting Room',TO_DATE('2020-05-23 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-23 16:21','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200520-S1-336','SR-BGF-13','Study Room',TO_DATE('2020-05-22 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-22 11:53','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200521-S1-338','SR-B1F-19','Study Room',TO_DATE('2020-05-26 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-26 15:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200521-M1-340','MR-A1F-7','Meeting Room',TO_DATE('2020-05-26 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-26 15:24','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation VALUES ('200521-M3-341','MR-A3F-11','Meeting Room',TO_DATE('2020-05-24 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-24 12:22','YYYY-MM-DD HH24:MI'),10,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200522-S1-342','SR-A1F-4','Study Room',TO_DATE('2020-05-25 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-25 11:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200522-M2-345','MR-A2F-8','Meeting Room',TO_DATE('2020-05-23 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-23 17:23','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200522-S1-348','SR-B2F-21','Study Room',TO_DATE('2020-05-24 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-24 11:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200523-S1-350','SR-B1F-20','Study Room',TO_DATE('2020-05-23 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-23 12:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200524-S1-352','SR-B1F-19','Study Room',TO_DATE('2020-05-25 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-25 14:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200524-S1-354','SR-B1F-20','Study Room',TO_DATE('2020-05-26 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-26 12:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200524-S1-355','SR-AGF-3','Study Room',TO_DATE('2020-05-27 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-27 12:53','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200525-S1-356','SR-B1F-20','Study Room',TO_DATE('2020-05-27 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-27 10:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200525-M1-357','MR-B2F-22','Meeting Room',TO_DATE('2020-05-30 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-30 12:20','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200525-S1-358','SR-B2F-21','Study Room',TO_DATE('2020-05-29 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-29 10:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200525-S1-359','SR-B1F-18','Study Room',TO_DATE('2020-05-29 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-29 13:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200525-M1-360','MR-A1F-7','Meeting Room',TO_DATE('2020-05-27 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-27 16:30','YYYY-MM-DD HH24:MI'),6,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200526-S1-362','SR-AGF-2','Study Room',TO_DATE('2020-05-29 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-29 13:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200526-S1-363','SR-B1F-20','Study Room',TO_DATE('2020-05-28 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-28 14:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200526-S1-364','SR-AGF-3','Study Room',TO_DATE('2020-05-30 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-30 10:53','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200527-S1-367','SR-B1F-19','Study Room',TO_DATE('2020-05-30 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-30 10:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200528-S1-369','SR-BGF-14','Study Room',TO_DATE('2020-05-29 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-29 12:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200529-M1-372','MR-B2F-23','Meeting Room',TO_DATE('2020-06-03 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-03 10:30','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200529-S1-374','SR-B1F-20','Study Room',TO_DATE('2020-06-01 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-01 09:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200530-M3-375','MR-A3F-11','Meeting Room',TO_DATE('2020-05-31 11:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-05-31 12:00','YYYY-MM-DD HH24:MI'),10,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200530-S1-377','SR-AGF-2','Study Room',TO_DATE('2020-05-31 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-31 15:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200531-M3-379','MR-A3F-11','Meeting Room',TO_DATE('2020-05-31 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-05-31 12:59','YYYY-MM-DD HH24:MI'),11,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200531-S1-381','SR-AGF-3','Study Room',TO_DATE('2020-06-03 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-03 12:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200601-S1-382','SR-AGF-2','Study Room',TO_DATE('2020-06-03 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-03 15:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200601-S1-383','SR-BGF-15','Study Room',TO_DATE('2020-06-06 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-06 14:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200602-S1-388','SR-B1F-20','Study Room',TO_DATE('2020-06-02 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-02 12:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200603-S1-390','SR-B1F-16','Study Room',TO_DATE('2020-06-04 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-04 12:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200603-S1-392','SR-BGF-13','Study Room',TO_DATE('2020-06-05 16:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-05 17:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200603-M2-393','MR-B2F-25','Meeting Room',TO_DATE('2020-06-06 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-06 16:25','YYYY-MM-DD HH24:MI'),4,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200604-S1-395','SR-AGF-3','Study Room',TO_DATE('2020-06-08 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-08 14:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200604-S1-397','SR-AGF-1','Study Room',TO_DATE('2020-06-09 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-09 14:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200605-M1-399','MR-B2F-22','Meeting Room',TO_DATE('2020-06-08 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-08 12:50','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200605-S1-400','SR-BGF-14','Study Room',TO_DATE('2020-06-09 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-09 12:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200605-S1-401','SR-BGF-15','Study Room',TO_DATE('2020-06-05 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-05 15:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200605-M1-402','MR-B2F-24','Meeting Room',TO_DATE('2020-06-09 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-09 12:55','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200605-S1-404','SR-AGF-2','Study Room',TO_DATE('2020-06-05 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-05 16:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200606-S1-405','SR-A1F-5','Study Room',TO_DATE('2020-06-11 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-11 10:55','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200606-S1-406','SR-B1F-17','Study Room',TO_DATE('2020-06-10 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-10 16:30','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200606-M1-407','MR-A1F-7','Meeting Room',TO_DATE('2020-06-07 11:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-07 11:24','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation VALUES ('200606-M1-408','MR-B2F-22','Meeting Room',TO_DATE('2020-06-08 11:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-08 11:23','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200607-S1-411','SR-A1F-4','Study Room',TO_DATE('2020-06-09 10:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-09 10:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200609-S1-416','SR-AGF-3','Study Room',TO_DATE('2020-06-10 10:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-10 11:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200609-M1-417','MR-B2F-22','Meeting Room',TO_DATE('2020-06-13 16:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-13 16:56','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200609-S1-418','SR-B1F-17','Study Room',TO_DATE('2020-06-11 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-11 09:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200610-M1-422','MR-B2F-24','Meeting Room',TO_DATE('2020-06-15 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-15 12:59','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200611-S1-424','SR-B1F-17','Study Room',TO_DATE('2020-06-11 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-11 11:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200611-S1-425','SR-AGF-1','Study Room',TO_DATE('2020-06-15 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-15 11:51','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200611-M2-426','MR-A2F-8','Meeting Room',TO_DATE('2020-06-11 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-11 17:21','YYYY-MM-DD HH24:MI'),5,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200611-S1-429','SR-AGF-1','Study Room',TO_DATE('2020-06-12 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-12 09:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200612-S1-433','SR-B2F-21','Study Room',TO_DATE('2020-06-16 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-16 10:30','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200613-S1-435','SR-B1F-17','Study Room',TO_DATE('2020-06-15 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-15 16:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200613-M1-437','MR-A1F-6','Meeting Room',TO_DATE('2020-06-15 13:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-15 13:25','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation VALUES ('200614-M1-440','MR-B2F-23','Meeting Room',TO_DATE('2020-06-19 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-19 09:26','YYYY-MM-DD HH24:MI'),3,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200614-S1-442','SR-BGF-14','Study Room',TO_DATE('2020-06-15 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-15 14:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200615-S1-446','SR-B2F-21','Study Room',TO_DATE('2020-06-17 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-17 15:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200616-S1-449','SR-B1F-16','Study Room',TO_DATE('2020-06-16 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-16 11:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200616-M1-450','MR-B2F-23','Meeting Room',TO_DATE('2020-06-17 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-17 13:50','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200617-S1-451','SR-A1F-5','Study Room',TO_DATE('2020-06-22 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-22 12:59','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200617-S1-453','SR-B1F-16','Study Room',TO_DATE('2020-06-21 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-21 10:30','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200618-S1-454','SR-A1F-4','Study Room',TO_DATE('2020-06-20 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-20 16:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200618-M3-455','MR-A3F-11','Meeting Room',TO_DATE('2020-06-19 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-19 11:27','YYYY-MM-DD HH24:MI'),7,50);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200619-S1-458','SR-B2F-21','Study Room',TO_DATE('2020-06-22 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-22 14:21','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200620-S1-462','SR-B1F-19','Study Room',TO_DATE('2020-06-21 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-21 15:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200621-S1-465','SR-B1F-17','Study Room',TO_DATE('2020-06-26 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-26 14:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200621-S1-467','SR-A1F-4','Study Room',TO_DATE('2020-06-24 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-24 12:59','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200622-S1-469','SR-B2F-21','Study Room',TO_DATE('2020-06-24 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-24 15:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200622-S1-470','SR-BGF-15','Study Room',TO_DATE('2020-06-22 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-22 12:58','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200623-S1-473','SR-B1F-19','Study Room',TO_DATE('2020-06-25 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-25 16:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200624-S1-476','SR-B1F-19','Study Room',TO_DATE('2020-06-28 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-28 12:30','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200624-S1-477','SR-B2F-21','Study Room',TO_DATE('2020-06-26 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-26 17:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200625-S1-480','SR-BGF-14','Study Room',TO_DATE('2020-06-27 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-27 12:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200625-M1-482','MR-B2F-24','Meeting Room',TO_DATE('2020-06-28 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-28 14:25','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200626-S1-484','SR-BGF-14','Study Room',TO_DATE('2020-06-30 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-30 12:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200626-M3-485','MR-A3F-12','Meeting Room',TO_DATE('2020-06-28 10:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-28 10:23','YYYY-MM-DD HH24:MI'),9,25);
INSERT INTO room_reservation VALUES ('200626-M3-488','MR-A3F-11','Meeting Room',TO_DATE('2020-07-01 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-01 13:56','YYYY-MM-DD HH24:MI'),12,25);
INSERT INTO room_reservation VALUES ('200627-M2-489','MR-A2F-8','Meeting Room',TO_DATE('2020-06-30 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-30 13:55','YYYY-MM-DD HH24:MI'),4,17.5);
INSERT INTO room_reservation VALUES ('200627-M1-490','MR-B2F-23','Meeting Room',TO_DATE('2020-06-30 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-06-30 13:00','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200628-S1-494','SR-B1F-18','Study Room',TO_DATE('2020-07-03 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-03 11:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200629-M1-495','MR-B2F-24','Meeting Room',TO_DATE('2020-06-30 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-06-30 14:50','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200629-S1-496','SR-BGF-13','Study Room',TO_DATE('2020-07-02 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-02 15:24','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200629-M1-497','MR-A1F-6','Meeting Room',TO_DATE('2020-07-03 16:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-03 16:50','YYYY-MM-DD HH24:MI'),5,25);
INSERT INTO room_reservation VALUES ('200629-M1-498','MR-B2F-23','Meeting Room',TO_DATE('2020-07-04 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-04 14:57','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200630-S1-499','SR-B1F-19','Study Room',TO_DATE('2020-07-04 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-04 11:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200630-S1-501','SR-AGF-2','Study Room',TO_DATE('2020-07-05 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-05 16:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200701-M2-505','MR-A2F-10','Meeting Room',TO_DATE('2020-07-04 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-04 09:59','YYYY-MM-DD HH24:MI'),8,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200701-S1-506','SR-AGF-3','Study Room',TO_DATE('2020-07-04 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-04 13:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200702-S1-507','SR-AGF-3','Study Room',TO_DATE('2020-07-02 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-02 11:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200702-M2-508','MR-B2F-25','Meeting Room',TO_DATE('2020-07-02 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-02 12:57','YYYY-MM-DD HH24:MI'),4,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200702-S1-509','SR-B1F-17','Study Room',TO_DATE('2020-07-04 12:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-04 12:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200703-M1-510','MR-B2F-23','Meeting Room',TO_DATE('2020-07-05 16:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-05 17:21','YYYY-MM-DD HH24:MI'),5,25);
INSERT INTO room_reservation VALUES ('200703-M1-511','MR-B2F-22','Meeting Room',TO_DATE('2020-07-03 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-03 14:26','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200703-S1-513','SR-AGF-1','Study Room',TO_DATE('2020-07-03 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-03 13:24','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200703-M1-514','MR-B2F-24','Meeting Room',TO_DATE('2020-07-04 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-04 14:54','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200704-S1-515','SR-B1F-20','Study Room',TO_DATE('2020-07-04 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-04 15:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200704-M2-516','MR-A2F-10','Meeting Room',TO_DATE('2020-07-07 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-07 12:29','YYYY-MM-DD HH24:MI'),4,35);
INSERT INTO room_reservation VALUES ('200704-M1-518','MR-B2F-22','Meeting Room',TO_DATE('2020-07-04 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-04 13:29','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200705-S1-519','SR-BGF-13','Study Room',TO_DATE('2020-07-07 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-07 16:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200705-M2-520','MR-B2F-25','Meeting Room',TO_DATE('2020-07-07 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-07 09:56','YYYY-MM-DD HH24:MI'),8,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200707-S1-527','SR-B1F-20','Study Room',TO_DATE('2020-07-09 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-09 15:53','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200707-S1-528','SR-B1F-16','Study Room',TO_DATE('2020-07-10 13:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-10 13:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200708-M2-531','MR-A2F-8','Meeting Room',TO_DATE('2020-07-10 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-10 15:54','YYYY-MM-DD HH24:MI'),5,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200710-S1-536','SR-A1F-5','Study Room',TO_DATE('2020-07-14 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-14 09:56','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200710-S1-537','SR-AGF-3','Study Room',TO_DATE('2020-07-13 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-13 10:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200711-S1-540','SR-AGF-3','Study Room',TO_DATE('2020-07-14 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-14 12:55','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200711-S1-542','SR-B2F-21','Study Room',TO_DATE('2020-07-16 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-16 13:27','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200711-S1-543','SR-A1F-4','Study Room',TO_DATE('2020-07-16 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-16 11:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200712-S1-545','SR-B1F-18','Study Room',TO_DATE('2020-07-12 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-12 12:51','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200713-M1-550','MR-B2F-24','Meeting Room',TO_DATE('2020-07-16 11:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-16 12:22','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200713-S1-551','SR-BGF-14','Study Room',TO_DATE('2020-07-17 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-17 09:52','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200714-M1-552','MR-B2F-23','Meeting Room',TO_DATE('2020-07-17 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-17 09:26','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation VALUES ('200714-M1-554','MR-B2F-24','Meeting Room',TO_DATE('2020-07-16 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-16 10:30','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200715-S1-556','SR-B1F-20','Study Room',TO_DATE('2020-07-17 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-17 15:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200716-S1-559','SR-A1F-5','Study Room',TO_DATE('2020-07-16 09:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-16 09:59','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200716-M1-562','MR-B2F-22','Meeting Room',TO_DATE('2020-07-18 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-18 16:50','YYYY-MM-DD HH24:MI'),4,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200717-S1-565','SR-BGF-14','Study Room',TO_DATE('2020-07-18 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-18 09:20','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200717-S1-567','SR-A1F-5','Study Room',TO_DATE('2020-07-22 13:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-22 14:26','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200717-M1-568','MR-B2F-23','Meeting Room',TO_DATE('2020-07-22 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-22 10:58','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200718-M1-569','MR-A1F-6','Meeting Room',TO_DATE('2020-07-20 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-20 10:57','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200718-M1-570','MR-B2F-24','Meeting Room',TO_DATE('2020-07-19 15:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-19 15:23','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation VALUES ('200718-M1-571','MR-B2F-23','Meeting Room',TO_DATE('2020-07-19 13:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-19 13:57','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation VALUES ('200719-M1-573','MR-B2F-22','Meeting Room',TO_DATE('2020-07-22 12:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-22 12:59','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200719-S1-575','SR-AGF-2','Study Room',TO_DATE('2020-07-24 09:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-24 09:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200719-M2-576','MR-B2F-25','Meeting Room',TO_DATE('2020-07-24 14:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-24 14:21','YYYY-MM-DD HH24:MI'),7,17.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200719-S1-577','SR-B2F-21','Study Room',TO_DATE('2020-07-22 12:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-22 13:29','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200719-S1-578','SR-A1F-4','Study Room',TO_DATE('2020-07-24 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-24 11:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200719-M1-579','MR-B2F-22','Meeting Room',TO_DATE('2020-07-19 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-19 14:55','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200720-S1-582','SR-B1F-18','Study Room',TO_DATE('2020-07-20 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-20 10:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200720-S1-583','SR-A1F-4','Study Room',TO_DATE('2020-07-24 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-24 14:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200721-S1-586','SR-B1F-20','Study Room',TO_DATE('2020-07-23 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-23 14:54','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200721-S1-587','SR-B2F-21','Study Room',TO_DATE('2020-07-26 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-26 16:28','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200721-M1-588','MR-B2F-22','Meeting Room',TO_DATE('2020-07-22 16:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-22 16:22','YYYY-MM-DD HH24:MI'),6,12.5);
INSERT INTO room_reservation VALUES ('200722-M1-591','MR-A1F-7','Meeting Room',TO_DATE('2020-07-23 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-23 16:59','YYYY-MM-DD HH24:MI'),5,12.5);
INSERT INTO room_reservation VALUES ('200723-M1-593','MR-B2F-23','Meeting Room',TO_DATE('2020-07-27 11:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-27 11:53','YYYY-MM-DD HH24:MI'),2,25);
INSERT INTO room_reservation VALUES ('200723-M2-594','MR-A2F-9','Meeting Room',TO_DATE('2020-07-27 12:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-27 12:52','YYYY-MM-DD HH24:MI'),7,35);
INSERT INTO room_reservation VALUES ('200724-M1-597','MR-A1F-6','Meeting Room',TO_DATE('2020-07-28 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-28 11:22','YYYY-MM-DD HH24:MI'),4,25);
INSERT INTO room_reservation VALUES ('200724-M2-600','MR-A2F-10','Meeting Room',TO_DATE('2020-07-28 15:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-28 16:26','YYYY-MM-DD HH24:MI'),8,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200725-S1-601','SR-AGF-3','Study Room',TO_DATE('2020-07-25 14:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-25 14:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200725-M1-602','MR-B2F-24','Meeting Room',TO_DATE('2020-07-25 11:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-25 12:00','YYYY-MM-DD HH24:MI'),2,12.5);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200725-S1-604','SR-B1F-17','Study Room',TO_DATE('2020-07-25 15:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-25 15:57','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200726-S1-605','SR-BGF-13','Study Room',TO_DATE('2020-07-31 14:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-31 14:51','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200727-S1-608','SR-AGF-3','Study Room',TO_DATE('2020-07-30 15:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-30 15:50','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200728-S1-613','SR-AGF-1','Study Room',TO_DATE('2020-08-01 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-08-01 15:22','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200728-M3-617','MR-A3F-11','Meeting Room',TO_DATE('2020-07-29 16:30','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-07-29 16:52','YYYY-MM-DD HH24:MI'),12,25);
INSERT INTO room_reservation VALUES ('200729-M2-618','MR-B2F-25','Meeting Room',TO_DATE('2020-07-29 10:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-07-29 11:29','YYYY-MM-DD HH24:MI'),4,35);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200730-S1-623','SR-B1F-16','Study Room',TO_DATE('2020-08-04 09:00','YYYY-MM-DD HH24:MI'),30,TO_DATE('2020-08-04 09:23','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200730-M1-624','MR-B2F-23','Meeting Room',TO_DATE('2020-08-04 09:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-08-04 10:24','YYYY-MM-DD HH24:MI'),3,25);
INSERT INTO room_reservation(reservation_id,room_id,reservation_desc,reserved_start_time,duration,reserved_checkout_time) VALUES ('200731-S1-626','SR-BGF-14','Study Room',TO_DATE('2020-08-01 10:00','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-08-01 11:00','YYYY-MM-DD HH24:MI'));
INSERT INTO room_reservation VALUES ('200731-M2-627','MR-A2F-9','Meeting Room',TO_DATE('2020-08-04 14:30','YYYY-MM-DD HH24:MI'),60,TO_DATE('2020-08-04 15:20','YYYY-MM-DD HH24:MI'),7,35);


--Book Category Table
INSERT INTO book_category VALUES ('ADVT', 'Adventure', TO_DATE('2020-06-25', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('BIOG', 'Biography', TO_DATE('2019-09-14', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('CHLD', 'Children', TO_DATE('2020-04-16', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('COMI', 'Comic', TO_DATE('2020-01-13', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('COOK', 'Cooking', TO_DATE('2020-05-16', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('EDUC', 'Education', TO_DATE('2020-01-03', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('FANT', 'Fantasy', TO_DATE('2019-10-01', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('HLTH', 'Health', TO_DATE('2020-06-21', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('HOBB', 'Hobbies', TO_DATE('2020-04-17', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('HORR', 'Horror', TO_DATE('2019-12-27', 'YYYY-MM-DD'));

INSERT INTO book_category VALUES ('JOUR', 'Journal', TO_DATE('2019-08-31', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('KIDS', 'Kids', TO_DATE('2020-04-01', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('NOVE', 'Novel', TO_DATE('2020-03-08', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('POET', 'Poetry', TO_DATE('2020-08-13', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('ROMC', 'Romance', TO_DATE('2020-02-14', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('SCFI', 'Science Fiction', TO_DATE('2020-01-16', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('SCMT', 'Science and Math', TO_DATE('2020-03-11', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('SOSC', 'Social Science', TO_DATE('2020-02-26', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('SPRT', 'Sports', TO_DATE('2020-03-23', 'YYYY-MM-DD'));
INSERT INTO book_category VALUES ('TEEN', 'Teenagers', TO_DATE('2020-04-08', 'YYYY-MM-DD'));


--Author Table
INSERT INTO author VALUES ('A0001','Poh','Choo Meng','M',TO_DATE('1987-08-02','YYYY-MM-DD'),'pohcm@gmail.com','011-3618287','Malaysian');
INSERT INTO author VALUES ('A0002','Chew','Wei Chung','M',TO_DATE('1982-03-15','YYYY-MM-DD'),'chewwc@gmail.com','012-3717821','Malaysian');
INSERT INTO author VALUES ('A0003','William','Choong','M',TO_DATE('1987-05-20','YYYY-MM-DD'),'williamc@gmail.com','018-2832812','Malaysian');
INSERT INTO author VALUES ('A0004','Choo','Zhi Yan','F',TO_DATE('1975-03-21','YYYY-MM-DD'),'choozy@gmail.com','015-3192312','Malaysian');
INSERT INTO author VALUES ('A0005','Ng','Kar Kai','M',TO_DATE('1983-05-11','YYYY-MM-DD'),'ngkk@gmail.com','012-1231232','Malaysian');
INSERT INTO author VALUES ('A0006','Oon','Kheng Huang','M',TO_DATE('1986-11-21','YYYY-MM-DD'),'oonkh@gmail.com','016-1228982','Malaysian');
INSERT INTO author VALUES ('A0007','Ng','Zhi Ern','F',TO_DATE('1988-05-21','YYYY-MM-DD'),'ngze@gmail.com','011-1248932','Malaysian');
INSERT INTO author VALUES ('A0008','Fong','Shu Ling','F',TO_DATE('1993-04-15','YYYY-MM-DD'),'fongsl@gmail.com','013-3493731','Malaysian');
INSERT INTO author VALUES ('A0009','Tan','Ke Xin','F',TO_DATE('1934-04-15','YYYY-MM-DD'),'tankx@gmail.com','012-3584821','Malaysian');
INSERT INTO author VALUES ('A0010','Chai','Jia Jun','M',TO_DATE('1927-06-18','YYYY-MM-DD'),'chaijj@gmail.com','016-3918212','Malaysian');

INSERT INTO author VALUES ('A0011','Chew','Kai Sean','M',TO_DATE('1928-12-18','YYYY-MM-DD'),'chewks@gmail.com','019-2329372','Malaysian');
INSERT INTO author VALUES ('A0012','Chok','Ji Yuan','M',TO_DATE('1938-02-13','YYYY-MM-DD'),'chokjy@gmail.com','012-3123921','Malaysian');
INSERT INTO author VALUES ('A0013','Chong','Zheng Ting','M',TO_DATE('1948-05-03','YYYY-MM-DD'),'chongzt@gmail.com','015-3431392','Malaysian');
INSERT INTO author VALUES ('A0014','Goh','Kia Chuan','M',TO_DATE('1933-06-01','YYYY-MM-DD'),'gohkc@gmail.com','018-2338331','Malaysian');
INSERT INTO author VALUES ('A0015','Hang','Ming Zhou','M',TO_DATE('1937-03-21','YYYY-MM-DD'),'hangmz@gmail.com','011-3484339','Malaysian');
INSERT INTO author VALUES ('A0016','Heng','Wey Chin','M',TO_DATE('1943-05-02','YYYY-MM-DD'),'hengwc@gmail.com','019-3489009','Malaysian');
INSERT INTO author VALUES ('A0017','Keong','Yi Juin','F',TO_DATE('1936-04-21','YYYY-MM-DD'),'keongyj@gmail.com','011-3765356','Malaysian');
INSERT INTO author VALUES ('A0018','Khoo','Yik Kang','M',TO_DATE('1944-06-13','YYYY-MM-DD'),'khooyk@gmail.com','013-4749797','Malaysian');
INSERT INTO author VALUES ('A0019','Ong','Quan Nee','F',TO_DATE('1935-05-15','YYYY-MM-DD'),'ongqn@gmail.com','012-3437391','Malaysian');
INSERT INTO author VALUES ('A0020','Sin','Jenz Joe','M',TO_DATE('1987-05-13','YYYY-MM-DD'),'sinjz@gmail.com','011-2437832','Malaysian');


--Book Table
INSERT INTO book VALUES ('B1FANT1955', 'The Return Of The King (lord Of The Rings)', 'FANT', TO_DATE('1955-10-20', 'YYYY-MM-DD'), 'English', '9780007635573', 416);
INSERT INTO book VALUES ('B2BIOG2004', 'Genghis Khan and the Making of the Modern World', 'BIOG', TO_DATE('2004-03-16', 'YYYY-MM-DD'), 'English', '9780609610626', 312);
INSERT INTO book VALUES ('B3HORR1986', ' It: A Novel', 'HORR', TO_DATE('1986-09-15', 'YYYY-MM-DD'), 'English', '9780670813025', 1138);
INSERT INTO book VALUES ('B4COMI2012', 'Avengers vs. X-Men', 'COMI', TO_DATE('2012-10-04', 'YYYY-MM-DD'), 'English', '9780785168058', 384);
INSERT INTO book VALUES ('B5COOK2012', 'Gordon Ramsay Ultimate Cookery Course', 'COOK', TO_DATE('2012-08-30', 'YYYY-MM-DD'), 'English', '9781444756692', 250);
INSERT INTO book VALUES ('B6HLTH2005', 'The Best Diet Book Ever: The Zen of Losing Weight', 'HLTH', TO_DATE('2005-08-23', 'YYYY-MM-DD'), 'English', '9780972846929', 174);
INSERT INTO book VALUES ('B7SCFI1992', 'Dark Force Rising', 'SCFI', TO_DATE('1992-06-01', 'YYYY-MM-DD'), 'English', '9780553085747', 144);
INSERT INTO book VALUES ('B8ADVT1851', 'Moby-dick', 'ADVT', TO_DATE('1851-10-18', 'YYYY-MM-DD'), 'English', '9780192741561', 585);
INSERT INTO book VALUES ('B9EDUC2015', 'The End of College', 'EDUC', TO_DATE('2015-03-03', 'YYYY-MM-DD'), 'English', '9781594632051', 288);
INSERT INTO book VALUES ('B10CHLD1952', 'Charlotte Web. E.b. White', 'CHLD', TO_DATE('1952-10-15', 'YYYY-MM-DD'), 'English', '9780760707258', 192);

INSERT INTO book VALUES ('B11ROMC1813', 'Pride and Prejudice', 'ROMC', TO_DATE('1813-01-28', 'YYYY-MM-DD'), 'English', '9780143123163', 432);
INSERT INTO book VALUES ('B12JOUR2014', 'Wreck This Journal Everywhere', 'JOUR', TO_DATE('2014-05-27', 'YYYY-MM-DD'), 'English', '9781846148583', 180);
INSERT INTO book VALUES ('B13NOVE2017', 'Your Name (novel)', 'NOVE', TO_DATE('2017-05-23', 'YYYY-MM-DD'), 'English', '9780316471862', 262);
INSERT INTO book VALUES ('B14POET2017', 'The Sun and Her Flowers', 'POET', TO_DATE('2017-10-03', 'YYYY-MM-DD'), 'English', '9781449495763', 256);
INSERT INTO book VALUES ('B15SPRT2012', 'Grantland', 'SPRT', TO_DATE('2012-07-03', 'YYYY-MM-DD'), 'English', '9781936365920', 310);
INSERT INTO book VALUES ('B16TEEN2017', 'The Hate U Give', 'TEEN', TO_DATE('2017-02-28', 'YYYY-MM-DD'), 'English', '9780062498533', 444);
INSERT INTO book VALUES ('B17SOSC2018', 'White Fragility', 'SOSC', TO_DATE('2018-06-26', 'YYYY-MM-DD'), 'English', '9780807047415', 192);
INSERT INTO book VALUES ('B18HOBB2018', 'RHS How to Garden If You are New to Gardening', 'HOBB', TO_DATE('2018-01-29', 'YYYY-MM-DD'), 'English', '9780241336656', 256);
INSERT INTO book VALUES ('B19TEEN1962', 'A Very Punchable Face: A Memoir', 'TEEN', TO_DATE('2020-07-14', 'YYYY-MM-DD'), 'English', '9781101906323', 336);
INSERT INTO book VALUES ('B20SCMT2020', 'Breath: The New Science of a Lost Art', 'SCMT', TO_DATE('2020-05-14', 'YYYY-MM-DD'), 'English', '9780735213616', 304);

INSERT INTO book VALUES ('B21SCFI2010', 'The Scorch Trials', 'SCFI', TO_DATE('2010-09-18', 'YYYY-MM-DD'), 'English', '9780385737944', 361);
INSERT INTO book VALUES ('B22COMI2013', 'Miss Kobayashi Dragon Maid Vol. 1', 'COMI', TO_DATE('2016-10-18', 'YYYY-MM-DD'), 'Traditional Chinese', '9781626923485', 146);
INSERT INTO book VALUES ('B23NOVE2015', 'I Want To Eat Your Pancreas', 'NOVE', TO_DATE('2015-06-19', 'YYYY-MM-DD'), 'Simplified Chinese', '9781642750324', 442);
INSERT INTO book VALUES ('B24ROMC1997', 'Titanic', 'ROMC', TO_DATE('1997-12-28', 'YYYY-MM-DD'), 'English', '9780006490609', 371);
INSERT INTO book VALUES ('B25HORR2011', 'House Of Darkness: House Of Light-The True Story', 'HORR', TO_DATE('2011-03-08', 'YYYY-MM-DD'), 'English', '9781456747596', 465);
INSERT INTO book VALUES ('B26SCFI1999', 'Harry Potter and the Prisoner of Azkaban', 'SCFI', TO_DATE('1999-07-08', 'YYYY-MM-DD'), 'English', '0747542155', 317);
INSERT INTO book VALUES ('B27NOVE2019', 'Girls Like Us', 'NOVE', TO_DATE('2019-07-02', 'YYYY-MM-DD'), 'English', '9780525535805', 304);
INSERT INTO book VALUES ('B28TEEN2016', 'Spence In Petal Park', 'TEEN', TO_DATE('2019-08-09', 'YYYY-MM-DD'), 'English', '9781911445845', 195);
INSERT INTO book VALUES ('B29COOK2019', 'Mini Cookbooks : Chef Wan Baked Treats', 'COOK', TO_DATE('2019-01-18', 'YYYY-MM-DD'), 'English', '9789812617514', 156);
INSERT INTO book VALUES ('B30COOK2017', '77 Resipi Istimewa Pressure Cooker', 'COOK', TO_DATE('2017-05-07', 'YYYY-MM-DD'), 'Bahasa Melayu', '9789674119881', 176);

INSERT INTO book VALUES ('B31NOVE2019', 'Weathering With You (novel)', 'NOVE', TO_DATE('2019-07-18', 'YYYY-MM-DD'), 'Simplified Chinese', '9789672341796', 296);
INSERT INTO book VALUES ('B32COMI2020', 'Demon Slayer: Kimetsu no Yaiba Vol. 23', 'COMI', TO_DATE('2020-05-18', 'YYYY-MM-DD'), 'Traditional Chinese', '9781974714780', 250);
INSERT INTO book VALUES ('B33COMI2017', 'Rent A Girlfriend Vol. 2', 'COMI', TO_DATE('2017-10-17', 'YYYY-MM-DD'), 'Traditional Chinese', '9789572632789', 180);
INSERT INTO book VALUES ('B34JOUR2020', 'National Geographic (CN ver) April 2020 Edition', 'JOUR', TO_DATE('2020-04-01', 'YYYY-MM-DD'), 'Simplified Chinese', '2000000767185', 189);
INSERT INTO book VALUES ('B35COMI2017', 'Boboiboy Galaxy 1: Kembara Ke Angkasa', 'COMI', TO_DATE('2017-05-05', 'YYYY-MM-DD'), 'Bahasa Melayu', '9789671396629', 144);
INSERT INTO book VALUES ('B36TEEN2020', 'Five NIghts At Freddy Fazbear Frights: 1:35AM', 'TEEN', TO_DATE('2020-05-05', 'YYYY-MM-DD'), 'English', '9781338576030', 272);
INSERT INTO book VALUES ('B37COMI2019', 'Uzaki-chan Wants to Hang Out!', 'COMI', TO_DATE('2019-05-08', 'YYYY-MM-DD'), 'Traditional Chinese', '9789572625262', 144);
INSERT INTO book VALUES ('B38JOUR2019', 'Japan Keihanshin Tour Guides!!', 'JOUR', TO_DATE('2019-11-01', 'YYYY-MM-DD'), 'Traditional Chinese', '9787508096438', 197);
INSERT INTO book VALUES ('B39NOVE2020', 'Curi Kasut Cinderella', 'NOVE', TO_DATE('2020-03-02', 'YYYY-MM-DD'), 'Bahasa Melayu', '9789670874609', 165);
INSERT INTO book VALUES ('B40COMI2020', 'Himouto! Umaru-chan', 'COMI', TO_DATE('2020-10-20', 'YYYY-MM-DD'), 'Traditional Chinese', '9781645057574', '182');


--Book Authors Table
INSERT INTO book_authors VALUES('B1FANT1955', 'A0006');
INSERT INTO book_authors VALUES('B2BIOG2004', 'A0004');
INSERT INTO book_authors VALUES('B3HORR1986', 'A0007');
INSERT INTO book_authors VALUES('B4COMI2012', 'A0001');
INSERT INTO book_authors VALUES('B5COOK2012', 'A0007');
INSERT INTO book_authors VALUES('B6HLTH2005', 'A0009');
INSERT INTO book_authors VALUES('B7SCFI1992', 'A0010');
INSERT INTO book_authors VALUES('B8ADVT1851', 'A0014');
INSERT INTO book_authors VALUES('B9EDUC2015', 'A0001');
INSERT INTO book_authors VALUES('B10CHLD1952', 'A0005');

INSERT INTO book_authors VALUES('B11ROMC1813', 'A0007');
INSERT INTO book_authors VALUES('B12JOUR2014', 'A0015');
INSERT INTO book_authors VALUES('B13NOVE2017', 'A0012');
INSERT INTO book_authors VALUES('B14POET2017', 'A0004');
INSERT INTO book_authors VALUES('B15SPRT2012', 'A0007');
INSERT INTO book_authors VALUES('B16TEEN2017', 'A0017');
INSERT INTO book_authors VALUES('B17SOSC2018', 'A0008');
INSERT INTO book_authors VALUES('B18HOBB2018', 'A0014');
INSERT INTO book_authors VALUES('B19TEEN1962', 'A0011');
INSERT INTO book_authors VALUES('B20SCMT2020', 'A0019');

INSERT INTO book_authors VALUES('B21SCFI2010', 'A0007');
INSERT INTO book_authors VALUES('B22COMI2013', 'A0004');
INSERT INTO book_authors VALUES('B23NOVE2015', 'A0012');
INSERT INTO book_authors VALUES('B24ROMC1997', 'A0017');
INSERT INTO book_authors VALUES('B25HORR2011', 'A0019');
INSERT INTO book_authors VALUES('B26SCFI1999', 'A0015');
INSERT INTO book_authors VALUES('B27NOVE2019', 'A0014');
INSERT INTO book_authors VALUES('B28TEEN2016', 'A0008');
INSERT INTO book_authors VALUES('B29COOK2019', 'A0007');
INSERT INTO book_authors VALUES('B30COOK2017', 'A0011');

INSERT INTO book_authors VALUES('B31NOVE2019', 'A0007');
INSERT INTO book_authors VALUES('B32COMI2020', 'A0001');
INSERT INTO book_authors VALUES('B33COMI2017', 'A0004');
INSERT INTO book_authors VALUES('B34JOUR2020', 'A0017');
INSERT INTO book_authors VALUES('B35COMI2017', 'A0003');
INSERT INTO book_authors VALUES('B36TEEN2020', 'A0015');
INSERT INTO book_authors VALUES('B37COMI2019', 'A0014');
INSERT INTO book_authors VALUES('B38JOUR2019', 'A0008');
INSERT INTO book_authors VALUES('B39NOVE2020', 'A0020');
INSERT INTO book_authors VALUES('B40COMI2020', 'A0002');


--Book Reservation Table
INSERT INTO book_reservation VALUES ('200301-B1-4','B37COMI2019',TO_DATE('2020-03-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200302-B1-5','B12JOUR2014',TO_DATE('2020-03-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200302-B1-6','B9EDUC2015',TO_DATE('2020-03-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200302-B1-7','B30COOK2017',TO_DATE('2020-03-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200303-B1-8','B13NOVE2017',TO_DATE('2020-03-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200303-B1-9','B12JOUR2014',TO_DATE('2020-03-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200305-B1-15','B16TEEN2017',TO_DATE('2020-03-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200305-B1-16','B40COMI2020',TO_DATE('2020-03-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200305-B1-17','B40COMI2020',TO_DATE('2020-03-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200305-B1-18','B18HOBB2018',TO_DATE('2020-03-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200307-B1-24','B2BIOG2004',TO_DATE('2020-03-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200308-B1-28','B31NOVE2019',TO_DATE('2020-03-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200308-B1-29','B14POET2017',TO_DATE('2020-03-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200309-B1-33','B14POET2017',TO_DATE('2020-03-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200309-B1-34','B24ROMC1997',TO_DATE('2020-03-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200309-B1-35','B30COOK2017',TO_DATE('2020-03-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200310-B1-37','B20SCMT2020',TO_DATE('2020-03-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200310-B1-40','B34JOUR2020',TO_DATE('2020-03-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200311-B1-43','B18HOBB2018',TO_DATE('2020-03-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200312-B1-44','B18HOBB2018',TO_DATE('2020-03-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200312-B1-46','B24ROMC1997',TO_DATE('2020-03-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200313-B1-48','B31NOVE2019',TO_DATE('2020-03-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200313-B1-49','B35COMI2017',TO_DATE('2020-03-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200313-B1-50','B19TEEN1962',TO_DATE('2020-03-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200314-B1-52','B37COMI2019',TO_DATE('2020-03-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200314-B1-53','B23NOVE2015',TO_DATE('2020-03-17','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200314-B1-54','B33COMI2017',TO_DATE('2020-03-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200314-B1-56','B26SCFI1999',TO_DATE('2020-03-17','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200315-B1-58','B22COMI2013',TO_DATE('2020-03-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200315-B1-59','B14POET2017',TO_DATE('2020-03-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200316-B1-61','B4COMI2012',TO_DATE('2020-03-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200316-B1-64','B14POET2017',TO_DATE('2020-03-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200318-B1-68','B15SPRT2012',TO_DATE('2020-03-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200318-B1-69','B16TEEN2017',TO_DATE('2020-03-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200318-B1-70','B27NOVE2019',TO_DATE('2020-03-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200319-B1-71','B37COMI2019',TO_DATE('2020-03-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200319-B1-72','B24ROMC1997',TO_DATE('2020-03-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200319-B1-73','B2BIOG2004',TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200319-B1-74','B8ADVT1851',TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200319-B1-75','B7SCFI1992',TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200320-B1-78','B9EDUC2015',TO_DATE('2020-03-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200320-B1-79','B27NOVE2019',TO_DATE('2020-03-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200321-B1-80','B2BIOG2004',TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200321-B1-81','B17SOSC2018',TO_DATE('2020-03-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200321-B1-83','B37COMI2019',TO_DATE('2020-03-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200322-B1-86','B16TEEN2017',TO_DATE('2020-03-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200323-B1-89','B28TEEN2016',TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200323-B1-90','B3HORR1986',TO_DATE('2020-03-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200324-B1-91','B7SCFI1992',TO_DATE('2020-03-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200324-B1-92','B37COMI2019',TO_DATE('2020-03-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200324-B1-95','B18HOBB2018',TO_DATE('2020-03-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200325-B1-97','B21SCFI2010',TO_DATE('2020-03-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200326-B1-102','B4COMI2012',TO_DATE('2020-03-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200327-B1-105','B40COMI2020',TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200327-B1-106','B3HORR1986',TO_DATE('2020-03-31','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200327-B1-107','B24ROMC1997',TO_DATE('2020-03-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200327-B1-108','B22COMI2013',TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200328-B1-110','B18HOBB2018',TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200328-B1-111','B36TEEN2020',TO_DATE('2020-03-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200329-B1-113','B3HORR1986',TO_DATE('2020-04-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200329-B1-114','B27NOVE2019',TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200329-B1-117','B10CHLD1952',TO_DATE('2020-03-30','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200330-B1-118','B24ROMC1997',TO_DATE('2020-04-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200331-B1-124','B35COMI2017',TO_DATE('2020-04-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200331-B1-125','B2BIOG2004',TO_DATE('2020-04-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200401-B1-127','B3HORR1986',TO_DATE('2020-04-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200401-B1-128','B37COMI2019',TO_DATE('2020-04-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200401-B1-129','B36TEEN2020',TO_DATE('2020-04-04','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200402-B1-132','B29COOK2019',TO_DATE('2020-04-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200403-B1-134','B11ROMC1813',TO_DATE('2020-04-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200404-B1-137','B22COMI2013',TO_DATE('2020-04-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200404-B1-138','B32COMI2020',TO_DATE('2020-04-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200405-B1-142','B4COMI2012',TO_DATE('2020-04-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200405-B1-144','B35COMI2017',TO_DATE('2020-04-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200405-B1-145','B38JOUR2019',TO_DATE('2020-04-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200406-B1-147','B17SOSC2018',TO_DATE('2020-04-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200406-B1-149','B15SPRT2012',TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200406-B1-150','B8ADVT1851',TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200406-B1-151','B29COOK2019',TO_DATE('2020-04-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200407-B1-154','B6HLTH2005',TO_DATE('2020-04-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200407-B1-155','B8ADVT1851',TO_DATE('2020-04-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200407-B1-156','B21SCFI2010',TO_DATE('2020-04-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200408-B1-158','B35COMI2017',TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200408-B1-160','B4COMI2012',TO_DATE('2020-04-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200409-B1-161','B18HOBB2018',TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200410-B1-165','B25HORR2011',TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200410-B1-166','B9EDUC2015',TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200411-B1-169','B30COOK2017',TO_DATE('2020-04-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200411-B1-171','B12JOUR2014',TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200412-B1-173','B22COMI2013',TO_DATE('2020-04-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200413-B1-175','B31NOVE2019',TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200413-B1-176','B5COOK2012',TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200413-B1-177','B27NOVE2019',TO_DATE('2020-04-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200413-B1-178','B24ROMC1997',TO_DATE('2020-04-17','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200413-B1-180','B26SCFI1999',TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200414-B1-183','B10CHLD1952',TO_DATE('2020-04-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200414-B1-184','B25HORR2011',TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200414-B1-185','B17SOSC2018',TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200415-B1-187','B19TEEN1962',TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200415-B1-189','B12JOUR2014',TO_DATE('2020-04-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200415-B1-191','B14POET2017',TO_DATE('2020-04-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200415-B1-192','B14POET2017',TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200415-B1-193','B40COMI2020',TO_DATE('2020-04-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200415-B1-194','B33COMI2017',TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200416-B1-195','B31NOVE2019',TO_DATE('2020-04-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200417-B1-198','B15SPRT2012',TO_DATE('2020-04-17','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200417-B1-201','B17SOSC2018',TO_DATE('2020-04-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200417-B1-202','B27NOVE2019',TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200418-B1-203','B29COOK2019',TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200419-B1-206','B15SPRT2012',TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200419-B1-207','B12JOUR2014',TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200419-B1-208','B5COOK2012',TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200420-B1-210','B14POET2017',TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200420-B1-211','B11ROMC1813',TO_DATE('2020-04-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200421-B1-214','B30COOK2017',TO_DATE('2020-04-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200421-B1-215','B16TEEN2017',TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200422-B1-219','B3HORR1986',TO_DATE('2020-04-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200422-B1-220','B6HLTH2005',TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200423-B1-222','B18HOBB2018',TO_DATE('2020-04-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200423-B1-224','B24ROMC1997',TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200423-B1-225','B3HORR1986',TO_DATE('2020-04-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200424-B1-227','B36TEEN2020',TO_DATE('2020-04-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200424-B1-228','B17SOSC2018',TO_DATE('2020-04-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200424-B1-230','B3HORR1986',TO_DATE('2020-04-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200425-B1-234','B8ADVT1851',TO_DATE('2020-04-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200427-B1-238','B25HORR2011',TO_DATE('2020-04-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200427-B1-239','B24ROMC1997',TO_DATE('2020-05-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200428-B1-242','B6HLTH2005',TO_DATE('2020-05-01','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200428-B1-243','B20SCMT2020',TO_DATE('2020-05-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200428-B1-244','B4COMI2012',TO_DATE('2020-04-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200430-B1-252','B14POET2017',TO_DATE('2020-05-01','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200501-B1-253','B15SPRT2012',TO_DATE('2020-05-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200501-B1-254','B12JOUR2014',TO_DATE('2020-05-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200502-B1-257','B24ROMC1997',TO_DATE('2020-05-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200503-B1-262','B34JOUR2020',TO_DATE('2020-05-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200503-B1-266','B28TEEN2016',TO_DATE('2020-05-04','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200504-B1-267','B37COMI2019',TO_DATE('2020-05-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200504-B1-268','B27NOVE2019',TO_DATE('2020-05-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200504-B1-270','B12JOUR2014',TO_DATE('2020-05-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200505-B1-272','B28TEEN2016',TO_DATE('2020-05-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200505-B1-273','B12JOUR2014',TO_DATE('2020-05-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200505-B1-274','B26SCFI1999',TO_DATE('2020-05-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200506-B1-275','B19TEEN1962',TO_DATE('2020-05-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200506-B1-276','B19TEEN1962',TO_DATE('2020-05-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200507-B1-279','B12JOUR2014',TO_DATE('2020-05-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200507-B1-280','B14POET2017',TO_DATE('2020-05-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200507-B1-281','B10CHLD1952',TO_DATE('2020-05-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200508-B1-283','B35COMI2017',TO_DATE('2020-05-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200508-B1-284','B1FANT1955',TO_DATE('2020-05-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200509-B1-289','B15SPRT2012',TO_DATE('2020-05-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200510-B1-292','B10CHLD1952',TO_DATE('2020-05-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200510-B1-294','B38JOUR2019',TO_DATE('2020-05-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200510-B1-295','B7SCFI1992',TO_DATE('2020-05-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200510-B1-296','B27NOVE2019',TO_DATE('2020-05-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200511-B1-297','B32COMI2020',TO_DATE('2020-05-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200511-B1-299','B6HLTH2005',TO_DATE('2020-05-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200512-B1-300','B3HORR1986',TO_DATE('2020-05-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200512-B1-301','B18HOBB2018',TO_DATE('2020-05-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200512-B1-302','B23NOVE2015',TO_DATE('2020-05-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200513-B1-303','B21SCFI2010',TO_DATE('2020-05-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200513-B1-305','B28TEEN2016',TO_DATE('2020-05-17','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200514-B1-307','B22COMI2013',TO_DATE('2020-05-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200514-B1-308','B37COMI2019',TO_DATE('2020-05-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200514-B1-309','B2BIOG2004',TO_DATE('2020-05-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200515-B1-310','B17SOSC2018',TO_DATE('2020-05-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200515-B1-314','B1FANT1955',TO_DATE('2020-05-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200515-B1-315','B17SOSC2018',TO_DATE('2020-05-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200516-B1-319','B37COMI2019',TO_DATE('2020-05-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200517-B1-322','B10CHLD1952',TO_DATE('2020-05-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200519-B1-328','B35COMI2017',TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200519-B1-329','B21SCFI2010',TO_DATE('2020-05-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200519-B1-331','B40COMI2020',TO_DATE('2020-05-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200520-B1-335','B34JOUR2020',TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200520-B1-337','B27NOVE2019',TO_DATE('2020-05-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200521-B1-339','B6HLTH2005',TO_DATE('2020-05-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200522-B1-343','B31NOVE2019',TO_DATE('2020-05-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200522-B1-344','B8ADVT1851',TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200522-B1-346','B21SCFI2010',TO_DATE('2020-05-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200522-B1-347','B20SCMT2020',TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200523-B1-349','B31NOVE2019',TO_DATE('2020-05-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200523-B1-351','B35COMI2017',TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200524-B1-353','B8ADVT1851',TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200526-B1-361','B25HORR2011',TO_DATE('2020-05-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200527-B1-365','B17SOSC2018',TO_DATE('2020-05-30','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200527-B1-366','B40COMI2020',TO_DATE('2020-05-31','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200527-B1-368','B29COOK2019',TO_DATE('2020-05-30','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200528-B1-370','B19TEEN1962',TO_DATE('2020-06-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200528-B1-371','B5COOK2012',TO_DATE('2020-05-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200529-B1-373','B21SCFI2010',TO_DATE('2020-06-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200530-B1-376','B27NOVE2019',TO_DATE('2020-06-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200531-B1-378','B40COMI2020',TO_DATE('2020-06-04','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200531-B1-380','B20SCMT2020',TO_DATE('2020-06-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200601-B1-384','B10CHLD1952',TO_DATE('2020-06-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200602-B1-385','B10CHLD1952',TO_DATE('2020-06-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200602-B1-386','B14POET2017',TO_DATE('2020-06-04','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200602-B1-387','B15SPRT2012',TO_DATE('2020-06-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200603-B1-389','B2BIOG2004',TO_DATE('2020-06-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200603-B1-391','B3HORR1986',TO_DATE('2020-06-07','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200604-B1-394','B4COMI2012',TO_DATE('2020-06-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200604-B1-396','B37COMI2019',TO_DATE('2020-06-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200605-B1-398','B33COMI2017',TO_DATE('2020-06-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200605-B1-403','B25HORR2011',TO_DATE('2020-06-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200607-B1-409','B4COMI2012',TO_DATE('2020-06-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200607-B1-410','B2BIOG2004',TO_DATE('2020-06-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200608-B1-412','B22COMI2013',TO_DATE('2020-06-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200608-B1-413','B26SCFI1999',TO_DATE('2020-06-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200608-B1-414','B4COMI2012',TO_DATE('2020-06-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200608-B1-415','B21SCFI2010',TO_DATE('2020-06-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200609-B1-419','B2BIOG2004',TO_DATE('2020-06-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200609-B1-420','B2BIOG2004',TO_DATE('2020-06-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200610-B1-421','B12JOUR2014',TO_DATE('2020-06-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200610-B1-423','B22COMI2013',TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200611-B1-427','B18HOBB2018',TO_DATE('2020-06-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200611-B1-428','B3HORR1986',TO_DATE('2020-06-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200612-B1-430','B14POET2017',TO_DATE('2020-06-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200612-B1-431','B2BIOG2004',TO_DATE('2020-06-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200612-B1-432','B24ROMC1997',TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200613-B1-434','B37COMI2019',TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200613-B1-436','B16TEEN2017',TO_DATE('2020-06-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200613-B1-438','B32COMI2020',TO_DATE('2020-06-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200614-B1-439','B38JOUR2019',TO_DATE('2020-06-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200614-B1-441','B21SCFI2010',TO_DATE('2020-06-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200615-B1-443','B18HOBB2018',TO_DATE('2020-06-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200615-B1-444','B23NOVE2015',TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200615-B1-445','B29COOK2019',TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200616-B1-447','B21SCFI2010',TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200616-B1-448','B13NOVE2017',TO_DATE('2020-06-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200617-B1-452','B3HORR1986',TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200618-B1-456','B2BIOG2004',TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200619-B1-457','B22COMI2013',TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200619-B1-459','B31NOVE2019',TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200619-B1-460','B32COMI2020',TO_DATE('2020-06-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200620-B1-461','B19TEEN1962',TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200620-B1-463','B22COMI2013',TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200620-B1-464','B6HLTH2005',TO_DATE('2020-06-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200621-B1-466','B22COMI2013',TO_DATE('2020-06-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200621-B1-468','B39NOVE2020',TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200622-B1-471','B8ADVT1851',TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200623-B1-472','B16TEEN2017',TO_DATE('2020-06-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200623-B1-474','B40COMI2020',TO_DATE('2020-06-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200624-B1-475','B27NOVE2019',TO_DATE('2020-06-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200624-B1-478','B18HOBB2018',TO_DATE('2020-06-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200625-B1-479','B14POET2017',TO_DATE('2020-06-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200625-B1-481','B24ROMC1997',TO_DATE('2020-06-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200625-B1-483','B3HORR1986',TO_DATE('2020-06-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200626-B1-486','B33COMI2017',TO_DATE('2020-07-01','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200626-B1-487','B7SCFI1992',TO_DATE('2020-06-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200627-B1-491','B26SCFI1999',TO_DATE('2020-06-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200628-B1-492','B18HOBB2018',TO_DATE('2020-06-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200628-B1-493','B35COMI2017',TO_DATE('2020-06-30','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200630-B1-500','B6HLTH2005',TO_DATE('2020-07-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200630-B1-502','B12JOUR2014',TO_DATE('2020-07-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200630-B1-503','B33COMI2017',TO_DATE('2020-07-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200701-B1-504','B1FANT1955',TO_DATE('2020-07-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200703-B1-512','B6HLTH2005',TO_DATE('2020-07-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200704-B1-517','B39NOVE2020',TO_DATE('2020-07-04','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200705-B1-521','B34JOUR2020',TO_DATE('2020-07-05','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200706-B1-522','B20SCMT2020',TO_DATE('2020-07-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200706-B1-523','B29COOK2019',TO_DATE('2020-07-11','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200706-B1-524','B17SOSC2018',TO_DATE('2020-07-06','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200706-B1-525','B15SPRT2012',TO_DATE('2020-07-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200707-B1-526','B33COMI2017',TO_DATE('2020-07-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200707-B1-529','B32COMI2020',TO_DATE('2020-07-08','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200708-B1-530','B1FANT1955',TO_DATE('2020-07-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200708-B1-532','B6HLTH2005',TO_DATE('2020-07-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200709-B1-533','B25HORR2011',TO_DATE('2020-07-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200709-B1-534','B1FANT1955',TO_DATE('2020-07-09','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200709-B1-535','B2BIOG2004',TO_DATE('2020-07-13','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200710-B1-538','B36TEEN2020',TO_DATE('2020-07-10','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200710-B1-539','B18HOBB2018',TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200711-B1-541','B28TEEN2016',TO_DATE('2020-07-12','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200711-B1-544','B32COMI2020',TO_DATE('2020-07-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200712-B1-546','B31NOVE2019',TO_DATE('2020-07-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200712-B1-547','B23NOVE2015',TO_DATE('2020-07-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200713-B1-548','B31NOVE2019',TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200713-B1-549','B9EDUC2015',TO_DATE('2020-07-16','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200714-B1-553','B29COOK2019',TO_DATE('2020-07-14','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200715-B1-555','B11ROMC1813',TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200715-B1-557','B20SCMT2020',TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200715-B1-558','B8ADVT1851',TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200716-B1-560','B21SCFI2010',TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200716-B1-561','B4COMI2012',TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200716-B1-563','B34JOUR2020',TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200716-B1-564','B8ADVT1851',TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200717-B1-566','B40COMI2020',TO_DATE('2020-07-17','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200719-B1-572','B10CHLD1952',TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200719-B1-574','B31NOVE2019',TO_DATE('2020-07-23','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200720-B1-580','B7SCFI1992',TO_DATE('2020-07-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200720-B1-581','B29COOK2019',TO_DATE('2020-07-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200720-B1-584','B34JOUR2020',TO_DATE('2020-07-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200721-B1-585','B28TEEN2016',TO_DATE('2020-07-21','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200722-B1-589','B12JOUR2014',TO_DATE('2020-07-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200722-B1-590','B11ROMC1813',TO_DATE('2020-07-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200723-B1-592','B13NOVE2017',TO_DATE('2020-07-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200724-B1-595','B21SCFI2010',TO_DATE('2020-07-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200724-B1-596','B11ROMC1813',TO_DATE('2020-07-24','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200724-B1-598','B5COOK2012',TO_DATE('2020-07-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200724-B1-599','B40COMI2020',TO_DATE('2020-07-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200725-B1-603','B7SCFI1992',TO_DATE('2020-07-26','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200726-B1-606','B18HOBB2018',TO_DATE('2020-07-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200726-B1-607','B2BIOG2004',TO_DATE('2020-07-31','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200727-B1-609','B1FANT1955',TO_DATE('2020-07-30','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200727-B1-610','B10CHLD1952',TO_DATE('2020-07-27','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200728-B1-611','B2BIOG2004',TO_DATE('2020-07-31','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200728-B1-612','B22COMI2013',TO_DATE('2020-07-28','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200728-B1-614','B35COMI2017',TO_DATE('2020-08-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200728-B1-615','B37COMI2019',TO_DATE('2020-07-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200728-B1-616','B35COMI2017',TO_DATE('2020-08-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200729-B1-619','B24ROMC1997',TO_DATE('2020-08-03','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200729-B1-620','B21SCFI2010',TO_DATE('2020-08-02','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200729-B1-621','B16TEEN2017',TO_DATE('2020-07-29','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200730-B1-622','B12JOUR2014',TO_DATE('2020-07-30','YYYY-MM-DD'));
INSERT INTO book_reservation VALUES ('200731-B1-625','B11ROMC1813',TO_DATE('2020-08-01','YYYY-MM-DD'));


--Book Loan Table
INSERT INTO book_loan VALUES ('LB00001','S101M','M101BR',1,TO_DATE('2020-03-11','YYYY-MM-DD'),TO_DATE('2020-03-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00002','S102F','M102SV',2,TO_DATE('2020-03-11','YYYY-MM-DD'),TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00003','S103M','M103BR',1,TO_DATE('2020-03-11','YYYY-MM-DD'),TO_DATE('2020-03-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00004','S104M','M104SV',2,TO_DATE('2020-03-11','YYYY-MM-DD'),TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00005','S105M','M105GD',2,TO_DATE('2020-03-11','YYYY-MM-DD'),TO_DATE('2020-03-27','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00006','S106F','M106SV',1,TO_DATE('2020-03-12','YYYY-MM-DD'),TO_DATE('2020-03-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00007','S107F','M107BR',2,TO_DATE('2020-03-12','YYYY-MM-DD'),TO_DATE('2020-03-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00008','S108F','M108GD',1,TO_DATE('2020-03-12','YYYY-MM-DD'),TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00009','S109M','M109SV',3,TO_DATE('2020-03-12','YYYY-MM-DD'),TO_DATE('2020-03-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00010','S110F','M110BR',1,TO_DATE('2020-03-12','YYYY-MM-DD'),TO_DATE('2020-03-22','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00011','S111F','M111GD',3,TO_DATE('2020-03-13','YYYY-MM-DD'),TO_DATE('2020-03-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00012','S112F','M112BR',1,TO_DATE('2020-03-13','YYYY-MM-DD'),TO_DATE('2020-03-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00013','S113M','M113SV',1,TO_DATE('2020-03-13','YYYY-MM-DD'),TO_DATE('2020-03-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00014','S114M','M114BR',2,TO_DATE('2020-03-13','YYYY-MM-DD'),TO_DATE('2020-03-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00015','S115M','M115GD',2,TO_DATE('2020-03-13','YYYY-MM-DD'),TO_DATE('2020-03-29','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00016','S116M','M116BR',5,TO_DATE('2020-03-14','YYYY-MM-DD'),TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00017','S117M','M117SV',1,TO_DATE('2020-03-14','YYYY-MM-DD'),TO_DATE('2020-03-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00018','S118F','M118GD',4,TO_DATE('2020-03-14','YYYY-MM-DD'),TO_DATE('2020-03-30','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00019','S119F','M119BR',1,TO_DATE('2020-03-14','YYYY-MM-DD'),TO_DATE('2020-03-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00020','S120F','M120GD',3,TO_DATE('2020-03-14','YYYY-MM-DD'),TO_DATE('2020-03-30','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00021','S101M','M101BR',3,TO_DATE('2020-03-15','YYYY-MM-DD'),TO_DATE('2020-03-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00022','S102F','M102SV',2,TO_DATE('2020-03-15','YYYY-MM-DD'),TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00023','S103M','M103BR',1,TO_DATE('2020-03-15','YYYY-MM-DD'),TO_DATE('2020-03-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00024','S104M','M104SV',2,TO_DATE('2020-03-15','YYYY-MM-DD'),TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00025','S105M','M105GD',3,TO_DATE('2020-03-15','YYYY-MM-DD'),TO_DATE('2020-03-31','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00026','S106F','M106SV',4,TO_DATE('2020-03-16','YYYY-MM-DD'),TO_DATE('2020-03-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00027','S107F','M107BR',5,TO_DATE('2020-03-16','YYYY-MM-DD'),TO_DATE('2020-03-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00028','S108F','M108GD',6,TO_DATE('2020-03-16','YYYY-MM-DD'),TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00029','S109M','M109SV',1,TO_DATE('2020-03-16','YYYY-MM-DD'),TO_DATE('2020-03-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00030','S110F','M110BR',2,TO_DATE('2020-03-16','YYYY-MM-DD'),TO_DATE('2020-03-26','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00031','S111F','M111GD',3,TO_DATE('2020-03-17','YYYY-MM-DD'),TO_DATE('2020-04-02','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00032','S112F','M112BR',1,TO_DATE('2020-03-17','YYYY-MM-DD'),TO_DATE('2020-03-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00033','S113M','M113SV',2,TO_DATE('2020-03-17','YYYY-MM-DD'),TO_DATE('2020-03-30','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00034','S114M','M114BR',3,TO_DATE('2020-03-17','YYYY-MM-DD'),TO_DATE('2020-03-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00035','S115M','M115GD',4,TO_DATE('2020-03-17','YYYY-MM-DD'),TO_DATE('2020-04-02','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00036','S116M','M116BR',4,TO_DATE('2020-03-18','YYYY-MM-DD'),TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00037','S117M','M117SV',5,TO_DATE('2020-03-18','YYYY-MM-DD'),TO_DATE('2020-03-31','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00038','S118F','M118GD',6,TO_DATE('2020-03-18','YYYY-MM-DD'),TO_DATE('2020-04-03','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00039','S119F','M119BR',5,TO_DATE('2020-03-18','YYYY-MM-DD'),TO_DATE('2020-03-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00040','S120F','M120GD',4,TO_DATE('2020-03-18','YYYY-MM-DD'),TO_DATE('2020-04-03','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00041','S101M','M101BR',3,TO_DATE('2020-03-19','YYYY-MM-DD'),TO_DATE('2020-03-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00042','S102F','M102SV',3,TO_DATE('2020-03-19','YYYY-MM-DD'),TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00043','S103M','M103BR',1,TO_DATE('2020-03-19','YYYY-MM-DD'),TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00044','S104M','M104SV',2,TO_DATE('2020-03-19','YYYY-MM-DD'),TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00045','S105M','M105GD',2,TO_DATE('2020-03-19','YYYY-MM-DD'),TO_DATE('2020-04-04','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00046','S106F','M106SV',4,TO_DATE('2020-03-20','YYYY-MM-DD'),TO_DATE('2020-04-02','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00047','S107F','M107BR',2,TO_DATE('2020-03-20','YYYY-MM-DD'),TO_DATE('2020-03-30','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00048','S108F','M108GD',4,TO_DATE('2020-03-20','YYYY-MM-DD'),TO_DATE('2020-04-05','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00049','S109M','M109SV',3,TO_DATE('2020-03-20','YYYY-MM-DD'),TO_DATE('2020-04-02','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00050','S110F','M110BR',1,TO_DATE('2020-03-20','YYYY-MM-DD'),TO_DATE('2020-03-30','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00051','S111F','M111GD',3,TO_DATE('2020-03-21','YYYY-MM-DD'),TO_DATE('2020-04-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00052','S112F','M112BR',3,TO_DATE('2020-03-21','YYYY-MM-DD'),TO_DATE('2020-03-31','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00053','S113M','M113SV',1,TO_DATE('2020-03-21','YYYY-MM-DD'),TO_DATE('2020-04-03','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00054','S114M','M114BR',2,TO_DATE('2020-03-21','YYYY-MM-DD'),TO_DATE('2020-04-03','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00055','S115M','M115GD',2,TO_DATE('2020-03-21','YYYY-MM-DD'),TO_DATE('2020-04-06','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00056','S116M','M116BR',4,TO_DATE('2020-03-22','YYYY-MM-DD'),TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00057','S117M','M117SV',1,TO_DATE('2020-03-22','YYYY-MM-DD'),TO_DATE('2020-04-04','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00058','S118F','M118GD',5,TO_DATE('2020-03-22','YYYY-MM-DD'),TO_DATE('2020-04-07','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00059','S119F','M119BR',1,TO_DATE('2020-03-22','YYYY-MM-DD'),TO_DATE('2020-04-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00060','S120F','M120GD',4,TO_DATE('2020-03-22','YYYY-MM-DD'),TO_DATE('2020-04-07','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00061','S101M','M101BR',2,TO_DATE('2020-04-01','YYYY-MM-DD'),TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00062','S102F','M102SV',4,TO_DATE('2020-04-01','YYYY-MM-DD'),TO_DATE('2020-04-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00063','S103M','M103BR',6,TO_DATE('2020-04-01','YYYY-MM-DD'),TO_DATE('2020-04-11','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00064','S104M','M104SV',1,TO_DATE('2020-04-01','YYYY-MM-DD'),TO_DATE('2020-04-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00065','S105M','M105GD',3,TO_DATE('2020-04-01','YYYY-MM-DD'),TO_DATE('2020-04-17','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00066','S106F','M106SV',3,TO_DATE('2020-04-02','YYYY-MM-DD'),TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00067','S107F','M107BR',6,TO_DATE('2020-04-02','YYYY-MM-DD'),TO_DATE('2020-04-12','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00068','S108F','M108GD',5,TO_DATE('2020-04-02','YYYY-MM-DD'),TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00069','S109M','M109SV',2,TO_DATE('2020-04-02','YYYY-MM-DD'),TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00070','S110F','M110BR',1,TO_DATE('2020-04-02','YYYY-MM-DD'),TO_DATE('2020-04-12','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00071','S111F','M111GD',1,TO_DATE('2020-04-03','YYYY-MM-DD'),TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00072','S112F','M112BR',1,TO_DATE('2020-04-03','YYYY-MM-DD'),TO_DATE('2020-04-13','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00073','S113M','M113SV',2,TO_DATE('2020-04-03','YYYY-MM-DD'),TO_DATE('2020-04-16','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00074','S114M','M114BR',1,TO_DATE('2020-04-03','YYYY-MM-DD'),TO_DATE('2020-04-13','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00075','S115M','M115GD',1,TO_DATE('2020-04-03','YYYY-MM-DD'),TO_DATE('2020-04-19','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00076','S116M','M116BR',5,TO_DATE('2020-04-04','YYYY-MM-DD'),TO_DATE('2020-04-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00077','S117M','M117SV',1,TO_DATE('2020-04-04','YYYY-MM-DD'),TO_DATE('2020-04-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00078','S118F','M118GD',4,TO_DATE('2020-04-04','YYYY-MM-DD'),TO_DATE('2020-04-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00079','S119F','M119BR',1,TO_DATE('2020-04-04','YYYY-MM-DD'),TO_DATE('2020-04-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00080','S120F','M120GD',3,TO_DATE('2020-04-04','YYYY-MM-DD'),TO_DATE('2020-04-20','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00081','S101M','M101BR',3,TO_DATE('2020-04-05','YYYY-MM-DD'),TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00082','S102F','M102SV',2,TO_DATE('2020-04-05','YYYY-MM-DD'),TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00083','S103M','M103BR',1,TO_DATE('2020-04-05','YYYY-MM-DD'),TO_DATE('2020-04-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00084','S104M','M104SV',1,TO_DATE('2020-04-05','YYYY-MM-DD'),TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00085','S105M','M105GD',2,TO_DATE('2020-04-05','YYYY-MM-DD'),TO_DATE('2020-04-21','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00086','S106F','M106SV',3,TO_DATE('2020-04-06','YYYY-MM-DD'),TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00087','S107F','M107BR',6,TO_DATE('2020-04-06','YYYY-MM-DD'),TO_DATE('2020-04-16','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00088','S108F','M108GD',3,TO_DATE('2020-04-06','YYYY-MM-DD'),TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00089','S109M','M109SV',6,TO_DATE('2020-04-06','YYYY-MM-DD'),TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00090','S110F','M110BR',2,TO_DATE('2020-04-06','YYYY-MM-DD'),TO_DATE('2020-04-16','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00091','S111F','M111GD',2,TO_DATE('2020-04-07','YYYY-MM-DD'),TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00092','S112F','M112BR',1,TO_DATE('2020-04-07','YYYY-MM-DD'),TO_DATE('2020-04-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00093','S113M','M113SV',2,TO_DATE('2020-04-07','YYYY-MM-DD'),TO_DATE('2020-04-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00094','S114M','M114BR',1,TO_DATE('2020-04-07','YYYY-MM-DD'),TO_DATE('2020-04-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00095','S115M','M115GD',2,TO_DATE('2020-04-07','YYYY-MM-DD'),TO_DATE('2020-04-23','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00096','S116M','M116BR',2,TO_DATE('2020-04-08','YYYY-MM-DD'),TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00097','S117M','M117SV',3,TO_DATE('2020-04-08','YYYY-MM-DD'),TO_DATE('2020-04-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00098','S118F','M118GD',3,TO_DATE('2020-04-08','YYYY-MM-DD'),TO_DATE('2020-04-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00099','S119F','M119BR',3,TO_DATE('2020-04-08','YYYY-MM-DD'),TO_DATE('2020-04-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00100','S120F','M120GD',2,TO_DATE('2020-04-08','YYYY-MM-DD'),TO_DATE('2020-04-24','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00101','S101M','M101BR',3,TO_DATE('2020-04-09','YYYY-MM-DD'),TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00102','S102F','M102SV',4,TO_DATE('2020-04-09','YYYY-MM-DD'),TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00103','S103M','M103BR',3,TO_DATE('2020-04-09','YYYY-MM-DD'),TO_DATE('2020-04-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00104','S104M','M104SV',4,TO_DATE('2020-04-09','YYYY-MM-DD'),TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00105','S105M','M105GD',3,TO_DATE('2020-04-09','YYYY-MM-DD'),TO_DATE('2020-04-25','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00106','S106F','M106SV',3,TO_DATE('2020-04-10','YYYY-MM-DD'),TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00107','S107F','M107BR',6,TO_DATE('2020-04-10','YYYY-MM-DD'),TO_DATE('2020-04-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00108','S108F','M108GD',5,TO_DATE('2020-04-10','YYYY-MM-DD'),TO_DATE('2020-04-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00109','S109M','M109SV',5,TO_DATE('2020-04-10','YYYY-MM-DD'),TO_DATE('2020-04-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00110','S110F','M110BR',1,TO_DATE('2020-04-10','YYYY-MM-DD'),TO_DATE('2020-04-20','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00111','S111F','M111GD',1,TO_DATE('2020-04-11','YYYY-MM-DD'),TO_DATE('2020-04-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00112','S112F','M112BR',2,TO_DATE('2020-04-11','YYYY-MM-DD'),TO_DATE('2020-04-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00113','S113M','M113SV',2,TO_DATE('2020-04-11','YYYY-MM-DD'),TO_DATE('2020-04-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00114','S114M','M114BR',2,TO_DATE('2020-04-11','YYYY-MM-DD'),TO_DATE('2020-04-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00115','S115M','M115GD',1,TO_DATE('2020-04-11','YYYY-MM-DD'),TO_DATE('2020-04-27','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00116','S116M','M116BR',4,TO_DATE('2020-04-12','YYYY-MM-DD'),TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00117','S117M','M117SV',3,TO_DATE('2020-04-12','YYYY-MM-DD'),TO_DATE('2020-04-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00118','S118F','M118GD',2,TO_DATE('2020-04-12','YYYY-MM-DD'),TO_DATE('2020-04-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00119','S119F','M119BR',1,TO_DATE('2020-04-12','YYYY-MM-DD'),TO_DATE('2020-04-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00120','S120F','M120GD',3,TO_DATE('2020-04-12','YYYY-MM-DD'),TO_DATE('2020-04-28','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00121','S101M','M101BR',5,TO_DATE('2020-05-11','YYYY-MM-DD'),TO_DATE('2020-05-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00122','S102F','M102SV',5,TO_DATE('2020-05-11','YYYY-MM-DD'),TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00123','S103M','M103BR',1,TO_DATE('2020-05-11','YYYY-MM-DD'),TO_DATE('2020-05-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00124','S104M','M104SV',2,TO_DATE('2020-05-11','YYYY-MM-DD'),TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00125','S105M','M105GD',2,TO_DATE('2020-05-11','YYYY-MM-DD'),TO_DATE('2020-05-27','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00126','S106F','M106SV',4,TO_DATE('2020-05-12','YYYY-MM-DD'),TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00127','S107F','M107BR',2,TO_DATE('2020-05-12','YYYY-MM-DD'),TO_DATE('2020-05-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00128','S108F','M108GD',4,TO_DATE('2020-05-12','YYYY-MM-DD'),TO_DATE('2020-05-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00129','S109M','M109SV',3,TO_DATE('2020-05-12','YYYY-MM-DD'),TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00130','S110F','M110BR',1,TO_DATE('2020-05-12','YYYY-MM-DD'),TO_DATE('2020-05-22','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00131','S111F','M111GD',3,TO_DATE('2020-05-13','YYYY-MM-DD'),TO_DATE('2020-05-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00132','S112F','M112BR',1,TO_DATE('2020-05-13','YYYY-MM-DD'),TO_DATE('2020-05-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00133','S113M','M113SV',2,TO_DATE('2020-05-13','YYYY-MM-DD'),TO_DATE('2020-05-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00134','S114M','M114BR',1,TO_DATE('2020-05-13','YYYY-MM-DD'),TO_DATE('2020-05-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00135','S115M','M115GD',3,TO_DATE('2020-05-13','YYYY-MM-DD'),TO_DATE('2020-05-29','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00136','S116M','M116BR',5,TO_DATE('2020-05-14','YYYY-MM-DD'),TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00137','S117M','M117SV',4,TO_DATE('2020-05-14','YYYY-MM-DD'),TO_DATE('2020-05-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00138','S118F','M118GD',4,TO_DATE('2020-05-14','YYYY-MM-DD'),TO_DATE('2020-05-30','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00139','S119F','M119BR',4,TO_DATE('2020-05-14','YYYY-MM-DD'),TO_DATE('2020-05-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00140','S120F','M120GD',5,TO_DATE('2020-05-14','YYYY-MM-DD'),TO_DATE('2020-05-30','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00141','S101M','M101BR',3,TO_DATE('2020-05-15','YYYY-MM-DD'),TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00142','S102F','M102SV',2,TO_DATE('2020-05-15','YYYY-MM-DD'),TO_DATE('2020-05-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00143','S103M','M103BR',3,TO_DATE('2020-05-15','YYYY-MM-DD'),TO_DATE('2020-05-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00144','S104M','M104SV',2,TO_DATE('2020-05-15','YYYY-MM-DD'),TO_DATE('2020-05-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00145','S105M','M105GD',3,TO_DATE('2020-05-15','YYYY-MM-DD'),TO_DATE('2020-05-31','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00146','S106F','M106SV',2,TO_DATE('2020-05-16','YYYY-MM-DD'),TO_DATE('2020-05-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00147','S107F','M107BR',4,TO_DATE('2020-05-16','YYYY-MM-DD'),TO_DATE('2020-05-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00148','S108F','M108GD',6,TO_DATE('2020-05-16','YYYY-MM-DD'),TO_DATE('2020-06-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00149','S109M','M109SV',4,TO_DATE('2020-05-16','YYYY-MM-DD'),TO_DATE('2020-05-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00150','S110F','M110BR',2,TO_DATE('2020-05-16','YYYY-MM-DD'),TO_DATE('2020-05-26','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00151','S111F','M111GD',2,TO_DATE('2020-05-17','YYYY-MM-DD'),TO_DATE('2020-06-02','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00152','S112F','M112BR',2,TO_DATE('2020-05-17','YYYY-MM-DD'),TO_DATE('2020-05-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00153','S113M','M113SV',5,TO_DATE('2020-05-17','YYYY-MM-DD'),TO_DATE('2020-05-30','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00154','S114M','M114BR',2,TO_DATE('2020-05-17','YYYY-MM-DD'),TO_DATE('2020-05-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00155','S115M','M115GD',2,TO_DATE('2020-05-17','YYYY-MM-DD'),TO_DATE('2020-06-02','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00156','S116M','M116BR',4,TO_DATE('2020-05-18','YYYY-MM-DD'),TO_DATE('2020-05-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00157','S117M','M117SV',5,TO_DATE('2020-05-18','YYYY-MM-DD'),TO_DATE('2020-05-31','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00158','S118F','M118GD',6,TO_DATE('2020-05-18','YYYY-MM-DD'),TO_DATE('2020-06-03','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00159','S119F','M119BR',5,TO_DATE('2020-05-18','YYYY-MM-DD'),TO_DATE('2020-05-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00160','S120F','M120GD',4,TO_DATE('2020-05-18','YYYY-MM-DD'),TO_DATE('2020-06-03','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00161','S101M','M101BR',3,TO_DATE('2020-05-19','YYYY-MM-DD'),TO_DATE('2020-05-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00162','S102F','M102SV',3,TO_DATE('2020-05-19','YYYY-MM-DD'),TO_DATE('2020-06-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00163','S103M','M103BR',1,TO_DATE('2020-05-19','YYYY-MM-DD'),TO_DATE('2020-05-29','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00164','S104M','M104SV',2,TO_DATE('2020-05-19','YYYY-MM-DD'),TO_DATE('2020-06-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00165','S105M','M105GD',2,TO_DATE('2020-05-19','YYYY-MM-DD'),TO_DATE('2020-06-04','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00166','S106F','M106SV',4,TO_DATE('2020-05-20','YYYY-MM-DD'),TO_DATE('2020-06-02','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00167','S107F','M107BR',2,TO_DATE('2020-05-20','YYYY-MM-DD'),TO_DATE('2020-05-30','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00168','S108F','M108GD',4,TO_DATE('2020-05-20','YYYY-MM-DD'),TO_DATE('2020-06-05','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00169','S109M','M109SV',3,TO_DATE('2020-05-20','YYYY-MM-DD'),TO_DATE('2020-06-02','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00170','S110F','M110BR',1,TO_DATE('2020-05-20','YYYY-MM-DD'),TO_DATE('2020-05-30','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00171','S111F','M111GD',3,TO_DATE('2020-05-21','YYYY-MM-DD'),TO_DATE('2020-06-06','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00172','S112F','M112BR',3,TO_DATE('2020-05-21','YYYY-MM-DD'),TO_DATE('2020-05-31','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00173','S113M','M113SV',1,TO_DATE('2020-05-21','YYYY-MM-DD'),TO_DATE('2020-06-03','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00174','S114M','M114BR',2,TO_DATE('2020-05-21','YYYY-MM-DD'),TO_DATE('2020-05-31','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00175','S115M','M115GD',2,TO_DATE('2020-05-21','YYYY-MM-DD'),TO_DATE('2020-06-06','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00176','S116M','M116BR',4,TO_DATE('2020-05-22','YYYY-MM-DD'),TO_DATE('2020-06-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00177','S117M','M117SV',1,TO_DATE('2020-05-22','YYYY-MM-DD'),TO_DATE('2020-06-04','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00178','S118F','M118GD',5,TO_DATE('2020-05-22','YYYY-MM-DD'),TO_DATE('2020-06-07','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00179','S119F','M119BR',1,TO_DATE('2020-05-22','YYYY-MM-DD'),TO_DATE('2020-06-01','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00180','S120F','M120GD',4,TO_DATE('2020-05-22','YYYY-MM-DD'),TO_DATE('2020-06-07','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00181','S101M','M101BR',5,TO_DATE('2020-06-01','YYYY-MM-DD'),TO_DATE('2020-06-11','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00182','S102F','M102SV',4,TO_DATE('2020-06-01','YYYY-MM-DD'),TO_DATE('2020-06-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00183','S103M','M103BR',6,TO_DATE('2020-06-01','YYYY-MM-DD'),TO_DATE('2020-06-11','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00184','S104M','M104SV',4,TO_DATE('2020-06-01','YYYY-MM-DD'),TO_DATE('2020-06-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00185','S105M','M105GD',5,TO_DATE('2020-06-01','YYYY-MM-DD'),TO_DATE('2020-06-17','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00186','S106F','M106SV',3,TO_DATE('2020-06-02','YYYY-MM-DD'),TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00187','S107F','M107BR',3,TO_DATE('2020-06-02','YYYY-MM-DD'),TO_DATE('2020-06-12','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00188','S108F','M108GD',5,TO_DATE('2020-06-02','YYYY-MM-DD'),TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00189','S109M','M109SV',3,TO_DATE('2020-06-02','YYYY-MM-DD'),TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00190','S110F','M110BR',3,TO_DATE('2020-06-02','YYYY-MM-DD'),TO_DATE('2020-06-12','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00191','S111F','M111GD',2,TO_DATE('2020-06-03','YYYY-MM-DD'),TO_DATE('2020-06-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00192','S112F','M112BR',1,TO_DATE('2020-06-03','YYYY-MM-DD'),TO_DATE('2020-06-13','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00193','S113M','M113SV',2,TO_DATE('2020-06-03','YYYY-MM-DD'),TO_DATE('2020-06-16','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00194','S114M','M114BR',1,TO_DATE('2020-06-03','YYYY-MM-DD'),TO_DATE('2020-06-13','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00195','S115M','M115GD',3,TO_DATE('2020-06-03','YYYY-MM-DD'),TO_DATE('2020-06-19','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00196','S116M','M116BR',3,TO_DATE('2020-06-04','YYYY-MM-DD'),TO_DATE('2020-06-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00197','S117M','M117SV',1,TO_DATE('2020-06-04','YYYY-MM-DD'),TO_DATE('2020-06-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00198','S118F','M118GD',3,TO_DATE('2020-06-04','YYYY-MM-DD'),TO_DATE('2020-06-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00199','S119F','M119BR',1,TO_DATE('2020-06-04','YYYY-MM-DD'),TO_DATE('2020-06-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00200','S120F','M120GD',4,TO_DATE('2020-06-04','YYYY-MM-DD'),TO_DATE('2020-06-20','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00201','S101M','M101BR',4,TO_DATE('2020-06-05','YYYY-MM-DD'),TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00202','S102F','M102SV',2,TO_DATE('2020-06-05','YYYY-MM-DD'),TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00203','S103M','M103BR',1,TO_DATE('2020-06-05','YYYY-MM-DD'),TO_DATE('2020-06-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00204','S104M','M104SV',4,TO_DATE('2020-06-05','YYYY-MM-DD'),TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00205','S105M','M105GD',2,TO_DATE('2020-06-05','YYYY-MM-DD'),TO_DATE('2020-06-21','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00206','S106F','M106SV',4,TO_DATE('2020-06-06','YYYY-MM-DD'),TO_DATE('2020-06-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00207','S107F','M107BR',6,TO_DATE('2020-06-06','YYYY-MM-DD'),TO_DATE('2020-06-16','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00208','S108F','M108GD',4,TO_DATE('2020-06-06','YYYY-MM-DD'),TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00209','S109M','M109SV',6,TO_DATE('2020-06-06','YYYY-MM-DD'),TO_DATE('2020-06-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00210','S110F','M110BR',2,TO_DATE('2020-06-06','YYYY-MM-DD'),TO_DATE('2020-06-16','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00211','S111F','M111GD',3,TO_DATE('2020-06-07','YYYY-MM-DD'),TO_DATE('2020-06-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00212','S112F','M112BR',1,TO_DATE('2020-06-07','YYYY-MM-DD'),TO_DATE('2020-06-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00213','S113M','M113SV',1,TO_DATE('2020-06-07','YYYY-MM-DD'),TO_DATE('2020-06-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00214','S114M','M114BR',1,TO_DATE('2020-06-07','YYYY-MM-DD'),TO_DATE('2020-06-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00215','S115M','M115GD',2,TO_DATE('2020-06-07','YYYY-MM-DD'),TO_DATE('2020-06-23','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00216','S116M','M116BR',4,TO_DATE('2020-06-08','YYYY-MM-DD'),TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00217','S117M','M117SV',3,TO_DATE('2020-06-08','YYYY-MM-DD'),TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00218','S118F','M118GD',4,TO_DATE('2020-06-08','YYYY-MM-DD'),TO_DATE('2020-06-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00219','S119F','M119BR',3,TO_DATE('2020-06-08','YYYY-MM-DD'),TO_DATE('2020-06-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00220','S120F','M120GD',2,TO_DATE('2020-06-08','YYYY-MM-DD'),TO_DATE('2020-06-24','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00221','S101M','M101BR',3,TO_DATE('2020-06-09','YYYY-MM-DD'),TO_DATE('2020-06-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00222','S102F','M102SV',4,TO_DATE('2020-06-09','YYYY-MM-DD'),TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00223','S103M','M103BR',1,TO_DATE('2020-06-09','YYYY-MM-DD'),TO_DATE('2020-06-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00224','S104M','M104SV',4,TO_DATE('2020-06-09','YYYY-MM-DD'),TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00225','S105M','M105GD',1,TO_DATE('2020-06-09','YYYY-MM-DD'),TO_DATE('2020-06-25','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00226','S106F','M106SV',3,TO_DATE('2020-06-10','YYYY-MM-DD'),TO_DATE('2020-06-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00227','S107F','M107BR',6,TO_DATE('2020-06-10','YYYY-MM-DD'),TO_DATE('2020-06-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00228','S108F','M108GD',3,TO_DATE('2020-06-10','YYYY-MM-DD'),TO_DATE('2020-06-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00229','S109M','M109SV',3,TO_DATE('2020-06-10','YYYY-MM-DD'),TO_DATE('2020-06-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00230','S110F','M110BR',1,TO_DATE('2020-06-10','YYYY-MM-DD'),TO_DATE('2020-06-20','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00231','S111F','M111GD',1,TO_DATE('2020-06-11','YYYY-MM-DD'),TO_DATE('2020-06-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00232','S112F','M112BR',3,TO_DATE('2020-06-11','YYYY-MM-DD'),TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00233','S113M','M113SV',3,TO_DATE('2020-06-11','YYYY-MM-DD'),TO_DATE('2020-06-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00234','S114M','M114BR',2,TO_DATE('2020-06-11','YYYY-MM-DD'),TO_DATE('2020-06-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00235','S115M','M115GD',1,TO_DATE('2020-06-11','YYYY-MM-DD'),TO_DATE('2020-06-27','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00236','S116M','M116BR',4,TO_DATE('2020-06-12','YYYY-MM-DD'),TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00237','S117M','M117SV',4,TO_DATE('2020-06-12','YYYY-MM-DD'),TO_DATE('2020-06-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00238','S118F','M118GD',2,TO_DATE('2020-06-12','YYYY-MM-DD'),TO_DATE('2020-06-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00239','S119F','M119BR',1,TO_DATE('2020-06-12','YYYY-MM-DD'),TO_DATE('2020-06-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00240','S120F','M120GD',3,TO_DATE('2020-06-12','YYYY-MM-DD'),TO_DATE('2020-06-28','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00241','S101M','M101BR',3,TO_DATE('2020-07-01','YYYY-MM-DD'),TO_DATE('2020-07-11','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00242','S102F','M102SV',3,TO_DATE('2020-07-01','YYYY-MM-DD'),TO_DATE('2020-07-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00243','S103M','M103BR',2,TO_DATE('2020-07-01','YYYY-MM-DD'),TO_DATE('2020-07-11','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00244','S104M','M104SV',2,TO_DATE('2020-07-01','YYYY-MM-DD'),TO_DATE('2020-07-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00245','S105M','M105GD',3,TO_DATE('2020-07-01','YYYY-MM-DD'),TO_DATE('2020-07-17','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00246','S106F','M106SV',3,TO_DATE('2020-07-02','YYYY-MM-DD'),TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00247','S107F','M107BR',4,TO_DATE('2020-07-02','YYYY-MM-DD'),TO_DATE('2020-07-12','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00248','S108F','M108GD',5,TO_DATE('2020-07-02','YYYY-MM-DD'),TO_DATE('2020-07-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00249','S109M','M109SV',4,TO_DATE('2020-07-02','YYYY-MM-DD'),TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00250','S110F','M110BR',1,TO_DATE('2020-07-02','YYYY-MM-DD'),TO_DATE('2020-07-12','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00251','S111F','M111GD',1,TO_DATE('2020-07-03','YYYY-MM-DD'),TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00252','S112F','M112BR',5,TO_DATE('2020-07-03','YYYY-MM-DD'),TO_DATE('2020-07-13','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00253','S113M','M113SV',3,TO_DATE('2020-07-03','YYYY-MM-DD'),TO_DATE('2020-07-16','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00254','S114M','M114BR',2,TO_DATE('2020-07-03','YYYY-MM-DD'),TO_DATE('2020-07-13','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00255','S115M','M115GD',1,TO_DATE('2020-07-03','YYYY-MM-DD'),TO_DATE('2020-07-19','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00256','S116M','M116BR',3,TO_DATE('2020-07-04','YYYY-MM-DD'),TO_DATE('2020-07-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00257','S117M','M117SV',1,TO_DATE('2020-07-04','YYYY-MM-DD'),TO_DATE('2020-07-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00258','S118F','M118GD',4,TO_DATE('2020-07-04','YYYY-MM-DD'),TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00259','S119F','M119BR',2,TO_DATE('2020-07-04','YYYY-MM-DD'),TO_DATE('2020-07-14','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00260','S120F','M120GD',2,TO_DATE('2020-07-04','YYYY-MM-DD'),TO_DATE('2020-07-20','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00261','S101M','M101BR',3,TO_DATE('2020-07-05','YYYY-MM-DD'),TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00262','S102F','M102SV',3,TO_DATE('2020-07-05','YYYY-MM-DD'),TO_DATE('2020-07-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00263','S103M','M103BR',1,TO_DATE('2020-07-05','YYYY-MM-DD'),TO_DATE('2020-07-15','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00264','S104M','M104SV',1,TO_DATE('2020-07-05','YYYY-MM-DD'),TO_DATE('2020-07-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00265','S105M','M105GD',1,TO_DATE('2020-07-05','YYYY-MM-DD'),TO_DATE('2020-07-21','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00266','S106F','M106SV',2,TO_DATE('2020-07-06','YYYY-MM-DD'),TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00267','S107F','M107BR',4,TO_DATE('2020-07-06','YYYY-MM-DD'),TO_DATE('2020-07-16','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00268','S108F','M108GD',2,TO_DATE('2020-07-06','YYYY-MM-DD'),TO_DATE('2020-07-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00269','S109M','M109SV',6,TO_DATE('2020-07-06','YYYY-MM-DD'),TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00270','S110F','M110BR',2,TO_DATE('2020-07-06','YYYY-MM-DD'),TO_DATE('2020-07-16','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00271','S111F','M111GD',3,TO_DATE('2020-07-07','YYYY-MM-DD'),TO_DATE('2020-07-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00272','S112F','M112BR',1,TO_DATE('2020-07-07','YYYY-MM-DD'),TO_DATE('2020-07-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00273','S113M','M113SV',2,TO_DATE('2020-07-07','YYYY-MM-DD'),TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00274','S114M','M114BR',2,TO_DATE('2020-07-07','YYYY-MM-DD'),TO_DATE('2020-07-17','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00275','S115M','M115GD',5,TO_DATE('2020-07-07','YYYY-MM-DD'),TO_DATE('2020-07-23','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00276','S116M','M116BR',4,TO_DATE('2020-07-08','YYYY-MM-DD'),TO_DATE('2020-07-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00277','S117M','M117SV',3,TO_DATE('2020-07-08','YYYY-MM-DD'),TO_DATE('2020-07-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00278','S118F','M118GD',4,TO_DATE('2020-07-08','YYYY-MM-DD'),TO_DATE('2020-07-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00279','S119F','M119BR',5,TO_DATE('2020-07-08','YYYY-MM-DD'),TO_DATE('2020-07-18','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00280','S120F','M120GD',2,TO_DATE('2020-07-08','YYYY-MM-DD'),TO_DATE('2020-07-24','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00281','S101M','M101BR',3,TO_DATE('2020-07-09','YYYY-MM-DD'),TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00282','S102F','M102SV',4,TO_DATE('2020-07-09','YYYY-MM-DD'),TO_DATE('2020-07-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00283','S103M','M103BR',1,TO_DATE('2020-07-09','YYYY-MM-DD'),TO_DATE('2020-07-19','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00284','S104M','M104SV',2,TO_DATE('2020-07-09','YYYY-MM-DD'),TO_DATE('2020-07-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00285','S105M','M105GD',1,TO_DATE('2020-07-09','YYYY-MM-DD'),TO_DATE('2020-07-25','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LS00286','S106F','M106SV',3,TO_DATE('2020-07-10','YYYY-MM-DD'),TO_DATE('2020-07-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00287','S107F','M107BR',6,TO_DATE('2020-07-10','YYYY-MM-DD'),TO_DATE('2020-07-20','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00288','S108F','M108GD',2,TO_DATE('2020-07-10','YYYY-MM-DD'),TO_DATE('2020-07-26','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00289','S109M','M109SV',3,TO_DATE('2020-07-10','YYYY-MM-DD'),TO_DATE('2020-07-23','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00290','S110F','M110BR',1,TO_DATE('2020-07-10','YYYY-MM-DD'),TO_DATE('2020-07-20','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LG00291','S111F','M111GD',1,TO_DATE('2020-07-11','YYYY-MM-DD'),TO_DATE('2020-07-27','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00292','S112F','M112BR',3,TO_DATE('2020-07-11','YYYY-MM-DD'),TO_DATE('2020-07-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00293','S113M','M113SV',3,TO_DATE('2020-07-11','YYYY-MM-DD'),TO_DATE('2020-07-24','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00294','S114M','M114BR',2,TO_DATE('2020-07-11','YYYY-MM-DD'),TO_DATE('2020-07-21','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00295','S115M','M115GD',4,TO_DATE('2020-07-11','YYYY-MM-DD'),TO_DATE('2020-07-27','YYYY-MM-DD'));

INSERT INTO book_loan VALUES ('LB00296','S116M','M116BR',4,TO_DATE('2020-07-12','YYYY-MM-DD'),TO_DATE('2020-07-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LS00297','S117M','M117SV',2,TO_DATE('2020-07-12','YYYY-MM-DD'),TO_DATE('2020-07-25','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00298','S118F','M118GD',2,TO_DATE('2020-07-12','YYYY-MM-DD'),TO_DATE('2020-07-28','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LB00299','S119F','M119BR',1,TO_DATE('2020-07-12','YYYY-MM-DD'),TO_DATE('2020-07-22','YYYY-MM-DD'));
INSERT INTO book_loan VALUES ('LG00300','S120F','M120GD',2,TO_DATE('2020-07-12','YYYY-MM-DD'),TO_DATE('2020-07-28','YYYY-MM-DD'));


--Lend Book Table
INSERT INTO lend_books VALUES ('LB00001','B1FANT1955','Loan');
INSERT INTO lend_books VALUES ('LS00002','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LB00003','B4COMI2012','Loan');
INSERT INTO lend_books VALUES ('LS00004','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00005','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LS00006','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LB00007','B6HLTH2005','Loan');
INSERT INTO lend_books VALUES ('LG00008','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LS00009','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LB00010','B9EDUC2015','Loan');

INSERT INTO lend_books VALUES ('LG00011','B11ROMC1813','Return');
INSERT INTO lend_books VALUES ('LB00012','B13NOVE2017','Loan');
INSERT INTO lend_books VALUES ('LS00013','B14POET2017','Return');
INSERT INTO lend_books VALUES ('LB00014','B15SPRT2012','Loan');
INSERT INTO lend_books VALUES ('LG00015','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LB00016','B19TEEN1962','Loan');
INSERT INTO lend_books VALUES ('LS00017','B12JOUR2014','Return');
INSERT INTO lend_books VALUES ('LG00018','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LB00019','B16TEEN2017','Loan');
INSERT INTO lend_books VALUES ('LG00020','B17SOSC2018','Return');

INSERT INTO lend_books VALUES ('LB00021','B21SCFI2010','Loan');
INSERT INTO lend_books VALUES ('LS00022','B22COMI2013','Return');
INSERT INTO lend_books VALUES ('LB00023','B24ROMC1997','Loan');
INSERT INTO lend_books VALUES ('LS00024','B23NOVE2015','Return');
INSERT INTO lend_books VALUES ('LG00025','B25HORR2011','Return');

INSERT INTO lend_books VALUES ('LS00026','B27NOVE2019','Return');
INSERT INTO lend_books VALUES ('LB00027','B26SCFI1999','Return');
INSERT INTO lend_books VALUES ('LG00028','B28TEEN2016','Return');
INSERT INTO lend_books VALUES ('LS00029','B30COOK2017','Return');
INSERT INTO lend_books VALUES ('LB00030','B29COOK2019','Return');

INSERT INTO lend_books VALUES ('LG00031','B31NOVE2019','Return');
INSERT INTO lend_books VALUES ('LB00032','B33COMI2017','Return');
INSERT INTO lend_books VALUES ('LS00033','B34JOUR2020','Return');
INSERT INTO lend_books VALUES ('LB00034','B35COMI2017','Return');
INSERT INTO lend_books VALUES ('LG00035','B32COMI2020','Return');

INSERT INTO lend_books VALUES ('LB00036','B39NOVE2020','Return');
INSERT INTO lend_books VALUES ('LS00037','B40COMI2020','Return');
INSERT INTO lend_books VALUES ('LG00038','B38JOUR2019','Return');
INSERT INTO lend_books VALUES ('LB00039','B36TEEN2020','Return');
INSERT INTO lend_books VALUES ('LG00040','B37COMI2019','Return');

INSERT INTO lend_books VALUES ('LB00041','B1FANT1955','Return');
INSERT INTO lend_books VALUES ('LS00042','B2BIOG2004','Return');
INSERT INTO lend_books VALUES ('LB00043','B4COMI2012','Return');
INSERT INTO lend_books VALUES ('LS00044','B3HORR1986','Return');
INSERT INTO lend_books VALUES ('LG00045','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LS00046','B7SCFI1992','Return');
INSERT INTO lend_books VALUES ('LB00047','B6HLTH2005','Return');
INSERT INTO lend_books VALUES ('LG00048','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LS00049','B10CHLD1952','Return');
INSERT INTO lend_books VALUES ('LB00050','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LG00051','B11ROMC1813','Return');
INSERT INTO lend_books VALUES ('LB00052','B13NOVE2017','Return');
INSERT INTO lend_books VALUES ('LS00053','B14POET2017','Return');
INSERT INTO lend_books VALUES ('LB00054','B15SPRT2012','Return');
INSERT INTO lend_books VALUES ('LG00055','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LB00056','B19TEEN1962','Return');
INSERT INTO lend_books VALUES ('LS00057','B12JOUR2014','Return');
INSERT INTO lend_books VALUES ('LG00058','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LB00059','B16TEEN2017','Return');
INSERT INTO lend_books VALUES ('LG00060','B17SOSC2018','Return');

INSERT INTO lend_books VALUES ('LB00061','B21SCFI2010','Loan');
INSERT INTO lend_books VALUES ('LS00062','B23NOVE2015','Loan');
INSERT INTO lend_books VALUES ('LB00063','B24ROMC1997','Loan');
INSERT INTO lend_books VALUES ('LS00064','B25HORR2011','Loan');
INSERT INTO lend_books VALUES ('LG00065','B30COOK2017','Return');

INSERT INTO lend_books VALUES ('LS00066','B29COOK2019','Loan');
INSERT INTO lend_books VALUES ('LB00067','B22COMI2013','Loan');
INSERT INTO lend_books VALUES ('LG00068','B28TEEN2016','Return');
INSERT INTO lend_books VALUES ('LS00069','B26SCFI1999','Loan');
INSERT INTO lend_books VALUES ('LB00070','B27NOVE2019','Loan');

INSERT INTO lend_books VALUES ('LG00071','B1FANT1955','Return');
INSERT INTO lend_books VALUES ('LB00072','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LS00073','B4COMI2012','Loan');
INSERT INTO lend_books VALUES ('LB00074','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00075','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LB00076','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LS00077','B6HLTH2005','Loan');
INSERT INTO lend_books VALUES ('LG00078','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LB00079','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LG00080','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LB00081','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LS00082','B13NOVE2017','Return');
INSERT INTO lend_books VALUES ('LB00083','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LS00084','B15SPRT2012','Return');
INSERT INTO lend_books VALUES ('LG00085','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LS00086','B19TEEN1962','Return');
INSERT INTO lend_books VALUES ('LB00087','B12JOUR2014','Loan');
INSERT INTO lend_books VALUES ('LG00088','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LS00089','B16TEEN2017','Return');
INSERT INTO lend_books VALUES ('LB00090','B17SOSC2018','Loan');

INSERT INTO lend_books VALUES ('LG00091','B31NOVE2019','Return');
INSERT INTO lend_books VALUES ('LB00092','B33COMI2017','Loan');
INSERT INTO lend_books VALUES ('LS00093','B34JOUR2020','Return');
INSERT INTO lend_books VALUES ('LB00094','B35COMI2017','Loan');
INSERT INTO lend_books VALUES ('LG00095','B40COMI2020','Return');

INSERT INTO lend_books VALUES ('LB00096','B39NOVE2020','Loan');
INSERT INTO lend_books VALUES ('LS00097','B32COMI2020','Return');
INSERT INTO lend_books VALUES ('LG00098','B38JOUR2019','Return');
INSERT INTO lend_books VALUES ('LB00099','B36TEEN2020','Loan');
INSERT INTO lend_books VALUES ('LG00100','B37COMI2019','Loan');

INSERT INTO lend_books VALUES ('LB00101','B1FANT1955','Loan');
INSERT INTO lend_books VALUES ('LS00102','B2BIOG2004','Return');
INSERT INTO lend_books VALUES ('LB00103','B4COMI2012','Loan');
INSERT INTO lend_books VALUES ('LS00104','B3HORR1986','Return');
INSERT INTO lend_books VALUES ('LG00105','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LS00106','B7SCFI1992','Return');
INSERT INTO lend_books VALUES ('LB00107','B6HLTH2005','Return');
INSERT INTO lend_books VALUES ('LG00108','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LS00109','B10CHLD1952','Return');
INSERT INTO lend_books VALUES ('LB00110','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LG00111','B11ROMC1813','Return');
INSERT INTO lend_books VALUES ('LB00112','B13NOVE2017','Return');
INSERT INTO lend_books VALUES ('LS00113','B14POET2017','Return');
INSERT INTO lend_books VALUES ('LB00114','B15SPRT2012','Return');
INSERT INTO lend_books VALUES ('LG00115','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LB00116','B19TEEN1962','Return');
INSERT INTO lend_books VALUES ('LS00117','B12JOUR2014','Return');
INSERT INTO lend_books VALUES ('LG00118','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LB00119','B16TEEN2017','Return');
INSERT INTO lend_books VALUES ('LG00120','B17SOSC2018','Return');

INSERT INTO lend_books VALUES ('LB00121','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LS00122','B13NOVE2017','Return');
INSERT INTO lend_books VALUES ('LB00123','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LS00124','B15SPRT2012','Return');
INSERT INTO lend_books VALUES ('LG00125','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LS00126','B29COOK2019','Return');
INSERT INTO lend_books VALUES ('LB00127','B22COMI2013','Loan');
INSERT INTO lend_books VALUES ('LG00128','B28TEEN2016','Return');
INSERT INTO lend_books VALUES ('LS00129','B26SCFI1999','Return');
INSERT INTO lend_books VALUES ('LB00130','B27NOVE2019','Loan');

INSERT INTO lend_books VALUES ('LG00131','B1FANT1955','Return');
INSERT INTO lend_books VALUES ('LB00132','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LS00133','B4COMI2012','Return');
INSERT INTO lend_books VALUES ('LB00134','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00135','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LB00136','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LS00137','B6HLTH2005','Return');
INSERT INTO lend_books VALUES ('LG00138','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LB00139','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LG00140','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LB00141','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LS00142','B13NOVE2017','Return');
INSERT INTO lend_books VALUES ('LB00143','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LS00144','B15SPRT2012','Return');
INSERT INTO lend_books VALUES ('LG00145','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LS00146','B19TEEN1962','Return');
INSERT INTO lend_books VALUES ('LB00147','B12JOUR2014','Return');
INSERT INTO lend_books VALUES ('LG00148','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LS00149','B16TEEN2017','Return');
INSERT INTO lend_books VALUES ('LB00150','B17SOSC2018','Return');

INSERT INTO lend_books VALUES ('LG00151','B31NOVE2019','Return');
INSERT INTO lend_books VALUES ('LB00152','B33COMI2017','Loan');
INSERT INTO lend_books VALUES ('LS00153','B34JOUR2020','Return');
INSERT INTO lend_books VALUES ('LB00154','B35COMI2017','Loan');
INSERT INTO lend_books VALUES ('LG00155','B40COMI2020','Return');

INSERT INTO lend_books VALUES ('LB00156','B39NOVE2020','Return');
INSERT INTO lend_books VALUES ('LS00157','B32COMI2020','Return');
INSERT INTO lend_books VALUES ('LG00158','B38JOUR2019','Return');
INSERT INTO lend_books VALUES ('LB00159','B36TEEN2020','Return');
INSERT INTO lend_books VALUES ('LG00160','B37COMI2019','Return');

INSERT INTO lend_books VALUES ('LB00161','B1FANT1955','Return');
INSERT INTO lend_books VALUES ('LS00162','B2BIOG2004','Return');
INSERT INTO lend_books VALUES ('LB00163','B4COMI2012','Return');
INSERT INTO lend_books VALUES ('LS00164','B3HORR1986','Return');
INSERT INTO lend_books VALUES ('LG00165','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LS00166','B7SCFI1992','Return');
INSERT INTO lend_books VALUES ('LB00167','B6HLTH2005','Return');
INSERT INTO lend_books VALUES ('LG00168','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LS00169','B10CHLD1952','Return');
INSERT INTO lend_books VALUES ('LB00170','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LG00171','B11ROMC1813','Return');
INSERT INTO lend_books VALUES ('LB00172','B13NOVE2017','Loan');
INSERT INTO lend_books VALUES ('LS00173','B14POET2017','Return');
INSERT INTO lend_books VALUES ('LB00174','B15SPRT2012','Loan');
INSERT INTO lend_books VALUES ('LG00175','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LB00176','B19TEEN1962','Loan');
INSERT INTO lend_books VALUES ('LS00177','B12JOUR2014','Loan');
INSERT INTO lend_books VALUES ('LG00178','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LB00179','B16TEEN2017','Loan');
INSERT INTO lend_books VALUES ('LG00180','B17SOSC2018','Return');

INSERT INTO lend_books VALUES ('LB00181','B31NOVE2019','Loan');
INSERT INTO lend_books VALUES ('LS00182','B33COMI2017','Loan');
INSERT INTO lend_books VALUES ('LB00183','B34JOUR2020','Loan');
INSERT INTO lend_books VALUES ('LS00184','B35COMI2017','Loan');
INSERT INTO lend_books VALUES ('LG00185','B40COMI2020','Return');

INSERT INTO lend_books VALUES ('LS00186','B39NOVE2020','Loan');
INSERT INTO lend_books VALUES ('LB00187','B32COMI2020','Loan');
INSERT INTO lend_books VALUES ('LG00188','B38JOUR2019','Return');
INSERT INTO lend_books VALUES ('LS00189','B36TEEN2020','Loan');
INSERT INTO lend_books VALUES ('LB00190','B37COMI2019','Loan');

INSERT INTO lend_books VALUES ('LG00191','B1FANT1955','Return');
INSERT INTO lend_books VALUES ('LB00192','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LS00193','B4COMI2012','Return');
INSERT INTO lend_books VALUES ('LB00194','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00195','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LB00196','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LS00197','B6HLTH2005','Loan');
INSERT INTO lend_books VALUES ('LG00198','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LB00199','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LG00200','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LB00201','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LS00202','B13NOVE2017','Return');
INSERT INTO lend_books VALUES ('LB00203','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LS00204','B15SPRT2012','Return');
INSERT INTO lend_books VALUES ('LG00205','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LS00206','B19TEEN1962','Loan');
INSERT INTO lend_books VALUES ('LB00207','B12JOUR2014','Loan');
INSERT INTO lend_books VALUES ('LG00208','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LS00209','B16TEEN2017','Loan');
INSERT INTO lend_books VALUES ('LB00210','B17SOSC2018','Loan');

INSERT INTO lend_books VALUES ('LG00211','B21SCFI2010','Return');
INSERT INTO lend_books VALUES ('LB00212','B23NOVE2015','Loan');
INSERT INTO lend_books VALUES ('LS00213','B24ROMC1997','Return');
INSERT INTO lend_books VALUES ('LB00214','B25HORR2011','Loan');
INSERT INTO lend_books VALUES ('LG00215','B30COOK2017','Return');

INSERT INTO lend_books VALUES ('LB00216','B29COOK2019','Loan');
INSERT INTO lend_books VALUES ('LS00217','B22COMI2013','Loan');
INSERT INTO lend_books VALUES ('LG00218','B28TEEN2016','Return');
INSERT INTO lend_books VALUES ('LB00219','B26SCFI1999','Loan');
INSERT INTO lend_books VALUES ('LG00220','B27NOVE2019','Return');

INSERT INTO lend_books VALUES ('LB00221','B1FANT1955','Loan');
INSERT INTO lend_books VALUES ('LS00222','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LB00223','B4COMI2012','Loan');
INSERT INTO lend_books VALUES ('LS00224','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00225','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LS00226','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LB00227','B6HLTH2005','Loan');
INSERT INTO lend_books VALUES ('LG00228','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LS00229','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LB00230','B9EDUC2015','Loan');

INSERT INTO lend_books VALUES ('LG00231','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LB00232','B13NOVE2017','Loan');
INSERT INTO lend_books VALUES ('LS00233','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LB00234','B15SPRT2012','Loan');
INSERT INTO lend_books VALUES ('LG00235','B20SCMT2020','Loan');

INSERT INTO lend_books VALUES ('LB00236','B19TEEN1962','Loan');
INSERT INTO lend_books VALUES ('LS00237','B12JOUR2014','Loan');
INSERT INTO lend_books VALUES ('LG00238','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LB00239','B16TEEN2017','Loan');
INSERT INTO lend_books VALUES ('LG00240','B17SOSC2018','Loan');

INSERT INTO lend_books VALUES ('LB00241','B31NOVE2019','Loan');
INSERT INTO lend_books VALUES ('LS00242','B33COMI2017','Loan');
INSERT INTO lend_books VALUES ('LB00243','B34JOUR2020','Loan');
INSERT INTO lend_books VALUES ('LS00244','B35COMI2017','Loan');
INSERT INTO lend_books VALUES ('LG00245','B40COMI2020','Return');

INSERT INTO lend_books VALUES ('LS00246','B39NOVE2020','Return');
INSERT INTO lend_books VALUES ('LB00247','B32COMI2020','Loan');
INSERT INTO lend_books VALUES ('LG00248','B38JOUR2019','Return');
INSERT INTO lend_books VALUES ('LS00249','B36TEEN2020','Return');
INSERT INTO lend_books VALUES ('LB00250','B37COMI2019','Loan');

INSERT INTO lend_books VALUES ('LG00251','B1FANT1955','Return');
INSERT INTO lend_books VALUES ('LB00252','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LS00253','B4COMI2012','Loan');
INSERT INTO lend_books VALUES ('LB00254','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00255','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LB00256','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LS00257','B6HLTH2005','Loan');
INSERT INTO lend_books VALUES ('LG00258','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LB00259','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LG00260','B9EDUC2015','Return');

INSERT INTO lend_books VALUES ('LB00261','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LS00262','B13NOVE2017','Loan');
INSERT INTO lend_books VALUES ('LB00263','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LS00264','B15SPRT2012','Loan');
INSERT INTO lend_books VALUES ('LG00265','B20SCMT2020','Return');

INSERT INTO lend_books VALUES ('LS00266','B19TEEN1962','Loan');
INSERT INTO lend_books VALUES ('LB00267','B12JOUR2014','Loan');
INSERT INTO lend_books VALUES ('LG00268','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LS00269','B16TEEN2017','Loan');
INSERT INTO lend_books VALUES ('LB00270','B17SOSC2018','Loan');

INSERT INTO lend_books VALUES ('LG00271','B21SCFI2010','Return');
INSERT INTO lend_books VALUES ('LB00272','B23NOVE2015','Loan');
INSERT INTO lend_books VALUES ('LS00273','B24ROMC1997','Loan');
INSERT INTO lend_books VALUES ('LB00274','B25HORR2011','Loan');
INSERT INTO lend_books VALUES ('LG00275','B30COOK2017','Return');

INSERT INTO lend_books VALUES ('LB00276','B29COOK2019','Loan');
INSERT INTO lend_books VALUES ('LS00277','B22COMI2013','Loan');
INSERT INTO lend_books VALUES ('LG00278','B28TEEN2016','Return');
INSERT INTO lend_books VALUES ('LB00279','B26SCFI1999','Loan');
INSERT INTO lend_books VALUES ('LG00280','B27NOVE2019','Return');

INSERT INTO lend_books VALUES ('LB00281','B1FANT1955','Loan');
INSERT INTO lend_books VALUES ('LS00282','B2BIOG2004','Loan');
INSERT INTO lend_books VALUES ('LB00283','B4COMI2012','Loan');
INSERT INTO lend_books VALUES ('LS00284','B3HORR1986','Loan');
INSERT INTO lend_books VALUES ('LG00285','B5COOK2012','Return');

INSERT INTO lend_books VALUES ('LS00286','B7SCFI1992','Loan');
INSERT INTO lend_books VALUES ('LB00287','B6HLTH2005','Loan');
INSERT INTO lend_books VALUES ('LG00288','B8ADVT1851','Return');
INSERT INTO lend_books VALUES ('LS00289','B10CHLD1952','Loan');
INSERT INTO lend_books VALUES ('LB00290','B9EDUC2015','Loan');

INSERT INTO lend_books VALUES ('LG00291','B11ROMC1813','Loan');
INSERT INTO lend_books VALUES ('LB00292','B13NOVE2017','Loan');
INSERT INTO lend_books VALUES ('LS00293','B14POET2017','Loan');
INSERT INTO lend_books VALUES ('LB00294','B15SPRT2012','Loan');
INSERT INTO lend_books VALUES ('LG00295','B20SCMT2020','Loan');

INSERT INTO lend_books VALUES ('LB00296','B19TEEN1962','Loan');
INSERT INTO lend_books VALUES ('LS00297','B12JOUR2014','Loan');
INSERT INTO lend_books VALUES ('LG00298','B18HOBB2018','Return');
INSERT INTO lend_books VALUES ('LB00299','B16TEEN2017','Loan');
INSERT INTO lend_books VALUES ('LG00300','B17SOSC2018','Return');


--Book Return Table
INSERT INTO book_return VALUES ('R1001L', 'LB00001', 'S101M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Late', 5, 25.00);
INSERT INTO book_return VALUES ('R1002L', 'LS00002', 'S101M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1003L', 'LB00003', 'S101M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Late', 5, 25.00);
INSERT INTO book_return VALUES ('R1004L', 'LS00004', 'S101M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1005E', 'LG00005', 'S101M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1006L', 'LS00006', 'S102F', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1007L', 'LB00007', 'S102F', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 2, 'Late', 4, 40.00);
INSERT INTO book_return VALUES ('R1008E', 'LG00008', 'S102F', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1009L', 'LS00009', 'S102F', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 3, 'Late', 1, 15.00);
INSERT INTO book_return VALUES ('R1010L', 'LB00010', 'S102F', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Late', 4, 20.00);

INSERT INTO book_return VALUES ('R1011E', 'LG00011', 'S103M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1012L', 'LB00012', 'S103M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1013E', 'LS00013', 'S103M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1014L', 'LB00014', 'S103M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 2, 'Late', 3, 30.00);
INSERT INTO book_return VALUES ('R1015E', 'LG00015', 'S103M', TO_DATE('2020-03-26', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1016L', 'LB00016', 'S104M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 5, 'Late', 3, 75.00);
INSERT INTO book_return VALUES ('R1017E', 'LS00017', 'S104M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1018E', 'LG00018', 'S104M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1019L', 'LB00019', 'S104M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1020E', 'LG00020', 'S104M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1021E', 'LB00021', 'S105M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1022E', 'LS00022', 'S105M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1023E', 'LB00023', 'S105M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);
INSERT INTO book_return VALUES ('R1024L', 'LS00024', 'S105M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1025L', 'LG00025', 'S105M', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1026E', 'LS00026', 'S106F', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1027E', 'LB00027', 'S106F', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1028E', 'LG00028', 'S106F', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 6, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1029E', 'LS00029', 'S106F', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1030E', 'LB00030', 'S106F', TO_DATE('2020-03-27', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1031E', 'LG00031', 'S107F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1032E', 'LB00032', 'S107F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1033E', 'LS00033', 'S107F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1034E', 'LB00034', 'S107F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1035E', 'LG00035', 'S107F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1036E', 'LB00036', 'S108F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1037E', 'LS00037', 'S108F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1038E', 'LG00038', 'S108F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 6, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1039E', 'LB00039', 'S108F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1040E', 'LG00040', 'S108F', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1041E', 'LB00041', 'S109M', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1042E', 'LS00042', 'S109M', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1043E', 'LB00043', 'S109M', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1044E', 'LS00044', 'S109M', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1045E', 'LG00045', 'S109M', TO_DATE('2020-03-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1046E', 'LS00046', 'S110F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1047E', 'LB00047', 'S110F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1048E', 'LG00048', 'S110F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1049E', 'LS00049', 'S110F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1050E', 'LB00050', 'S110F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1051E', 'LG00051', 'S111F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1052E', 'LB00052', 'S111F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1053E', 'LS00053', 'S111F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1054E', 'LB00054', 'S111F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1055E', 'LG00055', 'S111F', TO_DATE('2020-03-29', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1056E', 'LB00056', 'S112F', TO_DATE('2020-03-30', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1057E', 'LS00057', 'S112F', TO_DATE('2020-03-30', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1058E', 'LG00058', 'S112F', TO_DATE('2020-03-30', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1059E', 'LB00059', 'S112F', TO_DATE('2020-03-30', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1060E', 'LG00060', 'S112F', TO_DATE('2020-03-30', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1061L', 'LB00061', 'S113M', TO_DATE('2020-04-15', 'YYYY-MM-DD'), 2, 'Late', 4, 40.00);
INSERT INTO book_return VALUES ('R1062L', 'LS00062', 'S113M', TO_DATE('2020-04-15', 'YYYY-MM-DD'), 4, 'Late', 1, 20.00);
INSERT INTO book_return VALUES ('R1063L', 'LB00063', 'S113M', TO_DATE('2020-04-15', 'YYYY-MM-DD'), 6, 'Late', 4, 120.00);
INSERT INTO book_return VALUES ('R1064L', 'LS00064', 'S113M', TO_DATE('2020-04-15', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1065E', 'LG00065', 'S113M', TO_DATE('2020-04-15', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1066L', 'LS00066', 'S114M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1067L', 'LB00067', 'S114M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 6, 'Late', 5, 150.00);
INSERT INTO book_return VALUES ('R1068E', 'LG00068', 'S114M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1069L', 'LS00069', 'S114M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1070L', 'LB00070', 'S114M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 1, 'Late', 5, 25.00);

INSERT INTO book_return VALUES ('R1071E', 'LG00071', 'S115M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1072L', 'LB00072', 'S115M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 1, 'Late', 4, 20.00);
INSERT INTO book_return VALUES ('R1073L', 'LS00073', 'S115M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 2, 'Late', 1, 10.00);
INSERT INTO book_return VALUES ('R1074L', 'LB00074', 'S115M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 1, 'Late', 4, 20.00);
INSERT INTO book_return VALUES ('R1075E', 'LG00075', 'S115M', TO_DATE('2020-04-17', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1076L', 'LB00076', 'S116M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 5, 'Late', 4, 80.00);
INSERT INTO book_return VALUES ('R1077L', 'LS00077', 'S116M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1078E', 'LG00078', 'S116M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1079L', 'LB00079', 'S116M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 1, 'Late', 4, 20.00);
INSERT INTO book_return VALUES ('R1080E', 'LG00080', 'S116M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1081L', 'LB00081', 'S117M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 3, 'Late', 3, 45.00);
INSERT INTO book_return VALUES ('R1082E', 'LS00082', 'S117M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1083L', 'LB00083', 'S117M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1084E', 'LS00084', 'S117M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1085E', 'LG00085', 'S117M', TO_DATE('2020-04-18', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1086E', 'LS00086', 'S118F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1087L', 'LB00087', 'S118F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 6, 'Late', 4, 120.00);
INSERT INTO book_return VALUES ('R1088E', 'LG00088', 'S118F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1089E', 'LS00089', 'S118F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 6, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1090L', 'LB00090', 'S118F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 2, 'Late', 4, 40.00);

INSERT INTO book_return VALUES ('R1091E', 'LG00091', 'S119F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1092L', 'LB00092', 'S119F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);
INSERT INTO book_return VALUES ('R1093E', 'LS00093', 'S119F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1094L', 'LB00094', 'S119F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);
INSERT INTO book_return VALUES ('R1095E', 'LG00095', 'S119F', TO_DATE('2020-04-19', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1096L', 'LB00096', 'S120F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1097E', 'LS00097', 'S120F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1098E', 'LG00098', 'S120F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1099L', 'LB00099', 'S120F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1100E', 'LG00100', 'S120F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1101L', 'LB00101', 'S105M', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Late', 1, 15.00);
INSERT INTO book_return VALUES ('R1102E', 'LS00102', 'S105M', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1103L', 'LB00103', 'S105M', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Late', 1, 15.00);
INSERT INTO book_return VALUES ('R1104E', 'LS00104', 'S105M', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1105E', 'LG00105', 'S105M', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1106E', 'LS00106', 'S108F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1107E', 'LB00107', 'S108F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 6, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1108E', 'LG00108', 'S108F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1109E', 'LS00109', 'S108F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1110E', 'LB00110', 'S108F', TO_DATE('2020-04-20', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1111E', 'LG00111', 'S116M', TO_DATE('2020-04-21', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1112E', 'LB00112', 'S116M', TO_DATE('2020-04-21', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1113E', 'LS00113', 'S116M', TO_DATE('2020-04-21', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1114E', 'LB00114', 'S116M', TO_DATE('2020-04-21', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1115E', 'LG00115', 'S116M', TO_DATE('2020-04-21', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1116E', 'LB00116', 'S113M', TO_DATE('2020-04-22', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1117E', 'LS00117', 'S113M', TO_DATE('2020-04-22', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1118E', 'LG00118', 'S113M', TO_DATE('2020-04-22', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1119E', 'LB00119', 'S113M', TO_DATE('2020-04-22', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1120E', 'LG00120', 'S113M', TO_DATE('2020-04-22', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1121L', 'LB00121', 'S120F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 5, 'Late', 3, 75.00);
INSERT INTO book_return VALUES ('R1122E', 'LS00122', 'S120F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1123L', 'LB00123', 'S120F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1124E', 'LS00124', 'S120F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1125E', 'LG00125', 'S120F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1126E', 'LS00126', 'S119F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1127L', 'LB00127', 'S119F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1128E', 'LG00128', 'S119F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1129E', 'LS00129', 'S119F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1130L', 'LB00130', 'S119F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);

INSERT INTO book_return VALUES ('R1131E', 'LG00131', 'S110F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1132L', 'LB00132', 'S110F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1133E', 'LS00133', 'S110F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1134L', 'LB00134', 'S110F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 1, 'Late', 1, 30.00);
INSERT INTO book_return VALUES ('R1135E', 'LG00135', 'S110F', TO_DATE('2020-05-24', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1136L', 'LB00136', 'S102F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 5, 'Late', 2, 50.00);
INSERT INTO book_return VALUES ('R1137E', 'LS00137', 'S102F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1138E', 'LG00138', 'S102F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1139L', 'LB00139', 'S102F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 4, 'Late', 2, 40.00);
INSERT INTO book_return VALUES ('R1140E', 'LG00140', 'S102F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1141L', 'LB00141', 'S114M', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1142E', 'LS00142', 'S114M', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1143L', 'LB00143', 'S114M', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);
INSERT INTO book_return VALUES ('R1144E', 'LS00144', 'S114M', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 2, 'Early', 0, 20.00);
INSERT INTO book_return VALUES ('R1145E', 'LG00145', 'S114M', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 3, 'Early', 0, 30.00);

INSERT INTO book_return VALUES ('R1146E', 'LS00146', 'S112F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1147E', 'LB00147', 'S112F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1148E', 'LG00148', 'S112F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 6, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1149E', 'LS00149', 'S112F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1150E', 'LB00150', 'S112F', TO_DATE('2020-05-26', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1151E', 'LG00151', 'S117M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1152L', 'LB00152', 'S117M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 2, 'Late', 1, 10.00);
INSERT INTO book_return VALUES ('R1153E', 'LS00153', 'S117M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1154L', 'LB00154', 'S117M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 2, 'Late', 1, 10.00);
INSERT INTO book_return VALUES ('R1155E', 'LG00155', 'S117M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1156E', 'LB00156', 'S118F', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1157E', 'LS00157', 'S118F', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1158E', 'LG00158', 'S118F', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 6, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1159E', 'LB00159', 'S118F', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1160E', 'LG00160', 'S118F', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1161E', 'LB00161', 'S101M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1162E', 'LS00162', 'S101M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1163E', 'LB00163', 'S101M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1164E', 'LS00164', 'S101M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1165E', 'LG00165', 'S101M', TO_DATE('2020-05-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1166E', 'LS00166', 'S111F', TO_DATE('2020-05-29', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1167E', 'LB00167', 'S111F', TO_DATE('2020-05-29', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1168E', 'LG00168', 'S111F', TO_DATE('2020-05-29', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1169E', 'LS00169', 'S111F', TO_DATE('2020-05-29', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1170E', 'LB00170', 'S111F', TO_DATE('2020-05-29', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1171E', 'LG00171', 'S115M', TO_DATE('2020-06-02', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1172L', 'LB00172', 'S115M', TO_DATE('2020-06-02', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1173E', 'LS00173', 'S115M', TO_DATE('2020-06-02', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1174L', 'LB00174', 'S115M', TO_DATE('2020-06-02', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1175E', 'LG00175', 'S115M', TO_DATE('2020-06-02', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1176L', 'LB00176', 'S103M', TO_DATE('2020-06-05', 'YYYY-MM-DD'), 4, 'Late', 4, 80.00);
INSERT INTO book_return VALUES ('R1177L', 'LS00177', 'S103M', TO_DATE('2020-06-05', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1178E', 'LG00178', 'S103M', TO_DATE('2020-06-05', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1179L', 'LB00179', 'S103M', TO_DATE('2020-06-05', 'YYYY-MM-DD'), 1, 'Late', 4, 20.00);
INSERT INTO book_return VALUES ('R1180E', 'LG00180', 'S103M', TO_DATE('2020-06-05', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1181L', 'LB00181', 'S106F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 5, 'Late', 5, 125.00);
INSERT INTO book_return VALUES ('R1182L', 'LS00182', 'S106F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 4, 'Late', 2, 40.00);
INSERT INTO book_return VALUES ('R1183L', 'LB00183', 'S106F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 6, 'Late', 5, 150.00);
INSERT INTO book_return VALUES ('R1184L', 'LS00184', 'S106F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 4, 'Late', 2, 40.00);
INSERT INTO book_return VALUES ('R1185E', 'LG00185', 'S106F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1186L', 'LS00186', 'S104M', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 3, 'Late', 1, 15.00);
INSERT INTO book_return VALUES ('R1187L', 'LB00187', 'S104M', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 3, 'Late', 3, 45.00);
INSERT INTO book_return VALUES ('R1188E', 'LG00188', 'S104M', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1189L', 'LS00189', 'S104M', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 3, 'Late', 1, 15.00);
INSERT INTO book_return VALUES ('R1190L', 'LB00190', 'S104M', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 3, 'Late', 3, 45.00);

INSERT INTO book_return VALUES ('R1191E', 'LG00191', 'S107F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1192L', 'LB00192', 'S107F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1193E', 'LS00193', 'S107F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1194L', 'LB00194', 'S107F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1195E', 'LG00195', 'S107F', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1196L', 'LB00196', 'S109M', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 3, 'Late', 4, 60.00);
INSERT INTO book_return VALUES ('R1197L', 'LS00197', 'S109M', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1198E', 'LG00198', 'S109M', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1199L', 'LB00199', 'S109M', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 1, 'Late', 4, 20.00);
INSERT INTO book_return VALUES ('R1200E', 'LG00200', 'S109M', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1201L', 'LB00201', 'S120F', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 4, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1202E', 'LS00202', 'S120F', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1203L', 'LB00203', 'S120F', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);
INSERT INTO book_return VALUES ('R1204E', 'LS00204', 'S120F', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1205E', 'LG00205', 'S120F', TO_DATE('2020-06-18', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1206L', 'LS00206', 'S116M', TO_DATE('2020-06-20', 'YYYY-MM-DD'), 4, 'Late', 1, 20.00);
INSERT INTO book_return VALUES ('R1207L', 'LB00207', 'S116M', TO_DATE('2020-06-20', 'YYYY-MM-DD'), 6, 'Late', 4, 120.00);
INSERT INTO book_return VALUES ('R1208E', 'LG00208', 'S116M', TO_DATE('2020-06-20', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1209L', 'LS00209', 'S116M', TO_DATE('2020-06-20', 'YYYY-MM-DD'), 6, 'Late', 1, 30.00);
INSERT INTO book_return VALUES ('R1210L', 'LB00210', 'S116M', TO_DATE('2020-06-20', 'YYYY-MM-DD'), 2, 'Late', 4, 40.00);

INSERT INTO book_return VALUES ('R1211E', 'LG00211', 'S117M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1212L', 'LB00212', 'S117M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1213E', 'LS00213', 'S117M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1214L', 'LB00214', 'S117M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1215E', 'LG00215', 'S117M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1216L', 'LB00216', 'S114M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 4, 'Late', 5, 100.00);
INSERT INTO book_return VALUES ('R1217L', 'LS00217', 'S114M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1218E', 'LG00218', 'S114M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1219L', 'LB00219', 'S114M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 3, 'Late', 5, 75.00);
INSERT INTO book_return VALUES ('R1220E', 'LG00220', 'S114M', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1221L', 'LB00221', 'S104M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 3, 'Late', 6, 90.00);
INSERT INTO book_return VALUES ('R1222L', 'LS00222', 'S104M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 4, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1223L', 'LB00223', 'S104M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1224L', 'LS00224', 'S104M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 4, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1225E', 'LG00225', 'S104M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1226L', 'LS00226', 'S113M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1227L', 'LB00227', 'S113M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 6, 'Late', 5, 150.00);
INSERT INTO book_return VALUES ('R1228E', 'LG00228', 'S113M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1229L', 'LS00229', 'S113M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1230L', 'LB00230', 'S113M', TO_DATE('2020-06-25', 'YYYY-MM-DD'), 1, 'Late', 5, 25.00);

INSERT INTO book_return VALUES ('R1231L', 'LG00231', 'S118F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1232L', 'LB00232', 'S118F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 3, 'Late', 7, 105.00);
INSERT INTO book_return VALUES ('R1233L', 'LS00233', 'S118F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 3, 'Late', 4, 60.00);
INSERT INTO book_return VALUES ('R1234L', 'LB00234', 'S118F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 2, 'Late', 2, 20.00);
INSERT INTO book_return VALUES ('R1235L', 'LG00235', 'S118F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);

INSERT INTO book_return VALUES ('R1236L', 'LB00236', 'S107F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 4, 'Late', 6, 120.00);
INSERT INTO book_return VALUES ('R1237L', 'LS00237', 'S107F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 4, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1238E', 'LG00238', 'S107F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1239L', 'LB00239', 'S107F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1240E', 'LG00240', 'S107F', TO_DATE('2020-06-28', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1241L', 'LB00241', 'S105M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 3, 'Late', 4, 60.00);
INSERT INTO book_return VALUES ('R1242L', 'LS00242', 'S105M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 3, 'Late', 1, 15.00);
INSERT INTO book_return VALUES ('R1243L', 'LB00243', 'S105M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 2, 'Late', 4, 40.00);
INSERT INTO book_return VALUES ('R1244L', 'LS00244', 'S105M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 2, 'Late', 1, 10.00);
INSERT INTO book_return VALUES ('R1245E', 'LG00245', 'S105M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1246E', 'LS00246', 'S103M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1247L', 'LB00247', 'S103M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 4, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1248E', 'LG00248', 'S103M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1249E', 'LS00249', 'S103M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1250L', 'LB00250', 'S103M', TO_DATE('2020-07-15', 'YYYY-MM-DD'), 1, 'Late', 3, 15.00);

INSERT INTO book_return VALUES ('R1251E', 'LG00251', 'S108F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1252L', 'LB00252', 'S108F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 5, 'Late', 6, 150.00);
INSERT INTO book_return VALUES ('R1253L', 'LS00253', 'S108F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 3, 'Late', 3, 45.00);
INSERT INTO book_return VALUES ('R1254L', 'LB00254', 'S108F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 2, 'Late', 6, 60.00);
INSERT INTO book_return VALUES ('R1255E', 'LG00255', 'S108F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1256L', 'LB00256', 'S111F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 3, 'Late', 5, 75.00);
INSERT INTO book_return VALUES ('R1257L', 'LS00257', 'S111F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);
INSERT INTO book_return VALUES ('R1258E', 'LG00258', 'S111F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1259L', 'LB00259', 'S111F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 2, 'Late', 5, 50.00);
INSERT INTO book_return VALUES ('R1260E', 'LG00260', 'S111F', TO_DATE('2020-07-19', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1261L', 'LB00261', 'S102F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 3, 'Late', 5, 75.00);
INSERT INTO book_return VALUES ('R1262L', 'LS00262', 'S102F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1263L', 'LB00263', 'S102F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 1, 'Late', 5, 25.00);
INSERT INTO book_return VALUES ('R1264L', 'LS00264', 'S102F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 1, 'Late', 2, 10.00);
INSERT INTO book_return VALUES ('R1265E', 'LG00265', 'S102F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1266L', 'LS00266', 'S119F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 2, 'Late', 1, 10.00);
INSERT INTO book_return VALUES ('R1267L', 'LB00267', 'S119F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 4, 'Late', 4, 80.00);
INSERT INTO book_return VALUES ('R1268E', 'LG00268', 'S119F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1269L', 'LS00269', 'S119F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 6, 'Late', 1, 30.00);
INSERT INTO book_return VALUES ('R1270L', 'LB00270', 'S119F', TO_DATE('2020-07-20', 'YYYY-MM-DD'), 2, 'Late', 4, 40.00);

INSERT INTO book_return VALUES ('R1271E', 'LG00271', 'S106F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 3, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1272L', 'LB00272', 'S106F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1273L', 'LS00273', 'S106F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 2, 'Late', 3, 30.00);
INSERT INTO book_return VALUES ('R1274L', 'LB00274', 'S106F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 2, 'Late', 6, 60.00);
INSERT INTO book_return VALUES ('R1275E', 'LG00275', 'S106F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 5, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1276L', 'LB00276', 'S110F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 4, 'Late', 5, 100.00);
INSERT INTO book_return VALUES ('R1277L', 'LS00277', 'S110F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1278E', 'LG00278', 'S110F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 4, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1279L', 'LB00279', 'S110F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 5, 'Late', 5, 125.00);
INSERT INTO book_return VALUES ('R1280E', 'LG00280', 'S110F', TO_DATE('2020-07-23', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1281L', 'LB00281', 'S115M', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 3, 'Late', 6, 90.00);
INSERT INTO book_return VALUES ('R1282L', 'LS00282', 'S115M', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 4, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1283L', 'LB00283', 'S115M', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1284L', 'LS00284', 'S115M', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 2, 'Late', 3, 60.00);
INSERT INTO book_return VALUES ('R1285E', 'LG00285', 'S115M', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 1, 'Early', 0, 0.00);

INSERT INTO book_return VALUES ('R1286L', 'LS00286', 'S112F', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1287L', 'LB00287', 'S112F', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 6, 'Late', 5, 150.00);
INSERT INTO book_return VALUES ('R1288E', 'LG00288', 'S112F', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1289L', 'LS00289', 'S112F', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 3, 'Late', 2, 30.00);
INSERT INTO book_return VALUES ('R1290L', 'LB00290', 'S112F', TO_DATE('2020-07-25', 'YYYY-MM-DD'), 1, 'Late', 5, 25.00);

INSERT INTO book_return VALUES ('R1291L', 'LG00291', 'S101M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);
INSERT INTO book_return VALUES ('R1292L', 'LB00292', 'S101M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 3, 'Late', 7, 105.00);
INSERT INTO book_return VALUES ('R1293L', 'LS00293', 'S101M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 3, 'Late', 4, 60.00);
INSERT INTO book_return VALUES ('R1294L', 'LB00294', 'S101M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 2, 'Late', 7, 70.00);
INSERT INTO book_return VALUES ('R1295L', 'LG00295', 'S101M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 1, 'Late', 1, 5.00);

INSERT INTO book_return VALUES ('R1296L', 'LB00296', 'S109M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 4, 'Late', 6, 120.00);
INSERT INTO book_return VALUES ('R1297L', 'LS00297', 'S109M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 2, 'Late', 3, 30.00);
INSERT INTO book_return VALUES ('R1298E', 'LG00298', 'S109M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);
INSERT INTO book_return VALUES ('R1299L', 'LB00299', 'S109M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 1, 'Late', 6, 30.00);
INSERT INTO book_return VALUES ('R1300E', 'LG00300', 'S109M', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 2, 'Early', 0, 0.00);


--Payment Table
INSERT INTO payment VALUES ('P1-03-20','S113M','M101BR',TO_DATE('2020-03-21','YYYY-MM-DD'),NULL,'200321-M1-82','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P2-03-20','S108F','M115GD',TO_DATE('2020-03-22','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','credit card','50.00');
INSERT INTO payment VALUES ('P3-03-20','S106F','M114BR',TO_DATE('2020-03-22','YYYY-MM-DD'),NULL,'200322-M1-85','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P4-03-20','S103M','M116BR',TO_DATE('2020-03-23','YYYY-MM-DD'),NULL,'200323-M3-88','meeting room','cash','50.00');
INSERT INTO payment VALUES ('P5-03-20','S111F','M110BR',TO_DATE('2020-03-24','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P6-03-20','S116M','M110BR',TO_DATE('2020-03-24','YYYY-MM-DD'),NULL,'200324-M1-93','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P7-03-20','S105M','M108GD',TO_DATE('2020-03-25','YYYY-MM-DD'),NULL,'200325-M1-96','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P8-03-20','S105M','M109SV',TO_DATE('2020-03-25','YYYY-MM-DD'),NULL,'200325-M1-98','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P9-03-20','S105M','M105GD',TO_DATE('2020-03-25','YYYY-MM-DD'),NULL,'200325-M1-99','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P10-03-20','S107F','M117SV',TO_DATE('2020-03-26','YYYY-MM-DD'),NULL,'200326-M2-103','meeting room','cash','17.50');

INSERT INTO payment VALUES ('P11-03-20','S101M','M101BR',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1001L',NULL,'fine book','cash','25.00');
INSERT INTO payment VALUES ('P12-03-20','S101M','M102SV',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1002L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P13-03-20','S101M','M103BR',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1003L',NULL,'fine book','cash','25.00');
INSERT INTO payment VALUES ('P14-03-20','S102F','M104SV',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1004L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P15-03-20','S102F','M106SV',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1006L',NULL,'fine book','cash','5.00');

INSERT INTO payment VALUES ('P16-03-20','S102F','M107BR',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1007L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P17-03-20','S102F','M109SV',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1009L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P18-03-20','S102F','M110BR',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1010L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P19-03-20','S102F','M112BR',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1012L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P20-03-20','S102F','M114BR',TO_DATE('2020-03-26','YYYY-MM-DD'),'R1014L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P21-03-20','S104M','M116BR',TO_DATE('2020-03-27','YYYY-MM-DD'),'R1016L',NULL,'fine book','cash','75.00');
INSERT INTO payment VALUES ('P22-03-20','S104M','M119BR',TO_DATE('2020-03-27','YYYY-MM-DD'),'R1019L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P23-03-20','S104M','M101BR',TO_DATE('2020-03-27','YYYY-MM-DD'),'R1021E',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P24-03-20','S104M','M103BR',TO_DATE('2020-03-27','YYYY-MM-DD'),'R1023E',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P25-03-20','S117M','M116BR',TO_DATE('2020-03-27','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','credit card','30.00');

INSERT INTO payment VALUES ('P26-03-20','S112F','M107BR',TO_DATE('2020-03-27','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P27-03-20','S118F','M102SV',TO_DATE('2020-03-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P28-03-20','S119F','M103BR',TO_DATE('2020-03-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P29-03-20','S119F','M119BR',TO_DATE('2020-03-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P30-03-20','S112F','M110BR',TO_DATE('2020-03-30','YYYY-MM-DD'),NULL,'200329-M2-112','meeting room','cash','35.00');

INSERT INTO payment VALUES ('P31-03-20','S101M','M116BR',TO_DATE('2020-03-30','YYYY-MM-DD'),NULL,'200330-M2-122','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P32-04-20','S102F','M109SV',TO_DATE('2020-04-01','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','credit card','40.00');
INSERT INTO payment VALUES ('P33-04-20','S101M','M102SV',TO_DATE('2020-04-02','YYYY-MM-DD'),NULL,'200402-M3-130','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P34-04-20','S120F','M108GD',TO_DATE('2020-04-02','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','credit card','50.00');
INSERT INTO payment VALUES ('P35-04-20','S118F','M108GD',TO_DATE('2020-04-03','YYYY-MM-DD'),NULL,'200403-M3-136','meeting room','cash','50.00');

INSERT INTO payment VALUES ('P36-04-20','S118F','M101BR',TO_DATE('2020-04-03','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P37-04-20','S120F','M115GD',TO_DATE('2020-04-04','YYYY-MM-DD'),NULL,'200404-M1-139','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P38-04-20','S120F','M112BR',TO_DATE('2020-04-04','YYYY-MM-DD'),NULL,'200404-M1-140','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P39-04-20','S102F','M106SV',TO_DATE('2020-04-05','YYYY-MM-DD'),NULL,'200405-M1-143','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P40-04-20','S101M','M101BR',TO_DATE('2020-04-05','YYYY-MM-DD'),NULL,'200405-M3-146','meeting room','cash','50.00');

INSERT INTO payment VALUES ('P41-04-20','S116M','M104SV',TO_DATE('2020-04-06','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P42-04-20','S116M','M114BR',TO_DATE('2020-04-06','YYYY-MM-DD'),NULL,'200406-M1-148','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P43-04-20','S101M','M104SV',TO_DATE('2020-04-07','YYYY-MM-DD'),NULL,'200407-M2-152','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P44-04-20','S102F','M105GD',TO_DATE('2020-04-07','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P45-04-20','S105M','M111GD',TO_DATE('2020-04-08','YYYY-MM-DD'),NULL,'200408-M2-159','meeting room','cash','17.50');

INSERT INTO payment VALUES ('P46-04-20','S112F','M105GD',TO_DATE('2020-04-09','YYYY-MM-DD'),NULL,'200409-M1-164','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P47-04-20','S115M','M101BR',TO_DATE('2020-04-10','YYYY-MM-DD'),NULL,'200410-M3-167','meeting room','cash','50.00');
INSERT INTO payment VALUES ('P48-04-20','S115M','M112BR',TO_DATE('2020-04-10','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P49-04-20','S103M','M106SV',TO_DATE('2020-04-11','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P50-04-20','S114M','M118GD',TO_DATE('2020-04-12','YYYY-MM-DD'),NULL,'200412-M1-172','meeting room','cash','25.00');

INSERT INTO payment VALUES ('P51-04-20','S114M','M111GD',TO_DATE('2020-04-12','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P52-04-20','S102F','M110BR',TO_DATE('2020-04-13','YYYY-MM-DD'),NULL,'200413-M1-179','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P53-04-20','S101M','M113SV',TO_DATE('2020-04-13','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P54-04-20','S105M','M115GD',TO_DATE('2020-04-14','YYYY-MM-DD'),NULL,'200414-M1-181','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P55-04-20','S105M','M113SV',TO_DATE('2020-04-14','YYYY-MM-DD'),NULL,'200414-M2-182','meeting room','cash','17.50');

INSERT INTO payment VALUES ('P56-04-20','S112F','M101BR',TO_DATE('2020-04-15','YYYY-MM-DD'),'R1061L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P57-04-20','S102F','M102SV',TO_DATE('2020-04-15','YYYY-MM-DD'),'R1062L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P58-04-20','S103M','M103BR',TO_DATE('2020-04-15','YYYY-MM-DD'),'R1063L',NULL,'fine book','cash','120.00');
INSERT INTO payment VALUES ('P59-04-20','S102F','M114BR',TO_DATE('2020-04-16','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P60-04-20','S114M','M106SV',TO_DATE('2020-04-17','YYYY-MM-DD'),'R1066L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P61-04-20','S114M','M107BR',TO_DATE('2020-04-17','YYYY-MM-DD'),'R1067L',NULL,'fine book','credit card','150.00');
INSERT INTO payment VALUES ('P62-04-20','S102F','M109SV',TO_DATE('2020-04-17','YYYY-MM-DD'),'R1069L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P63-04-20','S116M','M116BR',TO_DATE('2020-04-18','YYYY-MM-DD'),'R1076L',NULL,'fine book','cash','80.00');
INSERT INTO payment VALUES ('P64-04-20','S116M','M119BR',TO_DATE('2020-04-18','YYYY-MM-DD'),'R1079L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P65-04-20','S105M','M101BR',TO_DATE('2020-04-18','YYYY-MM-DD'),NULL,'200418-M2-204','meeting room','cash','17.50');

INSERT INTO payment VALUES ('P66-04-20','S118F','M107BR',TO_DATE('2020-04-19','YYYY-MM-DD'),'R1087L',NULL,'fine book','cash','120.00');
INSERT INTO payment VALUES ('P67-04-20','S118F','M117SV',TO_DATE('2020-04-19','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','credit card','40.00');
INSERT INTO payment VALUES ('P68-04-20','S105M','M113SV',TO_DATE('2020-04-20','YYYY-MM-DD'),NULL,'200420-M3-212','meeting room','cash','120.00');
INSERT INTO payment VALUES ('P69-04-20','S105M','M118GD',TO_DATE('2020-04-20','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P70-04-20','S111F','M111GD',TO_DATE('2020-04-23','YYYY-MM-DD'),NULL,'200423-M2-221','meeting room','cash','35.00');

INSERT INTO payment VALUES ('P71-04-20','S104M','M102SV',TO_DATE('2020-04-25','YYYY-MM-DD'),NULL,'200425-M1-231','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P72-04-20','S104M','M103BR',TO_DATE('2020-04-25','YYYY-MM-DD'),NULL,'200425-M1-232','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P73-04-20','S109M','M117SV',TO_DATE('2020-04-26','YYYY-MM-DD'),NULL,'200426-M2-237','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P74-04-20','S110F','M106SV',TO_DATE('2020-04-27','YYYY-MM-DD'),NULL,'200427-M2-240','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P75-04-20','S117M','M115GD',TO_DATE('2020-04-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');

INSERT INTO payment VALUES ('P76-04-20','S115M','M115GD',TO_DATE('2020-04-28','YYYY-MM-DD'),NULL,'200428-M2-241','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P77-04-20','S104M','M101BR',TO_DATE('2020-04-29','YYYY-MM-DD'),NULL,'200429-M1-246','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P78-04-20','S104M','M110BR',TO_DATE('2020-04-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P79-04-20','S116M','M113SV',TO_DATE('2020-04-30','YYYY-MM-DD'),NULL,'200430-M2-251','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P80-04-20','S116M','M116BR',TO_DATE('2020-04-30','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P81-05-20','S115M','M107BR',TO_DATE('2020-05-02','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P82-05-20','S107F','M109SV',TO_DATE('2020-05-03','YYYY-MM-DD'),NULL,'200503-M3-261','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P83-05-20','S104M','M113SV',TO_DATE('2020-05-04','YYYY-MM-DD'),NULL,'200504-M3-269','meeting room','cash','50.00');
INSERT INTO payment VALUES ('P84-05-20','S110F','M102SV',TO_DATE('2020-05-05','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P85-05-20','S117M','M103BR',TO_DATE('2020-05-05','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P86-05-20','S113M','M112BR',TO_DATE('2020-05-07','YYYY-MM-DD'),NULL,'200507-M1-278','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P87-05-20','S104M','M104SV',TO_DATE('2020-05-08','YYYY-MM-DD'),NULL,'200508-M2-285','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P88-05-20','S108F','M108GD',TO_DATE('2020-05-09','YYYY-MM-DD'),NULL,'200509-M1-288','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P89-05-20','S118F','M116BR',TO_DATE('2020-05-10','YYYY-MM-DD'),NULL,'200510-M2-293','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P90-05-20','S116M','M119BR',TO_DATE('2020-05-11','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P91-05-20','S115M','M109SV',TO_DATE('2020-05-12','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P92-05-20','S113M','M109SV',TO_DATE('2020-05-03','YYYY-MM-DD'),NULL,'200511-M1-298','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P93-05-20','S107F','M103BR',TO_DATE('2020-05-13','YYYY-MM-DD'),NULL,'200513-M1-304','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P94-05-20','S120F','M113SV',TO_DATE('2020-05-13','YYYY-MM-DD'),NULL,'200513-M2-306','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P95-05-20','S107F','M111GD',TO_DATE('2020-05-15','YYYY-MM-DD'),NULL,'200515-M1-312','meeting room','cash','25.00');

INSERT INTO payment VALUES ('P96-05-20','S103M','M108GD',TO_DATE('2020-05-17','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P97-05-20','S103M','M101BR',TO_DATE('2020-05-17','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P98-05-20','S113M','M107BR',TO_DATE('2020-05-18','YYYY-MM-DD'),NULL,'200518-M1-325','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P99-05-20','S111F','M115GD',TO_DATE('2020-05-19','YYYY-MM-DD'),NULL,'200519-M1-332','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P100-05-20','S115M','M104SV',TO_DATE('2020-05-21','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');

INSERT INTO payment VALUES ('P101-05-20','S115M','M105GD',TO_DATE('2020-05-21','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P102-05-20','S120F','M110BR',TO_DATE('2020-05-22','YYYY-MM-DD'),NULL,'200522-M2-345','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P103-05-20','S108F','M112BR',TO_DATE('2020-05-23','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P104-05-20','S106F','M119BR',TO_DATE('2020-05-25','YYYY-MM-DD'),NULL,'200525-M1-357','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P105-05-20','S106F','M106SV',TO_DATE('2020-05-25','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');

INSERT INTO payment VALUES ('P106-05-20','S102F','M116BR',TO_DATE('2020-05-26','YYYY-MM-DD'),'R1136L',NULL,'fine book','cash','50.00');
INSERT INTO payment VALUES ('P107-05-20','S102F','M119BR',TO_DATE('2020-05-26','YYYY-MM-DD'),'R1139L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P108-05-20','S114M','M101BR',TO_DATE('2020-05-26','YYYY-MM-DD'),'R1141L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P109-05-20','S114M','M106SV',TO_DATE('2020-05-26','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P110-05-20','S114M','M103BR',TO_DATE('2020-05-26','YYYY-MM-DD'),'R1143L',NULL,'fine book','cash','10.00');

INSERT INTO payment VALUES ('P111-05-20','S114M','M104SV',TO_DATE('2020-05-26','YYYY-MM-DD'),'R1144E',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P112-05-20','S114M','M105GD',TO_DATE('2020-05-26','YYYY-MM-DD'),'R1145E',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P113-05-20','S117M','M112BR',TO_DATE('2020-05-28','YYYY-MM-DD'),'R1152L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P114-05-20','S117M','M114BR',TO_DATE('2020-05-28','YYYY-MM-DD'),'R1154L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P115-05-20','S106F','M111GD',TO_DATE('2020-05-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');

INSERT INTO payment VALUES ('P116-05-20','S107F','M108GD',TO_DATE('2020-05-29','YYYY-MM-DD'),NULL,'200529-M1-372','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P117-05-20','S110F','M106SV',TO_DATE('2020-05-30','YYYY-MM-DD'),NULL,'200530-M3-375','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P118-05-20','S103M','M113SV',TO_DATE('2020-05-31','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P119-05-20','S103M','M114BR',TO_DATE('2020-05-31','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P120-05-20','S117M','M101BR',TO_DATE('2020-05-31','YYYY-MM-DD'),NULL,'200531-M3-379','meeting room','cash','50.00');

INSERT INTO payment VALUES ('P121-06-20','S115M','M112BR',TO_DATE('2020-06-02','YYYY-MM-DD'),'R1172L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P122-06-20','S115M','M114BR',TO_DATE('2020-06-02','YYYY-MM-DD'),'R1174L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P123-06-20','S113M','M104SV',TO_DATE('2020-06-03','YYYY-MM-DD'),NULL,'200603-M2-393','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P124-06-20','S103M','M116BR',TO_DATE('2020-06-05','YYYY-MM-DD'),'R1176L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P125-06-20','S103M','M117SV',TO_DATE('2020-06-05','YYYY-MM-DD'),'R1177L',NULL,'fine book','cash','50.00');

INSERT INTO payment VALUES ('P126-06-20','S112F','M112BR',TO_DATE('2020-06-05','YYYY-MM-DD'),NULL,'200605-M1-399','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P127-06-20','S103M','M119BR',TO_DATE('2020-06-05','YYYY-MM-DD'),'R1179L',NULL,'fine book','cash','25.00');
INSERT INTO payment VALUES ('P128-06-20','S115M','M120GD',TO_DATE('2020-06-05','YYYY-MM-DD'),NULL,'200605-M1-402','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P129-06-20','S109M','M120GD',TO_DATE('2020-06-06','YYYY-MM-DD'),NULL,'200606-M1-407','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P130-06-20','S110F','M111GD',TO_DATE('2020-06-06','YYYY-MM-DD'),NULL,'200606-M1-408','meeting room','cash','12.50');

INSERT INTO payment VALUES ('P131-06-20','S115M','M117SV',TO_DATE('2020-06-08','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P132-06-20','S115M','M118GD',TO_DATE('2020-06-08','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P133-06-20','S101M','M106SV',TO_DATE('2020-06-09','YYYY-MM-DD'),NULL,'200609-M1-417','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P134-06-20','S103M','M110BR',TO_DATE('2020-06-10','YYYY-MM-DD'),NULL,'200610-M1-422','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P135-06-20','S103M','M115GD',TO_DATE('2020-06-10','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');

INSERT INTO payment VALUES ('P136-06-20','S109M','M118GD',TO_DATE('2020-06-11','YYYY-MM-DD'),NULL,'200611-M2-426','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P137-06-20','S106F','M101BR',TO_DATE('2020-06-13','YYYY-MM-DD'),NULL,'200613-M1-437','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P138-06-20','S112F','M110BR',TO_DATE('2020-06-13','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P139-06-20','S109M','M116BR',TO_DATE('2020-06-14','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P140-06-20','S109M','M107BR',TO_DATE('2020-06-14','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P141-06-20','S109M','M102SV',TO_DATE('2020-06-14','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P142-06-20','S103M','M103BR',TO_DATE('2020-06-15','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P143-06-20','S106F','M116BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1181L',NULL,'fine book','cash','125.00');
INSERT INTO payment VALUES ('P144-06-20','S106F','M117SV',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1182L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P145-06-20','S106F','M118GD',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1183L',NULL,'fine book','cash','150.00');

INSERT INTO payment VALUES ('P146-06-20','S106F','M119BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1184L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P147-06-20','S104M','M101BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1186L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P148-06-20','S106F','M107BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1187L',NULL,'fine book','cash','45.00');
INSERT INTO payment VALUES ('P149-06-20','S106F','M109SV',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1189L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P150-06-20','S106F','M110BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1190L',NULL,'fine book','cash','45.00');

INSERT INTO payment VALUES ('P151-06-20','S104M','M112BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1192L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P152-06-20','S104M','M114BR',TO_DATE('2020-06-16','YYYY-MM-DD'),'R1194L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P153-06-20','S119F','M119BR',TO_DATE('2020-06-16','YYYY-MM-DD'),NULL,'200616-M1-450','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P154-06-20','S103M','M119BR',TO_DATE('2020-06-17','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P155-06-20','S103M','M109SV',TO_DATE('2020-06-17','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');

INSERT INTO payment VALUES ('P156-06-20','S109M','M108GD',TO_DATE('2020-06-17','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P157-06-20','S106F','M104SV',TO_DATE('2020-06-17','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P158-06-20','S109M','M116BR',TO_DATE('2020-06-18','YYYY-MM-DD'),'R1196L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P159-06-20','S109M','M117SV',TO_DATE('2020-06-18','YYYY-MM-DD'),'R1197L',NULL,'fine book','cash','5.00');
INSERT INTO payment VALUES ('P160-06-20','S109M','M119BR',TO_DATE('2020-06-18','YYYY-MM-DD'),'R1199L',NULL,'fine book','cash','20.00');

INSERT INTO payment VALUES ('P161-06-20','S120F','M101BR',TO_DATE('2020-06-18','YYYY-MM-DD'),'R1201L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P162-06-20','S120F','M103BR',TO_DATE('2020-06-18','YYYY-MM-DD'),'R1203L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P163-06-20','S116M','M106SV',TO_DATE('2020-06-20','YYYY-MM-DD'),'R1206L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P164-06-20','S116M','M107BR',TO_DATE('2020-06-20','YYYY-MM-DD'),'R1207L',NULL,'fine book','cash','120.00');
INSERT INTO payment VALUES ('P165-06-20','S116M','M109SV',TO_DATE('2020-06-20','YYYY-MM-DD'),'R1209L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P166-06-20','S116M','M110BR',TO_DATE('2020-06-20','YYYY-MM-DD'),'R1210L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P167-06-20','S104M','M105GD',TO_DATE('2020-06-21','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P168-06-20','S117M','M112BR',TO_DATE('2020-06-23','YYYY-MM-DD'),'R1212L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P169-06-20','S117M','M114BR',TO_DATE('2020-06-23','YYYY-MM-DD'),'R1214L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P170-06-20','S114M','M116BR',TO_DATE('2020-06-23','YYYY-MM-DD'),'R1216L',NULL,'fine book','cash','100.00');

INSERT INTO payment VALUES ('P171-06-20','S114M','M117SV',TO_DATE('2020-06-23','YYYY-MM-DD'),'R1217L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P172-06-20','S114M','M119BR',TO_DATE('2020-06-23','YYYY-MM-DD'),'R1219L',NULL,'fine book','cash','75.00');
INSERT INTO payment VALUES ('P173-06-20','S104M','M112BR',TO_DATE('2020-06-25','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P174-06-20','S104M','M106SV',TO_DATE('2020-06-25','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P175-06-20','S104M','M101BR',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1221L',NULL,'fine book','cash','90.00');

INSERT INTO payment VALUES ('P176-06-20','S104M','M102SV',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1222L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P177-06-20','S104M','M103BR',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1223L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P178-06-20','S113M','M104SV',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1224L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P179-06-20','S113M','M106SV',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1226L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P180-20','S113M','M107BR',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1227L',NULL,'fine book','cash','150.00');

INSERT INTO payment VALUES ('P181-06-20','S113M','M109SV',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1229L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P182-06-20','S113M','M110BR',TO_DATE('2020-06-25','YYYY-MM-DD'),'R1230L',NULL,'fine book','cash','25.00');
INSERT INTO payment VALUES ('P183-06-20','S119F','M120GD',TO_DATE('2020-06-25','YYYY-MM-DD'),NULL,'200625-M1-482','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P184-06-20','S108F','M120GD',TO_DATE('2020-06-26','YYYY-MM-DD'),NULL,'200626-M3-485','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P185-06-20','S105M','M120GD',TO_DATE('2020-06-26','YYYY-MM-DD'),NULL,'200626-M3-488','meeting room','cash','25.00');

INSERT INTO payment VALUES ('P186-06-20','S105M','M118GD',TO_DATE('2020-06-26','YYYY-MM-DD'),NULL,'200627-M2-489','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P187-06-20','S105M','M103BR',TO_DATE('2020-06-26','YYYY-MM-DD'),NULL,'200627-M1-490','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P188-06-20','S118F','M111GD',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1231L',NULL,'fine book','cash','5.00');
INSERT INTO payment VALUES ('P189-06-20','S118F','M112BR',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1232L',NULL,'fine book','cash','105.00');
INSERT INTO payment VALUES ('P190-06-20','S118F','M113SV',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1233L',NULL,'fine book','cash','60.00');

INSERT INTO payment VALUES ('P191-06-20','S118F','M114BR',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1234L',NULL,'fine book','cash','20.00');
INSERT INTO payment VALUES ('P192-06-20','S118F','M115GD',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1235L',NULL,'fine book','cash','5.00');
INSERT INTO payment VALUES ('P193-06-20','S107F','M119BR',TO_DATE('2020-06-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P194-06-20','S107F','M109SV',TO_DATE('2020-06-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P195-06-20','S107F','M116BR',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1236L',NULL,'fine book','cash','120.00');

INSERT INTO payment VALUES ('P196-06-20','S107F','M117SV',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1237L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P197-06-20','S107F','M119BR',TO_DATE('2020-06-28','YYYY-MM-DD'),'R1239L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P198-06-20','S115M','M106SV',TO_DATE('2020-06-29','YYYY-MM-DD'),NULL,'200629-M1-495','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P199-06-20','S115M','M120GD',TO_DATE('2020-06-29','YYYY-MM-DD'),NULL,'200629-M1-497','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P200-06-20','S115M','M120GD',TO_DATE('2020-06-29','YYYY-MM-DD'),NULL,'200629-M1-498','meeting room','cash','12.50');

INSERT INTO payment VALUES ('P201-06-20','S106F','M111GD',TO_DATE('2020-06-30','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P202-06-20','S106F','M113SV',TO_DATE('2020-06-30','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P203-07-20','S102F','M114BR',TO_DATE('2020-07-01','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P204-07-20','S102F','M113SV',TO_DATE('2020-07-01','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P205-07-20','S102F','M101BR',TO_DATE('2020-07-01','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P206-07-20','S102F','M120GD',TO_DATE('2020-07-01','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P207-07-20','S120F','M114BR',TO_DATE('2020-07-01','YYYY-MM-DD'),NULL,'200701-M2-505','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P208-07-20','S112F','M102SV',TO_DATE('2020-07-02','YYYY-MM-DD'),NULL,'200702-M2-508','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P209-07-20','S111F','M106SV',TO_DATE('2020-07-03','YYYY-MM-DD'),NULL,'200703-M1-510','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P210-07-20','S111F','M118GD',TO_DATE('2020-07-03','YYYY-MM-DD'),NULL,'200703-M1-511','meeting room','cash','25.00');

INSERT INTO payment VALUES ('P211-07-20','S111F','M106SV',TO_DATE('2020-07-03','YYYY-MM-DD'),NULL,'200703-M1-514','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P212-07-20','S105M','M103BR',TO_DATE('2020-07-04','YYYY-MM-DD'),NULL,'200704-M2-516','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P213-07-20','S105M','M103BR',TO_DATE('2020-07-04','YYYY-MM-DD'),NULL,'200704-M2-516','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P214-07-20','S111F','M111GD',TO_DATE('2020-07-04','YYYY-MM-DD'),NULL,'200704-M1-518','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P215-07-20','S111F','M107BR',TO_DATE('2020-07-05','YYYY-MM-DD'),NULL,'200705-M2-520','meeting room','cash','17.50');

INSERT INTO payment VALUES ('P216-07-20','S111F','M118GD',TO_DATE('2020-07-08','YYYY-MM-DD'),NULL,'200708-M2-531','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P217-07-20','S105M','M108GD',TO_DATE('2020-07-09','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P218-07-20','S105M','M101BR',TO_DATE('2020-07-15','YYYY-MM-DD'),'R1241L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P219-07-20','S105M','M102SV',TO_DATE('2020-07-15','YYYY-MM-DD'),'R1242L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P220-07-20','S105M','M103BR',TO_DATE('2020-07-15','YYYY-MM-DD'),'R1243L',NULL,'fine book','cash','40.00');

INSERT INTO payment VALUES ('P221-07-20','S105M','M104SV',TO_DATE('2020-07-15','YYYY-MM-DD'),'R1244L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P222-07-20','S105M','M105GD',TO_DATE('2020-07-15','YYYY-MM-DD'),'R1247L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P223-07-20','S105M','M110BR',TO_DATE('2020-07-15','YYYY-MM-DD'),'R1250L',NULL,'fine book','cash','15.00');
INSERT INTO payment VALUES ('P224-07-20','S119F','M106SV',TO_DATE('2020-07-16','YYYY-MM-DD'),NULL,'200716-M1-562','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P225-07-20','S113M','M117SV',TO_DATE('2020-07-17','YYYY-MM-DD'),NULL,'200717-M1-568','meeting room','cash','25.00');

INSERT INTO payment VALUES ('P226-07-20','S102F','M113SV',TO_DATE('2020-07-18','YYYY-MM-DD'),NULL,'200718-M1-569','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P227-07-20','S108F','M117SV',TO_DATE('2020-07-18','YYYY-MM-DD'),NULL,'200718-M1-570','fine book','cash','12.50');
INSERT INTO payment VALUES ('P228-07-20','S104M','M103BR',TO_DATE('2020-07-19','YYYY-MM-DD'),NULL,'200719-M1-573','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P229-07-20','S104M','M118GD',TO_DATE('2020-07-19','YYYY-MM-DD'),NULL,'200719-M2-576','meeting room','cash','17.50');
INSERT INTO payment VALUES ('P230-07-20','S104M','M115GD',TO_DATE('2020-07-19','YYYY-MM-DD'),NULL,'200719-M1-579','meeting room','cash','12.50');

INSERT INTO payment VALUES ('P231-07-20','S108F','M109SV',TO_DATE('2020-07-19','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P232-07-20','S108F','M104SV',TO_DATE('2020-07-19','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P233-07-20','S108F','M112BR',TO_DATE('2020-07-19','YYYY-MM-DD'),'R1252L',NULL,'fine book','cash','150.00');
INSERT INTO payment VALUES ('P234-07-20','S108F','M113SV',TO_DATE('2020-07-19','YYYY-MM-DD'),'R1253L',NULL,'fine book','cash','45.00');
INSERT INTO payment VALUES ('P235-07-20','S108F','M114BR',TO_DATE('2020-07-19','YYYY-MM-DD'),'R1254L',NULL,'fine book','cash','60.00');

INSERT INTO payment VALUES ('P236-07-20','S108F','M116BR',TO_DATE('2020-07-19','YYYY-MM-DD'),'R1256L',NULL,'fine book','cash','70.00');
INSERT INTO payment VALUES ('P237-07-20','S108F','M117SV',TO_DATE('2020-07-19','YYYY-MM-DD'),'R1257L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P238-07-20','S102F','M119BR',TO_DATE('2020-07-19','YYYY-MM-DD'),'R1259L',NULL,'fine book','cash','50.00');
INSERT INTO payment VALUES ('P239-07-20','S102F','M101BR',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1261L',NULL,'fine book','cash','75.00');
INSERT INTO payment VALUES ('P240-07-20','S102F','M102SV',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1262L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P241-07-20','S102F','M103BR',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1263L',NULL,'fine book','cash','25.00');
INSERT INTO payment VALUES ('P242-07-20','S102F','M104SV',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1264L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P243-07-20','S119F','M107BR',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1266L',NULL,'fine book','cash','10.00');
INSERT INTO payment VALUES ('P244-07-20','S119F','M107BR',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1267L',NULL,'fine book','cash','80.00');
INSERT INTO payment VALUES ('P245-07-20','S119F','M109SV',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1269L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P246-07-20','S119F','M110BR',TO_DATE('2020-07-20','YYYY-MM-DD'),'R1270L',NULL,'fine book','cash','40.00');
INSERT INTO payment VALUES ('P247-07-20','S107F','M113SV',TO_DATE('2020-07-21','YYYY-MM-DD'),NULL,'200721-M1-588','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P248-07-20','S110F','M103BR',TO_DATE('2020-07-22','YYYY-MM-DD'),NULL,'200722-M1-591','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P249-07-20','S110F','M114BR',TO_DATE('2020-07-23','YYYY-MM-DD'),NULL,'200723-M1-593','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P250-07-20','S110F','M115GD',TO_DATE('2020-07-23','YYYY-MM-DD'),NULL,'200723-M2-594','meeting room','cash','35.00');

INSERT INTO payment VALUES ('P251-07-20','S106F','M111GD',TO_DATE('2020-07-23','YYYY-MM-DD'),'R1272L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P252-07-20','S106F','M112BR',TO_DATE('2020-07-23','YYYY-MM-DD'),'R1273L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P253-07-20','S110F','M114BR',TO_DATE('2020-07-23','YYYY-MM-DD'),'R1274L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P254-07-20','S110F','M116BR',TO_DATE('2020-07-23','YYYY-MM-DD'),'R1276L',NULL,'fine book','cash','100.00');
INSERT INTO payment VALUES ('P255-07-20','S110F','M117SV',TO_DATE('2020-07-23','YYYY-MM-DD'),'R1277L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P256-07-20','S110F','M119BR',TO_DATE('2020-07-23','YYYY-MM-DD'),'R1279L',NULL,'fine book','cash','125.00');
INSERT INTO payment VALUES ('P257-07-20','S108F','M103BR',TO_DATE('2020-07-24','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P258-07-20','S108F','M108GD',TO_DATE('2020-07-24','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P259-07-20','S108F','M109SV',TO_DATE('2020-07-24','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P260-07-20','S114M','M114BR',TO_DATE('2020-07-24','YYYY-MM-DD'),NULL,'200724-M1-597','meeting room','cash','25.00');

INSERT INTO payment VALUES ('P261-07-20','S114M','M105GD',TO_DATE('2020-07-24','YYYY-MM-DD'),NULL,'200724-M2-600','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P262-07-20','S111F','M111GD',TO_DATE('2020-07-25','YYYY-MM-DD'),NULL,'200725-M1-602','meeting room','cash','12.50');
INSERT INTO payment VALUES ('P263-07-20','S115M','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1281L',NULL,'fine book','cash','90.00');
INSERT INTO payment VALUES ('P264-07-20','S115M','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1282L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P265-07-20','S115M','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1283L',NULL,'fine book','cash','30.00');

INSERT INTO payment VALUES ('P266-07-20','S115M','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1284L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P267-07-20','S115M','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1286L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P268-07-20','S112F','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1287L',NULL,'fine book','cash','150.00');
INSERT INTO payment VALUES ('P269-07-20','S112F','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1289L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P270-07-20','S112F','M119BR',TO_DATE('2020-07-25','YYYY-MM-DD'),'R1290L',NULL,'fine book','cash','25.00');

INSERT INTO payment VALUES ('P271-07-20','S108F','M112BR',TO_DATE('2020-07-25','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P272-07-20','S108F','M106SV',TO_DATE('2020-07-25','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P273-07-20','S108F','M111GD',TO_DATE('2020-07-26','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P274-07-20','S108F','M113SV',TO_DATE('2020-07-26','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P275-07-20','S108F','M114BR',TO_DATE('2020-07-26','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P276-07-20','S115M','M111GD',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1291L',NULL,'fine book','cash','5.00');
INSERT INTO payment VALUES ('P277-07-20','S115M','M112BR',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1292L',NULL,'fine book','cash','105.00');
INSERT INTO payment VALUES ('P278-07-20','S101M','M113SV',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1293L',NULL,'fine book','cash','60.00');
INSERT INTO payment VALUES ('P279-07-20','S101M','M114BR',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1294L',NULL,'fine book','cash','70.00');
INSERT INTO payment VALUES ('P280-07-20','S101M','M115GD',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1295L',NULL,'fine book','cash','5.00');

INSERT INTO payment VALUES ('P281-07-20','S109M','M116BR',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1296L',NULL,'fine book','cash','120.00');
INSERT INTO payment VALUES ('P282-07-20','S109M','M117SV',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1297L',NULL,'fine book','cash','30.00');
INSERT INTO payment VALUES ('P283-07-20','S109M','M119BR',TO_DATE('2020-07-28','YYYY-MM-DD'),'R1299L',NULL,'fine book','cash','3.00');
INSERT INTO payment VALUES ('P284-07-20','S108F','M109SV',TO_DATE('2020-07-26','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P285-07-20','S108F','M104SV',TO_DATE('2020-07-26','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');

INSERT INTO payment VALUES ('P286-07-20','S107F','M116BR',TO_DATE('2020-07-28','YYYY-MM-DD'),NULL,'200728-M3-617','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P287-07-20','S115M','M104SV',TO_DATE('2020-07-29','YYYY-MM-DD'),NULL,'200729-M2-618','meeting room','cash','35.00');
INSERT INTO payment VALUES ('P288-07-20','S115M','M113SV',TO_DATE('2020-07-30','YYYY-MM-DD'),NULL,'200730-M1-624','meeting room','cash','25.00');
INSERT INTO payment VALUES ('P289-07-20','S101M','M120GD',TO_DATE('2020-07-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P290-07-20','S101M','M119BR',TO_DATE('2020-07-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');

INSERT INTO payment VALUES ('P291-07-20','S101M','M117SV',TO_DATE('2020-07-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P292-07-20','S101M','M115GD',TO_DATE('2020-07-28','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P293-07-20','S115M','M113SV',TO_DATE('2020-07-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');
INSERT INTO payment VALUES ('P294-07-20','S115M','M111GD',TO_DATE('2020-07-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P295-07-20','S115M','M109SV',TO_DATE('2020-07-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','40.00');

INSERT INTO payment VALUES ('P296-07-20','S115M','M107BR',TO_DATE('2020-07-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P297-07-20','S115M','M105GD',TO_DATE('2020-07-29','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','50.00');
INSERT INTO payment VALUES ('P298-07-20','S108F','M103BR',TO_DATE('2020-07-30','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P299-07-20','S108F','M101BR',TO_DATE('2020-07-30','YYYY-MM-DD'),NULL,NULL,'membership monthly fee','cash','30.00');
INSERT INTO payment VALUES ('P300-07-20','S111F','M113SV',TO_DATE('2020-07-31','YYYY-MM-DD'),NULL,'200731-M2-627','meeting room','cash','35.00');