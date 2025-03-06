-- Real-world Business Problems and SQL Solutions

-- 1. Identifying peak hours for ticket inflow
SELECT EXTRACT(HOUR FROM interaction_time) AS hour, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY hour
ORDER BY ticket_count DESC;

-- 2. Detecting underperforming support channels
SELECT interaction_type, 
    COUNT(*) AS ticket_count, 
    AVG(resolution_time_days) AS avg_resolution_time,
    (SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_violation_rate
FROM call_center_data
GROUP BY interaction_type
ORDER BY sla_violation_rate DESC;

-- 3. Identifying customers with unresolved issues
SELECT customer_id, COUNT(*) AS unresolved_tickets
FROM call_center_data
WHERE sla_met = 'No'
GROUP BY customer_id
ORDER BY unresolved_tickets DESC;

-- 4. Analyzing category-based issue trends
SELECT category, COUNT(*) AS ticket_count, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY category
ORDER BY ticket_count DESC;

-- 5. Evaluating month-over-month performance improvement
SELECT 
    DATE_TRUNC('month', interaction_date) AS month,
    COUNT(*) AS total_tickets,
    AVG(resolution_time_days) AS avg_resolution_time,
    (SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS sla_compliance_rate
FROM call_center_data
GROUP BY month
ORDER BY month;

-- 6. Detecting high-value customers with frequent issues
SELECT customer_id, COUNT(*) AS issue_count
FROM call_center_data
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY issue_count DESC;

-- 7. Finding the impact of ticket priority on resolution time
SELECT priority, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY priority
ORDER BY avg_resolution_time DESC;

-- 8. Predicting seasonal ticket volume trends
SELECT DATE_TRUNC('month', interaction_date) AS month, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY month
ORDER BY month;

-- 9. What percentage of customers report multiple issues?
SELECT 
    (COUNT(DISTINCT customer_id) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM call_center_data)) AS repeat_customer_rate
FROM call_center_data
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 10. What is the resolution time variance between working and non-working hours?
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM interaction_time) BETWEEN 9 AND 18 THEN 'Working Hours'
        ELSE 'After Hours'
    END AS time_period,
    AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY time_period;

-- 11. What is the most common complaint category by region?
SELECT region, category, COUNT(*) AS issue_count
FROM call_center_data
GROUP BY region, category
ORDER BY region, issue_count DESC;

-- 12. Analyzing the impact of agent experience on resolution time
SELECT agent_id, AVG(resolution_time_days) AS avg_resolution_time, COUNT(*) AS tickets_handled
FROM call_center_data
GROUP BY agent_id
ORDER BY tickets_handled DESC;

-- 13. What is the ticket resolution efficiency per agent?
SELECT agent_id, COUNT(*) AS tickets_resolved, AVG(resolution_time_days) AS avg_resolution_time
FROM call_center_data
GROUP BY agent_id
ORDER BY tickets_resolved DESC;

-- 14. Identifying the busiest support days in a year
SELECT DATE_TRUNC('day', interaction_date) AS day, COUNT(*) AS ticket_count
FROM call_center_data
GROUP BY day
ORDER BY ticket_count DESC
LIMIT 10;

-- 15. How many customers are affected by repeated SLA breaches?
SELECT customer_id, COUNT(*) AS sla_breach_count
FROM call_center_data
WHERE sla_met = 'No'
GROUP BY customer_id
HAVING COUNT(*) > 2
ORDER BY sla_breach_count DESC;
