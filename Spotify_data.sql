-- create table

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

Select * From spotify;

Select Count(*) From spotify;

Select Count(Distinct album) From spotify;

Select Distinct album_type From spotify;

Select Max(duration_min) From spotify;

Select Min(duration_min) From spotify;

Select * From spotify
Where duration_min = 0

Delete From spotify
Where duration_min = 0;

Select Distinct most_played_on From spotify;


--15 Practice Questions
---Easy Level

--1. Retrieve the names of all tracks that have more than 1 billion streams.
Select * From spotify
Where stream > 1000000000;

--2. List all albums along with their respective artists.
Select 
	Distinct album,
	artist
From spotify;

--3. Get the total number of comments for tracks where licensed = TRUE.
Select 
	Sum(comments) As Total_comments
From spotify
Where licensed = 'true';

--4. Find all tracks that belong to the album type single.
Select * From spotify
Where album_type = 'single';

--5. Count the total number of tracks by each artist.
Select 
	artist,
	Count(track) As Total_track	
From spotify
Group By artist
Order By 2 Asc;

--Medium Level

--6. Calculate the average danceability of tracks in each album.
Select 
	album,
	Avg(danceability) As Average_danceability
From spotify
Group By album
Order By 2 Desc;


--7. Find the top 5 tracks with the highest energy values.
Select 
	track,
	Max(energy)
From spotify
Group By 1
Order By 2 Desc
Limit 5;

--8. List all tracks along with their views and likes where official_video = TRUE.
Select 
	track,
	Sum(views) As Total_views,
	Sum(likes) As Total_likes
From spotify
Where official_video = 'true'
Group By 1
Order By 2 Desc;

--9. For each album, calculate the total views of all associated tracks.
Select
	album,
	track,
	Sum(views) As Total_views
From spotify
Group By 1, 2
Order By 3 Desc;

--10. Retrieve the track names that have been streamed on Spotify more than YouTube.
Select * From
(Select 
	track,
	Coalesce(Sum(Case When most_played_on = 'Youtube' Then stream End),0) as streamed_on_youtube,
	Coalesce(Sum(Case When most_played_on = 'Spotify' Then stream End),0) as streamed_on_spotify
From spotify
Group By 1
) As t1
Where 
	streamed_on_spotify > streamed_on_youtube
	And
	streamed_on_youtube <> 0

--Advanced Level

--11. Find the top 3 most-viewed tracks for each artist using window functions.
With ranking_artist
As
(Select 
	artist,
	track,
	Sum(views) As total_view,
	Dense_Rank() Over(Partition By artist Order By Sum(views) Desc) as rank
From spotify
Group By 1, 2
Order By 1, 3 Desc
)
Select * From ranking_artist
Where rank <= 3;


--12. Write a query to find tracks where the liveness score is above the average.
Select 
	track,
	artist,
	liveness
From spotify
Where liveness > (Select Avg(liveness) From spotify);


--13. Use a WITH clause to calculate the difference between 
----- the highest and lowest energy values for tracks in each album.
With cte
As
(Select 
	album,
	Max(energy) As highest_energy,
	Min(energy) As lowest_energy
From spotify
Group By 1
)
Select 
	album,
	highest_energy - lowest_energy as energy_diff
From cte
Order By 2 Desc;
