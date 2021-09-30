--Poh Choo Meng [Query 1] (Monthly Reservation Report)

--Clear screen
CL SCR

--Accept prompt commands
ACCEPT monthYear date format 'YYYY-MM' PROMPT 'Enter the month and year to search the result (YYYY-MM) : '

--Option
SET pagesize 63
SET linesize 126
TTITLE CENTER "Logical Library" SKIP CENTER "Month  Reservation Report" RIGHT ("Page: " FORMAT 009 SQL.PNO) SKIP 2
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'Name' FORMAT 'A20' WORD_WRAPPED
COLUMN 'Type' FORMAT 'A13'
COLUMN 'Room ID' FORMAT 'A11'
COLUMN 'Book ID' FORMAT 'A12'
COLUMN 'Reserved Date' FORMAT 'A11' HEADING "RESERVED|DATE"
COLUMN 'Remarks' FORMAT 'A29' WORD_WRAPPED
COLUMN 'Reserve Method' FORMAT 'A8' HEADING "RESERVE|METHOD"
SET VERIFY OFF

--Query
SELECT r.reservation_id as "RESERVATION ID",m.member_name as "NAME", r.reserve_method as "Reserve Method",rr.reservation_desc as "TYPE", rr.room_id as "ROOM ID", NULL as "BOOK ID", r.remarks ,rr.reserved_start_time as "Reserved Date"
FROM membership m 
JOIN reservation r
	ON m.member_id = r.member_id AND r.reserve_type = 'Room'
JOIN room_reservation rr
	ON r.reservation_id = rr.reservation_id
WHERE 
	EXTRACT(MONTH FROM r.requested_date) = EXTRACT(MONTH FROM DATE '&monthYear-01') 
	AND EXTRACT(YEAR FROM r.requested_date) = EXTRACT(YEAR FROM DATE '&monthYear-01')
UNION
	SELECT r.reservation_id, m.member_name, r.reserve_method as "Reserve Method", r.reserve_type, TO_CHAR(NULL), br.book_id, r.remarks ,br.reserved_date as "Reserved Date"
	FROM membership m
	JOIN reservation r
		ON m.member_id = r.member_id AND r.reserve_type = 'Book'
	JOIN book_reservation br
		ON r.reservation_id = br.reservation_id
	WHERE 
		EXTRACT(MONTH FROM r.requested_date) = EXTRACT(MONTH FROM DATE '&monthYear-01') 
		AND EXTRACT(YEAR FROM r.requested_date) = EXTRACT(YEAR FROM DATE '&monthYear-01');


--Poh Choo Meng [Query 2] (Member Reservation Records)

--Clear screen
CL SCR

--Accept prompt commands
ACCEPT member char FORMAT 'A30' PROMPT 'Enter the membername OR memberID : '
ACCEPT reserveType char FORMAT 'A4' PROMPT 'Enter the reservation type (Room/Book) : '

--Option
SET pagesize 63
SET linesize 116
TTITLE CENTER "Logical Library" SKIP CENTER "Member Reservation Records" RIGHT ("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&member Records]"
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'Name' FORMAT 'A20' WORD_WRAPPED
COLUMN 'Type' FORMAT 'A13'
COLUMN 'Reserved Date' FORMAT 'A11' HEADING "RESERVED|DATE"
COLUMN 'Remarks' FORMAT 'A29' WORD_WRAPPED
COLUMN 'Reserve Method' FORMAT 'A8' HEADING "RESERVE|METHOD"
COLUMN 'COSTS' FORMAT 9990.99 HEADING "COSTS|(RM)"
COLUMN 'Room ID' HEADING "ROOM ID"
COLUMN 'Book ID' HEADING "BOOK ID"
BREAK ON "NAME"
SET VERIFY OFF

--Query
SELECT r.reservation_id, r.reserve_method as "Reserve Method", rr.reservation_desc as "TYPE", rr.room_id as "&reserveType ID" , r.remarks,rr.reserved_start_time as "Reserved Date", rr.total_costs as "COSTS", status
FROM membership m
JOIN reservation r
	ON m.member_id = r.member_id AND '&reserveType' = 'Room' AND r.reserve_type='&reserveType'
JOIN room_reservation rr
	ON r.reservation_id = rr.reservation_id
WHERE m.member_id LIKE '&member' OR m.member_name LIKE '&member'
UNION
	SELECT r.reservation_id, r.reserve_method as "Reserve Method", r.reserve_type, br.book_id as "BOOK ID", r.remarks, br.reserved_date as "Reserved Date", 0, status
	FROM membership m
	JOIN reservation r
		ON m.member_id = r.member_id AND '&reserveType' = 'Book' AND r.reserve_type='&reserveType'
	JOIN book_reservation br
		ON r.reservation_id = br.reservation_id
	WHERE m.member_id LIKE '&member' OR m.member_name LIKE '&member';

--Poh Choo Meng [Query 3] (Reservation Summary)

--Clear screen
CL SCR

--Option
SET pagesize 63
SET linesize 85
TTITLE CENTER "Logical Library" SKIP CENTER "Reservation Summary" RIGHT ("Page: " FORMAT 009 SQL.PNO) SKIP 2
COLUMN 'monthYear' HEADING " "
COLUMN roomReservation FORMAT "9999" HEADING  "ROOM|RESERVATION"
COLUMN bookReservation FORMAT "9999" HEADING  "BOOK|RESERVATION"
COLUMN duration FORMAT "999999" HEADING "RESERVE DURATION|(Minutes)"
COLUMN totalReservation FORMAT "9999" HEADING "TOTAL|RESERVATION"
COLUMN totalCosts FORMAT "99990.99" HEADING "TOTAL COSTS"
COLUMN roomUsers FORMAT "999" HEADING "ROOM USERS"
ALTER SESSION SET NLS_DATE_FORMAT = 'MON-YYYY';

--Create a dummy which function as NULL and do nothing, purpose of it in this report is to break the line of whole report
COLUMN DUMMY NOPRINT
BREAK ON DUMMY SKIP

--Calculate the total
COMPUTE SUM OF roomReservation ON DUMMY
COMPUTE SUM OF bookReservation ON DUMMY
COMPUTE SUM OF totalCosts ON DUMMY
COMPUTE SUM OF duration ON DUMMY
COMPUTE SUM OF totalReservation ON DUMMY
COMPUTE SUM OF roomUsers ON DUMMY

--Query
SELECT NULL DUMMY, to_date(to_char(0||EXTRACT(MONTH FROM requested_date)||EXTRACT(YEAR FROM requested_date)),'MM-YYYY') as monthYear, count(rr.reservation_id) as roomReservation, sum(rr.total_costs) as totalCosts, sum(rr.room_users) as roomUsers, sum(rr.duration) as duration,count(NVL(r.reservation_id,0))-count(rr.reservation_id) as bookReservation, count(NVL(r.reservation_id,0)) as totalReservation
FROM reservation r
LEFT OUTER JOIN room_reservation rr
ON r.reservation_id = rr.reservation_id
GROUP BY (EXTRACT(MONTH FROM requested_date),EXTRACT(YEAR FROM requested_date));

--William Choong [Query 1] (Monthly Fine Records)

--Late return summary
CL SCR
--Accept prompt commands
ACCEPT v_return_date date format 'YYYY-MM' PROMPT 'Please enter the date to search the result (YYYY-MM) >> '

--Format
SET pagesize 28
SET linesize 120
TITLE CENTER "Logical Library" SKIP CENTER "Monthly Fine Records" RIGHT ("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&v_return_date]"
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'RETURN ID' FORMAT 'A10'
COLUMN 'NAME' FORMAT 'A20' WORD_WRAPPED
COLUMN 'TITLE' FORMAT 'A50' WORD_WRAPPED
COLUMN 'DUE DATE' FORMAT 'A10'
COLUMN 'DATE RETURNS' FORMAT 'A10' HEADING "DATE|RETURNS" 
COLUMN 'FINE AMOUNT' FORMAT 999.99
SET VERIFY OFF
CL SCR

--Query
SELECT br.return_id AS "RETURN ID", m.member_name AS "NAME", b.book_title AS "TITLE", bl.loan_due_date AS "DUE DATE", br.date_returns AS "DATE RETURNS", br.fine_amount AS "FINE AMOUNT"
FROM book b, lend_book lb, book_loan bl, book_return br, membership m
WHERE lb.book_id = b.book_id
AND bl.loan_id = lb.loan_id
AND br.loan_id = bl.loan_id
AND m.member_id = bl.member_id
AND br.overdue_status = 'Late'
AND extract(MONTH from br.date_returns) = extract(MONTH from date '&v_return_date-01')
AND extract(YEAR from br.date_returns) = extract(YEAR from date '&v_return_date-01')
ORDER BY br.return_id ASC;

--William Choong [Query 2] (Monthly Members Late Return Records)

--Monthly member late return records
CL SCR
--Accept prompt commands
ACCEPT v_late_month date FORMAT 'YYYY-MM' PROMPT 'Please enter the return months to search the results (YYYY-MM)>> '

--Format
SET pagesize 28
SET linesize 120
TITLE CENTER "Logical Library" SKIP CENTER "Monthly Members Late Return Records" RIGHT ("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&v_late_month]"
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'NAME' FORMAT 'A20' WORD_WRAPPED
COLUMN 'LATE RETURN TIMES' FORMAT 999 HEADING "LATE RETURN|TIMES"
COLUMN 'TOTAL FINE AMOUNT' FORMAT 9999.99 HEADING "TOTAL FINE|AMOUNT"
SET VERIFY OFF
CL SCR

--Query
SELECT m.member_name AS "NAME", COUNT(DISTINCT br.return_id) AS "LATE RETURN TIMES", SUM(br.fine_amount) AS "TOTAL FINE AMOUNT"
FROM membership m
JOIN book_loan bl
ON bl.member_id = m.member_id
JOIN book_return br
ON br.loan_id = bl.loan_id
WHERE br.overdue_status = 'Late'
AND EXTRACT(MONTH FROM br.date_returns) = EXTRACT(MONTH FROM DATE '&v_late_month-01')
AND EXTRACT(YEAR FROM br.date_returns) = EXTRACT(YEAR FROM DATE '&v_late_month-01')
GROUP BY m.member_name
ORDER BY COUNT(DISTINCT br.return_id) DESC, SUM(br.fine_amount) DESC;

--William Choong [Query 3] (Monthly Book Category Loaned)

--Late return summary
CL SCR
--Accept prompt commands
ACCEPT v_loan_date date format 'YYYY-MM' PROMPT 'Please enter the date to search the result (YYYY-MM) >> '

--Format
SET pagesize 28
SET linesize 120
TITLE CENTER "Logical Library" SKIP CENTER "Monthly Book Category Trends" RIGHT ("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&v_loan_date]"
COLUMN 'CATEGORY NAME' FORMAT 'A30'
COLUMN 'LEND TIMES' FORMAT 999
SET VERIFY OFF
CL SCR

--Query
SELECT bc.category_name AS "CATEGORY NAME", COUNT(*) AS "LEND TIMES"
FROM book_category bc
JOIN book b
ON b.category_id = bc.category_id
JOIN lend_book lb
ON lb.book_id = b.book_id
JOIN book_loan bl
ON bl.loan_id = lb.loan_id
WHERE EXTRACT(MONTH FROM bl.loan_start_date) = EXTRACT(MONTH FROM DATE '&v_loan_date-01')
AND EXTRACT(YEAR FROM bl.loan_start_date) = EXTRACT(YEAR FROM DATE '&v_loan_date-01')
GROUP BY bc.category_name
ORDER BY COUNT(*) DESC;

--Chew Wei Chung [Query 1] (Monthly Book Loan Records)

--Total loan summary
CL SCR
--Accept prompt commands
ACCEPT v_loan_date DATE format 'YYYY-MM' PROMPT 'Enter the month and year to search the result (YYYY-MM) : '

--Format
SET pagesize 30
SET linesize 120
TITLE CENTER "Logical Library" SKIP CENTER "Month Book Loan Report" -
RIGHT("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&v_loan_date]"
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'LOAN ID' FORMAT 'A10'
COLUMN 'NAME' FORMAT 'A30' WORD_WRAPPED
COLUMN 'BOOK' FORMAT 'A50' WORD_WRAPPED
COLUMN 'LOAN DATE' FORMAT 'A11' 
SET VERIFY OFF
CL SCR

--Query 
SELECT bl.loan_id AS "LOAN ID", m.member_name AS "NAME", b.book_title AS "BOOK", bl.loan_start_date AS "LOAN DATE"
FROM book b
JOIN lend_books lb
ON lb.book_id = b.book_id
JOIN book_loan bl
ON bl.loan_id = lb.loan_id
JOIN membership m
ON m.member_id = bl.member_id
WHERE extract(MONTH from bl.loan_start_date) = extract(MONTH from date'&v_loan_date-01')
AND extract(YEAR from bl.loan_start_date) = extract(YEAR from date'&v_loan_date-01')
ORDER BY bl.loan_start_date ASC;

--Chew Wei Chung [Query 2] (Lend Book Monthly Records)

--Total lend summary
CL SCR
--Accept prompt commands
ACCEPT v_loanS_date DATE format 'YYYY-MM' PROMPT 'Search for the book loan start date(YYYY-MM) : '

--Format
SET pagesize 30
SET linesize 160
TITLE CENTER "Logical Library" SKIP CENTER "Monthly Lend Books Report" -
RIGHT("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&v_loanS_date]"
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'LOAN ID' FORMAT 'A10'
COLUMN 'NAME' FORMAT 'A20' WORD_WRAPPED
COLUMN 'BOOK' FORMAT 'A50' WORD_WRAPPED
COLUMN 'LOAN DATE' FORMAT 'A11' 
COLUMN 'RETURN DATE' FORMAT 'A11'  
COLUMN 'OVERDUE STATUS' FORMAT 'A14' 
SET VERIFY OFF                                         
CL SCR

--Query 
SELECT bl.loan_id AS "LOAN ID", m.member_name AS "NAME", b.book_title AS "BOOK", bl.loan_start_date AS "LOAN DATE",br.date_returns AS "RETURN DATE",br.overdue_status AS "OVERDUE STATUS"
FROM book b,lend_books lb, book_loan bl, membership m,book_return br
WHERE lb.book_id = b.book_id
AND bl.loan_id = lb.loan_id
AND br.loan_id = bl.loan_id
AND m.member_id = bl.member_id
AND extract(MONTH from bl.loan_start_date) = extract(MONTH from date'&v_loanS_date-01')
AND extract(YEAR from bl.loan_start_date) = extract(YEAR from date'&v_loanS_date-01')
ORDER BY bl.loan_start_date ASC;

--Chew Wei Chung [Query 3] (Top Member Book Loan Records)

--Total top book loan summary
CL SCR
--Accept prompt commands
ACCEPT v_loanSummary_date DATE format 'YYYY-MM' PROMPT 'Search for the book loan start date(YYYY-MM) : '

--Format
SET pagesize 28
SET linesize 150
TITLE CENTER "Logical Library" SKIP CENTER "Top members Books Loan Record" -
RIGHT("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&v_loanSummary_date]"
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'MEMBER ID' FORMAT 'A10'
COLUMN 'NAME' FORMAT 'A20' WORD_WRAPPED
COLUMN 'LOAN AMOUNT' FORMAT 999
SET VERIFY OFF                                         
CL SCR

--Query 
SELECT bl.member_id AS "MEMBER ID", m.member_name AS "NAME", SUM(bl.loan_amount) AS "LOAN AMOUNT"
FROM membership m
JOIN book_loan bl
ON m.member_id = bl.member_id
WHERE extract(MONTH from bl.loan_start_date) = extract(MONTH from date'&v_loanSummary_date-01')
AND extract(YEAR from bl.loan_start_date) = extract(YEAR from date'&v_loanSummary_date-01')
GROUP BY bl.member_id, m.member_name
ORDER BY SUM(bl.loan_amount) DESC;

--Choo Zhi Yan [Query 1] (Monthly Membership Renew Report)

--Accpet prompt command
ACCEPT payment_date DATE format 'YYYY-MM' PROMPT 'Enter the month and year to search the monthly membership renew result (YYYY-MM) : ' 

--Format
SET pagesize 30
SET linesize 100
TTITLE CENTER -
"LOGICAL LIBRARY" SKIP CENTER "Monthly Membership renew Report" -
RIGHT("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&payment_date]" 
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'PAYMENT ID' FORMAT A25
COLUMN 'MEMBER ID' FORMAT A25
COLUMN 'DATE' FORMAT A25
COLUMN 'AMOUNT' FORMAT 9999.99
BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF AMOUNT ON REPORT
CL SCR

--Query
SELECT p.payment_id AS "PAYMENT ID", p.member_id AS "MEMBER ID", 
p.payment_date AS "DATE", p.payment_amount AS "AMOUNT"
FROM membership m, payment p
WHERE p.member_id = m.member_id
AND payment_desc = 'membership monthly fee'
AND extract(MONTH FROM p.payment_date) = extract(MONTH FROM DATE '&payment_date-01')
AND extract(YEAR FROM p.payment_date) = extract(YEAR FROM DATE '&payment_date-01')
ORDER BY p.payment_date;

--Choo Zhi Yan [Query 2] (Monthly Sales Report)

--Accpet prompt command
ACCEPT payment_date DATE format 'YYYY-MM' PROMPT 'Enter the month and year to search the monthly sales result (YYYY-MM) : ' 

--Format
SET pagesize 30
SET linesize 100
TTITLE CENTER -
"LOGICAL LIBRARY" SKIP CENTER "Monthly Sales Report" -
RIGHT("Page: " FORMAT 9 SQL.PNO) SKIP 2 CENTER "[&payment_date]" 
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'DATE' FORMAT A20
COLUMN 'PAYMENT ID' FORMAT A20
COLUMN 'MEMBER ID' FORMAT A15
COLUMN 'TYPE' FORMAT A30
COLUMN 'AMOUNT' FORMAT 99999.99
BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF AMOUNT ON REPORT
CL SCR

--Query
SELECT p.payment_id AS "PAYMENT ID", p.member_id AS "MEMBER ID", p.payment_date AS "DATE", 
p.payment_desc AS "TYPE", p.payment_amount AS "AMOUNT"
FROM membership m, payment p
WHERE p.member_id = m.member_id
AND extract(MONTH FROM p.payment_date) = extract(MONTH FROM DATE '&payment_date-01')
AND extract(YEAR FROM p.payment_date) = extract(YEAR FROM DATE '&payment_date-01')
ORDER BY p.payment_date;

--Choo Zhi Yan [Query 3] (Monthly Gold Membership Sales Report)

--Accpet prompt command
ACCEPT payment_date DATE format 'YYYY-MM' PROMPT 'Enter the month and year to search the monthly gold membership sales result (YYYY-MM) : ' 

--Format
SET pagesize 30
SET linesize 120
TTITLE CENTER -
"LOGICAL LIBRARY" SKIP CENTER "Monthly Gold Membership Sales Report" -
RIGHT("Page: " FORMAT 009 SQL.PNO) SKIP 2 CENTER "[&payment_date]" 
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
COLUMN 'PAYMENT ID' FORMAT A15
COLUMN 'MEMBER ID' FORMAT A10
COLUMN 'NAME' FORMAT A25
COLUMN 'TYPE' FORMAT A25
COLUMN 'DATE' FORMAT A20
COLUMN 'AMOUNT' FORMAT 9999.99
BREAK ON REPORT
COMPUTE SUM LABEL TOTAL OF AMOUNT ON REPORT
CL SCR

--Query
SELECT p.payment_id AS "PAYMENT ID", p.member_id AS "MEMBER ID", m.member_name AS "NAME", 
p.payment_desc AS "TYPE", p.payment_date AS "DATE", p.payment_amount AS "AMOUNT"
FROM membership m JOIN payment p
ON p.member_id = m.member_id
AND p.member_id LIKE '%GD'
AND extract(MONTH FROM p.payment_date) = extract(MONTH FROM DATE '&payment_date-01')
AND extract(YEAR FROM p.payment_date) = extract(YEAR FROM DATE '&payment_date-01')
ORDER BY p.payment_date;
