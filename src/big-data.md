# Analisi di Big Data

Esigenza di utilizzare i big data: cambia l'approccio all'analisi dei dati: algoritmi più complicati. Si è passati da qualche tera a peta e adesso anche ad exabyte. Quando si parla di analisi a big data quello che vogliamo avere è una architettura scalare e non progettata per un target, ovvero le cui prestazioni richieste dipendano dalla quantità di dati. Esempio: Facebook il cui numero di dati cresce continuamente del tempo senza far trasparire un affanno da parte dell'infrastruttura. 

## Apache Hadoop
E  un software open source (nato dall'esperienza di Google nei suoi data center). Vogliamo che sia

1. scalabile
2. cost effective
3. flessibile
4. Fail tolerant

Nel caso specifico la scelta iniziale di hadop è stata quella di partire da dei moduli di basi e di dare la possibilità a chi serve di appoggiarsi su quelle librerie di base creare dei progetti correlati.
Alla librerie di base si aggiunge quella del file system e poi due moduli per gestire anche la parte legata a come far girare dei programmi sui dati. Quindi in questo caso la gestione dei dati e delle code è unica e questo porta dei vantaggi. Su questa base (ovvero oggetti per gestire dati e far girare codice) si sono appaggiati dei progetti paralleli (come cassandra che è un sistema per creare database).
\subsection{Idea}
Nasce da Google.
Quando devo far girare una grande quantità di dati ho due problemi: uno è la CPU e l'altro è leggere i dati. Questi due problemi sono strettamente correlati. Dobbiamo cercare di non far stare la CPU senza far niente ma al tempo stesso non dare troppi dati in modo che non riesce a processarli.

La somma dei dischi deve essere sufficientemente veloce (non è singolo disco) e anche la rete deve essere sufficientemente veloce. Quest'ultimo aspetto è in realtà il più costoso. L'idea di google è cambiare come vengono processati i dati. 

FIG 1 sul quaderno.

Il problema dell'approccio innovativo è che se prima l'archiviazione di dati era dedicata a macchine dedicate, ora non lo è piu e le failure diventano più importanti e si devono gestire meglio quest'utlime.
Failure: problema ai dischi, problema alla macchina, problema di rete.
Per la prima devo prevedere una ridondanza con delle repliche in ogni posto. In un datacenter grosso ci sono i domini di fallimento (che sono problemi che possono capitare tipo switch che si rompono o linee di alimentazione che si rompono e non fanno funzionare un singolo armadio ecc).

E' basato su JAVA. Si voleva avere la possibilità di costruire un codice JAVA che sfruttasse in profondità il sistema. 
\subsection{Architettura}
Si utilizza un programma JAVA di alto livello che simula l'interfaccia con il file system tramite Mont point FUSE che simuli il file system. 
FUSE è un layer che mi permette di simulare la vista a file system (cartelle ecc) anche se dietro c'è una cosa più complicata o di più alto livello.

l'idea di  hadoop è quello di risolvere i problemi classici che avvengono in un data center. Immaginiamo che ci siano tre copie del mio file e ho due armadi. Conviene che le mie tre copie siano distribuite almeno una su un altro armadio in modo che se uno si spegne comunque un'altra copia sta sull'altro.

Chiedo la scrittura ad hadoop specificando la block size e il numero di repliche. Il client specifica queste cose al namenode che è un server che controlla tutto. Il namenode controlla dove è disponibile spazio e scrive il file sul primo datanode che copia poi sull'altro e cosi via. Questo riduce la complessita del client appoggiando uan parte dei compiti sul datasistem. Una volta che tutti e tre hanno comunicato al namenode che hanno scritto la procedura è finita. Quindi la velocità effettiva è tre volte piu lenta rispetto alla copia singola. Il sistema quindi ha completato la scrittura di quel blocco e si passa al blocco al successivo.

Quando il client vuole leggere un file va al namenode e chiede il file. Il namenode comunica con i datanode in parallelo le richieste sui file che comunicano i blocchi presenti di quel file. Il vantaggio è che se un nodo per esempio è occupato o non funziona il sistema può recuperare dagli altri nodi il dato cercato e questo per l'utente è completamente trasparente.

Riguardo la placemente startegy lui fa questo quando si richiede di fare 3 copie: una replica in un reck e un altra replica in 2 reck. Questo fa si che si minimizzano quanto piu possibile l'uso degli uplink di rete utilizzando la rete con la connessione interna del rack che è meno costosa. Quindi comunque ho la ridondanza senza aver stressato troppo l'uplink. Inoltre questi sistemi vengono utilizzati per scrivere poco e leggerli molte volte. Quidni avere due copie all'interno dello stesso rack fa si che quando vado a fare analisi potrei leggere al doppio della velocità utilizzando le due copie all'interno dello stesso rack.

