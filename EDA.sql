-- EDA on the Call Center Data

-- 1. What is the total number of interactions?
SELECT COUNT(*) AS total_interactions FROM call_center_data;

-- 2. Breakdown of interactions by type (calls, emails, chats)
SELECT interaction_type, COUNT(*) AS interaction_count
FROM call_center_data
GROUP BY interaction_type;

-- 3. Which category has the highest number of tickets?
SELECT category, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY category
ORDER BY ticket_count DESC
LIMIT 1;

-- 4. What is the average resolution time for each interaction type?
SELECT interaction_type, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY interaction_type;

-- 5. Monthly trend of ticket volumes
SELECT DATE_TRUNC('month', interaction_date) AS month, COUNT(*) AS total_tickets
FROM call_center_data
GROUP BY month
ORDER BY month;

-- 6. What is the SLA compliance rate per interaction type?
SELECT interaction_type, 
       (SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_compliance_rate
FROM call_center_data
GROUP BY interaction_type;

-- 7. What are the top 5 ticket categories based on volume?
SELECT category, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY category
ORDER BY ticket_count DESC
LIMIT 5;

-- 8. How does resolution time vary by category?
SELECT category, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY category
ORDER BY avg_resolution_time DESC;

-- 9. What percentage of tickets are resolved within SLA?
SELECT (SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS overall_sla_compliance_rate
FROM call_center_data;

-- 10. How many tickets were logged per weekday?
SELECT EXTRACT(DOW FROM interaction_date) AS day_of_week, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY day_of_week
ORDER BY ticket_count DESC;

-- 11. How many interactions happened outside working hours (9 AM - 6 PM)?
SELECT COUNT(*) AS after_hours_tickets
FROM call_center_data
WHERE EXTRACT(HOUR FROM interaction_time) NOT BETWEEN 9 AND 18;

-- 12. What is the ticket resolution distribution (min, max, avg)?
SELECT 
    MIN(resolution_time_days) AS min_resolution_time,
    MAX(resolution_time_days) AS max_resolution_time,
    AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data;

-- 13. Which interaction type has the most SLA breaches?
SELECT interaction_type, COUNT(*) AS sla_breaches
FROM call_center_data
WHERE sla_met = 'No'
GROUP BY interaction_type
ORDER BY sla_breaches DESC;

-- 14. What are the top customer complaints based on issue category?
SELECT category, COUNT(*) AS complaint_count
FROM call_center_data
GROUP BY category
ORDER BY complaint_count DESC
LIMIT 5;

-- 15. How many repeat customers have logged more than 3 tickets?
SELECT customer_id, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY customer_id
HAVING COUNT(*) > 3
ORDER BY ticket_count DESC;
