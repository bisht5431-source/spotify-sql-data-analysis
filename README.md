
<img width="1200" height="630" alt="open-graph-default" src="https://github.com/user-attachments/assets/b543e073-c894-45e1-9e4d-baaf7a7eb59d" />

<div align="center">


  # 🎵 Spotify Advanced SQL Analysis Project

  <p>
    <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" />
    <img src="https://img.shields.io/badge/SQL-Advanced-0052CC?style=for-the-badge&logo=databricks&logoColor=white" />
    <img src="https://img.shields.io/badge/Spotify-1DB954?style=for-the-badge&logo=spotify&logoColor=white" />
    <img src="https://img.shields.io/badge/Level-Easy%20→%20Advanced-6A1B9A?style=for-the-badge" />
  </p>

  <p>
    <img src="https://img.shields.io/badge/Queries-13%20Business%20Problems-E65100?style=for-the-badge" />
    <img src="https://img.shields.io/badge/Techniques-Window%20Functions%20%7C%20CTEs%20%7C%20Subqueries-2E7D32?style=for-the-badge" />
  </p>

  > **End-to-end SQL project on Spotify's music streaming dataset — solving 13 real-world business problems across Easy, Medium, and Advanced levels using PostgreSQL.**

</div>

---

## 📌 Project Overview

This project performs a deep SQL analysis on Spotify's global streaming dataset, covering tracks, albums, artists, views, likes, streams, and audio features like danceability, energy, liveness, and tempo.

The goal is to demonstrate **real analyst-level SQL skills** — from basic aggregations to complex window functions, CTEs, subqueries, and conditional logic — all applied to a real-world music dataset.

| Detail | Info |
|---|---|
| **Database** | PostgreSQL |
| **Dataset** | Spotify tracks with streaming, audio features & video metrics |
| **Total Columns** | 24 columns |
| **Difficulty Levels** | Easy (Q1–Q5) · Medium (Q6–Q10) · Advanced (Q11–Q13) |
| **Total Queries** | 13 business problems solved |

---

## 🗂️ Table Schema

```sql
CREATE TABLE spotify (
    artist            VARCHAR(255),
    track             VARCHAR(255),
    album             VARCHAR(255),
    album_type        VARCHAR(50),
    danceability      FLOAT,
    energy            FLOAT,
    loudness          FLOAT,
    speechiness       FLOAT,
    acousticness      FLOAT,
    instrumentalness  FLOAT,
    liveness          FLOAT,
    valence           FLOAT,
    tempo             FLOAT,
    duration_min      FLOAT,
    title             VARCHAR(255),
    channel           VARCHAR(255),
    views             FLOAT,
    likes             BIGINT,
    comments          BIGINT,
    licensed          BOOLEAN,
    official_video    BOOLEAN,
    stream            BIGINT,
    energy_liveness   FLOAT,
    most_played_on    VARCHAR(50)
);
```

---

## 🧹 Data Cleaning (Before Analysis)

```sql
-- Check for tracks with zero duration (invalid rows)
SELECT * FROM spotify
WHERE duration_min = 0;

-- Remove all zero-duration rows
DELETE FROM spotify
WHERE duration_min = 0;
```

> ✅ **Why:** Tracks with 0 minutes duration are data errors — keeping them would distort averages and aggregations across every query.

---

## 🔍 Business Problems & SQL Solutions

---

## 🟢 Easy Level — Foundational Queries

---

### Q1 — Retrieve all tracks with more than 1 billion streams

```sql
SELECT *
FROM spotify
WHERE stream > 1000000000;
```

| What it does | Filters tracks by stream count threshold |
|---|---|
| **Key concept** | `WHERE` with numeric comparison |
| **Business use** | Identify mega-hit tracks for playlist curation |

---

### Q2 — List all albums with their respective artists

```sql
SELECT
    DISTINCT album,
    artist
FROM spotify;
```

| What it does | Returns unique album–artist pairs |
|---|---|
| **Key concept** | `DISTINCT` to remove duplicates |
| **Business use** | Build an album catalogue for reporting |

---

### Q3 — Total number of comments for licensed tracks

```sql
SELECT
    SUM(comments) AS Total_comments
FROM spotify
WHERE licensed = 'true';
```

| What it does | Aggregates comments only for licensed content |
|---|---|
| **Key concept** | `SUM()` with `WHERE` filter on boolean |
| **Business use** | Measure audience engagement on official content |

---

### Q4 — Find all tracks from album type "single"

```sql
SELECT *
FROM spotify
WHERE album_type = 'single';
```

| What it does | Filters by album category |
|---|---|
| **Key concept** | String equality filter |
| **Business use** | Separate singles strategy from album releases |

---

### Q5 — Count total tracks per artist

```sql
SELECT
    artist,
    COUNT(track) AS Total_track
FROM spotify
GROUP BY artist
ORDER BY 2 ASC;
```

| What it does | Counts how many tracks each artist has |
|---|---|
| **Key concept** | `COUNT()` with `GROUP BY` |
| **Business use** | Measure artist catalogue size and output volume |

---

## 🟡 Medium Level — Business Intelligence Queries

---

### Q6 — Average danceability per album

```sql
SELECT
    album,
    AVG(danceability) AS Average_danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC;
```

| What it does | Ranks albums by average danceability score |
|---|---|
| **Key concept** | `AVG()` with `GROUP BY` + `ORDER BY` |
| **Business use** | Identify high-energy albums for DJ and party playlist targeting |

---

### Q7 — Top 5 tracks with the highest energy

```sql
SELECT
    track,
    MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

| What it does | Returns the 5 most energetic tracks on the platform |
|---|---|
| **Key concept** | `MAX()` + `LIMIT` for top-N analysis |
| **Business use** | Power workout and high-energy playlist recommendations |

---

### Q8 — Tracks with official videos — views and likes

```sql
SELECT
    track,
    SUM(views)  AS Total_views,
    SUM(likes)  AS Total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC;
```

| What it does | Summarises video performance metrics for official content only |
|---|---|
| **Key concept** | `SUM()` with boolean `WHERE` filter |
| **Business use** | Measure YouTube vs streaming video performance for marketing ROI |

---

### Q9 — Total views per album and track

```sql
SELECT
    album,
    track,
    SUM(views) AS Total_views
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;
```

| What it does | Ranks albums and individual tracks by total view count |
|---|---|
| **Key concept** | Multi-column `GROUP BY` |
| **Business use** | Album-level performance dashboard input |

---

### Q10 — Tracks streamed more on Spotify than YouTube

```sql
SELECT * FROM (
    SELECT
        track,
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube'  THEN stream END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify'  THEN stream END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY 1
) AS t1
WHERE
    streamed_on_spotify > streamed_on_youtube
    AND streamed_on_youtube <> 0;
```

| What it does | Compares platform-level streaming performance per track |
|---|---|
| **Key concept** | Subquery · `CASE WHEN` · `COALESCE` · Conditional aggregation |
| **Business use** | Identify Spotify-dominant tracks to prioritise in platform licensing deals |

---

## 🔴 Advanced Level — Expert SQL Techniques

---

### Q11 — Top 3 most-viewed tracks per artist (Window Function)

```sql
WITH ranking_artist AS (
    SELECT
        artist,
        track,
        SUM(views)                                              AS total_view,
        DENSE_RANK() OVER (
            PARTITION BY artist
            ORDER BY SUM(views) DESC
        )                                                       AS rank
    FROM spotify
    GROUP BY 1, 2
    ORDER BY 1, 3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3;
```

| What it does | Ranks each artist's top 3 tracks by view count independently |
|---|---|
| **Key concept** | `WITH (CTE)` · `DENSE_RANK()` · `OVER (PARTITION BY)` |
| **Business use** | Build artist-specific "Top Tracks" feature — used in Spotify's own app |

> 💡 **Why DENSE_RANK over RANK:** If two tracks tie on views, DENSE_RANK assigns both rank 1 and the next track rank 2 — RANK would skip to rank 3. DENSE_RANK ensures no gaps in ranking when ties exist.

---

### Q12 — Tracks where liveness is above the platform average

```sql
SELECT
    track,
    artist,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

| What it does | Identifies live-recorded or concert tracks above average liveness |
|---|---|
| **Key concept** | Correlated subquery inside `WHERE` |
| **Business use** | Curate "Live Sessions" playlists — content that feels authentic and unpolished |

---

### Q13 — Energy difference (max vs min) per album using CTE

```sql
WITH cte AS (
    SELECT
        album,
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY 1
)
SELECT
    album,
    highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC;
```

| What it does | Measures the emotional range of each album by audio energy variance |
|---|---|
| **Key concept** | `WITH` CTE · Arithmetic on aggregated columns |
| **Business use** | Identify albums with wide emotional range (diverse listening experience) vs flat albums |

---

## 🚀 SQL Techniques Used

| Technique | Used In |
|---|---|
| `SELECT WHERE ORDER BY LIMIT` | Q1, Q2, Q4, Q7 |
| `COUNT()` `SUM()` `AVG()` `MAX()` `MIN()` | Q3, Q5, Q6, Q7, Q8, Q9, Q13 |
| `DISTINCT` | Q2 |
| `GROUP BY` single column | Q5, Q6, Q7, Q8 |
| `GROUP BY` multiple columns | Q9 |
| `CASE WHEN` conditional aggregation | Q10 |
| `COALESCE()` null safety | Q10 |
| Subquery in `FROM` (derived table) | Q10 |
| Subquery in `WHERE` | Q12 |
| `WITH` CTE (Common Table Expression) | Q11, Q13 |
| `DENSE_RANK() OVER (PARTITION BY)` | Q11 |
| Boolean filter (`licensed`, `official_video`) | Q3, Q8 |
| Arithmetic on aggregates | Q13 |

---

## 📁 Repository Structure

```
spotify-sql-analysis/
│
├── 📄 README.md              ← You are here
└── 📄 Spotify_data.sql       ← Complete SQL script (CREATE TABLE + all 13 queries)
```

---

## 🛠️ How to Run This Project

```bash
# Step 1 — Clone this repository
git clone https://github.com/bisht5431-source/spotify-sql-analysis.git

# Step 2 — Open pgAdmin 4 or any PostgreSQL client

# Step 3 — Create the database
CREATE DATABASE spotify_db;

# Step 4 — Run the SQL file
-- Open Spotify_data.sql in pgAdmin
-- Execute the CREATE TABLE block first
-- Import your dataset into the table
-- Run each query section by section

# Step 5 — Explore the results
-- Start from Easy level queries and work up to Advanced
```

---

## 💼 What This Project Demonstrates

| Skill | Evidence |
|---|---|
| **Data Cleaning** | Identified and removed zero-duration invalid rows before analysis |
| **Aggregations** | SUM, AVG, COUNT, MAX, MIN across multiple groupings |
| **Filtering Logic** | WHERE, boolean filters, numeric thresholds |
| **Conditional Aggregation** | CASE WHEN inside SUM for platform comparison |
| **Subqueries** | Derived tables in FROM and scalar subqueries in WHERE |
| **Window Functions** | DENSE_RANK() OVER PARTITION BY — artist-level ranking |
| **CTEs** | Clean, readable multi-step logic using WITH clause |
| **Business Thinking** | Every query answers a real Spotify business question |

---

## 📬 Connect With Me

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/dataanalyst-manish)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/bisht5431-source)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:alphainsights123@gmail.com)

</div>

---

<div align="center">

**⭐ If this project helped you, please star the repository — it helps other SQL learners find it.**

*Built by Manish Bisht — Data Analyst Intern · Intellipaat Software Solutions Pvt. Ltd.*
*SQL · Power BI · DAX · Python · Excel*

</div>
