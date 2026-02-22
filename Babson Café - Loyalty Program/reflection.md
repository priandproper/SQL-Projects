# Reflection – Babson Bean Café Database Project  
**Student:** Priyanka Tambe  

This project allowed me to experience the complete process of relational database creation, from modeling and data generation to querying and analysis. Coming from a marketing and product strategy background, I had primarily worked with dashboards and analytics tools rather than raw databases. Building the Babson Bean Café database helped me understand how structured data is created, cleaned, and connected before it reaches visualization or decision-making stages. I learned how to translate a real business scenario into a structured, normalized database that ensures accuracy and consistency. Designing relationships between entities such as Customers, Orders, Employees, Menu_Items, and Order_Items taught me how primary and foreign keys enforce referential integrity. I also gained appreciation for thoughtful schema design decisions such as setting constraints, defining data types, and ensuring unique identifiers, which ultimately determine the reliability of analytical results.

From an SQL perspective, I became comfortable writing queries that not only retrieve data but also answer business questions. I practiced joins, aggregations, subqueries, and filtering logic while building analytics like top-selling products, high-value customers, and monthly sales trends. Working in SQLite through DBeaver improved my ability to debug syntax errors, validate results through row counts, and confirm data quality through integrity checks.

AI played a helpful but supporting role in my workflow. I used ChatGPT to structure my SQL queries, explain relational modeling concepts, format Markdown documentation, and resolve import errors in DBeaver. It helped speed up repetitive troubleshooting and gave me clarity on syntax issues. However, AI occasionally produced MySQL-specific code or JOIN conditions that were incompatible with SQLite. It also generated an incorrect version of the WHERE clause when filtering by month, which I identified and fixed through testing.

---

### Key Prompts and Validation
1. “Write a SQL query to find the top 3 best-selling items by quantity for the last month.” – Validated in DBeaver by checking the SUM outputs.  
2. “Explain how to enforce foreign keys in SQLite.” – Verified with `PRAGMA foreign_keys = ON;`.  
3. “Generate Markdown project documentation summarizing ERD and imports.” – Reviewed for accuracy and adjusted table names.  
4. “Help debug CSV import errors in DBeaver.” – Cross-checked column mappings manually.  
5. “Write queries for customer segmentation based on loyalty points.” – Modified JOIN logic after previewing incorrect row counts.

---

### AI Errors Corrected
- AI generated a DDL script that initially failed because of foreign key constraint violations during CSV import. I fixed it by creating and importing parent tables before child tables.  
- AI suggested an INNER JOIN order that caused missing rows, which I corrected by reversing the join direction.  
- AI recommended the `DATETIME()` function, which is unsupported in SQLite, and I replaced it with `date()`.

---

If I repeated this project, I would automate validation queries for integrity checks, plan the ERD earlier, and use AI mainly for optimization and review rather than initial query drafting.
