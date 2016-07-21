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
2. **Omniscence**: la conoscenza da parte di ogni istituzione/nodo dello stato di tutti gli altri.
3. **Existing Trust Relationship**: autenticazione degli individui o delle istituzioni sulla base di relazioni di fiducia preesistenti o comunque esterni alla Grid.

Il genere di problemi che una Grid cerca di risolvere è del tipo 

> Eseguire il programma X nel sito Y con permessi P, provvedendo accesso ai dati sul sito Z in accordo ai permessi Q

Riassuntivamente una Grid fornisce un livello di astrazione che rende accessibile un ambiente di calolo distribuito ad alte performance per gli utenti e che permette la condivisione di risorse per le istituzioni, in maniera trasparente ed immune da tre generi di eterogeneità:

1. delle risorse
2. delle policy
3. delle applicazioni

Si osserva che il calcolo su Grid si può definire calcolo distribuito con le seguenti precisazioni

1. Non viene condiviso solo un processo fra i nodi (dunque tempo di CPU e memoria) ma anche dati e software (in breve viene offert, in accordo ai permessi posseduti dall'utente, l'accesso ad una intera macchina)
2. L'esecuzione di un singolo job avviene su una singola macchina (o su un singolo cluster di macchine), ovvero i job sono tra loro indipendenti.



## Sottomissione di job ad una Grid

Per Grid middleware si intende una serie di componenti software che rendono possibile il calcolo su Grid. Alcuni esempi di Grid middleware sono gLite e EMI. 

Una analisi delle varie fasi dalla sottomissione di un job ad una Grid alla restituzione del output permette di analizzare i principali componenti di una Grid middleware.

Il componente di una Grid middleware con cui un utente si interfaccia è appunto detto **UI** (User Interface) e tramite quest'ultimo è infine possibile sottomettere un job, in questo contesto anche detto *gridlet*. Prima di ciò tuttavia un utente deve autenticarsi, per questo fornisce le proprie credenziali al **VOMS** (Virtual Organization Membership Service), il quale restituisce una chiave all'utente che ne garantisce l'appartenenza ad una certa organizzazione virtuale (le organizzazioni virtuali possono comprendere ad esempio i ricercatori di un certo esperimento). Tramite questa chiave l'utente può sottomettere un job al **WMS** (Workload Management System), dove viene inserito in una **coda globale**. Quest'ultimo riceve informazioni dal **Information Index** o **Information System**, che contiene un database dei nodi attualmente disponibili, delle loro policy e dei file archiviati in Grid. Tramite le informazioni ricevute dal Information Index ed una descrizione del job (sottomessa dall'utente insieme a quest'ultimo in un linguaggio detto JDL, Job Description Language), il **Resource Broker** computa il nodo più appropriato su cui eseguire il job (matchmaking). A questo punto il WMS può inoltrare il job al nodo, dove viene inserito in una **coda locale**. Una volta eseguito l'output del job viene inoltrato al WMS e finalmente all'utente.






















