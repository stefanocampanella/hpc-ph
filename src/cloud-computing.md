# Cloud Computing & Storage

Le tecnologie di cloud computig hanno avuto negli ultimi anni largo impiego nelle realtà aziendali ed è sempre più probabile che nel futuro diventeranno parte integrante dellle infrastrutture per il calcolo scientifico (attualmente già in fase di sperimentazione).

Storicamente Amazon è stata fra le prime aziende a sperimentare queste tecnologie ed a offrire servizi collegati. Ciò nacque dalla esigenza di sfruttare, dunque vendere, le risorse di calcolo in eccesso a propria disposizione, le quali erano state acquistate per affrontare i picchi di domanda sui propri store online in certi periodi dell'anno.

La soluzione ideata fu di mettere a disposizione queste risorse di calcolo ad altre aziende che avessero simili problemi di picchi di carico. Naturalmente una soluzione di questo genere comportò l'ideazione di tecnologie atte a rendere utilmente disponibili queste risorse ed isolare fra loro gli utenti di queste ultime. Oggi, dopo alcuni anni di sviluppo, queste tecnologie vengono complessivamente indicate come **cloud computing**.

Nel caso del cloud computing la *tecnologia abilitante*, ovvero senza la quale questi sviluppi non sarebbero stati possibili, è stata la **virtualizzazione**.

## Virtualizzazione

Informalmente, con virtualizzazione si intende la creazione di una versione virtuale di qualcosa, che può essere ad esempio una piattaforma hardware, un dispositivo o un sistema operativo. Questo comporta la creazione di un livello di astrazione intermedio che riproduce certe funzionalità e nasconde i dettagli di ciò che avviene a più basso livello, interfacciandosi con i livelli di astrazione superiore come farebbe l'oggetto che è stato virtualizzato.

Un esempio di questo genere di tecnologie è la **Java Virtual Machine** (JVM), ovvero un processore virtuale in grado di eseguire un set di istruzioni detto **Java bytecode**. In questo caso se si vuole eseguire codice Java, quest'ultimo deve essere compilato in bytecode ed eseguito su JVM. Questo risolve (in teoria) non solo il problema della portabilità del codice, che in questo modo è indipendente dalla piattaforma, ma anche dello stesso eseguibile, ovvero il java bytecode che può essere eseguito su architetture e sistemi operativi diversi purchè sia stata implementata per questi ultimi una JVM.

Nel discorso che segue per virtualizzazione si intenderà *virtualizzazione dell'intera piattaforma hardware*, ovvero dove generalmente il livello di astrazione creato si frappone fra l'hardware fisico ed il sistema operativo.

### Tipi di virtualizzazione

Si possono distinguere diversi tipi di virtualizzazione ed il primo che è possibile evidenziare è la **emulazione**. Si parla di emulazione quando i sistemi virtuali possiedono una architettura diversa dall'ospite ed usano un differente set di istruzioni. In altri termini nella emulazione l'hardware virtuale viene simulato (a spese di maggiori risorse, dunque **overhead**).

Il caso in cui i sistemi virtualizzati (*guest*) abbiano la stessa architettura dei sistemi ospite (*host*) si può distinguere ancora in **virtualizzazione completa** e **paravirtualizzazione**.

Nel caso della virtualizzzazione completa il sistema operativo ospite non è a conoscenza di essere eseguito su di una macchina virtuale e vede le stesse interfacce di una macchina fisica e dunque funziona senza alcuna modifica. In questo caso il livello software fra le macchine virtuali (VM) ed la macchina fisica viene detto **hypervisor** ed ha l'onere di tradurre (o inoltrare) le *system call* delle prime verso quest'ultima.

Nel caso della paravirtualizzazione i sistemi operativi delle VM sono a conoscenza della virtualizzazione dell'hardware sottostante e possono pertanto essere messe in atto delle ottimizzazioni. Queste consistono in modifiche della interfaccia, tramite chiamate speciali dette **hypercall**, permettendo ad esempio di eseguire istanze di codice in un ambiente non virtuale, dunque direttamente sull'hardware.

Gli hypervisor si distinguono a loro volta fra

- Tipo 1 o **bare metal**
- Tipo 2 o **hosted**

Gli hypervisor bare metal vengono eseguiti direttamente sull'hardware e le funzionalità di virtualizzazione si fondono insieme ad un kernel specifico in un SO *leggero* (dedicato alla virtualizzazione, non general purpose) che include anche tutti i driver per le periferiche ed il sistema di gestione/realizzazione delle macchine virtuali. Sono esempi di hypervisor bare metal: XEN, VMware vSphere, Parallels Server 4, Bare Metal e Hyper-V.

Gli hypervisor hosted invece sono normali applicativi eseguiti all'interno di un sistema operativo, ed in particolare installati ed eseguiti in user space, in grado di fornire funzionalità di virtualizzazione. Un esempio di questi ultimi è Oracle VirtualBox.

Esiste in realtà un terzo genere di hypervisor, in qualche misura ibrido rispetto ai primi due, detto **KVM** (*Linux Kernel-based Virtual Machine**), il quale è una infrastruttura di virtualizzazione che trasforma il kernel Linux in un hypervisor. In questo caso le funzioni di virtualizzazione vengono offerte da applicativi in user space che tuttavia fanno uso di interfacce esposte da un modulo del kernel Linux. Inoltre KVM può approfittare di alcune estensioni hardware dedicate alla virtualizzazione, in particolare legate alla gestione della memoria, ed in genere supportate dalle ultime generazioni di processori che permettono un migliore sfruttamento delle risorse (riduzione overhead).

### Vantaggi della virtualizzazione

L'avanzamento tecnologico degli ultimi anni ha prodotto una situazione in cui (generalmente ed in media) gli applicativi non sono più in grado di saturare le risorse hardware disponibili, sia nel caso di personal computing che, in maniera ancora più accentuata, in ambito aziendale.

Infatti si stima che un moderno server venga sfruttato solo al 15-20% e pertanto la virtualizzazione offre, permettendo di ospitare 3 o 4 machine virtuali sullo stesso hardware, il vantaggio di un miglior sfruttamento delle risorse, chiamato in ambito aziendale **consolidamento dei server**, e dunque la **riduzione dei server fisici**. Quest'ultima comporta la riduzione dei consumi energetici (quindi la necessità di impianti di raffreddamento meno potenti), dei **guasti hardware**, dei tempi tecnici per il montaggio ed il cablaggio, del numero di armadi (*rack*) e pertanto l'abbattimento dello spazio dedicato in sala macchine per questi ultimi ed il loro relativo cablaggio.

Inoltre il software, ed in particolar modo il sistema operativo in esecuzione su una macchina, è in genere strettamente legato all'hardware su cui viene eseguito. Pertanto se, ad esempio per un guasto hardware, si deve migrare una installazione da una macchina ad un'altra, si dovrà spendere del tempo nella configurazione del nuovo hardware. A questo proposito la virtualizzazione offre il vantaggio della **indipendenza hardware**, infatti il sistema operativo guest non si interfaccia con l'hardware fisico ma con un livello di astrazione di quest'ultimo e l'amministratore potrebbe spostare o clonare una macchina virtuale su altre macchine fisiche che eseguano lo stesso ambiente di virtualizzazione senza ulteriore lavoro (se si esclude la configurazione di quest'ultimo).

L'indipendenza dallo hardware in alcuni casi non rappresenta semplicemente una semplificazione della amministrazione straordinaria di sistema ma una necessità. Il tipico esempio è il supporto di vecchie applicazioni (**legacy**), ad esempio sviluppate per DOS, non in grado di supportare hardware più recente. In questi casi gli ambienti di virtualizzazione permettono l'esecuzione anche di sistemi *legacy* permettendo ai responsabili IT di liberarsi del vecchio hardware non più supportato e più soggetto a guasti.

Un ulteriore vantaggio è la **standardadizzazione del runtime**, ovvero mettere appunti ambienti di sviluppo (ma anche postazioni di lavoro, server di posta, etc.) omogenei in maniera semplicemente riproducibile, e la **creazione di ambienti di test**, ovvero di ambienti isolati che possano essere facilmente creati, distrutti o ripristinati ad uno stato precedente, per testare software.

### Svantaggi della virtualizzazione

Una delle caratteristiche richieste fin da principio alle tecnologie di virtualizzazione è l'isolamento dei dati e dei processi dei sistemi virtualizzati. In particolare questo aspetto, come si vedrà in seguito, emerge preponderantemente nei casi in cui gli utenti dei sistemi virtualizzati acquistano come servizio l'infrastruttura di virtualizzazione da terzi e pertanto si richiede che sullo stesso hardware coesistano diversi utenti senza collidere.

Tuttavia l'isolamento è realizzato dal software di virtualizzazione ed i **problemi di sicurezza** che derivano da bachi di quest'ultimo sono fra i principali svantaggi di queste tecnologie.

Inoltre l'introduzione di un livello software fra i sistemi virtualizzati e lo hardware ha come inevitabile contropartita una **diminuzione delle performance** (seppure minima, grazie al perfezionamento di queste tecnologie ed al loro elevato grado di maturità). Concretamente questa riduzione delle perfomance consiste in un overhead di esecuzione praticamente non rilevabile ed in una **riduzione del throughput di I/O** su disco e di rete misurabili (meno importanti nel caso di paravirtualizzazione e trascurabili per quest'ultimo per traffico di rete).

## Cloud Computing

Le peculiarità delle tecnologie di virtualizzazione hanno introdotto negli ultimi anni una modifica radicale degli approcci al calcolo, con applicazioni al calcolo scientifico.

Storicamente in principio, in ambito aziendale ma anche scientifico, il calcolo era affidato ai *mainframe*, grandi macchine con differenze architetturali (sia hw che sw) sostanziali rispetto ai server comunemente diffusi oggi, le cui risorse, ovvero tempo di calcolo, venivano allocate in maniera molto critica -- sistemi di questo genere continuano ad esistere ad esempio in banche o agenzie governative.

Successivamente, grazie agli sviluppi tecnologici ed in particolare la miniaturizzazione dell'elettronica, si affermò un modello di calcolo basato su hardware in pieno controllo dell'utente (*personal computers*), successivamente sull'accesso a risorse di calcolo remote (*client-server computing*) ed in particolare (successivamente) sull'accesso a documenti remoti (*Web*).

Negli ultmi dieci anni, in particolare grazie alle tecnologie di virtualizzazione, si è sviluppato un nuovo paradigma basato sull'accesso a risorse di calcolo remote con caratteristiche innovative detto **cloud computing**.

### Traditional infrastructure model

Sia in ambito aziendale che scientifico la crescita nel tempo di una istituzione in genere comporta una maggiore richiesta di risorse di calcolo, ad esempio per un aumento della base di utenti.

L'approccio tradizionale a questo problema era di acquistare un surplus di risorse, rispetto alla domanda attuale, per tenere il passo delle delle richieste future. Le previsioni sul tasso di crescita e la frequenza degli aggiornamenti determinavano l'entità di questo surplus. Si osserva che, anche nel caso ideale di una crescita monotona con previsioni affidabili sul tasso di crescita, questa è una soluzione non ottima in quanto per certi lassi di tempo vengono allocate (dunque pagate) risorse che rimangono inutilizzate.

Nei casi reali questo genere di soluzioni presenta ulteriori svantaggi. Infatti in questi ultimi la domanda di risorse, pur potendo avere in media semplice (ad esempio una crescita lineare), è in genere soggetta a fasi di crescita e contrazione, con un tasso non prevedibile. Le conseguenze di queste oscillazioni sono dei **surplus con perdite non accettabili** (spese troppo ingenti rispetto al consumo di risorse) e **periodi di deficit**.

Da questa discussione emerge che i problemi di questo approccio sono la lentezza degli interventi di aggiornamento delle infrastrutture e la loro irreversibilità, nel senso che una volta acquistate non è possibile (o non è conveniente) cederle o smantellarle e rappresentano un costo fisso.

Il **cloud computin** è un insieme di tecnologie che permette un approccio al problema delle risorse radicalmente differente, rendendo possibile ad esempio approntare una infrastruttura di calcolo in tempi dell'ordine di alcuni minuti, contro le diverse settimane necessarie nel caso di IT tradizionale.

### Definizione di cloud computing

In letteratura la definizione di riferimento per le tecnologie di cloud computing è quella data dal *National Institute of Standards and Technology* USA (**NIST**), che in sintesi definisce queste ultime come

> **fornitura** di tecnologia di **informazione e comunicazione** (ICT) come **servizio**

Si osserva che concettualmente il termine di maggior peso in questa definizione è *servizio*, il quale racchiude il contenuto innovativo di queste tecnologie (e dei paradigmi che rendono possibili).

La definizione del NIST inoltre prevede alcuni punti

- **On demand self service:** l'utente del servizio deve essere in grado di ottenere in maniera semplice, trasparente ed automatica risorse di calcolo, come ad esempio CPU time o dischi, alla bisogna, senza la necessità di una interazione diretta con gli amministratori dei service provider o di un intervento umano.
- **Broad network access:** il servizio deve essere distribuito ed accessibile tramite la rete
- **Resource pooling:** le risorse di calcolo, fisiche o virtuali, disponibili al service provider devono essere distribuite e riassegnate dinamicamente agli utenti in base alla domanda senza che questi ultimi collidano, ovvero realizzando una condizione di **isolamento** dei dati e dei processi di questi ultimi in un ambiente fortemente **multi-tenant**.
- **Rapid elasticity:** il servizio deve essere non solo in grado di fornire risorse di calcolo *elasticamente*, ovvero in base al carico, ma specialmente in maniera **rapida**, ovvero adattandosi a quest'ultimo in tempi brevi ed idealmente tenendo il passo della domanda in tempo reale.
- **Measured service:** i service provider devono essere in grado di misurare l'erogazione del servizio, utilizzando metriche di un livello di astrazione adeguato al genere di servizio, in modo da poter sia addebitare eventuali costi di servizio che, più in generale, ottimizzare le risorse fra gli utenti, ad esempio in base alle priorità assegnate alle organizzazioni a cui appartengono.

Una analogia utile a cogliere alcuni aspetti del cloud computing è quella con il noleggio auto:

- l'utente effettua una prenotazione telefonica o online senza la necessità di un intervento umano (*self service*) e accendendo un contratto temporaneo relativo alla prestazione particolare (*on demand*)
- il service provider (agenzia di autonoleggio) possiede una rete di distribuzione geograficamente distribuita (*broad network access*)
- le risorse (il parco vetture) viene riorganizzato per garantire il servizio in maniera trasparente all'utente (*resource pooling*)
- i dettagli del noleggio sono stabiliti in base alla domanda e possono essere semplicemente modificati (*rapid elasticity*)
- l'addebito agli utenti viene effettuato in base al consumo (*measured service*)

<!-- L'ultimo punto mostra una analogia con il cloud computing che mette in luce l'inadeguatezza delle infrastrutture IT tradizionali: data una richiesta di maggiori risorse, in questo caso autovetture (server nel caso IT), per l'utente sarebbe necessario acquistarne al loro inter costo dell'intero parco vetture! -->

### Service models

Il paradigma reso possibile dalle tecnologie di cloud computing presenta delle analogie con altri sistemi di condivisione di risorse di calcolo geograficamente distribuite, come ad esempio la GRID, tuttavia *nel cloud computing il focus è sul servizio* e questa, che è una caratteristica distintiva di queste tecnologie, ne ha sancito il successo in ambito aziendale.

Nel caso del grid computing la risorsa messa a disposizione dalla infrastruttura è essenzialmente la capacità di eseguire un applicativo, ovvero di sottomettere un job ad un **batch system** che può amministrare risorse facendo uso di tecnologie vicine a quelle adoperate per cloud computing. Quest'ultima è una differenza sostanziale rispetto al cloud computing propriamente detto in cui il panorama dei servizi offerti è molto più ricco e variegato, comportando un profondo divario nella implementazione di queste due tecnologie oltre che nell'approccio al problema.

Inoltre il grid computing si è affermato solamente all'interno della comunità scientifica mentre il cloud computing ha suscitato grande interesse nelle realtà aziendali ed è oggi una tecnologia matura ampliamente adottata in questi contesti, con alcune sperimentazioni in ambito scientifico.

Le tecnologie di cloud computing vengono in genere classificate in base alla tipologia di servizi che vengono erogati e si distinguono, in prima istanza, in tre livelli

- Infrastructure as a Service (**IaaS**)
- Platform as a Service (**PaaS**)
- Software as a Service (**SaaS**)

e successivamente il concetto di *Something as a Service* è stato esteso ad altri sottolivelli e servizi specifici.

### Infrastructure as a Service

Nel caso di IaaS il service provider mette a disposizione essenzialmente un ambiente di virtualizzazione e fornisce un certo numero di macchine virtuali, con certe caratteristiche, in base alla domanda dell'utenza.
Pertanto in questo livello di servizio tutto ciò che arriva fino al livello del sistema operativo è di competenza del service provider, mentre ciò che viene installato sulla macchina (middleware, software, etc.) diventa responsabilità dell'utente.

Semplificando, la differenza rispetto alla virtualizzazione su hardware in proprio controllo è che è possibile ottenere in pochi passaggi e su richiesta una macchina virtuale, con CPU, memoria e dischi richiesti, con un sistema operativo scelto senza dover conoscere i dettagli, o dover spendere energie nell'implementazione, della infrastruttura sottostante.

In questo caso l'utente può configurare il servizio assemblando virtualmente macchine, dischi, componenti di rete, etc, in maniera automatizzata senza interaggire direttamente con gli amministratori del datacenter in cui è fisicamente ospitato lo hardware (ad esempio tramite una interfaccia Web). Tuttavia questo da solo non sarebbe sufficiente a definire questo genere di servizi cloud computing, infatti ciò che permette di definire quest'ultimo cloud computing è la **flessibilità** del servizio, in accordo al concetto più generale di *rapid elasticity* (che diventà **dinamicità** o **scalabilità dinamica** del caso SaaS o PaaS).

Ad esempio un ipotetico servizio in cui sia possibile noleggiare una macchina virtuale con certe caratteristiche accendendo un contratto specifico per quella soluzione (*managed hosting*) non potrebbe essere definito cloud computing: nel caso di IaaS è importante che l'utente sia in grado di modificare le caratteristiche del servizio, ovvero l'infrastruttura e dunque CPU, dischi, etc., dinamicamente.

Questi servizi sono caratterizzati da:

- Ambienti multitenant virtualizzati e sistemi critici per l'isolamento dei dati e dei processi degli utenti
- Addebito in genere stabilito in base al wall time, non in base all'uso
- Nelle implementazioni reali, possibilità di accoppiare servizi per l'installazione e la manutenzione dei sistemi operativi o del runtime
- Accesso con diritti di amministrazione da parte dell'utente

Lo svantaggio peculiare della IaaS consiste nella lentezza e nella complessità nella creazione o modifica di macchine virtuali. In risposta a queste difficoltà molti utenti hanno preferito sistemi più evoluti, nella direzione di PaaS e SaaS, in cui i sistemi scalino dinamicamente, in maniera più automatica e trasparente all'utente, e IaaS è rimasto un servizio riservato ad utenti con esigenze piuttosto specifiche.

### Platform as a Service

Nel caso Platform as a Service quello che fornisce il service provider è un sistema dove il runtime è già disponibile, ovvero dove l'applicazione oggetto del servizio è pronta per essere usata dallo sviluppatore, che in questo contesto è l'utente del servizio. Ad esempio prima di poter sviluppare codice in C è necessario istallare un compilatore, un debugger ed in genere delle librerie, nel caso di PaaS allo sviluppatore viene fornito un ambiente pronto per la compilazione e l'esecuzione del codice, senza che quest'ultimo sia a conoscenza dei dettagli dell'infrastruttura che rende questo possibile o dell'onere di doverla preparare.

Nel caso PaaS il service provider fornisce all'utente tutti gli strumenti per lo sviluppo remoto delle sue applicazioni in maniera semplice (ad esempio tramite l'uso di interfacce Web) e la possibilità di gestire in maniera semplice l'intero ciclo di vita di queste ultime.

Sinteticamente Platform as a Service è un metodo per l'erogazione di risorse di calcolo attraverso una piattaforma, ovvero tramite una infrastruttura di componenti hardware e software disponibile all'uso e di cui non è necessario conoscere i meccanismi interni. Tutto ciò permette in questo modo di abbattere i tempi ed i costi per lo sviluppo ed il collaudo di applicazioni ed ha segnato il successo di questo approccio. Tuttavia questo da solo non sarebbe sufficiente per parlare di questi servizi come cloud computing, infatti la caratteristica principale di questi servizi è di scalare dinamicamente in base alle richieste degli applicativi sottomessi.

Questo tipo di servizi è caratterizzato da:

- Ambienti multitenant
- Scalabilità dei sistemi

Il principale svantaggio per l'utenza nella sottoscrizione a questi servizi è la dipendenza degli applicativi dalla piattaforma particolare e dunque la difficoltà, o addirittura l'impossibilità, di migrare verso un'altro service provider in un secondo momento.

Come già osservato i service provider di IaaS hanno gradualmente inglobato servizi di PaaS ed oggi è molto difficile trovare un service provider che faccia esclusivamente PaaS.

### Software as a Service

L'ultimo livello nella scala dei servizi offerti dal service provider è il caso **Software as a Service**, o **cloud application**. In questo caso l'utente del servizio è effettivamente l'utente finale ed a quest'ultimo viene fornito direttamente l'applicativo. Alcuni esempi noti sono **Gmail** e **Google Documents**.

Questi applicativi sono probabilmente la forma più popolare di cloud computing e sono in genere di utilizzo molto immediato, infatti sono in genere accessibili direttamente tramite un browser web e rimuovono la necessità di installazione e configuratione del software su computer individuali. Comportano inoltre notevoli semplificazioni anche per i fornitori del servizio, specialmente nell'erogazione del supporto dal momento che tutta l'infrastruttura (applicativi, rutime, sistema operativo e hardware) sono loro direttamente accessibili.

Sinteticamente si può dire che SaaS è un metodo per la distribuzione di applicativi che fornisce un accesso remoto alle funzionalità di questi ultimi, usualmente traimte interfacce Web, a diversi utenti forniti di licenza. Questi servizi sono in genere caratterizzati da

- Ambienti multitenant e sistemi per l'isolamento dei dati degli utenti
- Universalmente accessibili, ovvero entro certi limiti indipendenti dal software o hardware particolare dell'utenza
- Addebiti stabiliti in base all'uso
- Grande scalabilità dei sistemi per l'erogazione del servizio (intrinseca nella gestione del servizio e completamente delegata al fornitore)
- Sistemi di gestione delle licenze quindi, termini più astratti, gestione critica dei permessi
- Isolamento dei dati degli utenti

I principali problemi per l'utenza di questi servizi sono legati all'accesso, la persistenza ed al possesso ai dati, con ovvie implicazioni per la privacy degli utenti. Infatti **il servizio ed i dati sono strettamente collegati**, cosa che comporta notevoli conseguenze come ad esempio la possibile perdita dei dati in caso di interruzione del servizio.

### Alcuni esempi di service models

Queste definizioni sono piuttosto astratte e generali, è possibile vedere con alcuni esempi concreti la loro declinazione nel mondo reale.

#### SaaS case study: Salesforce.com e Google Apps

Un importante esempio di Software as a Service è [salesforce.com](www.salesforce.com) che fornisce software per gestire le relazioni con i clienti per le aziende (*business-to-business*). In questo caso l'utente, ovvero l'azienda, compone le proprie applicazioni assemblando pacchetti relativi a particolari servizi (modulo gestione clienti, modulo gestione fornitori, gestione del magazzino, etc.).

Nella esperienza comune Google Apps rappresenta un esempio classico di SaaS rivolto agli utenti finali, ovvero i consumatori. Tuttavia questi servizi (oltre a molti altri) sono rivolti anche alle aziende, alle quali viene vengono offerti in una forma simile a quella rivolta ai consumatori ma con la possibilità di personalizzazioni.

Non solo, infatti alcuni di questi servizi vengono offerti gratuitamente ad enti pubblici o di rilievo in cambio della pubblicità derivante dalla adesione ai servizi (ed alla raccolta di dati).

Si osserva comunque che Google è in realtà fornisce PaaS, infatti le applicazioni offerte all'utenza condividono le stesse tecnologie, che vengono messe a disposizione degli sviluppatori: questi toolkit incarnano il concetto di PaaS.

Si osserva come questo esempio metta bene in luce le limitazioni dell'approccio PaaS per gli sviluppatori, infatti un ipotetico applicativo che faccia uso dei servizi di geolocalizzazione di Google diventa dipendente da quest'ultimo.

#### IaaS e PaaS case study: Amazon AWS e Windows Azure

Il caso di studio di Amazon AWS è tra i più significativi in quanto la gamma dei servizi offerti è così estesa da poter illustrare tutti gli aspetti di IaaS e PaaS.

Storicamente il primo dei servizi offerti da Amazon Web Services è stato *Amazon Simple Storage Service* (**S3**), ovvero un sistema per la scrittura e la lettura di dati diverso dal semplice storage remoto (2006). Infatti questo servizio possedeva delle peculiarità che lo rendevano un vero esempio di PaaS. Ad esempio l'accesso ad i dati avveniva programmaticamente: ovvero all'interno di un linguaggio di programmazione tramite delle apposite librerie.

Un'altra caratteristica innovativa di S3 dispobilile fin dalla nascita del servizio era quella di richiedere che i dati venissero conservati in data center geograficamente distribuiti.

In un secondo momento è stato varate un servizio per la creazione di macchine virtuali, ovvero *Amazon Elastic Computing Cloud* (**EC2**), che rappresenta la formulazione classica di IaaS.

**Windows Azure** (in precedenza **Microsoft Azure**) è un'altro esempio di di PaaS e IaaS. Quest'ultimo si differenzia rispetto ad AWS nel fatto di essere fortemente orientato allo sviluppo di nuove applicazioni nativamente in cloud.

### Deployment and isolation models

Quanto presentato fin'ora potrebbe indurre a credere che i casi d'uso delle tecnologie di cloud computing riguardino solamente alcune grandi aziende (Amazon, Google, etc.), tuttavia non è questo il caso.

Infatti cloud computing è appunto una tecnologia ed i suoi impiegi possono essere classificati in base a 3 caratteristiche indipendenti: *service model*, *deployment model* e *isolation model*.

I servizi degli esempi precedenti (EC2, Windows Azure,...) sono infrastrutture di cloud che secondo lo standard viengono definite pubbliche, nel senso che chiunque può accedere a questi ultimi dietro compenso economico.

La caso opposto è quella di qualcuno che costruisca una infrastruttura di questo tipo per se stesso e quindi permetta l'accesso a certi utenti particolari. Benchè controintuitivo, questo genere di soluzioni viene scelto dalla gran parte delle istituzioni sia in ambito accademico che aziendale: ovvero queste istituzioni utilizzano tecnologie di cloud computing su risorse che sono completamente sotto il loro controllo.

In generale si distinguono diversi modelli di erogazione dei servizi:

1. **Public cloud:** L'utente ha diritto all'accesso di risorse di calcolo remote che sono allocate dinamicamente su richiesta da quest'ultimo, attraverso applicazioni web o API, via interntet a seguito della accensione di un contratto. Il service provider addebita all'utente una somma calcolata in base all'utilizzo delle risorse.
2. **Private cloud:** L'utente accede a risorse di calcolo remote che sono fornite da una istituzione di cui fa parte. Spesso l'adozione di queste tecnologie è il primo passaggio prima di una transizione a modelli di Public Cloud.
<!-- Le istituzioni che hanno adottato questa soluzione beneficiano delle semplificazioni intrinseche di questi sistemi rispetto alle tradizionali (*batch system*). -->
3. **Hybrid cloud:** L'utente ha accesso a risorse sia locali che remote e l'accesso a risorse remote è implementato tramite tecnologie di cloud computing. In genere queste soluzioni sfruttano le tecnologie di cloud computing per funzioni specifiche o in situazioni di carico di lavoro straordinario. Un caso ricorrente, sia in ambito aziendale che accademico, è di fare affidamento a risorse di cloud computing pubbliche in determinati periodi dell'anno ed un esempio in fisica delle alte energie è l'uso di AWS da parte di CMS. In questo modo è stato possibile affrontare richieste di calcolo particolarmente intensive e superiori alle capacità dell'esperimento, acquistando all'asta istanze di calcolo EC2 (**Spot Istances** e **Spot Fleet**), in quanto per Amazon i periodi di inattività rappresentano un costo senza profitto.
4. **Community cloud:** L'utente ha accesso a risorse remote messe a disposizione da una organizzazione di diverse istituzioni le quali collaborativamente condividono una infrastruttura comune di cloud computing. Rispetto al Public cloud le differenze consistono nel minor numero di utenti e nel sistema di addebito del servizio, invece rispetto al Private cloud è possibile partizionare i costi di implementazione e manutenzione del servizio fra le diverse istituzioni.

Per isolamento si intendono una serie di aspetti come:
- **Segmentazione delle risorse:** gli utenti devono avere pieno accesso alla quantità di risorse che gli è stata destinata e non altre
- **Protezione dei dati:** impedire l'accesso o la scrittura di dati da parte di utenti senza permessi
- **Sicurezza delle applicazioni:** impedire l'esecuzione o la modifica di applicazioni da parte di utenti senza permessi
- **Auditing:** monitoraggio degli accessi ai propri file o applicativi da parte degli utenti

ed i modelli di isolamento sono essenzialmente due:

1. Infrastrutture dedicate, con singolo utente o diversi utenti appartenenti alla stessa istituzione
2. Infrastrutture multitenant, ovvero con diversi tipi di utenti per cui l'isolamento è critico

### Considerazioni

#### Interesse nei confronti del Cloud Computing

L'interesse nei confronti di una nuova tecnologie in genere segue un andamento che si divide in diverse fasi

1. Nascita della tecnologia e repentina crescita dell'interesse
2. Picco di aspettative e massima attenzione nei confronti di quest'ultima
3. Rapida decrescita e picco negativo dell'interesse
4. Maturazione della tecnologia con una più graduale crescita dell'interesse
5. Plateau di produttività caratterizzato da un interesse stabile nel tempo

La visibilità del cloud computing ha seguito questo andamento generale ed attualmente ci troviamo nel plateau di produttività.

#### IaaS Cloud Stack più usati

Allo stato attuale esistono diversi software (toolkit) detti **IaaS Cloud Stack** per realizzare una infrastruttura di cloud computing di tipo IaaS. Alcuni di questi sono proprietari, come **WMware** e **Microsoft Hyper-V**, mentre altri sono *open source*, **OpenStack**, **Apache CloudStack** ed **OpenNebula**, ma in ogni caso si tratta di software che può essere installato e configurato su hardware di proprio controllo per implementare un cloud privato (ma che può eventualmente essere reso successivamente publico).

A differenza di quest'ultimo il software impiegato da piattaforme di cloud pubblico, come ad esempio AWS, non può essere impiegato al difuori della rispettiva piattaforma ed è accessibile solo tramite le IPA pubbliche.

#### Avvantaggiarsi delle tecnologie cloud

Deve essere chiaro che l'utilizzo delle tecnologie cloud, ad esempio in campo di calcolo scientifico, non garantisce un vantaggio: infatti **è necessario che gli applicativi utilizzati siano sviluppati in modo da approfittare delle potenzialità offerte da queste tecnologie**. In particolare questo software deve avere le seguenti caratteristiche

- **Distribuito:** capacità di eseguire istanze di codice parallelamente su macchine con memoria non condivisa
- **Immutabile:** caratteristica di non modificare (idealmente) lo stato della macchina durante la propria esecuzione. Questo permette avvantaggiarsi del calcolo distribuito potendo eseguire istanze di porzioni di codice su diverse CPU senza che queste debbano comunicare tra loro, dunque aggirando le latenze di comunicazione tra i processi.
- **Failover in app:** capacità intrinseca ed automatica di gestione di una eventuale interruzione anomala dei sottoprocessi, provvedendo meccanismi per farne partire altri
- **Scalabilità in app:** capacità di modificare automaticamente e dinamicamente la quantità di risorse utilizzate in base al carico ed alla disponibilità

#### EGI Federated Cloud

La *EGI federated cloud* è una organizzazione che riunisce istituzioni dotate di sistemi di cloud computing privati ed aggrega questi sistemi offrendo alla comunità scientifica, in europa e nel mondo, servizi di tipo IaaS come unico service provider.

Le idee dietro questo progetto internazionale sono essenzialmente l'adozione di **standard aperti** per le interfacce esposte all'utente, in modo da semplificare sia il *resource pooling* che l'integrazione con gli applicativi degli utenti, e la **implementazione eterogenea** delle infrastrutture, lasciando libertà agli enti aderenti di utilizzare le tecnologie di loro discrezione dunque semplificando la messa in opera di nuove infrastrutture o l'integrazione di quelle preesistenti.

Un aspetto interessante di questo *federated cloud* è il **catalogo delle macchine virtuali**, ovvero un elenco pubblico di piattaforme o servizi sviluppati dagli utenti e sottomessi da questi ultimi. Le macchine virtuali in questo catalogo vengono validate dalla federazione ed in questo modo è possibile per gli utenti instanziare servizi sviluppati da altri utenti in un ambiente collaborativo aperto.

## Cloud Storage

Per **cloud storage** si intende l'utilizzo di tecnologie analoghe al cloud computing (dunque on demand, self service, network access, resource pooling, rapid elasticity, measured service) per l'archiviazione di dati.

A seconda dei casi, queste tecnologie si rendono necessarie

- in relazione al cloud computing, in quanto il problema del processamento dei dati non può prescindere da quello dell'archiviazione di questi ultimi ed inoltre non è possibile utilizzare soluzioni di archiviazione tradizionali in una infrastruttura di cloud computing
- per via di necessità specifiche degli utenti, come ad esempio la necessità di archiviare grandi moli di dati in maniera semplice e trasparente o di doverle condividere.

Si individuano tre tipologie di cloud storage nel contesto di servizi di cloud computing di tipo IaaS, escludendo lo storage volatile dello spazio disco della istanza di macchine virtuali (al riavvio di una istanza le modifiche vengono perse)

- **Posix Storage:** permette, oltre che l'accesso remoto, la condivisione di file fra più host. Una semplice implementazione, per infrastrutture di piccole dimensioni e non molto complesse, può consistere anche di un solo volume NFS (*Network File System*) montato sulle macchine che devono avere accesso ai file. Tuttavia man mano che le infrastrutture scalano in dimensione diventa necessario usare file system che possano aumentare dinamicamente le proprie dimensioni e migliorare le performance sfruttando parallelamente l'hardware a disposizione.
- **Block Storage:** espone alle macchine virtuali un dispositivo di archiviazione virtuale, con una interfaccia equivalente ad un disco fisico. Quest'ultima nei sistemi UNIX consiste in un file speciale, in particolare in Linux in un *bock device file*, tramite il quale le funzionalità dei dispositivi di archiviazione sono accedute tramite le chiamate di sistema per la lettura e scrittura di file. In questo caso l'utente, proprio come nel caso di un disco fisico, può decidere come formattare ed utilizzare il dispositivo. Inoltre in genere quest'ultimo è disponibile sulla rete e condiviso da più host contemporaneamente e l'utente è in grado di gestire questi dispositivi tramite la stessa interfaccia attraverso cui amministra le macchine virtuali.
- **Object Storage:** non permette l'accesso ai dati di tipo Posix (open, seek, write, close) ma mette a disposizione una serie di IPA per l'accesso e la modifica di questi ultimi. In questo caso non è prevista una struttura a directory ma una organizzazione ad **oggetti**, file binari eventualmente provvisti di metadati, e **bucket**, contenitori in cui scrivere/leggere oggetti (ma non altri bucket, non è infatti possibile costrurire alberi di bucket ed esiste un solo livello). Oltre alle IPA è in genere possibile accedere ai file (oggetti) tramite web services sfruttando il protocollo HTTP. Un tipico caso d'uso di questa tipologia di cloud storage è la memorizzazione delle immagini delle macchine virtuali nei Market Place o negli Image Service.

### Esempi di tecnologie disponibili per il cloud storage

Nella seguente tabella sono elencati alcuni esempi di tecnologie disponibili per le varie tipologie di cloud storage

                     **Open Stack**   **Amazon**   **Others**                    
------------------   --------------   -----------  -----------------------------
 **Posix Storage**   NA               NA           GlusterFS, Lustre, GPFS, CEPH
 **Block Storage**   Cinder           EBS          CEPH, iSCSI storage           
 **Object Storage**  Swift            S3           CEPH, GlusterFSUFO            




mentre nella seguente tabella sono riassunte alcune caratteristiche delle tipologie di cloud storage per il caso particolare dello stack per il cloud computing open source **Open Stack**

### Caratteristiche di un cloud storage

Un servizio di cloud storage possiede le stesse proprietà caratterizzanti di un servizio di cloud computing, ovvero *on demand & self service*, *broad network access*, *resource pooling*, *rapid elasticity* e *measured service*. Tuttavia nel caso del cloud storage si aggiungono alcune richieste

- **High availability:** ovvero la ridondanza dei dati e la capacità dei sistemi garantire l'accesso ai dati nonostante la failure di un singolo dispositivo hardware.
- **High Level API:** possibilità di accesso ai dati, oltre che eventualmente tramite standard POSIX, anche tramite una interfaccia da remoto, standard ed universale (in genere un *web service*)

In una tecnologia di cloud storage fra gli aspetti di maggior rilievo ci sono le interfacce, ovvero il modo con cui viene esposto l'accesso ai file ai livelli di astrazione superiori.
