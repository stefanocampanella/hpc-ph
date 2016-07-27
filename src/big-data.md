# Analisi di Big Data

Per **Big Data** si intendono *dataset* le cui dimensioni trascendono le capacità di hardware e software convenzionali di catturare, gestire o processare dati in tempi ragionevoli. Tuttavia bisogna tenere presente che il concetto di big data è in costante evoluzione e la crescita delle dimensioni effettive dei dataset associati è molto veloce (di alcuni ordini di grandezza in pochi anni).

## Apache Hadoop

**Apache Hadoop** è un framework software scritto in Java per l'analisi di big data su cluster con le seguenti caratteristiche

- **Scalabile** : nuovi nodi possono essere aggiunti o rimossi *a caldo*, senza modifiche all'infrastruttura o alle applicazioni che accoglie
- **Efficiente** : rendendo possibile il calcolo su un sistema ad elevato parallelismo (*massively parallel computing*) senza l'impiego di hardware specifico
- **Flessibile** : possibilità di incorporare e scrivere applicazioni per qualsiasi genere di dato, strutturato o meno.
- **Tollerante ai guasti** : in caso di malfunzionamento di un nodo, perdita di una replica di un file o di un malfunzionamento di un disco, il sistema è in grado di gestire automaticamente il problema

Il framework Hadoop comprende

- **Hadoop Common** : le utility e le librerie comuni necessarie agli altri servizi
- **Hadoop Distributed File System (HDFS)** : un file system in grado di utilizzare risorse distribuite e massimizzare il volume di dati accessibili alle applicazioni
- **Hadoop YARN** : un framework per lo scheduling dei job e per la gestione delle risorse di archiviazione
- **Hadoop MapReduce** : un sistema per il calcolo parallelo basato su YARN ed ottimizzato per grandi dataset

I problemi riscontrati nella analisi di grandi dataset sono in genere legati al temo di CPU e alla lettura dei dati. La soluzione offerta da Hadoop consiste in un unico framework per la gestione integrata dei processi e dei dati, che cerca di porre rimedio a questi problemi e di risolvere le inefficienze di un approccio tradizionale.

L'osservazione principale è che trasferire i dati verso le CPU (come nel caso tradizionale di macchine separate per l'archiviazione) è sia costoso, per via delle infrastrutture di rete, che inefficiente, per via delle latenze. Una possibile soluzione è scalare il numero di CPU *assieme* ai dischi e tenere queste ultime il più vicino possibile ai dati da analizzare. Si osserva tuttavia che uno degli svantaggi di questo approccio è che la gestione delle failure diventa più delicata.

## HDFS

L'utente può interagire con HDFS in diversi modi

 - montare dischi in userspace (FUSE) simulando un file system di basso livello
 - monitorare il file system utilizzando una interfaccia Web
 - utilizzando le API in Java
 - utilizzando la shell nativa di HDFS da terminale

 L'architettura del sistema di archiviazione in un cluster Hadoop tramite HDFS comprende i seguenti componenti

 - Uno o più **client** che possono inoltrare richieste al sistema tramite le interfacce citate
 - Un *unico* **namenode** che coordina l'archiviazione e la lettura dei dati
 - Diversi (usualmente centinaia o migliaia) di **datanodes**, che contengono fisicamente i dati

### Scrittura di file in HDFS

La scrittura di un file su HDFS avviene in più fasi

1. **Request from user** L'utente chiede al client di scrivere un file e fornisce ridondanza desiderata, **replication factor**, e le dimensioni dei blocchi in cui questo verrà diviso dal sistema, **blocksize**.
2. **Client ask namenode** Il client divide il file in blocchi delle dimensioni stabilite e comunica al namenode ridondanza e numero di blocchi
3. **Namenode assignment** Il namenode determina i datanode su cui archiviare i blocchi. Infine restituisce gli indirizzi dei datanode al client (in ordine di distanza dal client crescente)
4. **Client writes data** Il client comincia a scrivere i dati sul primo datanode.
5. **Replication pipeline** Il primo datanode inoltra i dati al secondo e così via, fino all'ultimo datanode
5. **Completion and Inform namenode** Quando l'ultimo datanode finisce di ricevere i dati lo comunica al namenode.
6. **Namenode stores metadata** Ad operazioni concluse il namenode conserva i metadati dei file archiviati sul proprio disco (indirizzi dei namenode, etc.).

TODO

> l'idea di  hadoop è quello di risolvere i problemi classici che avvengono in un data center. Immaginiamo che ci siano tre copie del mio file e ho due armadi. Conviene che le mie tre copie siano distribuite almeno una su un altro armadio in modo che se uno si spegne comunque un'altra copia sta sull'altro.

> Chiedo la scrittura ad hadoop specificando la block size e il numero di repliche. Il client specifica queste cose al namenode che è un server che controlla tutto. Il namenode controlla dove è disponibile spazio e scrive il file sul primo datanode che copia poi sull'altro e cosi via. Questo riduce la complessità del client appoggiando una parte dei compiti sul datasystem. Una volta che tutti e tre hanno comunicato al namenode che hanno scritto la procedura è finita. Quindi la velocità effettiva è tre volte più lenta rispetto alla copia singola. Il sistema quindi ha completato la scrittura di quel blocco e si passa al blocco al successivo.

> Quando il client vuole leggere un file va al namenode e chiede il file. Il namenode comunica con i datanode in parallelo le richieste sui file che comunicano i blocchi presenti di quel file. Il vantaggio è che se un nodo per esempio è occupato o non funziona il sistema può recuperare dagli altri nodi il dato cercato e questo per l'utente è completamente trasparente.

> Riguardo la placement strategy lui fa questo quando si richiede di fare 3 copie: una replica in un rack e un altra replica in 2 rack. Questo fa si che si minimizzano quanto più possibile l'uso degli up link di rete utilizzando la rete con la connessione interna del rack che è meno costosa. Quindi comunque ho la ridondanza senza aver stressato troppo l'up link. Inoltre questi sistemi vengono utilizzati per scrivere poco e leggerli molte volte. Quindi avere due copie all'interno dello stesso rack fa si che quando vado a fare analisi potrei leggere al doppio della velocità utilizzando le due copie all'interno dello stesso rack.

## Map Reduce

TODO
