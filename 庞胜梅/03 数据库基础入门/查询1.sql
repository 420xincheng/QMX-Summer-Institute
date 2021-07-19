select lname, unitName from users;
select * from bookinfo;
select * from users where unitName = '计算机学院' ;
select * from books where bstatus = 3;
select bookNo, borrowDate from loan 
      where datediff(current_date(),borrowDate) >60;
select bname, author, price from bookinfo
    where language = '中文'and press ='清华大学出版社';
select * from books 
    where location = '流通总库' and bstatus = '0';
select * from bookinfo 
    where price < 50 and price > 30;
select * from loanhist where year(borrowDate) = '2019';
select bname, author, press, price from bookinfo 
    where author in('兰苓' , '孙海涛' , '刘明');
select bname, author, press, price from bookinfo 
    where bname like '%数据库%';
select bname,author,press,price * 1.5 AS price 
    from bookinfo where bname like "%数据库%";
select bname,author,press,price * 1.5 AS price 
    from bookinfo where bname like "%数据库%" 
		order by bname ;
select amount from money 
    order by billdate desc, amount ;
select bname, author, press, price 
    from bookinfo 
		order by price desc limit 5;
select distinct press from bookinfo;
select count(*) from users ;
select count(loanNo) from Loan ;
select sum(amount) from money where reason = '办证押金';
select avg(datediff(returnDate, borrowDate)) 
    from loanhist group by loanNo;
select MIN(price),MAX(price) from bookinfo;
select press, count(bname) 
    from bookinfo group by press;
select books.ISBN, bookinfo.bname 
    from books,bookinfo where books.ISBN = bookinfo.ISBN
		group by ISBN
		order by count(*),ISBN desc;
select books.ISBN, bookinfo.bname,count(*) 
    from books,bookinfo where books.ISBN = bookinfo.ISBN 
		group by ISBN having count(*) > 3
		order by count(*),ISBN desc;
select reason, sum(amount) from money 
    where year(billdate) = 2019
    group by reason having sum(amount) > 50 ;
select loan.loanNo, users.lname,loan.bookNo,loan.borrowDate 
    from loan,users 
		where loan.loanNo = users.loanNo;
select b.loanNo,a.lname, c.bname,b.borrowDate, 
    datediff(current_date ,b.borrowDate) 
    from users a, loan b,  bookinfo c 
		where b.loanNo = a.loanNo 
		order by b.loanNo;
select books.*,bookinfo.* 
    from books inner join bookinfo on 
		books.ISBN = bookinfo.ISBN 
    where books.location = '流通总库'and bookinfo.bname like '%数据库%';
select a.lname, a.unitName 
    from users a left join class_user b on 
		a.classNo = b.classNo  ;
select loanNo , lname from users
     where unitName = (select unitName from users where loanNo = 'S06102');
select a.lname, a.email 
	    from users a,reservation b 
			where a.loanNo = any (select loanNo from reservation where b.rstatus = 't');
select * from users 
      where classNo = 
			(select classNo from class_user where cname = '教师' );
select loanNo, lname ,unitName from users 
      where loanNo = 
			(select loanNo from loan group by loanNo having      count(bookNo) >3);
select loanNo, lname from users where loanNo in (select loanNo from loanhist where bookNo = 'A04500049'); 
select distinct distinct loanNo from loan;
select loan.loanNo from loan,loanhist where loan.loanNo != loanhist.loanNo;
select * from loan into outfile 'd:\loan.txt' fields terminated by ',';
Create table loan_statics(
    ISBN char(13),
    Loancount int;
    );
Insert into loan_statics(ISBN,Loancount)
select ISBN, count(*)
From books b inner join loanhist c 
    where b.loanNo = c. loanNo group by ISBN;
Alter table user add  amount DECIMAL;
