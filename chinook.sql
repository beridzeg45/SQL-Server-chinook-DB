--Q.1 What is the title of the album with AlbumId 67?
select Title
from Album
where AlbumId=67;


--Q.2 Find the name and length (in seconds) of all tracks that have length between 50 and 70 seconds

select Name,Milliseconds/1000 as length_in_seconds
from Track
where Milliseconds/1000 between 50 and 70
order by length_in_seconds asc;

--Q.3 List all the albums by artists with the word ‘black’ in their name.

select Name as Artist, Title
from Artist ar 
join Album al on ar.ArtistId=al.ArtistId
where Name like '%black%'
order by 1,2;

--Q.4 Provide a query showing a unique/distinct list of billing countries from the Invoice table

select distinct BillingCountry
from Invoice;

--Q.5 Display the city with highest sum total invoice.
select top 1 BillingCity, sum(Total) as TotalInvoice
from Invoice
group by BillingCity
order by TotalInvoice desc;

--Q.6 Produce a table that lists each country and the number of customers in 
--that country. (You only need to include countries that have customers) in 
-- descending order. (Highest count at the top)

select country, count(distinct CustomerId) as NumberOfCustomers
from Customer
where Country is not null
group by country
order by NumberOfCustomers desc;

--Q.7 Find the top five customers in terms of sales i.e. find the five customers 
--whose total combined invoice amounts are the highest. Give their name, 
--CustomerId and total invoice amount. Use join

with t1 as
(select i.CustomerId,sum(Total) as Total
from Invoice i 
group by i.CustomerId)
select top 5 t1.CustomerId,concat(FirstName,' ',LastName) as Customer,Total
from t1
join customer c on t1.CustomerId=c.CustomerId
order by Total desc;

--Q.8 Find out state wise count of customerID and list the names of states with 
--count of customerID in decreasing order. Note:- do not include where states is null value.

select State,count(distinct CustomerId) as CustomerCount
from Customer
where State is not null
group by State
order by CustomerCount desc;

-- Q.9 How many Invoices were there in 2009 and 2011?

select count(distinct InvoiceId) as InvoicesCount
from Invoice
where year(InvoiceDate) between 2009 and 2011;

--Q.10 Provide a query showing only the Employees who are Sales Agents.

select *
from Employee
where Title like '%agent%';


--Q.1 Display Most used media types: their names and count in descending order

use Chinook;

with t1 as
(select TrackId,sum(Quantity) as SoldNumber
from InvoiceLine
group by TrackId)
,t2 as 
(select GenreId, sum(SoldNumber) as SoldNumber
from t1 
join Track t on t1.TrackId=t.TrackId
group by GenreId)
select Name, SoldNumber
from t2
join Genre g on t2.GenreId=g.GenreId
order by SoldNumber desc;


--Q.2Provide a query showing the Invoices of customers who are from Brazil.
--The resultant table should show the customer's full name, Invoice ID, Date ofthe invoice and billing country

select CONCAT(FirstName,' ',LastName) as Customer,InvoiceId,InvoiceDate,BillingCountry
from Invoice i 
join Customer c on i.CustomerId=c.CustomerId
where Country='Brazil'
order by Customer asc;

--Q.3 Display artistname and total track count of the top 10 rock bands from dataset.

select top 10 ar.Name, count(TrackId) as TrackCount
from album al
join Track t on al.AlbumId=t.AlbumId
join Artist ar on al.ArtistId=ar.ArtistId
where GenreId in (select GenreId from Genre where Name like '%rock%')
group by ar.Name
order by TrackCount desc;

--Q.4 Display the Best customer (in case of amount spent). Full name (first name and last name)

use Chinook;
with t1 as 
(select i.CustomerId,sum(Total) as Total
from Invoice i
join Customer c on i.CustomerId=c.CustomerId
group by i.CustomerId)
select top 1 CONCAT(FirstName,' ',LastName) as Customer,Total
from t1
join Customer c on t1.CustomerId=c.CustomerId
order by Total desc;

-- find invoices that contain tracks of two or more different genres

with t1 as
(select InvoiceId,count(distinct GenreId) as GenresCount
from InvoiceLine i
join track t on i.TrackId=t.TrackId
group by InvoiceId
having count(distinct GenreId)>1)
select *
from t1;









-- How sales increased for each Sales Rep each year compared to previous year?

with t2009 as
(select SupportRepId, sum(Total) as TotalSales2009
from Invoice i 
join Customer c on i.CustomerId=c.CustomerId
join Employee e on c.SupportRepId=e.EmployeeId
where year(InvoiceDate)=2009
group by SupportRepId)
, t2010 as
(select SupportRepId, sum(Total) as TotalSales2010
from Invoice i 
join Customer c on i.CustomerId=c.CustomerId
join Employee e on c.SupportRepId=e.EmployeeId
where year(InvoiceDate)=2010
group by SupportRepId)
, t2011 as
(select SupportRepId, sum(Total) as TotalSales2011
from Invoice i 
join Customer c on i.CustomerId=c.CustomerId
join Employee e on c.SupportRepId=e.EmployeeId
where year(InvoiceDate)=2011
group by SupportRepId)
, t2012 as
(select SupportRepId, sum(Total) as TotalSales2012
from Invoice i 
join Customer c on i.CustomerId=c.CustomerId
join Employee e on c.SupportRepId=e.EmployeeId
where year(InvoiceDate)=2012
group by SupportRepId)
, t2013 as
(select SupportRepId, sum(Total) as TotalSales2013
from Invoice i 
join Customer c on i.CustomerId=c.CustomerId
join Employee e on c.SupportRepId=e.EmployeeId
where year(InvoiceDate)=2013
group by SupportRepId)

, t1 as
(select t2009.SupportRepId,TotalSales2009,TotalSales2010,TotalSales2011,TotalSales2012,TotalSales2013
from t2009,t2010,t2011,t2012,t2013
where t2009.SupportRepId=t2010.SupportRepId and t2010.SupportRepId=t2011.SupportRepId and t2011.SupportRepId=t2012.SupportRepId and t2012.SupportRepId=t2013.SupportRepId)
, t2 as 
(select t1.*, 
format((TotalSales2010-TotalSales2009)/TotalSales2009,'P2') as SalesIncrease2010,
format((TotalSales2011-TotalSales2010)/TotalSales2010,'P2') as SalesIncrease2011,
format((TotalSales2012-TotalSales2011)/TotalSales2011,'P2') as SalesIncrease2012,
format((TotalSales2013-TotalSales2012)/TotalSales2012,'P2') as SalesIncrease2013
from t1)
select SupportRepId,SalesIncrease2010,SalesIncrease2011,SalesIncrease2012,SalesIncrease2013
from t2;



