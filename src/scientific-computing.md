# Teoria dei calcolatori e del calcolo scientifico

## Modello di Von Neumann

Praticamente  tutti  i  computer  attuali  fondano  la  propria  architettura  sul *modello  di  Von Neumann*, quest'ultimo si basa sul principio secondo cui i dati e le istruzioni condividono lo stesso spazio di memoria. Lo schema è il seguente, ci sono 5 unità fondamentali:

1. **CPU (o unità di lavoro)** che si divide a sua volta in
  - **Unità di controllo**, che gestisce le operazioni necessarie per eseguire una istruzione o un insieme di istruzioni
  - **Unità operativa**, la cui parte più importante è l’unità aritmetico-logica (o ALU) e che effettua appunto operazioni aritmetiche e logiche
2. **RAM (Random Access Memory)**: Unità di memoria, intesa come memoria di lavoro o memoria principale
3. **Unità di input** (tastiere, mouse, ecc.)
4. **Unità di output** (monitor, stampanti, plotter, ecc.)
5. **Bus** ovvero un canale che collega tutti i componenti fra loro

In un calcolatore convenzionale le istruzioni vengono processate **sequenzialmente** nei seguenti passi:

1. un istruzione viene caricata dalla memoria (fetch) e decodificata
2. vengono calcolati gli indirizzi degli operandi
3. vengono prelevati gli operandi dalla memoria
4. viene eseguita l'istruzione
5. il risultato viene scritto in memoria (store)

Esistono pertanto due strategie per migliorare le performance

- Aumentare le prestazioni dei singoli componenti elettronici
- Eseguire più istruzioni contemporaneamente

Si precisa che in generale un piccolo aumento delle performance non è interessante da un punto di vista tecnologico e pertanto si considera un incremento significativo intorno ad un ordine di grandezza (fattore 10). 

La prima strategia ha dei limiti fisici:

- Problema della dissipazione del calore
- Limite imposto dalla velocità della luce

Il problema della dissipazione del calore è collegato alla dimensione dei transistor che compongono la CPU, questa dimensione è a sua volta collegata alle dimensioni caratteristiche del processo di litografia utilizzato (feature dimension). Il limite attuale per queste dimensioni è intorno ai 10 nanometri e non è possibile scendere molto al disotto di questa dimensione per via di effetti quantistici (oltre naturalmente al limite imposto dalle dimensioni atomiche del supporto di silicio).

L'altro limite è la velocità di I/O che è vincolata al limite fisico della velocità della luce per i segnali elettromagnetici nel vuoto.

Altri  problemi  sono  la  dimensione  della  ram,  che  pone  un  limite  alle applicazioni in esecuzione (attualmente su un singolo slot 128GB), la larghezza di banda tra memoria e processore, o fra processore/memoria e I/O, la larghezza di banda della cache, ecc. 

## Tassonomia di Flynn

La prima forma di parallelismo sperimentata è il pipelining e presenta delle analogie con il concetto di catena di montaggio dove, in una linea di flusso (pipe) di stazioni di assemblaggio gli elementi vengono assemblati a flusso continuo. 

In questo caso le componenti elettroniche specializzate (unità) che operano su ciascuna delle 5 fasi attraverso cui viene eseguita una istruzione (dal fetch allo store) funzionano simultaneamente. Ciascuna lavora sulla istruzione seguente rispetto alla unità successiva e sulla istruzione precedente rispetto alla unità precendente. In questo modo si evitano i tempi morti sulle singole unità.

Idealmente tutte le stazioni di assemblaggio devono avere la stessa velocità di elaborazione, altrimenti la stazione più lenta diventa il *bottleneck* della intera pipe.

La tassonomia di Flynn è una classificazione delle molteplicità dell'hardware per manipolare stream di istruzioni e di dati. In particolare lo **stream delle istruzioni** (sequenza delle istruzioni eseguite dal calcolatore) può essere singolo, **SI** per Single Instruction stream, o multiplo, **MI** per Multiple Instruction stream, ed anche lo **stream di dati** (sequenza degli operandi su cui vengono eseguite le istruzioni) può essere a sua volta singolo, **SD** per Single Data stream, o multiplo, **MD** per Multiple Data stream. Complessivamente sono possibili 4 combinazioni:

- **SISD**: è  la  tipica  architettura  di  Von  Newman (sistemi scalari monoprocessore)  e può essere pipelined
- **MISD**: più flussi di istruzioni lavorano contemporaneamente su un unico flusso di dati. Non è stata finora utilizzata praticamente.
- **SIMD**: una singola istruzione opera simultaneamente su più dati, in questo caso il sistema possiede una singola unità di controllo ma diverse unità di elaborazione. Sistemi di questo genere vengono anche chiamati *array processor* o *sistemi vettoriali*. Anche questo genere di sistemi può essere pipelined. Esistono esempi famosi di supercomputer vettoriali (come quelli costruiti dalla Cray negli anni 70) e sviluppati per applicazioni particolari, oggi molti dei moderni processori hanno capacità SIMD ed un set di istruzioni dedicato (SSE, Streaming SIMD Extensions, nel caso Intel).
- **MIMD**: in questo caso si parla anche di parallelismo asincrono ed esistono più CPU che operano su dati diversi, ovvero più unità di controllo ciascuna collegata a più unità operative. In questo senso ci si può riferire a questi sistemi come ad una versione multiprocessore dei sistemi SIMD. 

Per realizzare questi sistemi è necessario che i vari sottosistemi comunichino tra loro. Questo può avvenire sia in un solo calcolatore con **un'unica memoria condivisa** fra più processori (per questo detti *tightly coupled*), che per questo devono trovarsi nello stesso spazio fisico, sia tramite una rete di calcolatori (con processori in questo caso *loosely coupled*) interconnessi e funzionalmente completi (dotati di CPU, RAM, bus, dischi, etc.), che possono anche trovarsi in posti geograficamente differenti. Inoltre sono anche possibili soluzioni combinate di questi due casi.

I sistemi di tipo MIMD abbracciano una ampia classe di architetture possibili, ricapitolando si ha

- **Architettura  MIMD  multiprocessore o shared memory system**: i processori condividono i dati e le istruzioni in una memoria centrale comune. La  comunicazione avviene dunque mediante condivisione della memoria attraverso un bus.
- **Architettura MIMD multicomputer o distributed memory system**: ogni processore ha una memoria propria. I vari processori comunicano tra loro  mediante una rete che consente a ciascun processore di trasmettere e ricevere dati dagli altri. I processori possono anche essere fisicamente lontani.

Inoltre il genere di calcoli che vengono eseguiti su un sistema parallelo può essere di due tipi, distinti per il genere di priorità che comportano e di performance richieste al sistema

- **HPC, High Performance Computing**: il calcolo HPC consiste nell'esecuzione di *task* computazionalmente intensivi nel minor tempo possibile ed è dunque caratterizzato dalla necessità di grandi capacità di calcolo distribuite in brevi periodi di tempo (ore o giorni). Le performance di sistemi per HPC sono spesso misurate in *FLOPS* (FLoating point OPerations per Second).
- **HTC, High Throughput Computing**: il calcolo HTC consiste usualmente nell'esecuzione di molti task debolmente correlati (o di singoli task su grandi moli di dati) che si ha interesse siano completati efficientemente lungo periodo (mesi o anni).

La velocità della condivisione di istruzioni e dati caratteristici dei sistemi a memoria condivisa contro la flessibilità e la scalabilità dei sistemi a memoria distribuita tendono in maniera natuarale a far identificare i primi come soluzioni per HPC ed i secondi per HTC.

Anche in questo caso (specialmente nel caso di grandi sistemi) questi paradigmi possono combinarsi (ad esempio i sottosistemi di una infrastruttura per HTC possono essere effettivamente sistemi HPC).

## SETI@home

SETI@home è stato un progetto per la ricerca di segnali radio compatibili con segni di vita intelligente extraterrestre. Questo progetto è stato tra i primi e più famosi ad essersi avvalsi di una infrastruttura di calcolo distribuito *volontario* basata su internet, ovvero ad aver utilizzato le risorse, momentaneamente e gratuitamente messe a disposizione, di personal computer geograficamente distribuiti e connessi ad un nodo centrale tramite una connessione internet.

Oggi parte della tecnologia sviluppata per SETI@home è confluita in una infrastruttura per il calcolo distribuito indipendente dal particolare progetto di ricerca denominata BOINC (Berkley Open Infrastructure for Network Computing). 
Tramite quest'ultima gli utenti possono decidere di donare il proprio tempo di CPU ad uno o più progetti. Lo stesso SETI@home prosegue oggi come uno dei progetti ospitati da BOINC.

Nel caso di SETI@home l'obiettivo era analizzare tutto lo spettro delle frequenze di un radio telescopio per l'intero tempo di osservazione. Ciò che ha reso possibile l'impiego della infrastruttura di calcolo descritta 

1. I dati possono essere spacchettati in piccole porzioni (dell'ordine di 500 Kbyte), non è pertanto necessaria una connessione ad alte performance fra i singoli nodi.
2. Il tempo di CPU necessario per analizzare tali porzioni di dati su hardware di consumo è relativamente breve.
2. L'analisi dei segnali in ciascuna porzione è del tutto indipendente dalle altre ed è pertanto possibile eseguire tutti i job contemporaneamente (si dice che il problema è *embarassingly parallel* o *perfectly parallel*).

## Cluster

Un generico gruppo di calcolatori interconnessi ed in grado di lavorare cooperativamente come un unico sistema è in generale indicato come *cluster*.

Perchè un cluster possa essere considerato come un sistema a memoria distribuita è necessario:
 - hardware di rete ad elevate prestazioni
 - uno strato software che implementi le funzionalità richieste (interfacce, protocolli, librerie, etc.)
 - applicativi che sfruttino le capacità del sistema
 
Un esempio di queste librerie è *MPI* (Message Passing Interface) che permette di implementare in diversi linguaggi (C, C++, Fortran, Python, Julia) applicativi per sistemi a memoria distribuita. L'ovvia premessa è che, indipendentemente dal sistema particolare o dal linguaggio di programmazione, l'algoritmo sia parallelizzabile.

In generale esistono tre tipi di cluster (i primi due sono i più diffusi):

1. **Fail-over Cluster**: il funzionamento delle macchine è continuamente monitorato e quando una di queste ha un malfunzionamento un'altra subentra in attività.
2. **Load Balancing Cluster**: è un sistema nel quale le richieste di lavoro sono inviate alla macchina con meno carico di elaborazione distribuendo/bilanciando così il carico di lavoro sulle singole macchine. 
3. **HPC Cluster**: le macchine suddividono l'esecuzione di un *job* in più processi e questi ultimi vengono istanziati simulataneamente su più macchine (calcolo distribuito).

In generale i vantaggi offerti da un cluster rispetto ad un singolo calcolatore sono

- *Incremento delle capacità di calcolo* grazie allo sfruttamento di più unità di  calcolo e maggiore disponibilità di memoria
- *Maggiore affidabilità* in quanto il sistema continua a funzionare anche in caso di guasti di parti di esso (ovvero dei singoli calcolatori)
- *Minori costi*, infatti questi sistemi sono fino a 15 volte più economici dei tradizionali supercomputer rispetto ai quali, a parità di prestazioni, permettono un notevole risparmio sui componenti hardware
- *Scalabilità hardware*, possibilità di aggiungere ho rimpiazzare singole componenti a caldo
- *Disponibilità di un gran numero di software Open Source* come MOSIX e openMosix.

Gli svantaggi principali sono:

- Difficoltà di gestione e di organizzazione di un elevato numero di calcolatori
- Possibilità di problemi di connessione e di banda passante (specialmente di calcolatori lontani)
- Assieme allo hardware scala anche la probabilità di failure
- Scarse prestazioni nel caso di applicazioni non parallelizzabili

Fra i primi cluster si ricordano i cluster Beowulf, ovvero cluster di semplici personal computer collegati tramite reti informatiche standard, senza l'utilizzo di hardware esplicitamente sviluppato per il calcolo parallelo. Cluster di questo genere erano in genere cluster di computer IBM compatibili, implementati utilizzando software Open Source con lo scopo di eseguire task computazionalmente intensivi in genere in ambito tecnico scientifico. 

I Beowulf cluster sono caratterizzati da
- Accesso al sistema possibile solo dal nodo principale, che spesso è l'unico ad essere dotato di tastiera e monitor. 
- Nodi basati su di una architettura standard (x86,AMD64,PowerPC,etc.), usualmente uguale per tutti i nodi.
- Utilizzo di un sistema operativo (in genere GNU/Linux) e software Open Source

## Batch System

Gli atomi di calcolo (in cui viene istanziato un processo, letti o scritti dati, etc.) in un sistema multiutente (come può essere un cluster) vengono detti **job** (utilizzando una terminologia propria dei sistemi UNIX) e la richiesta di esecuzione di un job da parte di un utente è detta sottomissione di un job.

Per poter distribuire i job degli utenti su un cluster è necessario un software chiamato batch system (o PBS, Portable Batch System). Questi software si occupano di gestire l'ordine di esecuzione dei job e, in un sistema distribuito, di scegliere il nodo su cui verranno eseguiti. Dunque i batch sistem hanno il compito di accomodare le richieste degli utenti (*domanda*) e la disponibilità (limitata) di risorse (*offerta*), operazione nota in questo contesto come **matchmaking**.

Alcuni esempi di batch system sono Condor, Torque/Maui, LSF, SLURM, PBSPro, Oracle Grid Engine, Open Grid Engine.

La maggior parte di questi sistemi organizzano i job in una o più code e per questa ragione sono anche noti come *sistemi di code*. L'operazione di ordinare i job nella coda di esecuzione è nota come **job scheduling**, o scheduling, ed esistono diversi algoritmi che tentano di ottimizzare il problema dello scheduling rispetto a diversi parametri.

La premessa ovvia al problema dello scheduling è la capacità di monitorare le risorse. 

Genericamente i parametri rispetto a cui viene ottimizzato un algoritmo di scheduling sono

- **Throughput**: il numero totale di job che vengono completatti nell'unità di tempo
- **Latenze** ed in particolare
  - **Turnaround Time**: tempo totale tra la sottomissione di un processo ed il suo completamento
  - **Response Time**: lasso di tempo che intercorre fra la sottomissione di un job ed una risposta (es. stampa a video sul terminale) da parte del job
- **Fairness**: equità del tempo di calcolo assegnato a job della stessa priorità
- **Waiting Time**: tempo che un job spende inattivo nella propria coda

In pratica è non è possibile ottimizzare tutti questi parametri contemporaneamente (si consideri ad esempio il throughput e la latenza) ed è necessario realizzare un compromesso. I criteri con cui si realizza quest'ultimo sono caratteristici del particolare algoritmo di scheduling e rispondono a particolari esigenze, ad esempio, nel caso di un sistema in cui la sottomissione di job è un servizio a pagamento, parametri come la fairness ed il waiting time diventano prioritarì.

Alcuni esempi algoritmi di scheduling sono Unix Scheduling, FCFS (first Come, first Served), SJR (Shortest Job first), Small Job first / Big Job first, Priority Scheduling, Round Robin, Multilevel Queue, Multilevel Feedback Queue, FairShare.
