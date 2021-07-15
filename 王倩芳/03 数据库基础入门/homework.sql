-- 1 从USER表中查询所有用户的姓名和单位。
SELECT lname,unitName
FROM users;

-- 2 查询所有图书的信息
SELECT *
FROM bookinfo bi
LEFT JOIN books b
		ON bi.ISBN = b.ISBN;

-- 3 查询单位为“计算机学院”的用户的全部信息。
SELECT *
FROM users 
WHERE unitName = '计算机学院';

-- 4 查询已经预约但还没有借出的书的信息。
SELECT 
		bi.ISBN,
		bi.bname,
		bi.author,
		bi.press,
		bi.price,
		bi.`language`,
		bi.pages,
		res.rstatus
FROM bookinfo bi
 JOIN reservation res
		ON bi.ISBN = res.ISBN
		WHERE rstatus = 'f';

		
-- 5 查询借书超过60天且还没有归还的借阅证号、书号。
SELECT 
		l.loanNo,
		l.bookNo
FROM loan l, users u 
WHERE  DATEDIFF(now(),l.borrowDate) > 60 
AND l.loanNo = u.loanNo;


-- 6 查询“清华大学出版社”出版的所有中文书的书名、作者、价格。
SELECT 
		bi.bname,
		bi.author,
		bi.price
FROM bookinfo bi
WHERE bi.press = '清华大学出版社' 
AND bi.`language` = '中文' ;

-- 7 查询在流通总库或者是属于计算机学院资料室的尚未借出的书。
SELECT *
FROM books b
WHERE b.bstatus = '0'
AND b.location = '流通总库' OR b.location = '计算机学院资料室';
-- 注意状态和location的顺序，简直amazing!

-- 8 查询价格在30元到50元之间的书。
SELECT *
FROM bookinfo bi
WHERE bi.price BETWEEN 30 AND 50;

-- 9 查询2019年的借阅历史情况。 
SELECT *
FROM loanhist lh
WHERE YEAR(2019);
-- 用函数year

-- 10 查询作者为兰苓、孙海涛、刘明编写的书的书名、作者、出版社和价格
SELECT 
		bi.bname,
		bi.author,
		bi.press,
		bi.price
FROM bookinfo bi
WHERE bi.author = '兰苓' 
OR bi.author = '孙海涛'
OR bi.author = '刘明';
-- 记住是or 不是and

-- 11 查询书名包含“数据库”的所有书名、作者、出版社和价格。
SELECT 
		bi.bname,
		bi.author,
		bi.press,
		bi.price
FROM bookinfo bi
WHERE bi.bname REGEXP '数据库';

-- 12 查询书名包含“数据库”的所有书名、作者、出版社及价格*1.5 ,并将最后一列重命名为price。
SELECT 
		bi.bname,
		bi.author,
		bi.press,
		bi.price * 1.5 AS price
FROM bookinfo bi
WHERE bi.bname REGEXP '数据库';

-- 13 将上题的结果按书名排序。
SELECT 
		bi.bname,
		bi.author,
		bi.press,
		bi.price * 1.5 AS price
FROM bookinfo bi
WHERE bi.bname REGEXP '数据库'
ORDER BY bi.bname;

-- 14 查询收费情况，结果先按日期降序排序，同一天的按金额排序。
SELECT *
FROM money m
ORDER BY m.billdate DESC, m.amount ;

-- woc,这还能直接在后面写m.amount,我找了各种方法就是出不来...
-- 又是case when ，又是decode, wo 累了a...

-- 15 查询书价最高的前5种的书名、作者、出版社和定价。
SELECT 
		bname,
		author,
		press,
		price
FROM bookinfo
ORDER BY price DESC
LIMIT 5;
		
-- 16 查询买过哪些出版社的书。
SELECT DISTINCT
		bi.press
FROM bookinfo bi;
-- DISTINCT 真好用...

-- 17、	查询借阅用户总人数。
SELECT COUNT(*)
FROM users ;

-- 18、	查询当前正借有书的用户总人数。
SELECT COUNT(DISTINCT loanNo) AS count
FROM loan;

-- 19 查询办证押金的总金额。
SELECT SUM(m.amount) AS sum
FROM money m
WHERE m.reason = '办证押金';

-- 20 查询用户对书的平均借阅时间：按照用户分组，查询每个用户的平均借阅天数。
SELECT AVG(DATEDIFF(lh.returnDate,lh.borrowDate)) AS avg
FROM loanhist lh
GROUP BY lh.loanNo;

-- 21 查询书的最高价格和最低价格。
SELECT MAX(price) AS max, 
			 MIN(price) AS min
FROM bookinfo;

-- 22 查询出版社及从各个出版社购进的书各有多少种。
SELECT  press,
COUNT(*) AS amount
FROM bookinfo 
GROUP BY press;

-- 23 查询每种图书的书名和其库存量，并对结果按库存量排序。
SELECT 
		b.ISBN, 
		COUNT(b.ISBN) AS count
FROM books b, 
		 bookinfo bi
WHERE b.ISBN = bi.ISBN
GROUP BY b.ISBN
ORDER BY count;

-- 24 对上题的查询结果只返回库存量在3本以上的书名和库存量。
SELECT 
		b.ISBN, 
		COUNT(b.ISBN) AS count
FROM books b, 
		 bookinfo bi
WHERE b.ISBN = bi.ISBN
GROUP BY b.ISBN
HAVING count > 3
ORDER BY count;
-- 排序放在最后

-- 25 查询2019年各种情况收费的总数大于50元的金额和收费原因。
SELECT 
			m.reason,
			SUM(m.amount) AS sum
FROM money m
WHERE YEAR(billdate) = 2019
GROUP BY m.reason
HAVING sum > 50;

-- 26 查询当前借书用户的借阅证号、姓名、书号、借书日期。
SELECT 
			l.loanNo,
			u.lname,
			l.bookNo,
			l.borrowDate
FROM loan l, users u
WHERE l.loanNo = u.loanNo;
-- 就这放在26题，欺骗感情...

-- 27 查询当前借书过期还没归还的用户的借阅证号、姓名、书名、借书日期、过期天数，并按借阅证号排序。
SELECT  l.bookNo,
				u.lname,
				bi.bname,
				l.borrowDate
FROM  loan l,
		  users u,
			bookinfo bi,
			class_user cu,
			books b
WHERE l.loanNo = u.loanNo && u.classNo = cu.classNo			&& b.ISBN = bi.ISBN && l.bookNo = b.bookNo
			&& DATEDIFF(NOW(),l.borrowDate) > cu.term
ORDER BY l.loanNo;
			
-- 28 内联接查询在流通总库的数据库类书的信息。
SELECT bi.ISBN,
			 bi.bname,
			 bi.author,
			 bi.press 
FROM books b
INNER JOIN bookinfo bi
		ON b.ISBN = bi.ISBN
WHERE  b.location = '流通总库'
AND bi.bname REGEXP '数据库';

-- 29 左外联接查询分类为4的用户的姓名、单位、及借阅情况。
SELECT u.lname,
			 u.unitName,
			 l.bookNo,
			 l.loanNo,
			 l.borrowDate
FROM users u
LEFT JOIN loan l
		ON u.loanNo = l.loanNo
WHERE u.classNo = 4;

-- 30 使用子查询查询与借阅证号为“S06102”的用户在同一单位的所有用户的借阅证号和姓名。
SELECT loanNo,lname
FROM users
WHERE unitName = 
			(SELECT unitName 
			 FROM users			 WHERE loanNo = 'S06102'
		  );
			
-- 31 使用子查询查询所有借书预约成功的用户的姓名和E_mail，以便通知他们。
SELECT lname,email
FROM users 
WHERE loanNo IN
(SELECT loanNo FROM reservation WHERE rstatus = 't');
-- 注意是in,因为外面的表loanNo有很多，但是符合条件的在后面的select 中

-- 32 使用子查询查询类别为“教师”的用户的借书情况。
SELECT *
FROM loan
WHERE loanNo IN
(SELECT loanNo FROM users WHERE classNo = 4);
-- 注意到教师的类别为4

-- 33 计算相关子查询查询借阅数量大于3本的用户的借阅证号、姓名、单位。
SELECT u.loanNo,u.lname,u.unitName
FROM users u
JOIN (SELECT l.loanNo, COUNT(l.loanNo) AS cnt
FROM loan l 
GROUP BY l.loanNo 
HAVING cnt > 3) b
WHERE u.loanNo = b.loanNo;
-- 注意count好像必须要有个group by

-- 34 查询所有曾经借过书号为“A04500049”这本书的所有用户的借阅证号和姓名。
SELECT loanNo,lname
FROM users
WHERE loanNo IN
(SELECT loanNo FROM loanhist WHERE bookNo = 'A04500049');

-- 35 查询所有借过书的用户借阅证号。
SELECT loanNo
FROM loan
UNION
SELECT loanNo
FROM loanhist;

-- 36 查询现在正借有书的用户但以前没有借过书的用户的借阅证号。
SELECT DISTINCT loanNo
FROM loan
WHERE loanNo NOT IN
(SELECT loanNo FROM loanhist);
-- 记得加 DISTINCT 除去重复的

-- 37 查询当前所有借书信息，并将查询结果导出到’d:\loan.txt’文件中，字段之间用逗号分隔。
SELECT * 
FROM loan;
-- INTO OUTFILE '/var/lib/mysql/loan.txt' 
-- FIELDS TERMINATED by '\,'
-- 执行不了语句...

-- 38 新建一个表loan_statics，包括ISBN和loancount(借阅次数)两个字段，通过查询将每类书的ISBN号和历史借阅次数添加到这个表中。
CREATE TABLE loan_statics(ISBN char(13),loancount int);
INSERT into loan_statics (ISBN,loancount)
SELECT ISBN,count(*)
FROM books b,loanhist lh
WHERE b.bookNo = lh.bookNo
GROUP BY ISBN;

-- 39 在USER表中添加一个金额字段amount，并对每个用户的交费总额进行修改。
ALTER TABLE users ADD amount DECIMAL;
UPDATE users SET amount = 100 WHERE loanNo = 'X10463';
UPDATE users SET amount = 100 WHERE loanNo = 'Y00001';
UPDATE users SET amount = 100 WHERE loanNo = 'Y00003';

