# Seed Data — Babson Bean Café

This folder contains the synthetic datasets generated for the Babson Bean Café database project.  
All data was created using [Mockaroo](https://mockaroo.com) to align with the ERD and business logic of the café.  
The goal is to provide realistic sample data for testing and querying in SQL.

---

## Files Overview

| File | Rows | Description | Key Fields | Notes |
|------|------|--------------|-------------|-------|
| **customers.csv** | 150 | Loyalty program customers | `customer_id`, `first_name`, `last_name`, `email`, `phone`, `loyalty_points`, `join_date` | Join dates range from 2022–2025. Loyalty points scaled 0–600. |
| **employees.csv** | 12 | Café staff (Baristas and Managers) | `employee_id`, `first_name`, `last_name`, `role`, `hire_date`, `hourly_wage` | Weighted 3:1 ratio of Baristas to Managers; wages $16–28/hr. |
| **menu_item.csv** | 15 | Active menu items | `item_id`, `item_name`, `category`, `price`, `cost`, `is_active` | Includes coffee, bakery, and other drinks; prices range $3–9, costs range $1–3. |
| **orders.csv** | 400 | Customer transactions | `order_id`, `customer_id`, `employee_id`, `order_datetime`, `payment_method`, `order_channel`, `coupon_code`, `campaign_name`, `points_redeemed`, `order_total` | Foreign keys link to customers and employees. Payment mix: card, cash, mobile. Order period: Sept–Oct 2025. |
| **order_items.csv** | 800 | Line-items per order | `order_item_id`, `order_id`, `item_id`, `quantity`, `subtotal` | Represents the specific items per order. Subtotal = price × quantity. |

---

## Data Generation Notes

- **Parent entities** (`customers`, `employees`, `menu_item`) were generated **first**, followed by **child entities** (`orders`, `order_items`).
- **Foreign key ranges** were manually aligned:
  - `customer_id` → 1–150  
  - `employee_id` → 1–12  
  - `item_id` → 1–15  
- **Weighted distributions** were applied for realism:
  - Roles: Baristas appear more frequently than Managers  
  - Payment methods: Card most frequent, followed by Cash and Mobile  
  - Order channel: In-store more common than App orders  
- **Blank fields** (≈10–20%) were intentionally included to simulate real-world missing data (e.g., coupon code or points redeemed).
- **Date ranges**:
  - Customer join dates → 2022–2025  
  - Employee hire dates → 2022–2025  
  - Orders → September–October 2025  
- **Currency precision:** all prices, costs, and wages have two decimal places.
- **Boolean flags:** `is_active` marks currently available menu items.

---

## Version & Tools
- Generated with: **Mockaroo**  
- Created: **October 2025**


---

## Purpose
This seed data supports SQL development, testing, and analysis of sales, employee performance, and customer engagement for the Babson Bean Café database project.
