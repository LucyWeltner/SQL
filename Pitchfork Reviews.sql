.open pitchfork.db
.tables
.open /Users/lucyweltner/Downloads/pitchfork.db
.schema

#artists who scored over an 8
SELECT artist FROM reviews WHERE score>8.0;

#number of reviews that scored over an 8
SELECT COUNT(*) FROM reviews WHERE score>8.0;

#number of reviews containing the word good
SELECT COUNT(*) FROM  reviews WHERE review LIKE("% good %”);

#average score of reviews containing the word good
SELECT AVG(score) FROM reviews WHERE review LIKE("% good %");

#average score of reviews
SELECT AVG(score) FROM reviews;

#average score of reviews containing the word great
SELECT AVG(score) FROM reviews WHERE review LIKE("% great %");

SELECT COUNT(*) FROM reviews WHERE review LIKE("% great %")/(SELECT COUNT(*) FROM reviews);
#0 WHY?

#pick all the artists with at least one album scoring higher than 8 and rank them by score
 SELECT artist FROM reviews GROUP BY artist HAVING score>8.0 ORDER BY score;
 
#the lowest scores earned by top artists
SELECT artist, MIN(score) FROM reviews GROUP BY artist HAVING score>8.0 ORDER BY MIN(score);

#number of albums by each top scoring artist
SELECT artist,COUNT(album) FROM reviews GROUP BY artist HAVING score>8.0 ORDER BY score;

#all albums scoring higher than 8, ordered by score
SELECT album,artist,score FROM reviews WHERE score>8.0 ORDER BY score;

#create score brackets, count number of albums in each score bracket and order score brackets from largest to smallest
SELECT COUNT(*) AS tier_count, CASE 
WHEN score>8.0 THEN "Best New Music" 
WHEN score<=8.0 AND score>6.0 THEN "fairly decent" 
WHEN score<=6.0 AND score>4.0 THEN "meh" 
ELSE "Not good" 
END as "tiers" 
FROM reviews GROUP BY tiers ORDER BY tier_count DESC;

# most common scores?
SELECT score, COUNT(score) AS score_count FROM reviews GROUP BY score ORDER BY score_count DESC;

#most common artists?
SELECT artist, COUNT(artist) AS artist_count FROM reviews GROUP BY artist ORDER BY artist_count;

#how to only select artists with more than 7 albums?
#Why doesn’t this work? Ordering artists by number of albums
#SELECT artist, COUNT(artist) AS artist_count, CASE WHEN artist_count>=10 AND artist_count<30 THEN "prolific" WHEN artist_count < 10 AND artist_count>=6 THEN "experienced" WHEN artist_count<6 AND artist_count>=3 THEN "established" WHEN artist_count<3 THEN "new" ELSE "Various Artists"END as "tiers" FROM reviews ORDER BY tier;
#Error: no such column: artist_count

#how many albums per artist? Sort artists into brackets according to how many albums they’ve released, then count how many artists in each bracket
WHEN artist_count>=10 AND artist_count<30 THEN "prolific"
WHEN artist_count < 10 and artist_count>=6 THEN "experienced"
WHEN artist_count<6 AND artist_count>=3 THEN "established"
WHEN artist_count<3 THEN "new"
ELSE "Various Artists" END AS "tier" FROM (SELECT artist, COUNT(artist) AS artist_count FROM reviews GROUP BY artist ORDER BY artist_count) GROUP BY tier;
#find the average scores of each artist
SELECT artist,AVG(score) AS  average_score,COUNT(artist) AS artist_count FROM reviews GROUP BY artist ORDER BY artist_count;

#find the average scores of more experienced vs less experienced artists
SELECT average_score, CASE WHEN artist_count>=10 AND artist_count<30 THEN "prolific" 
WHEN artist_count<10 AND artist_count>=6 THEN "Experienced" 
WHEN artist_count<6 AND artist_count>=3 THEN "established" 
WHEN artist_count<3 THEN "new" ELSE "Various Artists" 
END AS "tier" FROM (SELECT artist,AVG(score) AS average_score, COUNT(artist) AS artist_count FROM reviews GROUP BY artist ORDER BY artist_count)
GROUP BY tier;

#See which artists are mentioned in other artist’s reviews (kind of broken):
SELECT reviewscopy.artist, reviews.artist FROM reviews
	JOIN reviews reviewscopy
	ON reviews.review LIKE ('% '||reviewscopy.artist||' %')
