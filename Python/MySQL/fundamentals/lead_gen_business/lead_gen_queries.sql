-- 1. What query would you run to get the total revenue for March of 2012? //35646 
SELECT MONTHNAME(billing.charged_datetime) AS month, SUM(amount) 
FROM billing 
WHERE MONTH(billing.charged_datetime) = 3 AND YEAR(billing.charged_datetime) = 2012; 

-- Todd's answer 
SELECT DATE_FORMAT(billing.charged_datetime, '%M') AS 'month', SUM(amount) as total_revenue
FROM billing
WHERE MONTH(billing.charged_datetime) = 3
	AND YEAR(billing.charged_datetime) = 2012;

-- 2. What query would you run to get total revenue collected from the client with an id of 2? //18639 
SELECT SUM(amount)
FROM billing 
JOIN clients ON billing.client_id = clients.client_id 
WHERE clients.client_id = 2; 

-- Todd's answer 
SELECT billing.client_id, SUM(billing.amount) as total_revenue
FROM billing
WHERE billing.client_id = 2;

-- 3. What query would you run to get all the sites that client=10 owns?
SELECT sites.site_id, sites.domain_name
FROM sites 
JOIN clients ON sites.client_id = clients.client_id 
WHERE clients.client_id = 10; 

-- Todd's answer 
SELECT sites.domain_name, sites.client_id
FROM sites
WHERE sites.client_id = 10;

-- 4. What query would you run to get total # of sites created per month per year for the client with an id of 1? What about for client=20?
SELECT client_id, DATE_FORMAT(created_datetime, '%M') AS 'month', DATE_FORMAT(created_datetime, '%Y') AS'year', COUNT(sites.site_id) AS number_of_sites
FROM sites 
WHERE sites.client_id = 1
GROUP BY month, year; 

SELECT client_id, DATE_FORMAT(created_datetime, '%M') AS month, DATE_FORMAT(created_datetime, '%Y') AS year, COUNT(sites.site_id) AS num_sites 
FROM sites 
WHERE sites.client_id = 20 
GROUP BY month, year; 

-- Todd's answer 
SELECT sites.client_id, COUNT(sites.site_id) as num_sites, DATE_FORMAT(sites.created_datetime, '%M') AS month_created, DATE_FORMAT(sites.created_datetime, '%Y') AS year_created
FROM sites
WHERE sites.client_id = 1
GROUP BY month_created, year_created;

SELECT leads.registered_datetime FROM leads; 

SELECT sites.client_id, DATE_FORMAT(sites.created_datetime, '%M') AS month_created, DATE_FORMAT(sites.created_datetime, '%Y') AS year_created, COUNT(sites.site_id) as num_sites
FROM sites
WHERE sites.client_id = 20
GROUP BY month_created, year_created;

-- 5. What query would you run to get the total # of leads generated for each of the sites between January 1, 2011 to February 15, 2011?
SELECT sites.domain_name, COUNT(leads_id) AS number_of_leads, registered_datetime
FROM leads 
LEFT JOIN sites ON leads.site_id = sites.site_id 
WHERE registered_datetime BETWEEN '2011-01-01' AND '2011-02-15'
GROUP BY sites.domain_name; 

-- Todd's answer 
SELECT sites.domain_name, COUNT(leads.leads_id) AS num_leads, DATE_FORMAT(leads.registered_datetime, '%M %d, %Y') AS date_registered
FROM sites
	LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-02-15'
GROUP BY sites.site_id;

-- 6. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients between January 1, 2011 to December 31, 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, sites.domain_name, COUNT(leads.leads_id) AS number_of_leads, registered_datetime
FROM clients 
	LEFT JOIN sites ON clients.client_id = sites.client_id 
    LEFT JOIN leads ON sites.site_id = leads.site_id 
WHERE registered_datetime BETWEEN '2011-01-01' AND '2011-12-31' 
GROUP BY sites.domain_name 
ORDER BY client_name; 

-- Todd's answer: 
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, sites.domain_name, COUNT(leads.leads_id) AS num_leads, DATE_FORMAT(leads.registered_datetime, '%M %d, %Y') AS date_generated
FROM clients
	JOIN sites ON clients.client_id = sites.client_id
    LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY sites.domain_name
ORDER BY clients.client_id;

-- 7. What query would you run to get a list of client names and the total # of leads we've generated for each client each month between months 1 - 6 of Year 2011?
SELECT clients.client_id, CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, DATE_FORMAT(registered_datetime, '%M') AS date_generated, COUNT(leads_id) AS num_of_leads
FROM clients 
	JOIN sites ON clients.client_id = sites.client_id 
    LEFT JOIN leads ON sites.site_id = leads.site_id 
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-06-30' 
GROUP BY MONTH(registered_datetime), clients.client_id 
ORDER BY MONTH(registered_datetime); 

-- Todd's answer
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, COUNT(leads.leads_id) AS num_leads, DATE_FORMAT(leads.registered_datetime, '%M') AS 'month'
FROM clients
	LEFT JOIN sites ON clients.client_id = sites.client_id
    JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-06-30'
GROUP BY clients.client_id, MONTH(leads.registered_datetime)
ORDER BY MONTH(leads.registered_datetime);

-- 8. What query would you run to get a list of client names and the total # of leads we've generated for each of our clients' sites between January 1, 2011 to December 31, 2011? 
-- Order this query by client id.  Come up with a second query that shows all the clients, the site name(s), and the total number of leads generated from each site for all time.
SELECT clients.client_id, sites.domain_name, COUNT(leads_id) 
FROM clients 
	LEFT JOIN sites ON clients.client_id = sites.client_id 
    LEFT JOIN leads ON sites.site_id = leads.site_id 
WHERE registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY sites.domain_name 
ORDER BY clients.client_id; 

-- Todd's answer 
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, sites.domain_name, COUNT(leads.leads_id) AS num_leads, DATE_FORMAT(leads.registered_datetime, '%M %d, %Y') AS date_generated
FROM clients
	JOIN sites ON clients.client_id = sites.client_id
    LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE leads.registered_datetime BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY sites.domain_name
ORDER BY clients.client_id;

-- 9. Write a single query that retrieves total revenue collected from each client for each month of the year. Order it by client id.
SELECT clients.client_id, CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, MONTH(charged_datetime), YEAR(charged_datetime), SUM(amount) as monthly_revenue  
FROM billing
	LEFT JOIN clients ON billing.client_id = clients.client_id
GROUP BY YEAR(charged_datetime), clients.client_id, MONTH(charged_datetime)
ORDER BY clients.client_id, YEAR(charged_datetime), MONTH(charged_datetime); 

-- Todd's answer 
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, SUM(billing.amount) AS monthly_revenue, DATE_FORMAT(billing.charged_datetime, '%M') AS 'month', DATE_FORMAT(billing.charged_datetime, '%Y') AS 'year'
FROM clients
	LEFT JOIN billing ON clients.client_id = billing.client_id
GROUP BY client_name, MONTH(billing.charged_datetime), YEAR(billing.charged_datetime)
ORDER BY clients.client_id; 

-- 10. Write a single query that retrieves all the sites that each client owns. 
-- Group the results so that each row shows a new client. It will become clearer when you add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
SELECT clients.client_id, CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, GROUP_CONCAT(sites.domain_name) AS sites 
FROM clients  -- put this as left table so it pulls up ALL the clients *including* those that don't have a site. 
LEFT JOIN sites ON sites.client_id = clients.client_id
GROUP BY client_id; 

-- Todd's answer
SELECT CONCAT(clients.first_name, ' ', clients.last_name) AS client_name, GROUP_CONCAT(sites.domain_name) AS 'sites'
FROM clients
	LEFT JOIN sites ON clients.client_id = sites.client_id
GROUP BY clients.client_id;