# SQL_MUSIC_STORE_DATABASE

# Music Store Database Analysis

## Project Overview

This project contains SQL queries designed to analyze a simulated music store database. The queries aim to extract valuable business insights from various aspects of the music store's operations, including employee data, customer purchasing habits, and sales performance across different geographical locations. The goal is to answer key business questions that can help in decision-making, such as identifying top customers, best-performing regions, and senior staff.

## Database Schema (Assumed)

For these queries to function correctly, the underlying database is assumed to have a schema similar to the following, typical for a music store application:

  * **`Employee`**: Stores information about employees, including their `employee_id`, `first_name`, `last_name`, `title`, and `levels` (likely indicating seniority or hierarchy).
  * **`Customer`**: Holds details about customers, such as `customer_id`, `first_name`, `last_name`, `email`, `city`, and `country`.
  * **`Invoice`**: Contains invoice details, including `invoice_id`, `customer_id` (foreign key to `Customer`), `invoice_date`, `billing_address`, `billing_city`, `billing_state`, `billing_country`, and `total` invoice amount.
  * **`InvoiceLine`**: Links invoices to tracks, containing `invoice_line_id`, `invoice_id` (foreign key to `Invoice`), `track_id` (foreign key to `Track`), `unit_price`, and `quantity`.
  * **`Track`**: Details about individual music tracks, including `track_id`, `name`, `album_id`, `media_type_id`, `genre_id`, `composer`, `milliseconds`, `bytes`, and `unit_price`.
  * **`Album`**: Information about music albums, with `album_id`, `title`, and `artist_id` (foreign key to `Artist`).
  * **`Artist`**: Details about music artists, with `artist_id` and `name`.
  * **`Genre`**: Categories for music genres, with `genre_id` and `name`.
  * **`MediaType`**: Types of media (e.g., MPEG audio file, protected AAC audio file), with `media_type_id` and `name`.

*(Note: While the provided queries directly use `Employee`, `Invoice`, and `Customer` tables, the full schema is typically more extensive to support all aspects of a music store.)*

## SQL Queries and Insights

The project includes a set of SQL queries designed to answer specific business questions. Each query is provided with a clear explanation of its purpose.

### Set 1: Foundational Business Questions

This set of queries focuses on extracting core insights related to employees, sales by country, top-value invoices, best-performing cities, and identifying the most valuable customer.

1.  **Who is the senior-most employee based on job title?**

      * **Purpose:** To identify the employee with the highest seniority level within the company, often useful for organizational hierarchy understanding.
      * **Query:**
        ```sql
        SELECT *
        FROM employee
        ORDER BY levels DESC
        LIMIT 1;
        ```
      * **Insight:** Helps in understanding the organizational structure and identifying key personnel.

2.  **Which countries have the most invoices?**

      * **Purpose:** To determine which countries generate the highest volume of sales transactions. This can indicate strong markets or areas needing more attention.
      * **Query:**
        ```sql
        SELECT count(*) AS c, billing_country
        FROM invoice
        GROUP BY billing_country
        ORDER BY c DESC;
        ```
      * **Insight:** Identifies the top-performing countries in terms of sales activity, guiding potential market expansion or targeted marketing efforts.

3.  **What are the top 3 values of total invoices?**

      * **Purpose:** To quickly see the highest individual transaction amounts, which can highlight large purchases or premium customers.
      * **Query:**
        ```sql
        SELECT total
        FROM invoice
        ORDER BY total DESC
        LIMIT 3;
        ```
      * **Insight:** Provides a snapshot of high-value transactions, potentially revealing patterns in high-spending customers or products.

4.  **Which city has the best customers? (Promotional Music Festival)**

      * **Purpose:** To identify the city that has generated the most revenue, specifically to inform decisions about where to host promotional events like a music festival for maximum impact.
      * **Query:**
        ```sql
        SELECT sum(total) AS invoice_totals, billing_city
        FROM invoice
        GROUP BY billing_city
        ORDER BY invoice_totals DESC;
        ```
      * **Insight:** Pinpoints the most lucrative cities, allowing for targeted marketing campaigns or event planning where customer engagement and spending are highest.

5.  **Who is the best customer?**

      * **Purpose:** To identify the individual customer who has spent the most money overall, crucial for loyalty programs, personalized offers, or special recognition.
      * **Query:**
        ```sql
        SELECT
            customer.customer_id,
            customer.first_name,
            customer.last_name,
            sum(invoice.total) AS total
        FROM customer
        JOIN invoice ON customer.customer_id = invoice.customer_id
        GROUP BY customer.customer_id, customer.first_name, customer.last_name
        ORDER BY total DESC
        LIMIT 1;
        ```
      * **Insight:** Highlights the most valuable customer, enabling businesses to focus on retention strategies or offer exclusive benefits to high spenders.
  
      * Here's the detailed breakdown for your "Set 2" queries, formatted to be easily added to your GitHub README under a new section.

-----

### Set 2: Advanced Customer & Music Analysis

This set of queries delves deeper into specific music genres, customer preferences, and track statistics.

1.  **Write a query to return the email, first name, last name, and genre of all Rock Music listeners. Return your list ordered alphabetically by email.**

      * **Purpose:** To identify customers who specifically listen to 'Rock' music. This information can be valuable for targeted marketing campaigns related to rock music events, new album releases, or merchandise.
      * **Queries Provided:**
          * **Subquery Approach (Recommended):** This approach first identifies all `track_id`s that belong to the 'Rock' genre and then filters invoices and customers based on these tracks.
            ```sql
            SELECT DISTINCT email, first_name, last_name
            FROM customer
            JOIN invoice ON customer.customer_id = invoice.customer_id
            JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
            WHERE track_id IN (
                SELECT track_id
                FROM track
                JOIN genre ON track.genre_id = genre.genre_id
                WHERE genre.name LIKE 'Rock'
            )
            ORDER BY email;
            ```
          * **Direct Join Approach (Also Valid and Often More Efficient):** This approach joins all necessary tables (`customer`, `invoice`, `invoice_line`, `track`, `genre`) directly and filters by genre name. This version also explicitly includes the `genre.name` in the select clause, which was requested in the question but missing in the first query.
            ```sql
            SELECT DISTINCT
                email AS Email,
                first_name AS fname,
                last_name AS lname,
                genre.name AS Name
            FROM customer
            JOIN invoice ON invoice.customer_id = customer.customer_id
            JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
            JOIN track ON track.track_id = invoice_line.track_id
            JOIN genre ON genre.genre_id = track.genre_id
            WHERE genre.name LIKE 'Rock'
            ORDER BY email;
            ```
      * **Insight:** Provides a clear list of 'Rock' music enthusiasts, enabling personalized outreach and improving customer engagement.

2.  **Let's invite the artists who have written the most Rock Music in our dataset. Write a query that returns the artist's name and total track count of the top 10 rock bands.**

      * **Purpose:** To identify the most prolific artists within the 'Rock' genre based on the number of tracks they have produced. This can inform decisions for inviting artists for events, collaborations, or promotions.
      * **Query:**
        ```sql
        SELECT
            artist.artist_id,
            artist.name,
            COUNT(artist.artist_id) AS number_of_songs
        FROM track
        JOIN album ON album.album_id = track.album_id
        JOIN artist ON album.artist_id = artist.artist_id
        JOIN genre ON genre.genre_id = track.genre_id
        WHERE genre.name LIKE 'Rock'
        GROUP BY artist.artist_id, artist.name -- Added artist.name to GROUP BY for consistency
        ORDER BY number_of_songs DESC
        LIMIT 10;
        ```
      * **Insight:** Highlights key artists in the 'Rock' genre who have significantly contributed to the music library, making them prime candidates for special events or features.

3.  **Return all the track names that have a length longer than the average song. Return the song name and the milliseconds for each track. Order by the song length with the longest song listed first.**

      * **Purpose:** To identify longer-duration tracks in the music library, which might be of interest to specific listener segments or for curation purposes.
      * **Query (Dynamic Average Calculation - Recommended):** This query uses a subquery to calculate the average track length dynamically, ensuring the comparison is always against the current average.
        ```sql
        SELECT name, milliseconds
        FROM track
        WHERE milliseconds > (
            SELECT AVG(milliseconds) AS avg_track_length
            FROM track
        )
        ORDER BY milliseconds DESC;
        ```
      * **Alternative Query (Static Average - Not Recommended for Dynamic Data):** This version uses a hardcoded average, which would only be accurate at the time it was written.
        ```sql
        SELECT name, milliseconds
        FROM track
        WHERE milliseconds > 393599 -- Example static average
        ORDER BY milliseconds DESC;
        ```
      * **Insight:** Helps in categorizing tracks by length, potentially useful for creating playlists (e.g., "long-play tracks") or analyzing listener engagement with different song durations.
  
      * Here's the detailed breakdown for your "Set 3" queries, formatted to be easily added to your GitHub README under the "SQL Queries and Insights" section.

Set 3: Advanced Business Metrics & Ranking

This set of queries tackles more complex business questions, involving Common Table Expressions (CTEs) and window functions to derive deeper insights and rankings, especially concerning customer spending on artists, popular genres per country, and top customers per country.

    Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name, and total amount spent.

        Purpose: To understand customer preferences for specific artists by showing how much each customer has spent on music by a particular artist. This can help in targeted marketing or artist promotion. The provided query specifically focuses on calculating spending on the best-selling artist in the dataset.

        Query:
        SQL

    WITH best_selling_artist AS (
        SELECT
            artist.artist_id AS artist_id,
            artist.name AS artist_name,
            SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
        FROM invoice_line
        JOIN track ON track.track_id = invoice_line.track_id
        JOIN album ON album.album_id = track.album_id
        JOIN artist ON artist.artist_id = album.artist_id
        GROUP BY 1
        ORDER BY 3 DESC
        LIMIT 1
    )
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        bsa.artist_name,
        SUM(il.unit_price * il.quantity) AS amount_spent
    FROM invoice i
    JOIN customer c ON c.customer_id = i.customer_id
    JOIN invoice_line il ON il.invoice_id = i.invoice_id
    JOIN track t ON t.track_id = il.track_id
    JOIN album alb ON alb.album_id = t.album_id
    JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
    GROUP BY 1, 2, 3, 4
    ORDER BY 5 DESC;

    Insight: Identifies which customers are spending the most on the overall top-selling artist, allowing for special recognition or personalized offers related to that artist's new releases or tours.

We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top genre. For countries where the max no. of purchases is shared, return all genres.

    Purpose: To understand the dominant music preferences in different countries, which is vital for regional marketing, inventory management, and targeting content.

    Queries Provided:

        Using ROW_NUMBER() (Method 1): This method uses a window function to rank genres by purchases within each country. It efficiently selects the top genre(s) handling ties.
        SQL

WITH popular_genre AS (
    SELECT
        COUNT(invoice_line.quantity) AS purchases,
        customer.country,
        genre.name,
        genre.genre_id,
        ROW_NUMBER() OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS ROWNO
    FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON customer.customer_id = invoice.customer_id
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre ON genre.genre_id = track.genre_id
    GROUP BY 2, 3, 4
)
SELECT *
FROM popular_genre
WHERE ROWNO <= 1;

Using MAX() in a CTE (Method 2 - Recursive CTE Not Actually Used Here, but a Multi-CTE Approach): This approach calculates sales per genre per country in one CTE and then finds the maximum sales for each country in another, finally joining them to filter for the top genre(s). This method is robust for handling ties.
SQL

        WITH sales_per_country AS (
            SELECT
                COUNT(*) AS purchases_per_genre,
                customer.country,
                genre.name,
                genre.genre_id
            FROM invoice_line
            JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
            JOIN customer ON customer.customer_id = invoice.customer_id
            JOIN track ON track.track_id = invoice_line.track_id
            JOIN genre ON genre.genre_id = track.genre_id
            GROUP BY 2, 3, 4
        ),
        max_genre_per_country AS (
            SELECT
                MAX(purchases_per_genre) AS max_genre_number,
                country
            FROM sales_per_country
            GROUP BY 2
        )
        SELECT sales_per_country.*
        FROM sales_per_country
        JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
        WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;

    Insight: Critical for localizing business strategies, such as stocking popular genres in specific regions, tailoring advertising, or planning genre-specific events.

Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries that have spent the most amount shared, return all customers who have spent this money.

    Purpose: To identify the highest-spending customer(s) within each country. This is crucial for regional customer relationship management and targeted loyalty programs.

    Queries Provided:

        Using MAX() in a CTE (Method 1 - Recursive CTE Not Actually Used Here, but a Multi-CTE Approach): This approach calculates total spending per customer per country in one CTE and then finds the maximum spending for each country in another, finally joining them to filter for the top customer(s). This method correctly handles ties.
        SQL

WITH customer_with_country AS (
    SELECT
        customer.customer_id,
        first_name,
        last_name,
        billing_country,
        SUM(invoice.total) AS total_spending
    FROM invoice
    JOIN customer ON customer.customer_id = invoice.customer_id
    GROUP BY 1, 2, 3, 4
),
country_max_spending AS (
    SELECT
        billing_country,
        MAX(total_spending) AS max_spending
    FROM customer_with_country
    GROUP BY billing_country
)
SELECT
    cc.billing_country,
    cc.total_spending,
    cc.first_name,
    cc.last_name,
    cc.customer_id
FROM customer_with_country cc
JOIN country_max_spending ms ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;

Using ROW_NUMBER() (Method 2): This method uses a window function to rank customers by spending within each country. It effectively selects the top customer(s) and handles ties by including all customers with the same top spending.
SQL

            WITH customer_with_country AS (
                SELECT
                    customer.customer_id,
                    first_name,
                    last_name,
                    billing_country,
                    SUM(invoice.total) AS total_spending,
                    ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(invoice.total) DESC) AS ROWNO
                FROM invoice
                JOIN customer ON customer.customer_id = invoice.customer_id
                GROUP BY 1, 2, 3, 4
            )
            SELECT *
            FROM customer_with_country
            WHERE ROWNO <= 1;

        Insight: Identifies the most valuable customers in each geographical market, enabling tailored VIP programs, direct outreach, and localized marketing efforts to foster stronger customer loyalty.



## How to Use

To use these SQL queries:

1.  **Database Setup:** Ensure you have a relational database (e.g., PostgreSQL, MySQL, SQLite) with the described music store schema populated with data. You might need to import sample data if you're setting up a new database. (Commonly, Chinook database is used for such practice).
2.  **SQL Client:** Use a SQL client (like DBeaver, DataGrip, VS Code with SQL extensions, or the command-line interface of your database) to connect to your database.
3.  **Execute Queries:** Copy and paste the desired queries into your SQL client and execute them. The results will be displayed in your client.

## Technologies Used

  * SQL (Structured Query Language)
  * Relational Database Management System (RDBMS) - pgAdmin4, PostgreSQL.


  * NOTE: ALL THE REFERENCE TABLES ARE PROVIDED IN "Music_Store_database(1).sql" FILE ATTACHED IN THE REPOSITORY.

-----
