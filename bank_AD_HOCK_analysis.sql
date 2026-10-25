use bank1;

-- AD-HOC DATA ANALYSIS
-- CZECHOSLOVAKIA BANK FINANCIAL DATA


-- 1. DEMOGRAPHIC PROFILE OF THE BANK'S CLIENTS

select * from district limit1;
select * from client limit 1;

--  Which districts have the highest and lowest number of clients?

select d.district_name,count(distinct client_id)as client_count
from client c
inner join district d
on c.district_id=d.district_code
group by d.district_name
order by client_count;

-- genderwise distribution

select sex,count(distinct client_id)as gender_distribution from client
group by sex ;

select client_id,timestampdiff(Year,Birth_date,curdate()) as clients_age from client;


with temp as
(select client_id,timestampdiff(year,birth_date,curdate())as client_age from client)
select 
case
when client_age < 14 THEN 'Children'
when client_age between 14 and 18 then "Teenager"
when client_age between 19 and 30 then "Young Adults"
when client_age between 31 and 45 then "Adults"
when client_age between 46 and 60 then "Middle-Aged"
when client_age >=61 then "senior_citizen"
end as age_group,count(distinct client_id) as client_count
from temp
group by age_group
order by client_count;

-- District-wise Gender Distribution

select d.district_name,c.sex,count(c.client_id)
from client c
inner join district d
on c.district_id=d.district_code
group by d.district_name,c.sex ;

-- District-wise Average Age

with temp as (select client_id,timestampdiff(year,birth_date,curdate())as age from client)
select d.district_name,avg(t.age)as avrage_age
from temp t
inner join client c
on c.client_id=t.client_id
inner join district d
on d.district_code=c.district_id
group by  d.district_name;

-- Q2 — What is the bank's performance over the years, with detailed year/month analysis?

-- 1. Year-wise Total Transaction Amount

 select * from transactions limit 1;
 
 -- year wise (total transaction amount,transaction count,avarage transaction amount) 
 
 select year(`date`)transaction_year,sum(amount)as transaction_amount from transactions_clean
 group by year(`date`);
 
 select year(`date`)transaction_year,count(amount)as transaction_count from transactions_clean
 group by year(`date`);
 
  select year(`date`)transaction_year,avg(amount)as average_transaction from transactions_clean
 group by year(`date`);

-- monthwise(jan 2017 ,2018 jan...2022 jan cha total)

 select month(`date`)transaction_month,sum(amount)as transaction_amount_per_month from transactions_clean
 group by month(`date`);

-- Month-wise Transaction Count 

select month(`date`)transaction_month,count(amount)as transaction_count from transactions_clean
group by month(`date`);

-- Transaction Type-wise Performance.

select type as transaction_type ,sum(amount)as transaction_amount from transactions_clean
group by type;

-- Year-wise Credit vs Withdrawal.

select year(`date`) as transction_year ,type as transaction_type ,sum(amount)as transaction_amount from transactions_clean
group by type,year(`date`);

-- Q3 What are the common account types, their usage, and profitability?

select * from account limit 1;
select distinct Account_type from account;

-- account type distribution 



select account_type,count(account_id)as number_of_accounts from account
group by account_type;

-- Account Type-wise Transaction Count

select a.account_type,count(t.amount) as type_transaction
from account a
inner join transactions_clean t
on a.account_id=t.account_id
group by  a.account_type;	

-- Account Type-wise Transaction Amount

select a.account_type,sum(t.amount) as total_transaction
from account a
inner join transactions_clean t
on a.account_id=t.account_id
group by  a.account_type;	

-- Account Type-wise Average Transaction Amount

select a.account_type,avg(t.amount) as avg_transaction
from account a
inner join transactions_clean t
on a.account_id=t.account_id
group by  a.account_type;	


-- Account Type-wise Credit vs Withdrawal

select a.account_type,t.type as transction_type ,count(t.type) as type
from account a
inner join transactions_clean t
on a.account_id=t.account_id
group by  a.account_type,t.type;	


-- Account Type-wise Current/Latest Balance

-- logic
-- find latest transaction for each account_id 
-- use balance on latest transaction
-- then join to account table
-- analyse balance account type wise

WITH temp AS (
    SELECT
        account_id,
        balance,
        ROW_NUMBER() OVER (
            PARTITION BY account_id
            ORDER BY `date` DESC, trans_id DESC
        ) AS rn
    FROM transactions_clean
)
SELECT
    a.account_type,
    SUM(t.balance) AS latest_balance
FROM temp t
INNER JOIN account a
    ON t.account_id = a.account_id
WHERE t.rn = 1
GROUP BY a.account_type
ORDER BY latest_balance DESC;


SELECT 
    account_id,
    `date`,
    COUNT(*) AS transaction_count
FROM transactions_clean
GROUP BY account_id, `date`
HAVING COUNT(*) > 1;

-- Q4 	Which types of cards are most frequently used by the bank's clients and what is the 
 -- overall profitability of the credit card business? 


-- Card Type Distribution 
select type,count(type) from card
group by type;

-- Card Type-wise Issuance Trend 

select year(issued),type,count(issued)as card_issued_by_year from card
group by year(issued),type;

-- Credit Card Transaction Activity

select count(*)as credit_card_transactions from transactions_clean
where operation ="credit card withdrawal";

-- Credit Card Transaction Amount

select sum(amount)as transaction_amount from transactions_clean
where operation ="credit card withdrawal";

-- Year-wise Credit Card Transaction Activity

select year(`date`),count(*) as transaction_activity_by_year
from transactions_clean
where operation ="credit card withdrawal"
group by year(`date`)
order by transaction_activity_by_year desc;



-- Q5 “What are the major expenses of the bank and how can they be reduced to improve profitability?”

-- Transaction Type-wise Expense Amount

select type,sum(amount)as total_expense from transactions_clean
where type="withdrawal"
group by type;
-- 6.3 billon amount withdrawal

-- Operation-wise Expense Amount
select operation,sum(amount)as total_amount_by_operation from transactions_clean
where type="withdrawal"
group by operation
order by total_amount_by_operation desc;

-- Year-wise Expense/Withdrawal Trend

select year(`date`)as transaction_year,sum(amount)as total_expense
from transactions_clean 
where type = 'Withdrawal'
group by year(`date`)
order by total_expense;


-- Year-wise Major Expense/Operation

select year(`date`),operation,sum(amount)as total_expense
from transactions_clean
where type="withdrawal"
group by year(`date`),operation
order by total_expense desc;


-- Q6 “What is the loan portfolio by purposes and client segments?”

select * from loan limit 1;

-- total_loan_amount
select sum(amount)as total_loan_amount from loan;

-- Loan Status-wise Distribution.

select status,count(loan_id)as total_loan_count
from loan
group by status
order by total_loan_count desc;

-- Loan Amount by Status 	

select status,sum(amount)as total_loan_amount
from loan
group by status
order by total_loan_amount desc;

-- average loan amount by status

select status,avg(amount)as average_loan_amount
from loan
group by status
order by average_loan_amount desc;

-- business_insight 
-- Client in debt category has the highest average loan amount, while Contract Finished has the lowest.



-- Loan Portfolio by Client Segment
 
 select c.sex,count(l.loan_id)as loan_count,sum(l.amount)as total_loan_amount
 from loan l
 inner join account a
 on l.account_id=a.account_id
 inner join disposition d
 on a.account_id = d.account_id
 inner join client c
 on d.client_id = c.client_id
 where d.type='owner'
 group by c.sex
 order by total_loan_amount desc;
 






-- Q 7 “How can the bank improve customer service/satisfaction?”

-- Client-wise Transaction Activity

 select * from client limit 1;
 
 select c.client_id,
 count(t.trans_id) as number_of_transaction,
 sum(t.amount) as transaction_amount,
 avg(t.amount)as average_amount,
 max(t.date) as latest_transaction_date
 from client c
inner join disposition d 
on d.client_id=c.client_id
inner join account a
on d.account_id=a.account_id
inner join transactions_clean t
on t.account_id=a.account_id
where d.type='owner'
group by c.client_id
order by transaction_amount desc
limit 10;

-- Which customers have low transaction activity and may need better engagement or customer support?
-- Identify Inactive / Low-Activity Customers

 select c.client_id,
 count(t.trans_id) as number_of_transaction
 from client c
inner join disposition d 
on d.client_id=c.client_id
inner join account a
on d.account_id=a.account_id
inner join transactions_clean t
on t.account_id=a.account_id
where d.type='owner'
group by c.client_id
having count(t.trans_id)<100
order by number_of_transaction;


-- Truly Inactive Customers check
SELECT 
    c.client_id,
    COUNT(t.trans_id) AS number_of_transaction
FROM client c
INNER JOIN disposition d
    ON d.client_id = c.client_id
    AND d.type = 'OWNER'
INNER JOIN account a
    ON d.account_id = a.account_id
LEFT JOIN transactions_clean t
    ON t.account_id = a.account_id
GROUP BY c.client_id
HAVING COUNT(t.trans_id) = 0
ORDER BY c.client_id;

-- No truly inactive customers were identified based on zero transaction activity.





-- High-Value vs Low-Value Customers

 select c.client_id,
 count(t.trans_id) as number_of_transaction,
 sum(t.amount) as transaction_amount,
 avg(t.amount)as average_amount
from client c
inner join disposition d 
on d.client_id=c.client_id
inner join account a
on d.account_id=a.account_id
inner join transactions_clean t
on t.account_id=a.account_id
where d.type='owner'
group by c.client_id
order by transaction_amount desc
limit 10;


-- How effectively is the bank serving customers who have loans?

 select c.client_id,
 count(l.loan_id) as number_of_loan,
 sum(l.amount) as transaction_loan_amount,
 avg(l.amount)as average_loan_amount
from client c
inner join disposition d 
on d.client_id=c.client_id
inner join account a
on d.account_id=a.account_id
inner join loan l
on l.account_id=a.account_id
where d.type='owner'
group by c.client_id
order by transaction_loan_amount desc
limit 20;




-- Which loan statuses require more attention from the bank?
-- Loan Status-wise Customer Analysis

 SELECT
    l.status,
    COUNT(l.loan_id) AS number_of_loans,
    SUM(l.amount) AS total_loan_amount,
    ROUND(AVG(l.amount), 2) AS average_loan_amount
FROM loan l
GROUP BY l.status
ORDER BY total_loan_amount DESC;




-- Card Type-wise Analysis
SELECT
    type AS card_type,
    COUNT(card_id) AS number_of_cards
FROM card
GROUP BY type
ORDER BY number_of_cards DESC;

-- Card Type + Customer Distribution
SELECT
    c.type AS card_type,
    COUNT(DISTINCT d.client_id) AS number_of_customers
FROM card c
INNER JOIN disposition d
    ON c.disp_id = d.disp_id
GROUP BY c.type
ORDER BY number_of_customers DESC;




-- 8.	Can the bank introduce new financial products or services to attract more customers and increase profitability? 

-- Existing customer behavior → Existing products usage → Gap identify  → New product/service recommendation

-- Customer-wise Existing Product Usage

select c.client_id,count(distinct a.account_id) as number_of_account,count(distinct l.loan_id) as number_of_loan,
count(distinct ca.card_id)as number_of_card
from client c
inner join disposition d
on c.client_id=d.client_id
left join account a
on a.account_id=d.account_id
left join loan l
on l.account_id=a.account_id
left join card ca
on ca.disp_id=d.disp_id
where d.type='owner'
group by c.client_id
order by c.client_id;



-- product_wise_category

-- account-loan_card
-- loan 0,card 0 -accounts only
-- loan >0,card 0 - accounts+loan
-- loan 0, card >0 - accounts +card
-- loan>0,card,0-acoount+loan+card  
select product_category,
count(*) as number_of_customers
from(
select client_id,case
when number_of_loan=0 and  number_of_card=0 then 'account only'
when number_of_loan>0 and  number_of_card=0 then 'account + loan'
when number_of_loan=0 and  number_of_card>0 then 'account + card'
when number_of_loan>0 and  number_of_card>0 then 'account + loan + card'
end as product_category
from
(select c.client_id,count(distinct a.account_id) as number_of_account,count(distinct l.loan_id) as number_of_loan,
count(distinct ca.card_id)as number_of_card
from client c
inner join disposition d
on c.client_id=d.client_id
left join account a
on a.account_id=d.account_id
left join loan l
on l.account_id=a.account_id
left join card ca
on ca.disp_id=d.disp_id
where d.type='owner'
group by c.client_id)as customer_products
) as categorized_customers
group by product_category
order by number_of_customers desc;



-- Customer Segment-wise Product Opportunity

     -- Gender-wise Product Adoption
     
select c.sex ,count(distinct c.client_id) as number_of_customers,count(distinct l.loan_id) as number_of_loan,
count(distinct ca.card_id)as number_of_card
from client c
inner join disposition d
on c.client_id=d.client_id
left join account a
on a.account_id=d.account_id
left join loan l
on l.account_id=a.account_id
left join card ca
on ca.disp_id=d.disp_id
where d.type='owner'
group by c.sex
order by number_of_customers;

-- Final New Product / Service Recommendations

with customer_age as
(
    select
        client_id,
        timestampdiff(YEAR, birth_date, CURDATE()) as client_age
    from client
),
customer_segment as
(
    select
        client_id,
        case
            when client_age < 14 then 'Children'
            when client_age between 14 and 18 then 'Teenager'
            when client_age between 19 and 30 then 'Young Adults'
            when client_age between 31 and 45 then 'Adults'
            when client_age between 46 and 60 then 'Middle-Aged'
            when client_age >= 61 then 'Senior Citizen'
        end as age_group
    from customer_age
),
product_usage as(
select
    cs.age_group,
    COUNT(distinct cs.client_id) AS number_of_customers,
    COUNT(distinct l.loan_id) AS number_of_loans,
    COUNT(distinct ca.card_id) AS number_of_cards
from customer_segment cs
inner join disposition d
    on cs.client_id = d.client_id
left join account a
    ON a.account_id = d.account_id
left join loan l
    on l.account_id = a.account_id
left join card ca
    on ca.disp_id = d.disp_id
    where d.type='owner'
group by cs.age_group
)
select age_group,number_of_customers,number_of_loans,
    round(number_of_loans * 100.0 / number_of_customers, 2) as loan_penetration,
    number_of_cards,
    round(number_of_cards * 100.0 / number_of_customers, 2) as card_penetration
from product_usage
order by number_of_customers desc;

-- business_insight

-- Senior Citizens have the lowest loan and card adoption.
-- Young Adults show better card adoption than loan adoption.
-- Adults have the highest loan penetration.
-- The bank can use age-based offers to increase product adoption.
-- Senior Citizens can be targeted with suitable banking and financial products.

-- conclusion

-- The bank can use age-based customer segments to offer suitable products and increase product adoption and profitability.

