--SOLUZIONI SQL QUERY ESERCITAZIONE SECONDO PARZIALE

-- a. Ricercare tutti i prodotti acquistati da 'Franco' mostrando la data della fattura, il nome del prodotto, e il prezzo da fattura:

SELECT c.Nome As Acquirente, f.data, p.nome AS Prodotto, rf.prezzo AS Prezzo
FROM clienti c, fatture f, prodotti p, righefatture rf
WHERE f.cliente = c.codice AND c.nome='Franco' AND rf.fattura=f.codice AND rf.prodotto = p.codice;

--b. Ricercare tutti i prodotti con le rispettive fatture, mostrando il nome del prodotto, la data della fattura e il prezzo a cui è stato venduto e avendo cura di visualizzare anche i prodotti che non sono mai stati venduti:

SELECT p.nome AS Prodotto, f.data, rf.codice
FROM righefatture rf RIGHT JOIN prodotti p ON (rf.prodotto=p.codice) LEFT JOIN fatture f ON(f.codice =
rf.fattura);

--c. Calcolare il totale delle vendite sommando il prezzo di tutte le righe delle fatture. Supponendo che l'azienda guadagni all'incirca il 10% su ogni vendita, si calcoli anche il guadagno atteso:

SELECT SUM(rf.prezzo) AS Vendite, SUM(rf.prezzo*1.10) AS Guadagno
FROM righefatture rf;

--d. Visualizzare per ogni fattura il codice, la data, il numero di righe e il totale ottenuto sommando il prezzo associato a ciascuna riga:

SELECT f.codice, COUNT(rf.fattura) AS NRighe,f.data ,SUM(rf.prezzo)
FROM fatture f, righefatture rf
WHERE rf.fattura = f.codice
GROUP BY f.codice;

--e. Ripetere l'interrogazione precedente ordinando i dati per data:

SELECT f.codice, COUNT(rf.fattura) AS NRighe,f.data ,SUM(rf.prezzo)
FROM fatture f, righefatture rf
WHERE rf.fattura = f.codice
GROUP BY f.codice
ORDER BY f.data;

--f. Visualizzare il nome di ogni cliente con il numero totale di fatture che gli sono state emesse includendo nel conto solo le fatture del 2009(2010), visualizzando solo i clienti che hanno almeno 3 fatture e ordinando le fatture per nome del cliente:

SELECT c.nome as Acquirente, COUNT(f.codice) AS Nfatture
FROM clienti c, fatture f
WHERE f.cliente = c.codice AND YEAR(f.data)=2010
GROUP BY c.codice
HAVING COUNT(f.codice) > 2
ORDER BY c.nome;

--g. Verificare che una fattura non superi mai le 100 righe(ho inserito max 3 righe), in caso contrario, generate un errore inserendo un riga già esistente nella tabella (generando un conflitto nella chiave primaria):

DELIMITER |
CREATE TRIGGER maxRighe 
BEFORE INSERT ON righefatture
FOR EACH ROW
BEGIN
	DECLARE x BIGINT;
	
	SELECT COUNT(rf.fattura) INTO x
	FROM fatture f, righefatture rfWHERE f.codice = rf.fattura AND f.codice= new.fattura
	GROUP BY f.codice;
	
	IF(x>2) THEN
	INSERT INTO fatture VALUES('1000','000001','1996-12-24');
	END IF;
END |
DELIMITER;
