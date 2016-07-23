# Grid Computing

## Principi di calcolo a Grid

Una **Grid computazionale**, o semplicemente una Grid, è una infrastruttura hardware e software che garantisca un accesso affidabile, coerente, capillare ed economico a risorse computazionali ad alte prestazioni.

Dal punto di vista delle istituzioni che forniscono queste risorse il suo scopo è permettere una condivisione flessibile, sicura e coordinata di queste ultime.

Inoltre, dato l'interesse nella condivisione dinamica di risorse fra diverse organizzazioni, le tecnologie Grid non possono rimpiazzare le preesistenti tecnologie per il calcolo distribuito, ma devono piuttosto coesistere ed essere complementari a queste ultime.

Gli utenti di un sistema Grid operano generalmente all'interno di organizzazioni virtuali, a cui sono garantiti certi permessi e risorse.

Ci sono tre proprietà fondamentali che caratterizzano una Grid rispetto ad altri sistemi per il calcolo distribuito

1. Coordinazione su *larga scala* di risorse geograficamente distribuite ed appartenenti a diversi domini amministrativi
2. Protocolli ed interfacce standard, aperte e polivalenti, tali da provvedere ad una ampia gamma di servizi
3. Capacità di fornire vari tipi di qualità del servizio (QoS, Quality of Service), ovvero di coordinare le risorse in modo da fornire un servizio calibrato sulle richieste degli utenti.

Inoltre una Grid presuppone l'assenza di

1. **Central control**: una istituzione/nodo centrale a cui facciano riferimento tutti gli altri.
2. **Omniscience**: la conoscenza da parte di ogni istituzione/nodo dello stato di tutti gli altri.
3. **Existing Trust Relationship**: autenticazione degli individui o delle istituzioni sulla base di relazioni di fiducia preesistenti o comunque esterni alla Grid.

Il genere di problemi che una Grid cerca di risolvere è del tipo

> Eseguire il programma X nel sito Y con permessi P, provvedendo accesso ai dati sul sito Z in accordo ai permessi Q

Riassuntivamente una Grid fornisce un livello di astrazione che rende accessibile un ambiente di calcolo distribuito ad alte performance per gli utenti e che permette la condivisione di risorse per le istituzioni, in maniera trasparente ed immune da tre generi di eterogeneità:

1. delle risorse
2. delle policy
3. delle applicazioni

Si osserva che il calcolo su Grid si può definire calcolo distribuito con le seguenti precisazioni

1. Non viene condiviso solo un processo fra i nodi (dunque tempo di CPU e memoria) ma anche dati e software (in breve viene offerto, in accordo ai permessi posseduti dall'utente, l'accesso ad una intera macchina)
2. L'esecuzione di un singolo job avviene su una singola macchina (o su un singolo cluster di macchine), ovvero i job sono tra loro indipendenti.

Un esempio di Grid è **EGI** (European Grid Infrastructure), nata da progetti precedenti come DataGrid e EGEEE (Enabling Grids for E-SciencE).

## Sottomissione di job ad una Grid

Per Grid middleware si intende una serie di componenti software che fungono da intermediari tra l'infrastruttura e le applicazioni utente, rendendo possibile la condivisione di risorse ed infine il calcolo su Grid. Alcuni esempi di Grid middleware sono gLite e EMI, entrambi collegati a EGI.

Le varie componenti di un Grid middleware si possono classificare in

1. **Servizi di Accesso**: CLI, API, etc.
2. **Servizi di Sicurezza**: autenticazione e autorizzazioni
3. **Servizi di informazione e monitoraggio**: monitoraggio dello stato dei servizi, del carico dei sistemi, etc.
4. **Servizi Dati**: catalogo dei file e delle repliche, catalogo dei metadati, archiviazione fisica dei dati
5. **Servizi di Elaborazione**: gestione dei job, interfacciamento con i siti di calcolo, etc.

Considerando l'esempio di EGI è possibile illustrare i disersi componenti di un Grid middleware.

Un utente che vuole sottomettere un job, in questo contesto noto come *gridlet*, deve preparare un **job description file** ovvero un file che contiene una descrione del job in un linguaggio noto come **JDL** (Job Description Language).

JDL è un linguaggio flessibile, estensibile e di alto livello, derivato da **ClassAd** (CLASSified Advertisement language), il linguaggio utilizzato dal batch system *Condor*. Sia JDL che ClassAd contengono una struttura a record composta da un certo numero di attributi separati da un punto e virgola (`;`).

Un file JDL in genere contiene almeno i seguenti campi

1. `Executable` : deve essere uno shell script (in genere bash, csh o tcsh).
2. `StdOutput` : nome del file che conterrà la l'output del job (i.e. lo standard output)
3. `StdError` : nome del file che conterrà gli errori del job (i.e. lo standard error)

Altri campi importanti sono

1. `Type` : può assumere i valori **Job**, che può essere a sua volta normale (default) o parametrico, **DAG** (Directed Acyclic Graph) o **Collection**
2. `Argoments` : contiene gli argomenti da passare allo script che deve essere eseguito
3. `Environment` : contiene una o più variabili d'ambiente da esportare prima di eseguire lo script (in JDL è possibile costruire un vettore di espressioni con le parentesi graffe `{}`)
4. `InputSandbox` : elenco dei file che devono essere inviati insieme al job
5. `OutputSandbox` : elenco dei file (inclusi lo standard error e output) che devono essere restituiti in caso di esecuzione con successo del job.
6. `Requirements` : richieste sul working node che eseguirà il job (ad esempio sul sistema operativo, supporto per OpenMP o OpenMPI, etc.)

Si osserva che con una singola richiesta è possibile istanziare più job in una volta, infatti

- un job parametrico è un job in cui uno o più argomenti variano in un intervallo
- un DAG è un insieme di job con relazioni di dipendenza reciproca che possono essere descritte da un grafo diretto aciclico (e per il quale esiste una specifica sintassi)
- una collezione è un insieme di job indipendenti

Si osserva che in questo modo si riduce il tempo di sottomissione (singola autenticazione/autorizzazione, etc.).

Considerato lo script di esempio

```
#!/bin/sh
# test.sh
echo $*
```

un semplice job description file può essere (i commenti su una linea usano `#` quelli su più linee devono essere incapsulati in `/* */`)

```
# test.jdl

Executable    = "test.sh";
Arguments     = "Hello world!";
StdOutput     = "std.out";
StdError      = "std.err";
InputSandbox  = {"test.sh"};
OutputSandbox = {"std.out", "std.err"};
```

Il job description file viene quindi inviato al **WMS** (Workload Management System), che (fra gli altri) ha l'incarico di assegnare l'esecuzione del job ad un particolare sito di calcolo (CE, Computing Element, che in generale può essere una macchina o un cluster) tenendo conto delle preferenze espresse nel job description file (matchmaking). A questo punto il job si trova in una **coda globale**, in attesa di essere assegnato. Successivamente il WMS richiede informazioni allo **Information Index** o **Information System**, che contiene un database dei CE attualmente disponibili, del loro carico di lavoro ed eventualmente delle loro policy. Si osserva che a questo scopo i CE comunicano direttamente con lo information index. Tramite queste informazioni uno dei componenti del WMS detto **Resource Broker** computa il CE più opportuno su cui eseguire il job. Il WMS può quindi inoltrare il job su una **coda locale** attraverso un suo componente che il cui compito è interfacciarsi con il batch system locale del CE (CREAM, Computing Resource Execution and Management, per gLite e EMI-ES, EMI Execution Service, per EMI). Fra i batch system supportati figurano PBS(Torque/MAUI), LSF, SGE.

Ogni passaggio del ciclo di vita di un job è registrato da un servizio chiamato **Logging and Bookkeeping** (LB), con cui sono in comunicazione sia il WMS che il CE. Questo è utile ad esempio per conoscere lo stato di un job che è stato sottomesso, infatti gli utenti possono tracciare lo stato del proprio job conoscendone lo ID (che viene comunicato durante la sottomissione). Dopo essere stato eseguito successo da un **Worker Node** l'output del job viene inoltrato automaticamente (tramite il CE) al WMS , da cui l'utente può ottenere una copia (in questo schema l'utente non si interfaccia mai direttamente col CE, tuttavia non è l'unica implementazione possibile).

Tra i comandi a disposizione di un utente vi sono

**Description**                **Command**
-----------------------------  ------------------------------
 Submitting a job 	            `glite-wms-job-submit`
 Checking job status 	         `glite-wms-job-status`
 Retrieving job output         `glite-wms-job-output`
 Checking job history 	        `glite-wms-job-logging-info`
 Listing compatible resources 	`glite-wms-job-list-match`
 Delegate a proxy 	            `glite-wms-job-delegate-proxy`


## Gestione della sicurezza in Grid

In genere in una Grid viene utilizzato (ed ampliato) lo standard X.509. Ad esempio in EGI le certification authority riconosciute sono diverse ed hanno in genere base nazionale, tuttavia esiste un progetto per la coordinazione delle CA europee chiamato EUGridPMA (quest'ultimo in realtà include diverse CA extra-europee, oltre a collaborare con analoge organizzazioni in Asia e negli Stati Uniti).

Sempre in EGI i root certificate sono distribuiti tramite *pacchetti* per diversi sistemi operativi e disponibili in repository pubblici (dopo aver aggiunto il repository è possibile installare tutti i certificati tramite il metapacchetto `lcg-CA`).

Uno degli standard di sicurezza adottato su Grid è (Grid Security Infrastructure) basato sullo standard PKI X.509. In questo standard ogni transazione (scambio di dati, invio di istruzioni, etc.) è **mutualmente autenticato**.

Infatti tramite lo standard di sicurezza X.509 è possibile risolvere (oltre ai problemi di confidenzialità, integrità e non ripudio) il problema della autenticazione. Il meccanismo è il seguente.

All'inizio di una transazione tra due utenti A e B (ciascuno dei due può essere un individuo, un software o una macchina), dopo aver stabilito una connessione

1. A invia a B una copia del proprio certificato.
2. B ne verifica la validità tramite la firma della CA (che può verificare a sua volta tramite i root certificates).
3. Se la verifica del certificato di A è andato a buon termine, B invia un messaggio casuale (*challenge string*) che contiene un *timestamp*, ovvero una indicazione che permette di datare univocamente la transazione.
4. A firma la challenge string ed invia la firma a B.
5. B verifica la firma e autentica A

Perchè vi sia mutua autenticazione si ripete la procedura a ruoli invertiti. Si osserva che il solo certificato non autentica A, ma garantisce soltanto la corrispondenza fra l'identità di A ed una chiave pubblica. Invece nella procedura descritta (anche nota come CHAP, Challenge-Handshake Authentication Protocol) A viene autenticato nella misura in cui si è certi che solo A sia in possesso della chiave privata di A. L'ultima considerazione è cruciale in tutti i sistemi di sicurezza basati su chiavi asimmetriche e deve essere sempre tenuto presente.

Nella effettiva implementazione della autenticazione nei servizi Grid viene utilizzata una estensione dei certificati X.509 detta **X.509 proxy certificate** o **certificati proxy**. Questi certificati sono contraddistinti dalle seguenti caratteristiche

1. Hanno durata piuttosto breve, dell'ordine di alcune ore (usualmente 12) contro i certificati personali che hanno in genere durata annuale
2. Contengono al loro interno una coppia di chiavi, pubblica e privata

Questa estensione ha la seguente motivazione. Nel contesto di una Grid è spesso necessario che un servizio o l'istanza di un software possano agire per conto dell'utente (ad esempio un job può aver bisogno di recuperare una copia di un file e dunque di dover contattare un server ed autenticarsi). Deve pertanto esistere un meccanismo in grado di trasferire la propria capacità di autenticazione, questo meccanismo è noto come **delegazione**.

Una soluzione ingenua potrebbe essere quella di rilasciare insieme al proprio certificato una copia della propria chiave privata. Tuttavia per quanto già osservato una soluzione di questo genere comporterebbe gravi problemi di sicurezza.

Quando si crea un certificato proxy vengono create una coppia di chiavi ed incluse nel certificato, tuttavia la propria chiave privata personale **non** viene allegata. In questo modo la propria identità è stata delegata. Infatti un individuo o un servizio in possesso un certificato proxy potrà non solo instaurare una relazione di fiducia con altri utenti (essendo in possesso di un certificato valido), ma anche autenticarsi grazie alla propria chiave privata.

Inoltre un proxy può delegare a sua volta la propria identità prolungando la catena della fiducia.

Chiaramente in termini di sicurezza un proxy è un compromesso. Infatti la delegazione implica che esista nel sistema una coppia di chiavi (non cifrate). Pertanto, tramite la chiave privata di un proxy, è possibile impersonare l'identità (delegata) dell'utente che in origine ha creato il proxy. Tuttavia la delegazione è solo temporanea ed ha il grande vantaggio che la chiave privata dell'utente rimane sempre segreta.

Lo standard GSI prevede ulteriori estensioni a X.509 con lo scopo di semplificare la gestione delle autorizzazioni. Infatti il problema delle autorizzazioni è complesso e consiste nell'accomodare i permessi garantiti da due diverse entità

1. Virtual Organizazion (VO)
2. Resource Provider (RP),

Lo sviluppo dei **VOMS** (Virtual Organization Membership Service) nei sistemi Grid è stato una risposta all'esigenza di centralizzare la gestione delle autorizzazioni nelle organizzazioni virtuali. A questo scopo i certificati proxy sono stati estesi al fine di poter (opzionalmente) contenere informazioni associate ai permessi entro l'organizzazione virtuale di appartenenza. Queste informazioni sono

1. Organizzazione virtuale di appartenenza
2. Una lista dei gruppi di appartenenza. Infatti le organizzazioni virtuali hanno una struttura ad albero (simile ad un filesystem UNIX) i cui nodi sono le organizzazioni e di cui la VO rappresenta la radice (ogni utente della VO deve appartenere ad almeno un gruppo e può appartenere a più gruppi)
3. Ruolo all'interno del gruppo, che può considerarsi come una regolazione fine dei permessi rispetto ai assegnazione ad un gruppo. Si osserva che i ruoli sono relativi al gruppo, nel senso che ruoli con lo stesso identificativo in gruppi diversi hanno diverso significato.
4. Capacità, ovvero autorizzazioni speciali o temporanee (un utente può ad esempio avere permessi di amministrazione solamente durante i suoi *turni*)

Infine i resource provider sono liberi di computare le autorizzazioni del richiedente sulla base di queste informazioni, delle sue credenziali e delle proprie policy.

I comandi a disposizione dell'utente sono `voms-proxy-init`, `voms-proxy-destroy` e `voms-proxy-info`. L'invocazione di `voms-proxy-init` comporta le seguenti operazioni. Viene creato un proxy localmente, successivamente viene inoltrato al server VOMS che aggiunge i campi al proxy e lo firma.
