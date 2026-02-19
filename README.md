# ISU-Installation-Device-Report

Report ABAP IS-U per estrazione e visualizzazione integrata di dati relativi a:

- **Impianto** (EANL)
- **Contratto** (EVER)
- **Conto contrattuale** (FKKVKP / VKONT)
- **Business Partner** (BUT000 + indirizzo da BUT020/ADRC)
- **Apparecchiatura / Contatore** (EASTL → EGERH → EQUI)

Con visualizzazione in griglia SALV ottimizzata (colonne ridimensionabili automaticamente).

### Funzionalità principali

- Selezione multipla su numero impianto (`ANLAGE`)
- Recupero dati anagrafici BP (nome, cognome, indirizzo completo via + civico)
- Dati contratto e conto contrattuale
- Tipo impianto con testo descrittivo (da TE439T)
- Informazioni apparecchiatura (EQUNR + numero seriale SERNR)
- Filtro base su apparecchiatura attualmente installata (BISZEITSCH = '99991231')
- Output in ALV SALV con intestazioni personalizzate e ottimizzazione larghezza colonne

### Tabelle utilizzate

| Tabella   | Descrizione principale                  |
|-----------|-----------------------------------------|
| EANL      | Installazioni / Impianti                |
| EVER      | Contratti                               |
| FKKVKP    | Dati partner per conto contrattuale     |
| BUT000    | Business Partner header                 |
| BUT020    | Collegamento BP → indirizzo             |
| ADRC      | Indirizzi (via, civico, città, CAP)     |
| EASTL     | Installazione dispositivo in impianto   |
| EGERH     | Storico master dispositivo              |
| EQUI      | Equipment (contatore / apparecchiatura) |
| TE439T    | Testi tipo impianto                     |

### Requisiti

- Sistema SAP IS-U / EDM attivo
- Autorizzazioni su tabelle sopra indicate
- ABAP 7.40+ (per inline data, host variables @, concatenazione &&)

### Utilizzo

1. Inserire uno o più numeri impianto nel range di selezione
2. Eseguire (F8)
3. Visualizzazione griglia SALV con ottimizzazione colonne

Creato per scopi di analisi e debugging IS-U – non è un programma di produzione certificato.
