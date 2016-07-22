# Principi di sicurezza

Si considerano preliminarmente alcune definizioni generali

- **Credenziali**: producono prova dell'identità dell'utente, in genere sono uno *username* ed una *password* assegnati in combinazione unica
- **Autenticazione**: verifica dell'identità dell'utente
- **Autorizzazioni** o permessi, vengono assegnati all'utente assieme alle credenziali e, a seguito della autenticazione, gli permettono o meno di eseguire operazioni su un sistema (istanziare processi, leggere o scrivere dati, etc.)
- **Confidenzialità**: capacità di inviare un messaggio che solo il destinatario possa comprendere
- **Integrità**: capacità di stabilire che un messaggio ricevuto sia identico a quello inviato dal mittente, ovvero che non vi siano state alterazioni fra l'invio e la consegna
- **autenticità e non ripudio**: rispettivamente capacità di stabilire l'identità del mittente ed impossibilità da parte di quest'ultimo di disconoscere il messaggio

## Algoritmi di crittografia simmetrica e asimmetrica

Nei sistemi informatici la confidenzialità è ottenuta crittograficamente. Il messaggio viene cifrato dal mittente utilizzando un algoritmo (noto anche al destinatario) ed una certa *chiave* mentre il destinatario lo decifra utilizzando una seconda chiave.

Storicamente i primi algoritmi crittografici erano a **chiave simmetrica**, nel senso che una chiave poteva essere ottenuta dall'altra (ad esempio perchè erano identiche). Per esempio **AES** (Advanced Encryption Standard, anche conosciuto come *Rijndael*) è un algoritmo a chiave simmetrica selezionato dal NIST (National Institute of Standards and Technology) sia perché (ad oggi) crittograficamente sicuro sia per le sue performance.

Gli algoritmi a chiave simmetrica pongono intrinsecamente dei rischi di sicurezza, indipendentemente dalla bontà degli algoritmi. Infatti perché il destinatario possa ricostruire il messaggio è *necessario che conosca la chiave*. Il mittente è pertanto costretto a comunicargliela e per fare ciò è necessario un canale di trasmissione sicuro, che però potrebbe non esistere (ovviamente non ha senso crittografare una chiave simmetrica con una chiave simmetrica perché si riporrebbe il problema).

Inoltre gli algoritmi a chiave simmetrica soffrono di un ulteriore problema. Infatti il mittente dovrà condividere una chiave differente con ogni destinatario (posto che sia interessato a trasmettere in maniera segreta con ciascun destinatario rispetto ad ogni altro destinatario). Questo comporta che il numero di chiavi (che devono essere trasmesse e conservate in maniera sicura) cresca in una rete di utenti come il quadrato del numero di questi ultimi.

Questo genere di problemi è risolto tramite l'uso di **chiavi asimmetriche**. Negli algoritmi asimmetrici esistono due chiavi, una detta **pubblica** e l'altra **privata**. La chiave pubblica è unicamente in grado di cifrare, invece la chiave privata è sia in grado di cifrare che di decifrare un messaggio cifrato utilizzando una chiave pubblica o privata. 

Tramite l'uso di algoritmi asimmetrici il destinatario può inviare (o rendere appunto pubblica) una copia della propria chiave pubblica, ma conservare la propria chiave privata, e per il mittente sarà sufficiente cifrare il messaggio utilizzando la chiave pubblica del destinatario. Una volta consegnato il messaggio il destinatario potrà decifrarlo utilizzando la propria chiave privata. 

In generale, essendo questi algoritmi computazionalmente costosi, nel caso di messaggi molto grandi si adotta usualmente la strategia di cifrare questi ultimi usando una chiave simmetrica e poi di condividere la chiave simmetrica cifrandola con un algoritmo asimmetrico.

Uno dei primi algoritmi a chiave asimmetrica ad essere scoperti (1978) ed oggi maggiormente adottati è **RSA** (da nomi dei suoi inventori Ronald Rivest, Adi Shamir e Leonard Adleman). In questo caso le chiavi consistono in genere di una coppia di file ed una *passphrase*, nota solo al proprietario della chiave privata.

L'algoritmo RSA ha inoltre la seguente utile proprietà. Si è già visto che un messaggio cifrato usando la chiave pubblica può essere decifrato utilizzando la chiave privata, tuttavia è vero anche il contrario: ovvero un messaggio cifrato utilizzando la chiave privata può essere decifrato usando la chiave pubblica.

## Firma digitale

Per **hash** o **one-way hash function** si intende una funzione $H$ (in pratica un algoritmo) che riceve una stringa di lunghezza qualsiasi $M$ e restituisce una stringa di lunghezza fissata $h$ tale che 

1. dato $M$, sia semplice (economico) calcolare $h = H(M)$
2. dato $h$, sia difficile (costoso) calcolare gli elementi di $H^{-1}(h)$
3. dato $M$, sia difficile (costoso) calcolare $M'$ tale che $H(M) = H(M')$ (ci si riferisce a questa eventualità col termine **collisione**)

Si osserva che, a differenza degli algoritmi crittografici, gli algoritmi di hashing non sono per definizione invertibili (non esiste una corrispondenza univoca fra $M$ e $h$). La conseguenza di questo fatto è che esistono certamente collisioni.

Può essere più economico, o interessante per altre ragioni, calcolare le funzioni di hash per due stringe e confrontare i risultati che confrontare direttamente le stringe di partenza. In questo caso il risultato delle funzioni di hash si chiama **checksum**. In questo caso si preferiscono funzioni di hash che abbiano la ulteriore proprietà che la probabilità di collisione sia *piccola* per stringhe di partenza *simili*.

L'integrità, l'autenticità ed il non ripudio possono essere ottenuti sfruttando le funzioni di hash e l'algoritmo RSA. In questo caso il mittente che vuole apporre la propria **firma digitale** su un messaggio (eventualmente in cifrato) calcola lo hash del messaggio, lo cifra con la sua chiave privata ed allega il risultato al messaggio. In questo modo il destinatario potrà calcolare lo hash del messaggio, decifrare tramite la chiave pubblica quello in allegato ed effettuare un confronto. 

Se i due hash coincidono il destinatario potrà dedurre che

1. Il messaggio ricevuto coincide (a meno di una collisione, eventualità con probabilità trascurabili) con quello su cui il mittente ha apportato la firma
2. Il mittente può essere solo il proprietario della chiave privata (autenticità) e quest'ultimo non può negare di aver firmato il messaggio (non ripudio)

## Certificati personali secondo lo standard X.509

Gli algoritmi a chiave asimmetrica e la firma digitale costituiscono una soluzione a certi problemi di sicurezza se sono vere alcune premesse

1. Le chiavi private degli utenti non sono compromesse
2. Gli utenti sono in grado di associare con sicurezza l'identità di altri utenti alle rispettive chiavi pubbliche (che in qualche modo devono essere state distribuite in precedenza)

Esistono due modelli per garantire la seconda di queste premesse

1. **X.509**: controllo centrale da parte di un terzo individuo (*hierarchical organization*)
2. **PGP**: sistema distribuito con relazioni fra pari (*web of trust*)

Nel secondo caso si sfrutta l'assunto che se si conosce l'identità di un utente e quest'ultimo *garantisce* sull'identità di un terzo utente, allora si può considerare (ragionevolmente) sicura l'identità di questo terzo utente, anche nel caso non fossimo in grado di stabilirne direttamente l'identità. 

Questo ragionamento si può applicare più volte ed è eventualmente possibile stabilire in questo modo una o più catene di relazioni di fiducia fra mittente e destinatario. 

In pratica in una *web of trust* un utente che sia sicuro della identità associata ad una chiave pubblica può firmarla e queste chiavi pubbliche firmate sono raccolte in database liberamente accessibili online. Software come **GPG** (GNU Privacy Guard), oltre a permettere di cifrare, decifrare e firmare messaggi, ricostruiscono automaticamente queste relazioni di fiducia in base alle chiavi pubbliche fidate nel proprio *portachiavi*.

X.509 è uno standard per PKI (Public Key Infrastructure), che permette di realizzare relazioni di fiducia tra utenti tramite un controllo centrale. 

Esistono due concetti fondamentali nello standard X.509

1. **Certification Authority** o CA
2. **Certificati digitali**

La certification authority è una terza parte la cui identità è per ipotesi fidata (*trust anchor*) che può rilasciare certificati digitali per utenti, software o calcolatori. Si occupa di verificare l'identità dei richiedenti (tramite le RA, Registration Authorities) e pubblica periodicamente un elenco dei certificati compromessi che sono ancora in periodo di validità nelle CRL (Certificate Revocation Lists).

I certificati digitali rappresentano una estensione del concetto di chiave pubblica e contengono almeno i seguenti campi

1. la chiave pubblica del proprietario del certificato
2. l'identità del proprietario (es. dati anagrafici)
3. alcune informazioni sulla CA
4. periodo di validità del certificato
5. firma digitale della CA

Il mittente in questo modo può esaminare il certificato (dopo averne ricevuto copia) ed essere sicuro della corrispondenza fra l'identità del destinatario e la sua chiave pubblica.

Per poter applicare lo schema X.509 è tuttavia necessario che un utente possieda la chiave pubblica della CA (che deve essere stata ottenuta tramite un canale sicuro perché è per ipotesi fidata). Queste chiavi vengono solitamente distribuite sotto forma di certificati, detti *root certificate*, in modo da contenere informazioni addizionali come ad esempio il periodo di validità della chiave. Inoltre i root certificate sono **self signed**, ovvero firmati dallo stessa CA, ed è pertanto possibile stabilirne l'integrità (l'autenticità è data per ipotesi).






























