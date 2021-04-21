# Versionhallinta - Palvelinten hallinta viikkotehtävä 3

## TLDR

Tehtävässä loin paikallisen git varaston, tein muutoksia ja peruin niitä, sekä vein paikallisen git varaston githubiin ja laitoin sen sisään /srv/salt kansion sisällön.

[Tehtävänanto](https://terokarvinen.com/2021/configuration-management-systems-palvelinten-hallinta-ict4tn022-spring-2021/#h3-versionhallinta)

## Markdown - Tehtävä A

Ensimmäisenä tehtävänä oli kirjoittaa tämä raportti markdownina. Olen kirjoittanut kaikki raporttini tähän mennessä markdownilla, joten tämä tapahtuu itsestään.

Laitoin markdown version tästä raportista samaan repositorioon, jonka luon myöhemmin tehtävän aikana. Sitä voi tarkastella [täältä](https://github.com/vapalo/suolagit).


## Paikallinen git varasto - Tehtävä B

Tehtävänä oli demonstroida omalla paikallisella git varastolla `git log`, `git diff` sekä `git blame` komentoja. Gitin käyttämisen alkuun pääsee helposti jo muutamalla komennolla.
[Tero Karvisella](http://terokarvinen.com/contact/) on hyvä [artikkeli](http://terokarvinen.com/2016/publish-your-project-with-github/) tähän liittyen.

![gitlog](../static/pictures/phvt3/1.png)

Git log näyttää git varaston commit historian. Täältä näkee kuka on tehnyt commitin, mihin aikaan ja minä päivänä, sekä committiin liitetyn viestin.

![gitdiff](../static/pictures/phvt3/2.png)

Git diff näyttää tiedostoihin tehdyt muutokset, joita ei ole vielä commitattu git varastoon. Mikäli olisin poistanut tiedostosta rivejä
olisi git diff näyttänyt ne - merkillä + merkin sijaan. Mikäli muutokset on lisätty `git add` comennolla, muttei kuitenkaan vielä commitattu voi muutoksia
tarkastella `git diff --staged` komennolla.

![gitblame](../static/pictures/phvt3/3.png)

Git blame vastaavasti näyttää kuka on tehnyt muutokset tiedostoon. Komento onkin nimetty hyvän muistisäännön mukaan, sillä komennolla voi tarkistaa
ketä syyttää huonoista muutoksista.

## Tee tyhmä muutos gittiin - Tehtävä C

Seuraavaksi vuorossa oli tehdä jokin tyhmä muutos gittiin. Päätin siis poistaa readme.md tiedoston ja lisätä sen commitoitavaksi `git add` komennolla.
Muutoksia en kuitenkaan vienyt maaliin asti `git commit -m` komennolla vielä.

![gitresethard](../static/pictures/phvt3/4.png)

`git reset --hard` komento peruuttaa **kaikki** tehdyt muutokset ja palauttaa varaston tilan edelliseen committiin. Tämä tarkoittaa, että aikaiseemin tekemäni
muutokset muutoksien sisäänkin poistuvat ja readme.md tiedosto palaa aikaisempaan muotoonsa.

[Oh shit git](https://ohshitgit.com/) sivustolta löytyy loistavia ohjeita sekä Englanniksi, että Suomeksi gitin käytöstä, mikäli jotain menee pieleen.
Sivustosta on myös saatavilla kirosanaton versio [Dangit git](https://dangitgit.com/en). Kirosanaton version on myös käännetty suomeksi.

## Luo uusi salt moduuli - Tehtävä D

Tässä tehtävässä luodaan jokin uusi salt moduuli samaan tapaan kuin edellisessäkin tehtävässä. Ensin asennan käsin ja sitten automatisoin prosesesin
saltin avulla. Päätin asentaa Postgresql tietokanta-ajurin. Ohjeita tämän asennukseen löytää [täältä](http://terokarvinen.com/2016/03/03/install-postgresql-on-ubuntu-new-user-and-database-in-3-commands/index.html?fromSearch=)

![psql](../static/pictures/phvt3/5.PNG)

Käyttäjän sekä tietokannan luonti onnistui vaivattomasti. Seuraavaksi halusin luoda taulun tietokantaan. 

	CREATE TABLE employees(
		id serial primary key,
		name varchar(250),
		address varchar(250)
	);

![psqltaulu](../static/pictures/phvt3/6.PNG)

Ja näin taulu on luotu tietokannan sisään. 

Seuraavaksi on vuorossa tämän automatisointi, sekä idempotentin tilan luonti. Aloitin poistamalla kaiken asentamani.

	$ sudo -u postgres dropdb toni
	$ sudo -u postgres dropuser toni
	$ sudo apt-get purge postgresql

### Automatisointi

Aloitin luomalla kansion /srv/salt hakemiston sisään postgresiä varten. Nimesin kansion todella luovasti `postgres`.
Tiedoston tarkoituksena on tarkistaa onko järjestelmä halutussa tilassa ja toimii asianmukaisesti mikäli ei ole. Haluttu tila on seuraava:

* Postgresql asennettuna
* Käyttäjä sekä tietokanta luotu
* Taulu employees luotu sekä sen sisälle kentät:
	* id
	* name
	* address

	#/srv/salt/postgres/init.sls sisältö

	postgresql:
	  pkg.installed

	'createuser toni && createdb toni'
	  cmd.run:
	    - runas: postgres
	    - unless: 'psql -c "\du"|grep toni'

	'psql -c CREATE TABLE employees(id serial primary key, name varchar(250), address varchar(250))':
	  cmd.run:
	    - runas: toni
	    - unless: 'psql -c "\d"|grep employees'

![success](../static/pictures/phvt3/7.PNG)

Komento onnistui ja halutut asetukset ovat voimassa.

![inserted](../static/pictures/phvt3/8.PNG)

Komennon ajo `toni` käyttäjänä myös onnistui, sillä käyttäjällä on oikeus lisätä tietoa tauluun.

Entä jos poistan taulun ja ajan salt komennon uudelleen?

![deleet](../static/pictures/phvt3/9.PNG)

![uusisalt](../static/pictures/phvt3/10.PNG)

Komento ajettiin onnistuneesti, ja muutoksia tapahtui vain yksi, joka oli taulun luonti. Tämä siis tarkoittaa, että salt tila on onnistuneesti luotu.

## Vie salt kansiosi githubiin - Tehtävä E

Viimeisenä vuorossa oli viedä /srv/salt kansion sisältö githubiin. Aloitin siirtymällä /srv/salt kansioon ja ajamalla `sudo git init` komennon. /srv/salt kansion sisällä
ei tavallisella käyttäjällä pysty luomaan kansioita tai muokkaamaan tiedostoja. Siksi siis sudo täytyy lisätä komentoon.

![sudogit](../static/pictures/phvt3/11.PNG)

Aikaisemmin linkkaamassani ohjeessa näytettiin, kuinka git varasto saadaan synkronoitua githubista paikalliseksi. Siksi oli tärkeää luoda tiedostoja etärepositorioon ensin
ja sitten käyttää `git pull` komentoa vetääkseen repositorion paikalliseksi. Tässä tapauksessa /srv/salt kansioni ei ole tyhjä, joten linkitys githubiin täytyy
tehdä hieman eri tavalla.

Alku pysyy kuitenkin samana. Githubiin luodaan repositorio haluamalla nimellä, sekä kuvauksella. Kuitenkin repositorion luontivaiheessa **ei** lisätä yhtäkään tiedostoa.
Ei readme tai licence tiedostoa myöskään. Etärepositorion tulee olla täysin tyhjä luomisen jälkeen.

![tyhjarepo](../static/pictures/phvt3/12.PNG)

Github myös kohteliaasti kertoo ohjeet, kuinka olemassa oleva repositorio pusketaan githubiin

	$ git remote add origin https://github.com/Vapalo/suolagit.git
	$ git branch -M main
	$ git push -u origin main

Seuraavaksi palasin paikalliseen git repositoriooni ajamaan nämä komennot. Komentoja ajaessani törmäsin ongelmaan. Unohdin aikaisemmassa kohdassa `git init` komennon jälkeen
sanoa, että pitäisi ajaa `git add .`, `git commit -m "Initial commit"` komennot. Näitä ajaessa sudon avulla commitin tekijä muuttuu gittiin asetetusta käyttäjästä `root`
käyttäjäksi. Arvelinkin, että näiden komentojen ajaminen sudolla oli huono idea ja tässä se materialisoitui. 

Hätä ei ole tämän näköinen! Loin uuden kansion käyttäjäni kotihakemistoon ja kopioin /srv/salt sisällön sinne. Poistin samalla `.git` kansion /srv/salt
kansion sisältä, jonka `git init` komento loi. 

![kotihakemistokansio](../static/pictures/phvt3/13.PNG)

![ekacommit](../static/pictures/phvt3/14.PNG)

Näin commit saatiin tehtyä oikean käyttäjän tiedoilla.

Seuraavaksi ajoin githubin tarjoamat komennot, joilla paikallinen repositorio saadaan vietyä githubiin

![githubkomennot](../static/pictures/phvt3/15.PNG)

![etärepo](../static/pictures/phvt3/16.PNG)

Ja näin repositoriomme on näkyvä maailmalle! Sitä voi tarkastella [täältä](https://github.com/vapalo/suolagit). Lisäsin readme tiedoston sekä licencen jälkikäteen.

Viimeisenä vuorossa oli poistaa paikallinen /srv/salt kansio ja palauttaa se githubista paikalleen. Poistin myös paikallisen suolagit repositorion.

![rm-rf](../static/pictures/phvt3/17.PNG)

Käytin `git clone` komentoa hankkiakseni suolagit kansioni takaisin githubista.

![backagain](../static/pictures/phvt3/18.PNG)

Viimeisenä loin /srv/salt kansion uudelleen, ja kopioin suolagitistä tuleet kansiot takaisin sen sisään. Testasin myös ajaa salt komennon paikallisesti, jotta näen tilojen
toimivuuden.

![createsrvsalt](../static/pictures/phvt3/19.PNG)

![endresult](../static/pictures/phvt3/20.PNG)


## Linkkejä

* [Kurssin materiaalit](https://terokarvinen.com/2021/configuration-management-systems-palvelinten-hallinta-ict4tn022-spring-2021/)
* [Github](https://github.com)
* [Ohshitgit](https://ohshitgit.com/)
* [Git](https://git-scm.com/)
