# Pulse University Music Festival – Database Project (2024-2025)
# Team 29
# Benas Georgios - 03122895 
# Therqaj Kristian - 03121905
# Monanteros Fotios - 03121912


## Overview

This project implements a relational database system for the **Pulse University International Music Festival**, supporting the organization, operation, and evaluation of multi-day, multi-venue musical events held annually across the globe.

The system is designed in accordance with the specification provided by the **National Technical University of Athens (NTUA), School of ECE**, for the 6th-semester course **Database Systems (Βάσεις Δεδομένων)**.

---

## Folder Structure


├── README.md ← This documentation file
├── diagrams/
│ ├── er.pdf ← (ER) Diagram
│ └── relational.pdf ← Relational Schema Diagram
├── sql/
│ ├── install.sql ← Schema creation script (DDL)
│ ├── load.sql ← Data population script (DML)
│ ├── Q01.sql - Q15.sql ← SQL queries for the specified tasks
│ └── Q01_out.txt - Q15_out.txt ← Corresponding RDBMS outputs
├── docs/
   └── report.pdf ← Report with methodology, screenshots, and justification


---

## System Design

### Entities Modeled

- **Location**: Stores geographic and administrative information (name, address, city, country, continent, coordinates) for each venue. 
- **Festival**: Represents each annual edition of the Pulse University festival, including year, image, and associated location.
- **Stage**: Physical performance area within a location, with a description, capacity, and linked technical infrastructure.
- **Event**: A daily show within a festival that takes place on a specific stage and contains sequential performances.
- **Artist**: Individual performers with names, pseudonym, birthdate, genres/subgenres, and optional online profiles and image.
- **Band**: Musical groups with metadata such as name, formation date, and social links.
- **Artist_Band**: Associative entity linking artists to bands (many-to-many relationship).
- **Performance_Type**: Defines the type of performance (e.g., Warm-up, Headline, Guest).
- **Performance**: A scheduled appearance of an artist or band during an event, with type, start time, and duration. Ensures mutual exclusivity of artist/band and scheduling constraints.
- **Visitor**: Ticket buyers or attendees, storing contact details and age.
- **Ticket_Category**: Different types of tickets offered (e.g., General, VIP, Backstage).
- **Payment_Method**: Payment method used for ticket purchases (e.g., credit card, debit card, bank account).
- **Ticket**: A record of a visitor’s entry to a specific event, containing pricing, category, payment, EAN-13 code, and activation status.
- **Review**: Ratings submitted by visitors on Likert scale across criteria like performance, sound/light, organization, and overall experience.  
- **Resale_Status**: Status of a resale ticket (e.g., Available, Sold).
- **Resale Queue**: Queueing system for resale tickets, operating FIFO for buyers/sellers with automatic matching.
- **Staff_Role**: Classification of staff members (e.g., Technician, Security, Support).
- **Experience_Level**: Numeric indication of staff experience for eligibility checks (e.g., novice to expert).
- **Staff**: Personnel assigned to events with specific roles and experience levels.
- **Employment**: Assignment of staff to specific events, ensuring constraints on maximum daily workload and skill coverage.
- **Equipment_Type**: Classification of equipment (e.g., audio, lighting, special effects).
- **Equipment**: Details about available equipment including type, description, and quantity.
- **Stage_Equipment**: Relationship between stages and required equipment per stage, with quantity specifications.

### Constraints & Features

- Foreign key constraints and integrity rules.
- Domain and business logic constraints:
  - Artists can't perform simultaneously.
  - Technical staff max 2/day.
  - One ticket per visitor/day/event.
  - VIP ticket limits (10%).
  - Automatic handling of resale queues.
- Activation system upon ticket scan.

---

## SQL Queries

Includes the following analysis and report queries:

1. Annual ticket revenue by category and payment method.
2. Artists by genre with yearly participation flag.
3. Warm-up artists appearing >2 times in the same festival.
4. Average performance and overall score for a given artist. *(+ optimizer traces)*
5. Most recurring young artists (<30 years).
6. Visitor-specific average review by event. *(+ optimizer traces)*
7. Festival with lowest average staff experience.
8. Staff with no assignment on a specific date.
9. Visitors attending exactly the same number of shows (>3) in a year.
10. Top-3 genre pair combinations appearing together in festivals.
11. Artists with at least 5 fewer appearances than the most recurring one.
12. Daily staff requirements by category (tech/security/support).
13. Artists who performed on ≥3 different continents.
14. Genres with same appearances in 2 consecutive years (≥3 each year).
15. Top-5 visitors with highest total ratings given to a single artist.

---

## Technologies Used

- **DBMS**: MySQL Workbench
- **SQL**: Strictly relational queries (no JSON, ENUMs, or arrays)
- **Diagramming**: Draw.io

---

## Notes & Constraints

- Queries must be executable and return non-empty results to be graded.
- All constraints (functional, temporal, business) are enforced via SQL triggers, checks, or logic.
- All images (e.g., artist photos, posters) are linked/stored as `LONGBLOB` with descriptions.
- No ORM frameworks permitted.

---

## Team - 29
- Full Name: Benas Georgios (03122895), Therqaj Kristian - 03121905, Fotis Monanteros(03121912)
- Email: f.monanteros@gmail.com
- Semester: Spring 2024-2025
