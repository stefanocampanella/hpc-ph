# Principi di sicurezza

## Algoritmi di crittografia simmetrica e asimmetrica

Si considerano preliminarmente alcune definizioni generali

- **Credenziali**: producono prova dell'identità dell'utente, in genere sono uno *username* ed una *password* assegnati in combinazione unica
- **Autenticazione**: verifica dell'identità dell'utente
- **Autorizzazioni** o permessi, vengono assegnati all'utente assieme alle credenziali e, a seguito della autenticazione, gli permettono o meno di eseguire operazioni su un sistema (istanziare processi, leggere o scrivere dati, etc.)
- **Confidenzialità**: capacità di inviare un messagio che solo il destinatario possa comprendere
- **Integrità**: capacità di stabilire che un messaggio ricevuto sia identico a quello inviato dal mittente, ovvero che non vi siano state alterazioni fra l'invio e la consegna
- **autenticità e non ripudio**: rispettivamente capacità di stabilire l'identità del mittente ed impossibilità da parte di quest'ultimo di disconoscere il messaggio

Nei sistemi informatici odierni la confidenzialità è ottenuta modificando il contenuto del messaggio in modo che questo sia incomprensibile ad altri che non siano il destinatario, che dovrà riconvertire il messaggio in forma leggibile.
