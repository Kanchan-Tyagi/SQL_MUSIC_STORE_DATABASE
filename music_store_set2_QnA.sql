--MUSIC DATABASE SET 2 QnA
--Question1: Write a query to return the email,firstname,lastname and genre of all Rock Music listeners.
--Return your list ordered alphabetically.
select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
     select track_id from track
     join genre on track.genre_id=genre.genre_id
     where genre.name like 'Rock'
)

order by email;


--question2: Lets invite the artists who have written the most Rock Music in our dataset.
--write a query that returns the artists name and total track count of top 10 rock bands.
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs
from track
join album on album.album_id=track.album_id
join artist on album.artist_id=artist.artist_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;

--Question3: Return all the tracmk names that have the length longedr than the average songs.
--Return the song name and the Millisecond for each track. Order by the song length with longest song listed first.
SELECT name,milliseconds
FROM track
WHERE milliseconds>(
      SELECT AVG(milliseconds) AS avg_track_length
	  FROM track
)
ORDER BY milliseconds DESC


--OR not dynamic
SELECT name,milliseconds
FROM track
where milliseconds >393599
ORDER BY milliseconds DESC

--or
select distinct email as Email,first_name as fname, last_name as lname,genre.name as Name
from customer
join invoice on invoice.customer_id=customer.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
where genre.name like 'Rock'
order by email;
